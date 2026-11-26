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
// bg_pmweapon.c -- weapon state machine

#include "../../Shared/q_shared.h"
#include "bg_public.h"
#include "bg_local.h"
#include "bg_userweapons.h"
#include "g_tiers.h"

// Weapon selection.

/*
===============
PM_BeginWeaponChange
===============
*/
void PM_BeginWeaponChange(int weapon){
	qboolean charging;
	qboolean usable;
	charging = (pm->ps->weaponstate == WEAPON_CHARGING || pm->ps->weaponstate == WEAPON_ALTCHARGING) ? qtrue : qfalse;
	if(pm->ps->weapon == pm->cmd.weapon){
		return;
	}
	if(weapon <= WP_NONE || weapon >= WP_NUM_WEAPONS){
		return;
	}
	if(pm->ps->stats[stMeleeState] || pm->ps->timers[tmTransform] || charging){
		return;
	}
	if(!(pm->ps->stats[stSkills] & (1 << weapon))){
		return;
	}

	if(pm->ps->weaponstate == WEAPON_DROPPING){
		return;
	}
	PM_AddEvent(EV_CHANGE_WEAPON);
	usable = qfalse;
	weapon = pm->cmd.weapon;
	while(!usable){
		if(weapon == 1 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL1){usable = qtrue;}
		if(weapon == 2 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL2){usable = qtrue;}
		if(weapon == 3 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL3){usable = qtrue;}
		if(weapon == 4 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL4){usable = qtrue;}
		if(weapon == 5 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL5){usable = qtrue;}
		if(weapon == 6 && pm->ps->powerups[PW_SKILLS] & USABLE_SKILL6){usable = qtrue;}
		if(!usable){
			if(pm->cmd.weapon < pm->ps->weapon){weapon -=1;}
			else if(pm->cmd.weapon > pm->ps->weapon){weapon +=1;}
			else{break;}
			if(weapon > 6){weapon = 1;}
			if(weapon < 1){weapon = 6;}
		}
	}
	pm->ps->weapon = weapon;
	pm->ps->timers[tmAttack1] = 0;
	pm->ps->timers[tmAttack2] = 0;
}

// Weapon firing and target lock-on.

/*==============
PM_Weapon
Generates weapon events and modifes the weapon counter
==============*/
void PM_WeaponRelease(void){
	if(pm->ps->bitFlags & isStruggling){return;}
	if(pm->ps->bitFlags & isGuiding){
		PM_AddEvent(EV_DETONATE_WEAPON);
		pm->ps->bitFlags &= ~isGuiding;
	}
	pm->ps->weaponstate = WEAPON_READY;
	pm->ps->stats[stChargePercentPrimary] = 0;
	pm->ps->stats[stChargePercentSecondary] = 0;
}
void PM_Weapon(void){
	int	*weaponInfo;
	int	*alt_weaponInfo;
	int chargeRate;
	int costPrimary,costSecondary;
	float energyScale;
	if(pm->ps->weaponstate != WEAPON_GUIDING){pm->ps->bitFlags &= ~isGuiding;}
	if(pm->ps->persistant[PERS_TEAM] == TEAM_SPECTATOR){return;}
	if(pm->ps->bitFlags & isStruggling || pm->ps->bitFlags & usingSoar
		|| pm->ps->bitFlags & isPreparing || pm->ps->timers[tmTransform] > 1 || pm->ps->bitFlags & usingMelee
		|| (pm->ps->lockedTarget && pm->ps->lockedPlayer->timers[tmKnockback] && VectorLength(pm->ps->velocity))){
		if(pm->ps->timers[tmTransform] > 1 || pm->ps->bitFlags & usingMelee){PM_WeaponRelease();}
		return;
	}
	if(pm->ps->bitFlags & isStruggling){return;}
	if(pm->ps->weapon == WP_NONE || pm->ps->bitFlags & usingMelee){
		PM_WeaponRelease();
		return;
	}
	if(pm->ps->lockedTarget && pm->ps->lockedPlayer->timers[tmKnockback] && VectorLength(pm->ps->velocity)){return;}
	if(pm->ps->pm_flags & PMF_ATTACK1_HELD){
		if(!(pm->cmd.buttons & BUTTON_ATTACK)){pm->ps->pm_flags &= ~PMF_ATTACK1_HELD;}
		else{return;}
	}
	if(pm->ps->pm_flags & PMF_ATTACK2_HELD){
		if(!(pm->cmd.buttons & BUTTON_ALT_ATTACK)){pm->ps->pm_flags &= ~PMF_ATTACK2_HELD;}
		else{return;}
	}
	// Retrieve our weapon's settings
	weaponInfo = pm->ps->currentSkill;
	if(weaponInfo[WPSTAT_BITFLAGS] & WPF_ALTWEAPONPRESENT){
		alt_weaponInfo = &weaponInfo[WPSTAT_ALT_POWERLEVELCOST];
	} else{
		alt_weaponInfo = weaponInfo;	 // Keep both sets the same.
		if(pm->cmd.buttons & BUTTON_ALT_ATTACK) {	// ifwe have no altfire,
			pm->cmd.buttons &= ~BUTTON_ALT_ATTACK;	// override ALT_ATTACK to ATTACK.
			pm->cmd.buttons |= BUTTON_ATTACK;
		}
	}
	if(weaponInfo[WPSTAT_NUMCHECK] != pm->ps->weapon){return;}
	costPrimary = weaponInfo[WPSTAT_POWERLEVELCOST];
	costSecondary = alt_weaponInfo[WPSTAT_POWERLEVELCOST];
	energyScale = (float)pm->ps->powerLevel[plCurrent] / (float)pm->ps->powerLevel[plMaximum];
	switch(pm->ps->weaponstate){
	case WEAPON_READY:
	case WEAPON_DROPPING:
	case WEAPON_RAISING:
	case WEAPON_COOLING:
		pm->ps->timers[tmAttackLife] = 0;
		if(pm->ps->weaponTime > 0){
			pm->ps->weaponTime -= pml.msec;
		}

		if(pm->ps->weaponTime > 0){
			break;
		} else{
			pm->ps->weaponTime = 0;
			pm->ps->weaponstate = WEAPON_READY;
		}
		if(pm->ps->weapon == pm->cmd.weapon){
			if(pm->cmd.buttons & BUTTON_ATTACK) {
				if(weaponInfo[WPSTAT_BITFLAGS] & WPF_NEEDSCHARGE){
					pm->ps->weaponstate = WEAPON_CHARGING;
					PM_StartTorsoAnim(ANIM_KI_ATTACK1_PREPARE + (pm->ps->weapon - 1) * 2 );
					break;
				}
				pm->ps->stats[stChargePercentPrimary] = 100;
				pm->ps->powerLevel[plUseFatigue] += costPrimary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
				if(weaponInfo[WPSTAT_BITFLAGS] & WPF_CONTINUOUS){
					PM_AddEvent(EV_FIRE_WEAPON );
					pm->ps->weaponstate = WEAPON_FIRING;
				} else{
					PM_AddEvent(EV_FIRE_WEAPON);
					pm->ps->weaponstate = WEAPON_COOLING;
					pm->ps->weaponTime += weaponInfo[WPSTAT_COOLTIME];
				}
				PM_StartTorsoAnim(ANIM_KI_ATTACK1_FIRE + (pm->ps->weapon - 1) * 2 );
				break;
			}
			if(pm->cmd.buttons & BUTTON_ALT_ATTACK){
				if(alt_weaponInfo[WPSTAT_BITFLAGS] & WPF_NEEDSCHARGE){
					pm->ps->weaponstate = WEAPON_ALTCHARGING;
					PM_StartTorsoAnim(ANIM_KI_ATTACK1_ALT_PREPARE + (pm->ps->weapon - 1) * 2 );
					break;
				}
				pm->ps->stats[stChargePercentSecondary] = 100;
				pm->ps->powerLevel[plUseFatigue] += costSecondary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
				if(alt_weaponInfo[WPSTAT_BITFLAGS] & WPF_CONTINUOUS){
					pm->ps->weaponstate = WEAPON_ALTFIRING;
					PM_AddEvent(EV_ALTFIRE_WEAPON );
				} else{
					pm->ps->weaponstate = WEAPON_COOLING;
					pm->ps->weaponTime += alt_weaponInfo[WPSTAT_COOLTIME];
					PM_AddEvent(EV_ALTFIRE_WEAPON );
				}
				PM_StartTorsoAnim(ANIM_KI_ATTACK1_ALT_FIRE + (pm->ps->weapon - 1) * 2 );
				break;
			}
		}
		else{
			PM_BeginWeaponChange(pm->cmd.weapon);
		}
		break;
	case WEAPON_GUIDING:
		if(pm->cmd.buttons & BUTTON_ATTACK && !(pm->ps->bitFlags & isStruggling) &&	pm->ps->timers[tmAttackLife] > 2000){
			PM_AddEvent(EV_DETONATE_WEAPON);
			pm->ps->weaponTime += weaponInfo[WPSTAT_COOLTIME];
			PM_StartTorsoAnim(ANIM_IDLE);
		}
		pm->ps->timers[tmAttackLife] += pml.msec;
		pm->ps->timers[tmImpede] = 100;
		break;
	case WEAPON_ALTGUIDING:
		if(pm->cmd.buttons & BUTTON_ALT_ATTACK && !(pm->ps->bitFlags & isStruggling) &&	pm->ps->timers[tmAttackLife] > 2000){
			PM_AddEvent(EV_DETONATE_WEAPON);
			pm->ps->weaponTime += alt_weaponInfo[WPSTAT_COOLTIME];
			PM_StartTorsoAnim(ANIM_IDLE);
		}
		pm->ps->timers[tmAttackLife] += pml.msec;
		pm->ps->timers[tmImpede] = 100;
		break;
	case WEAPON_CHARGING:
		chargeRate = (pm->ps->bitFlags & usingBoost) ? 2 : 1;
		pm->ps->timers[tmAttack1] += pml.msec;
		pm->ps->timers[tmImpede] = weaponInfo[WPSTAT_RESTRICT_MOVEMENT];
		if(pm->ps->timers[tmAttack1] >= weaponInfo[WPSTAT_CHRGTIME]){
			pm->ps->timers[tmAttack1] -= weaponInfo[WPSTAT_CHRGTIME];
			if(pm->ps->stats[stChargePercentPrimary] < 100){
				if(pm->ps->stats[stChargePercentPrimary] == 0 && pm->ps->bitFlags & usingBoost){
					pm->ps->stats[stChargePercentPrimary] = 25;
					costPrimary *= 25;
				}
				pm->ps->stats[stChargePercentPrimary] += chargeRate;
				if(pm->ps->stats[stChargePercentPrimary] > 100){
					pm->ps->stats[stChargePercentPrimary] = 100;
				}
				pm->ps->powerLevel[plUseFatigue] += costPrimary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
				pm->ps->powerLevel[plUseHealth] += weaponInfo[WPSTAT_HEALTHCOST] * ((float)pm->ps->powerLevel[plMaximum] * 0.0001) * pm->ps->baseStats[stEnergyAttackCost];
				pm->ps->powerLevel[plUseMaximum] += weaponInfo[WPSTAT_MAXIMUMCOST] * ((float)pm->ps->powerLevel[plMaximum] * 0.0001) * pm->ps->baseStats[stEnergyAttackCost];
			}
		}
		if(!(pm->cmd.buttons & BUTTON_ATTACK)) {
			pm->ps->timers[tmAttack1] = 0;
			if(weaponInfo[WPSTAT_BITFLAGS] & WPF_READY){
				weaponInfo[WPSTAT_BITFLAGS] &= ~WPF_READY;
				if(weaponInfo[WPSTAT_BITFLAGS] & WPF_GUIDED){
					pm->ps->weaponstate = WEAPON_GUIDING;
					pm->ps->bitFlags |= isGuiding;
				} else{
					pm->ps->weaponstate = WEAPON_COOLING;
					pm->ps->weaponTime += weaponInfo[WPSTAT_COOLTIME];
				}
				PM_AddEvent(EV_FIRE_WEAPON);
				PM_StartTorsoAnim(ANIM_KI_ATTACK1_FIRE + (pm->ps->weapon - 1) * 2 );
			} else{
				pm->ps->weaponTime = 0;
				pm->ps->weaponstate = WEAPON_READY;
				pm->ps->stats[stChargePercentPrimary] = 0;
				PM_StartTorsoAnim(ANIM_IDLE);
			}
		}
		break;
	case WEAPON_ALTCHARGING:
		chargeRate = (pm->ps->bitFlags & usingBoost) ? 2 : 1;
		pm->ps->timers[tmAttack2] += pml.msec;
		pm->ps->timers[tmImpede] = weaponInfo[WPSTAT_ALT_RESTRICT_MOVEMENT];
		if(pm->ps->timers[tmAttack2] >= weaponInfo[WPSTAT_ALT_CHRGTIME]){
			pm->ps->timers[tmAttack2] -= weaponInfo[WPSTAT_ALT_CHRGTIME];
			if(pm->ps->stats[stChargePercentSecondary] < 100){
				if(pm->ps->stats[stChargePercentPrimary] == 0 && pm->ps->bitFlags & usingBoost){
					pm->ps->stats[stChargePercentPrimary] = 25;
					costSecondary *= 25;
				}
				pm->ps->stats[stChargePercentSecondary] += chargeRate;
				if(pm->ps->stats[stChargePercentSecondary] > 100){
					pm->ps->stats[stChargePercentSecondary] = 100;
				}
				pm->ps->powerLevel[plUseFatigue] += costSecondary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
				pm->ps->powerLevel[plUseHealth] += weaponInfo[WPSTAT_ALT_HEALTHCOST] * ((float)pm->ps->powerLevel[plMaximum] * 0.0001);
				pm->ps->powerLevel[plUseMaximum] += weaponInfo[WPSTAT_ALT_MAXIMUMCOST] * ((float)pm->ps->powerLevel[plMaximum] * 0.0001);
			}
		}
		if(!(pm->cmd.buttons & BUTTON_ALT_ATTACK)) {
			if(alt_weaponInfo[WPSTAT_BITFLAGS] & WPF_READY){
				alt_weaponInfo[WPSTAT_BITFLAGS] &= ~WPF_READY;
				if(alt_weaponInfo[WPSTAT_BITFLAGS] & WPF_GUIDED){
					pm->ps->weaponstate = WEAPON_ALTGUIDING;
					pm->ps->bitFlags |= isGuiding;
				} else{
					pm->ps->weaponstate = WEAPON_COOLING;
					pm->ps->weaponTime += alt_weaponInfo[WPSTAT_COOLTIME];
				}
				PM_AddEvent(EV_ALTFIRE_WEAPON );
				PM_StartTorsoAnim(ANIM_KI_ATTACK1_ALT_FIRE + (pm->ps->weapon - 1) * 2 );
			} else{
				pm->ps->weaponTime = 0;
				pm->ps->weaponstate = WEAPON_READY;
				pm->ps->stats[stChargePercentSecondary] = 0;
				PM_StartTorsoAnim(ANIM_IDLE );
			}
		}
		break;
	case WEAPON_FIRING:
		if(!(pm->cmd.buttons & BUTTON_ATTACK)){
			pm->ps->weaponstate = WEAPON_COOLING;
			pm->ps->weaponTime += weaponInfo[WPSTAT_COOLTIME];
			PM_StartTorsoAnim(ANIM_IDLE );
			break;
		}
		pm->ps->weaponTime += pml.msec;
		while(pm->ps->weaponTime > 100){
			pm->ps->powerLevel[plUseFatigue] += costPrimary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
		}
		break;
	case WEAPON_ALTFIRING:
		if(!(pm->cmd.buttons & BUTTON_ALT_ATTACK)){
			pm->ps->weaponstate = WEAPON_COOLING;
			pm->ps->weaponTime += alt_weaponInfo[WPSTAT_COOLTIME];
			PM_StartTorsoAnim(ANIM_IDLE );
			break;
		}
		pm->ps->weaponTime += pml.msec;
		while(pm->ps->weaponTime > 100){
			pm->ps->powerLevel[plUseFatigue] += costSecondary * pm->ps->baseStats[stEnergyAttackCost] * energyScale;
		}
		break;
	default:
		break;
	}
}
/*================
PM_CheckLockon
================*/
void PM_StopLockon(void){
	if(pm->ps->lockedTarget>0){
		pm->ps->lockedPlayer->bitFlags &= ~isTargeted;
		PM_AddEvent(EV_LOCKON_END);
	}
	pm->ps->lockedPosition = NULL;
	pm->ps->lockedTarget = 0;
}
void PM_CheckLockon(void){
	int	lockBox;
	trace_t	trace;
	vec3_t minSize,maxSize,forward,end;
	if(pm->ps->lockedTarget > 0){
		pm->ps->lockedPlayerData[lkPowerCurrent] = pm->ps->lockedPlayer->powerLevel[plCurrent];
		pm->ps->lockedPlayerData[lkPowerHealth] = pm->ps->lockedPlayer->powerLevel[plHealth];
		pm->ps->lockedPlayerData[lkPowerMaximum] = pm->ps->lockedPlayer->powerLevel[plMaximum];
		pm->ps->lockedPlayer->bitFlags |= isTargeted;
	}
	if(pm->cmd.buttons & BUTTON_GESTURE && pm->ps->stats[stMeleeState] == 0){
		if(pm->ps->pm_flags & PMF_LOCK_HELD){return;}
		pm->ps->pm_flags |= PMF_LOCK_HELD;
		if(pm->ps->lockedTarget>0){
			PM_StopLockon();
			return;
		}
		AngleVectors(pm->ps->viewangles,forward,NULL,NULL);
		VectorMA(pm->ps->origin,131072,forward,end);
		lockBox = 250;
		minSize[0] = -lockBox;
		minSize[1] = -lockBox;
		minSize[2] = -lockBox;
		maxSize[0] = -minSize[0];
		maxSize[1] = -minSize[1];
		maxSize[2] = -minSize[2];
		pm->trace(&trace,pm->ps->origin,minSize,maxSize,end,pm->ps->clientNum,CONTENTS_BODY);
		if((trace.entityNum >= MAX_CLIENTS)){return;}
		PM_AddEvent(EV_LOCKON_START);
		pm->ps->lockedTarget = trace.entityNum+1;
	}
	else{
		pm->ps->pm_flags &= ~PMF_LOCK_HELD;
	}
}

