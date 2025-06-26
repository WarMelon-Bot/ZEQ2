code
proc Options_Event 4 0
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $78
ADDRGP4 $77
JUMPV
LABELV $78
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 14
EQI4 $83
ADDRGP4 $80
JUMPV
LABELV $83
ADDRGP4 UI_PopMenu
CALLV
pop
LABELV $80
LABELV $81
LABELV $77
endproc Options_Event 4 0
export SystemConfig_Cache
proc SystemConfig_Cache 0 4
ADDRGP4 $85
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $86
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $87
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
ADDRGP4 $88
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
LABELV $84
endproc SystemConfig_Cache 0 4
export Options_MenuInit
proc Options_MenuInit 3088 12
ADDRGP4 s_options
ARGP4
CNSTI4 0
ARGI4
CNSTI4 900
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 SystemConfig_Cache
CALLV
pop
ADDRGP4 s_options+276
CNSTI4 1
ASGNI4
ADDRLP4 4
ARGP4
ADDRGP4 trap_GetClientState
CALLV
pop
ADDRLP4 4
INDIRI4
CNSTI4 5
LTI4 $91
ADDRGP4 s_options+280
CNSTI4 0
ASGNI4
ADDRGP4 $92
JUMPV
LABELV $91
ADDRGP4 s_options+280
CNSTI4 1
ASGNI4
LABELV $92
ADDRGP4 s_options+288
CNSTI4 10
ASGNI4
ADDRGP4 s_options+288+44
CNSTU4 8
ASGNU4
ADDRGP4 s_options+288+12
CNSTI4 320
ASGNI4
ADDRGP4 s_options+288+16
CNSTI4 16
ASGNI4
ADDRGP4 s_options+288+60
ADDRGP4 $104
ASGNP4
ADDRGP4 s_options+288+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_options+288+64
CNSTI4 2049
ASGNI4
ADDRGP4 s_options+360
CNSTI4 6
ASGNI4
ADDRGP4 s_options+360+4
ADDRGP4 $85
ASGNP4
ADDRGP4 s_options+360+44
CNSTU4 16384
ASGNU4
ADDRGP4 s_options+360+12
CNSTI4 8
ASGNI4
ADDRGP4 s_options+360+16
CNSTI4 76
ASGNI4
ADDRGP4 s_options+360+72
CNSTI4 256
ASGNI4
ADDRGP4 s_options+360+76
CNSTI4 334
ASGNI4
ADDRGP4 s_options+444
CNSTI4 6
ASGNI4
ADDRGP4 s_options+444+4
ADDRGP4 $86
ASGNP4
ADDRGP4 s_options+444+44
CNSTU4 16384
ASGNU4
ADDRGP4 s_options+444+12
CNSTI4 376
ASGNI4
ADDRGP4 s_options+444+16
CNSTI4 76
ASGNI4
ADDRGP4 s_options+444+72
CNSTI4 256
ASGNI4
ADDRGP4 s_options+444+76
CNSTI4 334
ASGNI4
ADDRLP4 0
CNSTI4 168
ASGNI4
ADDRGP4 s_options+528
CNSTI4 9
ASGNI4
ADDRGP4 s_options+528+44
CNSTU4 264
ASGNU4
ADDRGP4 s_options+528+48
ADDRGP4 Options_Event
ASGNP4
ADDRGP4 s_options+528+8
CNSTI4 10
ASGNI4
ADDRGP4 s_options+528+12
CNSTI4 320
ASGNI4
ADDRGP4 s_options+528+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_options+528+60
ADDRGP4 $148
ASGNP4
ADDRGP4 s_options+528+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_options+528+64
CNSTI4 2049
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 34
ADDI4
ASGNI4
ADDRGP4 s_options+600
CNSTI4 9
ASGNI4
ADDRGP4 s_options+600+44
CNSTU4 264
ASGNU4
ADDRGP4 s_options+600+48
ADDRGP4 Options_Event
ASGNP4
ADDRGP4 s_options+600+8
CNSTI4 11
ASGNI4
ADDRGP4 s_options+600+12
CNSTI4 320
ASGNI4
ADDRGP4 s_options+600+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_options+600+60
ADDRGP4 $166
ASGNP4
ADDRGP4 s_options+600+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_options+600+64
CNSTI4 2049
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 34
ADDI4
ASGNI4
ADDRGP4 s_options+672
CNSTI4 9
ASGNI4
ADDRGP4 s_options+672+44
CNSTU4 264
ASGNU4
ADDRGP4 s_options+672+48
ADDRGP4 Options_Event
ASGNP4
ADDRGP4 s_options+672+8
CNSTI4 12
ASGNI4
ADDRGP4 s_options+672+12
CNSTI4 320
ASGNI4
ADDRGP4 s_options+672+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_options+672+60
ADDRGP4 $184
ASGNP4
ADDRGP4 s_options+672+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_options+672+64
CNSTI4 2049
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 34
ADDI4
ASGNI4
ADDRGP4 s_options+744
CNSTI4 9
ASGNI4
ADDRGP4 s_options+744+44
CNSTU4 264
ASGNU4
ADDRGP4 s_options+744+48
ADDRGP4 Options_Event
ASGNP4
ADDRGP4 s_options+744+8
CNSTI4 13
ASGNI4
ADDRGP4 s_options+744+12
CNSTI4 320
ASGNI4
ADDRGP4 s_options+744+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_options+744+60
ADDRGP4 $202
ASGNP4
ADDRGP4 s_options+744+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_options+744+64
CNSTI4 2049
ASGNI4
ADDRGP4 s_options+816
CNSTI4 6
ASGNI4
ADDRGP4 s_options+816+4
ADDRGP4 $87
ASGNP4
ADDRGP4 s_options+816+44
CNSTU4 260
ASGNU4
ADDRGP4 s_options+816+48
ADDRGP4 Options_Event
ASGNP4
ADDRGP4 s_options+816+8
CNSTI4 14
ASGNI4
ADDRGP4 s_options+816+12
CNSTI4 0
ASGNI4
ADDRGP4 s_options+816+16
CNSTI4 416
ASGNI4
ADDRGP4 s_options+816+72
CNSTI4 128
ASGNI4
ADDRGP4 s_options+816+76
CNSTI4 64
ASGNI4
ADDRGP4 s_options+816+60
ADDRGP4 $88
ASGNP4
ADDRGP4 s_options
ARGP4
ADDRGP4 s_options+528
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_options
ARGP4
ADDRGP4 s_options+600
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_options
ARGP4
ADDRGP4 s_options+672
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_options
ARGP4
ADDRGP4 s_options+744
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_options
ARGP4
ADDRGP4 s_options+816
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
LABELV $89
endproc Options_MenuInit 3088 12
export UI_SystemConfigMenu
proc UI_SystemConfigMenu 0 4
ADDRGP4 uis+20
CNSTI4 0
ASGNI4
ADDRGP4 Options_MenuInit
CALLV
pop
ADDRGP4 s_options
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
LABELV $231
endproc UI_SystemConfigMenu 0 4
bss
align 4
LABELV s_options
skip 900
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
LABELV $202
byte 1 78
byte 1 69
byte 1 84
byte 1 87
byte 1 79
byte 1 82
byte 1 75
byte 1 0
align 1
LABELV $184
byte 1 83
byte 1 79
byte 1 85
byte 1 78
byte 1 68
byte 1 0
align 1
LABELV $166
byte 1 68
byte 1 73
byte 1 83
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 0
align 1
LABELV $148
byte 1 71
byte 1 82
byte 1 65
byte 1 80
byte 1 72
byte 1 73
byte 1 67
byte 1 83
byte 1 0
align 1
LABELV $104
byte 1 83
byte 1 89
byte 1 83
byte 1 84
byte 1 69
byte 1 77
byte 1 32
byte 1 83
byte 1 69
byte 1 84
byte 1 85
byte 1 80
byte 1 0
align 1
LABELV $88
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
LABELV $87
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
LABELV $86
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
LABELV $85
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
