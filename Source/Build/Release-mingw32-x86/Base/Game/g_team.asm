export Team_InitGame
code
proc Team_InitGame 0 12
ADDRGP4 teamgame
ARGP4
CNSTI4 0
ARGI4
CNSTI4 36
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 5
EQI4 $67
ADDRGP4 $65
JUMPV
LABELV $67
ADDRGP4 teamgame+8
CNSTI4 -1
ASGNI4
CNSTI4 1
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 Team_SetFlagStatus
CALLV
pop
ADDRGP4 teamgame+12
CNSTI4 -1
ASGNI4
CNSTI4 2
ARGI4
CNSTI4 0
ARGI4
ADDRGP4 Team_SetFlagStatus
CALLV
pop
LABELV $65
LABELV $63
endproc Team_InitGame 0 12
export OtherTeam
proc OtherTeam 0 0
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $71
CNSTI4 2
RETI4
ADDRGP4 $70
JUMPV
LABELV $71
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $73
CNSTI4 1
RETI4
ADDRGP4 $70
JUMPV
LABELV $73
ADDRFP4 0
INDIRI4
RETI4
LABELV $70
endproc OtherTeam 0 0
export TeamName
proc TeamName 0 0
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $76
ADDRGP4 $78
RETP4
ADDRGP4 $75
JUMPV
LABELV $76
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $79
ADDRGP4 $81
RETP4
ADDRGP4 $75
JUMPV
LABELV $79
ADDRFP4 0
INDIRI4
CNSTI4 3
NEI4 $82
ADDRGP4 $84
RETP4
ADDRGP4 $75
JUMPV
LABELV $82
ADDRGP4 $85
RETP4
LABELV $75
endproc TeamName 0 0
export OtherTeamName
proc OtherTeamName 0 0
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $87
ADDRGP4 $81
RETP4
ADDRGP4 $86
JUMPV
LABELV $87
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $89
ADDRGP4 $78
RETP4
ADDRGP4 $86
JUMPV
LABELV $89
ADDRFP4 0
INDIRI4
CNSTI4 3
NEI4 $91
ADDRGP4 $84
RETP4
ADDRGP4 $86
JUMPV
LABELV $91
ADDRGP4 $85
RETP4
LABELV $86
endproc OtherTeamName 0 0
export TeamColorString
proc TeamColorString 0 0
ADDRFP4 0
INDIRI4
CNSTI4 1
NEI4 $94
ADDRGP4 $96
RETP4
ADDRGP4 $93
JUMPV
LABELV $94
ADDRFP4 0
INDIRI4
CNSTI4 2
NEI4 $97
ADDRGP4 $99
RETP4
ADDRGP4 $93
JUMPV
LABELV $97
ADDRFP4 0
INDIRI4
CNSTI4 3
NEI4 $100
ADDRGP4 $102
RETP4
ADDRGP4 $93
JUMPV
LABELV $100
ADDRGP4 $103
RETP4
LABELV $93
endproc TeamColorString 0 0
export PrintMsg
proc PrintMsg 1048 16
ADDRLP4 1028
ADDRFP4 4+4
ASGNP4
ADDRLP4 4
ARGP4
CNSTI4 1024
ARGI4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 1028
INDIRP4
ARGP4
ADDRLP4 1032
ADDRGP4 Q_vsnprintf
CALLI4
ASGNI4
ADDRLP4 1032
INDIRI4
CVIU4 4
CNSTU4 1024
LEU4 $106
ADDRGP4 $108
ARGP4
ADDRGP4 G_Error
CALLV
pop
LABELV $106
ADDRLP4 1028
CNSTP4 0
ASGNP4
ADDRGP4 $110
JUMPV
LABELV $109
ADDRLP4 0
INDIRP4
CNSTI1 39
ASGNI1
LABELV $110
ADDRLP4 4
ARGP4
CNSTI4 34
ARGI4
ADDRLP4 1036
ADDRGP4 strchr
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 1036
INDIRP4
ASGNP4
ADDRLP4 1036
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $109
ADDRGP4 $113
ARGP4
ADDRLP4 4
ARGP4
ADDRLP4 1044
ADDRGP4 va
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $114
ADDRLP4 1040
CNSTI4 -1
ASGNI4
ADDRGP4 $115
JUMPV
LABELV $114
ADDRLP4 1040
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 1304
DIVI4
ASGNI4
LABELV $115
ADDRLP4 1040
INDIRI4
ARGI4
ADDRLP4 1044
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
LABELV $104
endproc PrintMsg 1048 16
export AddTeamScore
proc AddTeamScore 16 8
ADDRFP4 0
INDIRP4
ARGP4
CNSTI4 51
ARGI4
ADDRLP4 4
ADDRGP4 G_TempEntity
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $117
ADDRGP4 level+44+4
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ADDRGP4 level+44+8
INDIRI4
NEI4 $119
ADDRGP4 $118
JUMPV
LABELV $119
ADDRGP4 level+44+4
INDIRI4
ADDRGP4 level+44+8
INDIRI4
GTI4 $118
ADDRGP4 level+44+4
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ADDRGP4 level+44+8
INDIRI4
LEI4 $118
ADDRGP4 $118
JUMPV
LABELV $117
ADDRGP4 level+44+8
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ADDRGP4 level+44+4
INDIRI4
NEI4 $135
ADDRGP4 $136
JUMPV
LABELV $135
ADDRGP4 level+44+8
INDIRI4
ADDRGP4 level+44+4
INDIRI4
GTI4 $141
ADDRGP4 level+44+8
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ADDRGP4 level+44+4
INDIRI4
LEI4 $141
LABELV $141
LABELV $142
LABELV $136
LABELV $118
ADDRLP4 12
ADDRFP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 level+44
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
ADDRFP4 8
INDIRI4
ADDI4
ASGNI4
LABELV $116
endproc AddTeamScore 16 8
export OnSameTeam
proc OnSameTeam 16 0
ADDRLP4 0
CNSTI4 628
ASGNI4
ADDRLP4 4
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
EQU4 $155
ADDRFP4 4
INDIRP4
ADDRLP4 0
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 4
INDIRU4
NEU4 $153
LABELV $155
CNSTI4 0
RETI4
ADDRGP4 $152
JUMPV
LABELV $153
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 4
GEI4 $156
CNSTI4 0
RETI4
ADDRGP4 $152
JUMPV
LABELV $156
ADDRLP4 8
CNSTI4 628
ASGNI4
ADDRLP4 12
CNSTI4 1264
ASGNI4
ADDRFP4 0
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 8
INDIRI4
ADDP4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRI4
NEI4 $159
CNSTI4 1
RETI4
ADDRGP4 $152
JUMPV
LABELV $159
CNSTI4 0
RETI4
LABELV $152
endproc OnSameTeam 16 0
data
align 1
LABELV ctfFlagStatusRemap
byte 1 48
byte 1 49
byte 1 42
byte 1 42
byte 1 50
align 1
LABELV oneFlagStatusRemap
byte 1 48
byte 1 49
byte 1 50
byte 1 51
byte 1 52
export Team_SetFlagStatus
code
proc Team_SetFlagStatus 16 8
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRLP4 4
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $174
ADDRLP4 4
INDIRI4
CNSTI4 1
EQI4 $164
ADDRLP4 4
INDIRI4
CNSTI4 2
EQI4 $169
ADDRGP4 $162
JUMPV
LABELV $164
ADDRGP4 teamgame+8
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $163
ADDRGP4 teamgame+8
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $163
JUMPV
LABELV $169
ADDRGP4 teamgame+12
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $163
ADDRGP4 teamgame+12
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $163
JUMPV
LABELV $174
ADDRGP4 teamgame+16
INDIRI4
ADDRFP4 4
INDIRI4
EQI4 $163
ADDRGP4 teamgame+16
ADDRFP4 4
INDIRI4
ASGNI4
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $162
LABELV $163
ADDRLP4 0
INDIRI4
CNSTI4 0
EQI4 $179
ADDRGP4 g_gametype+12
INDIRI4
CNSTI4 5
NEI4 $181
ADDRLP4 12
ADDRGP4 ctfFlagStatusRemap
ASGNP4
ADDRLP4 8
ADDRGP4 teamgame+8
INDIRI4
ADDRLP4 12
INDIRP4
ADDP4
INDIRI1
ASGNI1
ADDRLP4 8+1
ADDRGP4 teamgame+12
INDIRI4
ADDRLP4 12
INDIRP4
ADDP4
INDIRI1
ASGNI1
ADDRLP4 8+2
CNSTI1 0
ASGNI1
ADDRGP4 $182
JUMPV
LABELV $181
ADDRLP4 8
ADDRGP4 teamgame+16
INDIRI4
ADDRGP4 oneFlagStatusRemap
ADDP4
INDIRI1
ASGNI1
ADDRLP4 8+1
CNSTI1 0
ASGNI1
LABELV $182
CNSTI4 23
ARGI4
ADDRLP4 8
ARGP4
ADDRGP4 trap_SetConfigstring
CALLV
pop
LABELV $179
LABELV $161
endproc Team_SetFlagStatus 16 8
export Team_CheckDroppedItem
proc Team_CheckDroppedItem 0 0
LABELV $190
endproc Team_CheckDroppedItem 0 0
export Team_ForceGesture
proc Team_ForceGesture 12 0
ADDRFP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $192
ADDRLP4 0
CNSTI4 1304
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
CNSTI4 0
NEI4 $196
ADDRGP4 $193
JUMPV
LABELV $196
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $198
ADDRGP4 $193
JUMPV
LABELV $198
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
ADDRFP4 0
INDIRI4
EQI4 $200
ADDRGP4 $193
JUMPV
LABELV $200
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 648
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 32768
BORI4
ASGNI4
LABELV $193
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 64
LTI4 $192
LABELV $191
endproc Team_ForceGesture 12 0
export Team_FragBonuses
proc Team_FragBonuses 0 0
LABELV $202
endproc Team_FragBonuses 0 0
export Team_CheckHurtCarrier
proc Team_CheckHurtCarrier 36 0
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 4
CNSTI4 628
ASGNI4
ADDRLP4 8
CNSTU4 0
ASGNU4
ADDRFP4 0
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRU4
EQU4 $206
ADDRFP4 4
INDIRP4
ADDRLP4 4
INDIRI4
ADDP4
INDIRP4
CVPU4 4
ADDRLP4 8
INDIRU4
NEU4 $204
LABELV $206
ADDRGP4 $203
JUMPV
LABELV $204
ADDRLP4 12
CNSTI4 628
ASGNI4
ADDRLP4 16
ADDRFP4 0
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRP4
ASGNP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 16
INDIRP4
CNSTI4 804
ADDP4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $207
ADDRLP4 20
CNSTI4 1264
ASGNI4
ADDRLP4 16
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 12
INDIRI4
ADDP4
INDIRP4
ADDRLP4 20
INDIRI4
ADDP4
INDIRI4
EQI4 $207
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1236
ADDP4
ADDRGP4 level+32
INDIRI4
CVIF4 4
ASGNF4
LABELV $207
ADDRLP4 24
CNSTI4 628
ASGNI4
ADDRLP4 28
ADDRFP4 0
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRP4
ASGNP4
ADDRLP4 28
INDIRP4
CNSTI4 1092
ADDP4
INDIRI4
CNSTI4 0
EQI4 $210
ADDRLP4 32
CNSTI4 1264
ASGNI4
ADDRLP4 28
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
ADDRFP4 4
INDIRP4
ADDRLP4 24
INDIRI4
ADDP4
INDIRP4
ADDRLP4 32
INDIRI4
ADDP4
INDIRI4
EQI4 $210
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1236
ADDP4
ADDRGP4 level+32
INDIRI4
CVIF4 4
ASGNF4
LABELV $210
LABELV $203
endproc Team_CheckHurtCarrier 36 0
export Team_ResetFlag
proc Team_ResetFlag 0 0
CNSTP4 0
RETP4
LABELV $213
endproc Team_ResetFlag 0 0
export Team_ResetFlags
proc Team_ResetFlags 0 0
LABELV $214
endproc Team_ResetFlags 0 0
export Team_ReturnFlagSound
proc Team_ReturnFlagSound 0 0
LABELV $215
endproc Team_ReturnFlagSound 0 0
export Team_TakeFlagSound
proc Team_TakeFlagSound 0 0
LABELV $216
endproc Team_TakeFlagSound 0 0
export Team_CaptureFlagSound
proc Team_CaptureFlagSound 0 0
LABELV $217
endproc Team_CaptureFlagSound 0 0
export Team_ReturnFlag
proc Team_ReturnFlag 0 0
LABELV $218
endproc Team_ReturnFlag 0 0
export Team_FreeEntity
proc Team_FreeEntity 0 0
LABELV $219
endproc Team_FreeEntity 0 0
export Team_DroppedFlagThink
proc Team_DroppedFlagThink 8 8
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 Team_ResetFlag
CALLP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRGP4 Team_ReturnFlagSound
CALLV
pop
LABELV $220
endproc Team_DroppedFlagThink 8 8
export Team_TouchOurFlag
proc Team_TouchOurFlag 0 0
CNSTI4 0
RETI4
LABELV $221
endproc Team_TouchOurFlag 0 0
export Team_TouchEnemyFlag
proc Team_TouchEnemyFlag 0 0
CNSTI4 -1
RETI4
LABELV $222
endproc Team_TouchEnemyFlag 0 0
export Pickup_Team
proc Pickup_Team 20 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 4
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 636
ADDP4
INDIRP4
ARGP4
ADDRGP4 $226
ARGP4
ADDRLP4 8
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $224
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRGP4 $225
JUMPV
LABELV $224
ADDRFP4 0
INDIRP4
CNSTI4 636
ADDP4
INDIRP4
ARGP4
ADDRGP4 $229
ARGP4
ADDRLP4 12
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
NEI4 $227
ADDRLP4 0
CNSTI4 2
ASGNI4
ADDRGP4 $228
JUMPV
LABELV $227
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 $230
ARGP4
ADDRGP4 PrintMsg
CALLV
pop
CNSTI4 0
RETI4
ADDRGP4 $223
JUMPV
LABELV $228
LABELV $225
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
NEI4 $231
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 Team_TouchOurFlag
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
RETI4
ADDRGP4 $223
JUMPV
LABELV $231
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 16
ADDRGP4 Team_TouchEnemyFlag
CALLI4
ASGNI4
ADDRLP4 16
INDIRI4
RETI4
LABELV $223
endproc Pickup_Team 20 12
export Team_GetLocation
proc Team_GetLocation 48 8
ADDRLP4 24
CNSTP4 0
ASGNP4
ADDRLP4 20
CNSTF4 1296039936
ASGNF4
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 600
ADDP4
INDIRB
ASGNB 12
ADDRLP4 0
ADDRGP4 level+9168
INDIRP4
ASGNP4
ADDRGP4 $237
JUMPV
LABELV $234
ADDRLP4 32
ADDRLP4 4
INDIRF4
ADDRLP4 0
INDIRP4
CNSTI4 600
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 36
ADDRLP4 0
INDIRP4
CNSTI4 604
ADDP4
INDIRF4
ASGNF4
ADDRLP4 40
ADDRLP4 0
INDIRP4
CNSTI4 608
ADDP4
INDIRF4
ASGNF4
ADDRLP4 16
ADDRLP4 32
INDIRF4
ADDRLP4 32
INDIRF4
MULF4
ADDRLP4 4+4
INDIRF4
ADDRLP4 36
INDIRF4
SUBF4
ADDRLP4 4+4
INDIRF4
ADDRLP4 36
INDIRF4
SUBF4
MULF4
ADDF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 40
INDIRF4
SUBF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 40
INDIRF4
SUBF4
MULF4
ADDF4
ASGNF4
ADDRLP4 16
INDIRF4
ADDRLP4 20
INDIRF4
LEF4 $243
ADDRGP4 $235
JUMPV
LABELV $243
ADDRLP4 4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 600
ADDP4
ARGP4
ADDRLP4 44
ADDRGP4 trap_InPVS
CALLI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
NEI4 $245
ADDRGP4 $235
JUMPV
LABELV $245
ADDRLP4 20
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 24
ADDRLP4 0
INDIRP4
ASGNP4
LABELV $235
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 716
ADDP4
INDIRP4
ASGNP4
LABELV $237
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $234
ADDRLP4 24
INDIRP4
RETP4
LABELV $233
endproc Team_GetLocation 48 8
export Team_GetLocationMsg
proc Team_GetLocationMsg 12 24
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 Team_GetLocation
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $248
CNSTI4 0
RETI4
ADDRGP4 $247
JUMPV
LABELV $248
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
INDIRI4
CNSTI4 0
EQI4 $250
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
INDIRI4
CNSTI4 0
GEI4 $252
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
CNSTI4 0
ASGNI4
LABELV $252
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
INDIRI4
CNSTI4 7
LEI4 $254
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
CNSTI4 7
ASGNI4
LABELV $254
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $256
ARGP4
CNSTI4 94
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 1212
ADDP4
INDIRI4
CNSTI4 48
ADDI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
ADDRGP4 $251
JUMPV
LABELV $250
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 8
INDIRI4
ARGI4
ADDRGP4 $257
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 748
ADDP4
INDIRP4
ARGP4
ADDRGP4 Com_sprintf
CALLV
pop
LABELV $251
CNSTI4 1
RETI4
LABELV $247
endproc Team_GetLocationMsg 12 24
export SelectRandomTeamSpawnPoint
proc SelectRandomTeamSpawnPoint 152 12
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $259
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $261
ADDRLP4 8
ADDRGP4 $263
ASGNP4
ADDRGP4 $260
JUMPV
LABELV $261
ADDRFP4 4
INDIRI4
CNSTI4 2
NEI4 $264
ADDRLP4 8
ADDRGP4 $266
ASGNP4
ADDRGP4 $260
JUMPV
LABELV $264
CNSTP4 0
RETP4
ADDRGP4 $258
JUMPV
LABELV $259
ADDRFP4 4
INDIRI4
CNSTI4 1
NEI4 $267
ADDRLP4 8
ADDRGP4 $269
ASGNP4
ADDRGP4 $268
JUMPV
LABELV $267
ADDRFP4 4
INDIRI4
CNSTI4 2
NEI4 $270
ADDRLP4 8
ADDRGP4 $272
ASGNP4
ADDRGP4 $271
JUMPV
LABELV $270
CNSTP4 0
RETP4
ADDRGP4 $258
JUMPV
LABELV $271
LABELV $268
LABELV $260
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
CNSTP4 0
ASGNP4
ADDRGP4 $274
JUMPV
LABELV $273
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 144
ADDRGP4 SpotWouldTelefrag
CALLI4
ASGNI4
ADDRLP4 144
INDIRI4
CNSTI4 0
EQI4 $276
ADDRGP4 $274
JUMPV
LABELV $276
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
ADDRLP4 0
INDIRP4
ASGNP4
ADDRLP4 148
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
ADDRLP4 148
INDIRI4
ASGNI4
ADDRLP4 148
INDIRI4
CNSTI4 32
NEI4 $278
ADDRGP4 $275
JUMPV
LABELV $278
LABELV $274
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 636
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 144
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 144
INDIRP4
ASGNP4
ADDRLP4 144
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $273
LABELV $275
ADDRLP4 4
INDIRI4
CNSTI4 0
NEI4 $280
CNSTP4 0
ARGP4
CNSTI4 636
ARGI4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 148
ADDRGP4 G_Find
CALLP4
ASGNP4
ADDRLP4 148
INDIRP4
RETP4
ADDRGP4 $258
JUMPV
LABELV $280
ADDRLP4 148
ADDRGP4 rand
CALLI4
ASGNI4
ADDRLP4 140
ADDRLP4 148
INDIRI4
ADDRLP4 4
INDIRI4
MODI4
ASGNI4
ADDRLP4 140
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 12
ADDP4
INDIRP4
RETP4
LABELV $258
endproc SelectRandomTeamSpawnPoint 152 12
export SelectCTFSpawnPoint
proc SelectCTFSpawnPoint 12 16
ADDRFP4 4
INDIRI4
ARGI4
ADDRFP4 0
INDIRI4
ARGI4
ADDRLP4 4
ADDRGP4 SelectRandomTeamSpawnPoint
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 4
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $283
ADDRGP4 vec3_origin
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRFP4 12
INDIRP4
ARGP4
ADDRFP4 16
INDIRI4
ARGI4
ADDRLP4 8
ADDRGP4 SelectSpawnPoint
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
RETP4
ADDRGP4 $282
JUMPV
LABELV $283
ADDRFP4 8
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
ADDRLP4 8
ADDRFP4 8
INDIRP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
CNSTF4 1091567616
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
INDIRB
ASGNB 12
ADDRLP4 0
INDIRP4
RETP4
LABELV $282
endproc SelectCTFSpawnPoint 12 16
proc SortClients 0 0
ADDRFP4 0
INDIRP4
INDIRI4
ADDRFP4 4
INDIRP4
INDIRI4
SUBI4
RETI4
LABELV $285
endproc SortClients 0 0
export TeamplayInfoMessage
proc TeamplayInfoMessage 9408 36
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1260
ADDP4
INDIRI4
CNSTI4 0
NEI4 $287
ADDRGP4 $286
JUMPV
LABELV $287
ADDRLP4 9372
CNSTI4 0
ASGNI4
ADDRLP4 4
ADDRLP4 9372
INDIRI4
ASGNI4
ADDRLP4 8
ADDRLP4 9372
INDIRI4
ASGNI4
ADDRGP4 $292
JUMPV
LABELV $289
ADDRLP4 0
CNSTI4 1304
ADDRLP4 4
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 level+84
ADDP4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
CNSTI4 0
EQI4 $295
ADDRLP4 9380
CNSTI4 628
ASGNI4
ADDRLP4 9384
CNSTI4 1264
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 9380
INDIRI4
ADDP4
INDIRP4
ADDRLP4 9384
INDIRI4
ADDP4
INDIRI4
ADDRFP4 0
INDIRP4
ADDRLP4 9380
INDIRI4
ADDP4
INDIRP4
ADDRLP4 9384
INDIRI4
ADDP4
INDIRI4
NEI4 $295
ADDRLP4 9388
ADDRLP4 8
INDIRI4
ASGNI4
ADDRLP4 8
ADDRLP4 9388
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 9392
CNSTI4 2
ASGNI4
ADDRLP4 9388
INDIRI4
ADDRLP4 9392
INDIRI4
LSHI4
ADDRLP4 9244
ADDP4
ADDRLP4 4
INDIRI4
ADDRLP4 9392
INDIRI4
LSHI4
ADDRGP4 level+84
ADDP4
INDIRI4
ASGNI4
LABELV $295
LABELV $290
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $292
ADDRLP4 4
INDIRI4
ADDRGP4 g_maxclients+12
INDIRI4
GEI4 $298
ADDRLP4 8
INDIRI4
CNSTI4 32
LTI4 $289
LABELV $298
ADDRLP4 9244
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRGP4 SortClients
ARGP4
ADDRGP4 qsort
CALLV
pop
ADDRLP4 1052
CNSTI1 0
ASGNI1
ADDRLP4 9376
CNSTI4 0
ASGNI4
ADDRLP4 1044
ADDRLP4 9376
INDIRI4
ASGNI4
ADDRLP4 4
ADDRLP4 9376
INDIRI4
ASGNI4
ADDRLP4 8
ADDRLP4 9376
INDIRI4
ASGNI4
ADDRGP4 $302
JUMPV
LABELV $299
ADDRLP4 0
CNSTI4 1304
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
CNSTI4 0
EQI4 $304
ADDRLP4 9384
CNSTI4 628
ASGNI4
ADDRLP4 9388
CNSTI4 1264
ASGNI4
ADDRLP4 0
INDIRP4
ADDRLP4 9384
INDIRI4
ADDP4
INDIRP4
ADDRLP4 9388
INDIRI4
ADDP4
INDIRI4
ADDRFP4 0
INDIRP4
ADDRLP4 9384
INDIRI4
ADDP4
INDIRP4
ADDRLP4 9388
INDIRI4
ADDP4
INDIRI4
NEI4 $304
ADDRLP4 1036
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ASGNI4
ADDRLP4 9392
CNSTI4 0
ASGNI4
ADDRLP4 1040
ADDRLP4 9392
INDIRI4
ASGNI4
ADDRLP4 1036
INDIRI4
ADDRLP4 9392
INDIRI4
GEI4 $306
ADDRLP4 1036
CNSTI4 0
ASGNI4
LABELV $306
ADDRLP4 1040
INDIRI4
CNSTI4 0
GEI4 $308
ADDRLP4 1040
CNSTI4 0
ASGNI4
LABELV $308
ADDRLP4 12
ARGP4
CNSTI4 1024
ARGI4
ADDRGP4 $310
ARGP4
ADDRLP4 4
INDIRI4
ARGI4
ADDRLP4 9400
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
ASGNP4
ADDRLP4 9400
INDIRP4
CNSTI4 1208
ADDP4
INDIRI4
ARGI4
ADDRLP4 1036
INDIRI4
ARGI4
ADDRLP4 1040
INDIRI4
ARGI4
ADDRLP4 9400
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 224
ADDP4
INDIRI4
ARGI4
ADDRGP4 Com_sprintf
CALLV
pop
ADDRLP4 12
ARGP4
ADDRLP4 9404
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 1048
ADDRLP4 9404
INDIRI4
ASGNI4
ADDRLP4 1044
INDIRI4
ADDRLP4 1048
INDIRI4
ADDI4
CVIU4 4
CNSTU4 8192
LEU4 $311
ADDRGP4 $301
JUMPV
LABELV $311
ADDRLP4 1044
INDIRI4
ADDRLP4 1052
ADDP4
ARGP4
ADDRLP4 12
ARGP4
ADDRGP4 strcpy
CALLP4
pop
ADDRLP4 1044
ADDRLP4 1044
INDIRI4
ADDRLP4 1048
INDIRI4
ADDI4
ASGNI4
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $304
LABELV $300
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $302
ADDRLP4 4
INDIRI4
ADDRGP4 g_maxclients+12
INDIRI4
GEI4 $313
ADDRLP4 8
INDIRI4
CNSTI4 32
LTI4 $299
LABELV $313
LABELV $301
ADDRGP4 $314
ARGP4
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 1052
ARGP4
ADDRLP4 9380
ADDRGP4 va
CALLP4
ASGNP4
ADDRFP4 0
INDIRP4
CVPU4 4
ADDRGP4 g_entities
CVPU4 4
SUBU4
CVUI4 4
CNSTI4 1304
DIVI4
ARGI4
ADDRLP4 9380
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
LABELV $286
endproc TeamplayInfoMessage 9408 36
export CheckTeamStatus
proc CheckTeamStatus 24 4
ADDRGP4 level+32
INDIRI4
ADDRGP4 level+60
INDIRI4
SUBI4
CNSTI4 1000
LEI4 $316
ADDRGP4 level+60
ADDRGP4 level+32
INDIRI4
ASGNI4
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $325
JUMPV
LABELV $322
ADDRLP4 0
CNSTI4 1304
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1120
ADDP4
INDIRI4
CNSTI4 2
EQI4 $327
ADDRGP4 $323
JUMPV
LABELV $327
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
CNSTI4 0
EQI4 $329
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 1
EQI4 $331
ADDRLP4 16
INDIRI4
CNSTI4 2
NEI4 $329
LABELV $331
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 Team_GetLocation
CALLP4
ASGNP4
ADDRLP4 8
ADDRLP4 20
INDIRP4
ASGNP4
ADDRLP4 8
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $332
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1208
ADDP4
ADDRLP4 8
INDIRP4
CNSTI4 1080
ADDP4
INDIRI4
ASGNI4
ADDRGP4 $333
JUMPV
LABELV $332
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1208
ADDP4
CNSTI4 0
ASGNI4
LABELV $333
LABELV $329
LABELV $323
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $325
ADDRLP4 4
INDIRI4
ADDRGP4 g_maxclients+12
INDIRI4
LTI4 $322
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRGP4 $337
JUMPV
LABELV $334
ADDRLP4 0
CNSTI4 1304
ADDRLP4 4
INDIRI4
MULI4
ADDRGP4 g_entities
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1120
ADDP4
INDIRI4
CNSTI4 2
EQI4 $339
ADDRGP4 $335
JUMPV
LABELV $339
ADDRLP4 0
INDIRP4
CNSTI4 632
ADDP4
INDIRI4
CNSTI4 0
EQI4 $341
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 1
EQI4 $343
ADDRLP4 16
INDIRI4
CNSTI4 2
NEI4 $341
LABELV $343
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 TeamplayInfoMessage
CALLV
pop
LABELV $341
LABELV $335
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $337
ADDRLP4 4
INDIRI4
ADDRGP4 g_maxclients+12
INDIRI4
LTI4 $334
LABELV $316
LABELV $315
endproc CheckTeamStatus 24 4
export SP_team_CTF_redplayer
proc SP_team_CTF_redplayer 0 0
LABELV $344
endproc SP_team_CTF_redplayer 0 0
export SP_team_CTF_blueplayer
proc SP_team_CTF_blueplayer 0 0
LABELV $345
endproc SP_team_CTF_blueplayer 0 0
export SP_team_CTF_redspawn
proc SP_team_CTF_redspawn 0 0
LABELV $346
endproc SP_team_CTF_redspawn 0 0
export SP_team_CTF_bluespawn
proc SP_team_CTF_bluespawn 0 0
LABELV $347
endproc SP_team_CTF_bluespawn 0 0
bss
export neutralObelisk
align 4
LABELV neutralObelisk
skip 4
export teamgame
align 4
LABELV teamgame
skip 36
import trap_SnapVector
import trap_GeneticParentsAndChildSelection
import trap_Characteristic_String
import trap_Characteristic_BInteger
import trap_Characteristic_Integer
import trap_Characteristic_BFloat
import trap_Characteristic_Float
import trap_EA_ResetInput
import trap_EA_GetInput
import trap_EA_EndRegular
import trap_EA_View
import trap_EA_Move
import trap_EA_DelayedJump
import trap_EA_Jump
import trap_EA_SelectWeapon
import trap_EA_MoveRight
import trap_EA_MoveLeft
import trap_EA_MoveBack
import trap_EA_MoveForward
import trap_EA_MoveDown
import trap_EA_MoveUp
import trap_EA_Crouch
import trap_EA_Respawn
import trap_EA_Use
import trap_EA_Attack
import trap_EA_Talk
import trap_EA_Gesture
import trap_EA_Action
import trap_EA_Command
import trap_EA_SayTeam
import trap_EA_Say
import trap_AAS_PredictClientMovement
import trap_AAS_Swimming
import trap_AAS_AlternativeRouteGoals
import trap_AAS_PredictRoute
import trap_AAS_EnableRoutingArea
import trap_AAS_AreaTravelTimeToGoalArea
import trap_AAS_AreaReachability
import trap_AAS_IntForBSPEpairKey
import trap_AAS_FloatForBSPEpairKey
import trap_AAS_VectorForBSPEpairKey
import trap_AAS_ValueForBSPEpairKey
import trap_AAS_NextBSPEntity
import trap_AAS_PointContents
import trap_AAS_TraceAreas
import trap_AAS_PointReachabilityAreaIndex
import trap_AAS_PointAreaNum
import trap_AAS_Time
import trap_AAS_PresenceTypeBoundingBox
import trap_AAS_Initialized
import trap_AAS_EntityInfo
import trap_AAS_AreaInfo
import trap_AAS_BBoxAreas
import trap_BotUserCommand
import trap_BotGetServerCommand
import trap_BotGetSnapshotEntity
import trap_BotLibTest
import trap_BotLibUpdateEntity
import trap_BotLibLoadMap
import trap_BotLibStartFrame
import trap_BotLibDefine
import trap_BotLibVarGet
import trap_BotLibVarSet
import trap_BotLibShutdown
import trap_BotLibSetup
import trap_DebugPolygonDelete
import trap_DebugPolygonCreate
import trap_GetEntityToken
import trap_GetUsercmd
import trap_BotFreeClient
import trap_BotAllocateClient
import trap_EntityContact
import trap_EntitiesInBox
import trap_UnlinkEntity
import trap_LinkEntity
import trap_AreasConnected
import trap_AdjustAreaPortalState
import trap_InPVSIgnorePortals
import trap_InPVS
import trap_PointContents
import trap_Trace
import trap_SetBrushModel
import trap_GetServerinfo
import trap_SetUserinfo
import trap_GetUserinfo
import trap_GetConfigstring
import trap_SetConfigstring
import trap_SendServerCommand
import trap_DropClient
import trap_LocateGameData
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_VariableIntegerValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_SendConsoleCommand
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Args
import trap_Argv
import trap_Argc
import trap_RealTime
import trap_Milliseconds
import trap_Error
import trap_Printf
import g_editmode
import g_running
import g_rolling
import g_allowAdvancedMelee
import g_allowBlock
import g_allowLockon
import g_allowMelee
import g_allowBreakLimit
import g_allowOverheal
import g_allowBallFlip
import g_allowJump
import g_allowZanzoken
import g_allowFly
import g_allowBoost
import g_allowSoar
import g_allowScoreboard
import g_allowTiers
import g_breakLimitRate
import g_powerlevelMaximum
import g_powerlevel
import g_verboseParse
import g_proxMineTimeout
import g_singlePlayer
import g_enableBreath
import g_enableDust
import g_rankings
import pmove_msec
import pmove_fixed
import g_smoothClients
import g_filterBan
import g_banIPs
import g_teamForceBalance
import g_teamAutoJoin
import g_allowVote
import g_doWarmup
import g_warmup
import g_motd
import g_synchronousClients
import g_debugDamage
import g_debugAlloc
import g_debugMove
import g_inactivity
import g_forcerespawn
import g_knockback
import g_needpass
import g_password
import g_friendlyFire
import g_timelimit
import g_fraglimit
import g_dmflags
import g_restarted
import g_maxGameClients
import g_maxclients
import g_cheats
import g_dedicated
import g_gametype
import g_entities
import level
import BotTestAAS
import BotAIStartFrame
import BotAIShutdownClient
import BotAISetupClient
import BotAILoadMap
import BotAIShutdown
import BotAISetup
import G_weapPhys_Parse
import G_RadarUpdateCS
import G_weapPhysParser_MainParse
import G_DieUserWeapon
import G_DetachUserWeapon
import G_RemoveUserWeapon
import G_ExplodeUserWeapon
import G_RunRiftWeaponClass
import G_RunUserTorch
import G_RunUserSkimmer
import G_RunUserMissile
import G_RunUserExplosion
import Release_UserWeapon
import Fire_UserWeapon
import Svcmd_AbortPodium_f
import SpawnModelsOnVictoryPads
import UpdateTournamentInfo
import G_WriteSessionData
import G_InitWorldSession
import G_InitSessionData
import G_ReadSessionData
import Svcmd_GameMem_f
import G_InitMemory
import G_Alloc
import CheckObeliskAttack
import G_RunClient
import ClientEndFrame
import ClientThink
import SetTargetPos
import ClientCommand
import ClientBegin
import ClientDisconnect
import ClientUserinfoChanged
import ClientConnect
import G_Error
import G_Printf
import SendScoreboardMessageToAllClients
import G_LogPrintf
import G_RunThink
import CheckTeamLeader
import SetLeader
import FindIntermissionPoint
import DeathmatchScoreboardMessage
import G_SetStats
import MoveClientToIntermission
import G_GetMuzzleSettings
import FireWeapon
import G_FilterPacket
import G_ProcessIPBans
import ConsoleCommand
import SpotWouldTelefrag
import CalculateRanks
import ClientSpawn
import InitBodyQue
import InitClientResp
import InitClientPersistant
import BeginIntermission
import respawn
import CopyToBodyQue
import SelectSpawnPoint
import SetClientViewAngle
import PickTeam
import TeamLeader
import TeamCount
import Weapon_HookThink
import Weapon_HookFree
import CheckGauntletAttack
import SnapVectorTowards
import CalcMuzzlePoint
import TeleportPlayer
import trigger_teleporter_touch
import Touch_DoorTrigger
import G_RunMover
import G_ExplodeMissile
import G_FreeBeamTrail
import fire_grapple
import fire_bfg
import fire_rocket
import fire_grenade
import fire_plasma
import fire_blaster
import G_RunMissile
import body_die
import G_InvulnerabilityEffect
import G_RadiusDamage
import G_Damage
import CanDamage
import BuildShaderStateConfig
import AddRemap
import G_SetOrigin
import G_AddEvent
import G_AddPredictableEvent
import vectoyaw
import vtos
import tv
import G_TouchSolids
import G_TouchTriggers
import G_EntitiesFree
import G_FreeEntity
import G_Sound
import G_TempEntity
import G_Spawn
import G_InitGentity
import G_SetMovedir
import G_UseTargets
import G_PickTarget
import G_Find
import G_KillBox
import G_TeamCommand
import G_SoundIndex
import G_ModelIndex
import Cmd_FollowCycle_f
import SetTeam
import BroadcastTeamChange
import StopFollowing
import Cmd_Score_f
import G_NewString
import G_SpawnEntitiesFromString
import G_SpawnVector
import G_SpawnInt
import G_SpawnFloat
import G_SpawnString
import G_FindUserWeaponMask
import G_LinkUserWeaponData
import G_FindUserAltWeaponSpawnData
import G_FindUserAltWeaponData
import G_FindUserWeaponSpawnData
import G_FindUserWeaponData
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
LABELV $314
byte 1 116
byte 1 105
byte 1 110
byte 1 102
byte 1 111
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $310
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 32
byte 1 37
byte 1 105
byte 1 0
align 1
LABELV $272
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 0
align 1
LABELV $269
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 115
byte 1 112
byte 1 97
byte 1 119
byte 1 110
byte 1 0
align 1
LABELV $266
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $263
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $257
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $256
byte 1 37
byte 1 99
byte 1 37
byte 1 99
byte 1 37
byte 1 115
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $230
byte 1 68
byte 1 111
byte 1 110
byte 1 39
byte 1 116
byte 1 32
byte 1 107
byte 1 110
byte 1 111
byte 1 119
byte 1 32
byte 1 119
byte 1 104
byte 1 97
byte 1 116
byte 1 32
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 116
byte 1 104
byte 1 101
byte 1 32
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 32
byte 1 105
byte 1 115
byte 1 32
byte 1 111
byte 1 110
byte 1 46
byte 1 10
byte 1 0
align 1
LABELV $229
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 98
byte 1 108
byte 1 117
byte 1 101
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $226
byte 1 116
byte 1 101
byte 1 97
byte 1 109
byte 1 95
byte 1 67
byte 1 84
byte 1 70
byte 1 95
byte 1 114
byte 1 101
byte 1 100
byte 1 102
byte 1 108
byte 1 97
byte 1 103
byte 1 0
align 1
LABELV $113
byte 1 112
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 34
byte 1 0
align 1
LABELV $108
byte 1 80
byte 1 114
byte 1 105
byte 1 110
byte 1 116
byte 1 77
byte 1 115
byte 1 103
byte 1 32
byte 1 111
byte 1 118
byte 1 101
byte 1 114
byte 1 114
byte 1 117
byte 1 110
byte 1 0
align 1
LABELV $103
byte 1 94
byte 1 55
byte 1 0
align 1
LABELV $102
byte 1 94
byte 1 51
byte 1 0
align 1
LABELV $99
byte 1 94
byte 1 52
byte 1 0
align 1
LABELV $96
byte 1 94
byte 1 49
byte 1 0
align 1
LABELV $85
byte 1 70
byte 1 82
byte 1 69
byte 1 69
byte 1 0
align 1
LABELV $84
byte 1 83
byte 1 80
byte 1 69
byte 1 67
byte 1 84
byte 1 65
byte 1 84
byte 1 79
byte 1 82
byte 1 0
align 1
LABELV $81
byte 1 66
byte 1 76
byte 1 85
byte 1 69
byte 1 0
align 1
LABELV $78
byte 1 82
byte 1 69
byte 1 68
byte 1 0
