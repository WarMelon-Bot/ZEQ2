export CG_InitTrails
code
proc CG_InitTrails 0 12
ADDRGP4 cg_trails
ARGP4
CNSTI4 0
ARGI4
CNSTI4 516096
ARGI4
ADDRGP4 memset
CALLP4
pop
LABELV $102
endproc CG_InitTrails 0 12
export CG_ResetTrail
proc CG_ResetTrail 4 0
ADDRFP4 0
ADDRFP4 0
INDIRI4
ASGNI4
ADDRFP4 4
ADDRFP4 4
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $104
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails
ADDP4
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
LABELV $105
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 20
LTI4 $104
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+492
ADDP4
ADDRFP4 16
INDIRI4
ASGNI4
ADDRFP4 8
INDIRF4
CNSTF4 1133903872
LEF4 $109
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+500
ADDP4
ADDRFP4 8
INDIRF4
ASGNF4
ADDRGP4 $110
JUMPV
LABELV $109
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+500
ADDP4
CNSTF4 1133903872
ASGNF4
LABELV $110
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+496
ADDP4
ADDRFP4 12
INDIRF4
ASGNF4
ADDRFP4 20
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $114
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+480
ADDP4
ADDRFP4 20
INDIRP4
INDIRB
ASGNB 12
ADDRGP4 $115
JUMPV
LABELV $114
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+480
ADDP4
CNSTF4 1065353216
ASGNF4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+480+4
ADDP4
CNSTF4 1065353216
ASGNF4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+480+8
ADDP4
CNSTF4 1065353216
ASGNF4
LABELV $115
LABELV $103
endproc CG_ResetTrail 4 0
export CG_UpdateTrailHead
proc CG_UpdateTrailHead 0 0
ADDRFP4 0
ADDRFP4 0
INDIRI4
ASGNI4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails
ADDP4
ADDRFP4 4
INDIRP4
INDIRB
ASGNB 12
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+240
ADDP4
CNSTF4 0
ASGNF4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+240+4
ADDP4
CNSTF4 0
ASGNF4
CNSTI4 504
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 cg_trails+240+8
ADDP4
CNSTF4 0
ASGNF4
LABELV $122
endproc CG_UpdateTrailHead 0 0
proc CG_LerpTrails 128 8
ADDRLP4 28
CNSTI4 0
ASGNI4
LABELV $129
ADDRLP4 4
CNSTI4 504
ADDRLP4 28
INDIRI4
MULI4
ADDRGP4 cg_trails
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ARGP4
ADDRLP4 4
INDIRP4
CNSTI4 228
ADDP4
ARGP4
ADDRLP4 36
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
NEF4 $133
CNSTI4 35276
ADDRLP4 28
INDIRI4
MULI4
ADDRGP4 cg_entities+8
ADDP4
INDIRI4
CNSTI4 16384
BANDI4
CNSTI4 0
NEI4 $133
ADDRGP4 $130
JUMPV
LABELV $133
ADDRLP4 0
CNSTI4 1
ASGNI4
LABELV $136
ADDRLP4 40
CNSTI4 12
ASGNI4
ADDRLP4 44
ADDRLP4 40
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 52
ADDRLP4 44
INDIRI4
ADDRLP4 40
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
ADDRLP4 56
ADDRLP4 44
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
ADDRLP4 8
ADDRLP4 52
INDIRP4
INDIRF4
ADDRLP4 56
INDIRP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 60
CNSTI4 4
ASGNI4
ADDRLP4 8+4
ADDRLP4 52
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
ADDRLP4 56
INDIRP4
ADDRLP4 60
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 64
CNSTI4 12
ASGNI4
ADDRLP4 68
ADDRLP4 64
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 76
CNSTI4 8
ASGNI4
ADDRLP4 8+8
ADDRLP4 68
INDIRI4
ADDRLP4 64
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
ADDRLP4 68
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 76
INDIRI4
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 8
ARGP4
ADDRLP4 80
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 24
ADDRLP4 80
INDIRF4
ASGNF4
ADDRLP4 20
CNSTF4 981668463
ADDRLP4 4
INDIRP4
CNSTI4 500
ADDP4
INDIRF4
CNSTI4 28
ADDRLP4 0
INDIRI4
SUBI4
CVIF4 4
CNSTF4 1109393408
DIVF4
MULF4
ADDRGP4 cg+137584
INDIRI4
CVIF4 4
MULF4
MULF4
ASGNF4
ADDRLP4 20
INDIRF4
ADDRLP4 24
INDIRF4
LEF4 $143
ADDRLP4 84
CNSTI4 12
ASGNI4
ADDRLP4 88
ADDRLP4 84
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 88
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 88
INDIRI4
ADDRLP4 84
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
INDIRB
ASGNB 12
ADDRLP4 96
CNSTI4 12
ASGNI4
ADDRLP4 100
ADDRLP4 96
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 104
ADDRLP4 4
INDIRP4
CNSTI4 240
ADDP4
ASGNP4
ADDRLP4 100
INDIRI4
ADDRLP4 104
INDIRP4
ADDP4
ADDRLP4 100
INDIRI4
ADDRLP4 96
INDIRI4
SUBI4
ADDRLP4 104
INDIRP4
ADDP4
INDIRB
ASGNB 12
ADDRGP4 $137
JUMPV
LABELV $143
ADDRLP4 24
INDIRF4
ADDRLP4 20
INDIRF4
SUBF4
CNSTF4 1120403456
LEF4 $145
ADDRLP4 84
CNSTI4 12
ASGNI4
ADDRLP4 88
ADDRLP4 84
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 88
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 88
INDIRI4
ADDRLP4 84
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
INDIRF4
CNSTF4 3267887104
ADDRLP4 8
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 96
CNSTI4 12
ASGNI4
ADDRLP4 100
ADDRLP4 96
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 108
CNSTI4 4
ASGNI4
ADDRLP4 100
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 108
INDIRI4
ADDP4
ADDRLP4 100
INDIRI4
ADDRLP4 96
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 108
INDIRI4
ADDP4
INDIRF4
CNSTF4 3267887104
ADDRLP4 8+4
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 112
CNSTI4 12
ASGNI4
ADDRLP4 116
ADDRLP4 112
INDIRI4
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 124
CNSTI4 8
ASGNI4
ADDRLP4 116
INDIRI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 124
INDIRI4
ADDP4
ADDRLP4 116
INDIRI4
ADDRLP4 112
INDIRI4
SUBI4
ADDRLP4 4
INDIRP4
ADDP4
ADDRLP4 124
INDIRI4
ADDP4
INDIRF4
CNSTF4 3267887104
ADDRLP4 8+8
INDIRF4
MULF4
ADDF4
ASGNF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
CNSTI4 240
ADDP4
ADDP4
ADDRLP4 8
INDIRB
ASGNB 12
ADDRGP4 $137
JUMPV
LABELV $145
ADDRLP4 84
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
ASGNP4
ADDRLP4 84
INDIRP4
ADDRLP4 84
INDIRP4
INDIRF4
ADDRLP4 8
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 88
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
CNSTI4 4
ADDP4
ASGNP4
ADDRLP4 88
INDIRP4
ADDRLP4 88
INDIRP4
INDIRF4
ADDRLP4 8+4
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 92
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
ADDP4
CNSTI4 8
ADDP4
ASGNP4
ADDRLP4 92
INDIRP4
ADDRLP4 92
INDIRP4
INDIRF4
ADDRLP4 8+8
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
ADDF4
ASGNF4
CNSTI4 12
ADDRLP4 0
INDIRI4
MULI4
ADDRLP4 4
INDIRP4
CNSTI4 240
ADDP4
ADDP4
ADDRLP4 8
INDIRB
ASGNB 12
LABELV $137
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 20
LTI4 $136
LABELV $130
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 1024
LTI4 $129
LABELV $128
endproc CG_LerpTrails 128 8
proc CG_ShiftTrailVerts 24 0
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 72
ADDP4
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 48
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRB
ASGNB 12
ADDRFP4 0
INDIRP4
CNSTI4 84
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 88
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 60
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRF4
ASGNF4
ADDRFP4 0
INDIRP4
CNSTI4 64
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRF4
ASGNF4
LABELV $151
endproc CG_ShiftTrailVerts 24 0
proc CG_GetTrailVerts 56 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 8
ADDRFP4 8
INDIRF4
ASGNF4
ADDRFP4 12
ADDRFP4 12
INDIRP4
ASGNP4
ADDRLP4 12
ADDRFP4 0
INDIRP4
INDIRF4
ADDRGP4 cg+174228+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRGP4 cg+174228+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+8
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRGP4 cg+174228+24+8
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
ADDRLP4 0
ARGP4
ADDRLP4 44
ADDRGP4 VectorNormalize
CALLF4
ASGNF4
ADDRLP4 36
ADDRLP4 44
INDIRF4
ASGNF4
ADDRLP4 36
INDIRF4
CNSTF4 0
NEF4 $163
ADDRLP4 24
ADDRFP4 0
INDIRP4
INDIRB
ASGNB 12
ADDRLP4 24+8
ADDRLP4 24+8
INDIRF4
CNSTF4 1036831949
ADDF4
ASGNF4
ADDRLP4 12
ADDRLP4 24
INDIRF4
ADDRGP4 cg+174228+24
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+4
ADDRLP4 24+4
INDIRF4
ADDRGP4 cg+174228+24+4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12+8
ADDRLP4 24+8
INDIRF4
ADDRGP4 cg+174228+24+8
INDIRF4
SUBF4
ASGNF4
ADDRLP4 12
ARGP4
ADDRFP4 4
INDIRP4
ARGP4
ADDRLP4 0
ARGP4
ADDRGP4 CrossProduct
CALLV
pop
ADDRLP4 0
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
LABELV $163
ADDRFP4 12
INDIRP4
ADDRFP4 0
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDRFP4 8
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 48
CNSTI4 4
ASGNI4
ADDRFP4 12
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 48
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0+4
INDIRF4
ADDRFP4 8
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 52
CNSTI4 8
ASGNI4
ADDRFP4 12
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
ADDRFP4 0
INDIRP4
ADDRLP4 52
INDIRI4
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
ADDRFP4 8
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
CNSTI4 24
ADDP4
ADDRFP4 0
INDIRP4
INDIRF4
ADDRLP4 0
INDIRF4
ADDRFP4 8
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
CNSTI4 28
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
ADDRLP4 0+4
INDIRF4
ADDRFP4 8
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
ADDRFP4 12
INDIRP4
CNSTI4 32
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ADDRLP4 0+8
INDIRF4
ADDRFP4 8
INDIRF4
NEGF4
MULF4
ADDF4
ASGNF4
LABELV $152
endproc CG_GetTrailVerts 56 12
export CG_AddTrailsToScene
proc CG_AddTrailsToScene 196 16
ADDRGP4 CG_LerpTrails
CALLV
pop
ADDRLP4 12
ARGP4
CNSTI4 0
ARGI4
CNSTI4 96
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRLP4 12+12+4
CNSTF4 1065353216
ASGNF4
ADDRLP4 12+24+12+4
CNSTF4 0
ASGNF4
ADDRLP4 12+48+12+4
CNSTF4 0
ASGNF4
ADDRLP4 12+72+12+4
CNSTF4 1065353216
ASGNF4
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $194
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 12+20+3
ADDP4
CNSTU1 255
ASGNU1
LABELV $195
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 4
LTI4 $194
ADDRLP4 120
CNSTI4 0
ASGNI4
LABELV $200
ADDRLP4 8
CNSTI4 504
ADDRLP4 120
INDIRI4
MULI4
ADDRGP4 cg_trails
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
CNSTI4 492
ADDP4
INDIRI4
CNSTI4 0
NEI4 $204
ADDRGP4 $201
JUMPV
LABELV $204
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 228
ADDP4
ARGP4
ADDRLP4 128
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 128
INDIRF4
CNSTF4 0
NEF4 $206
CNSTI4 35276
ADDRLP4 120
INDIRI4
MULI4
ADDRGP4 cg_entities+8
ADDP4
INDIRI4
CNSTI4 16384
BANDI4
CNSTI4 0
NEI4 $206
ADDRGP4 $201
JUMPV
LABELV $206
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $209
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $213
ADDRLP4 140
CNSTF4 1132396544
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 8
INDIRP4
CNSTI4 480
ADDP4
ADDP4
INDIRF4
MULF4
ASGNF4
ADDRLP4 144
CNSTF4 1325400064
ASGNF4
ADDRLP4 140
INDIRF4
ADDRLP4 144
INDIRF4
LTF4 $219
ADDRLP4 132
ADDRLP4 140
INDIRF4
ADDRLP4 144
INDIRF4
SUBF4
CVFI4 4
CVIU4 4
CNSTU4 2147483648
ADDU4
ASGNU4
ADDRGP4 $220
JUMPV
LABELV $219
ADDRLP4 132
ADDRLP4 140
INDIRF4
CVFI4 4
CVIU4 4
ASGNU4
LABELV $220
ADDRLP4 0
INDIRI4
CNSTI4 24
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 12+20
ADDP4
ADDP4
ADDRLP4 132
INDIRU4
CVUU1 4
ASGNU1
LABELV $214
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 3
LTI4 $213
LABELV $210
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 4
LTI4 $209
ADDRLP4 4
CNSTI4 19
ASGNI4
ADDRLP4 108
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
CNSTI4 240
ADDP4
ADDP4
INDIRB
ASGNB 12
ADDRLP4 108
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
ARGP4
ADDRLP4 108
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ARGF4
ADDRLP4 12
ARGP4
ADDRGP4 CG_GetTrailVerts
CALLV
pop
ADDRLP4 136
CNSTF4 0
ASGNF4
ADDRLP4 12+24+12
ADDRLP4 136
INDIRF4
ASGNF4
ADDRLP4 12+12
ADDRLP4 136
INDIRF4
ASGNF4
ADDRLP4 12
ARGP4
ADDRGP4 CG_ShiftTrailVerts
CALLV
pop
ADDRLP4 4
CNSTI4 18
ASGNI4
LABELV $224
ADDRLP4 140
CNSTI4 12
ASGNI4
ADDRLP4 144
ADDRLP4 140
INDIRI4
ADDRLP4 4
INDIRI4
MULI4
ASGNI4
ADDRLP4 144
INDIRI4
ADDRLP4 140
INDIRI4
ADDI4
ADDRLP4 8
INDIRP4
ADDP4
ARGP4
ADDRLP4 144
INDIRI4
ADDRLP4 8
INDIRP4
ADDP4
ARGP4
ADDRLP4 152
ADDRGP4 Distance
CALLF4
ASGNF4
ADDRLP4 152
INDIRF4
CNSTF4 0
NEF4 $228
ADDRGP4 $225
JUMPV
LABELV $228
ADDRLP4 4
INDIRI4
CNSTI4 0
EQI4 $232
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
CNSTI4 240
ADDP4
ADDP4
ARGP4
ADDRLP4 160
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 160
INDIRF4
CNSTF4 0
NEF4 $230
LABELV $232
ADDRLP4 108
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
CNSTI4 252
ADDP4
ADDP4
INDIRB
ASGNB 12
ADDRGP4 $231
JUMPV
LABELV $230
ADDRLP4 164
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ASGNI4
ADDRLP4 172
ADDRLP4 164
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 240
ADDP4
ADDP4
ASGNP4
ADDRLP4 176
ADDRLP4 164
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 252
ADDP4
ADDP4
ASGNP4
ADDRLP4 108
ADDRLP4 172
INDIRP4
INDIRF4
ADDRLP4 176
INDIRP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 180
CNSTI4 4
ASGNI4
ADDRLP4 108+4
ADDRLP4 172
INDIRP4
ADDRLP4 180
INDIRI4
ADDP4
INDIRF4
ADDRLP4 176
INDIRP4
ADDRLP4 180
INDIRI4
ADDP4
INDIRF4
ADDF4
ASGNF4
ADDRLP4 184
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ASGNI4
ADDRLP4 192
CNSTI4 8
ASGNI4
ADDRLP4 108+8
ADDRLP4 184
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 240
ADDP4
ADDP4
ADDRLP4 192
INDIRI4
ADDP4
INDIRF4
ADDRLP4 184
INDIRI4
ADDRLP4 8
INDIRP4
CNSTI4 252
ADDP4
ADDP4
ADDRLP4 192
INDIRI4
ADDP4
INDIRF4
ADDF4
ASGNF4
LABELV $231
ADDRLP4 108
ARGP4
ADDRGP4 VectorNormalize
CALLF4
pop
CNSTI4 12
ADDRLP4 4
INDIRI4
MULI4
ADDRLP4 8
INDIRP4
ADDP4
ARGP4
ADDRLP4 108
ARGP4
ADDRLP4 8
INDIRP4
CNSTI4 496
ADDP4
INDIRF4
ARGF4
ADDRLP4 12
ARGP4
ADDRGP4 CG_GetTrailVerts
CALLV
pop
ADDRLP4 168
CNSTF4 1065353216
ADDRLP4 4
INDIRI4
CVIF4 4
CNSTF4 1100480512
DIVF4
SUBF4
ASGNF4
ADDRLP4 12+24+12
ADDRLP4 168
INDIRF4
ASGNF4
ADDRLP4 12+12
ADDRLP4 168
INDIRF4
ASGNF4
ADDRLP4 8
INDIRP4
CNSTI4 492
ADDP4
INDIRI4
ARGI4
CNSTI4 4
ARGI4
ADDRLP4 12
ARGP4
ADDRGP4 trap_R_AddPolyToScene
CALLV
pop
ADDRLP4 12
ARGP4
ADDRGP4 CG_ShiftTrailVerts
CALLV
pop
LABELV $225
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
ADDRLP4 4
INDIRI4
CNSTI4 0
GEI4 $224
LABELV $201
ADDRLP4 120
ADDRLP4 120
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 120
INDIRI4
CNSTI4 1024
LTI4 $200
LABELV $182
endproc CG_AddTrailsToScene 196 16
bss
align 4
LABELV cg_trails
skip 516096
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
import CG_ProcessSnapshots
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
