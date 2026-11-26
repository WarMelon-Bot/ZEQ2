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
// bg_pmanim.c -- shared pmove animation helpers

#include "../../Shared/q_shared.h"
#include "bg_public.h"
#include "bg_local.h"
#include "bg_userweapons.h"
#include "g_tiers.h"

// Shared player animation helpers.

/*===================
PM_StartTorsoAnim
===================*/
void PM_StartTorsoAnim(int anim){
	pm->ps->torsoAnim = ((pm->ps->torsoAnim & ANIM_TOGGLEBIT)^ ANIM_TOGGLEBIT) | anim;
}
void PM_StartLegsAnim(int anim){
	if((pm->ps->bitFlags & isGuiding) && (pm->cmd.buttons & BUTTON_ANY) && !(VectorLength(pm->ps->velocity)== 0.0f)){return;}
	pm->ps->legsAnim = ((pm->ps->legsAnim & ANIM_TOGGLEBIT)^ ANIM_TOGGLEBIT ) | anim;
}

void PM_ContinueLegsAnim(int anim){
	if((pm->ps->bitFlags & isGuiding) && (pm->cmd.buttons & BUTTON_ANY) && !(VectorLength(pm->ps->velocity)== 0.0f)){return;}
	if((pm->ps->legsAnim & ~ANIM_TOGGLEBIT)== anim){
		return;
	}
	PM_StartLegsAnim(anim );
}

void PM_ContinueTorsoAnim(int anim){
	if((pm->ps->torsoAnim & ~ANIM_TOGGLEBIT)== anim){
		return;
	}
	PM_StartTorsoAnim(anim );
}
void PM_ForceTorsoAnim(int anim){
	pm->ps->torsoTimer = 0;
	PM_StartTorsoAnim(anim);
}
void PM_ForceLegsAnim(int anim){
	if((pm->ps->bitFlags & isGuiding) && (pm->cmd.buttons & BUTTON_ANY) && !(VectorLength(pm->ps->velocity)== 0.0f)){return;}
	pm->ps->legsTimer = 0;
	PM_StartLegsAnim(anim );
}

// The torso mirrors the legs animation for every one of these states.  The
// old switch had one case per animation; a table keeps the mapping in one
// place and makes it impossible to update one side without the other.
static const int torsoMirrorAnims[] = {
	ANIM_DEATH_AIR_LAND,
	ANIM_KNOCKBACK,
	ANIM_KNOCKBACK_HIT_WALL,
	ANIM_KNOCKBACK_RECOVER_1,
	ANIM_KNOCKBACK_RECOVER_2,
	ANIM_STUNNED_MELEE,
	ANIM_POWER_MELEE_1_CHARGE,
	ANIM_POWER_MELEE_2_CHARGE,
	ANIM_POWER_MELEE_3_CHARGE,
	ANIM_POWER_MELEE_4_CHARGE,
	ANIM_POWER_MELEE_5_CHARGE,
	ANIM_POWER_MELEE_6_CHARGE,
	ANIM_POWER_MELEE_1_HIT,
	ANIM_POWER_MELEE_2_HIT,
	ANIM_POWER_MELEE_3_HIT,
	ANIM_POWER_MELEE_4_HIT,
	ANIM_POWER_MELEE_5_HIT,
	ANIM_POWER_MELEE_6_HIT,
	ANIM_BREAKER_MELEE_HIT1,
	ANIM_BREAKER_MELEE_HIT2,
	ANIM_BREAKER_MELEE_HIT3,
	ANIM_BREAKER_MELEE_HIT4,
	ANIM_BREAKER_MELEE_HIT5,
	ANIM_BREAKER_MELEE_HIT6,
	ANIM_BREAKER_MELEE_ATTACK1,
	ANIM_BREAKER_MELEE_ATTACK2,
	ANIM_BREAKER_MELEE_ATTACK3,
	ANIM_BREAKER_MELEE_ATTACK4,
	ANIM_BREAKER_MELEE_ATTACK5,
	ANIM_BREAKER_MELEE_ATTACK6,
	ANIM_SPEED_MELEE_DODGE,
	ANIM_SPEED_MELEE_ATTACK,
	ANIM_SPEED_MELEE_BLOCK,
	ANIM_SPEED_MELEE_HIT,
	ANIM_RUN,
	ANIM_BACKRUN,
	ANIM_DASH_FORWARD,
	ANIM_DASH_BACKWARD,
	ANIM_DASH_RIGHT,
	ANIM_DASH_LEFT,
	ANIM_WALK,
	ANIM_BACKWALK,
	ANIM_SWIM_IDLE,
	ANIM_SWIM,
	ANIM_JUMP_UP,
	ANIM_JUMP_FORWARD,
	ANIM_JUMP_BACK,
	ANIM_LAND_UP,
	ANIM_LAND_FORWARD,
	ANIM_LAND_BACK,
	ANIM_STUNNED,
	ANIM_PUSH,
	ANIM_DEFLECT,
	ANIM_BLOCK,
	ANIM_KI_CHARGE,
	ANIM_PL_UP,
	ANIM_TRANS_UP,
	ANIM_TRANS_BACK,
	ANIM_FLY_IDLE,
	ANIM_FLY_START,
	ANIM_FLY_FORWARD,
	ANIM_FLY_BACKWARD,
	ANIM_FLY_UP,
	ANIM_FLY_DOWN,
	ANIM_IDLE,
	ANIM_FLOOR_RECOVER
};

/*
==============
PM_TorsoAnimation
==============
*/
void PM_TorsoAnimation(void){
	int legsAnim;
	int i;

	if(pm->ps->weaponstate != WEAPON_READY){return;}
	if(pm->ps->timers[tmImpede] || pm->ps->states & isBurning){PM_ContinueLegsAnim(ANIM_STUNNED);}
	if(pm->ps->states & isRiding){PM_ContinueLegsAnim(ANIM_KNOCKBACK);}
	if(pm->ps->bitFlags & usingBlock && !(pm->ps->bitFlags & usingMelee)){
		if(pm->ps->bitFlags & isStruggling){
			PM_ContinueTorsoAnim(ANIM_PUSH);
			PM_ContinueLegsAnim(ANIM_PUSH);
			return;
		}
		PM_ContinueTorsoAnim(ANIM_BLOCK);
		if(!pm->cmd.forwardmove && !pm->cmd.rightmove){
			PM_ContinueLegsAnim(ANIM_BLOCK);
		}
		return;
	}

	legsAnim = pm->ps->legsAnim & ~ANIM_TOGGLEBIT;
	for(i = 0; i < (int)(sizeof(torsoMirrorAnims) / sizeof(torsoMirrorAnims[0])); i++){
		if(torsoMirrorAnims[i] == legsAnim){
			PM_ContinueTorsoAnim(legsAnim);
			return;
		}
	}
	if(pm->ps->lockedTarget > 0){
		PM_ContinueTorsoAnim(ANIM_IDLE_LOCKED);
	}
	else{
		PM_ContinueTorsoAnim(ANIM_IDLE);
	}
}
