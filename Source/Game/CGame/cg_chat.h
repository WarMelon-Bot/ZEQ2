/*
 * cg_chat.h -- safe handling of server supplied chat/message text.
 *
 * These helpers are deliberately static and dependency-free so the same code
 * can be compiled into the cgame module (native and QVM) and into the
 * standalone regression test (Source/Tests/test_chat_message.c).
 *
 * All server provided strings are untrusted: never assume they are NUL
 * terminated within a particular size, never write to them, and never copy
 * them with an unbounded string function.
 */
#ifndef CG_CHAT_H
#define CG_CHAT_H

#include "../../Shared/q_shared.h"

/*
 * CG_ChatCleanNameEx
 *
 * Build a display-safe, colour-free name for comparison. The server prefixes
 * chat with the speaker's netname, which may itself contain colour escapes,
 * while cgs.clientinfo[].name is a raw configstring value. Stripping escapes
 * (both the '^' and the colour character) from both sides makes coloured
 * player names resolve to the right client again without copying arbitrary
 * lengths into a small buffer.
 */
static void CG_ChatCleanNameEx( const char *src, char *dest, size_t destSize, qboolean stopAtColon ) {
	const char *p;
	size_t out;

	if ( !dest || destSize == 0 ) {
		return;
	}
	dest[0] = '\0';
	if ( !src ) {
		return;
	}

	p = src;
	while ( *p == ' ' || *p == '\t' || *p == '\x19' ) {
		p++;
	}

	out = 0;
	while ( *p && ( !stopAtColon || *p != ':' ) ) {
		if ( Q_IsColorString( p ) ) {
			p += 2;
			continue;
		}
		if ( *p == '\x19' || *p == '\r' || *p == '\n' ) {
			p++;
			continue;
		}
		if ( out + 1 >= destSize ) {
			break;
		}
		dest[out++] = *p++;
	}
	dest[out] = '\0';

	while ( out > 0 && ( dest[out - 1] == ' ' || dest[out - 1] == '\t' ) ) {
		dest[--out] = '\0';
	}
}

static void CG_ChatCleanName( const char *src, char *dest, size_t destSize ) {
	CG_ChatCleanNameEx( src, dest, destSize, qfalse );
}

static void CG_ChatSpeakerName( const char *text, char *dest, size_t destSize ) {
	CG_ChatCleanNameEx( text, dest, destSize, qtrue );
}

/*
 * CG_ChatCopyText
 *
 * Copy src into dest, preserving valid ^X colour escapes so the HUD renders
 * coloured chat again. Control and non-printable bytes are turned into spaces
 * so a server cannot inject newlines/carriage returns or binary garbage into
 * the chat overlay. Always NUL-terminates and never writes past destSize.
 */
static void CG_ChatCopyText( char *dest, size_t destSize, const char *src ) {
	size_t out;
	unsigned char c;

	if ( !dest || destSize == 0 ) {
		return;
	}
	dest[0] = '\0';
	if ( !src ) {
		return;
	}

	out = 0;
	while ( *src && out + 1 < destSize ) {
		if ( Q_IsColorString( src ) ) {
			// Do not leave a dangling '^' at the end of the buffer.
			if ( out + 2 >= destSize ) {
				break;
			}
			dest[out++] = *src++;
			dest[out++] = *src++;
			continue;
		}

		c = (unsigned char)*src++;
		if ( c < 0x20 || c >= 0x7f ) {
			c = ' ';
		}
		dest[out++] = (char)c;
	}
	dest[out] = '\0';
}

/*
 * CG_ChatMessageSlot
 *
 * Return the index of a free chat slot, rotating the oldest messages down when
 * all slots are in use. Never returns an index outside [0, count). Callers
 * pass cgs.messages flattened with messageSize == sizeof(cgs.messages[0]).
 */
static int CG_ChatMessageSlot( char *messages, size_t messageSize, int *messageClients, int count ) {
	int i;

	if ( !messages || !messageClients || count <= 0 || messageSize == 0 || messageSize > (size_t)INT_MAX ) {
		return -1;
	}

	for ( i = 0; i < count; i++ ) {
		if ( !messages[i * messageSize] ) {
			return i;
		}
	}

	for ( i = count - 1; i > 0; i-- ) {
		char *dst = messages + i * messageSize;
		const char *src = messages + (i - 1) * messageSize;
		size_t len = strlen( src );

		if ( len >= messageSize )
			len = messageSize - 1;
		memmove( dst, src, len );
		dst[len] = '\0';
		messageClients[i] = messageClients[i - 1];
	}
	messages[0] = '\0';
	messageClients[0] = -1;
	return 0;
}

#endif // CG_CHAT_H
