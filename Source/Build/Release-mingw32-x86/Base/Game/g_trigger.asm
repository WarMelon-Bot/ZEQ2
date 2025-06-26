export InitTrigger
code
proc InitTrigger 12 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRGP4 vec3_origin
ARGP4
ADDRLP4 0
ADDRGP4 VectorCompare
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 0
NEI4 $64
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1120
ADDP4
ARGP4
ADDRGP4 G_SetMovedir
CALLV
pop
LABELV $64
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 652
ADDP4
INDIRP4
ARGP4
ADDRGP4 trap_SetBrushModel
CALLV
pop
ADDRFP4 0
INDIRP4
CNSTI4 572
ADDP4
CNSTI4 1073741824
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
CNSTI4 1
ASGNI4
LABELV $63
endproc InitTrigger 12 8
export multi_wait
proc multi_wait 0 0
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
CNSTI4 0
ASGNI4
LABELV $66
endproc multi_wait 0 0
export multi_trigger
proc multi_trigger 12 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1228
ADDP4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
INDIRI4
CNSTI4 0
EQI4 $68
ADDRGP4 $67
JUMPV
LABELV $68
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $70
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
BANDI4
CNSTI4 0
EQI4 $72
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
ADDRLP4 0
INDIRI4
EQI4 $72
ADDRGP4 $67
JUMPV
LABELV $72
ADDRLP4 4
CNSTI4 2
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
BANDI4
CNSTI4 0
EQI4 $74
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
ADDRLP4 4
INDIRI4
EQI4 $74
ADDRGP4 $67
JUMPV
LABELV $74
LABELV $70
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1228
ADDP4
INDIRP4
ARGP4
ADDRGP4 G_UseTargets
CALLV
pop
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
CNSTF4 0
LEF4 $76
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 multi_wait
ASGNP4
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CVIF4 4
CNSTF4 1148846080
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
MULF4
ADDF4
MULF4
ADDF4
CVFI4 4
ASGNI4
ADDRGP4 $77
JUMPV
LABELV $76
ADDRFP4 0
INDIRP4
CNSTI4 1148
ADDP4
CNSTP4 0
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 G_FreeEntity
ASGNP4
LABELV $77
LABELV $67
endproc multi_trigger 12 8
export Use_Multi
proc Use_Multi 0 8
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 8
INDIRP4
ARGP4
ADDRGP4 multi_trigger
CALLV
pop
LABELV $80
endproc Use_Multi 0 8
export Touch_Multi
proc Touch_Multi 0 8
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $82
ADDRGP4 $81
JUMPV
LABELV $82
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRGP4 multi_trigger
CALLV
pop
LABELV $81
endproc Touch_Multi 0 8
export SP_trigger_multiple
proc SP_trigger_multiple 12 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $85
ARGP4
ADDRGP4 $86
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
ARGP4
ADDRGP4 G_SpawnFloat
CALLI4
pop
ADDRGP4 $87
ARGP4
ADDRGP4 $88
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
ARGP4
ADDRGP4 G_SpawnFloat
CALLI4
pop
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
INDIRF4
ADDRLP4 4
INDIRF4
LTF4 $89
ADDRLP4 4
INDIRF4
CNSTF4 0
LTF4 $89
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
ADDRGP4 $91
ARGP4
ADDRGP4 G_Printf
CALLV
pop
LABELV $89
ADDRFP4 0
INDIRP4
CNSTI4 1148
ADDP4
ADDRGP4 Touch_Multi
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1152
ADDP4
ADDRGP4 Use_Multi
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 InitTrigger
CALLV
pop
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
LABELV $84
endproc SP_trigger_multiple 12 12
export trigger_always_think
proc trigger_always_think 4 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_UseTargets
CALLV
pop
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
LABELV $92
endproc trigger_always_think 4 8
export SP_trigger_always
proc SP_trigger_always 0 0
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 300
ADDI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 trigger_always_think
ASGNP4
LABELV $93
endproc SP_trigger_always 0 0
export trigger_push_touch
proc trigger_push_touch 0 8
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $96
ADDRGP4 $95
JUMPV
LABELV $96
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 BG_TouchJumpPad
CALLV
pop
LABELV $95
endproc trigger_push_touch 0 8
export AimAtTarget
proc AimAtTarget 72 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 576
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 588
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+4
ADDRFP4 0
INDIRP4
CNSTI4 580
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 592
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 0+8
ADDRFP4 0
INDIRP4
CNSTI4 584
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 596
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 44
CNSTF4 1056964608
ASGNF4
ADDRLP4 0
ADDRLP4 44
INDIRF4
ADDRLP4 0
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+4
ADDRLP4 44
INDIRF4
ADDRLP4 0+4
INDIRF4
MULF4
ASGNF4
ADDRLP4 0+8
CNSTF4 1056964608
ADDRLP4 0+8
INDIRF4
MULF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRP4
ARGP4
ADDRLP4 48
ADDRGP4 G_PickTarget
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 48
INDIRP4
ASGNP4
ADDRLP4 12
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $105
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
ADDRGP4 $98
JUMPV
LABELV $105
ADDRLP4 28
ADDRLP4 12
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
ADDRLP4 24
CNSTF4 1148846080
ASGNF4
ADDRLP4 28
INDIRF4
CNSTF4 1056964608
ADDRLP4 24
INDIRF4
MULF4
DIVF4
ARGF4
ADDRLP4 52
ADDRGP4 sqrt
CALLF4
ASGNF4
ADDRLP4 16
ADDRLP4 52
INDIRF4
ASGNF4
ADDRLP4 16
INDIRF4
CNSTF4 0
NEF4 $108
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 G_FreeEntity
CALLV
pop
ADDRGP4 $98
JUMPV
LABELV $108
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 92
ADDP4
INDIRF4
ADDRLP4 0
INDIRF4
SUBF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 96
ADDP4
INDIRF4
ADDRLP4 0+4
INDIRF4
SUBF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 12
INDIRP4
CNSTI4 100
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
SUBF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
CNSTF4 0
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ARGP4
ADDRLP4 56
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 32
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 20
ADDRLP4 32
INDIRF4
ADDRLP4 16
INDIRF4
DIVF4
ASGNF4
ADDRLP4 60
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 60
INDIRP4
ADDRLP4 60
INDIRP4
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ASGNF4
ADDRLP4 64
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
ASGNP4
ADDRLP4 64
INDIRP4
ADDRLP4 64
INDIRP4
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ASGNF4
ADDRLP4 68
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ASGNP4
ADDRLP4 68
INDIRP4
ADDRLP4 68
INDIRP4
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ADDRLP4 16
INDIRF4
ADDRLP4 24
INDIRF4
MULF4
ASGNF4
LABELV $98
endproc AimAtTarget 72 4
export SP_trigger_push
proc SP_trigger_push 4 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 InitTrigger
CALLV
pop
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
ADDRGP4 $113
ARGP4
ADDRGP4 G_SoundIndex
CALLI4
pop
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 8
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1148
ADDP4
ADDRGP4 trigger_push_touch
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 AimAtTarget
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
LABELV $112
endproc SP_trigger_push 4 4
export Use_target_push
proc Use_target_push 0 12
ADDRFP4 8
ADDRFP4 8
INDIRP4
ASGNP4
ADDRFP4 8
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $116
ADDRGP4 $115
JUMPV
LABELV $116
ADDRFP4 8
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $118
ADDRGP4 $115
JUMPV
LABELV $118
ADDRFP4 8
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
INDIRB
ASGNB 12
ADDRFP4 8
INDIRP4
CNSTI4 1168
ADDP4
INDIRI4
ADDRGP4 level+32
INDIRI4
GEI4 $120
ADDRFP4 8
INDIRP4
CNSTI4 1168
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 1500
ADDI4
ASGNI4
ADDRFP4 8
INDIRP4
ARGP4
CNSTI4 0
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 1248
ADDP4
INDIRI4
ARGI4
ADDRGP4 G_Sound
CALLV
pop
LABELV $120
LABELV $115
endproc Use_target_push 0 12
export SP_target_push
proc SP_target_push 36 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRF4
CNSTF4 0
NEF4 $125
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
CNSTF4 1148846080
ASGNF4
LABELV $125
ADDRFP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ARGP4
ADDRGP4 G_SetMovedir
CALLV
pop
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 104
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 108
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 112
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 784
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $127
ADDRGP4 $113
ARGP4
ADDRLP4 28
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1248
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
ADDRGP4 $128
JUMPV
LABELV $127
ADDRGP4 $129
ARGP4
ADDRLP4 28
ADDRGP4 G_SoundIndex
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1248
ADDP4
ADDRLP4 28
INDIRI4
ASGNI4
LABELV $128
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $130
ADDRFP4 0
INDIRP4
CNSTI4 576
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 588
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 AimAtTarget
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
LABELV $130
ADDRFP4 0
INDIRP4
CNSTI4 1152
ADDP4
ADDRGP4 Use_target_push
ASGNP4
LABELV $124
endproc SP_target_push 36 8
export trigger_teleporter_touch
proc trigger_teleporter_touch 12 12
ADDRFP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $134
ADDRGP4 $133
JUMPV
LABELV $134
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
CNSTI4 3
NEI4 $136
ADDRGP4 $133
JUMPV
LABELV $136
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $138
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1264
ADDP4
INDIRI4
CNSTI4 3
EQI4 $138
ADDRGP4 $133
JUMPV
LABELV $138
ADDRFP4 0
INDIRP4
CNSTI4 760
ADDP4
INDIRP4
ARGP4
ADDRLP4 4
ADDRGP4 G_PickTarget
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
NEU4 $140
ADDRGP4 $142
ARGP4
ADDRGP4 G_Printf
CALLV
pop
ADDRGP4 $133
JUMPV
LABELV $140
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 116
ADDP4
ARGP4
ADDRGP4 TeleportPlayer
CALLV
pop
LABELV $133
endproc trigger_teleporter_touch 12 12
export SP_trigger_teleport
proc SP_trigger_teleport 4 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 InitTrigger
CALLV
pop
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $144
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
ADDRGP4 $145
JUMPV
LABELV $144
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
LABELV $145
ADDRGP4 $113
ARGP4
ADDRGP4 G_SoundIndex
CALLI4
pop
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
CNSTI4 9
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1148
ADDP4
ADDRGP4 trigger_teleporter_touch
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
LABELV $143
endproc SP_trigger_teleport 4 4
export hurt_use
proc hurt_use 0 4
ADDRFP4 0
INDIRP4
CNSTI4 528
ADDP4
INDIRI4
CNSTI4 0
EQI4 $147
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_UnlinkEntity
CALLV
pop
ADDRGP4 $148
JUMPV
LABELV $147
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
LABELV $148
LABELV $146
endproc hurt_use 0 4
export hurt_touch
proc hurt_touch 12 12
ADDRFP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $150
ADDRLP4 0
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 624
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 8000000
ADDI4
ASGNI4
ADDRGP4 $152
ARGP4
ADDRFP4 4
INDIRP4
CNSTI4 628
ADDP4
INDIRP4
CNSTI4 1160
ADDP4
ARGP4
ADDRLP4 4
ADDRGP4 va
CALLP4
ASGNP4
CNSTI4 -1
ARGI4
ADDRLP4 4
INDIRP4
ARGP4
ADDRGP4 trap_SendServerCommand
CALLV
pop
CNSTI4 2
ARGI4
ADDRGP4 $153
ARGP4
ADDRGP4 trap_SendConsoleCommand
CALLV
pop
ADDRFP4 4
INDIRP4
CNSTI4 1156
ADDP4
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $154
ADDRFP4 4
INDIRP4
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
CNSTI4 8000000
ARGI4
ADDRFP4 4
INDIRP4
CNSTI4 1156
ADDP4
INDIRP4
CALLV
pop
LABELV $154
LABELV $150
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
NEI4 $156
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 trap_LinkEntity
CALLV
pop
LABELV $156
LABELV $149
endproc hurt_touch 12 12
export SP_trigger_hurt
proc SP_trigger_hurt 0 4
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 InitTrigger
CALLV
pop
ADDRFP4 0
INDIRP4
CNSTI4 1148
ADDP4
ADDRGP4 hurt_touch
ASGNP4
LABELV $158
endproc SP_trigger_hurt 0 4
export func_timer_think
proc func_timer_think 12 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1228
ADDP4
INDIRP4
ARGP4
ADDRGP4 G_UseTargets
CALLV
pop
ADDRLP4 4
ADDRGP4 rand
CALLI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CVIF4 4
CNSTF4 1148846080
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
CNSTF4 1073741824
ADDRLP4 4
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
INDIRF4
MULF4
ADDF4
MULF4
ADDF4
CVFI4 4
ASGNI4
LABELV $159
endproc func_timer_think 12 8
export func_timer_use
proc func_timer_use 0 4
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1228
ADDP4
ADDRFP4 8
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
INDIRI4
CNSTI4 0
EQI4 $162
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
CNSTI4 0
ASGNI4
ADDRGP4 $161
JUMPV
LABELV $162
ADDRFP4 0
INDIRP4
ARGP4
ADDRGP4 func_timer_think
CALLV
pop
LABELV $161
endproc func_timer_use 0 4
export SP_func_timer
proc SP_func_timer 12 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRGP4 $87
ARGP4
ADDRGP4 $165
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
ARGP4
ADDRGP4 G_SpawnFloat
CALLI4
pop
ADDRGP4 $85
ARGP4
ADDRGP4 $165
ARGP4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
ARGP4
ADDRGP4 G_SpawnFloat
CALLI4
pop
ADDRFP4 0
INDIRP4
CNSTI4 1152
ADDP4
ADDRGP4 func_timer_use
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1136
ADDP4
ADDRGP4 func_timer_think
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
INDIRF4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
LTF4 $166
ADDRFP4 0
INDIRP4
CNSTI4 1256
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 1252
ADDP4
INDIRF4
CNSTF4 1120403456
SUBF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 92
ADDP4
ARGP4
ADDRLP4 8
ADDRGP4 vtos
CALLP4
ASGNP4
ADDRGP4 $168
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 G_Printf
CALLV
pop
LABELV $166
ADDRFP4 0
INDIRP4
CNSTI4 640
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $169
ADDRFP4 0
INDIRP4
CNSTI4 1132
ADDP4
ADDRGP4 level+32
INDIRI4
CNSTI4 100
ADDI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1228
ADDP4
ADDRFP4 0
INDIRP4
ASGNP4
LABELV $169
ADDRFP4 0
INDIRP4
CNSTI4 536
ADDP4
CNSTI4 1
ASGNI4
LABELV $164
endproc SP_func_timer 12 12
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
import Pickup_Team
import CheckTeamStatus
import TeamplayInfoMessage
import Team_GetLocationMsg
import Team_GetLocation
import SelectCTFSpawnPoint
import Team_FreeEntity
import Team_ReturnFlag
import Team_InitGame
import Team_CheckHurtCarrier
import Team_FragBonuses
import Team_DroppedFlagThink
import AddTeamScore
import TeamColorString
import OtherTeamName
import TeamName
import OtherTeam
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
import Team_CheckDroppedItem
import OnSameTeam
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
LABELV $168
byte 1 102
byte 1 117
byte 1 110
byte 1 99
byte 1 95
byte 1 116
byte 1 105
byte 1 109
byte 1 101
byte 1 114
byte 1 32
byte 1 97
byte 1 116
byte 1 32
byte 1 37
byte 1 115
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 32
byte 1 62
byte 1 61
byte 1 32
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $165
byte 1 49
byte 1 0
align 1
LABELV $153
byte 1 109
byte 1 97
byte 1 112
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 32
byte 1 53
byte 1 10
byte 1 0
align 1
LABELV $152
byte 1 99
byte 1 112
byte 1 32
byte 1 34
byte 1 37
byte 1 115
byte 1 94
byte 1 55
byte 1 32
byte 1 87
byte 1 97
byte 1 115
byte 1 32
byte 1 80
byte 1 117
byte 1 116
byte 1 32
byte 1 75
byte 1 110
byte 1 111
byte 1 99
byte 1 107
byte 1 32
byte 1 79
byte 1 117
byte 1 116
byte 1 10
byte 1 34
byte 1 0
align 1
LABELV $142
byte 1 67
byte 1 111
byte 1 117
byte 1 108
byte 1 100
byte 1 110
byte 1 39
byte 1 116
byte 1 32
byte 1 102
byte 1 105
byte 1 110
byte 1 100
byte 1 32
byte 1 116
byte 1 101
byte 1 108
byte 1 101
byte 1 112
byte 1 111
byte 1 114
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 100
byte 1 101
byte 1 115
byte 1 116
byte 1 105
byte 1 110
byte 1 97
byte 1 116
byte 1 105
byte 1 111
byte 1 110
byte 1 10
byte 1 0
align 1
LABELV $129
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 109
byte 1 105
byte 1 115
byte 1 99
byte 1 47
byte 1 119
byte 1 105
byte 1 110
byte 1 100
byte 1 102
byte 1 108
byte 1 121
byte 1 46
byte 1 111
byte 1 103
byte 1 103
byte 1 0
align 1
LABELV $113
byte 1 115
byte 1 111
byte 1 117
byte 1 110
byte 1 100
byte 1 47
byte 1 119
byte 1 111
byte 1 114
byte 1 108
byte 1 100
byte 1 47
byte 1 106
byte 1 117
byte 1 109
byte 1 112
byte 1 112
byte 1 97
byte 1 100
byte 1 46
byte 1 111
byte 1 103
byte 1 103
byte 1 0
align 1
LABELV $91
byte 1 116
byte 1 114
byte 1 105
byte 1 103
byte 1 103
byte 1 101
byte 1 114
byte 1 95
byte 1 109
byte 1 117
byte 1 108
byte 1 116
byte 1 105
byte 1 112
byte 1 108
byte 1 101
byte 1 32
byte 1 104
byte 1 97
byte 1 115
byte 1 32
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 32
byte 1 62
byte 1 61
byte 1 32
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $88
byte 1 48
byte 1 0
align 1
LABELV $87
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 0
align 1
LABELV $86
byte 1 48
byte 1 46
byte 1 53
byte 1 0
align 1
LABELV $85
byte 1 119
byte 1 97
byte 1 105
byte 1 116
byte 1 0
