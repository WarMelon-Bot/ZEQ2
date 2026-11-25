/*
 * Null sound DMA backend for Android.
 *
 * The portable mixer in snd_dma.c supplies the public S_* entry points, so
 * this file only provides the platform DMA hooks it expects.  Android builds
 * ship without audio first; OpenSL ES or AAudio can replace this later.
 */

#include "../../Shared/q_shared.h"
#include "../../Shared/qcommon.h"

qboolean SNDDMA_Init( void )
{
	return qfalse;
}

int SNDDMA_GetDMAPos( void )
{
	return 0;
}

void SNDDMA_Shutdown( void )
{
}

void SNDDMA_BeginPainting( void )
{
}

void SNDDMA_Submit( void )
{
}
