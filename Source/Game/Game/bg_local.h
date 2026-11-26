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
// bg_local.h -- local definitions for the bg (both games) files

#define	MIN_WALK_NORMAL	0.7f		// can't walk on very steep slopes

#define	STEPSIZE		18

#define	JUMP_VELOCITY	1000
#define POWERJUMP_TIME 2500

#define	TIMER_LAND		130
#define	TIMER_GESTURE	(34*66+50)

#define	OVERCLIP		1.001f

// all of the locals will be zeroed before each
// pmove, just to make damn sure we don't have
// any differences when running on client or server
typedef struct {
	vec3_t		forward, right, up;
	float		frametime;
	int			msec;
	qboolean	onGround;
	qboolean	groundPlane;
	trace_t		groundTrace;
	float		impactSpeed;
	vec3_t		previous_origin;
	vec3_t		previous_velocity;
	int			previous_waterlevel;
	// -->
} pml_t;

extern	pmove_t		*pm;
extern	pml_t		pml;

// movement parameters
extern	float	pm_stopspeed;
extern	float	pm_swimScale;

extern	float	pm_accelerate;
extern	float	pm_airaccelerate;
extern	float	pm_wateraccelerate;
extern	float	pm_flyaccelerate;
extern	float	pm_dashaccelerate;

extern	float	pm_friction;
extern	float	pm_waterfriction;
extern	float	pm_flightfriction;

extern	int		c_pmove;

// Shared pmove code calls this through the module's syscall table.  Each game
// module provides its own implementation (g/cgame/ui syscalls).
int trap_RealTime( qtime_t *qtime );

qboolean	PM_SlideMove( qboolean gravity );
void		PM_StepSlideMove( qboolean gravity );

// Pmove is split across bg_pmove.c and the bg_pm*.c translation units.  Keep
// every cross-module entry point here so the pieces stay source compatible
// with the game, cgame and standalone harness builds.
void	PM_AddEvent( int newEvent );
void	PM_AddTouchEnt( int entityNum );
void	PM_ClipVelocity( vec3_t in, vec3_t normal, vec3_t out, float overbounce );

// animation
void	PM_StartTorsoAnim( int anim );
void	PM_StartLegsAnim( int anim );
void	PM_ContinueTorsoAnim( int anim );
void	PM_ContinueLegsAnim( int anim );
void	PM_ForceTorsoAnim( int anim );
void	PM_ForceLegsAnim( int anim );
void	PM_TorsoAnimation( void );

// status, power levels and transformation
void	PM_Freeze( void );
void	PM_Impede( void );
void	PM_Ride( void );
void	PM_Burn( void );
void	PM_Blind( void );
void	PM_CheckLoopingSound( void );
void	PM_StopKnockback( void );
void	PM_StopDirections( void );
void	PM_CheckKnockback( void );
void	PM_Crash( qboolean vertical );
void	PM_CheckTalk( void );
void	PM_StopZanzoken( void );
void	PM_CheckZanzoken( void );
void	PM_UsePowerLevel( void );
void	PM_BurnPowerLevel( void );
void	PM_CheckCrash( void );
void	PM_CheckStatus( void );
qboolean PM_CheckTransform( void );
void	PM_CheckPowerLevel( void );
void	PM_CheckHover( void );

// movement
void	PM_StopBoost( void );
void	PM_StopDash( void );
void	PM_StopMovementTypes( void );
void	PM_StopMovement( void );
void	PM_CheckBoost( void );
void	PM_Friction( void );
void	PM_Accelerate( vec3_t wishdir, float wishspeed, float accel );
float	PM_CmdScale( usercmd_t *cmd );
void	PM_NotOnGround( void );
void	PM_StopJump( void );
void	PM_CheckJump( void );
void	PM_StopSoar( void );
void	PM_StopFlight( void );
void	PM_FlyMove( void );
void	PM_AirMove( void );
void	PM_WalkMove( void );
void	PM_DashMove( void );
void	PM_NoclipMove( void );
int		PM_FootstepForSurface( void );
void	PM_Land( void );
int		PM_CorrectAllSolid( trace_t *trace );
int		PM_CheckDirection( vec3_t direction, qboolean player );
void	PM_GroundTraceMissed( void );
void	PM_NotNearGround( void );
void	PM_NearGroundTrace( void );
void	PM_GroundTrace( void );
void	PM_SetWaterLevel( void );
void	PM_SetView( void );
void	PM_Footsteps( void );
void	PM_WaterEvents( void );
void	PM_DropTimers( void );

// melee
void	PM_CheckStruggling( void );
void	PM_CheckBlock( void );
void	PM_StopMelee( void );
void	PM_CheckDrift( void );
void	PM_EndDrift( void );
void	PM_StopDrift( void );
void	PM_SyncMelee( void );
void	PM_MeleeIdle( void );
void	PM_Melee( void );

// weapons and target lock
void	PM_BeginWeaponChange( int weapon );
void	PM_WeaponRelease( void );
void	PM_Weapon( void );
void	PM_StopLockon( void );
void	PM_CheckLockon( void );


