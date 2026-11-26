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
// bg_pmmelee.c -- melee state machine

#include "../../Shared/q_shared.h"
#include "bg_public.h"
#include "bg_local.h"
#include "bg_userweapons.h"
#include "g_tiers.h"

// Blocking and struggling checks (melee defence).

/*==================
PM_CheckStruggling
==================*/
void PM_CheckStruggling(void){
	if(pm->ps->bitFlags & isStruggling){
		PM_StopMovement();
		pm->ps->timers[tmFreeze] = 100;
		if(pm->ps->bitFlags & usingBoost){
			pm->ps->powerLevel[plUseFatigue] += pm->ps->powerLevel[plMaximum] * 0.002;
		}else{
			pm->ps->powerLevel[plUseFatigue] += pm->ps->powerLevel[plMaximum] * 0.001;
		}
	}
}

/*=============
PM_CheckBlock
=============*/
void PM_CheckBlock(void){
	pm->ps->bitFlags &= ~usingBlock;
	if((pm->cmd.buttons & BUTTON_BLOCK)
		&& !(pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING)
		&& !(pm->ps->bitFlags & usingAlter)
		&& !(pm->ps->bitFlags & usingSoar)
		&& !(pm->ps->bitFlags & usingZanzoken)
		&& !(pm->ps->bitFlags & usingWeapon)
		&& !(pm->ps->bitFlags & isStruggling)
		&& !(pm->ps->bitFlags & isGuiding)
		&& !(pm->ps->bitFlags & isPreparing)){
		pm->ps->bitFlags |= usingBlock;
	}
}

// The melee state machine.

/*=============================================*\
    Amazin' Melee (now with 99% more strategy!)
\*=============================================*/
void PM_StopMelee(void){
	if(pm->ps->bitFlags & usingMelee || pm->ps->stats[stMeleeState]){
		pm->ps->stats[stMeleeState] = 0;
		pm->ps->timers[tmMeleeCharge] = 0;
		pm->ps->timers[tmMeleeIdle] = 0;
		pm->ps->timers[tmMeleeBreaker] = 0;
		pm->ps->bitFlags &= ~usingMelee;
		PM_AddEvent(EV_STOPLOOPINGSOUND);
		PM_EndDrift();
		if(pm->ps->lockedPlayer){
			pm->ps->lockedPlayer->stats[stMeleeState] = 0;
			pm->ps->lockedPlayer->timers[tmMeleeCharge] = 0;
			pm->ps->lockedPlayer->timers[tmMeleeIdle] = 0;
			pm->ps->lockedPlayer->timers[tmMeleeBreaker] = 0;
			pm->ps->lockedPlayer->powerups[PW_DRIFTING] = 0;
			pm->ps->lockedPlayer->bitFlags &= ~usingMelee;
		}
	}
}
void PM_CheckDrift(void){
	if(!pm->ps->lockedPlayer->powerups[PW_DRIFTING] && pm->ps->stats[stMeleeState] & stMeleeUsingSpeed){
		pm->ps->powerups[PW_DRIFTING] = 1;
		pm->ps->lockedPlayer->powerups[PW_DRIFTING] = 2;
	}
}
void PM_EndDrift(void){
	pm->ps->powerups[PW_DRIFTING] = 0;
	if(pm->ps->lockedTarget > 0){pm->ps->lockedPlayer->powerups[PW_DRIFTING] = 0;}
}
void PM_StopDrift(void){
	if(pm->ps->powerups[PW_DRIFTING] == 1){PM_EndDrift();}
}
void PM_SyncMelee(void){
	if(pm->ps->lockedPlayer->bitFlags & usingZanzoken || pm->ps->lockedPlayer->bitFlags & usingZanzoken){return;}
	pm->ps->pm_flags |= PMF_ATTACK1_HELD;
	pm->ps->pm_flags |= PMF_ATTACK2_HELD;
	pm->ps->bitFlags |= usingMelee;
	pm->ps->bitFlags |= usingFlight;
	pm->ps->timers[tmUpdateMelee] = 300;
	pm->ps->lockedPlayer->timers[tmUpdateMelee] = 300;
	pm->ps->lockedPlayer->bitFlags |= usingMelee;
	pm->ps->lockedPlayer->bitFlags |= usingFlight;
	pm->ps->lockedPlayer->weaponstate = WEAPON_READY;
	if(pm->ps->lockedPlayer->stats[stMeleeState] == 0){
		pm->ps->lockedPlayer->pm_flags |= PMF_ATTACK1_HELD;
		pm->ps->lockedPlayer->pm_flags |= PMF_ATTACK2_HELD;
		pm->ps->lockedPlayer->lockedTarget = pm->ps->clientNum + 1;
		pm->ps->lockedPlayer->lockedPlayer = 0;
	}
}
void PM_MeleeIdle(void){
	pm->ps->timers[tmMeleeIdle] += pml.msec;
	if(pm->ps->timers[tmMeleeIdle] > 1500 && pm->ps->lockedPlayer->timers[tmMeleeIdle] > 1500){
		pm->ps->powerups[PW_DRIFTING] = 2;
		pm->ps->lockedPlayer->powerups[PW_DRIFTING] = 2;
	}
}
/*
 * One context object is passed through the melee stages so that event order,
 * damage and state transitions stay identical to the original monolith.
 */
typedef struct meleeCmd_s {
	int state, enemyState, damage, distance, animation, direction, meleeCharge;
	qboolean enemyDefense;
} meleeCmd_t;

static const int powerMeleeAnims[2][7] = {
	{ 0, ANIM_POWER_MELEE_1_CHARGE, ANIM_POWER_MELEE_2_CHARGE, ANIM_POWER_MELEE_3_CHARGE,
		ANIM_POWER_MELEE_4_CHARGE, ANIM_POWER_MELEE_5_CHARGE, ANIM_POWER_MELEE_6_CHARGE },
	{ 0, ANIM_POWER_MELEE_1_HIT, ANIM_POWER_MELEE_2_HIT, ANIM_POWER_MELEE_3_HIT,
		ANIM_POWER_MELEE_4_HIT, ANIM_POWER_MELEE_5_HIT, ANIM_POWER_MELEE_6_HIT }
};
static const int breakerAnims[2][7] = {
	{ 0, ANIM_BREAKER_MELEE_HIT1, ANIM_BREAKER_MELEE_HIT2, ANIM_BREAKER_MELEE_HIT3,
		ANIM_BREAKER_MELEE_HIT4, ANIM_BREAKER_MELEE_HIT5, ANIM_BREAKER_MELEE_HIT6 },
	{ 0, ANIM_BREAKER_MELEE_ATTACK1, ANIM_BREAKER_MELEE_ATTACK2, ANIM_BREAKER_MELEE_ATTACK3,
		ANIM_BREAKER_MELEE_ATTACK4, ANIM_BREAKER_MELEE_ATTACK5, ANIM_BREAKER_MELEE_ATTACK6 }
};
static const int powerDirIndex[5] = { 0, 4, 2, 6, 5 };

static int PM_PowerMeleeAnim(int direction,qboolean boosting,qboolean hit){
	int index = direction >= 1 && direction <= 4 ? powerDirIndex[direction] : (boosting ? 3 : 1);
	return powerMeleeAnims[hit ? 1 : 0][index];
}
static int PM_BreakerAnim(int breaker,qboolean attack){
	return breaker >= 1 && breaker <= 6 ? breakerAnims[attack ? 1 : 0][breaker] : 0;
}
static void PM_MeleePairTimer(int timer,int self,int enemy){
	pm->ps->timers[timer] = self;
	pm->ps->lockedPlayer->timers[timer] = enemy;
}
static void PM_MeleeSetDrift(int self,int enemy){
	pm->ps->powerups[PW_DRIFTING] = self;
	pm->ps->lockedPlayer->powerups[PW_DRIFTING] = enemy;
}
static void PM_MeleeDamage(meleeCmd_t *m,float health,float maximum,qboolean assign){
	pm->ps->powerLevel[plHealthPool] += m->damage*health;
	pm->ps->powerLevel[plMaximumPool] += m->damage*maximum;
	if(assign){pm->ps->lockedPlayer->powerLevel[plDamageFromMelee] = m->damage;}
	else{pm->ps->lockedPlayer->powerLevel[plDamageFromMelee] += m->damage;}
}
static void PM_MeleeClash(void){
	PM_AddEvent(EV_MELEE_KNOCKBACK);
	PM_MeleePairTimer(tmFreeze,500,500);
	PM_MeleePairTimer(tmMeleeIdle,-480,-480);
}
static void PM_MeleeBreakerHit(meleeCmd_t *m,qboolean charge){
	PM_EndDrift();
	PM_AddEvent(EV_MELEE_BREAKER);
	m->enemyState = stMeleeIdle;
	PM_MeleePairTimer(tmFreeze,100,500);
	PM_MeleeDamage(m,0.5f,0.3f,qtrue);
	if(charge){pm->ps->lockedPlayer->timers[tmMeleeCharge] = 0;}
}
static void PM_MeleeKnockback(meleeCmd_t *m){
	pm->ps->lockedPlayer->powerups[PW_KNOCKBACK_SPEED] = (pm->ps->powerLevel[plCurrent]/21.84)+pm->ps->stats[stKnockbackPower];
	if(pm->ps->lockedPlayer->timers[tmKnockback]){pm->ps->lockedPlayer->powerups[PW_KNOCKBACK_SPEED] *= 2;}
	if(pm->ps->bitFlags & usingBoost){
		m->damage *= 1.5;
		pm->ps->lockedPlayer->powerups[PW_KNOCKBACK_SPEED] *= 1.8;
	}
	pm->ps->lockedPlayer->timers[tmKnockback] = 5000;
	PM_StopMelee();
}
static void PM_MeleeBreakCharge(meleeCmd_t *m,qtime_t *random,int breaker){
	if(!pm->ps->timers[tmMeleeBreakerWait]){
		pm->ps->timers[tmMeleeBreaker] = breaker;
		pm->ps->timers[tmMeleeBreakerWait] = 500;
		pm->ps->stats[stAnimState] = (Q_random(&random->tm_sec)*5)+1;
	}
	m->meleeCharge = 0;
}
static void PM_MeleeCharge(meleeCmd_t *m,int state,int maximum,qboolean direction){
	if(direction){
		m->direction = 5;
		if(pm->cmd.upmove > 0){m->direction = 1;}
		else if(pm->cmd.upmove < 0){m->direction = 2;}
		else if(pm->cmd.rightmove > 0){m->direction = 3;}
		else if(pm->cmd.rightmove < 0){m->direction = 4;}
		pm->ps->lockedPlayer->knockBackDirection = m->direction;
	}
	m->state = state;
	m->meleeCharge += pml.msec;
	if(m->meleeCharge >= maximum){m->meleeCharge = maximum;}
}

static qboolean PM_MeleeSetup(meleeCmd_t *m,qboolean charging){
	m->distance = 9000;
	pm->ps->timers[tmUpdateMelee] += pml.msec;
	if(pm->ps->lockedTarget <= 0 || charging){PM_StopMelee(); return qfalse;}
	if(pm->ps->timers[tmUpdateMelee] >= 300){
		pm->ps->timers[tmUpdateMelee] = 0;
		PM_AddEvent(EV_MELEE_CHECK);
	}
	if((pm->ps->bitFlags & usingZanzoken) || (pm->ps->lockedPlayer && (pm->ps->lockedPlayer->bitFlags & usingZanzoken))){
		PM_StopMelee();
		return qfalse;
	}
	if(pm->ps->lockedPlayer){
		m->distance = Distance(pm->ps->origin,*(pm->ps->lockedPosition));
		if(!(pm->ps->bitFlags & usingMelee)){
			m->state = pm->cmd.forwardmove > 0 ? stMeleeAggressing : (pm->cmd.forwardmove < 0 ? stMeleeDegressing : stMeleeInactive);
		}
		if(pm->ps->lockedPlayer->bitFlags & (isDead|isUnconcious|isCrashed)){
			PM_StopMelee();
			PM_StopLockon();
			return qfalse;
		}
		if(m->state != stMeleeIdle){pm->ps->timers[tmMeleeIdle] = 0;}
		if(m->distance > 64 && pm->ps->bitFlags & usingMelee){PM_StopMelee();}
	}
	return qtrue;
}

static qboolean PM_MeleeBreaker(meleeCmd_t *m){
	qboolean active = pm->ps->timers[tmMeleeBreaker] ? qtrue : qfalse;
	if(pm->ps->timers[tmMeleeBreakerWait]){
		pm->ps->timers[tmMeleeBreakerWait] -= pml.msec;
		if(pm->ps->timers[tmMeleeBreakerWait] < 0){pm->ps->timers[tmMeleeBreakerWait] = 0;}
	}
	if(!active){return qfalse;}
	m->damage = (pm->ps->powerLevel[plCurrent]*0.05)*pm->ps->stats[stMeleeAttack];
	if(pm->ps->timers[tmMeleeBreaker] > 0){
		m->state = stMeleeUsingChargeBreaker;
		if(m->enemyState == stMeleeUsingSpeed){
			pm->ps->timers[tmFreeze] = 950;
			pm->ps->powerLevel[plUseFatigue] = m->damage;
			m->state = stMeleeIdle;
		}
		else if(pm->ps->lockedPlayer->timers[tmMeleeBreaker]){PM_MeleeClash();}
		else if(m->enemyState != stMeleeUsingEvade){PM_MeleeBreakerHit(m,qtrue);}
	}
	else{
		m->state = stMeleeUsingSpeedBreaker;
		if(pm->ps->lockedPlayer->timers[tmMeleeCharge]){
			pm->ps->timers[tmFreeze] = 300;
			pm->ps->lockedPlayer->timers[tmMeleeCharge] = 1000;
			m->state = stMeleeIdle;
		}
		else if(pm->ps->lockedPlayer->timers[tmMeleeBreaker]){PM_MeleeClash();}
		else if(m->enemyState != stMeleeUsingBlock){PM_MeleeBreakerHit(m,qfalse);}
	}
	pm->ps->timers[tmMeleeBreaker] = 0;
	return qtrue;
}

static void PM_MeleePower(meleeCmd_t *m,qtime_t *random){
	if((m->state == stMeleeChargingPower || m->state == stMeleeStartPower) && (!(pm->cmd.buttons & BUTTON_ALT_ATTACK) || m->meleeCharge >= 550)){
		if(m->meleeCharge < 550){PM_MeleeBreakCharge(m,random,1); return;}
		m->damage = 0;
		pm->ps->timers[tmFreeze] = 1000;
		PM_EndDrift();
		pm->ps->powerLevel[plUseFatigue] += pm->ps->powerLevel[plMaximum]*0.05;
		if(pm->ps->lockedPlayer->timers[tmMeleeCharge] > 50){
			PM_MeleePairTimer(tmMeleeIdle,-480,-480);
			PM_AddEvent(EV_MELEE_KNOCKBACK);
			PM_StopMelee();
		}
		else if(m->enemyState != stMeleeUsingEvade){
			m->damage = (pm->ps->powerLevel[plCurrent]*0.15)*pm->ps->stats[stMeleeAttack];
			if(m->enemyState == stMeleeUsingBlock){m->damage *= 0.3;}
			if(m->state != stMeleeStartPower){PM_AddEvent(EV_MELEE_KNOCKBACK);}
		}
		else{
			pm->ps->powerLevel[plUseFatigue] = m->damage*0.8;
			pm->ps->lockedPlayer->powerLevel[plUseFatigue] = m->damage*0.4;
		}
		if(m->enemyState != stMeleeUsingBlock && m->enemyState != stMeleeUsingEvade){PM_MeleeKnockback(m);}
		PM_MeleeDamage(m,1.0f,0.8f,qfalse);
		m->state = stMeleeUsingPower;
		m->meleeCharge = 0;
	}
	else{PM_MeleeCharge(m,stMeleeChargingPower,550,qtrue);}
}
static void PM_MeleeStun(meleeCmd_t *m,qtime_t *random){
	if(m->state == stMeleeChargingStun && (!(pm->cmd.buttons & BUTTON_ATTACK) || m->meleeCharge >= 1000)){PM_MeleeBreakCharge(m,random,-1);}
	else{PM_MeleeCharge(m,stMeleeChargingStun,1000,qfalse);}
}

static void PM_MeleeStart(meleeCmd_t *m){
	m->meleeCharge = 0;
	if(pm->ps->bitFlags & usingMelee || pm->ps->lockedPlayer->bitFlags & usingMelee || pm->ps->bitFlags & isStruggling || pm->ps->lockedPlayer->bitFlags & isStruggling){return;}
	m->state = stMeleeStartAttack;
	PM_MeleePairTimer(tmFreeze,1000,1000);
	PM_SyncMelee();
	if(m->enemyState == stMeleeAggressing){
		PM_MeleeSetDrift(0,0);
		PM_AddEvent(EV_MELEE_BREAKER);
		m->enemyState = stMeleeStartAttack;
	}
	else if(pm->ps->lockedPlayer->bitFlags & usingBlock || m->enemyState == stMeleeDegressing){
		PM_MeleeSetDrift(1,2);
		m->enemyState = stMeleeStartDodge;
		PM_AddEvent(EV_MELEE_BREAKER);
		pm->ps->powerLevel[plUseFatigue] = pm->ps->powerLevel[plMaximum]*0.10;
	}
	else if(pm->ps->lockedPlayer->timers[tmKnockback]){
		m->state = stMeleeChargingPower;
		m->meleeCharge = 750;
		PM_MeleePairTimer(tmFreeze,300,300);
		pm->ps->lockedPlayer->knockBackDirection = 2;
	}
	else if(pm->ps->timers[tmBoost] > 2500){
		m->state = stMeleeStartPower;
		m->enemyState = stMeleeStartHit;
		m->meleeCharge = 750;
		PM_MeleePairTimer(tmFreeze,1000,1000);
		pm->ps->lockedPlayer->knockBackDirection = 5;
		PM_AddEvent(EV_MELEE_KNOCKBACK);
	}
	else{
		PM_MeleeSetDrift(1,2);
		if(pm->ps->timers[tmBoost]){
			PM_MeleePairTimer(tmFreeze,0,0);
			m->state = stMeleeUsingSpeed;
		}
		else{
			pm->ps->lockedPlayer->timers[tmFreeze] = 2500;
			m->enemyState = stMeleeStartHit;
			PM_AddEvent(EV_MELEE_KNOCKBACK);
		}
	}
}
static void PM_MeleeSpeed(meleeCmd_t *m){
	m->damage = (pm->ps->powerLevel[plFatigue]*0.013)*pm->ps->stats[stMeleeAttack];
	if(pm->ps->powerups[PW_DRIFTING] == 1){m->damage *= 1.2;}
	if(pm->ps->bitFlags & usingBoost){m->damage *= 1.5;}
	pm->ps->timers[tmMeleeSpeed] += pml.msec;
	if(pm->ps->timers[tmMeleeSpeed] >= 100){
		if(m->enemyState == stMeleeUsingBlock){m->damage *= 0.2;}
		if(m->enemyState == stMeleeUsingEvade){
			pm->ps->powerLevel[plUseFatigue] += m->damage*0.5;
			m->damage = 0;
		}
		if(pm->ps->lockedPlayer->powerLevel[plHealth] > m->damage){PM_MeleeDamage(m,0.7f,0.5f,qfalse);}
		else{pm->ps->lockedPlayer->powerLevel[plUseFatigue] += m->damage;}
		pm->ps->timers[tmMeleeSpeed] -= 100;
	}
	m->state = stMeleeUsingSpeed;
}
static void PM_MeleeAdvance(meleeCmd_t *m){
	if(pm->cmd.forwardmove > 0){
		if(pm->ps->bitFlags & usingMelee || pm->ps->lockedPlayer->bitFlags & usingMelee){PM_MeleeSpeed(m);}
		else{PM_MeleeStart(m);}
	}
	else if(pm->cmd.forwardmove < 0){
		if(pm->ps->lockedPlayer->timers[tmFreeze] > 0 || m->enemyDefense){PM_StopMelee();}
		else{m->state = stMeleeUsingEvade;}
		PM_MeleeIdle();
	}
	else{
		m->meleeCharge = 0;
		m->state = pm->ps->bitFlags & usingBlock ? stMeleeUsingBlock : stMeleeIdle;
		PM_MeleeIdle();
		if(m->state == stMeleeUsingBlock && m->enemyDefense){PM_StopMelee();}
	}
}

static void PM_MeleeSpeedAnim(meleeCmd_t *m){
	if(m->state == stMeleeUsingSpeed){
		m->animation = ANIM_SPEED_MELEE_ATTACK;
		if(m->enemyState != stMeleeUsingEvade){PM_AddEvent(EV_MELEE_SPEED);}
	}
	else if(m->state == stMeleeUsingBlock){m->animation = ANIM_SPEED_MELEE_BLOCK;}
	else if(m->state == stMeleeUsingEvade){m->animation = ANIM_SPEED_MELEE_DODGE; PM_AddEvent(EV_MELEE_MISS);}
	else if(m->state != stMeleeChargingPower && m->state != stMeleeChargingStun){m->animation = ANIM_SPEED_MELEE_HIT;}
}
static void PM_MeleeAnimate(meleeCmd_t *m){
	qboolean enemyChanged,attack;
	int anim;
	enemyChanged = pm->ps->lockedPlayer->stats[stMeleeState] == m->enemyState ? qfalse : qtrue;
	if(pm->ps->lockedPlayer->lockedTarget != pm->ps->clientNum+1 && !enemyChanged){m->enemyState = -1;}
	if((pm->ps->lockedPlayer->timers[tmKnockback] || pm->ps->lockedPlayer->timers[tmFreeze]) && !enemyChanged){m->enemyState = -1;}
	if(!m->state){return;}
	if(m->state == stMeleeStartAttack){m->animation = ANIM_BREAKER_MELEE_ATTACK1;}
	if(m->state == stMeleeStartHit){m->animation = ANIM_BREAKER_MELEE_HIT1;}
	if(m->state == stMeleeStartDodge){m->animation = ANIM_BLOCK;}
	if(m->state == stMeleeUsingSpeed || m->enemyState == stMeleeUsingSpeed){PM_MeleeSpeedAnim(m);}
	if(m->state == stMeleeUsingPower || m->state == stMeleeStartPower || m->enemyState == stMeleeUsingPower || m->enemyState == stMeleeStartPower){
		if(m->state == stMeleeUsingPower || m->state == stMeleeStartPower){
			m->animation = PM_PowerMeleeAnim(pm->ps->lockedPlayer->knockBackDirection,(pm->ps->bitFlags & usingBoost) && m->state != stMeleeStartPower,qtrue);
		}
		else if(m->state == stMeleeUsingBlock){m->animation = ANIM_BLOCK;}
	}
	if(m->state == stMeleeUsingStun || m->enemyState == stMeleeUsingStun){
		if(m->state == stMeleeUsingStun){m->animation = ANIM_POWER_MELEE_3_HIT;}
		else if(m->state == stMeleeUsingBlock){m->animation = ANIM_BLOCK;}
		else{m->animation = ANIM_STUNNED_MELEE;}
	}
	if(m->state == stMeleeChargingPower){
		m->animation = PM_PowerMeleeAnim(pm->ps->lockedPlayer->knockBackDirection,pm->ps->bitFlags & usingBoost,qfalse);
	}
	if(m->state == stMeleeChargingStun){m->animation = ANIM_POWER_MELEE_1_CHARGE;}
	if(m->state == stMeleeUsingSpeedBreaker || m->enemyState == stMeleeUsingSpeedBreaker || m->state == stMeleeUsingChargeBreaker || m->enemyState == stMeleeUsingChargeBreaker){
		attack = m->state == stMeleeUsingSpeedBreaker || m->state == stMeleeUsingChargeBreaker;
		anim = PM_BreakerAnim(attack ? pm->ps->stats[stAnimState] : pm->ps->lockedPlayer->stats[stAnimState],attack);
		if(anim){m->animation = anim;}
	}
}

void PM_Melee(void){
	meleeCmd_t m;
	qtime_t realRandom;
	trap_RealTime(&realRandom);
	if(pm->ps->persistant[PERS_TEAM] == TEAM_SPECTATOR || pm->ps->bitFlags & isStruggling || pm->ps->timers[tmMeleeIdle] < 0){return;}
	m.state = pm->ps->stats[stMeleeState];
	m.damage = 0;
	m.animation = pm->ps->bitFlags & usingMelee ? ANIM_FLY_IDLE : 0;
	m.meleeCharge = pm->ps->timers[tmMeleeCharge];
	if(!PM_MeleeSetup(&m,pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING)){return;}
	m.enemyState = pm->ps->lockedPlayer->stats[stMeleeState];
	m.enemyDefense = m.enemyState == stMeleeUsingEvade || m.enemyState == stMeleeUsingBlock ? qtrue : qfalse;
	if(m.distance <= 64 && !pm->ps->timers[tmFreeze]){
		PM_CheckDrift();
		if(m.state != stMeleeStartAttack && m.state != stMeleeUsingSpeed){PM_StopDrift();}
		if(!PM_MeleeBreaker(&m)){
			if(m.state == stMeleeChargingPower || m.state == stMeleeStartPower || pm->cmd.buttons & BUTTON_ALT_ATTACK){PM_MeleePower(&m,&realRandom);}
			else if(m.state == stMeleeChargingStun || pm->cmd.buttons & BUTTON_ATTACK){PM_MeleeStun(&m,&realRandom);}
			else{PM_MeleeAdvance(&m);}
		}
	}
	PM_MeleeAnimate(&m);
	if(m.animation){PM_ContinueLegsAnim(m.animation);}
	if(m.enemyState != -1){pm->ps->lockedPlayer->stats[stMeleeState] = m.enemyState;}
	pm->ps->stats[stMeleeState] = m.state;
	pm->ps->timers[tmMeleeCharge] = m.meleeCharge;
	if(m.distance <= 64){pm->cmd.rightmove = 0;}
}
