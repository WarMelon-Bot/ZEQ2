code
proc InGame_RestartAction 0 8
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $78
ADDRGP4 $77
JUMPV
LABELV $78
ADDRGP4 UI_PopMenu
CALLV
pop
CNSTI4 2
ARGI4
ADDRGP4 $80
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
LABELV $77
endproc InGame_RestartAction 0 8
proc InGame_QuitAction 0 0
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $82
ADDRGP4 $81
JUMPV
LABELV $82
ADDRGP4 UI_PopMenu
CALLV
pop
ADDRGP4 UI_CreditMenu
CALLV
pop
LABELV $81
endproc InGame_QuitAction 0 0
export InGame_Event
proc InGame_Event 8 12
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $85
ADDRGP4 $84
JUMPV
LABELV $85
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 13
LTI4 $87
ADDRLP4 0
INDIRI4
CNSTI4 19
GTI4 $87
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $102-52
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $102
address $90
address $91
address $92
address $93
address $97
address $99
address $101
code
LABELV $90
ADDRGP4 UI_SystemSettingsMenu
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $91
ADDRGP4 UI_PlayerModelMenu
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $92
ADDRGP4 UI_CameraMenu
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $93
ADDRGP4 $94
ARGP4
ADDRGP4 $95
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
CNSTI4 2
ARGI4
ADDRGP4 $96
ARGP4
ADDRGP4 trap_Cmd_ExecuteText
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $97
ADDRGP4 $98
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 InGame_RestartAction
ARGP4
ADDRGP4 UI_ConfirmMenu
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $99
ADDRGP4 $100
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 InGame_QuitAction
ARGP4
ADDRGP4 UI_ConfirmMenu
CALLV
pop
ADDRGP4 $88
JUMPV
LABELV $101
ADDRGP4 UI_PopMenu
CALLV
pop
LABELV $87
LABELV $88
LABELV $84
endproc InGame_Event 8 12
export InGame_MenuInit
proc InGame_MenuInit 12 12
ADDRGP4 s_ingame
ARGP4
CNSTI4 0
ARGI4
CNSTI4 948
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 InGame_Cache
CALLV
pop
ADDRGP4 s_ingame+276
CNSTI4 1
ASGNI4
ADDRGP4 s_ingame+280
CNSTI4 0
ASGNI4
ADDRGP4 s_ingame+288
CNSTI4 6
ASGNI4
ADDRGP4 s_ingame+288+44
CNSTU4 16384
ASGNU4
ADDRGP4 s_ingame+288+4
ADDRGP4 $112
ASGNP4
ADDRGP4 s_ingame+288+12
CNSTI4 87
ASGNI4
ADDRGP4 s_ingame+288+16
CNSTI4 74
ASGNI4
ADDRGP4 s_ingame+288+72
CNSTI4 470
ASGNI4
ADDRGP4 s_ingame+288+76
CNSTI4 350
ASGNI4
ADDRLP4 0
CNSTI4 125
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+876
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+876+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+876+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+876+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+876+8
CNSTI4 19
ASGNI4
ADDRGP4 s_ingame+876+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+876+60
ADDRGP4 $134
ASGNP4
ADDRGP4 s_ingame+876+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+876+64
CNSTI4 2065
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+372
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+372+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+372+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+372+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+372+8
CNSTI4 13
ASGNI4
ADDRGP4 s_ingame+372+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+372+60
ADDRGP4 $152
ASGNP4
ADDRGP4 s_ingame+372+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+372+64
CNSTI4 2065
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+444
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+444+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+444+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+444+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+444+8
CNSTI4 14
ASGNI4
ADDRGP4 s_ingame+444+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+444+60
ADDRGP4 $170
ASGNP4
ADDRGP4 s_ingame+444+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+444+64
CNSTI4 2065
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+516
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+516+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+516+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+516+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+516+8
CNSTI4 15
ASGNI4
ADDRGP4 s_ingame+516+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+516+60
ADDRGP4 $188
ASGNP4
ADDRGP4 s_ingame+516+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+516+64
CNSTI4 2065
ASGNI4
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+732
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+732+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+732+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+732+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+732+8
CNSTI4 17
ASGNI4
ADDRGP4 s_ingame+732+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+732+60
ADDRGP4 $206
ASGNP4
ADDRGP4 s_ingame+732+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+732+64
CNSTI4 2065
ASGNI4
ADDRGP4 $213
ARGP4
ADDRLP4 4
ADDRGP4 trap_Cvar_VariableValue
CALLF4
ASGNF4
ADDRLP4 4
INDIRF4
CNSTF4 0
NEF4 $211
ADDRLP4 8
ADDRGP4 s_ingame+732+44
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRU4
CNSTU4 8192
BORU4
ASGNU4
LABELV $211
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 28
ADDI4
ASGNI4
ADDRGP4 s_ingame+660
CNSTI4 9
ASGNI4
ADDRGP4 s_ingame+660+44
CNSTU4 264
ASGNU4
ADDRGP4 s_ingame+660+12
CNSTI4 320
ASGNI4
ADDRGP4 s_ingame+660+16
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_ingame+660+8
CNSTI4 16
ASGNI4
ADDRGP4 s_ingame+660+48
ADDRGP4 InGame_Event
ASGNP4
ADDRGP4 s_ingame+660+60
ADDRGP4 $229
ASGNP4
ADDRGP4 s_ingame+660+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_ingame+660+64
CNSTI4 2065
ASGNI4
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+876
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+732
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+372
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+444
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+516
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 s_ingame+660
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
LABELV $104
endproc InGame_MenuInit 12 12
export InGame_Cache
proc InGame_Cache 0 4
ADDRGP4 $112
ARGP4
ADDRGP4 trap_R_RegisterShaderNoMip
CALLI4
pop
LABELV $241
endproc InGame_Cache 0 4
export UI_InGameMenu
proc UI_InGameMenu 0 4
ADDRGP4 uis+16
CNSTI4 0
ASGNI4
ADDRGP4 uis+8
CNSTI4 320
ASGNI4
ADDRGP4 uis+12
CNSTI4 240
ASGNI4
ADDRGP4 InGame_MenuInit
CALLV
pop
ADDRGP4 s_ingame
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
LABELV $242
endproc UI_InGameMenu 0 4
bss
align 4
LABELV s_ingame
skip 948
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
LABELV $229
byte 1 76
byte 1 69
byte 1 65
byte 1 86
byte 1 69
byte 1 0
align 1
LABELV $213
byte 1 115
byte 1 118
byte 1 95
byte 1 114
byte 1 117
byte 1 110
byte 1 110
byte 1 105
byte 1 110
byte 1 103
byte 1 0
align 1
LABELV $206
byte 1 82
byte 1 69
byte 1 83
byte 1 84
byte 1 65
byte 1 82
byte 1 84
byte 1 0
align 1
LABELV $188
byte 1 67
byte 1 65
byte 1 77
byte 1 69
byte 1 82
byte 1 65
byte 1 0
align 1
LABELV $170
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 69
byte 1 82
byte 1 0
align 1
LABELV $152
byte 1 79
byte 1 80
byte 1 84
byte 1 73
byte 1 79
byte 1 78
byte 1 83
byte 1 0
align 1
LABELV $134
byte 1 82
byte 1 69
byte 1 83
byte 1 85
byte 1 77
byte 1 69
byte 1 0
align 1
LABELV $112
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
byte 1 100
byte 1 100
byte 1 98
byte 1 111
byte 1 116
byte 1 102
byte 1 114
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $100
byte 1 69
byte 1 88
byte 1 73
byte 1 84
byte 1 32
byte 1 71
byte 1 65
byte 1 77
byte 1 69
byte 1 63
byte 1 0
align 1
LABELV $98
byte 1 82
byte 1 69
byte 1 83
byte 1 84
byte 1 65
byte 1 82
byte 1 84
byte 1 32
byte 1 71
byte 1 65
byte 1 77
byte 1 69
byte 1 63
byte 1 0
align 1
LABELV $96
byte 1 100
byte 1 105
byte 1 115
byte 1 99
byte 1 111
byte 1 110
byte 1 110
byte 1 101
byte 1 99
byte 1 116
byte 1 10
byte 1 0
align 1
LABELV $95
byte 1 48
byte 1 0
align 1
LABELV $94
byte 1 103
byte 1 95
byte 1 101
byte 1 100
byte 1 105
byte 1 116
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 0
align 1
LABELV $80
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
byte 1 48
byte 1 10
byte 1 0
