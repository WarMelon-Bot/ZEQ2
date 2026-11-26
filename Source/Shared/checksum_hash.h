/*
 * Small fixed-size hash set with generation stamps.
 *
 * Used by the server's pure-pak validation: a client sends up to 1024
 * checksums when it connects.  Comparing every client checksum against every
 * server checksum used to take up to a million iterations inside one packet
 * event, stalling all players on the server.
 *
 * Two tables are provided so that duplicates can be detected in the client's
 * list while membership is checked against the server's list.  Generation
 * stamps avoid clearing the tables between clients.
 */

#ifndef CHECKSUM_HASH_H
#define CHECKSUM_HASH_H

#include <string.h>

#define CHECKSUM_HASH_SIZE	2048
#define CHECKSUM_HASH_MASK	(CHECKSUM_HASH_SIZE - 1)

typedef struct {
	int	values[2][CHECKSUM_HASH_SIZE];
	int	marks[2][CHECKSUM_HASH_SIZE];
	int	generation;
} checksumHash_t;

static __attribute__((unused)) unsigned int ChecksumHash_Index( int checksum ) {
	return ( (unsigned int)checksum * 2654435761u ) & CHECKSUM_HASH_MASK;
}

static __attribute__((unused)) void ChecksumHash_NextGeneration( checksumHash_t *hash ) {
	if ( hash->generation >= 0x7ffffffd ) {
		memset( hash->marks, 0, sizeof( hash->marks ) );
		hash->generation = 0;
	}
	hash->generation++;
}

/* Returns 0 if checksum is already present in this table. */
static __attribute__((unused)) int ChecksumHash_Insert( checksumHash_t *hash, int table, int checksum ) {
	unsigned int i = ChecksumHash_Index( checksum );
	int mark = hash->generation + table;

	while ( hash->marks[table][i] == mark ) {
		if ( hash->values[table][i] == checksum ) {
			return 0;
		}
		i = ( i + 1 ) & CHECKSUM_HASH_MASK;
	}
	hash->marks[table][i] = mark;
	hash->values[table][i] = checksum;
	return 1;
}

static __attribute__((unused)) int ChecksumHash_Contains( checksumHash_t *hash, int table, int checksum ) {
	unsigned int i = ChecksumHash_Index( checksum );
	int mark = hash->generation + table;

	while ( hash->marks[table][i] == mark ) {
		if ( hash->values[table][i] == checksum ) {
			return 1;
		}
		i = ( i + 1 ) & CHECKSUM_HASH_MASK;
	}
	return 0;
}

#endif	/* CHECKSUM_HASH_H */
