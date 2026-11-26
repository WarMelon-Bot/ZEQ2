/*
===========================================================================
Copyright (C) 1999-2005 Id Software, Inc.

This file is part of Quake III Arena source code.

Quake III Arena source code is free software; you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation; either version 2 of the License,
or (at your option) any later version.

Quake III Arena source code is distributed in the hope that it will be
useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Quake III Arena source code; if not, write to the Free Software
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
===========================================================================
*/
// bg_pmmove.c -- movement state machine

#include "../../Shared/q_shared.h"
#include "bg_public.h"
#include "bg_local.h"
#include "bg_userweapons.h"
#include "g_tiers.h"

// Boost/dash/movement-type helpers.

void PM_CheckHover(void){
	if(VectorLength(pm->ps->velocity) && pm->ps->bitFlags & usingFlight){
		if(pm->cmd.buttons & BUTTON_WALKING){
			if(!(pm->ps->states & isHovering)){
				pm->ps->states |= isHovering;
				PM_AddEvent(EV_HOVER);
			}
		}else{
			if(!(pm->ps->states & isDashing)){
				pm->ps->states |= isDashing;
				//PM_AddEvent(EV_HOVER_FAST);
			}
		}
	}
	else{
		pm->ps->states &= ~isDashing;
		pm->ps->states &= ~isHovering;
	}
}
/*===============
BOOST TYPES
===============*/
void PM_StopBoost(void){
	pm->ps->bitFlags &= ~usingBoost;
	pm->ps->powerups[PW_BOOST] = 0;
	pm->ps->timers[tmBoost] = 0;
}
void PM_StopDash(void){
	VectorClear(pm->ps->dashDir);
}
void PM_StopMovementTypes(void){
	PM_StopDash();
	PM_StopJump();
	PM_StopSoar();
	PM_StopZanzoken();
	PM_StopKnockback();
	//PM_EndDrift();
}
void PM_StopMovement(void){
	PM_StopMovementTypes();
	VectorClear(pm->ps->velocity);
}
void PM_CheckBoost(void){
	int limit;
	limit = pm->ps->powerLevel[plLimit];
	if(!(pm->ps->states & canBoost && !(pm->ps->bitFlags & isStruggling))){return;}
	if(!(pm->cmd.buttons & BUTTON_BOOST)){
		PM_StopBoost();
	}
	else if(pm->ps->powerups[PW_BOOST]){
		pm->ps->eFlags |= EF_AURA;
		pm->ps->powerups[PW_BOOST] += pml.msec;
		pm->ps->timers[tmBoost] += pml.msec;
		if(pm->ps->timers[tmBoost] > limit){pm->ps->timers[tmBoost] = limit;}
		if(pm->ps->powerups[PW_BOOST] > 150){
			pm->ps->powerLevel[plUseFatigue] += (pm->ps->powerLevel[plMaximum] * 0.003) * pm->ps->baseStats[stBoostCost];
			pm->ps->powerups[PW_BOOST] -= 150;
		}
	}
	else{
		pm->ps->timers[tmBoost] = 0;
		pm->ps->powerups[PW_BOOST] = 1;
		if(!(pm->ps->bitFlags & usingBoost)){PM_AddEvent(EV_BOOST_START);}
		pm->ps->bitFlags |= usingBoost;
	}
}
// Velocity clipping, friction and acceleration.

/*
==================
PM_ClipVelocity

Slide off of the impacting surface
==================
*/
void PM_ClipVelocity(vec3_t in, vec3_t normal, vec3_t out, float overbounce){
	float	backoff;
	float	change;
	int		i;
	backoff = DotProduct (in, normal);
	if(backoff < 0){
		backoff *= overbounce;
	} else{
		backoff /= overbounce;
	}
	for (i=0 ; i<3 ; i++){
		change = normal[i]*backoff;
		out[i] = in[i] - change;
	}
}


/*==================
PM_Friction
==================*/
void PM_Friction(void){
	float speed,newspeed,control,drop;
	drop = 0;
	speed = VectorLength(pm->ps->velocity);
	if(speed < 5){
		PM_StopDash();
		VectorClear(pm->ps->velocity);
		return;
	}
	if(pm->waterlevel){
		drop += speed*pm_waterfriction*pm->waterlevel*pml.frametime;
	}
	if(pm->ps->bitFlags & usingFlight || pml.onGround){
		control = speed < pm_stopspeed ? pm_stopspeed : speed;
		drop += control*pm_friction*pml.frametime;
	}
	/*
	if(pm->ps->timers[tmKnockback] > 0){
		if(!(pm->ps->pm_flags & PMF_TIME_KNOCKBACK)){
			drop = speed*20*pml.frametime;
		} else {
			drop = speed*pml.frametime;
		}
	}*/
	newspeed = speed - drop;
	if(newspeed < 0) {newspeed = 0;}
	newspeed /= speed;
	pm->ps->velocity[0] *= newspeed;
	pm->ps->velocity[1] *= newspeed;
	pm->ps->velocity[2] *= newspeed;
}
/*==============
PM_Accelerate
==============*/
void PM_Accelerate(vec3_t wishdir, float wishspeed, float accel){
#if 1
	// q2 style
	int			i;
	float		addspeed, accelspeed, currentspeed;

	// clamp the speed lower if wading or moving underwater.
	if(pm->waterlevel){
		float waterScale;
		pm->ps->bitFlags |= underWater;
		waterScale = 1.0f - (1.0f - pm_swimScale)* (float)pm->waterlevel / 3.0f;
		wishspeed = wishspeed * waterScale;
	}
	else{
		pm->ps->bitFlags &= ~underWater;
	}
	currentspeed = DotProduct (pm->ps->velocity, wishdir);
	addspeed = wishspeed - currentspeed;
	if(addspeed <= 0) {
		return;
	}
	accelspeed = accel*pml.frametime*wishspeed;
	if(accelspeed > addspeed) {
		accelspeed = addspeed;
	}

	for (i=0 ; i<3 ; i++) {
		pm->ps->velocity[i] += accelspeed*wishdir[i];
	}

#else
	// proper way (avoids strafe jump maxspeed bug), but feels bad
	vec3_t		wishVelocity;
	vec3_t		pushDir;
	float		pushLen;
	float		canPush;

	VectorScale(wishdir, wishspeed, wishVelocity );
	VectorSubtract(wishVelocity, pm->ps->velocity, pushDir );
	pushLen = VectorNormalize(pushDir );

	canPush = accel*pml.frametime*wishspeed;
	if(canPush > pushLen) {
		canPush = pushLen;
	}

	VectorMA(pm->ps->velocity, canPush, pushDir, pm->ps->velocity );
#endif
}



/*
============
PM_CmdScale

Returns the scale factor to apply to cmd movements
This allows the clients to use axial -127 to 127 values for all directions
without getting a sqrt(2) distortion in speed.
============
*/
float PM_CmdScale(usercmd_t *cmd){
	int		max;
	int		totalSpeed;
	float	total;
	float	scale;

	max = abs(cmd->forwardmove );
	if(abs(cmd->rightmove)> max){
		max = abs(cmd->rightmove );
	}
	if(abs(cmd->upmove)> max){
		max = abs(cmd->upmove );
	}
	if(!max){
		return 0;
	}
	total = sqrt(cmd->forwardmove * cmd->forwardmove + cmd->rightmove * cmd->rightmove + cmd->upmove * cmd->upmove );
	totalSpeed = (pm->ps->powerLevel[plFatigue] / 72.81) + pm->ps->stats[stSpeed];
	if(pm->ps->powerups[PW_DRIFTING] > 0){
		totalSpeed = 500;
		if(pm->ps->lockedPlayer->timers[tmMeleeIdle] > 1500 && pm->ps->timers[tmMeleeIdle] > 1500){totalSpeed = 1500;}
	}
	if(pm->ps->timers[tmMeleeIdle] < 0){totalSpeed = 4000;}
	scale = (float)totalSpeed * max / (127.0 * total );
	return scale;
}
/*=============
PM_CheckJump
=============*/

// Jump handling.

void PM_NotOnGround(void){
	pml.groundPlane = qfalse;
	pml.onGround = qfalse;
	pm->ps->bitFlags &= ~atopGround;
	pm->ps->groundEntityNum = ENTITYNUM_NONE;
}
void PM_StopJump(void){
	if(pm->ps->bitFlags & usingJump){
		pm->ps->bitFlags &= ~usingJump;
		VectorScale(pm->ps->velocity,0.01,pm->ps->velocity);
	}
	if(pm->ps->bitFlags & usingBallFlip){
		pm->ps->bitFlags &= ~usingBallFlip;
		PM_AddEvent(EV_STOPLOOPINGSOUND);
	}
}
void PM_CheckJump(void){
	int jumpPower;
	vec3_t post_vel;
	if(!(pm->ps->states & canJump)){return;}
	if(pm->ps->bitFlags & usingBallFlip){return;}
	if(pm->ps->bitFlags & usingJump){
		if(pm->ps->bitFlags & nearGround && pm->ps->velocity[2] < 0){
			PM_ContinueLegsAnim(ANIM_FLY_DOWN);
		}
		else if(pm->ps->velocity[2] < 200){
			if(pm->ps->pm_flags & PMF_BACKWARDS_JUMP){PM_ForceLegsAnim(ANIM_LAND_BACK);}
			else if(pm->ps->pm_flags & PMF_FORWARDS_JUMP){PM_ForceLegsAnim(ANIM_LAND_UP);}
			else{PM_ForceLegsAnim(ANIM_LAND_UP);}
		}
		return;
	}	
	if(pm->ps->bitFlags & usingAlter || pm->ps->bitFlags & usingFlight
		|| pm->ps->bitFlags & isStruggling || (!(pm->ps->bitFlags & atopGround && !(pm->waterlevel)))){return;}
	if(!(pm->cmd.buttons & BUTTON_JUMP) || pm->cmd.upmove < 0 || pm->ps->weaponstate == WEAPON_GUIDING){return;}
	PM_NotOnGround();
	PM_StopDash();
	pm->ps->bitFlags |= usingJump;
	jumpPower = pm->ps->stats[stSpeed];
	pm->ps->gravity[2] = 12000;
	pm->ps->velocity[2] = 0;
	VectorNormalize(pm->ps->velocity);
	VectorScale(pm->ps->velocity,2500.0,pm->ps->velocity);
	VectorNormalize2(pm->ps->velocity,post_vel);
	if((pm->cmd.forwardmove != 0) || (pm->cmd.rightmove != 0)){
		pm->ps->velocity[2] = jumpPower * 6;
		pm->ps->powerLevel[plUseFatigue] += pm->ps->powerLevel[plMaximum] * 0.01;
		PM_AddEvent(EV_HIGHJUMP);
	} else{
		pm->ps->gravity[2] = 6000;
		pm->ps->velocity[2] = jumpPower * 8;
		pm->ps->powerLevel[plUseFatigue] += pm->ps->powerLevel[plMaximum] * 0.06;
		PM_AddEvent(EV_JUMP);
	}
	if(pm->cmd.forwardmove > 0){
		PM_ForceLegsAnim(ANIM_JUMP_UP);
		pm->ps->pm_flags |= PMF_FORWARDS_JUMP;
		pm->ps->pm_flags &= ~PMF_BACKWARDS_JUMP;
	}else if(pm->cmd.forwardmove < 0 || pm->ps->pm_flags & PMF_BACKWARDS_JUMP){
		PM_ForceLegsAnim(ANIM_JUMP_BACK);
		pm->ps->pm_flags |= PMF_BACKWARDS_JUMP;
		pm->ps->pm_flags &= ~PMF_FORWARDS_JUMP;
	}
	else{
		PM_ForceLegsAnim(ANIM_JUMP_UP);
		pm->ps->pm_flags &= ~PMF_BACKWARDS_JUMP;
		pm->ps->pm_flags &= ~PMF_FORWARDS_JUMP;
	}
}

// Movement modes, ground traces, footsteps and water events.

/*===================
PM_FlyMove
===================*/
void PM_StopSoar(void){
	pm->ps->bitFlags &= ~isPreparing;
	pm->ps->bitFlags &= ~usingSoar;
	pm->ps->bitFlags &= ~lockedRoll;
	pm->ps->bitFlags &= ~lockedPitch;
	pm->ps->bitFlags &= ~lockedYaw;
	pm->ps->bitFlags &= ~locked360;
}
void PM_StopFlight(void){
	pm->ps->bitFlags &= ~usingFlight;
}
void PM_FlyMove(void){
	int		i;
	vec3_t	wishvel;
	vec3_t	wishdir;
	float	soarCost;
	float	wishspeed;
	float	fadeSpeed;
	float	scale;
	float	boostFactor;
	if(!(pm->ps->states & canFly)){return;}
	if(pm->cmd.upmove > 0){
		pm->ps->bitFlags |= usingFlight;
		PM_StopDash();
		PM_StopJump();
	}
	if(pm->cmd.buttons & BUTTON_POWERLEVEL && !VectorLength(pm->ps->velocity)){return;}
	if(!(pm->ps->bitFlags & usingFlight) ||(pm->cmd.buttons & BUTTON_POWERLEVEL && !VectorLength(pm->ps->velocity))){return;}
	boostFactor = pm->ps->bitFlags & usingBoost ? 4.4 : 1.1;
	if(pm->cmd.buttons & BUTTON_WALKING){
		boostFactor = 1.0;
	}
	if((pm->cmd.buttons & BUTTON_JUMP &&
		!(pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING) && 
		!(pm->ps->weaponstate == WEAPON_GUIDING || pm->ps->weaponstate == WEAPON_ALTGUIDING) && 
		!(pm->ps->bitFlags & usingZanzoken)) ||
		(pm->ps->bitFlags & lockedPitch || pm->ps->bitFlags & lockedYaw || pm->ps->bitFlags & lockedRoll)){
		if(pm->ps->bitFlags & usingJump){return;}
		//if(PM_CheckDirection(pml.forward,qfalse)){PM_Crash(qtrue);}
		pm->ps->timers[tmSoar] += pml.msec;
		pm->ps->eFlags |= EF_AURA;
		if(pm->cmd.buttons & BUTTON_POWERLEVEL){pm->cmd.forwardmove = 0;}
		if(!(pm->ps->bitFlags & usingSoar)){
			pm->cmd.upmove = pm->cmd.rightmove = pm->cmd.forwardmove = 0;
			pm->ps->bitFlags |= isPreparing;
			pm->ps->soarBase[YAW] = pm->ps->soarLimit[YAW] = pm->ps->viewangles[YAW];
			pm->ps->soarBase[ROLL] = pm->ps->soarLimit[ROLL] = 0.0;
			pm->ps->soarBase[PITCH] = pm->ps->soarLimit[PITCH] = 0.0;
			pm->ps->viewangles[PITCH] = 0.0;
			if(pm->ps->timers[tmSoar] < 700){return;}
			pm->ps->bitFlags |= usingSoar;
			pm->ps->bitFlags &= ~isPreparing;
			pm->ps->timers[tmSoar] = 0;
		}
		soarCost = 0;
		if(pm->ps->powerLevel[plMaximum] * 0.8 > pm->ps->powerLevel[plFatigue]){
			soarCost = pm->ps->powerLevel[plMaximum] * 0.001;
		}
		boostFactor = 5.8;
		pm->ps->viewangles[PITCH] = pm->ps->soarBase[PITCH];
		pm->ps->viewangles[YAW] = pm->ps->soarBase[YAW];
		pm->ps->viewangles[ROLL] = pm->ps->soarBase[ROLL];
		if(pm->cmd.upmove != 0){
			if(pm->cmd.upmove < 0){pm->ps->soarLimit[PITCH] = 360.0;}
			else if(pm->cmd.upmove > 0){pm->ps->soarLimit[PITCH] = -360.0;}
			pm->ps->bitFlags |= locked360;
		}
		if(pm->cmd.forwardmove != 0){
			if(pm->cmd.forwardmove < 0){pm->ps->soarLimit[PITCH] += 2.0;}
			else if(pm->cmd.forwardmove > 0){pm->ps->soarLimit[PITCH] += -2.0;}
			pm->ps->bitFlags |= lockedPitch;
		}
		if(pm->cmd.rightmove != 0){
			if(pm->cmd.rightmove < 0){
				if(!(pm->ps->bitFlags & lockedRoll) && !(pm->ps->bitFlags & lockedSpin) && pm->ps->soarLimit[ROLL] > -20){
					pm->ps->soarLimit[ROLL] -= 2;
				}
				pm->ps->soarLimit[YAW] += 2.0;
			}
			else if(pm->cmd.rightmove > 0){
				if(!(pm->ps->bitFlags & lockedRoll) && !(pm->ps->bitFlags & lockedSpin) && pm->ps->soarLimit[ROLL] < 20){
					pm->ps->soarLimit[ROLL] += 2;
				}
				pm->ps->soarLimit[YAW] -= 2.0;
			}
			pm->ps->bitFlags |= lockedYaw;
			pm->ps->bitFlags |= lockedRoll;
		}
		if(pm->cmd.buttons & BUTTON_BOOST){
			if(soarCost){soarCost = pm->ps->powerLevel[plMaximum] * 0.002;}
			boostFactor *= 1.5;
		}
		if(pm->cmd.buttons & BUTTON_ROLL_RIGHT || pm->cmd.buttons & BUTTON_ROLL_LEFT){
			if(pm->cmd.buttons & BUTTON_ROLL_RIGHT){pm->ps->soarLimit[ROLL] = 360;}
			else if(pm->cmd.buttons & BUTTON_ROLL_LEFT){pm->ps->soarLimit[ROLL] = -360;}
			pm->ps->bitFlags |= lockedSpin;
		}
		fadeSpeed = 2.0;
		while(pm->ps->timers[tmSoar] > 10){
			if(pm->ps->bitFlags & lockedPitch || pm->ps->bitFlags & locked360){
				if(pm->ps->bitFlags & locked360){fadeSpeed = 4;}
				if(pm->ps->soarBase[PITCH] > 180){
					pm->ps->soarBase[PITCH] = pm->ps->bitFlags & locked360 ? -184 : -182;
					pm->ps->soarLimit[PITCH] = 0;
				}
				else if(pm->ps->soarBase[PITCH] < -180){
					pm->ps->soarBase[PITCH] = pm->ps->bitFlags & locked360 ? 184 : 182;
					pm->ps->soarLimit[PITCH] = 0;
				}
				if(pm->ps->soarBase[PITCH] > pm->ps->soarLimit[PITCH]){pm->ps->soarBase[PITCH] -= fadeSpeed;}
				else if(pm->ps->soarBase[PITCH] < pm->ps->soarLimit[PITCH]){pm->ps->soarBase[PITCH] += fadeSpeed;}
				else{
					pm->ps->bitFlags &= ~lockedPitch;
					pm->ps->bitFlags &= ~locked360;
				}
			}
			if(pm->ps->bitFlags & lockedYaw){
				if(pm->ps->soarBase[YAW] > pm->ps->soarLimit[YAW]){pm->ps->soarBase[YAW] -= fadeSpeed;}
				else if(pm->ps->soarBase[YAW] < pm->ps->soarLimit[YAW]){pm->ps->soarBase[YAW] += fadeSpeed;}
				else{pm->ps->bitFlags &= ~lockedYaw;}
			}
			if(pm->ps->bitFlags & lockedRoll || pm->ps->bitFlags & lockedSpin){
				boostFactor *= 1.2;
				if(pm->ps->bitFlags & lockedSpin){fadeSpeed = 4;}
				if(pm->ps->soarBase[ROLL] > 180){
					pm->ps->soarBase[ROLL] = pm->ps->bitFlags & lockedSpin ? -184 : -182;
					pm->ps->soarLimit[ROLL] = 0;
				}
				else if(pm->ps->soarBase[ROLL] < -180){
					pm->ps->soarBase[ROLL] = pm->ps->bitFlags & lockedSpin ? 184 : 182;
					pm->ps->soarLimit[ROLL] = 0;
				}
				if(pm->ps->soarBase[ROLL] > pm->ps->soarLimit[ROLL]){pm->ps->soarBase[ROLL] -= fadeSpeed;}
				else if(pm->ps->soarBase[ROLL] < pm->ps->soarLimit[ROLL]){pm->ps->soarBase[ROLL] += fadeSpeed;}
				else{
					pm->ps->bitFlags &= ~lockedRoll;
					pm->ps->bitFlags &= ~lockedSpin;
				}
			}
			pm->ps->timers[tmSoar] -= 10;
			pm->ps->powerLevel[plUseFatigue] +=	soarCost;
		}
		pm->cmd.upmove = 0;
		pm->cmd.rightmove = 0;
		pm->cmd.forwardmove = 127;
	}
	else if(pm->ps->bitFlags & usingSoar || pm->ps->bitFlags & isPreparing){
		pm->ps->timers[tmFreeze] = 1000;
		pm->ps->bitFlags &= ~usingSoar;
		pm->ps->bitFlags &= ~isPreparing;
		pm->ps->eFlags &= ~EF_AURA;
	}
	else{
		/*
		pm->ps->viewangles[ROLL] = pm->ps->soarBase[ROLL];
		if(pm->cmd.buttons & BUTTON_ROLL_LEFT){pm->ps->soarBase[ROLL] -= 3;}
		if(pm->cmd.buttons & BUTTON_ROLL_RIGHT){pm->ps->soarBase[ROLL] += 3;}
		*/
	}
	scale = PM_CmdScale(&pm->cmd) * boostFactor;
	if(!scale){
		wishvel[0] = 0;
		wishvel[1] = 0;
		wishvel[2] = 0;
	}
	else{
		for(i=0 ;i<3;i++){
			wishvel[i] = scale * pml.forward[i] * pm->cmd.forwardmove + scale * pml.right[i] * pm->cmd.rightmove + scale * pml.up[i] * pm->cmd.upmove;
		}
	}
	VectorCopy(wishvel, wishdir);
	wishspeed = VectorNormalize(wishdir);
	PM_Accelerate(wishdir,wishspeed,pm_flyaccelerate);
}


/*===================
PM_AirMove
===================*/
void PM_AirMove(void){
	int			i,backupDrift;
	vec3_t		wishvel;
	float		fmove, smove;
	vec3_t		wishdir;
	qboolean	gravity;
	float		wishspeed;
	float		scale;
	usercmd_t	cmd;
	backupDrift = pm->cmd.forwardmove;
	if((!pm->ps->powerups[PW_DRIFTING] && pm->ps->timers[tmMeleeIdle] >= 0) && (pml.onGround
		|| ((pm->cmd.buttons & BUTTON_POWERLEVEL && !VectorLength(pm->ps->velocity))
		&& !(pm->ps->bitFlags & isUnconcious) && !(pm->ps->bitFlags & isDead) && !(pm->ps->bitFlags & isCrashed)))){return;}
	if(pm->ps->bitFlags & isGuiding){return;}
	if(!(pm->ps->bitFlags & usingFlight)){
		if((pm->ps->states & canBallFlip)){
			if(pm->ps->bitFlags & usingJump && pm->cmd.upmove < 0){
				pm->ps->gravity[2] = 3000;
				pm->ps->bitFlags |= usingBallFlip;
				PM_AddEvent(EV_BALLFLIP);
				if(pm->ps->bitFlags & nearGround && pm->ps->velocity[2] < 0){PM_ContinueLegsAnim(ANIM_FLY_DOWN);}
				else{PM_ContinueLegsAnim(ANIM_JUMP_FORWARD);}
			}
			else if(pm->ps->bitFlags & usingJump && pm->ps->bitFlags & usingBallFlip && pm->cmd.upmove == 0){
				pm->ps->gravity[2] = 6000;
				pm->ps->bitFlags &= ~usingBallFlip;
				PM_AddEvent(EV_STOPLOOPINGSOUND);
			}
			if(pm->ps->bitFlags & usingBallFlip){PM_StopDirections();}
		}
	}
	if(pm->ps->timers[tmMeleeIdle] < 0){
		PM_StopDirections();
		pm->cmd.forwardmove = -127;
		pm->ps->timers[tmMeleeIdle] += pml.msec;
		if(pm->ps->timers[tmMeleeIdle] > 0){pm->ps->timers[tmMeleeIdle] = 0;}
	}
	if(pm->ps->bitFlags & usingMelee){
		PM_StopDirections();
		if(pm->ps->powerups[PW_DRIFTING] == 1){pm->cmd.forwardmove = 127;}
		else if(pm->ps->powerups[PW_DRIFTING] == 2){pm->cmd.forwardmove = -127;}
	}
	fmove = pm->cmd.forwardmove;
	smove = pm->cmd.rightmove;
	cmd = pm->cmd;
	scale = PM_CmdScale(&cmd);
	pml.forward[2] = 0;
	pml.right[2] = 0;
	VectorNormalize(pml.forward);
	VectorNormalize(pml.right);
	for(i = 0 ; i < 2 ; i++){
		wishvel[i] = pml.forward[i]*fmove + pml.right[i]*smove;
	}
	wishvel[2] = 0;
	VectorCopy (wishvel, wishdir);
	wishspeed = VectorNormalize(wishdir);
	wishspeed *= scale;
	PM_Accelerate (wishdir, wishspeed, pm_airaccelerate);
	if(pml.groundPlane){
		PM_ClipVelocity(pm->ps->velocity, pml.groundTrace.plane.normal,pm->ps->velocity, OVERCLIP);
	}
	if(pm->waterlevel == 3){
		pm->ps->velocity[2] += 0.7f * pm->ps->gravity[2] * pml.frametime;
	}
	gravity = pm->ps->bitFlags & usingFlight ? qfalse : qtrue;
	if(pm->ps->bitFlags & usingZanzoken){
		if(pm->ps->bitFlags & usingJump){gravity = qtrue;}
		pm->tracemask = CONTENTS_SOLID;
	}
	PM_StepSlideMove(gravity); 
	if(pm->ps->bitFlags & usingZanzoken){pm->tracemask = MASK_PLAYERSOLID;}
	if(pm->ps->bitFlags & usingMelee){
		PM_StopDirections();
	}
	pm->cmd.forwardmove = backupDrift;
}
/*===================
PM_WalkMove
===================*/
void PM_WalkMove(void){
	int			i;
	vec3_t		wishvel;
	float		fmove, smove;
	vec3_t		wishdir;
	float		wishspeed;
	float		scale;
	usercmd_t	cmd;
	float		accelerate;
	float		vel;
	if(pm->ps->bitFlags & usingFlight){return;}
	if(pm->cmd.buttons & BUTTON_POWERLEVEL && !VectorLength(pm->ps->velocity)){return;}
	if(!pml.onGround || VectorLength(pm->ps->dashDir)){return;}
	fmove = pm->cmd.forwardmove;
	smove = pm->cmd.rightmove;
	cmd = pm->cmd;
	scale = PM_CmdScale(&cmd) * 2.5;
	// set the movementDir so clients can rotate the legs for strafing
	pml.forward[2] = 0;
	pml.right[2] = 0;
	PM_ClipVelocity (pml.forward, pml.groundTrace.plane.normal, pml.forward, OVERCLIP );
	PM_ClipVelocity (pml.right, pml.groundTrace.plane.normal, pml.right, OVERCLIP );
	VectorNormalize (pml.forward);
	VectorNormalize (pml.right);
	for (i = 0 ; i < 3 ; i++){
		wishvel[i] = pml.forward[i]*fmove + pml.right[i]*smove;
	}
	VectorCopy (wishvel, wishdir);
	wishspeed = VectorNormalize(wishdir);
	wishspeed *= scale * 0.60f;
	accelerate = pm_accelerate;
	PM_Accelerate (wishdir, wishspeed,accelerate);
	vel = VectorLength(pm->ps->velocity);
	PM_ClipVelocity(pm->ps->velocity, pml.groundTrace.plane.normal,pm->ps->velocity, OVERCLIP );
	VectorNormalize(pm->ps->velocity);
	VectorScale(pm->ps->velocity, vel, pm->ps->velocity);
	if(!pm->ps->velocity[0] && !pm->ps->velocity[1]) {
		return;
	}
	if(pm->waterlevel == 3){
		pm->ps->velocity[2] += 0.7f * pm->ps->gravity[2] * pml.frametime;
	}
	PM_StepSlideMove(qfalse);
}
/*=============
PM_DashMove
=============*/
void PM_DashMove(void){
	int			i;
	vec3_t		wishvel;
	vec3_t		wishdir;
	float		fmove,smove;
	float		wishspeed;
	float		scale;
	float		dashAmount;
	float		boostFactor;
	float		accelerate;
	usercmd_t	cmd;
	dashAmount = VectorLength(pm->ps->dashDir);
	if(pm->cmd.buttons & BUTTON_POWERLEVEL && !VectorLength(pm->ps->velocity)){return;}
	if((pml.onGround && !(pm->cmd.buttons & BUTTON_WALKING) && (pm->cmd.forwardmove || pm->cmd.rightmove))){
		pm->cmd.upmove = 0;
		boostFactor = pm->ps->bitFlags & usingBoost ? 4.4 : 1.1;
		if(dashAmount == 0){
			pm->ps->dashDir[0] = 0;
			pm->ps->dashDir[1] = 0;
			if(pm->cmd.forwardmove > 0){
				pm->ps->dashDir[0] = 1;
				pm->cmd.forwardmove = 127;
			}else if(pm->cmd.forwardmove < 0){
				pm->ps->dashDir[0] = -1;
				pm->cmd.forwardmove = -127;
			}
			if(pm->cmd.rightmove > 0){
				pm->ps->dashDir[1] = 1;
				pm->cmd.rightmove = 127;
			}else if(pm->cmd.rightmove < 0){
				pm->ps->dashDir[1] = -1;
				pm->cmd.rightmove = -127;
			}
		}
		cmd = pm->cmd;
		fmove = pm->cmd.forwardmove;
		smove = pm->cmd.rightmove;
		scale = PM_CmdScale(&cmd) * boostFactor;
		pml.forward[2] = 0;
		pml.right[2] = 0;
		VectorNormalize(pml.forward);
		VectorNormalize(pml.right);
		for(i=0;i<2;i++){
			wishvel[i] = pml.forward[i]*fmove + pml.right[i]*smove;
		}
		wishvel[2] = 0;
		VectorCopy (wishvel, wishdir);
		wishspeed = VectorNormalize(wishdir);
		wishspeed *= scale;
		accelerate = pm_dashaccelerate;
		PM_Accelerate(wishdir,wishspeed,accelerate);
		if(pml.groundPlane){
			PM_ClipVelocity(pm->ps->velocity,pml.groundTrace.plane.normal,pm->ps->velocity,OVERCLIP);
		}
		if(pm->waterlevel == 3){
			pm->ps->velocity[2] += 0.7f * pm->ps->gravity[2] * pml.frametime;
		}
		PM_StepSlideMove(qtrue);
	}
	else{	
		PM_StopDash();
	}
}
/*===============
PM_NoclipMove
===============*/
void PM_NoclipMove(void){
	float	speed, drop, friction, control, newspeed;
	int			i;
	vec3_t		wishvel;
	float		fmove, smove;
	vec3_t		wishdir;
	float		wishspeed;
	float		scale;

	pm->ps->viewheight = DEFAULT_VIEWHEIGHT;

	// friction

	speed = VectorLength (pm->ps->velocity);
	if(speed < 1){
		VectorCopy (vec3_origin, pm->ps->velocity);
	}
	else
	{
		drop = 0;

		friction = pm_friction*1.5;	// extra friction
		control = speed < pm_stopspeed ? pm_stopspeed : speed;
		drop += control*friction*pml.frametime;

		// scale the velocity
		newspeed = speed - drop;
		if(newspeed < 0)
			newspeed = 0;
		newspeed /= speed;

		VectorScale (pm->ps->velocity, newspeed, pm->ps->velocity);
	}

	// accelerate
	scale = PM_CmdScale(&pm->cmd );

	fmove = pm->cmd.forwardmove;
	smove = pm->cmd.rightmove;

	for (i=0 ; i<3 ; i++)
		wishvel[i] = pml.forward[i]*fmove + pml.right[i]*smove;
	wishvel[2] += pm->cmd.upmove;

	VectorCopy (wishvel, wishdir);
	wishspeed = VectorNormalize(wishdir);
	wishspeed *= scale;

	PM_Accelerate(wishdir, wishspeed, pm_accelerate );

	// move
	VectorMA (pm->ps->origin, pml.frametime, pm->ps->velocity, pm->ps->origin);
}
/*================
PM_FootstepForSurface
================*/
int PM_FootstepForSurface(void){
	if(pml.groundTrace.surfaceFlags & SURF_NOSTEPS){
		return 0;
	}
	if(pml.groundTrace.surfaceFlags & SURF_METALSTEPS){
		return EV_FOOTSTEP_METAL;
	}
	return EV_FOOTSTEP;
}
/*=================
PM_Land
=================*/
void PM_Land(void){
	float		delta;
	float		dist;
	float		vel, acc;
	float		t;
	float		a, b, c, den;
	pm->ps->legsTimer = TIMER_LAND;
	// calculate the exact velocity on landing
	dist = pm->ps->origin[2] - pml.previous_origin[2];
	vel = pml.previous_velocity[2];
	acc = -pm->ps->gravity[2];

	a = acc / 2;
	b = vel;
	c = -dist;

	den =  b * b - 4 * a * c;
	if(den < 0){
		return;
	}
	t = (-b - sqrt(den)) / (2 * a );

	delta = vel + t * acc;
	delta = delta*delta * 0.0001;
	// reduce falling damage ifthere is standing water
	if(pm->waterlevel == 2){
		delta *= 0.25;
	}
	if(pm->waterlevel == 1){
		delta *= 0.5;
	}

	if(delta < 1){
		return;
	}
	// start footstep cycle over
	pm->ps->bobCycle = 0;
}
/*
=============
PM_CorrectAllSolid
=============
*/
int PM_CorrectAllSolid(trace_t *trace){
	int			i, j, k;
	vec3_t		point;
	// jitter around
	for (i = -1; i <= 1; i++) {
		for (j = -1; j <= 1; j++) {
			for (k = -1; k <= 1; k++) {
				VectorCopy(pm->ps->origin, point);
				point[0] += (float) i;
				point[1] += (float) j;
				point[2] += (float) k;
				pm->trace (trace, point, pm->mins, pm->maxs, point, pm->ps->clientNum, pm->tracemask);
				if(!trace->allsolid){
					point[0] = pm->ps->origin[0];
					point[1] = pm->ps->origin[1];
					point[2] = pm->ps->origin[2] - 0.25;

					pm->trace (trace, pm->ps->origin, pm->mins, pm->maxs, point, pm->ps->clientNum, pm->tracemask);
					pml.groundTrace = *trace;
					return qtrue;
				}
			}
		}
	}
	PM_NotOnGround();
	return qfalse;
}
/*
=============
PM_GroundTraceMissed

The ground trace didn't hit a surface, so we are in freefall
=============
*/
int PM_CheckDirection(vec3_t direction,qboolean player){
	vec3_t	point;
	trace_t	trace;
	int flags = pm->tracemask &~ CONTENTS_BODY;
	VectorMA(pm->ps->origin,64,direction,point);
	if(player){flags = CONTENTS_BODY;}
	pm->trace(&trace,pm->ps->origin,pm->mins,pm->maxs,point,pm->ps->clientNum,flags);
	if(trace.allsolid && (!PM_CorrectAllSolid(&trace))){return 0;}
	if(trace.fraction == 1.0){
		return 0;
	}
	if(player){return trace.entityNum+1;}
	return 1;
}
void PM_GroundTraceMissed(void){
	trace_t		trace;
	vec3_t		point;
	if(pm->ps->groundEntityNum != ENTITYNUM_NONE){
		VectorCopy(pm->ps->origin, point );
		point[2] -= 64;
		pm->trace (&trace, pm->ps->origin, pm->mins, pm->maxs, point, pm->ps->clientNum, pm->tracemask);
		if(trace.fraction == 1.0){
			PM_StopDash();
		}
	}
	PM_NotOnGround();
}
void PM_NotNearGround(void){
	pm->ps->bitFlags &= ~nearGround;
}
void PM_NearGroundTrace(void){
	vec3_t		point;
	trace_t		trace;
	if(pm->ps->bitFlags & atopGround){
		if(pm->ps->timers[tmFall] >= 4000){PM_AddEvent(EV_FALL_FAR);}
		else if(pm->ps->timers[tmFall] >= 2000){PM_AddEvent(EV_FALL_MEDIUM);}
		else if(pm->ps->timers[tmFall] >= 500){PM_AddEvent(EV_FALL_SHORT);}
		pm->ps->timers[tmFall] = 0;
		return;
	}
	pm->ps->timers[tmFall] += pml.msec;
	point[0] = pm->ps->origin[0];
	point[1] = pm->ps->origin[1];
	point[2] = pm->ps->origin[2] - 450.0f;
	pm->trace(&trace,pm->ps->origin,pm->mins,pm->maxs,point,pm->ps->clientNum,pm->tracemask);
	if(trace.allsolid && (!PM_CorrectAllSolid(&trace))){return;}
	if(trace.fraction == 1.0){
		PM_NotNearGround();
		return;
	}
	pm->ps->bitFlags |= nearGround;
}
/*=============
PM_GroundTrace
=============*/
void PM_GroundTrace(void){
	vec3_t		point;
	trace_t		trace;
	if(pm->ps->bitFlags & usingSoar){return;}
	point[0] = pm->ps->origin[0];
	point[1] = pm->ps->origin[1];
	point[2] = pm->ps->origin[2] - 0.75f;
	pm->trace (&trace, pm->ps->origin, pm->mins, pm->maxs, point, pm->ps->clientNum, pm->tracemask);
	pml.groundTrace = trace;
	if(trace.allsolid && (!PM_CorrectAllSolid(&trace))){return;}
	// if the trace didn't hit anything, we are in free fall
	if(trace.fraction == 1.0){
		PM_GroundTraceMissed();
		pml.groundPlane = qfalse;
		pml.onGround = qfalse;
		pm->ps->bitFlags &= ~atopGround;
		return;
	}
	if(pm->ps->velocity[2] > 0 && DotProduct(pm->ps->velocity, trace.plane.normal)> 10){
		PM_NotOnGround();
		return;
	}
	if(pm->ps->bitFlags & usingFlight){
		vec3_t testVec;
		VectorNormalize2(pml.up, testVec);
		if((testVec[2] < 0.9f) || (pm->cmd.upmove >= 0)){
			PM_NotOnGround();
			return;
		} else{
			PM_StopFlight();
			pm->ps->timers[tmZanzoken] = 0;
		}
	}
	// slopes that are too steep will not be considered onground
	if(trace.plane.normal[2] < MIN_WALK_NORMAL){
		PM_NotOnGround();
		pml.groundPlane = qtrue;
		return;
	}
	pml.groundPlane = qtrue;
	pml.onGround = qtrue;
	pm->ps->bitFlags |= atopGround;
	if(pm->ps->groundEntityNum == ENTITYNUM_NONE && (pm->ps->bitFlags & usingJump || pm->ps->bitFlags & usingFlight
		|| pm->ps->bitFlags & usingBallFlip || pm->ps->bitFlags & isUnconcious || pm->ps->bitFlags & isDead)){
		PM_StopFlight();
		PM_Land();
		PM_StopJump();
	}
	pm->ps->groundEntityNum = trace.entityNum;
	// don't reset the z velocity for slopes
	pm->ps->velocity[2] = 0;
	PM_AddTouchEnt(trace.entityNum );
}


/*=============
PM_SetWaterLevel
=============*/
void PM_SetWaterLevel(void){
	vec3_t		point;
	int			cont;
	int			sample1;
	int			sample2;
	pm->waterlevel = 0;
	pm->watertype = 0;
	if(pm->ps->pm_flags & PMF_TIME_WATERJUMP){
		return;
	}

	point[0] = pm->ps->origin[0];
	point[1] = pm->ps->origin[1];
	point[2] = pm->ps->origin[2] + MINS_Z + 1;
	cont = pm->pointcontents(point, pm->ps->clientNum );

	if(cont & MASK_WATER){
		sample2 = pm->ps->viewheight - MINS_Z;
		sample1 = sample2 / 2;

		pm->watertype = cont;
		pm->waterlevel = 1;
		point[2] = pm->ps->origin[2] + MINS_Z + sample1;
		cont = pm->pointcontents (point, pm->ps->clientNum );
		if(cont & MASK_WATER){
			pm->waterlevel = 2;
			point[2] = pm->ps->origin[2] + MINS_Z + sample2;
			cont = pm->pointcontents (point, pm->ps->clientNum );
			if(cont & MASK_WATER ){
				pm->waterlevel = 3;
			}
		}
	}

}
/*==============
PM_SetView
==============*/
void PM_SetView(void){
	pm->mins[0] = -15;
	pm->mins[1] = -15;
	pm->mins[2] = MINS_Z;
	pm->maxs[0] = 15;
	pm->maxs[1] = 15;
	pm->maxs[2] = 32;
	pm->ps->viewheight = DEFAULT_VIEWHEIGHT;
}
/*===============
PM_Footsteps
===============*/
void PM_Footsteps(void){
	float bobmove;
	int	old;
	qboolean footstep;
	if(pm->ps->bitFlags & usingZanzoken || pm->ps->bitFlags & usingJump || pm->ps->bitFlags & usingBallFlip){return;}
	if((pm->ps->bitFlags & keyTierUp) || ((pm->ps->bitFlags & keyTierDown) && (VectorLength(pm->ps->velocity) <= 5))){return;}
	if((pm->ps->bitFlags & usingAlter) && (VectorLength(pm->ps->velocity) <= 5)){
		if(pm->cmd.rightmove < 0){
			PM_ContinueLegsAnim(ANIM_IDLE);
			return;
		}
		if(pm->ps->powerLevel[plCurrent] > 31000){PM_ContinueLegsAnim(ANIM_KI_CHARGE);}
		else{pm->ps->powerLevel[plCurrent] > pm->ps->powerLevel[plFatigue] ? PM_ContinueLegsAnim(ANIM_KI_CHARGE) : PM_ContinueLegsAnim(ANIM_PL_UP);}
		return;
	}
	pm->xyspeed = sqrt(pm->ps->velocity[0] * pm->ps->velocity[0] +  pm->ps->velocity[1] * pm->ps->velocity[1]);
	if(pm->waterlevel > 2 && !(pm->ps->bitFlags & usingFlight)){
		if(pm->cmd.forwardmove > 0){
			PM_ContinueLegsAnim(ANIM_SWIM);
			return;
		}
		else if(!pm->cmd.forwardmove && !pm->cmd.rightmove && !pm->cmd.upmove){
			PM_ContinueLegsAnim(ANIM_SWIM_IDLE);
			return;
		}
	}
	if(pm->ps->bitFlags & usingFlight){
		if(pm->ps->bitFlags & usingSoar || pm->ps->bitFlags & isPreparing){
			pm->ps->bitFlags & usingSoar ? PM_ContinueLegsAnim(ANIM_FLY_FORWARD) : PM_ContinueLegsAnim(ANIM_FLY_START);
			return;
		}
		if((!pm->cmd.forwardmove && !pm->cmd.rightmove) || (pm->cmd.buttons & BUTTON_WALKING )) {
			int	tempAnimIndex;
			pm->ps->bobCycle = 0;
			tempAnimIndex = pm->ps->torsoAnim & ~ANIM_TOGGLEBIT;
			if((tempAnimIndex >= ANIM_KI_ATTACK1_PREPARE) && (tempAnimIndex <= ANIM_KI_ATTACK6_ALT_FIRE)) {
				tempAnimIndex = tempAnimIndex - ANIM_KI_ATTACK1_PREPARE;
				tempAnimIndex = ANIM_KI_ATTACK1_PREPARE + tempAnimIndex;
				PM_ContinueLegsAnim(tempAnimIndex);
			} else{
				if(pm->cmd.upmove > 0){PM_ContinueLegsAnim(ANIM_FLY_UP);} 
				else if(pm->cmd.upmove < 0){PM_ContinueLegsAnim(ANIM_FLY_DOWN);}
				else if(pm->ps->lockedTarget>0){PM_ContinueLegsAnim(ANIM_IDLE_LOCKED);}
				else{PM_ContinueLegsAnim(ANIM_FLY_IDLE);}
			}
			return;
		}
		if(pm->cmd.forwardmove > 0){
			PM_ContinueLegsAnim(ANIM_DASH_FORWARD);
		} else if(pm->cmd.forwardmove < 0){
			PM_ContinueLegsAnim(ANIM_DASH_BACKWARD);
		} else if(pm->cmd.rightmove > 0){
			PM_ContinueLegsAnim(ANIM_DASH_RIGHT);
		} else if(pm->cmd.rightmove < 0){
			PM_ContinueLegsAnim(ANIM_DASH_LEFT);
		}
		return;
	}
	if(!(pm->ps->bitFlags & atopGround)){
		if(pm->ps->timers[tmFall] > 750){
			PM_ContinueLegsAnim(ANIM_FLY_DOWN);
		}
		return;
	}
	if(!pm->cmd.forwardmove && !pm->cmd.rightmove){
		if(pm->xyspeed < 5){
			int	tempAnimIndex;
			pm->ps->bobCycle = 0;
			tempAnimIndex = pm->ps->torsoAnim & ~ANIM_TOGGLEBIT;
			if((tempAnimIndex >= ANIM_KI_ATTACK1_PREPARE) && (tempAnimIndex <= ANIM_KI_ATTACK6_ALT_FIRE)) {
				tempAnimIndex = tempAnimIndex - ANIM_KI_ATTACK1_PREPARE;
				tempAnimIndex = ANIM_KI_ATTACK1_PREPARE + tempAnimIndex;
				PM_ContinueLegsAnim(tempAnimIndex);
			}
			else if(pm->ps->bitFlags & atopGround){
				if(pm->ps->lockedTarget>0){PM_ContinueLegsAnim(ANIM_IDLE_LOCKED);}
				else{PM_ContinueLegsAnim(ANIM_IDLE);}
			}
		}
		return;
	}
	footstep = qfalse;
	if(!(pm->cmd.buttons & BUTTON_WALKING)){
		bobmove = 0.4f;
		if(!pm->ps->running){
			if(pm->cmd.forwardmove < 0) {
				PM_ContinueLegsAnim(ANIM_DASH_BACKWARD);
			} else if(pm->cmd.forwardmove > 0){
				PM_ContinueLegsAnim(ANIM_DASH_FORWARD);
			} else if(pm->cmd.rightmove > 0){
				PM_ContinueLegsAnim(ANIM_DASH_RIGHT);
			} else if(pm->cmd.rightmove < 0){
				PM_ContinueLegsAnim(ANIM_DASH_LEFT);
			}
		}else{
			if(pm->cmd.forwardmove < 0){
				PM_ContinueLegsAnim(ANIM_BACKRUN);
			} else if(pm->cmd.forwardmove > 0){
				PM_ContinueLegsAnim(ANIM_RUN);
			} else if(pm->cmd.rightmove > 0){
				PM_ContinueLegsAnim(ANIM_DASH_RIGHT );
			} else if(pm->cmd.rightmove < 0){
				PM_ContinueLegsAnim(ANIM_DASH_LEFT);
			}
		}
		footstep = qtrue;
	}
	else{
		bobmove = 0.3f;
		if(pm->cmd.forwardmove < 0){
			PM_ContinueLegsAnim(ANIM_BACKWALK );
		}
		else{
			PM_ContinueLegsAnim(ANIM_WALK);
		}
	}
	old = pm->ps->bobCycle;
	pm->ps->bobCycle = (int)(old + bobmove * pml.msec)& 255;
	if(((old + 64)^ (pm->ps->bobCycle + 64)) & 128){
		if(pm->waterlevel == 0){
			if(footstep && !pm->noFootsteps){
				PM_AddEvent(PM_FootstepForSurface());
			}
		} else if(pm->waterlevel == 1){
			PM_AddEvent(EV_FOOTSPLASH );
		} else if(pm->waterlevel == 2){
			PM_AddEvent(EV_SWIM );
		} else if(pm->waterlevel == 3){
		}
	}
}

/*
==============
PM_WaterEvents

Generate sound events for entering and leaving water
==============
*/
void PM_WaterEvents(void){		// FIXME?
/*
	//
	// ifjust entered a water volume at a high velocity, play a sound and effect
	//
	if(!pml.previous_waterlevel && pm->waterlevel && pm->xyspeed > 200) {
		PM_AddEvent(EV_WATER_SPLASH );
	}
*/
	//
	// ifjust entered a water volume, play a sound
	//
	if(!pml.previous_waterlevel && pm->waterlevel) {
		PM_AddEvent(EV_WATER_TOUCH );
	}

	//
	// ifjust completely exited a water volume, play a sound
	//
	if(pml.previous_waterlevel && !pm->waterlevel) {
		PM_AddEvent(EV_WATER_LEAVE );
	}

	//
	// check for head just going under water
	//
	if(pml.previous_waterlevel != 3 && pm->waterlevel == 3) {
		PM_AddEvent(EV_WATER_UNDER );
	}

	//
	// check for head just coming out of water
	//
	if(pml.previous_waterlevel == 3 && pm->waterlevel != 3) {
		PM_AddEvent(EV_WATER_CLEAR );
	}
}

// Timer decay.

/*
================
PM_DropTimers
================
*/
void PM_DropTimers(void){
	if(pm->ps->pm_time){
		if(pml.msec >= pm->ps->pm_time){
			pm->ps->pm_time = 0;
		} else{
			pm->ps->pm_time -= pml.msec;
		}
	}
	if(pm->ps->legsTimer > 0){
		pm->ps->legsTimer -= pml.msec;
		if(pm->ps->legsTimer < 0){
			pm->ps->legsTimer = 0;
		}
	}
	if(pm->ps->torsoTimer > 0){
		pm->ps->torsoTimer -= pml.msec;
		if(pm->ps->torsoTimer < 0){
			pm->ps->torsoTimer = 0;
		}
	}
	if(pm->ps->lockTimer > 0){
		pm->ps->lockTimer -= pml.msec;
		if(pm->ps->lockTimer < 0){
			pm->ps->lockTimer = 0;
		}
	}
}

