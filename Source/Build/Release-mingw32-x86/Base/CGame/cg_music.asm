export CG_CheckMusic
code
proc CG_CheckMusic 16 8
ADDRLP4 0
ADDRGP4 cg+137620
ASGNP4
ADDRGP4 cgs+2281132+3844
INDIRI4
CNSTI4 0
NEI4 $103
ADDRGP4 CG_StartMusic
CALLV
pop
LABELV $103
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 8192
BANDI4
CNSTI4 0
EQI4 $107
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 9
EQI4 $108
ADDRGP4 cgs+2281132+3932
CNSTI4 9
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $108
JUMPV
LABELV $107
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 16384
BANDI4
CNSTI4 0
EQI4 $115
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 4
EQI4 $116
ADDRGP4 cgs+2281132+3932
CNSTI4 4
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $116
JUMPV
LABELV $115
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 8388608
BANDI4
CNSTI4 0
NEI4 $123
ADDRLP4 8
CNSTI4 0
ASGNI4
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 2097152
BANDI4
ADDRLP4 8
INDIRI4
NEI4 $127
ADDRLP4 0
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
ADDRLP4 8
INDIRI4
LEI4 $125
LABELV $127
ADDRLP4 0
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
CVIF4 4
CNSTF4 1053609165
ADDRLP4 0
INDIRP4
CNSTI4 564
ADDP4
INDIRI4
CVIF4 4
MULF4
GEF4 $128
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 6
EQI4 $124
ADDRGP4 cgs+2281132+3932
CNSTI4 6
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $124
JUMPV
LABELV $128
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 5
EQI4 $124
ADDRGP4 cgs+2281132+3932
CNSTI4 5
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $124
JUMPV
LABELV $125
ADDRLP4 0
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
CVIF4 4
CNSTF4 1053609165
ADDRLP4 0
INDIRP4
CNSTI4 564
ADDP4
INDIRI4
CVIF4 4
MULF4
GEF4 $142
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 3
EQI4 $124
ADDRGP4 cgs+2281132+3932
CNSTI4 3
ASGNI4
ADDRGP4 CG_FadeNext
CALLV
pop
ADDRGP4 $124
JUMPV
LABELV $142
ADDRLP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 67108864
BANDI4
CNSTI4 0
EQI4 $150
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 2
EQI4 $124
ADDRGP4 cgs+2281132+3932
CNSTI4 2
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $124
JUMPV
LABELV $150
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 1
EQI4 $124
ADDRGP4 cgs+2281132+3932
CNSTI4 1
ASGNI4
ADDRGP4 CG_FadeNext
CALLV
pop
ADDRGP4 $124
JUMPV
LABELV $123
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 0
EQI4 $164
ADDRGP4 cgs+2281132+3932
CNSTI4 0
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
LABELV $164
LABELV $124
LABELV $116
LABELV $108
ADDRGP4 cg+137588
INDIRI4
ADDRGP4 cgs+2281132+3944
INDIRI4
LEI4 $170
ADDRLP4 4
ADDRGP4 cg+137588
INDIRI4
ADDRGP4 cgs+2281132+3944
INDIRI4
SUBI4
ASGNI4
ADDRLP4 8
CNSTF4 0
ASGNF4
ADDRLP4 4
INDIRI4
ADDRGP4 cgs+2281132+3940
INDIRI4
GEI4 $178
ADDRLP4 8
CNSTF4 1065353216
ADDRLP4 4
INDIRI4
CVIF4 4
ADDRGP4 cgs+2281132+3940
INDIRI4
CVIF4 4
DIVF4
SUBF4
ASGNF4
ADDRGP4 $179
JUMPV
LABELV $178
ADDRGP4 cgs+2281132+3848
CNSTI4 0
ASGNI4
ADDRGP4 CG_NextTrack
CALLV
pop
ADDRGP4 $101
JUMPV
LABELV $179
ADDRGP4 $187
ARGP4
ADDRLP4 8
INDIRF4
ADDRGP4 cg_music+8
INDIRF4
MULF4
ARGF4
ADDRLP4 12
ADDRGP4 va
CALLP4
ASGNP4
ADDRGP4 $186
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
LABELV $170
LABELV $101
endproc CG_CheckMusic 16 8
export CG_GetMilliseconds
proc CG_GetMilliseconds 36 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 0
ADDRLP4 20
INDIRI4
ASGNI4
ADDRLP4 12
ADDRLP4 20
INDIRI4
ASGNI4
ADDRLP4 16
ADDRLP4 20
INDIRI4
ASGNI4
ADDRGP4 $191
JUMPV
LABELV $190
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 24
ADDRGP4 Q_PrintStrlen
CALLI4
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 24
INDIRI4
LEI4 $193
ADDRGP4 $192
JUMPV
LABELV $193
ADDRLP4 12
INDIRI4
ADDRLP4 4
ADDP4
ADDRLP4 0
INDIRI4
ADDRFP4 0
INDIRP4
ADDP4
INDIRI1
ASGNI1
ADDRLP4 0
INDIRI4
ADDRLP4 4
ADDP4
ARGP4
ADDRGP4 $197
ARGP4
ADDRLP4 28
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 28
INDIRI4
CNSTI4 0
NEI4 $195
ADDRLP4 4
ARGP4
ADDRLP4 32
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1000
CNSTI4 60
ADDRLP4 32
INDIRI4
MULI4
MULI4
ADDI4
ASGNI4
ADDRLP4 12
CNSTI4 -1
ASGNI4
ADDRLP4 4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 8
ARGI4
ADDRGP4 memset
CALLP4
pop
LABELV $195
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
ADDRLP4 32
INDIRI4
ADDI4
ASGNI4
ADDRLP4 12
ADDRLP4 12
INDIRI4
ADDRLP4 32
INDIRI4
ADDI4
ASGNI4
LABELV $191
ADDRGP4 $190
JUMPV
LABELV $192
ADDRLP4 4
ARGP4
ADDRLP4 24
ADDRGP4 atoi
CALLI4
ASGNI4
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1000
ADDRLP4 24
INDIRI4
MULI4
ADDI4
ASGNI4
ADDRLP4 16
INDIRI4
RETI4
LABELV $189
endproc CG_GetMilliseconds 36 12
bss
align 1
LABELV $243
skip 131072
export CG_ParsePlaylist
code
proc CG_ParsePlaylist 32092 12
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRLP4 32032
CNSTI4 -1
ASGNI4
ADDRLP4 16
ADDRLP4 32032
INDIRI4
ASGNI4
ADDRGP4 cgs+2281132+3936
ADDRLP4 32032
INDIRI4
ASGNI4
ADDRGP4 cgs+2281132+3940
CNSTI4 0
ASGNI4
ADDRGP4 cgs+2281132+3844
CNSTI4 1
ASGNI4
ADDRGP4 cgs+2281132+3840
CNSTI4 0
ASGNI4
ADDRGP4 $209
ARGP4
CNSTP4 0
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 32036
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 32036
INDIRI4
CNSTI4 0
LEI4 $207
ADDRGP4 $209
ARGP4
ADDRLP4 24
ARGP4
CNSTI4 0
ARGI4
ADDRLP4 32040
ADDRGP4 trap_FS_FOpenFile
CALLI4
ASGNI4
ADDRLP4 28
ADDRLP4 32040
INDIRI4
ASGNI4
ADDRLP4 32
ARGP4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 trap_FS_Read
CALLV
pop
ADDRLP4 28
INDIRI4
ADDRLP4 32
ADDP4
CNSTI1 0
ASGNI1
ADDRLP4 24
INDIRI4
ARGI4
ADDRGP4 trap_FS_FCloseFile
CALLV
pop
ADDRLP4 8
ADDRLP4 32
ASGNP4
ADDRGP4 $211
JUMPV
LABELV $210
ADDRLP4 8
ARGP4
ADDRLP4 32044
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 32044
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $213
ADDRGP4 $212
JUMPV
LABELV $213
ADDRLP4 12
ADDRLP4 0
INDIRP4
INDIRI1
ASGNI1
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 32052
ADDRGP4 Q_PrintStrlen
CALLI4
ASGNI4
ADDRLP4 4
ADDRLP4 32052
INDIRI4
CNSTI4 1
SUBI4
ADDRLP4 0
INDIRP4
ADDP4
INDIRI1
ASGNI1
ADDRGP4 $215
ARGP4
ADDRLP4 4
INDIRI1
CVII4 1
ARGI4
ADDRLP4 32056
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 32056
INDIRP4
INDIRI1
ASGNI1
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $218
ARGP4
ADDRLP4 32060
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32060
INDIRI4
CNSTI4 0
NEI4 $216
ADDRLP4 8
ARGP4
ADDRLP4 32064
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 32064
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $219
ADDRGP4 $212
JUMPV
LABELV $219
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $223
ARGP4
ADDRLP4 32068
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32068
INDIRI4
CNSTI4 0
NEI4 $217
ADDRGP4 cgs+2281132+3840
CNSTI4 1
ASGNI4
ADDRGP4 $217
JUMPV
LABELV $216
ADDRLP4 0
INDIRP4
ARGP4
ADDRGP4 $228
ARGP4
ADDRLP4 32064
ADDRGP4 Q_stricmp
CALLI4
ASGNI4
ADDRLP4 32064
INDIRI4
CNSTI4 0
NEI4 $226
ADDRLP4 8
ARGP4
ADDRLP4 32068
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 32068
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $229
ADDRGP4 $212
JUMPV
LABELV $229
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 32072
ADDRGP4 CG_GetMilliseconds
CALLI4
ASGNI4
ADDRGP4 cgs+2281132+3940
ADDRLP4 32072
INDIRI4
ASGNI4
ADDRGP4 $227
JUMPV
LABELV $226
ADDRLP4 4
ARGP4
ADDRGP4 $235
ARGP4
ADDRLP4 32068
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 32068
INDIRI4
CNSTI4 0
NEI4 $233
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3892
ADDP4
CNSTI4 -1
ASGNI4
ADDRLP4 16
ADDRLP4 16
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 $234
JUMPV
LABELV $233
ADDRLP4 12
ARGP4
ADDRGP4 $240
ARGP4
ADDRLP4 32072
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 32072
INDIRI4
CNSTI4 0
NEI4 $238
ADDRLP4 16
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3852
ADDP4
ADDRLP4 20
INDIRI4
ASGNI4
ADDRLP4 20
CNSTI4 0
ASGNI4
ADDRGP4 $239
JUMPV
LABELV $238
ADDRLP4 20
INDIRI4
CNSTI4 8
LSHI4
ADDRLP4 16
INDIRI4
CNSTI4 13
LSHI4
ADDRGP4 $243
ADDP4
ADDP4
ARGP4
ADDRLP4 0
INDIRP4
ARGP4
CNSTI4 255
ARGI4
ADDRGP4 strncpy
CALLP4
pop
ADDRLP4 20
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 16
INDIRI4
CNSTI4 7
LSHI4
ADDRGP4 cgs+2281132
ADDP4
ADDP4
ADDRLP4 20
INDIRI4
CNSTI4 8
LSHI4
ADDRLP4 16
INDIRI4
CNSTI4 13
LSHI4
ADDRGP4 $243
ADDP4
ADDP4
ASGNP4
ADDRLP4 8
ARGP4
ADDRLP4 32084
ADDRGP4 COM_Parse
CALLP4
ASGNP4
ADDRLP4 32084
INDIRP4
ARGP4
ADDRLP4 32088
ADDRGP4 CG_GetMilliseconds
CALLI4
ASGNI4
ADDRLP4 20
INDIRI4
CNSTI4 2
LSHI4
ADDRLP4 16
INDIRI4
CNSTI4 7
LSHI4
ADDRGP4 cgs+2281132+1280
ADDP4
ADDP4
ADDRLP4 32088
INDIRI4
ASGNI4
ADDRLP4 20
ADDRLP4 20
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $239
LABELV $234
LABELV $227
LABELV $217
LABELV $211
ADDRGP4 $210
JUMPV
LABELV $212
LABELV $207
LABELV $198
endproc CG_ParsePlaylist 32092 12
export CG_StartMusic
proc CG_StartMusic 0 0
ADDRGP4 CG_ParsePlaylist
CALLV
pop
LABELV $247
endproc CG_StartMusic 0 0
export CG_FadeNext
proc CG_FadeNext 0 0
ADDRGP4 cgs+2281132+3848
CNSTI4 1
ASGNI4
ADDRGP4 cgs+2281132+3944
ADDRGP4 cg+137588
INDIRI4
ASGNI4
LABELV $248
endproc CG_FadeNext 0 0
export CG_NextTrack
proc CG_NextTrack 32 8
ADDRGP4 cgs+2281132+3848
INDIRI4
CNSTI4 0
EQI4 $255
ADDRGP4 $254
JUMPV
LABELV $255
ADDRLP4 4
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3852
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
GEI4 $266
ADDRLP4 16
ADDRGP4 cgs+2281132+3936
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRGP4 $267
JUMPV
LABELV $266
ADDRLP4 16
CNSTI4 0
ASGNI4
LABELV $267
ADDRLP4 0
ADDRLP4 16
INDIRI4
ASGNI4
ADDRGP4 cgs+2281132+3840
INDIRI4
CNSTI4 0
EQI4 $268
ADDRLP4 20
ADDRGP4 rand
CALLI4
ASGNI4
CNSTF4 1073741824
ADDRLP4 20
INDIRI4
CNSTI4 32767
BANDI4
CVIF4 4
CNSTF4 1191181824
DIVF4
CNSTF4 1056964608
SUBF4
MULF4
ARGF4
ADDRLP4 24
ADDRGP4 fabs
CALLF4
ASGNF4
ADDRLP4 0
ADDRLP4 24
INDIRF4
ADDRLP4 4
INDIRI4
CVIF4 4
MULF4
CVFI4 4
ASGNI4
LABELV $268
ADDRLP4 0
INDIRI4
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3892
ADDP4
INDIRI4
NEI4 $272
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $272
ADDRLP4 0
INDIRI4
CNSTI4 0
GEI4 $278
ADDRLP4 0
ADDRLP4 4
INDIRI4
CNSTI4 1
SUBI4
ASGNI4
LABELV $278
ADDRLP4 0
INDIRI4
ADDRLP4 4
INDIRI4
LTI4 $280
ADDRLP4 0
CNSTI4 0
ASGNI4
LABELV $280
ADDRGP4 $282
ARGP4
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 7
LSHI4
ADDRGP4 cgs+2281132
ADDP4
ADDP4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 va
CALLP4
ASGNP4
ADDRLP4 12
ADDRLP4 20
INDIRP4
ASGNP4
ADDRLP4 8
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 7
LSHI4
ADDRGP4 cgs+2281132+1280
ADDP4
ADDP4
INDIRI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 300000
LEI4 $290
ADDRLP4 8
CNSTI4 300000
ASGNI4
LABELV $290
ADDRGP4 cgs+2281132+3944
ADDRGP4 cg+137588
INDIRI4
ADDRLP4 8
INDIRI4
ADDI4
ADDRGP4 cgs+2281132+3940
INDIRI4
SUBI4
ASGNI4
ADDRGP4 cgs+2281132+3932
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 cgs+2281132+3892
ADDP4
ADDRLP4 0
INDIRI4
ASGNI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 trap_S_StartBackgroundTrack
CALLV
pop
ADDRGP4 $187
ARGP4
ADDRGP4 cg_music+8
INDIRF4
ARGF4
ADDRLP4 28
ADDRGP4 va
CALLP4
ASGNP4
ADDRGP4 $186
ARGP4
ADDRLP4 28
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
LABELV $254
endproc CG_NextTrack 32 8
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
LABELV $282
byte 1 109
byte 1 117
byte 1 115
byte 1 105
byte 1 99
byte 1 47
byte 1 37
byte 1 115
byte 1 0
align 1
LABELV $240
byte 1 125
byte 1 0
align 1
LABELV $235
byte 1 123
byte 1 0
align 1
LABELV $228
byte 1 102
byte 1 97
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $223
byte 1 114
byte 1 97
byte 1 110
byte 1 100
byte 1 111
byte 1 109
byte 1 0
align 1
LABELV $218
byte 1 116
byte 1 121
byte 1 112
byte 1 101
byte 1 0
align 1
LABELV $215
byte 1 37
byte 1 99
byte 1 0
align 1
LABELV $209
byte 1 109
byte 1 117
byte 1 115
byte 1 105
byte 1 99
byte 1 47
byte 1 112
byte 1 108
byte 1 97
byte 1 121
byte 1 108
byte 1 105
byte 1 115
byte 1 116
byte 1 46
byte 1 99
byte 1 102
byte 1 103
byte 1 0
align 1
LABELV $197
byte 1 58
byte 1 0
align 1
LABELV $187
byte 1 37
byte 1 102
byte 1 0
align 1
LABELV $186
byte 1 115
byte 1 95
byte 1 109
byte 1 117
byte 1 115
byte 1 105
byte 1 99
byte 1 118
byte 1 111
byte 1 108
byte 1 117
byte 1 109
byte 1 101
byte 1 0
