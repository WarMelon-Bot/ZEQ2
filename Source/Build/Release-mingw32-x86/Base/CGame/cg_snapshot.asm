code
proc CG_ResetEntity 8 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 560
ADDP4
INDIRI4
ADDRGP4 cg+137588
INDIRI4
CNSTI4 300
SUBI4
GEI4 $102
ADDRFP4 0
INDIRP4
CNSTI4 540
ADDP4
CNSTI4 0
ASGNI4
LABELV $102
ADDRFP4 0
INDIRP4
CNSTI4 548
ADDP4
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 35232
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 35244
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 1
NEI4 $106
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_ResetPlayerEntity
CALLV
pop
LABELV $106
LABELV $101
endproc CG_ResetEntity 8 4
proc CG_TransitionEntity 4 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
ADDRFP4 0
INDIRP4
CNSTI4 264
ADDP4
INDIRB
ASGNB 264
ADDRFP4 0
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 1
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
CNSTI4 0
NEI4 $109
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_ResetEntity
CALLV
pop
LABELV $109
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
CNSTI4 0
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CheckEvents
CALLV
pop
LABELV $108
endproc CG_TransitionEntity 4 4
export CG_SetInitialSnapshot
proc CG_SetInitialSnapshot 24 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 cg+40
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
ARGP4
CNSTI4 35276
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
ADDRGP4 CG_BuildSolidList
CALLV
pop
ADDRFP4 0
INDIRP4
CNSTI4 68756
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_ExecuteNewServerCommands
CALLV
pop
ADDRGP4 CG_Respawn
CALLV
pop
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $116
JUMPV
LABELV $113
ADDRLP4 16
CNSTI4 264
ASGNI4
ADDRLP4 8
ADDRLP4 16
INDIRI4
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1168
ADDP4
ADDP4
ASGNP4
ADDRLP4 0
CNSTI4 35276
ADDRLP4 8
INDIRP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRLP4 0
INDIRP4
CNSTI4 528
ADDP4
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_ResetEntity
CALLV
pop
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_CheckEvents
CALLV
pop
LABELV $114
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $116
ADDRLP4 4
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1164
ADDP4
INDIRI4
LTI4 $113
LABELV $111
endproc CG_SetInitialSnapshot 24 12
proc CG_TransitionSnapshot 32 12
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $120
ADDRGP4 $123
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $120
ADDRGP4 cg+44
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $124
ADDRGP4 $127
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $124
ADDRGP4 cg+44
INDIRP4
CNSTI4 68756
ADDP4
INDIRI4
ARGI4
ADDRGP4 CG_ExecuteNewServerCommands
CALLV
pop
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $129
LABELV $129
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $135
JUMPV
LABELV $132
ADDRLP4 4
CNSTI4 35276
CNSTI4 264
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1168
ADDP4
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
CNSTI4 532
ADDP4
CNSTI4 0
ASGNI4
LABELV $133
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $135
ADDRLP4 0
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1164
ADDP4
INDIRI4
LTI4 $132
ADDRLP4 8
ADDRGP4 cg+40
INDIRP4
ASGNP4
ADDRGP4 cg+40
ADDRGP4 cg+44
INDIRP4
ASGNP4
ADDRGP4 cg+40
INDIRP4
CNSTI4 44
ADDP4
ARGP4
CNSTI4 35276
ADDRGP4 cg+40
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
CNSTI4 35276
ADDRGP4 cg+40
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities+528
ADDP4
CNSTI4 0
ASGNI4
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 $148
JUMPV
LABELV $145
ADDRLP4 4
CNSTI4 35276
CNSTI4 264
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1168
ADDP4
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 CG_TransitionEntity
CALLV
pop
ADDRLP4 4
INDIRP4
CNSTI4 560
ADDP4
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
LABELV $146
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $148
ADDRLP4 0
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 1164
ADDP4
INDIRI4
LTI4 $145
ADDRGP4 cg+44
CNSTP4 0
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $153
ADDRLP4 20
CNSTI4 44
ASGNI4
ADDRLP4 12
ADDRLP4 8
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ASGNP4
ADDRLP4 16
ADDRGP4 cg+40
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
ASGNP4
ADDRLP4 24
CNSTI4 100
ASGNI4
ADDRLP4 16
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
ADDRLP4 12
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRI4
BXORI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $156
ADDRGP4 cg+137572
CNSTI4 1
ASGNI4
LABELV $156
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRGP4 cg+12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $169
ADDRGP4 cg+40
INDIRP4
CNSTI4 56
ADDP4
INDIRI4
CNSTI4 4096
BANDI4
ADDRLP4 28
INDIRI4
NEI4 $169
ADDRGP4 cg_nopredict+12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $169
ADDRGP4 cg_synchronousClients+12
INDIRI4
ADDRLP4 28
INDIRI4
NEI4 $169
ADDRGP4 cg+40
INDIRP4
CNSTI4 244
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
LEI4 $159
LABELV $169
ADDRLP4 16
INDIRP4
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 CG_TransitionPlayerState
CALLV
pop
LABELV $159
LABELV $153
LABELV $119
endproc CG_TransitionSnapshot 32 12
proc CG_StopMover 12 0
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
CNSTI4 0
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 35232
ADDP4
INDIRB
ASGNB 12
ADDRLP4 8
CNSTF4 0
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
ADDRLP4 8
INDIRF4
ASGNF4
LABELV $170
endproc CG_StopMover 12 0
proc CG_SetNextSnap 36 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 cg+44
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 44
ADDP4
ARGP4
CNSTI4 35276
ADDRFP4 0
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities+264
ADDP4
ARGP4
CNSTI4 0
ARGI4
ADDRGP4 BG_PlayerStateToEntityState
CALLV
pop
CNSTI4 35276
ADDRGP4 cg+40
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
MULI4
ADDRGP4 cg_entities+528
ADDP4
CNSTI4 1
ASGNI4
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRGP4 $179
JUMPV
LABELV $176
ADDRLP4 16
CNSTI4 264
ASGNI4
ADDRLP4 4
ADDRLP4 16
INDIRI4
ADDRLP4 8
INDIRI4
MULI4
ADDRFP4 0
INDIRP4
CNSTI4 1168
ADDP4
ADDP4
ASGNP4
ADDRLP4 0
CNSTI4 35276
ADDRLP4 4
INDIRP4
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
ARGP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 16
INDIRI4
ARGI4
ADDRGP4 memcpy
CALLP4
pop
ADDRLP4 28
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 532
ADDP4
INDIRI4
ADDRLP4 28
INDIRI4
EQI4 $182
ADDRLP4 32
CNSTI4 8
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
ADDRLP4 4
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
BXORI4
CNSTI4 4
BANDI4
ADDRLP4 28
INDIRI4
EQI4 $180
LABELV $182
ADDRLP4 0
INDIRP4
CNSTI4 528
ADDP4
CNSTI4 0
ASGNI4
ADDRGP4 $181
JUMPV
LABELV $180
ADDRLP4 0
INDIRP4
CNSTI4 528
ADDP4
CNSTI4 1
ASGNI4
LABELV $181
LABELV $177
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $179
ADDRLP4 8
INDIRI4
ADDRFP4 0
INDIRP4
CNSTI4 1164
ADDP4
INDIRI4
LTI4 $176
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $183
ADDRLP4 16
CNSTI4 144
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
BXORI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $183
ADDRGP4 cg+137576
CNSTI4 1
ASGNI4
ADDRGP4 $184
JUMPV
LABELV $183
ADDRGP4 cg+137576
CNSTI4 0
ASGNI4
LABELV $184
ADDRLP4 20
CNSTI4 180
ASGNI4
ADDRGP4 cg+44
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
EQI4 $189
ADDRGP4 cg+137576
CNSTI4 1
ASGNI4
LABELV $189
ADDRGP4 cg+44
INDIRP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
INDIRI4
BXORI4
CNSTI4 4
BANDI4
CNSTI4 0
EQI4 $194
ADDRGP4 cg+137576
CNSTI4 1
ASGNI4
LABELV $194
ADDRGP4 CG_BuildSolidList
CALLV
pop
LABELV $171
endproc CG_SetNextSnap 36 12
proc CG_ReadNextSnapshot 20 12
ADDRGP4 cg+32
INDIRI4
ADDRGP4 cgs+31448
INDIRI4
CNSTI4 1000
ADDI4
LEI4 $208
ADDRGP4 $204
ARGP4
ADDRGP4 cg+32
INDIRI4
ARGI4
ADDRGP4 cgs+31448
INDIRI4
ARGI4
ADDRGP4 CG_Printf
CALLV
pop
ADDRGP4 $208
JUMPV
LABELV $207
ADDRGP4 cg+40
INDIRP4
CVPU4 4
ADDRGP4 cg+48
CVPU4 4
NEU4 $212
ADDRLP4 0
ADDRGP4 cg+48+68760
ASGNP4
ADDRGP4 $213
JUMPV
LABELV $212
ADDRLP4 0
ADDRGP4 cg+48
ASGNP4
LABELV $213
ADDRLP4 8
ADDRGP4 cgs+31448
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 cgs+31448
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 trap_GetSnapshot
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 12
INDIRI4
ASGNI4
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $221
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $221
ADDRLP4 16
CNSTI4 8
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
NEI4 $221
LABELV $221
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $225
ADDRLP4 0
INDIRP4
RETP4
ADDRGP4 $199
JUMPV
LABELV $225
LABELV $208
ADDRGP4 cgs+31448
INDIRI4
ADDRGP4 cg+32
INDIRI4
LTI4 $207
CNSTP4 0
RETP4
LABELV $199
endproc CG_ReadNextSnapshot 20 12
export CG_ProcessSnapshots
proc CG_ProcessSnapshots 20 8
ADDRLP4 4
ARGP4
ADDRGP4 cg+36
ARGP4
ADDRGP4 trap_GetCurrentSnapshotNumber
CALLV
pop
ADDRLP4 4
INDIRI4
ADDRGP4 cg+32
INDIRI4
EQI4 $238
ADDRLP4 4
INDIRI4
ADDRGP4 cg+32
INDIRI4
GEI4 $232
ADDRGP4 $235
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $232
ADDRGP4 cg+32
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 $238
JUMPV
LABELV $237
ADDRLP4 8
ADDRGP4 CG_ReadNextSnapshot
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $241
ADDRGP4 $227
JUMPV
LABELV $241
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
NEI4 $243
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_SetInitialSnapshot
CALLV
pop
LABELV $243
LABELV $238
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $237
LABELV $245
ADDRGP4 cg+44
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $248
ADDRLP4 8
ADDRGP4 CG_ReadNextSnapshot
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 8
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $251
ADDRGP4 $247
JUMPV
LABELV $251
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 CG_SetNextSnap
CALLV
pop
ADDRLP4 12
CNSTI4 8
ASGNI4
ADDRGP4 cg+44
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
GEI4 $253
ADDRGP4 $257
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $253
LABELV $248
ADDRLP4 8
CNSTI4 8
ASGNI4
ADDRGP4 cg+137588
INDIRI4
ADDRGP4 cg+40
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRI4
LTI4 $258
ADDRGP4 cg+137588
INDIRI4
ADDRGP4 cg+44
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRI4
GEI4 $258
ADDRGP4 $247
JUMPV
LABELV $258
ADDRGP4 CG_TransitionSnapshot
CALLV
pop
LABELV $246
ADDRGP4 $245
JUMPV
LABELV $247
ADDRGP4 cgs+31680
INDIRI4
CNSTI4 1
NEI4 $264
ADDRGP4 cg+174628+448
INDIRI4
CNSTI4 0
EQI4 $267
ADDRLP4 8
CNSTI4 64
ASGNI4
LABELV $271
ADDRLP4 12
CNSTI4 35276
ADDRLP4 8
INDIRI4
MULI4
ADDRGP4 cg_entities
ADDP4
ASGNP4
ADDRLP4 16
CNSTI4 4
ASGNI4
ADDRLP4 12
INDIRP4
ADDRLP4 16
INDIRI4
ADDP4
INDIRI4
ADDRLP4 16
INDIRI4
EQI4 $275
ADDRGP4 $272
JUMPV
LABELV $275
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 CG_StopMover
CALLV
pop
LABELV $272
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 1022
LTI4 $271
ADDRGP4 $268
JUMPV
LABELV $267
ADDRLP4 8
CNSTU4 0
ASGNU4
ADDRGP4 cg+174628
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRU4
EQU4 $277
ADDRGP4 cg+174628
INDIRP4
CNSTI4 12
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRU4
EQU4 $277
ADDRGP4 cg+174628
INDIRP4
CNSTI4 12
ADDP4
INDIRP4
ARGP4
ADDRGP4 CG_StopMover
CALLV
pop
LABELV $277
LABELV $268
LABELV $264
ADDRGP4 cg+40
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $282
ADDRGP4 $285
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $282
ADDRGP4 cg+137588
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
GEI4 $286
ADDRGP4 cg+137588
ADDRGP4 cg+40
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
LABELV $286
ADDRGP4 cg+44
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $292
ADDRGP4 cg+44
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ADDRGP4 cg+137588
INDIRI4
GTI4 $292
ADDRGP4 $297
ARGP4
ADDRGP4 CG_Error
CALLV
pop
LABELV $292
LABELV $227
endproc CG_ProcessSnapshots 20 8
import CG_MotionBlur
import CG_FrameHist_WasWeaponNr
import CG_FrameHist_IsWeaponNr
import CG_FrameHist_WasWeaponState
import CG_FrameHist_IsWeaponState
import CG_FrameHist_HadAura
import CG_FrameHist_HasAura
import CG_FrameHist_SetAura
import CG_FrameHist_WasInPVS
import CG_FrameHist_IsInPVS
import CG_FrameHist_SetPVS
import CG_FrameHist_NextFrame
import CG_FrameHist_Init
import PSys_SpawnCachedSystem
import CG_AddParticleSystems
import CG_InitParticleSystems
import CG_RegisterClientModelnameWithTiers
import CG_weapGfx_Parse
import CG_UpdateRadarBlips
import CG_DrawRadar
import CG_InitRadarBlips
import CG_AddTrailsToScene
import CG_UpdateTrailHead
import CG_ResetTrail
import CG_InitTrails
import CG_BeamTableUpdate
import CG_AddBeamTables
import CG_InitBeamTables
import CG_CopyClientAura
import CG_AddAuraToScene
import CG_RegisterClientAura
import CG_AuraEnd
import CG_AuraStart
import CG_NewParticleArea
import initparticles
import CG_ParticleExplosion
import CG_ParticleMisc
import CG_ParticleDust
import CG_ParticleSparks
import CG_ParticleBulletDebris
import CG_ParticleSnowFlurry
import CG_AddParticleShrapnel
import CG_ParticleSmoke
import CG_ParticleSnow
import CG_AddParticles
import CG_ClearParticles
import trap_GetEntityToken
import trap_getCameraInfo
import trap_startCamera
import trap_loadCamera
import trap_SnapVector
import trap_CIN_SetExtents
import trap_CIN_DrawCinematic
import trap_CIN_RunCinematic
import trap_CIN_StopCinematic
import trap_CIN_PlayCinematic
import trap_Key_GetKey
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_IsDown
import trap_R_RegisterFont
import trap_MemoryRemaining
import testPrintFloat
import testPrintInt
import trap_SetUserCmdValue
import trap_GetUserCmd
import trap_GetCurrentCmdNumber
import trap_GetServerCommand
import trap_GetSnapshot
import trap_GetCurrentSnapshotNumber
import trap_GetGameState
import trap_GetGlconfig
import trap_R_SetBlendPose
import trap_R_GetLerpPose
import trap_R_AddRefExtendedEntityToScene
import trap_R_RemapShader
import trap_R_LerpTag
import trap_R_ModelBounds
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_LightForPoint
import trap_R_AddLightToScene
import trap_R_AddFogToScene
import trap_R_AddPolysToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterShader
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_R_LoadWorldMap
import trap_S_StopBackgroundTrack
import trap_S_StartBackgroundTrack
import trap_S_RegisterSound
import trap_S_Respatialize
import trap_S_UpdateEntityPosition
import trap_S_AddRealLoopingSound
import trap_S_AddLoopingSound
import trap_S_ClearLoopingSounds
import trap_S_StartLocalSound
import trap_S_StopLoopingSound
import trap_S_StartSound
import trap_CM_MarkFragments
import trap_CM_TransformedBoxTrace
import trap_CM_BoxTrace
import trap_CM_TransformedPointContents
import trap_CM_PointContents
import trap_CM_TempBoxModel
import trap_CM_InlineModel
import trap_CM_NumInlineModels
import trap_CM_LoadMap
import trap_UpdateScreen
import trap_SendClientCommand
import trap_AddCommand
import trap_SendConsoleCommand
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import CG_CheckChangedPredictableEvents
import CG_TransitionPlayerState
import CG_Respawn
import CG_PlayBufferedVoiceChats
import CG_VoiceChatLocal
import CG_ShaderStateChanged
import CG_LoadVoiceChats
import CG_SetConfigValues
import CG_ParseServerinfo
import CG_ExecuteNewServerCommands
import CG_InitConsoleCommands
import CG_ConsoleCommand
import CG_DrawOldTourneyScoreboard
import CG_DrawOldScoreboard
import CG_DrawInformation
import CG_LoadingClient
import CG_LoadingString
import CG_CreateStraightBeamFade
import CG_MakeUserExplosion
import CG_MakeExplosion
import CG_Bleed
import CG_BigExplode
import CG_GibPlayer
import CG_ScorePlum
import CG_PowerStruggleEffect
import CG_PowerMeleeEffect
import CG_SpeedMeleeEffect
import CG_BigLightningEffect
import CG_LightningEffect
import CG_WaterSplash
import CG_DirtPush
import CG_WaterRipple
import CG_SpawnEffect
import CG_BubbleTrail
import CG_PlayerDirtPush
import CG_PlayerSplash
import CG_WaterBubble
import CG_SmokePuff
import CG_AddLocalEntities
import CG_AllocLocalEntity
import CG_InitLocalEntities
import CG_ImpactMark
import CG_AddMarks
import CG_InitMarkPolys
import CG_UserRailTrail
import CG_UserMissileHitPlayer
import CG_UserMissileHitWall
import CG_DrawLineRGBA
import CG_DrawLine
import CG_OutOfAmmoChange
import CG_DrawWeaponSelect
import CG_AddPlayerWeaponMD4
import CG_AddPlayerWeapon
import CG_AddViewWeapon
import CG_GrappleTrail
import CG_RailTrail
import CG_Draw3DLine
import CG_Bullet
import CG_ShotgunFire
import CG_MissileHitPlayer
import CG_MissileHitWall
import CG_FireWeapon
import CG_RegisterItemVisuals
import CG_RegisterWeapon
import CG_Weapon_f
import CG_PrevWeapon_f
import CG_NextWeapon_f
import CG_Mover
import CG_GetTagOrientation
import CG_GetTagPosition
import CG_PositionRotatedEntityOnTagMD4
import CG_PositionRotatedEntityOnTag
import CG_PositionEntityOnTagMD4
import CG_PositionEntityOnTag
import CG_AdjustPositionForMover
import CG_Beam
import CG_AddPacketEntities
import CG_SetEntitySoundPosition
import CG_PainEvent
import CG_EntityEvent
import CG_PlaceString
import CG_CheckEvents
import CG_LoadDeferredPlayers
import CG_PredictPlayerState
import CG_SmoothTrace
import CG_Trace
import CG_PointContents
import CG_BuildSolidList
import CG_SpawnLightSpeedGhost
import CG_GetTagOrientationFromPlayerEntityLegsModel
import CG_GetTagOrientationFromPlayerEntityTorsoModel
import CG_GetTagOrientationFromPlayerEntityHeadModel
import CG_GetTagOrientationFromPlayerEntity
import CG_ParseAnimationFile
import CG_CustomSound
import CG_NewClientInfo
import CG_AddRefExtEntityWithPowerups
import CG_AddRefEntityWithPowerups
import CG_ResetPlayerEntity
import CG_Player
import CG_StatusHandle
import CG_OtherTeamHasFlag
import CG_YourTeamHasFlag
import CG_GameTypeString
import CG_CheckOrderPending
import CG_Text_PaintChar
import CG_Draw3DModel
import CG_GetKillerText
import CG_GetGameStatusText
import CG_GetTeamColor
import CG_InitTeamChat
import CG_SetPrintString
import CG_ShowResponseHead
import CG_RunMenuScript
import CG_OwnerDrawVisible
import CG_GetValue
import CG_SelectNextPlayer
import CG_SelectPrevPlayer
import CG_Text_Height
import CG_Text_Width
import CG_Text_Paint
import CG_OwnerDraw
import CG_DrawTeamBackground
import CG_DrawFlagModel
import CG_DrawActive
import CG_DrawHead
import CG_CenterPrint
import teamChat2
import teamChat1
import systemChat
import drawTeamOverlayModificationCount
import numSortedTeamPlayers
import sortedTeamPlayers
import CG_DrawTopBottom
import CG_DrawSides
import CG_DrawRect
import UI_DrawProportionalString
import CG_GetColorForHealth
import CG_ColorForHealth
import CG_TileClear
import CG_TeamColor
import CG_FadeColor
import CG_DrawStrlen
import CG_DrawMediumStringColor
import CG_DrawSmallStringColor
import CG_DrawSmallStringHalfHeight
import CG_DrawSmallString
import CG_DrawBigStringColor
import CG_DrawBigString
import CG_DrawStringExt
import CG_DrawString
import CG_DrawPic
import CG_FillRect
import CG_AdjustFrom640
import CG_AddLensFlare
import CG_AddLFEditorCursor
import CG_AdjustEarthquakes
import CG_AddEarthquake
import CG_DrawActiveFrame
import CG_WorldCoordToScreenCoordVec
import CG_WorldCoordToScreenCoordFloat
import CG_AddBufferedSound
import CG_ZoomUp_f
import CG_ZoomDown_f
import CG_TestModelPrevSkin_f
import CG_TestModelNextSkin_f
import CG_TestModelPrevFrame_f
import CG_TestModelNextFrame_f
import CG_TestGun_f
import CG_TestModel_f
import CG_LoadLensFlareEntities
import CG_ComputeMaxVisAngle
import CG_LoadLensFlares
import CG_SelectLFEnt
import CG_SetLFEdMoveMode
import CG_SetLFEntOrigin
import CG_LFEntOrigin
import CG_BuildSpectatorString
import CG_GetSelectedScore
import CG_SetScoreSelection
import CG_RankRunFrame
import CG_EventHandling
import CG_MouseEvent
import CG_KeyEvent
import CG_LoadMenus
import CG_LastAttacker
import CG_CrosshairPlayer
import CG_UpdateCvars
import CG_Error
import CG_Printf
import CG_Argv
import CG_ConfigString
import cg_playerOrigins
import cg_missileFlare
import cg_sunFlare
import cg_mapFlare
import cg_lensFlare
import cg_particlesMaximum
import cg_particlesStop
import cg_particlesQuality
import cg_music
import cg_beamControl
import cg_thirdPersonCamera
import cg_soundAttenuation
import r_beamDetail
import cg_verboseParse
import cg_tailDetail
import cg_lockonDistance
import cg_enableBreath
import cg_enableDust
import cg_trueLightning
import cg_oldPlasma
import cg_oldRocket
import cg_oldRail
import cg_noProjectileTrail
import cg_noTaunt
import cg_bigFont
import cg_smallFont
import cg_cameraMode
import cg_timescale
import cg_timescaleFadeSpeed
import cg_timescaleFadeEnd
import cg_cameraOrbitDelay
import cg_cameraOrbit
import pmove_msec
import pmove_fixed
import cg_smoothClients
import cg_scorePlum
import cg_noVoiceText
import cg_noVoiceChats
import cg_teamChatsOnly
import cg_drawFriend
import cg_deferPlayers
import cg_predictItems
import cg_blood
import cg_paused
import cg_buildScript
import cg_forceModel
import cg_stats
import cg_teamChatHeight
import cg_teamChatTime
import cg_synchronousClients
import cg_thirdPerson
import cg_lockedSlide
import cg_lockedHeight
import cg_lockedAngle
import cg_lockedRange
import cg_thirdPersonSlide
import cg_thirdPersonHeight
import cg_thirdPersonAngle
import cg_thirdPersonRange
import cg_thirdPersonMeleeTargetDamp
import cg_thirdPersonMeleeCameraDamp
import cg_thirdPersonTargetDamp
import cg_thirdPersonCameraDamp
import cg_advancedFlight
import cg_zoomFov
import cg_fov
import cg_simpleItems
import cg_ignore
import cg_displayObituary
import cg_autoswitch
import cg_tracerLength
import cg_tracerWidth
import cg_tracerChance
import cg_viewsize
import cg_drawGun
import cg_gun_z
import cg_gun_y
import cg_gun_x
import cg_gun_frame
import cg_chatTime
import cg_brassTime
import cg_addMarks
import cg_footsteps
import cg_showmiss
import cg_noPlayerAnims
import cg_nopredict
import cg_errorDecay
import cg_railTrailTime
import cg_debugEvents
import cg_debugPosition
import cg_debugAnim
import cg_animSpeed
import cg_draw2D
import cg_drawStatus
import cg_crosshairBars
import cg_crosshairHealth
import cg_crosshairMargin
import cg_crosshairSize
import cg_crosshairY
import cg_crosshairX
import cg_teamOverlayUserinfo
import cg_drawTeamOverlay
import cg_drawRewards
import cg_drawCrosshairNames
import cg_drawCrosshair
import cg_drawAmmoWarning
import cg_drawIcons
import cg_draw3dIcons
import cg_drawSnapshot
import cg_drawFPS
import cg_drawTimer
import cg_gibs
import cg_shadows
import cg_swingSpeed
import cg_bobroll
import cg_bobpitch
import cg_bobup
import cg_runroll
import cg_runpitch
import cg_centertime
import cg_markPolys
import cg_items
import cg_weapons
import cg_entities
import cg
import cgs
import CG_NextTrack
import CG_FadeNext
import CG_StartMusic
import CG_ParsePlaylist
import CG_GetMilliseconds
import CG_CheckMusic
import CG_CopyUserWeaponGraphics
import CG_FindUserWeaponGraphics
import BG_IntMergeBits
import BG_IntHiBits
import BG_IntLoBits
import BG_PlayerStateToEntityState
import BG_TouchJumpPad
import BG_AddPredictableEventToPlayerstate
import BG_EvaluateWeaponChargeLevel
import BG_EvaluateTrajectoryDelta
import BG_EvaluateTrajectory
import Pmove
import PM_UpdateViewAngles
import Com_Printf
import Com_Error
import Info_NextPair
import Info_Validate
import Info_SetValueForKey_Big
import Info_SetValueForKey
import Info_RemoveKey_big
import Info_RemoveKey
import Info_ValueForKey
import Com_TruncateLongString
import va
import Q_CountChar
import Q_CleanStr
import Q_PrintStrlen
import Q_strcat
import Q_strncpyz
import Q_stristr
import Q_strrchr
import Q_strupr
import Q_strlwr
import Q_stricmpn
import Q_strncmp
import Q_stricmp
import Q_isintegral
import Q_isanumber
import Q_isalpha
import Q_isupper
import Q_islower
import Q_isprint
import Com_RandomBytes
import Com_SkipCharset
import Com_SkipTokens
import Com_sprintf
import Com_HexStrToInt
import Parse3DMatrix
import Parse2DMatrix
import Parse1DMatrix
import SkipRestOfLine
import SkipBracedSection
import COM_MatchToken
import COM_ParseWarning
import COM_ParseError
import COM_Compress
import COM_ParseExt
import COM_Parse
import COM_GetCurrentParseLine
import COM_BeginParseSession
import COM_DefaultExtension
import COM_StripExtension
import COM_GetExtension
import COM_SkipPath
import Com_Clamp
import hack_asin
import hack_acos
import Q_Sign
import DistancePointToLine
import ProjectPointOnLine
import VectorPieceWiseMultiply
import VectorPllComponent
import Q_hypot
import Distance_2D
import Q_angle2D
import PointsSameSide_2D
import DotProduct_2D
import Det_2D
import DistancePointLine
import QuatToAngles
import QuatMul
import QuatToVector
import QuatToAxis
import AnglesToQuat
import Q_isnan
import PerpendicularVector
import AngleVectors
import MatrixMultiply
import Matrix4Multiply
import Matrix4Copy
import Matrix4Compare
import MakeNormalVectors
import RotateAroundDirection
import RotatePointAroundVector
import ProjectPointOnPlane
import PlaneFromPoints
import AngleDelta
import AngleNormalize180
import AngleNormalize360
import AnglesSubtract
import AngleSubtract
import LerpAngle
import AngleMod
import BoundsIntersectPoint
import BoundsIntersectSphere
import BoundsIntersect
import BoxOnPlaneSide
import SetPlaneSignbits
import AxisCopy
import AxisClear
import AnglesToAxis
import vectoangles
import Q_crandom
import Q_random
import Q_rand
import Q_asin
import Q_acos
import Q_log2
import VectorRotate
import Vector4Scale
import VectorNormalize2
import VectorNormalize
import CrossProduct
import VectorInverse
import VectorNormalizeFast
import DistanceSquared
import Distance
import VectorLengthSquared
import VectorLength
import VectorCompare
import AddPointToBounds
import ClearBounds
import RadiusFromBounds
import NormalizeColor
import ColorBytes4
import ColorBytes3
import _VectorMA
import _VectorScale
import _VectorCopy
import _VectorAdd
import _VectorSubtract
import _DotProduct
import ByteToDir
import DirToByte
import ClampShort
import ClampChar
import Q_rsqrt
import Q_fabs
import axisDefault
import vec3_origin
import g_color_table
import colorDkGrey
import colorMdGrey
import colorLtGrey
import colorWhite
import colorCyan
import colorMagenta
import colorYellow
import colorBlue
import colorGreen
import colorRed
import colorBlack
import bytedirs
import Hunk_Alloc
import FloatSwap
import LongSwap
import ShortSwap
import acos
import fabs
import abs
import tan
import atan2
import cos
import sin
import sqrt
import floor
import ceil
import memcpy
import memset
import memmove
import sscanf
import Q_snprintf
import Q_vsnprintf
import strtol
import _atoi
import atoi
import strtod
import _atof
import atof
import toupper
import tolower
import strncpy
import strstr
import strchr
import strcmp
import strcpy
import strcat
import strlen
import rand
import srand
import qsort
lit
align 1
LABELV $297
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 114
byte 1 111
byte 1 99
byte 1 101
byte 1 115
byte 1 115
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 115
byte 1 58
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 45
byte 1 62
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 84
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 60
byte 1 61
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $285
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 114
byte 1 111
byte 1 99
byte 1 101
byte 1 115
byte 1 115
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 115
byte 1 58
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 115
byte 1 110
byte 1 97
byte 1 112
byte 1 32
byte 1 61
byte 1 61
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 0
align 1
LABELV $257
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 114
byte 1 111
byte 1 99
byte 1 101
byte 1 115
byte 1 115
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 115
byte 1 58
byte 1 32
byte 1 83
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 32
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 32
byte 1 119
byte 1 101
byte 1 110
byte 1 116
byte 1 32
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 119
byte 1 97
byte 1 114
byte 1 100
byte 1 115
byte 1 0
align 1
LABELV $235
byte 1 67
byte 1 71
byte 1 95
byte 1 80
byte 1 114
byte 1 111
byte 1 99
byte 1 101
byte 1 115
byte 1 115
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 115
byte 1 58
byte 1 32
byte 1 110
byte 1 32
byte 1 60
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 108
byte 1 97
byte 1 116
byte 1 101
byte 1 115
byte 1 116
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 78
byte 1 117
byte 1 109
byte 1 0
align 1
LABELV $204
byte 1 87
byte 1 65
byte 1 82
byte 1 78
byte 1 73
byte 1 78
byte 1 71
byte 1 58
byte 1 32
byte 1 67
byte 1 71
byte 1 95
byte 1 82
byte 1 101
byte 1 97
byte 1 100
byte 1 78
byte 1 101
byte 1 120
byte 1 116
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 58
byte 1 32
byte 1 119
byte 1 97
byte 1 121
byte 1 32
byte 1 111
byte 1 117
byte 1 116
byte 1 32
byte 1 111
byte 1 102
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 44
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 62
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $127
byte 1 67
byte 1 71
byte 1 95
byte 1 84
byte 1 114
byte 1 97
byte 1 110
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 58
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 110
byte 1 101
byte 1 120
byte 1 116
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 0
align 1
LABELV $123
byte 1 67
byte 1 71
byte 1 95
byte 1 84
byte 1 114
byte 1 97
byte 1 110
byte 1 115
byte 1 105
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 83
byte 1 110
byte 1 97
byte 1 112
byte 1 115
byte 1 104
byte 1 111
byte 1 116
byte 1 58
byte 1 32
byte 1 78
byte 1 85
byte 1 76
byte 1 76
byte 1 32
byte 1 99
byte 1 103
byte 1 46
byte 1 115
byte 1 110
byte 1 97
byte 1 112
byte 1 0
