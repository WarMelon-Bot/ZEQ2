data
align 4
LABELV particlesQuality_names
address $77
address $78
address $79
byte 4 0
align 4
LABELV particlesOptimise_names
address $80
address $81
byte 4 0
align 4
LABELV beamdetail_names
address $82
address $83
address $84
address $85
address $86
byte 4 0
align 4
LABELV beamcontrol_names
address $87
address $88
byte 4 0
align 4
LABELV camerastyle_names
address $89
address $90
address $91
byte 4 0
align 4
LABELV crosshairSize_names
address $92
address $93
address $94
address $95
address $96
address $97
address $98
byte 4 0
align 4
LABELV bloomQuality_names
address $77
address $83
address $84
address $85
address $86
byte 4 0
align 4
LABELV bloomIntensity_names
address $83
address $84
address $85
byte 4 0
align 4
LABELV bloomDarken_names
address $83
address $84
address $85
byte 4 0
align 4
LABELV bloomAlpha_names
address $83
address $84
address $85
byte 4 0
code
proc Preferences_SetMenuItems 132 12
ADDRGP4 $102
ARGP4
ADDRLP4 0
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRGP4 s_preferences+672+64
ADDRLP4 0
INDIRF4
CVFI4 4
CNSTI4 10
MODI4
ASGNI4
ADDRGP4 $105
ARGP4
ADDRLP4 4
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1073741824
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 8
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+864+64
ADDRLP4 8
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $108
ARGP4
ADDRLP4 12
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1086324736
ARGF4
ADDRLP4 12
INDIRF4
ARGF4
ADDRLP4 16
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+768+64
ADDRLP4 16
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $111
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1082130432
ARGF4
ADDRLP4 20
INDIRF4
ARGF4
ADDRLP4 24
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+960+64
ADDRLP4 24
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $114
ARGP4
ADDRLP4 28
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1073741824
ARGF4
ADDRLP4 28
INDIRF4
ARGF4
ADDRLP4 32
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+1152+64
ADDRLP4 32
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $117
ARGP4
ADDRLP4 36
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 36
INDIRF4
ARGF4
ADDRLP4 40
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+1056+64
ADDRLP4 40
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $120
ARGP4
ADDRLP4 44
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1065353216
ARGF4
ADDRLP4 44
INDIRF4
ARGF4
ADDRLP4 48
ADDRGP4 Com_Clamp
CALLF4
ASGNF4
ADDRGP4 s_preferences+1592+64
ADDRLP4 48
INDIRF4
CVFI4 4
ASGNI4
ADDRGP4 $123
ARGP4
ADDRLP4 56
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 56
INDIRF4
CNSTF4 0
EQF4 $125
ADDRLP4 52
CNSTI4 1
ASGNI4
ADDRGP4 $126
JUMPV
LABELV $125
ADDRLP4 52
CNSTI4 0
ASGNI4
LABELV $126
ADDRGP4 s_preferences+1688+60
ADDRLP4 52
INDIRI4
ASGNI4
ADDRGP4 $129
ARGP4
ADDRLP4 64
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 64
INDIRF4
CNSTF4 0
EQF4 $131
ADDRLP4 60
CNSTI4 1
ASGNI4
ADDRGP4 $132
JUMPV
LABELV $131
ADDRLP4 60
CNSTI4 0
ASGNI4
LABELV $132
ADDRGP4 s_preferences+1752+60
ADDRLP4 60
INDIRI4
ASGNI4
ADDRGP4 $135
ARGP4
ADDRLP4 72
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 72
INDIRF4
CNSTF4 0
EQF4 $137
ADDRLP4 68
CNSTI4 1
ASGNI4
ADDRGP4 $138
JUMPV
LABELV $137
ADDRLP4 68
CNSTI4 0
ASGNI4
LABELV $138
ADDRGP4 s_preferences+1816+60
ADDRLP4 68
INDIRI4
ASGNI4
ADDRGP4 $141
ARGP4
ADDRLP4 80
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 76
ADDRLP4 80
INDIRF4
CVFI4 4
ASGNI4
ADDRLP4 88
CNSTI4 128
ASGNI4
ADDRLP4 76
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $149
ADDRLP4 76
INDIRI4
ADDRLP4 88
INDIRI4
GTI4 $159
LABELV $158
ADDRLP4 96
CNSTI4 0
ASGNI4
ADDRLP4 76
INDIRI4
ADDRLP4 96
INDIRI4
EQI4 $143
ADDRLP4 76
INDIRI4
ADDRLP4 96
INDIRI4
LTI4 $139
LABELV $160
ADDRLP4 76
INDIRI4
CNSTI4 64
EQI4 $146
ADDRGP4 $139
JUMPV
LABELV $159
ADDRLP4 104
CNSTI4 256
ASGNI4
ADDRLP4 76
INDIRI4
ADDRLP4 104
INDIRI4
EQI4 $152
ADDRLP4 76
INDIRI4
ADDRLP4 104
INDIRI4
LTI4 $139
LABELV $161
ADDRLP4 76
INDIRI4
CNSTI4 512
EQI4 $155
ADDRGP4 $139
JUMPV
LABELV $139
LABELV $143
ADDRGP4 s_preferences+1248+64
CNSTI4 0
ASGNI4
ADDRGP4 $140
JUMPV
LABELV $146
ADDRGP4 s_preferences+1248+64
CNSTI4 1
ASGNI4
ADDRGP4 $140
JUMPV
LABELV $149
ADDRGP4 s_preferences+1248+64
CNSTI4 2
ASGNI4
ADDRGP4 $140
JUMPV
LABELV $152
ADDRGP4 s_preferences+1248+64
CNSTI4 3
ASGNI4
ADDRGP4 $140
JUMPV
LABELV $155
ADDRGP4 s_preferences+1248+64
CNSTI4 4
ASGNI4
LABELV $140
ADDRGP4 $164
ARGP4
ADDRLP4 108
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRGP4 s_preferences+1344+68
ADDRLP4 108
INDIRF4
ASGNF4
ADDRGP4 $167
ARGP4
ADDRLP4 116
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 112
ADDRLP4 116
INDIRF4
CVFI4 4
ASGNI4
ADDRLP4 124
CNSTI4 32
ASGNI4
ADDRLP4 112
INDIRI4
ADDRLP4 124
INDIRI4
EQI4 $172
ADDRLP4 112
INDIRI4
ADDRLP4 124
INDIRI4
GTI4 $179
LABELV $178
ADDRLP4 112
INDIRI4
CNSTI4 16
EQI4 $169
ADDRGP4 $165
JUMPV
LABELV $179
ADDRLP4 112
INDIRI4
CNSTI4 64
EQI4 $175
ADDRGP4 $165
JUMPV
LABELV $165
LABELV $169
ADDRGP4 s_preferences+1420+64
CNSTI4 0
ASGNI4
ADDRGP4 $166
JUMPV
LABELV $172
ADDRGP4 s_preferences+1420+64
CNSTI4 1
ASGNI4
ADDRGP4 $166
JUMPV
LABELV $175
ADDRGP4 s_preferences+1420+64
CNSTI4 2
ASGNI4
LABELV $166
ADDRGP4 $182
ARGP4
ADDRLP4 128
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRGP4 s_preferences+1516+68
ADDRLP4 128
INDIRF4
ASGNF4
LABELV $99
endproc Preferences_SetMenuItems 132 12
proc Preferences_Event 28 8
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $184
ADDRGP4 $183
JUMPV
LABELV $184
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 8
CNSTI4 100
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
EQI4 $253
ADDRLP4 0
INDIRI4
CNSTI4 101
EQI4 $254
ADDRLP4 0
INDIRI4
CNSTI4 102
EQI4 $187
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
LTI4 $186
LABELV $257
ADDRLP4 0
INDIRI4
CNSTI4 127
LTI4 $186
ADDRLP4 0
INDIRI4
CNSTI4 141
GTI4 $186
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $258-508
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $258
address $189
address $206
address $209
address $212
address $200
address $218
address $215
address $224
address $227
address $239
address $242
address $250
address $221
address $203
address $256
code
LABELV $189
ADDRLP4 16
ADDRGP4 s_preferences+672+64
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 s_preferences+672+64
INDIRI4
CNSTI4 10
NEI4 $192
ADDRGP4 s_preferences+672+64
CNSTI4 0
ASGNI4
LABELV $192
ADDRGP4 $102
ARGP4
ADDRGP4 s_preferences+672+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $200
ADDRGP4 $108
ARGP4
ADDRGP4 s_preferences+768+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $203
ADDRGP4 $135
ARGP4
ADDRGP4 s_preferences+1816+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $206
ADDRGP4 $105
ARGP4
ADDRGP4 s_preferences+864+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $209
ADDRGP4 $120
ARGP4
ADDRGP4 s_preferences+1592+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $212
ADDRGP4 $111
ARGP4
ADDRGP4 s_preferences+960+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $215
ADDRGP4 $114
ARGP4
ADDRGP4 s_preferences+1152+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $218
ADDRGP4 $117
ARGP4
ADDRGP4 s_preferences+1056+64
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $221
ADDRGP4 $123
ARGP4
ADDRGP4 s_preferences+1688+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $224
ADDRGP4 $129
ARGP4
ADDRGP4 s_preferences+1752+60
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $227
ADDRLP4 20
ADDRGP4 s_preferences+1248+64
INDIRI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 0
LTI4 $187
ADDRLP4 20
INDIRI4
CNSTI4 4
GTI4 $187
ADDRLP4 20
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $238
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $238
address $232
address $234
address $235
address $236
address $237
code
LABELV $232
ADDRGP4 $141
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $233
ARGP4
CNSTF4 0
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $234
ADDRGP4 $141
ARGP4
CNSTF4 1115684864
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $233
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $235
ADDRGP4 $141
ARGP4
CNSTF4 1124073472
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $233
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $236
ADDRGP4 $141
ARGP4
CNSTF4 1132462080
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $233
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $237
ADDRGP4 $141
ARGP4
CNSTF4 1140850688
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $233
ARGP4
CNSTF4 1065353216
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $239
ADDRGP4 $164
ARGP4
ADDRGP4 s_preferences+1344+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $242
ADDRLP4 24
ADDRGP4 s_preferences+1420+64
INDIRI4
ASGNI4
ADDRLP4 24
INDIRI4
CNSTI4 0
EQI4 $247
ADDRLP4 24
INDIRI4
CNSTI4 1
EQI4 $248
ADDRLP4 24
INDIRI4
CNSTI4 2
EQI4 $249
ADDRGP4 $187
JUMPV
LABELV $247
ADDRGP4 $167
ARGP4
CNSTF4 1098907648
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $248
ADDRGP4 $167
ARGP4
CNSTF4 1107296256
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $249
ADDRGP4 $167
ARGP4
CNSTF4 1115684864
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $250
ADDRGP4 $182
ARGP4
ADDRGP4 s_preferences+1516+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $253
ADDRGP4 UI_PopMenu
CALLV
pop
ADDRGP4 UI_ControlsMenu
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $254
ADDRGP4 UI_PopMenu
CALLV
pop
ADDRGP4 UI_SystemSettingsMenu
CALLV
pop
ADDRGP4 $187
JUMPV
LABELV $256
ADDRGP4 UI_PopMenu
CALLV
pop
LABELV $186
LABELV $187
LABELV $183
endproc Preferences_Event 28 8
proc Crosshair_Draw 56 20
ADDRGP4 $108
ARGP4
ADDRLP4 32
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 4
CNSTF4 1090519040
ADDRLP4 32
INDIRF4
MULF4
CNSTF4 1090519040
ADDF4
CVFI4 4
ASGNI4
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
ASGNI4
ADDRLP4 12
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
ADDRLP4 24
CNSTI4 2064
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
NEI4 $262
ADDRLP4 28
CNSTI4 1
ASGNI4
ADDRGP4 $263
JUMPV
LABELV $262
ADDRLP4 28
CNSTI4 0
ASGNI4
LABELV $263
ADDRLP4 20
ADDRLP4 28
INDIRI4
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 8192
BANDU4
CNSTU4 0
EQU4 $264
ADDRLP4 16
ADDRGP4 text_color_disabled
ASGNP4
ADDRGP4 $265
JUMPV
LABELV $264
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $266
ADDRLP4 16
ADDRGP4 text_color_highlight
ASGNP4
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
ADDRGP4 $267
JUMPV
LABELV $266
ADDRLP4 0
INDIRP4
CNSTI4 44
ADDP4
INDIRU4
CNSTU4 1
BANDU4
CNSTU4 0
EQU4 $268
ADDRLP4 16
ADDRGP4 text_color_highlight
ASGNP4
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 4096
BORI4
ASGNI4
ADDRGP4 $269
JUMPV
LABELV $268
ADDRLP4 16
ADDRGP4 text_color_normal
ASGNP4
LABELV $269
LABELV $267
LABELV $265
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $270
ADDRLP4 44
ADDRLP4 0
INDIRP4
CNSTI4 20
ADDP4
INDIRI4
ASGNI4
ADDRLP4 44
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 48
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
ASGNI4
ADDRLP4 48
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 52
CNSTI4 1
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
SUBI4
ADDRLP4 52
INDIRI4
ADDI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 32
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
SUBI4
ADDRLP4 52
INDIRI4
ADDI4
CVIF4 4
ARGF4
ADDRGP4 listbar_color
ARGP4
ADDRGP4 UI_FillRect
CALLV
pop
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
CNSTI4 13
ARGI4
CNSTI4 6161
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 UI_DrawChar
CALLV
pop
LABELV $270
ADDRLP4 8
INDIRI4
CNSTI4 8
SUBI4
ARGI4
ADDRLP4 12
INDIRI4
ARGI4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRP4
ARGP4
ADDRLP4 24
INDIRI4
CNSTI4 2
BORI4
ARGI4
ADDRLP4 16
INDIRP4
ARGP4
ADDRGP4 UI_DrawString
CALLV
pop
ADDRLP4 0
INDIRP4
CNSTI4 64
ADDP4
INDIRI4
CNSTI4 0
NEI4 $272
ADDRGP4 $260
JUMPV
LABELV $272
ADDRLP4 40
CNSTI4 64
ASGNI4
ADDRLP4 44
ADDRLP4 4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 48
CNSTF4 1056964608
ADDRLP4 44
INDIRF4
MULF4
ASGNF4
ADDRLP4 8
INDIRI4
CNSTI4 8
ADDI4
ADDRLP4 40
INDIRI4
ADDI4
CVIF4 4
ADDRLP4 48
INDIRF4
SUBF4
ARGF4
ADDRLP4 52
CNSTI4 2
ASGNI4
ADDRLP4 12
INDIRI4
ADDRLP4 52
INDIRI4
ADDI4
CVIF4 4
ADDRLP4 48
INDIRF4
SUBF4
ARGF4
ADDRLP4 44
INDIRF4
ARGF4
ADDRLP4 44
INDIRF4
ARGF4
ADDRLP4 0
INDIRP4
ADDRLP4 40
INDIRI4
ADDP4
INDIRI4
ADDRLP4 52
INDIRI4
LSHI4
ADDRGP4 s_preferences+2036
ADDP4
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
LABELV $260
endproc Crosshair_Draw 56 20
proc Bloom_ApplyChanges 0 8
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $276
ADDRGP4 $275
JUMPV
LABELV $276
CNSTI4 2
ARGI4
ADDRGP4 $278
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
LABELV $275
endproc Bloom_ApplyChanges 0 8
export Preferences_MenuDraw
proc Preferences_MenuDraw 8 4
ADDRLP4 0
ADDRGP4 s_preferences+1880+44
ASGNP4
ADDRLP4 0
INDIRP4
ADDRLP4 0
INDIRP4
INDIRU4
CNSTU4 20480
BORU4
ASGNU4
ADDRGP4 initialBloomQuality
INDIRI4
ADDRGP4 s_preferences+1248+64
INDIRI4
EQI4 $282
ADDRLP4 4
ADDRGP4 s_preferences+1880+44
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRU4
CNSTU4 4294946815
BANDU4
ASGNU4
LABELV $282
ADDRGP4 s_preferences
ARGP4
ADDRGP4 Menu_Draw
CALLV
pop
LABELV $279
endproc Preferences_MenuDraw 8 4
proc Preferences_MenuInit 20 12
ADDRLP4 4
CNSTI4 28
ASGNI4
ADDRLP4 0
CNSTI4 119
ASGNI4
ADDRLP4 8
CNSTI4 38
ASGNI4
ADDRLP4 12
CNSTI4 67584
ASGNI4
ADDRGP4 s_preferences
ARGP4
CNSTI4 0
ARGI4
CNSTI4 2076
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 Preferences_Cache
CALLV
pop
ADDRGP4 s_preferences+276
CNSTI4 1
ASGNI4
ADDRGP4 s_preferences+280
CNSTI4 1
ASGNI4
ADDRGP4 s_preferences+268
ADDRGP4 Preferences_MenuDraw
ASGNP4
ADDRGP4 s_preferences+288
CNSTI4 6
ASGNI4
ADDRGP4 s_preferences+288+4
ADDRGP4 $295
ASGNP4
ADDRGP4 s_preferences+288+44
CNSTU4 16384
ASGNU4
ADDRGP4 s_preferences+288+12
CNSTI4 0
ASGNI4
ADDRGP4 s_preferences+288+16
CNSTI4 78
ASGNI4
ADDRGP4 s_preferences+288+72
CNSTI4 256
ASGNI4
ADDRGP4 s_preferences+288+76
CNSTI4 329
ASGNI4
ADDRGP4 s_preferences+372
CNSTI4 6
ASGNI4
ADDRGP4 s_preferences+372+4
ADDRGP4 $309
ASGNP4
ADDRGP4 s_preferences+372+44
CNSTU4 16384
ASGNU4
ADDRGP4 s_preferences+372+12
CNSTI4 376
ASGNI4
ADDRGP4 s_preferences+372+16
CNSTI4 76
ASGNI4
ADDRGP4 s_preferences+372+72
CNSTI4 256
ASGNI4
ADDRGP4 s_preferences+372+76
CNSTI4 334
ASGNI4
ADDRGP4 s_preferences+456
CNSTI4 9
ASGNI4
ADDRGP4 s_preferences+456+44
CNSTU4 260
ASGNU4
ADDRGP4 s_preferences+456+8
CNSTI4 100
ASGNI4
ADDRGP4 s_preferences+456+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+456+12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 s_preferences+456+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+456+60
ADDRGP4 $333
ASGNP4
ADDRGP4 s_preferences+456+64
ADDRLP4 12
INDIRI4
ASGNI4
ADDRGP4 s_preferences+456+68
ADDRGP4 color_white
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
ADDRGP4 s_preferences+528
CNSTI4 9
ASGNI4
ADDRGP4 s_preferences+528+44
CNSTU4 260
ASGNU4
ADDRGP4 s_preferences+528+8
CNSTI4 101
ASGNI4
ADDRGP4 s_preferences+528+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+528+12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 s_preferences+528+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+528+60
ADDRGP4 $351
ASGNP4
ADDRGP4 s_preferences+528+64
ADDRLP4 12
INDIRI4
ASGNI4
ADDRGP4 s_preferences+528+68
ADDRGP4 color_white
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
ADDRGP4 s_preferences+600
CNSTI4 9
ASGNI4
ADDRGP4 s_preferences+600+44
CNSTU4 16
ASGNU4
ADDRGP4 s_preferences+600+8
CNSTI4 102
ASGNI4
ADDRGP4 s_preferences+600+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+600+12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 s_preferences+600+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+600+60
ADDRGP4 $369
ASGNP4
ADDRGP4 s_preferences+600+64
ADDRLP4 12
INDIRI4
ASGNI4
ADDRGP4 s_preferences+600+68
ADDRGP4 color_white
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
ADDRGP4 s_preferences+1964
CNSTI4 9
ASGNI4
ADDRGP4 s_preferences+1964+44
CNSTU4 260
ASGNU4
ADDRGP4 s_preferences+1964+8
CNSTI4 141
ASGNI4
ADDRGP4 s_preferences+1964+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1964+12
ADDRLP4 4
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1964+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1964+60
ADDRGP4 $387
ASGNP4
ADDRGP4 s_preferences+1964+64
ADDRLP4 12
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1964+68
ADDRGP4 color_white
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ASGNI4
ADDRLP4 0
CNSTI4 88
ASGNI4
ADDRGP4 s_preferences+672
CNSTI4 7
ASGNI4
ADDRGP4 s_preferences+672+44
CNSTU4 98562
ASGNU4
ADDRGP4 s_preferences+672+12
CNSTI4 288
ASGNI4
ADDRGP4 s_preferences+672+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+672+4
ADDRGP4 $401
ASGNP4
ADDRGP4 s_preferences+672+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+672+56
ADDRGP4 Crosshair_Draw
ASGNP4
ADDRGP4 s_preferences+672+8
CNSTI4 127
ASGNI4
ADDRGP4 s_preferences+672+24
ADDRLP4 0
INDIRI4
CNSTI4 4
SUBI4
ASGNI4
ADDRGP4 s_preferences+672+32
ADDRLP4 0
INDIRI4
CNSTI4 20
ADDI4
ASGNI4
ADDRGP4 s_preferences+672+4
INDIRP4
ARGP4
ADDRLP4 16
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRGP4 s_preferences+672+20
CNSTI4 320
ADDRLP4 16
INDIRI4
CNSTI4 3
LSHI4
CNSTI4 8
ADDI4
SUBI4
CNSTI4 32
SUBI4
ASGNI4
ADDRGP4 s_preferences+672+28
CNSTI4 336
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 42
ADDI4
ASGNI4
ADDRGP4 s_preferences+768
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+768+4
ADDRGP4 $421
ASGNP4
ADDRGP4 s_preferences+768+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+768+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+768+8
CNSTI4 131
ASGNI4
ADDRGP4 s_preferences+768+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+768+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+768+76
ADDRGP4 crosshairSize_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1816
CNSTI4 5
ASGNI4
ADDRGP4 s_preferences+1816+4
ADDRGP4 $437
ASGNP4
ADDRGP4 s_preferences+1816+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1816+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1816+8
CNSTI4 140
ASGNI4
ADDRGP4 s_preferences+1816+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1816+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+864
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+864+4
ADDRGP4 $451
ASGNP4
ADDRGP4 s_preferences+864+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+864+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+864+8
CNSTI4 128
ASGNI4
ADDRGP4 s_preferences+864+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+864+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+864+76
ADDRGP4 camerastyle_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1592
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+1592+4
ADDRGP4 $467
ASGNP4
ADDRGP4 s_preferences+1592+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1592+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1592+8
CNSTI4 129
ASGNI4
ADDRGP4 s_preferences+1592+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1592+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1592+76
ADDRGP4 beamcontrol_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+960
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+960+4
ADDRGP4 $483
ASGNP4
ADDRGP4 s_preferences+960+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+960+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+960+8
CNSTI4 130
ASGNI4
ADDRGP4 s_preferences+960+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+960+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+960+76
ADDRGP4 beamdetail_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1152
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+1152+4
ADDRGP4 $499
ASGNP4
ADDRGP4 s_preferences+1152+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1152+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1152+8
CNSTI4 133
ASGNI4
ADDRGP4 s_preferences+1152+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1152+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1152+76
ADDRGP4 particlesQuality_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1056
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+1056+4
ADDRGP4 $515
ASGNP4
ADDRGP4 s_preferences+1056+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1056+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1056+8
CNSTI4 132
ASGNI4
ADDRGP4 s_preferences+1056+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1056+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1056+76
ADDRGP4 particlesOptimise_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1688
CNSTI4 5
ASGNI4
ADDRGP4 s_preferences+1688+4
ADDRGP4 $531
ASGNP4
ADDRGP4 s_preferences+1688+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1688+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1688+8
CNSTI4 139
ASGNI4
ADDRGP4 s_preferences+1688+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1688+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1752
CNSTI4 5
ASGNI4
ADDRGP4 s_preferences+1752+4
ADDRGP4 $545
ASGNP4
ADDRGP4 s_preferences+1752+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1752+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1752+8
CNSTI4 134
ASGNI4
ADDRGP4 s_preferences+1752+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1752+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1248
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+1248+4
ADDRGP4 $559
ASGNP4
ADDRGP4 s_preferences+1248+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1248+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1248+8
CNSTI4 135
ASGNI4
ADDRGP4 s_preferences+1248+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1248+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1248+76
ADDRGP4 bloomQuality_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1420
CNSTI4 3
ASGNI4
ADDRGP4 s_preferences+1420+4
ADDRGP4 $575
ASGNP4
ADDRGP4 s_preferences+1420+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1420+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1420+8
CNSTI4 137
ASGNI4
ADDRGP4 s_preferences+1420+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1420+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1420+76
ADDRGP4 bloomDarken_names
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1344
CNSTI4 1
ASGNI4
ADDRGP4 s_preferences+1344+4
ADDRGP4 $591
ASGNP4
ADDRGP4 s_preferences+1344+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1344+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1344+8
CNSTI4 136
ASGNI4
ADDRGP4 s_preferences+1344+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1344+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1344+60
CNSTF4 0
ASGNF4
ADDRGP4 s_preferences+1344+64
CNSTF4 1065353216
ASGNF4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 18
ADDI4
ASGNI4
ADDRGP4 s_preferences+1516
CNSTI4 1
ASGNI4
ADDRGP4 s_preferences+1516+4
ADDRGP4 $609
ASGNP4
ADDRGP4 s_preferences+1516+44
CNSTU4 258
ASGNU4
ADDRGP4 s_preferences+1516+48
ADDRGP4 Preferences_Event
ASGNP4
ADDRGP4 s_preferences+1516+8
CNSTI4 138
ASGNI4
ADDRGP4 s_preferences+1516+12
CNSTI4 320
ASGNI4
ADDRGP4 s_preferences+1516+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_preferences+1516+60
CNSTF4 0
ASGNF4
ADDRGP4 s_preferences+1516+64
CNSTF4 1065353216
ASGNF4
ADDRGP4 s_preferences+1880
CNSTI4 6
ASGNI4
ADDRGP4 s_preferences+1880+4
ADDRGP4 $627
ASGNP4
ADDRGP4 s_preferences+1880+44
CNSTU4 20752
ASGNU4
ADDRGP4 s_preferences+1880+48
ADDRGP4 Bloom_ApplyChanges
ASGNP4
ADDRGP4 s_preferences+1880+12
CNSTI4 640
ASGNI4
ADDRGP4 s_preferences+1880+16
CNSTI4 416
ASGNI4
ADDRGP4 s_preferences+1880+72
CNSTI4 128
ASGNI4
ADDRGP4 s_preferences+1880+76
CNSTI4 64
ASGNI4
ADDRGP4 s_preferences+1880+60
ADDRGP4 $642
ASGNP4
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+456
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+528
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+372
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+672
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+768
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1816
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+864
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1592
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+960
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1152
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1056
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1688
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1752
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1248
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1344
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1420
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1964
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+1880
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 Preferences_SetMenuItems
CALLV
pop
ADDRGP4 initialBloomQuality
ADDRGP4 s_preferences+1248+64
INDIRI4
ASGNI4
LABELV $288
endproc Preferences_MenuInit 20 12
export Preferences_Cache
proc Preferences_Cache 16 8
ADDRGP4 $295
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $309
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $667
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $668
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $627
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $642
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $669
ADDRGP4 $674
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 97
ADDI4
ARGI4
ADDRLP4 8
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 s_preferences+2036
ADDP4
ADDRLP4 12
INDIRI4
ASGNI4
LABELV $670
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LTI4 $669
LABELV $666
endproc Preferences_Cache 16 8
export UI_PreferencesMenu
proc UI_PreferencesMenu 0 8
ADDRGP4 uis+20
CNSTI4 4
ASGNI4
ADDRGP4 uis+24
CNSTI4 1
ASGNI4
ADDRGP4 uis+32
CNSTI4 1
ASGNI4
ADDRGP4 Preferences_MenuInit
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
ADDRGP4 s_preferences
ARGP4
ADDRGP4 s_preferences+600
ARGP4
ADDRGP4 Menu_SetCursorToItem
CALLV
pop
LABELV $675
endproc UI_PreferencesMenu 0 8
bss
align 4
LABELV s_preferences
skip 2076
align 4
LABELV initialBloomQuality
skip 4
import UI_InitGameinfo
import UI_SPUnlockMedals_f
import UI_SPUnlock_f
import UI_GetAwardLevel
import UI_LogAwardData
import UI_NewGame
import UI_GetCurrentGame
import UI_CanShowTierVideo
import UI_ShowTierVideo
import UI_TierCompleted
import UI_SetBestScore
import UI_GetBestScore
import UI_GetNumBots
import UI_GetBotInfoByName
import UI_GetBotInfoByNumber
import UI_GetNumSPTiers
import UI_GetNumSPArenas
import UI_GetNumArenas
import UI_GetSpecialArenaInfo
import UI_GetArenaInfoByMap
import UI_GetArenaInfoByNumber
import UI_SaveConfigMenu
import UI_SaveConfigMenu_Cache
import UI_LoadConfigMenu
import UI_LoadConfig_Cache
import UI_TeamOrdersMenu_Cache
import UI_TeamOrdersMenu_f
import UI_TeamOrdersMenu
import trap_MemoryRemaining
import trap_LAN_GetPingInfo
import trap_LAN_GetPing
import trap_LAN_ClearPing
import trap_LAN_ServerStatus
import trap_LAN_GetPingQueueCount
import trap_LAN_GetServerInfo
import trap_LAN_GetServerAddressString
import trap_LAN_GetServerCount
import trap_GetConfigString
import trap_GetGlconfig
import trap_GetClientState
import trap_GetClipboardData
import trap_Key_SetCatcher
import trap_Key_GetCatcher
import trap_Key_ClearStates
import trap_Key_SetOverstrikeMode
import trap_Key_GetOverstrikeMode
import trap_Key_IsDown
import trap_Key_SetBinding
import trap_Key_GetBindingBuf
import trap_Key_KeynumToStringBuf
import trap_S_RegisterSound
import trap_S_StartLocalSound
import trap_CM_LerpTag
import trap_UpdateScreen
import trap_R_DrawStretchPic
import trap_R_SetColor
import trap_R_RenderScene
import trap_R_AddLightToScene
import trap_R_AddPolyToScene
import trap_R_AddRefEntityToScene
import trap_R_ClearScene
import trap_R_RegisterShaderNoMip
import trap_R_RegisterSkin
import trap_R_RegisterModel
import trap_FS_Seek
import trap_FS_GetFileList
import trap_FS_FCloseFile
import trap_FS_Write
import trap_FS_Read
import trap_FS_FOpenFile
import trap_Cmd_ExecuteText
import trap_Argv
import trap_Argc
import trap_Cvar_InfoStringBuffer
import trap_Cvar_Create
import trap_Cvar_Reset
import trap_Cvar_SetValue
import trap_Cvar_VariableStringBuffer
import trap_Cvar_VariableValue
import trap_Cvar_Set
import trap_Cvar_Update
import trap_Cvar_Register
import trap_Milliseconds
import trap_Error
import trap_Print
import uis
import m_entersound
import UI_StartDemoLoop
import UI_DrawBackPic
import UI_MenuLogo
import UI_MenuScene
import UI_Cvar_VariableString
import UI_Argv
import UI_ForceMenuOff
import UI_PopMenu
import UI_PushMenu
import UI_SetActiveMenu
import UI_IsFullscreen
import UI_DrawTextBox
import UI_AdjustFrom640
import UI_CursorInRect
import UI_DrawChar
import UI_DrawString
import UI_DrawStrlen
import UI_ProportionalStringWidth
import UI_DrawProportionalString_AutoWrapped
import UI_DrawProportionalString
import UI_ProportionalSizeScale
import UI_DrawBannerString
import UI_LerpColor
import UI_SetColor
import UI_UpdateScreen
import UI_DrawRect
import UI_FillRect
import UI_DrawHandlePic
import UI_DrawNamedPic
import UI_ClampCvar
import UI_ConsoleCommand
import UI_Refresh
import UI_MouseEvent
import UI_KeyEvent
import UI_Shutdown
import UI_Init
import UI_RegisterClientModelname
import UI_PlayerInfo_SetInfo
import UI_PlayerInfo_SetModel
import UI_DrawPlayer_zMesh
import UI_DrawPlayer
import SystemSettings_Cache
import UI_SystemSettingsMenu
import ServerInfo_Cache
import UI_ServerInfoMenu
import UI_BotSelectMenu_Cache
import UI_BotSelectMenu
import ServerOptions_Cache
import StartServer_Cache
import UI_StartServerMenu
import ArenaServers_Cache
import UI_ArenaServersMenu
import SpecifyServer_Cache
import UI_SpecifyServerMenu
import SpecifyLeague_Cache
import UI_SpecifyLeagueMenu
import PlayerSettings_Cache
import UI_PlayerSettingsMenu
import PlayerModel_Cache
import UI_PlayerModelMenu
import Controls_Cache
import UI_ControlsMenu
import Camera_Cache
import UI_CameraMenu
import UI_DrawConnectScreen
import TeamMain_Cache
import UI_TeamMainMenu
import UI_SetupMenu
import UI_SetupMenu_Cache
import UI_Message
import UI_ConfirmMenu_Style
import UI_ConfirmMenu
import ConfirmMenu_Cache
import UI_InGameMenu
import InGame_Cache
import UI_MusicMenu_Cache
import UI_MusicMenu
import UI_CreditMenu
import UI_UpdateCvars
import UI_RegisterCvars
import UI_MainMenu
import MainMenu_Cache
import MenuField_Key
import MenuField_Draw
import MenuField_Init
import MField_Draw
import MField_CharEvent
import MField_KeyDownEvent
import MField_Clear
import ui_medalSounds
import ui_medalPicNames
import ui_medalNames
import text_color_highlight
import text_color_normal
import text_color_disabled
import listbar_color
import list_color
import name_color
import color_dim
import color_red
import color_orange
import color_white
import color_blue
import color_yellow
import color_black
import menu_dim_color
import menu_black_color
import menu_red_color
import menu_highlight_color
import menu_dark_color
import menu_grayed_color
import menu_text_color
import menu_exit_sound
import menu_null_sound
import menu_buzz_sound
import menu_out_sound
import menu_move_sound
import menu_in_sound
import ScrollList_Key
import ScrollList_Draw
import Bitmap_Draw
import Bitmap_Init
import Menu_DefaultKey
import Menu_SetCursorToItem
import Menu_SetCursor
import Menu_ActivateItem
import Menu_ItemAtCursor
import Menu_Draw
import Menu_Side
import Menu_Frame
import Menu_Common
import Menu_AdjustCursor
import Menu_AddItem
import Menu_Focus
import Menu_Cache
import s_mastermusicvolume
import ui_cdkeychecked
import ui_cdkey
import ui_server16
import ui_server15
import ui_server14
import ui_server13
import ui_server12
import ui_server11
import ui_server10
import ui_server9
import ui_server8
import ui_server7
import ui_server6
import ui_server5
import ui_server4
import ui_server3
import ui_server2
import ui_server1
import ui_marks
import ui_drawCrosshairNames
import ui_drawCrosshair
import ui_brassTime
import ui_browserShowEmpty
import ui_browserShowFull
import ui_browserSortKey
import ui_browserGameType
import ui_browserMaster
import ui_spSelection
import ui_spSkill
import ui_spVideos
import ui_spAwards
import ui_spScores5
import ui_spScores4
import ui_spScores3
import ui_spScores2
import ui_spScores1
import ui_botsFile
import ui_arenasFile
import ui_ctf_friendly
import ui_ctf_breakLimitRate
import ui_ctf_powerlevel
import ui_ctf_timelimit
import ui_ctf_capturelimit
import ui_team_friendly
import ui_team_breakLimitRate
import ui_team_powerlevel
import ui_team_timelimit
import ui_team_fraglimit
import ui_tourney_breakLimitRate
import ui_tourney_powerlevel
import ui_tourney_timelimit
import ui_tourney_fraglimit
import ui_ffa_breakLimitRate
import ui_ffa_powerlevelMaximum
import ui_ffa_powerlevel
import ui_ffa_timelimit
import ui_ffa_fraglimit
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
LABELV $674
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 37
byte 1 99
byte 1 0
align 1
LABELV $668
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $667
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 98
byte 1 97
byte 1 99
byte 1 107
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $642
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 97
byte 1 99
byte 1 99
byte 1 101
byte 1 112
byte 1 116
byte 1 95
byte 1 49
byte 1 0
align 1
LABELV $627
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 97
byte 1 99
byte 1 99
byte 1 101
byte 1 112
byte 1 116
byte 1 95
byte 1 48
byte 1 0
align 1
LABELV $609
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 32
byte 1 65
byte 1 108
byte 1 112
byte 1 104
byte 1 97
byte 1 58
byte 1 0
align 1
LABELV $591
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 32
byte 1 73
byte 1 110
byte 1 116
byte 1 101
byte 1 110
byte 1 115
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 0
align 1
LABELV $575
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 32
byte 1 68
byte 1 97
byte 1 114
byte 1 107
byte 1 101
byte 1 110
byte 1 58
byte 1 0
align 1
LABELV $559
byte 1 66
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 32
byte 1 81
byte 1 117
byte 1 97
byte 1 108
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 0
align 1
LABELV $545
byte 1 65
byte 1 100
byte 1 118
byte 1 97
byte 1 110
byte 1 99
byte 1 101
byte 1 100
byte 1 32
byte 1 70
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $531
byte 1 67
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 79
byte 1 117
byte 1 116
byte 1 108
byte 1 105
byte 1 110
byte 1 101
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $515
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 32
byte 1 80
byte 1 104
byte 1 121
byte 1 115
byte 1 105
byte 1 99
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $499
byte 1 80
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 32
byte 1 81
byte 1 117
byte 1 97
byte 1 108
byte 1 105
byte 1 116
byte 1 121
byte 1 58
byte 1 0
align 1
LABELV $483
byte 1 66
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 68
byte 1 101
byte 1 116
byte 1 97
byte 1 105
byte 1 108
byte 1 58
byte 1 0
align 1
LABELV $467
byte 1 66
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 67
byte 1 111
byte 1 110
byte 1 116
byte 1 114
byte 1 111
byte 1 108
byte 1 32
byte 1 83
byte 1 116
byte 1 121
byte 1 108
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $451
byte 1 67
byte 1 97
byte 1 109
byte 1 101
byte 1 114
byte 1 97
byte 1 32
byte 1 115
byte 1 116
byte 1 121
byte 1 108
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $437
byte 1 80
byte 1 108
byte 1 97
byte 1 121
byte 1 101
byte 1 114
byte 1 32
byte 1 78
byte 1 97
byte 1 109
byte 1 101
byte 1 115
byte 1 58
byte 1 0
align 1
LABELV $421
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 32
byte 1 83
byte 1 105
byte 1 122
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $401
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 58
byte 1 0
align 1
LABELV $387
byte 1 66
byte 1 65
byte 1 67
byte 1 75
byte 1 0
align 1
LABELV $369
byte 1 71
byte 1 69
byte 1 78
byte 1 69
byte 1 82
byte 1 65
byte 1 76
byte 1 0
align 1
LABELV $351
byte 1 83
byte 1 89
byte 1 83
byte 1 84
byte 1 69
byte 1 77
byte 1 0
align 1
LABELV $333
byte 1 67
byte 1 79
byte 1 78
byte 1 84
byte 1 82
byte 1 79
byte 1 76
byte 1 83
byte 1 0
align 1
LABELV $309
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 49
byte 1 95
byte 1 114
byte 1 0
align 1
LABELV $295
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 114
byte 1 102
byte 1 97
byte 1 99
byte 1 101
byte 1 47
byte 1 97
byte 1 114
byte 1 116
byte 1 47
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 50
byte 1 95
byte 1 108
byte 1 0
align 1
LABELV $278
byte 1 118
byte 1 105
byte 1 100
byte 1 95
byte 1 114
byte 1 101
byte 1 115
byte 1 116
byte 1 97
byte 1 114
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $233
byte 1 114
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 0
align 1
LABELV $182
byte 1 114
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 95
byte 1 97
byte 1 108
byte 1 112
byte 1 104
byte 1 97
byte 1 0
align 1
LABELV $167
byte 1 114
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 95
byte 1 100
byte 1 97
byte 1 114
byte 1 107
byte 1 101
byte 1 110
byte 1 0
align 1
LABELV $164
byte 1 114
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 95
byte 1 105
byte 1 110
byte 1 116
byte 1 101
byte 1 110
byte 1 115
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $141
byte 1 114
byte 1 95
byte 1 98
byte 1 108
byte 1 111
byte 1 111
byte 1 109
byte 1 95
byte 1 115
byte 1 97
byte 1 109
byte 1 112
byte 1 108
byte 1 101
byte 1 95
byte 1 115
byte 1 105
byte 1 122
byte 1 101
byte 1 0
align 1
LABELV $135
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 78
byte 1 97
byte 1 109
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $129
byte 1 99
byte 1 103
byte 1 95
byte 1 97
byte 1 100
byte 1 118
byte 1 97
byte 1 110
byte 1 99
byte 1 101
byte 1 100
byte 1 70
byte 1 108
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $123
byte 1 114
byte 1 95
byte 1 111
byte 1 117
byte 1 116
byte 1 108
byte 1 105
byte 1 110
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $120
byte 1 99
byte 1 103
byte 1 95
byte 1 98
byte 1 101
byte 1 97
byte 1 109
byte 1 67
byte 1 111
byte 1 110
byte 1 116
byte 1 114
byte 1 111
byte 1 108
byte 1 0
align 1
LABELV $117
byte 1 99
byte 1 103
byte 1 95
byte 1 112
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 115
byte 1 83
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $114
byte 1 99
byte 1 103
byte 1 95
byte 1 112
byte 1 97
byte 1 114
byte 1 116
byte 1 105
byte 1 99
byte 1 108
byte 1 101
byte 1 115
byte 1 81
byte 1 117
byte 1 97
byte 1 108
byte 1 105
byte 1 116
byte 1 121
byte 1 0
align 1
LABELV $111
byte 1 114
byte 1 95
byte 1 98
byte 1 101
byte 1 97
byte 1 109
byte 1 68
byte 1 101
byte 1 116
byte 1 97
byte 1 105
byte 1 108
byte 1 0
align 1
LABELV $108
byte 1 99
byte 1 103
byte 1 95
byte 1 99
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 83
byte 1 105
byte 1 122
byte 1 101
byte 1 0
align 1
LABELV $105
byte 1 99
byte 1 103
byte 1 95
byte 1 116
byte 1 104
byte 1 105
byte 1 114
byte 1 100
byte 1 80
byte 1 101
byte 1 114
byte 1 115
byte 1 111
byte 1 110
byte 1 67
byte 1 97
byte 1 109
byte 1 101
byte 1 114
byte 1 97
byte 1 0
align 1
LABELV $102
byte 1 99
byte 1 103
byte 1 95
byte 1 100
byte 1 114
byte 1 97
byte 1 119
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 0
align 1
LABELV $98
byte 1 69
byte 1 120
byte 1 116
byte 1 114
byte 1 97
byte 1 32
byte 1 69
byte 1 120
byte 1 116
byte 1 114
byte 1 97
byte 1 32
byte 1 76
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 63
byte 1 33
byte 1 0
align 1
LABELV $97
byte 1 69
byte 1 120
byte 1 116
byte 1 114
byte 1 97
byte 1 32
byte 1 76
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 33
byte 1 0
align 1
LABELV $96
byte 1 76
byte 1 97
byte 1 114
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $95
byte 1 78
byte 1 111
byte 1 114
byte 1 109
byte 1 97
byte 1 108
byte 1 0
align 1
LABELV $94
byte 1 83
byte 1 109
byte 1 97
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $93
byte 1 86
byte 1 101
byte 1 114
byte 1 121
byte 1 32
byte 1 83
byte 1 109
byte 1 97
byte 1 108
byte 1 108
byte 1 0
align 1
LABELV $92
byte 1 84
byte 1 105
byte 1 110
byte 1 121
byte 1 33
byte 1 0
align 1
LABELV $91
byte 1 68
byte 1 101
byte 1 108
byte 1 97
byte 1 121
byte 1 32
byte 1 66
byte 1 101
byte 1 104
byte 1 105
byte 1 110
byte 1 100
byte 1 32
byte 1 67
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $90
byte 1 76
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 100
byte 1 32
byte 1 66
byte 1 101
byte 1 104
byte 1 105
byte 1 110
byte 1 100
byte 1 32
byte 1 67
byte 1 104
byte 1 97
byte 1 114
byte 1 97
byte 1 99
byte 1 116
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $89
byte 1 76
byte 1 111
byte 1 99
byte 1 107
byte 1 101
byte 1 100
byte 1 32
byte 1 66
byte 1 101
byte 1 104
byte 1 105
byte 1 110
byte 1 100
byte 1 32
byte 1 72
byte 1 101
byte 1 97
byte 1 100
byte 1 0
align 1
LABELV $88
byte 1 67
byte 1 114
byte 1 111
byte 1 115
byte 1 115
byte 1 104
byte 1 97
byte 1 105
byte 1 114
byte 1 32
byte 1 70
byte 1 111
byte 1 99
byte 1 117
byte 1 115
byte 1 0
align 1
LABELV $87
byte 1 66
byte 1 101
byte 1 97
byte 1 109
byte 1 32
byte 1 72
byte 1 101
byte 1 97
byte 1 100
byte 1 32
byte 1 70
byte 1 111
byte 1 99
byte 1 117
byte 1 115
byte 1 0
align 1
LABELV $86
byte 1 86
byte 1 101
byte 1 114
byte 1 121
byte 1 32
byte 1 72
byte 1 105
byte 1 103
byte 1 104
byte 1 0
align 1
LABELV $85
byte 1 72
byte 1 105
byte 1 103
byte 1 104
byte 1 0
align 1
LABELV $84
byte 1 77
byte 1 101
byte 1 100
byte 1 105
byte 1 117
byte 1 109
byte 1 0
align 1
LABELV $83
byte 1 76
byte 1 111
byte 1 119
byte 1 0
align 1
LABELV $82
byte 1 86
byte 1 101
byte 1 114
byte 1 121
byte 1 32
byte 1 76
byte 1 111
byte 1 119
byte 1 0
align 1
LABELV $81
byte 1 82
byte 1 101
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 32
byte 1 79
byte 1 110
byte 1 32
byte 1 83
byte 1 116
byte 1 111
byte 1 112
byte 1 0
align 1
LABELV $80
byte 1 82
byte 1 101
byte 1 109
byte 1 111
byte 1 118
byte 1 101
byte 1 32
byte 1 65
byte 1 102
byte 1 116
byte 1 101
byte 1 114
byte 1 32
byte 1 65
byte 1 119
byte 1 104
byte 1 105
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $79
byte 1 77
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 115
byte 1 0
align 1
LABELV $78
byte 1 83
byte 1 112
byte 1 114
byte 1 105
byte 1 116
byte 1 101
byte 1 115
byte 1 0
align 1
LABELV $77
byte 1 79
byte 1 102
byte 1 102
byte 1 0
