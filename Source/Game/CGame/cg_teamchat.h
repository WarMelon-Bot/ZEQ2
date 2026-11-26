/*
 * cg_teamchat.h -- bounded, display-safe team chat line formatting.
 *
 * This helper is deliberately static and dependency-free so the same code can
 * be compiled into the cgame module (native and QVM) and into the standalone
 * regression test (Source/Tests/test_chat_message.c). It is kept separate from
 * cg_chat.h because the QVM build links static helper definitions by symbol
 * name; including cg_chat.h from more than one cgame translation unit would
 * create duplicate definitions.
 */
#ifndef CG_TEAMCHAT_H
#define CG_TEAMCHAT_H

#include "../../Shared/q_shared.h"

/*
 * CG_ChatBuildTeamLine
 *
 * Format one bounded, display-safe line of team chat. Colour escapes are kept
 * (and normalised to ^0..^7 so a wrapped line can restore the current colour),
 * while control/high-bit bytes and the legacy chat escape byte become spaces.
 *
 * The byte budget is checked independently of the visible-character budget:
 * a line made entirely of colour escapes used to advance the write pointer
 * without ever reaching the visible-width limit. Word wrapping rewinds to the
 * last space, and *lastColor is updated for the next line.
 *
 * Returns the number of source bytes consumed; zero only when no progress is
 * possible. dest is always NUL terminated when destSize > 0.
 */
static size_t CG_ChatBuildTeamLine( const char *src, char *dest, size_t destSize,
                                    int maxVisible, char *lastColor ) {
	size_t capacity, used, consumed, limit, lastSpace, i;
	unsigned char c;
	char color;
	int visible;

	if ( !dest || destSize == 0 ) {
		return 0;
	}

	capacity = destSize - 1;
	dest[0] = '\0';
	if ( !src || !*src ) {
		return 0;
	}

	if ( maxVisible < 1 ) {
		maxVisible = 1;
	}
	color = ( lastColor && *lastColor >= '0' && *lastColor <= '7' ) ? *lastColor : COLOR_WHITE;

	/* First pass: how many source bytes fit in this line? */
	used = ( capacity >= 2 ) ? 2 : 0;	/* colour continuation prefix */
	consumed = 0;
	visible = 0;
	lastSpace = 0;

	while ( src[consumed] ) {
		if ( Q_IsColorString( src + consumed ) ) {
			if ( used + 2 > capacity || visible >= maxVisible ) {
				break;
			}
			used += 2;
			consumed += 2;
			continue;
		}
		if ( used + 1 > capacity || visible >= maxVisible ) {
			break;
		}
		c = (unsigned char)src[consumed];
		if ( c == ' ' && consumed > 0 ) {
			lastSpace = consumed + 1;
		}
		used++;
		consumed++;
		visible++;
	}

	limit = consumed;
	if ( visible >= maxVisible && lastSpace > 0 && lastSpace < limit ) {
		limit = lastSpace;
	}
	if ( limit == 0 ) {
		/* Never stall the caller, even with a tiny destination buffer. */
		limit = ( capacity >= 2 && Q_IsColorString( src ) ) ? 2 : 1;
	}

	/* Second pass: copy the accepted range, sanitising as we go. */
	used = 0;
	if ( capacity >= 2 ) {
		dest[used++] = Q_COLOR_ESCAPE;
		dest[used++] = color;
	}

	i = 0;
	while ( i < limit && src[i] ) {
		if ( used + 1 > capacity ) {
			break;
		}
		if ( Q_IsColorString( src + i ) && i + 2 <= limit && used + 2 <= capacity ) {
			c = (unsigned char)src[i + 1];
			color = (char)( '0' + ColorIndex( (int)c ) );
			dest[used++] = Q_COLOR_ESCAPE;
			dest[used++] = (char)c;
			i += 2;
			continue;
		}

		c = (unsigned char)src[i++];
		if ( c < 0x20 || c >= 0x7f || c == '\x19' ) {
			c = ' ';
		}
		dest[used++] = (char)c;
	}
	dest[used] = '\0';

	if ( lastColor ) {
		*lastColor = color;
	}
	return i;
}

#endif /* CG_TEAMCHAT_H */
