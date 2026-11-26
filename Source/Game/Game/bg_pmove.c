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
//
// bg_pmove.c -- both games player movement code
// takes a playerstate and a usercmd as input and returns a modifed playerstate

#include "../../Shared/q_shared.h"
#include "bg_public.h"
#include "bg_local.h"
#include "bg_userweapons.h"
#include "g_tiers.h"
pmove_t		*pm;
pml_t		pml;
// movement parameters
float	pm_stopspeed = 100.0f;
float	pm_swimScale = 0.80f;
float	pm_accelerate = 10.0f;
float	pm_airaccelerate = 15.0f;
float	pm_wateraccelerate = 4.0f;
float	pm_flyaccelerate = 15.0f;
float	pm_dashaccelerate = 15.0f;
float	pm_friction = 15.0f;
float	pm_waterfriction = 1.0f;
float	pm_flightfriction = 15.0f;
float	pm_spectatorfriction = 7.0f;
int		c_pmove = 0;
/*===================
FREEZE
===================*/
void PM_Freeze(void){
	if(pm->ps->timers[tmFreeze] > 0){
		pm->ps->timers[tmFreeze] -= pml.msec;
		VectorClear(pm->ps->velocity);
		if(pm->ps->timers[tmFreeze]<0){pm->ps->timers[tmFreeze] = 0;}
	}
}
/*================
IMPEDE
================*/
void PM_Impede(void){
	if(pm->ps->timers[tmImpede] > 0){
		pm->ps->timers[tmImpede] -= pml.msec;
		if(pm->ps->timers[tmImpede] <= 0){pm->ps->timers[tmImpede] = 0;}
		if(usingJump && (pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING)){pm->ps->bitFlags = usingFlight;}
		VectorClear(pm->ps->velocity);
		PM_StopDirections();
		PM_StopZanzoken();
	}
}
/*================
RIDE
================*/
void PM_Ride(void){
	if(pm->ps->states & isRiding){
		if(usingJump && (pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING)){pm->ps->bitFlags = usingFlight;}
		VectorClear(pm->ps->velocity);
		//PM_StopDirections();
		PM_StopZanzoken();
		pm->cmd.forwardmove = -1;
	}
}
/*================
Burn
================*/
void PM_Burn(void){
	if(pm->ps->states & isBurning){
		if(usingJump && (pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING)){pm->ps->bitFlags = usingFlight;}
		VectorClear(pm->ps->velocity);
		PM_StopDirections();
		PM_StopZanzoken();
	}
}
/*===================
BLIND
===================*/
void PM_Blind(void){
	if(pm->ps->timers[tmBlind] > 0){
		pm->ps->timers[tmBlind] -= pml.msec;
		if(pm->ps->timers[tmBlind]<0){pm->ps->timers[tmBlind] = 0;}
	}
}
/*===================
CHECK LOOPING SOUND
===================*/
void PM_CheckLoopingSound(void){
	if(pm->ps->timers[tmKnockback] ||
		pm->ps->timers[tmMeleeCharge] != 0 ||
		pm->ps->timers[tmMeleeIdle]  ||
		pm->ps->bitFlags & usingMelee ||
		pm->ps->bitFlags & isUnconcious ||
		pm->ps->bitFlags & isCrashed ||
		pm->ps->bitFlags & isDead){
		PM_AddEvent(EV_STOPLOOPINGSOUND);
	}
}
/*===================
KNOCKBACK
===================*/
void PM_StopKnockback(void){
	pm->ps->timers[tmKnockback] = 0;
	pm->ps->knockBackDirection = 0;
}
void PM_StopDirections(void){
	pm->cmd.forwardmove = 0;
	pm->cmd.upmove = 0;
	pm->cmd.rightmove = 0;
}
void PM_CheckKnockback(void){
	vec3_t post_vel,wishvel,wishdir,direction;
	qboolean vertical;
	float scale,wishspeed;
	int i,speed;
	vertical = qfalse;
	if(pm->ps->timers[tmFreeze]){return;}
	if(pm->ps->timers[tmKnockback] < 0){
		pm->ps->timers[tmKnockback] += pml.msec;
		PM_ContinueLegsAnim(ANIM_KNOCKBACK_RECOVER_2);
		if(pm->ps->timers[tmKnockback] >= 0){
			pm->ps->timers[tmKnockback] = 0;
		}
	}
	if(pm->ps->timers[tmKnockback] > 0){
		PM_ContinueLegsAnim(ANIM_KNOCKBACK);
		pm->ps->timers[tmKnockback] -= pml.msec;
		PM_StopDirections();
		VectorScale(pml.forward,-1,direction);
		if(pm->ps->timers[tmKnockback] > 0){
			PM_WeaponRelease();
			if(pm->ps->knockBackDirection == 1){
				VectorCopy(pml.up,direction);
				vertical = qtrue;
				pm->cmd.upmove = 127;
			}
			else if(pm->ps->knockBackDirection == 2){
				VectorScale(pml.up,-1.0,direction);
				vertical = qtrue;
				pm->cmd.upmove = -127;
			}
			else if(pm->ps->knockBackDirection == 3){
				VectorScale(pml.right,-1.0,direction);
				pm->cmd.rightmove = -127;
			}
			else if(pm->ps->knockBackDirection == 4){
				VectorCopy(pml.right,direction);
				pm->cmd.rightmove = 127;
			}
			else if(pm->ps->knockBackDirection == 5){
				VectorScale(pml.forward,-1.0,direction);
				pm->cmd.forwardmove = -127;
			}
			else if(pm->ps->knockBackDirection == 6){
				VectorCopy(pml.forward,direction);
				pm->cmd.forwardmove = 127;
			}
		}
		else{
			pm->ps->timers[tmKnockback] = 0;
		}
		scale = PM_CmdScale(&pm->cmd);
		for(i=0;i<3;i++){
			wishvel[i] = scale * pml.forward[i] * pm->cmd.forwardmove + scale * pml.right[i] * pm->cmd.rightmove + scale * pml.up[i] * pm->cmd.upmove;
		}
		VectorCopy(wishvel,wishdir);
		wishspeed = VectorNormalize(wishdir);
		PM_Accelerate(wishdir,wishspeed,50);
		VectorNormalize(pm->ps->velocity);
		speed = pm->ps->powerups[PW_KNOCKBACK_SPEED];
		if((pm->cmd.buttons & BUTTON_ALT_ATTACK) && (pm->ps->timers[tmKnockback] < 4000)){
			pm->ps->powerLevel[plUseFatigue] += ((float)pm->ps->timers[tmKnockback] / 5000.0) * (0.2 * pm->ps->powerLevel[plFatigue]);
			pm->ps->timers[tmKnockback] = -500;
			speed = 0;
		}
		else if(pm->cmd.buttons & BUTTON_ATTACK){
			pm->ps->timers[tmKnockback] -= pml.msec;
			//PM_ContinueLegsAnim(ANIM_KNOCKBACK_RECOVER_1);
			speed /= 2;
		}
		VectorScale(pm->ps->velocity,speed,pm->ps->velocity);
		PM_StepSlideMove(qfalse);
		VectorNormalize2(pm->ps->velocity,post_vel);
		if(PM_CheckDirection(direction,qfalse)){PM_Crash(vertical);}
	}
}
void PM_Crash(qboolean vertical){
	pm->ps->powerLevel[plDamageGeneric] = pm->ps->bitFlags & usingSoar ? VectorLength(pm->ps->velocity) * 0.03 : VectorLength(pm->ps->velocity) * 0.3;
	pm->ps->timers[tmCrash] = vertical ? -2500 : 2500;
	pm->ps->bitFlags |= isCrashed;
	PM_AddEvent(EV_CRASH);
	PM_StopSoar();
	PM_StopKnockback();
}
/*===================
TALK
===================*/
void PM_CheckTalk(void){
	if(pm->cmd.buttons & BUTTON_TALK){pm->ps->eFlags |= EF_TALK;}
	else{pm->ps->eFlags &= ~EF_TALK;}
	if(pm->cmd.buttons & BUTTON_TALK){
		pm->cmd.buttons = BUTTON_TALK;
	}
}
/*===============
ZANZOKEN
===============*/
void PM_StopZanzoken(void){
	if(pm->ps->bitFlags & usingZanzoken){
		pm->ps->bitFlags &= ~usingZanzoken;
		PM_AddEvent(EV_ZANZOKEN_END);
		VectorClear(pm->ps->velocity);
	}
	pm->ps->timers[tmZanzoken] = 0;
}
void PM_CheckZanzoken(void){
	vec3_t post_vel,minSize,maxSize,forward,end;
	int speed,cost;
	trace_t trace;
	if(pm->ps->powerLevel[plFatigue] <= 1){
		PM_StopZanzoken();
		return;
	}
	if(!(pm->ps->states & canZanzoken)){return;}
	if(pm->ps->bitFlags & usingSoar || pm->ps->bitFlags & isPreparing || pm->ps->bitFlags & usingMelee){return;}
	if(!(pm->cmd.buttons & BUTTON_TELEPORT)){
		pm->ps->timers[tmZanzoken] = -1;
	}
	if((pm->ps->bitFlags & usingZanzoken) && (pm->ps->timers[tmZanzoken] <= 0)){
		minSize[0] = minSize[1] = minSize[2] = -1;
		maxSize[0] = maxSize[1] = maxSize[2] = 1;
		AngleVectors(pm->ps->viewangles,forward,NULL,NULL);
		VectorMA(pm->ps->origin,10,forward,end);
		pm->trace(&trace,pm->ps->origin,minSize,maxSize,end,pm->ps->clientNum,CONTENTS_BODY); 
		if(trace.fraction == 1.0){
			PM_StopZanzoken();
		} 
	}
	if(pm->ps->timers[tmZanzoken] > 0){
		speed = (pm->ps->powerLevel[plCurrent] / 13.1) + pm->ps->stats[stZanzokenSpeed];
		pm->ps->timers[tmZanzoken] -= pml.msec;
		if(pm->ps->timers[tmZanzoken] < 0){
			pm->ps->timers[tmZanzoken] = 0;
		}
		VectorNormalize(pm->ps->velocity);
		if(pm->ps->lockedTarget > 0){speed *= 1.5;}
		VectorScale(pm->ps->velocity,speed,pm->ps->velocity);
		VectorNormalize2(pm->ps->velocity,post_vel);
	}
	if((pm->cmd.buttons & BUTTON_TELEPORT) && !(pm->ps->bitFlags & usingZanzoken) && (pm->ps->timers[tmZanzoken] == -1)){
		PM_StopDash();
		pm->ps->bitFlags |= usingZanzoken;
		pm->ps->timers[tmZanzoken] = (pm->ps->powerLevel[plFatigue] / 93.62) + pm->ps->stats[stZanzokenDistance];
		cost = (pm->ps->powerLevel[plMaximum] * 0.12) * pm->ps->baseStats[stZanzokenCost];
		if(pm->ps->lockedTarget > 0){cost *= 0.8;}
		if(pm->ps->bitFlags & usingJump){cost *= 0.4;}
		pm->ps->powerLevel[plUseFatigue] += cost;
		PM_AddEvent(EV_ZANZOKEN_START);
	}	
}
/*===============
POWER LEVEL
===============*/
void PM_UsePowerLevel(void){
	int newValue,amount,stat,useType,limit;
	useType = 0;
	limit = pm->ps->powerLevel[plLimit];
	while(useType < 4){
		stat = useType == 1 ? pm->ps->powerLevel[plFatigue] : pm->ps->powerLevel[plCurrent];
		stat = useType == 2 ? pm->ps->powerLevel[plHealth] : stat;
		stat = useType == 3 ? pm->ps->powerLevel[plMaximum] : stat;
		amount = useType == 1 ? pm->ps->powerLevel[plUseFatigue] : pm->ps->powerLevel[plUseCurrent];
		amount = useType == 2 ? pm->ps->powerLevel[plUseHealth] : amount;
		amount = useType == 3 ? pm->ps->powerLevel[plUseMaximum] : amount;
		newValue = (stat - amount) > limit ? limit : stat - amount;
		if(newValue <= 0 && useType == 0 && pm->ps->powerLevel[plFatigue] > 0){
			pm->ps->powerLevel[plFatigue] -= (amount * 1.5);
			pm->ps->powerLevel[plCurrent] = 1;
			pm->ps->powerLevel[plUseCurrent] = 0;
			return;
		}
		newValue = newValue < -limit ? -limit : newValue;
		if(useType == 1){
			pm->ps->powerLevel[plFatigue] = newValue;
			if(pm->ps->powerLevel[plFatigue] < 0){
				amount = (pm->ps->powerLevel[plFatigue]*-1)*0.75;
				if(pm->ps->powerLevel[plHealth] - amount <= 0){
					amount = pm->ps->powerLevel[plHealth] - 1;
				}
				pm->ps->powerLevel[plUseHealth] += amount;
				pm->ps->powerLevel[plFatigue] = 0;
			}
			pm->ps->powerLevel[plUseFatigue] = 0;
		}
		else if(useType == 2){
			pm->ps->powerLevel[plHealth] = newValue;
			pm->ps->powerLevel[plUseHealth] = 0;
		}
		else if(useType == 3){
			pm->ps->powerLevel[plMaximum] = newValue;
			pm->ps->powerLevel[plUseMaximum] = 0;
		}
		else{
			pm->ps->powerLevel[plCurrent] = newValue;
			pm->ps->powerLevel[plUseCurrent] = 0;
		}
		useType += 1;
	}
}
void PM_BurnPowerLevel(void){
	float percent;
	int defense;
	int burn,initial;
	int newValue;
	int burnType;
	int limit;
	limit = pm->ps->powerLevel[plLimit];
	burnType = 0;
	if(pm->ps->powerLevel[plDamageFromMelee] || pm->ps->powerLevel[plDamageFromEnergy] || pm->ps->powerLevel[plDamageGeneric] || pm->ps->states & causedDamage){
		pm->ps->bitFlags |= isUnsafe;
		pm->ps->states &= ~causedDamage;
		pm->ps->timers[tmSafe] = 0;
	}
	else if(pm->ps->timers[tmSafe] > 10000){
		pm->ps->bitFlags &= ~isUnsafe;
	}
	pm->ps->timers[tmSafe] += pml.msec;
	while(burnType < 3){
		burn = burnType == 1 ? pm->ps->powerLevel[plDamageFromMelee] : pm->ps->powerLevel[plDamageFromEnergy];
		burn = burnType == 2 ? pm->ps->powerLevel[plDamageGeneric] : burn;
		if(!burn){
			burnType += 1;
			continue;
		}
		defense = burnType == 1 ? pm->ps->stats[stMeleeDefense] : pm->ps->stats[stEnergyDefense];
		defense = pm->ps->bitFlags & usingBlock ? defense * 2.0 : defense;
		defense = pm->ps->bitFlags & usingBallFlip ? defense * 1.5 : defense;
		defense = pm->ps->bitFlags & atopGround ? defense * 1.1 : defense;
		defense = (pm->cmd.buttons & BUTTON_WALKING) && pm->ps->bitFlags & atopGround ? defense * 1.5 : defense;
		initial = burn;
		percent = 1.0 - ((float)pm->ps->powerLevel[plCurrent] / (float)pm->ps->powerLevel[plMaximum]);
		burn -= (int)(((float)pm->ps->powerLevel[plFatigue] * 0.01) * defense);
		if(burnType != 2){
			pm->ps->powerLevel[plHealthPool] += burn * 0.5;
			pm->ps->powerLevel[plMaximumPool] += burn * 0.7;
		}
		if(pm->ps->powerLevel[plHealthPool] > limit){pm->ps->powerLevel[plHealthPool] = limit;}
		if(pm->ps->powerLevel[plMaximumPool] > limit){pm->ps->powerLevel[plMaximumPool] = limit;}
		newValue = pm->ps->powerLevel[plHealth] - burn;
		if(burn > 0){
			newValue = newValue > limit ? limit : newValue;
			pm->ps->powerLevel[plHealth] = newValue < 0 ? 0 : newValue;
			if(burnType != 2){
				newValue = pm->ps->powerLevel[plMaximum] + ((initial*0.7) * percent);
			}
			newValue = newValue < 0 ? 0 : newValue;
			if(burnType != 2){pm->ps->powerLevel[plMaximum] = newValue > limit ? limit : newValue;}
		}
		if(burnType == 0){pm->ps->powerLevel[plDamageFromEnergy] = 0;}
		else if(burnType == 1){pm->ps->powerLevel[plDamageFromMelee] = 0;}
		else if(burnType == 2){pm->ps->powerLevel[plDamageGeneric] = 0;}
		burnType += 1;
	}
}
void PM_CheckCrash(void){
	if(pm->ps->timers[tmCrash] > 0){
		pm->ps->timers[tmCrash] -= pml.msec;
		PM_ContinueTorsoAnim(ANIM_KNOCKBACK_HIT_WALL);
		PM_ContinueLegsAnim(ANIM_KNOCKBACK_HIT_WALL);
		if(pm->ps->timers[tmCrash] < 0){
			pm->ps->powerups[PW_STATE] = -1;
			pm->ps->timers[tmCrash] = 0;
		}
	}
	else if(pm->ps->timers[tmCrash] < 0){
		pm->ps->timers[tmCrash] += pml.msec;
		PM_ContinueTorsoAnim(ANIM_DEATH_AIR_LAND);
		PM_ContinueLegsAnim(ANIM_DEATH_AIR_LAND);
		if(pm->ps->timers[tmCrash] > 0){
			pm->ps->powerups[PW_STATE] = -1;
			pm->ps->timers[tmCrash] = 0;
		}
	}
}
void PM_CheckStatus(void){
	if(pm->ps->persistant[PERS_TEAM] == TEAM_SPECTATOR){return;}
	if(pm->ps->powerLevel[plHealth] <= 0){
		if(pm->ps->powerups[PW_STATE] != -2){
			pm->ps->bitFlags |= isDead;
			pm->ps->bitFlags &= ~isStruggling;
			pm->ps->powerups[PW_STATE] = -2;
			pm->ps->timers[tmFreeze] = 0;
			PM_StopMovement();
			PM_StopFlight();
			PM_WeaponRelease();
			PM_AddEvent(EV_DEATH);
		}
		else{
			if(pm->ps->bitFlags & atopGround){
				if(!(pm->ps->bitFlags & nearGround)){
					PM_ContinueTorsoAnim(ANIM_DEATH_AIR_LAND);
					PM_ContinueLegsAnim(ANIM_DEATH_AIR_LAND);
				}
				else{
					PM_ContinueTorsoAnim(ANIM_DEATH_GROUND);
					PM_ContinueLegsAnim(ANIM_DEATH_GROUND);
				}
			}
			else{
				PM_ContinueTorsoAnim(ANIM_DEATH_AIR);
				PM_ContinueLegsAnim(ANIM_DEATH_AIR);
			}
		}
	}
	/*else if(pm->ps->powerLevel[plFatigue] <= 0){
		if(pm->ps->powerups[PW_STATE] != -1){
			pm->ps->bitFlags |= isUnconcious;
			pm->ps->bitFlags &= ~isStruggling;
			pm->ps->powerups[PW_STATE] = -1;
			pm->ps->timers[tmFreeze] = 0;
			pm->ps->powerLevel[plCurrent] = 1;
			PM_StopMovement();
			PM_StopFlight();
			PM_StopBoost();
			PM_WeaponRelease();
			PM_AddEvent(EV_UNCONCIOUS);
			if(pm->ps->powerLevel[plFatigue] > -2500){
				pm->ps->powerLevel[plFatigue] = -2500;
			}
		}
		else{
			pm->ps->powerLevel[plFatigue] += pml.msec / 2;
			if(pm->ps->bitFlags & atopGround){
				if(!(pm->ps->bitFlags & nearGround)){
					PM_ContinueTorsoAnim(ANIM_DEATH_AIR_LAND);
					PM_ContinueLegsAnim(ANIM_DEATH_AIR_LAND);
				}
				else{
					PM_ContinueTorsoAnim(ANIM_DEATH_GROUND);
					PM_ContinueLegsAnim(ANIM_DEATH_GROUND);
				}
			}
			else{
				PM_ContinueTorsoAnim(ANIM_DEATH_AIR);
				PM_ContinueLegsAnim(ANIM_DEATH_AIR);
			}
		}
	}*/
	else{
		if(pm->ps->powerups[PW_STATE] == -1){
			if(pm->ps->timers[tmRecover] <= 0){pm->ps->timers[tmRecover] = 2000;}
			pm->ps->timers[tmRecover] -= pml.msec;
			if(pm->ps->timers[tmRecover] <= 0){
				pm->ps->bitFlags &= ~isUnconcious;
				pm->ps->bitFlags &= ~isCrashed;
				pm->ps->powerups[PW_STATE] = 0;
			}
			else if(pm->ps->bitFlags & isCrashed && !(pm->ps->bitFlags & atopGround)){
				PM_StopMovement();
				pm->ps->bitFlags |= usingFlight;
				PM_ContinueTorsoAnim(ANIM_KNOCKBACK_HIT_WALL);
				PM_ContinueLegsAnim(ANIM_KNOCKBACK_HIT_WALL);
				return;
			}
			else{
				PM_ContinueTorsoAnim(ANIM_FLOOR_RECOVER);
				PM_ContinueLegsAnim(ANIM_FLOOR_RECOVER);
				return;
			}
		}
		pm->ps->powerups[PW_STATE] = 0;
	}
}
qboolean PM_CheckTransform(void){
	pm->ps->timers[tmUpdateTier] += pml.msec;
	if(pm->ps->timers[tmUpdateTier] > 300){
		pm->ps->timers[tmUpdateTier] = 0;
		if(pm->ps->stats[stTransformState] == -1){PM_AddEvent(EV_TIERDOWN);}
		else if(pm->ps->stats[stTransformState] == 1){PM_AddEvent(EV_TIERUP);}
		else if(pm->ps->stats[stTransformState] == 2){PM_AddEvent(EV_TIERUP_FIRST);}
		pm->ps->stats[stTransformState] = 0;
		PM_AddEvent(EV_TIERCHECK);
	}
	if(pm->ps->timers[tmTransform] == 1){
		pm->ps->timers[tmTransform] = -100;
		PM_AddEvent(EV_SYNCTIER);
		return qtrue;
	}
	else if(pm->ps->timers[tmTransform] == -1){
		pm->ps->timers[tmTransform] = -100;
		PM_AddEvent(EV_SYNCTIER);
		return qtrue;
	}
	else if(pm->ps->timers[tmTransform] > 0){
		PM_StopDirections();
		if(pm->ps->bitFlags & isTransforming){
			PM_ContinueLegsAnim(ANIM_TRANS_UP);
			pm->ps->eFlags |= EF_AURA;
			pm->ps->timers[tmTransform] -= pml.msec;
			if(pm->ps->timers[tmTransform] <= 0){pm->ps->timers[tmTransform] = 0;}
			PM_StopMovement();
		}
		else{
			pm->ps->bitFlags |= isTransforming;
			PM_AddEvent(EV_SYNCTIER);
			return qtrue;
		}
	}
	else if(pm->ps->timers[tmTransform] < 0){
		if(pm->ps->timers[tmTransform] > 100 || pm->ps->timers[tmTransform] < -100){PM_StopDirections();}
		pm->ps->timers[tmTransform] += pml.msec;
		if(pm->ps->timers[tmTransform] >= -1){
			pm->ps->timers[tmTransform] = 0;
		}
	}
	if(pm->ps->timers[tmTransform] == 0){
		pm->ps->bitFlags &= ~isTransforming;
	}
	return qfalse;
}
void PM_CheckPowerLevel(void){
	int limit;
	int *timers,*powerLevel;
	float lower,raise,recovery;
	float statScale;
	float fatigueScale;
	float pushLimit;
	int newValue;
	int idleScale;
	timers = pm->ps->timers;
	powerLevel = pm->ps->powerLevel;
	timers[tmPowerAuto] += pml.msec;
	limit = powerLevel[plLimit];
	/*if(powerLevel[plFatigue] <= 0 && powerLevel[plCurrent] > 0){
		powerLevel[plCurrent] = 1;
	}*/
	while(timers[tmPowerAuto] >= 100){
		timers[tmPowerAuto] -= 100;
		idleScale = (!pm->cmd.forwardmove && !pm->cmd.rightmove && !pm->cmd.upmove) ? 2.8 : 1;
		statScale = 1.0 - ((float)powerLevel[plCurrent] / (float)powerLevel[plMaximum]);
		if(statScale > 0.75){statScale = 0.75;}
		if(statScale < 0.25){statScale = 0.25;}
		fatigueScale = (float)powerLevel[plFatigue] / (float)powerLevel[plMaximum];
		recovery = (float)powerLevel[plMaximum] * 0.01 * idleScale;
		recovery *=  statScale;
		recovery *=  fatigueScale < 0.15 ? 0.15 : fatigueScale;
		recovery *= pm->ps->baseStats[stFatigueRecovery];
		if(pm->ps->bitFlags & usingAlter || pm->ps->bitFlags & isStruggling || pm->ps->bitFlags & usingSoar
		|| pm->ps->bitFlags & isBreakingLimit || pm->ps->weaponstate >= WEAPON_GUIDING){recovery = 0;}
		/*if(powerLevel[plCurrent] > powerLevel[plFatigue]){
			newValue = powerLevel[plCurrent] - (powerLevel[plMaximum] * 0.005);
			powerLevel[plCurrent] = (powerLevel[plCurrent] - newValue >= 0) ? newValue : 0;
		}*/
		newValue = powerLevel[plCurrent] + powerLevel[plDrainCurrent];
		if(newValue < powerLevel[plMaximum] && newValue > 0){powerLevel[plCurrent] = newValue;}
		newValue = powerLevel[plFatigue] + powerLevel[plDrainFatigue];
		if(newValue < powerLevel[plMaximum]){powerLevel[plFatigue] = newValue;}
		newValue = powerLevel[plHealth] + powerLevel[plDrainHealth];
		if(newValue < powerLevel[plMaximum]){powerLevel[plHealth] = newValue;}
		newValue = powerLevel[plMaximum] + powerLevel[plDrainMaximum];
		if(newValue < limit &&  newValue > 0){powerLevel[plMaximum] = newValue;}
		if(powerLevel[plFatigue] + recovery < powerLevel[plMaximum]){
			powerLevel[plFatigue] += recovery;
		}
		else{
			powerLevel[plFatigue] = powerLevel[plMaximum];
		}
	}
	if(pm->cmd.buttons & BUTTON_POWERLEVEL){
		qboolean canAlter;
		pm->ps->bitFlags &= ~keyTierDown;
		pm->ps->bitFlags &= ~keyTierUp;
		canAlter = qtrue;
		if(pm->ps->bitFlags & usingJump){
			pm->ps->bitFlags |= usingFlight;
			PM_StopJump();
		}
		if(pm->ps->bitFlags & usingBoost || pm->ps->timers[tmTransform] < 0 || pm->ps->bitFlags & usingSoar ||
		   pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING){
			canAlter = qfalse;
		}
		if(canAlter && pm->cmd.upmove < 0){
			PM_StopFlight();
			PM_ForceLegsAnim(ANIM_FLY_DOWN);
		}
		if(pm->cmd.forwardmove > 0){
			pm->ps->bitFlags |= keyTierUp;
			pm->ps->bitFlags &= ~usingAlter;
		}
		else if(pm->cmd.forwardmove < 0){
			pm->ps->bitFlags |= keyTierDown;
			pm->ps->bitFlags &= ~usingAlter;
		}
		else if(canAlter && pm->cmd.rightmove < 0){
			pm->ps->eFlags &= ~EF_AURA;
			lower = powerLevel[plMaximum] * 0.01;
			powerLevel[plCurrent] = (powerLevel[plCurrent] - lower > 1) ? powerLevel[plCurrent] - lower : 1;
			if(!(pm->ps->bitFlags & usingAlter)){PM_AddEvent(EV_ALTERDOWN_START);}
			pm->ps->bitFlags |= usingAlter;
		}
		else if(canAlter && (pm->cmd.rightmove > 0)){
			pm->ps->eFlags |= EF_AURA;
			timers[tmPowerRaise] += pml.msec;
			while(timers[tmPowerRaise] >= 25){
				timers[tmPowerRaise] -= 25;
				raise = powerLevel[plMaximum] * 0.009;
				if(raise < 1){raise = 1;}
				if(powerLevel[plCurrent] > powerLevel[plFatigue]){raise *= 0.6;}
				newValue = powerLevel[plCurrent] + raise;
				if(newValue > powerLevel[plMaximum]){newValue = powerLevel[plMaximum];}
				if(newValue > limit){newValue = limit;}
				powerLevel[plCurrent] = newValue;
				if(powerLevel[plCurrent] == powerLevel[plMaximum]){
					if(!(pm->ps->bitFlags & isBreakingLimit)){PM_AddEvent(EV_POWERINGUP_START);}
					pm->ps->bitFlags |= isBreakingLimit;
					pushLimit = powerLevel[plCurrent] + pm->ps->breakLimitRate;
					if(powerLevel[plHealthPool] > 0){
						if(powerLevel[plHealth] + raise * 0.3 < pushLimit){
							powerLevel[plHealth] += raise * 0.3;
							powerLevel[plUseFatigue] += raise * 0.25;
						}
					}
					powerLevel[plHealthPool] -= raise * 0.3;
					if(powerLevel[plHealthPool] < 0){powerLevel[plHealthPool] = 0;}
					if(powerLevel[plHealth] > limit){powerLevel[plHealth] = limit;}
					if(powerLevel[plMaximumPool] > 0){
						if(pushLimit < limit){
							powerLevel[plCurrent] = powerLevel[plMaximum] = pushLimit;
						}
					}
					else{
						powerLevel[plUseFatigue] += raise;
					}
					powerLevel[plMaximumPool] -= raise * 0.3;
					if(powerLevel[plMaximumPool] < 0){powerLevel[plMaximumPool] = 0;}
				}
				if(pm->ps->bitFlags & isBreakingLimit){
					if(powerLevel[plCurrent] < ((float)powerLevel[plMaximum] * 0.95)){
						pm->ps->bitFlags &= ~isBreakingLimit;
					}
				}
			}
			if(!(pm->ps->bitFlags & usingAlter)){PM_AddEvent(EV_ALTERUP_START);}
			pm->ps->bitFlags |= usingAlter;
		}
		else{
			pm->ps->bitFlags &= ~usingAlter;
			pm->ps->bitFlags &= ~isBreakingLimit;
		}
	}
	else{
		pm->ps->bitFlags &= ~usingAlter;
		pm->ps->bitFlags &= ~keyTierDown;
		pm->ps->bitFlags &= ~keyTierUp;
		pm->ps->bitFlags &= ~isBreakingLimit;
	}
}
void PM_AddEvent(int newEvent){
	BG_AddPredictableEventToPlayerstate(newEvent,0,pm->ps);
}
/*===============
PM_AddTouchEnt
===============*/
void PM_AddTouchEnt(int entityNum){
	int		i;
	if(entityNum == ENTITYNUM_WORLD){
		return;
	}
	if(pm->numtouch == MAXTOUCH){
		return;
	}
	// see ifit is already added
	for (i = 0 ; i < pm->numtouch ; i++){
		if(pm->touchents[ i ] == entityNum){
			return;
		}
	}
	// add it
	pm->touchents[pm->numtouch] = entityNum;
	pm->numtouch++;
}

/*================
PM_UpdateViewAngles
================*/
void PM_UpdateViewAngles(playerState_t *ps, const usercmd_t *cmd){
	short		temp;
	int			i;
	int			roll = 0;
	float		oldCmdAngle;
	vec3_t		offset_angles;
	vec4_t		quatOrient;
	vec4_t		quatRot;
	vec4_t		quatResult;
	vec3_t		new_angles;
	float		pitchNorm;
	if(ps->pm_type == PM_INTERMISSION || ps->pm_type == PM_SPINTERMISSION) {
		return;		// no view changes at all
	}
	if((pm->ps->lockedTarget > 0) && !(pm->ps->bitFlags & usingAlter) && *ps->lockedPosition){
		vec3_t dir;
		vec3_t angles;
		VectorSubtract(*(ps->lockedPosition),ps->origin,dir);
		vectoangles(dir, angles);

		for (i = 0; i < 3; i++) {
			ps->delta_angles[i] = ANGLE2SHORT(angles[i]) - cmd->angles[i];
		}
	}
	else if(pm->ps->bitFlags & usingFlight && pm->ps->states & advancedFlight){
		if(cmd->buttons & BUTTON_ROLL_LEFT){
			roll -= 28 * (pml.msec / 200.0f);
		}
		if(cmd->buttons & BUTTON_ROLL_RIGHT) {
			roll += 28 * (pml.msec / 200.0f);
		}
		for (i=0; i<3; i++) {
			// Get the offsets for the angles
			oldCmdAngle = ps->viewangles[i] - SHORT2ANGLE(ps->delta_angles[i]);
			offset_angles[i] = AngleNormalize180(SHORT2ANGLE(cmd->angles[i]) - oldCmdAngle);
		}
		// Don't forget to add our customized roll function if
		// we're not guiding a weapon!
		if(!(pm->ps->bitFlags & isGuiding)){
			offset_angles[ROLL] = AngleNormalize180(offset_angles[ROLL] + roll);
		}

		// There's a drifting problem with the quaternions' rounding, so when we DON'T change
		// our viewangles at all, we don't run through the quaternions to prevent drifting.
		// (As a bonus; this also means we won't be doing needless matrix manipulations.)

		if(((offset_angles[0] == 0) && (offset_angles[1] == 0)) && (offset_angles[2] == 0)) {
			return;
		}
		AnglesToQuat(ps->viewangles, quatOrient);
		AnglesToQuat(offset_angles, quatRot);
		QuatMul(quatOrient, quatRot, quatResult);
		QuatToAngles(quatResult, new_angles);
		// Try and compensate for the drifting problem.
		new_angles[PITCH] += 0.05f;
		// HACK: Because an exact pitch of -90 degrees STILL causes trouble troughout the
		//       code due to 'bad mathematics', we give a slight nudge ifthis threatens
		//       to happen. 2 degrees is not really noticeable, and is big enough to
		//       compensate for round off errors leading to -90 degrees of pitch.
		// NOTE: For some reason the program 'auto-magically' prevents angles of 90 degree
		//       pitch, by forcing you into a bit more yaw. Strange...
		AngleNormalize180(new_angles[PITCH]);
		if((new_angles[PITCH] < -89.0f)&& (new_angles[PITCH] > -91.0f)) {
			if(ps->viewangles[PITCH] < new_angles[PITCH]){
				new_angles[PITCH] += 2;
			} else{
				new_angles[PITCH] -= 2;
			}
		}
		// Correct the 3 delta_angles;
		if(i == ROLL && ps->viewangles[i] != 0) {
			ps->viewangles[i] = 0;
			ps->delta_angles[i] = 0 - cmd->angles[i];
		}
		for (i=0; i<3; i++) {
			ps->viewangles[i] = AngleNormalize180(new_angles[i]);
			ps->delta_angles[i] = ANGLE2SHORT(ps->viewangles[i]) - cmd->angles[i];
		}
		return;
	}
	else{
		ps->viewangles[ROLL] = 0;
		ps->delta_angles[ROLL] = 0;
		offset_angles[ROLL]= 0;
	}
	// We've been flying and we've inverted our pitch to a good amount upside down.
	// Cheat the view, by adjusting the yaw to 'swing around' and adjusting the pitch to match.
	pitchNorm = AngleNormalize180(ps->viewangles[PITCH]);
	if(pitchNorm > 100){
		ps->delta_angles[YAW] += ANGLE2SHORT(180);
		ps->delta_angles[PITCH] -= ANGLE2SHORT(pitchNorm);
		ps->delta_angles[PITCH] += ANGLE2SHORT(180 - pitchNorm);
	}
	if(pitchNorm < -100){
		ps->delta_angles[YAW] += ANGLE2SHORT(180);
		ps->delta_angles[PITCH] -= ANGLE2SHORT(pitchNorm);
		ps->delta_angles[PITCH] += ANGLE2SHORT(-180 - pitchNorm);
	}
	for (i=0 ; i<3 ; i++) {
		temp = cmd->angles[i] + ps->delta_angles[i];
		if(i == PITCH){
			if(pm->ps->lockedTarget <= 0){
				if(temp > 16000){
					ps->delta_angles[i] = 16000 - cmd->angles[i];
					temp = 16000;
				} else if(temp < -16000){
					ps->delta_angles[i] = -16000 - cmd->angles[i];
					temp = -16000;
				}
			}
			
		}
		ps->viewangles[i] = SHORT2ANGLE(temp);
	}
}
/*================
PmoveSingle
================*/
void trap_SnapVector(float *v );
void PmoveSingle(pmove_t *pmove){
	qboolean meleeRange;
	pm = pmove;
	c_pmove++;
	meleeRange = qfalse;
	pm->numtouch = 0;
	pm->watertype = 0;
	pm->waterlevel = 0;
	pm->ps->gravity[2] = pm->ps->bitFlags & usingJump ? pm->ps->gravity[2] : 800;
	pm->ps->eFlags &= ~EF_AURA;
	memset (&pml, 0, sizeof(pml));
	pml.msec = pmove->cmd.serverTime - pm->ps->commandTime;
	if(pml.msec < 1){pml.msec = 1;}
	else if(pml.msec > 200){pml.msec = 200;}
	if(abs(pm->cmd.forwardmove)> 64 || abs(pm->cmd.rightmove)> 64){pm->cmd.buttons &= ~BUTTON_WALKING;}
	AngleVectors(pm->ps->viewangles,pml.forward,pml.right,pml.up);
	pml.previous_waterlevel = pmove->waterlevel;
	PM_Impede();
	PM_Burn();
	PM_Ride();
	PM_CheckKnockback();
	PM_CheckHover();
	if(PM_CheckTransform()){return;}
	PM_CheckLoopingSound();
	PM_SetWaterLevel();
	if(pm->cmd.buttons != 0 && pm->cmd.buttons != 2048){
		//Com_Printf("%i\n",pm->cmd.buttons);
	}
	if(pm->ps->lockedTarget > 0){
		meleeRange = Distance(pm->ps->origin,*(pm->ps->lockedPosition)) <= 48 ? qtrue : qfalse;
	}
	if(!(pm->ps->bitFlags & isTransforming)){
		PM_UsePowerLevel();
		PM_BurnPowerLevel();
		PM_CheckCrash();
		PM_CheckStatus();
		PM_CheckStruggling();
		if(!pm->ps->timers[tmKnockback] && !(pm->ps->bitFlags & isUnconcious) && !(pm->ps->bitFlags & isDead) && !(pm->ps->bitFlags & isCrashed)){
			PM_CheckBoost();
			PM_CheckPowerLevel();
			PM_CheckLockon();
			PM_CheckZanzoken();
			if(!meleeRange){
				PM_CheckBlock();
				PM_CheckJump();
				PM_Footsteps();
			}
		}
	}
	PM_CheckTalk();
	pm->ps->commandTime = pmove->cmd.serverTime;
	VectorCopy(pm->ps->origin, pml.previous_origin);
	VectorCopy(pm->ps->velocity, pml.previous_velocity);
	pml.frametime = pml.msec * 0.001;
	PM_DropTimers();
	PM_SetView();
	if(pm->ps->bitFlags & isUnconcious || pm->ps->bitFlags & isDead || pm->ps->bitFlags & isCrashed){
		PM_StopMovementTypes();
		PM_StopFlight();
		PM_StopDirections();
		PM_StopLockon();
		PM_GroundTrace();
		PM_AirMove();
		PM_UpdateViewAngles(pm->ps, &pm->cmd);
		return;
	}
	if(!pm->ps->timers[tmKnockback]){
		int state;
		PM_Melee();
		state = pm->ps->stats[stMeleeState];
		if(state != stMeleeUsingPower || state != stMeleeUsingStun){
			PM_UpdateViewAngles(pm->ps,&pm->cmd);
			PM_Weapon();
		}
	}
	if(pm->ps->pm_type == PM_SPECTATOR){
		PM_FlyMove();
	}
	PM_TorsoAnimation();
	PM_Freeze();
	PM_Blind();
	PM_GroundTrace();
	PM_NearGroundTrace();
	if(!pm->ps->timers[tmFreeze] && !pm->ps->timers[tmImpede] && pm->ps->timers[tmTransform] < 100 && pm->ps->timers[tmTransform] > -100){
		if(!(pm->ps->bitFlags & usingAlter) && !(pm->ps->bitFlags & isStruggling) && !(pm->ps->bitFlags & usingMelee)){
			PM_FlyMove();
			PM_DashMove();
			PM_WalkMove();
			PM_AirMove();
		}
		else if(pm->ps->powerups[PW_DRIFTING] || pm->ps->timers[tmMeleeIdle] < 0){PM_AirMove();}
	}
	PM_Friction();
	PM_GroundTrace();
	trap_SnapVector(pm->ps->velocity);
}

/*================
Pmove
================*/
void Pmove(pmove_t *pmove){
	int	finalTime;
	finalTime = pmove->cmd.serverTime;
	if(finalTime < pmove->ps->commandTime){return;}
	if(finalTime > pmove->ps->commandTime + 1000){
		pmove->ps->commandTime = finalTime - 1000;
	}
	pmove->ps->pmove_framecount = (pmove->ps->pmove_framecount+1) & ((1<<PS_PMOVEFRAMECOUNTBITS)-1);
	while(pmove->ps->commandTime != finalTime){
		int	msec;
		msec = finalTime - pmove->ps->commandTime;
		if(pmove->pmove_fixed){
			if(msec > pmove->pmove_msec){
				msec = pmove->pmove_msec;
			}
		}
		else if(msec > 66){
			msec = 66;
		}
		pmove->cmd.serverTime = pmove->ps->commandTime + msec;
		PmoveSingle(pmove);
	}
}

