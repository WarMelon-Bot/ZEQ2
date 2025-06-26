export CG_InitRadarBlips
code
proc CG_InitRadarBlips 4 12
ADDRLP4 0
CNSTI4 0
ASGNI4
ADDRGP4 cg_radarWarningAlready
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 cg_playerOrigins
ARGP4
ADDRLP4 0
INDIRI4
ARGI4
CNSTI4 2304
ARGI4
ADDRGP4 memset
CALLP4
pop
LABELV $101
endproc CG_InitRadarBlips 4 12
lit
align 4
LABELV $103
byte 4 0
byte 4 0
byte 4 1065353216
code
proc CG_DrawRadarBlips 220 24
ADDRFP4 8
ADDRFP4 8
INDIRF4
ASGNF4
ADDRFP4 12
ADDRFP4 12
INDIRF4
ASGNF4
ADDRLP4 132
ADDRGP4 $103
INDIRB
ASGNB 12
ADDRLP4 64
ADDRGP4 cg+137620
ASGNP4
ADDRLP4 148
CNSTI4 0
ASGNI4
ADDRLP4 144
ADDRLP4 148
INDIRI4
ASGNI4
ADDRLP4 152
CNSTF4 1056964608
ASGNF4
ADDRLP4 124
ADDRFP4 0
INDIRF4
ADDRLP4 152
INDIRF4
ADDRFP4 8
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 128
ADDRFP4 4
INDIRF4
ADDRLP4 152
INDIRF4
ADDRFP4 12
INDIRF4
MULF4
ADDF4
ASGNF4
ADDRLP4 0
ADDRLP4 148
INDIRI4
ASGNI4
LABELV $105
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_playerOrigins
ADDP4
INDIRI4
CNSTI4 0
NEI4 $109
ADDRGP4 $106
JUMPV
LABELV $109
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_playerOrigins+20
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 180
ADDP4
INDIRI4
NEI4 $111
ADDRGP4 $106
JUMPV
LABELV $111
ADDRLP4 156
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 4
ADDRLP4 156
INDIRI4
ADDRGP4 cg_playerOrigins+24
ADDP4
INDIRF4
ADDRLP4 64
INDIRP4
CNSTI4 20
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+4
ADDRLP4 156
INDIRI4
ADDRGP4 cg_playerOrigins+24+4
ADDP4
INDIRF4
ADDRLP4 64
INDIRP4
CNSTI4 24
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4+8
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_playerOrigins+24+8
ADDP4
INDIRF4
ADDRLP4 64
INDIRP4
CNSTI4 28
ADDP4
INDIRF4
SUBF4
ASGNF4
ADDRLP4 4
ARGP4
ADDRLP4 164
ADDRGP4 VectorLength
CALLF4
ASGNF4
ADDRLP4 164
INDIRF4
CNSTF4 1182400512
LEF4 $122
ADDRGP4 $106
JUMPV
LABELV $122
ADDRLP4 104
ARGP4
ADDRLP4 132
ARGP4
ADDRLP4 4
ARGP4
CNSTF4 1119092736
ADDRLP4 64
INDIRP4
CNSTI4 152
ADDP4
INDIRF4
SUBF4
ARGF4
ADDRGP4 RotatePointAroundVector
CALLV
pop
ADDRLP4 4
ADDRLP4 104
INDIRB
ASGNB 12
ADDRLP4 168
CNSTF4 1056964608
ASGNF4
ADDRLP4 172
CNSTF4 1182400512
ASGNF4
ADDRLP4 72
ADDRLP4 168
INDIRF4
ADDRLP4 4
INDIRF4
ADDRLP4 172
INDIRF4
DIVF4
MULF4
ADDRFP4 8
INDIRF4
MULF4
ADDRLP4 124
INDIRF4
ADDF4
ASGNF4
ADDRLP4 76
ADDRLP4 168
INDIRF4
ADDRLP4 4+4
INDIRF4
NEGF4
ADDRLP4 172
INDIRF4
DIVF4
MULF4
ADDRFP4 12
INDIRF4
MULF4
ADDRLP4 128
INDIRF4
ADDF4
ASGNF4
ADDRLP4 176
CNSTF4 1103101952
ASGNF4
ADDRLP4 16
ADDRLP4 176
INDIRF4
ADDRLP4 168
INDIRF4
ADDRLP4 4+8
INDIRF4
ADDRLP4 172
INDIRF4
DIVF4
MULF4
MULF4
ADDRLP4 176
INDIRF4
ADDF4
ASGNF4
ADDRLP4 20
ADDRLP4 16
INDIRF4
ASGNF4
ADDRLP4 116
ADDRGP4 cg+40
INDIRP4
CNSTI4 592
ADDP4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 180
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 80
ADDRLP4 180
INDIRI4
ADDRGP4 cg_playerOrigins+8
ADDP4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 120
ADDRGP4 cg+40
INDIRP4
CNSTI4 608
ADDP4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 84
ADDRLP4 180
INDIRI4
ADDRGP4 cg_playerOrigins+12
ADDP4
INDIRI4
CVIF4 4
ASGNF4
ADDRLP4 184
CNSTF4 1065353216
ASGNF4
ADDRLP4 60
ADDRLP4 184
INDIRF4
ADDRLP4 116
INDIRF4
ADDRLP4 80
INDIRF4
DIVF4
SUBF4
ASGNF4
ADDRLP4 68
ADDRLP4 184
INDIRF4
ADDRLP4 120
INDIRF4
ADDRLP4 84
INDIRF4
DIVF4
SUBF4
ASGNF4
ADDRLP4 60
INDIRF4
ADDRLP4 184
INDIRF4
LEF4 $130
ADDRLP4 60
CNSTF4 1065353216
ASGNF4
LABELV $130
ADDRLP4 60
INDIRF4
CNSTF4 0
GEF4 $132
ADDRLP4 60
CNSTF4 0
ASGNF4
LABELV $132
ADDRLP4 68
INDIRF4
CNSTF4 1065353216
LEF4 $134
ADDRLP4 68
CNSTF4 1065353216
ASGNF4
LABELV $134
ADDRLP4 68
INDIRF4
CNSTF4 0
GEF4 $136
ADDRLP4 68
CNSTF4 0
ASGNF4
LABELV $136
ADDRLP4 56
ADDRLP4 60
INDIRF4
ASGNF4
ADDRLP4 56
INDIRF4
CNSTF4 1065353216
LEF4 $138
ADDRLP4 56
CNSTF4 1065353216
ASGNF4
LABELV $138
ADDRLP4 56
INDIRF4
CNSTF4 0
GEF4 $140
ADDRLP4 56
CNSTF4 0
ASGNF4
LABELV $140
ADDRLP4 188
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 188
INDIRI4
ADDRGP4 cg_playerOrigins+4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 724
ADDP4
INDIRI4
NEI4 $142
ADDRLP4 188
INDIRI4
ADDRGP4 cg_playerOrigins+4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $142
ADDRLP4 24
CNSTF4 0
ASGNF4
ADDRLP4 24+4
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 24+8
CNSTF4 0
ASGNF4
ADDRLP4 24+12
ADDRLP4 80
INDIRF4
ADDRLP4 84
INDIRF4
DIVF4
ASGNF4
ADDRLP4 88
CNSTF4 0
ASGNF4
ADDRLP4 88+4
CNSTF4 1065353216
ASGNF4
ADDRLP4 88+8
CNSTF4 0
ASGNF4
ADDRLP4 88+12
ADDRLP4 80
INDIRF4
ADDRLP4 84
INDIRF4
DIVF4
ASGNF4
ADDRLP4 40
CNSTF4 0
ASGNF4
ADDRLP4 40+4
CNSTF4 1065353216
ASGNF4
ADDRLP4 40+8
CNSTF4 0
ASGNF4
ADDRLP4 40+12
CNSTF4 1065353216
ASGNF4
ADDRGP4 $143
JUMPV
LABELV $142
ADDRLP4 24
ADDRLP4 56
INDIRF4
ASGNF4
ADDRLP4 24+4
CNSTF4 0
ASGNF4
ADDRLP4 24+8
CNSTF4 0
ASGNF4
ADDRLP4 24+12
ADDRLP4 80
INDIRF4
ADDRLP4 84
INDIRF4
DIVF4
ASGNF4
ADDRLP4 40
CNSTF4 1065353216
ASGNF4
ADDRLP4 40+4
CNSTF4 0
ASGNF4
ADDRLP4 40+8
CNSTF4 0
ASGNF4
ADDRLP4 40+12
CNSTF4 1065353216
ASGNF4
LABELV $143
ADDRLP4 24
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
CNSTI4 0
ARGI4
ADDRLP4 192
CNSTF4 1056964608
ASGNF4
ADDRLP4 72
INDIRF4
ADDRLP4 192
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 76
INDIRF4
ADDRLP4 192
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
INDIRF4
ARGF4
ADDRGP4 cgs+2280484+40
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
ADDRLP4 40
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_playerOrigins+16
ADDP4
INDIRI4
CNSTI4 2
BANDI4
CNSTI4 0
EQI4 $164
CNSTI4 0
ARGI4
ADDRLP4 204
CNSTF4 1056964608
ASGNF4
ADDRLP4 72
INDIRF4
ADDRLP4 204
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 76
INDIRF4
ADDRLP4 204
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
INDIRF4
ARGF4
ADDRGP4 cgs+2280484+48
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
LABELV $164
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ADDRGP4 cg_playerOrigins+16
ADDP4
INDIRI4
CNSTI4 1
BANDI4
CNSTI4 0
EQI4 $169
CNSTI4 0
ARGI4
ADDRLP4 204
CNSTF4 1056964608
ASGNF4
ADDRLP4 72
INDIRF4
ADDRLP4 204
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 76
INDIRF4
ADDRLP4 204
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
INDIRF4
ARGF4
ADDRGP4 cgs+2280484+52
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
ADDRLP4 144
CNSTI4 1
ASGNI4
LABELV $169
ADDRLP4 204
CNSTI4 36
ADDRLP4 0
INDIRI4
MULI4
ASGNI4
ADDRLP4 204
INDIRI4
ADDRGP4 cg_playerOrigins+4
ADDP4
INDIRI4
ADDRGP4 cg+40
INDIRP4
CNSTI4 724
ADDP4
INDIRI4
NEI4 $174
ADDRLP4 204
INDIRI4
ADDRGP4 cg_playerOrigins+4
ADDP4
INDIRI4
CNSTI4 0
EQI4 $174
ADDRLP4 88
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
CNSTI4 0
ARGI4
ADDRLP4 208
CNSTF4 1056964608
ASGNF4
ADDRLP4 72
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 16
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 76
INDIRF4
ADDRLP4 208
INDIRF4
ADDRLP4 20
INDIRF4
MULF4
SUBF4
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
INDIRF4
ARGF4
ADDRGP4 cgs+2280484+44
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
LABELV $174
CNSTP4 0
ARGP4
ADDRGP4 trap_R_SetColor
CALLV
pop
LABELV $106
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 64
LTI4 $105
CNSTI4 0
ARGI4
ADDRLP4 156
CNSTF4 1090519040
ASGNF4
ADDRLP4 124
INDIRF4
ADDRLP4 156
INDIRF4
SUBF4
ARGF4
ADDRLP4 128
INDIRF4
ADDRLP4 156
INDIRF4
SUBF4
ARGF4
ADDRLP4 160
CNSTF4 1098907648
ASGNF4
ADDRLP4 160
INDIRF4
ARGF4
ADDRLP4 160
INDIRF4
ARGF4
ADDRGP4 cgs+2280484+56
INDIRI4
ARGI4
ADDRGP4 CG_DrawPic
CALLV
pop
ADDRLP4 164
CNSTI4 0
ASGNI4
ADDRLP4 144
INDIRI4
ADDRLP4 164
INDIRI4
EQI4 $183
ADDRGP4 cg_radarWarningAlready
INDIRI4
ADDRLP4 164
INDIRI4
NEI4 $183
ADDRGP4 cg_radarWarningAlready
CNSTI4 1
ASGNI4
ADDRGP4 cgs+2280484+492
INDIRI4
ARGI4
CNSTI4 6
ARGI4
ADDRGP4 trap_S_StartLocalSound
CALLV
pop
LABELV $183
ADDRLP4 144
INDIRI4
CNSTI4 0
NEI4 $187
ADDRGP4 cg_radarWarningAlready
CNSTI4 0
ASGNI4
LABELV $187
LABELV $102
endproc CG_DrawRadarBlips 220 24
export CG_DrawRadar
proc CG_DrawRadar 8 16
ADDRLP4 0
ADDRGP4 cg+137620
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 200
ADDP4
INDIRI4
CNSTI4 0
GTI4 $191
CNSTF4 1140850688
ARGF4
CNSTF4 0
ARGF4
ADDRLP4 4
CNSTF4 1124073472
ASGNF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRLP4 4
INDIRF4
ARGF4
ADDRGP4 CG_DrawRadarBlips
CALLV
pop
LABELV $191
LABELV $189
endproc CG_DrawRadar 8 16
bss
align 4
LABELV cg_radarWarningAlready
skip 4
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
export cg_playerOrigins
align 4
LABELV cg_playerOrigins
skip 2304
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
