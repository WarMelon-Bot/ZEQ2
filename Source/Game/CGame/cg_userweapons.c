// Copyright (C) 2003-2004 RiO
//
// cg_userweapons.c -- Clientside custom weapons database and parser functions.
//                     Contains the actual loading of the clientside files, and
//                     of the both games files. Passes the pointer to the loaded
//                     string of the latter to bg_userweapons.c. 

#include "cg_local.h"


static cg_userWeapon_t		weaponGraphicsDatabase[MAX_CLIENTS][ALTSPAWN_OFFSET + MAX_PLAYERWEAPONS];
							// * 2 because we also have alternate fires possible for each
							// weapon!

cg_userWeapon_t *CG_FindUserWeaponGraphics( int clientNum, int index ) {
	static cg_userWeapon_t emptyWeaponGraphics;
	const int maxIndex = ALTSPAWN_OFFSET + MAX_PLAYERWEAPONS;

	// clientNum and weapon/index arrive in snapshots/events from the
	// server.  Never use them as unchecked array indexes.
	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ||
	     index < 1 || index > maxIndex ) {
		Com_Memset( &emptyWeaponGraphics, 0, sizeof( emptyWeaponGraphics ) );
		return &emptyWeaponGraphics;
	}
	return &weaponGraphicsDatabase[clientNum][index - 1];
}

void CG_ClearUserWeaponGraphics( int clientNum ) {
	if ( clientNum < 0 || clientNum >= MAX_CLIENTS ) {
		return;
	}
	memset( weaponGraphicsDatabase[clientNum], 0, sizeof( weaponGraphicsDatabase[clientNum] ) );
}

void CG_CopyUserWeaponGraphics( int from, int to ) {
	if ( from < 0 || from >= MAX_CLIENTS || to < 0 || to >= MAX_CLIENTS ) {
		return;
	}
	memcpy(&weaponGraphicsDatabase[to], &weaponGraphicsDatabase[from], sizeof(cg_userWeapon_t)*(ALTSPAWN_OFFSET+MAX_PLAYERWEAPONS));
}


