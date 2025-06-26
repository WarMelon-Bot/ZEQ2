data
export multiXpos
align 4
LABELV multiXpos
byte 4 28
export multiYpos
align 4
LABELV multiYpos
byte 4 119
export setupXpos
align 4
LABELV setupXpos
byte 4 28
export setupYpos
align 4
LABELV setupYpos
byte 4 157
export exitXpos
align 4
LABELV exitXpos
byte 4 28
export exitYpos
align 4
LABELV exitYpos
byte 4 195
code
proc MainMenu_DrawPlayer 96 28
ADDRGP4 $79
ARGP4
ADDRLP4 4
ARGP4
CNSTI4 64
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
ADDRLP4 4
ARGP4
ADDRGP4 s_main+4236
ARGP4
ADDRLP4 80
ADDRGP4 strcmp
CALLI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
EQI4 $80
ADDRGP4 s_main+920
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 UI_PlayerInfo_SetModel
CALLV
pop
ADDRGP4 s_main+4236
ARGP4
ADDRLP4 4
ARGP4
ADDRGP4 strcpy
CALLP4
pop
ADDRLP4 68+4
CNSTF4 1125515264
ASGNF4
ADDRLP4 84
CNSTF4 0
ASGNF4
ADDRLP4 68
ADDRLP4 84
INDIRF4
ASGNF4
ADDRLP4 68+8
ADDRLP4 84
INDIRF4
ASGNF4
ADDRGP4 s_main+920
ARGP4
ADDRLP4 88
CNSTI4 5
ASGNI4
ADDRLP4 88
INDIRI4
ARGI4
ADDRLP4 88
INDIRI4
ARGI4
ADDRLP4 68
ARGP4
ADDRGP4 vec3_origin
ARGP4
ADDRLP4 92
CNSTI4 0
ASGNI4
ADDRLP4 92
INDIRI4
ARGI4
ADDRLP4 92
INDIRI4
ARGI4
ADDRGP4 UI_PlayerInfo_SetInfo
CALLV
pop
LABELV $80
ADDRLP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
INDIRP4
CNSTI4 12
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 72
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRLP4 0
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
CVIF4 4
ARGF4
ADDRGP4 s_main+920
ARGP4
ADDRGP4 uis+4
INDIRI4
CVIF4 4
CNSTF4 1067450368
DIVF4
CVFI4 4
ARGI4
ADDRGP4 UI_DrawPlayer
CALLV
pop
LABELV $78
endproc MainMenu_DrawPlayer 96 28
proc MainMenu_DrawName 76 20
ADDRLP4 32
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
ADDRLP4 32
INDIRP4
CNSTI4 72
ADDP4
ASGNP4
ADDRLP4 0
INDIRP4
ARGP4
ADDRLP4 48
ADDRGP4 Q_PrintStrlen
CALLI4
ASGNI4
ADDRLP4 36
ADDRLP4 32
INDIRP4
CNSTI4 28
ADDP4
INDIRI4
CNSTI4 8
SUBI4
CNSTI4 6
ADDRLP4 48
INDIRI4
MULI4
CNSTI4 6
ADDI4
SUBI4
ASGNI4
ADDRLP4 24
ADDRLP4 32
INDIRP4
CNSTI4 16
ADDP4
INDIRI4
ASGNI4
ADDRLP4 32
INDIRP4
CNSTI4 36
ADDP4
INDIRP4
INDIRI4
ADDRLP4 32
INDIRP4
CNSTI4 40
ADDP4
INDIRI4
NEI4 $92
ADDRLP4 40
CNSTI4 1
ASGNI4
ADDRGP4 $93
JUMPV
LABELV $92
ADDRLP4 40
CNSTI4 0
ASGNI4
LABELV $93
ADDRLP4 20
ADDRLP4 40
INDIRI4
ASGNI4
ADDRLP4 28
CNSTI4 2064
ASGNI4
ADDRLP4 12
ADDRGP4 text_color_normal
ASGNP4
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $94
ADDRLP4 28
ADDRLP4 28
INDIRI4
CNSTI4 16384
BORI4
ASGNI4
ADDRLP4 12
ADDRGP4 text_color_highlight
ASGNP4
LABELV $94
ADDRLP4 24
ADDRLP4 24
INDIRI4
CNSTI4 27
ADDI4
ASGNI4
ADDRLP4 12
ADDRGP4 g_color_table+112
ASGNP4
ADDRLP4 8
ADDRLP4 36
INDIRI4
ASGNI4
ADDRGP4 $98
JUMPV
LABELV $97
ADDRLP4 56
CNSTI4 0
ASGNI4
ADDRLP4 20
INDIRI4
ADDRLP4 56
INDIRI4
NEI4 $100
ADDRLP4 0
INDIRP4
CVPU4 4
CNSTU4 0
EQU4 $100
ADDRLP4 0
INDIRP4
INDIRI1
CVII4 1
CNSTI4 94
NEI4 $100
ADDRLP4 64
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 64
INDIRI4
ADDRLP4 56
INDIRI4
EQI4 $100
ADDRLP4 64
INDIRI4
CNSTI4 65
LTI4 $103
ADDRLP4 64
INDIRI4
CNSTI4 90
LEI4 $102
LABELV $103
ADDRLP4 68
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 97
LTI4 $104
ADDRLP4 68
INDIRI4
CNSTI4 122
LEI4 $102
LABELV $104
ADDRLP4 72
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 48
LTI4 $100
ADDRLP4 72
INDIRI4
CNSTI4 57
GTI4 $100
LABELV $102
ADDRLP4 16
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
INDIRI1
CVII4 1
CNSTI4 48
SUBI4
CNSTI4 7
BANDI4
ASGNI4
ADDRLP4 16
INDIRI4
CNSTI4 0
NEI4 $105
ADDRLP4 16
CNSTI4 7
ASGNI4
LABELV $105
ADDRLP4 12
ADDRLP4 16
INDIRI4
CNSTI4 4
LSHI4
ADDRGP4 g_color_table
ADDP4
ASGNP4
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 2
ADDP4
ASGNP4
ADDRGP4 $98
JUMPV
LABELV $100
ADDRLP4 8
INDIRI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 4
INDIRI1
CVII4 1
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRLP4 12
INDIRP4
ARGP4
ADDRGP4 UI_DrawChar
CALLV
pop
ADDRLP4 0
ADDRLP4 0
INDIRP4
CNSTI4 1
ADDP4
ASGNP4
ADDRLP4 8
ADDRLP4 8
INDIRI4
CNSTI4 6
ADDI4
ASGNI4
LABELV $98
ADDRLP4 56
ADDRLP4 0
INDIRP4
INDIRI1
ASGNI1
ADDRLP4 4
ADDRLP4 56
INDIRI1
ASGNI1
ADDRLP4 56
INDIRI1
CVII4 1
CNSTI4 0
NEI4 $97
ADDRLP4 20
INDIRI4
CNSTI4 0
EQI4 $107
ADDRLP4 60
ADDRGP4 trap_Key_GetOverstrikeMode
CALLI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 0
EQI4 $109
ADDRLP4 4
CNSTI1 11
ASGNI1
ADDRGP4 $110
JUMPV
LABELV $109
ADDRLP4 4
CNSTI1 10
ASGNI1
LABELV $110
ADDRLP4 36
INDIRI4
CNSTI4 6
ADDRLP4 32
INDIRP4
CNSTI4 60
ADDP4
INDIRI4
MULI4
ADDI4
ARGI4
ADDRLP4 24
INDIRI4
ARGI4
ADDRLP4 4
INDIRI1
CVII4 1
ARGI4
ADDRLP4 28
INDIRI4
ARGI4
ADDRGP4 color_white
ARGP4
ADDRGP4 UI_DrawChar
CALLV
pop
LABELV $107
LABELV $90
endproc MainMenu_DrawName 76 20
proc MainMenu_ExitAction 0 0
ADDRFP4 0
INDIRI4
CNSTI4 0
NEI4 $112
ADDRGP4 $111
JUMPV
LABELV $112
ADDRGP4 UI_PopMenu
CALLV
pop
ADDRGP4 UI_CreditMenu
CALLV
pop
LABELV $111
endproc MainMenu_ExitAction 0 0
export Main_MenuEvent
proc Main_MenuEvent 8 12
ADDRFP4 4
INDIRI4
CNSTI4 3
EQI4 $115
ADDRGP4 $114
JUMPV
LABELV $115
ADDRLP4 0
ADDRFP4 0
INDIRP4
CNSTI4 8
ADDP4
INDIRI4
ASGNI4
ADDRLP4 0
INDIRI4
CNSTI4 11
LTI4 $117
ADDRLP4 0
INDIRI4
CNSTI4 18
GTI4 $117
ADDRLP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 $125-44
ADDP4
INDIRP4
JUMPV
lit
align 4
LABELV $125
address $120
address $121
address $117
address $117
address $117
address $117
address $122
address $124
code
LABELV $120
ADDRGP4 MainMenu_Save
CALLV
pop
ADDRGP4 UI_ArenaServersMenu
CALLV
pop
ADDRGP4 $118
JUMPV
LABELV $121
ADDRGP4 MainMenu_Save
CALLV
pop
ADDRGP4 UI_SystemSettingsMenu
CALLV
pop
ADDRGP4 $118
JUMPV
LABELV $122
ADDRGP4 MainMenu_Save
CALLV
pop
ADDRGP4 $123
ARGP4
CNSTP4 0
ARGP4
ADDRGP4 MainMenu_ExitAction
ARGP4
ADDRGP4 UI_ConfirmMenu
CALLV
pop
ADDRGP4 $118
JUMPV
LABELV $124
ADDRGP4 MainMenu_Save
CALLV
pop
ADDRGP4 UI_PlayerModelMenu
CALLV
pop
LABELV $117
LABELV $118
LABELV $114
endproc Main_MenuEvent 8 12
export MainMenu_Cache
proc MainMenu_Cache 0 0
LABELV $127
endproc MainMenu_Cache 0 0
export MainMenu_Save
proc MainMenu_Save 0 8
ADDRGP4 $129
ARGP4
ADDRGP4 s_main+432+60+12
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
LABELV $128
endproc MainMenu_Save 0 8
export ErrorMessage_Key
proc ErrorMessage_Key 0 8
ADDRGP4 $134
ARGP4
ADDRGP4 $135
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
ADDRGP4 UI_MainMenu
CALLV
pop
ADDRGP4 menu_null_sound
INDIRI4
RETI4
LABELV $133
endproc ErrorMessage_Key 0 8
proc Main_MenuDraw 0 20
ADDRGP4 uis+20
INDIRI4
CNSTI4 3
EQI4 $137
LABELV $137
ADDRGP4 uis+20
CNSTI4 3
ASGNI4
ADDRGP4 uis+24
CNSTI4 0
ASGNI4
ADDRGP4 uis+32
CNSTI4 0
ASGNI4
CNSTF4 1139277824
ARGF4
CNSTF4 1136852992
ARGF4
CNSTF4 1125449728
ARGF4
CNSTF4 1111752704
ARGF4
ADDRGP4 uis+11428
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
CNSTF4 1139605504
ARGF4
CNSTF4 1138163712
ARGF4
CNSTF4 1124335616
ARGF4
CNSTF4 1101529088
ARGF4
ADDRGP4 uis+11424
INDIRI4
ARGI4
ADDRGP4 UI_DrawHandlePic
CALLV
pop
ADDRGP4 s_main
ARGP4
ADDRGP4 Menu_Draw
CALLV
pop
LABELV $136
endproc Main_MenuDraw 0 20
export UI_MainMenu
proc UI_MainMenu 20 12
ADDRLP4 4
CNSTI4 0
ASGNI4
ADDRLP4 0
CNSTI4 67584
ASGNI4
ADDRGP4 trap_S_StopBackgroundTrack
CALLI4
pop
ADDRLP4 8
ADDRGP4 $146
ASGNP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRLP4 8
INDIRP4
ARGP4
ADDRGP4 trap_S_StartBackgroundTrack
CALLI4
pop
ADDRGP4 $147
ARGP4
ADDRGP4 $148
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
ADDRGP4 uis+8
CNSTI4 320
ASGNI4
ADDRGP4 uis+12
CNSTI4 240
ASGNI4
ADDRGP4 $151
ARGP4
ADDRGP4 $152
ARGP4
ADDRGP4 trap_Cvar_Set
CALLV
pop
ADDRGP4 s_main
ARGP4
CNSTI4 0
ARGI4
CNSTI4 4300
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 s_errorMessage
ARGP4
CNSTI4 0
ARGI4
CNSTI4 4384
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 MainMenu_Cache
CALLV
pop
ADDRGP4 $134
ARGP4
ADDRGP4 s_errorMessage+288
ARGP4
CNSTI4 4096
ARGI4
ADDRGP4 trap_Cvar_VariableStringBuffer
CALLV
pop
ADDRGP4 s_errorMessage+288
ARGP4
ADDRLP4 12
ADDRGP4 strlen
CALLI4
ASGNI4
ADDRLP4 12
INDIRI4
CNSTI4 0
EQI4 $155
ADDRGP4 s_errorMessage+268
ADDRGP4 Main_MenuDraw
ASGNP4
ADDRGP4 s_errorMessage+272
ADDRGP4 ErrorMessage_Key
ASGNP4
ADDRGP4 s_errorMessage+280
CNSTI4 1
ASGNI4
ADDRGP4 s_errorMessage+276
CNSTI4 1
ASGNI4
ADDRGP4 s_errorMessage+284
CNSTI4 1
ASGNI4
CNSTI4 2
ARGI4
ADDRGP4 trap_Key_SetCatcher
CALLV
pop
ADDRGP4 uis+16
CNSTI4 0
ASGNI4
ADDRGP4 s_errorMessage
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
ADDRGP4 $145
JUMPV
LABELV $155
ADDRGP4 s_main+268
ADDRGP4 Main_MenuDraw
ASGNP4
ADDRGP4 s_main+280
CNSTI4 1
ASGNI4
ADDRGP4 s_main+276
CNSTI4 1
ASGNI4
ADDRGP4 s_main+284
CNSTI4 1
ASGNI4
ADDRGP4 s_main+288
CNSTI4 9
ASGNI4
ADDRGP4 s_main+288+44
CNSTU4 260
ASGNU4
ADDRGP4 s_main+288+12
ADDRGP4 multiXpos
INDIRI4
ASGNI4
ADDRGP4 s_main+288+16
ADDRGP4 multiYpos
INDIRI4
ASGNI4
ADDRGP4 s_main+288+8
CNSTI4 11
ASGNI4
ADDRGP4 s_main+288+48
ADDRGP4 Main_MenuEvent
ASGNP4
ADDRGP4 s_main+288+60
ADDRGP4 $181
ASGNP4
ADDRGP4 s_main+288+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_main+288+64
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_main+360
CNSTI4 9
ASGNI4
ADDRGP4 s_main+360+44
CNSTU4 260
ASGNU4
ADDRGP4 s_main+360+12
ADDRGP4 setupXpos
INDIRI4
ASGNI4
ADDRGP4 s_main+360+16
ADDRGP4 setupYpos
INDIRI4
ASGNI4
ADDRGP4 s_main+360+8
CNSTI4 12
ASGNI4
ADDRGP4 s_main+360+48
ADDRGP4 Main_MenuEvent
ASGNP4
ADDRGP4 s_main+360+60
ADDRGP4 $199
ASGNP4
ADDRGP4 s_main+360+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_main+360+64
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_main+764
CNSTI4 9
ASGNI4
ADDRGP4 s_main+764+44
CNSTU4 260
ASGNU4
ADDRGP4 s_main+764+12
ADDRGP4 exitXpos
INDIRI4
ASGNI4
ADDRGP4 s_main+764+16
ADDRGP4 exitYpos
INDIRI4
ASGNI4
ADDRGP4 s_main+764+8
CNSTI4 17
ASGNI4
ADDRGP4 s_main+764+48
ADDRGP4 Main_MenuEvent
ASGNP4
ADDRGP4 s_main+764+60
ADDRGP4 $217
ASGNP4
ADDRGP4 s_main+764+68
ADDRGP4 color_white
ASGNP4
ADDRGP4 s_main+764+64
ADDRLP4 0
INDIRI4
ASGNI4
ADDRGP4 s_main+432
CNSTI4 4
ASGNI4
ADDRGP4 s_main+432+44
CNSTU4 32768
ASGNU4
ADDRGP4 s_main+432+56
ADDRGP4 MainMenu_DrawName
ASGNP4
ADDRGP4 s_main+432+60+8
CNSTI4 14
ASGNI4
ADDRGP4 s_main+432+60+268
CNSTI4 14
ASGNI4
ADDRGP4 s_main+432+12
CNSTI4 454
ASGNI4
ADDRGP4 s_main+432+16
CNSTI4 405
ASGNI4
ADDRGP4 s_main+432+20
CNSTI4 474
ASGNI4
ADDRGP4 s_main+432+24
CNSTI4 430
ASGNI4
ADDRGP4 s_main+432+28
CNSTI4 610
ASGNI4
ADDRGP4 s_main+432+32
CNSTI4 455
ASGNI4
ADDRGP4 s_main+836
CNSTI4 6
ASGNI4
ADDRGP4 s_main+836+44
CNSTU4 1048576
ASGNU4
ADDRGP4 s_main+836+56
ADDRGP4 MainMenu_DrawPlayer
ASGNP4
ADDRGP4 s_main+836+8
CNSTI4 18
ASGNI4
ADDRGP4 s_main+836+48
ADDRGP4 Main_MenuEvent
ASGNP4
ADDRGP4 s_main+836+12
CNSTI4 380
ASGNI4
ADDRGP4 s_main+836+16
CNSTI4 -170
ASGNI4
ADDRGP4 s_main+836+72
CNSTI4 320
ASGNI4
ADDRGP4 s_main+836+76
CNSTI4 810
ASGNI4
ADDRGP4 s_main
ARGP4
ADDRGP4 s_main+288
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_main
ARGP4
ADDRGP4 s_main+360
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_main
ARGP4
ADDRGP4 s_main+764
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 s_main
ARGP4
ADDRGP4 s_main+432
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
ADDRGP4 $129
ARGP4
ADDRLP4 16
ADDRGP4 UI_Cvar_VariableString
CALLP4
ASGNP4
ADDRGP4 s_main+432+60+12
ARGP4
ADDRLP4 16
INDIRP4
ARGP4
CNSTI4 256
ARGI4
ADDRGP4 Q_strncpyz
CALLV
pop
ADDRGP4 s_main
ARGP4
ADDRGP4 s_main+836
ARGP4
ADDRGP4 Menu_AddItem
CALLV
pop
CNSTI4 2
ARGI4
ADDRGP4 trap_Key_SetCatcher
CALLV
pop
ADDRGP4 uis+16
CNSTI4 0
ASGNI4
ADDRGP4 s_main
ARGP4
ADDRGP4 UI_PushMenu
CALLV
pop
LABELV $145
endproc UI_MainMenu 20 12
import trap_S_StartBackgroundTrack
import trap_S_StopBackgroundTrack
bss
align 4
LABELV s_errorMessage
skip 4384
align 4
LABELV s_main
skip 4300
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
LABELV $217
byte 1 69
byte 1 88
byte 1 73
byte 1 84
byte 1 0
align 1
LABELV $199
byte 1 83
byte 1 69
byte 1 84
byte 1 85
byte 1 80
byte 1 0
align 1
LABELV $181
byte 1 80
byte 1 76
byte 1 65
byte 1 89
byte 1 0
align 1
LABELV $152
byte 1 48
byte 1 0
align 1
LABELV $151
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
LABELV $148
byte 1 49
byte 1 0
align 1
LABELV $147
byte 1 115
byte 1 118
byte 1 95
byte 1 107
byte 1 105
byte 1 108
byte 1 108
byte 1 115
byte 1 101
byte 1 114
byte 1 118
byte 1 101
byte 1 114
byte 1 0
align 1
LABELV $146
byte 1 109
byte 1 117
byte 1 115
byte 1 105
byte 1 99
byte 1 47
byte 1 109
byte 1 101
byte 1 110
byte 1 117
byte 1 46
byte 1 111
byte 1 103
byte 1 103
byte 1 0
align 1
LABELV $135
byte 1 0
align 1
LABELV $134
byte 1 99
byte 1 111
byte 1 109
byte 1 95
byte 1 101
byte 1 114
byte 1 114
byte 1 111
byte 1 114
byte 1 77
byte 1 101
byte 1 115
byte 1 115
byte 1 97
byte 1 103
byte 1 101
byte 1 0
align 1
LABELV $129
byte 1 110
byte 1 97
byte 1 109
byte 1 101
byte 1 0
align 1
LABELV $123
byte 1 81
byte 1 117
byte 1 105
byte 1 116
byte 1 63
byte 1 0
align 1
LABELV $79
byte 1 109
byte 1 111
byte 1 100
byte 1 101
byte 1 108
byte 1 0
