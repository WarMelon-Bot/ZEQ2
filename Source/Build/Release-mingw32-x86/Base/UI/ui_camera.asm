data
align 4
LABELV g_cameraconfigcvars
address $78
byte 4 0
byte 4 0
address $79
byte 4 0
byte 4 0
address $80
byte 4 0
byte 4 0
address $81
byte 4 0
byte 4 0
byte 4 0
byte 4 0
byte 4 0
code
proc Camera_InitCvars 28 8
ADDRLP4 0
ADDRGP4 g_cameraconfigcvars
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $83
ADDRLP4 0
INDIRP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $87
ADDRGP4 $85
JUMPV
LABELV $87
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRLP4 12
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
ADDRLP4 12
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRGP4 trap_Cvar_Reset
CALLV
pop
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRLP4 20
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
ADDRLP4 20
INDIRF4
ASGNF4
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
LABELV $84
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRGP4 $83
JUMPV
LABELV $85
LABELV $82
endproc Camera_InitCvars 28 8
proc Camera_GetCvarDefault 12 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRGP4 g_cameraconfigcvars
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $90
ADDRLP4 0
INDIRP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $94
CNSTF4 0
RETF4
ADDRGP4 $89
JUMPV
LABELV $94
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $96
ADDRGP4 $92
JUMPV
LABELV $96
LABELV $91
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRGP4 $90
JUMPV
LABELV $92
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRF4
RETF4
LABELV $89
endproc Camera_GetCvarDefault 12 8
proc Camera_GetCvarValue 12 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRGP4 g_cameraconfigcvars
ASGNP4
ADDRLP4 4
CNSTI4 0
ASGNI4
LABELV $99
ADDRLP4 0
INDIRP4
INDIRP4
CVPU4 4
CNSTU4 0
NEU4 $103
CNSTF4 0
RETF4
ADDRGP4 $98
JUMPV
LABELV $103
ADDRLP4 0
INDIRP4
INDIRP4
ARGP4
ADDRFP4 0
INDIRP4
ARGP4
ADDRLP4 8
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 8
INDIRI4
CNSTI4 0
NEI4 $105
ADDRGP4 $101
JUMPV
LABELV $105
LABELV $100
ADDRLP4 4
ADDRLP4 4
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
ASGNP4
ADDRGP4 $99
JUMPV
LABELV $101
ADDRLP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRF4
RETF4
LABELV $98
endproc Camera_GetCvarValue 12 8
proc Camera_GetConfig 32 12
ADDRGP4 $78
ARGP4
ADDRLP4 0
ADDRGP4 Camera_GetCvarValue
CALLF4
ASGNF4
CNSTF4 1097859072
ARGF4
CNSTF4 1125515264
ARGF4
ADDRLP4 0
INDIRF4
ARGF4
ADDRLP4 4
ADDRGP4 UI_ClampCvar
CALLF4
ASGNF4
ADDRGP4 s_camera+576+68
ADDRLP4 4
INDIRF4
ASGNF4
ADDRGP4 $79
ARGP4
ADDRLP4 8
ADDRGP4 Camera_GetCvarValue
CALLF4
ASGNF4
CNSTF4 3265265664
ARGF4
CNSTF4 1117782016
ARGF4
ADDRLP4 8
INDIRF4
ARGF4
ADDRLP4 12
ADDRGP4 UI_ClampCvar
CALLF4
ASGNF4
ADDRGP4 s_camera+652+68
ADDRLP4 12
INDIRF4
ASGNF4
ADDRGP4 $80
ARGP4
ADDRLP4 16
ADDRGP4 Camera_GetCvarValue
CALLF4
ASGNF4
CNSTF4 3272998912
ARGF4
CNSTF4 1125515264
ARGF4
ADDRLP4 16
INDIRF4
ARGF4
ADDRLP4 20
ADDRGP4 UI_ClampCvar
CALLF4
ASGNF4
ADDRGP4 s_camera+728+68
ADDRLP4 20
INDIRF4
ASGNF4
ADDRGP4 $81
ARGP4
ADDRLP4 24
ADDRGP4 Camera_GetCvarValue
CALLF4
ASGNF4
CNSTF4 0
ARGF4
CNSTF4 1135837184
ARGF4
ADDRLP4 24
INDIRF4
ARGF4
ADDRLP4 28
ADDRGP4 UI_ClampCvar
CALLF4
ASGNF4
ADDRGP4 s_camera+804+68
ADDRLP4 28
INDIRF4
ASGNF4
LABELV $107
endproc Camera_GetConfig 32 12
proc Camera_SetConfig 0 8
ADDRGP4 $78
ARGP4
ADDRGP4 s_camera+576+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $79
ARGP4
ADDRGP4 s_camera+652+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $80
ARGP4
ADDRGP4 s_camera+728+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
ADDRGP4 $81
ARGP4
ADDRGP4 s_camera+804+68
INDIRF4
ARGF4
ADDRGP4 trap_Cvar_SetValue
CALLV
pop
LABELV $116
endproc Camera_SetConfig 0 8
proc Camera_MenuEvent 8 0
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 10
LTI4 $126
ADDRLP4 0
INDIRI4
CNSTI4 14
GTI4 $126
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $139-40
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $139
address $135
address $135
address $135
address $129
address $135
code
LABELV $129
ADDRFP4 4
INDIRI4
CNSTI4 3
NEI4 $127
ADDRGP4 s_camera+880
INDIRI4
CNSTI4 0
EQI4 $132
ADDRGP4 Camera_SetConfig
CALLV
pop
LABELV $132
ADDRGP4 UI_PopMenu
CALLV
pop
ADDRGP4 $127
JUMPV
LABELV $135
ADDRFP4 4
INDIRI4
CNSTI4 3
NEI4 $127
ADDRGP4 s_camera+880
CNSTI4 1
ASGNI4
ADDRGP4 Camera_SetConfig
CALLV
pop
LABELV $126
LABELV $127
LABELV $125
endproc Camera_MenuEvent 8 0
proc Camera_MenuInit 0 12
ADDRGP4 s_camera
ARGP4
CNSTI4 0
ARGI4
CNSTI4 968
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 Camera_Cache
CALLV
pop
ADDRGP4 s_camera+276
CNSTI4 1
ASGNI4
ADDRGP4 s_camera+280
CNSTI4 0
ASGNI4
ADDRGP4 s_camera+288
CNSTI4 10
ASGNI4
ADDRGP4 s_camera+288+44
CNSTU4 8
ASGNU4
ADDRGP4 s_camera+288+12
CNSTI4 320
ASGNI4
ADDRGP4 s_camera+288+16
CNSTI4 16
ASGNI4
ADDRGP4 s_camera+288+60
ADDRGP4 $153
ASGNP4
ADDRGP4 s_camera+288+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_camera+288+64
CNSTI4 2049
ASGNI4
ADDRGP4 s_camera+576
CNSTI4 1
ASGNI4
ADDRGP4 s_camera+576+4
ADDRGP4 $161
ASGNP4
ADDRGP4 s_camera+576+44
CNSTU4 258
ASGNU4
ADDRGP4 s_camera+576+48
ADDRGP4 Camera_MenuEvent
ASGNP4
ADDRGP4 s_camera+576+8
CNSTI4 10
ASGNI4
ADDRGP4 s_camera+576+12
CNSTI4 70
ASGNI4
ADDRGP4 s_camera+576+16
CNSTI4 40
ASGNI4
ADDRGP4 s_camera+576+60
CNSTF4 1097859072
ASGNF4
ADDRGP4 s_camera+576+64
CNSTF4 1125515264
ASGNF4
ADDRGP4 s_camera+652
CNSTI4 1
ASGNI4
ADDRGP4 s_camera+652+4
ADDRGP4 $179
ASGNP4
ADDRGP4 s_camera+652+44
CNSTU4 258
ASGNU4
ADDRGP4 s_camera+652+48
ADDRGP4 Camera_MenuEvent
ASGNP4
ADDRGP4 s_camera+652+8
CNSTI4 11
ASGNI4
ADDRGP4 s_camera+652+12
CNSTI4 70
ASGNI4
ADDRGP4 s_camera+652+16
CNSTI4 60
ASGNI4
ADDRGP4 s_camera+652+60
CNSTF4 3265265664
ASGNF4
ADDRGP4 s_camera+652+64
CNSTF4 1117782016
ASGNF4
ADDRGP4 s_camera+728
CNSTI4 1
ASGNI4
ADDRGP4 s_camera+728+4
ADDRGP4 $197
ASGNP4
ADDRGP4 s_camera+728+44
CNSTU4 258
ASGNU4
ADDRGP4 s_camera+728+48
ADDRGP4 Camera_MenuEvent
ASGNP4
ADDRGP4 s_camera+728+8
CNSTI4 14
ASGNI4
ADDRGP4 s_camera+728+12
CNSTI4 70
ASGNI4
ADDRGP4 s_camera+728+16
CNSTI4 80
ASGNI4
ADDRGP4 s_camera+728+60
CNSTF4 3272998912
ASGNF4
ADDRGP4 s_camera+728+64
CNSTF4 1125515264
ASGNF4
ADDRGP4 s_camera+804
CNSTI4 1
ASGNI4
ADDRGP4 s_camera+804+4
ADDRGP4 $215
ASGNP4
ADDRGP4 s_camera+804+44
CNSTU4 258
ASGNU4
ADDRGP4 s_camera+804+48
ADDRGP4 Camera_MenuEvent
ASGNP4
ADDRGP4 s_camera+804+8
CNSTI4 12
ASGNI4
ADDRGP4 s_camera+804+12
CNSTI4 70
ASGNI4
ADDRGP4 s_camera+804+16
CNSTI4 100
ASGNI4
ADDRGP4 s_camera+804+60
CNSTF4 0
ASGNF4
ADDRGP4 s_camera+804+64
CNSTF4 1135837184
ASGNF4
ADDRGP4 s_camera+884
CNSTI4 6
ASGNI4
ADDRGP4 s_camera+884+4
ADDRGP4 $233
ASGNP4
ADDRGP4 s_camera+884+44
CNSTU4 260
ASGNU4
ADDRGP4 s_camera+884+12
CNSTI4 512
ASGNI4
ADDRGP4 s_camera+884+16
CNSTI4 416
ASGNI4
ADDRGP4 s_camera+884+8
CNSTI4 13
ASGNI4
ADDRGP4 s_camera+884+48
ADDRGP4 Camera_MenuEvent
ASGNP4
ADDRGP4 s_camera+884+72
CNSTI4 128
ASGNI4
ADDRGP4 s_camera+884+76
CNSTI4 64
ASGNI4
ADDRGP4 s_camera+884+60
ADDRGP4 $250
ASGNP4
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+576
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+652
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+728
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+804
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 s_camera+884
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 Camera_InitCvars
CALLV
pop
ADDRGP4 Camera_GetConfig
CALLV
pop
LABELV $141
endproc Camera_MenuInit 0 12
export Camera_Cache
proc Camera_Cache 0 4
ADDRGP4 $233
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $250
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
LABELV $257
endproc Camera_Cache 0 4
export UI_CameraMenu
proc UI_CameraMenu 0 4
ADDRGP4 Camera_MenuInit
CALLV
pop
ADDRGP4 s_camera
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
LABELV $258
endproc UI_CameraMenu 0 4
bss
align 4
LABELV s_camera
skip 968
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
import Preferences_Cache
import UI_PreferencesMenu
import PlayerSettings_Cache
import UI_PlayerSettingsMenu
import PlayerModel_Cache
import UI_PlayerModelMenu
import Controls_Cache
import UI_ControlsMenu
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
LABELV $250
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
LABELV $233
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
LABELV $215
byte 1 65
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $197
byte 1 83
byte 1 108
byte 1 105
byte 1 100
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $179
byte 1 72
byte 1 101
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 58
byte 1 0
align 1
LABELV $161
byte 1 82
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 58
byte 1 0
align 1
LABELV $153
byte 1 67
byte 1 65
byte 1 77
byte 1 69
byte 1 82
byte 1 65
byte 1 0
align 1
LABELV $81
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
byte 1 65
byte 1 110
byte 1 103
byte 1 108
byte 1 101
byte 1 0
align 1
LABELV $80
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
byte 1 83
byte 1 108
byte 1 105
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $79
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
byte 1 72
byte 1 101
byte 1 105
byte 1 103
byte 1 104
byte 1 116
byte 1 0
align 1
LABELV $78
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
byte 1 82
byte 1 97
byte 1 110
byte 1 103
byte 1 101
byte 1 0
