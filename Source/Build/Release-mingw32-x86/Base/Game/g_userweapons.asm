export G_FindUserWeaponMask
code
proc G_FindUserWeaponMask 0 0
ADDRFP4 0
INDIRI4
CNSTI4 2
LSHI4
ADDRGP4 weaponPhysicsMasks
ADDP4
RETP4
LABELV $63
endproc G_FindUserWeaponMask 0 0
export G_FindUserWeaponData
proc G_FindUserWeaponData 4 0
ADDRLP4 0
CNSTI4 328
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRI4
SUBI4
CNSTI4 7872
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 weaponPhysicsDatabase
ADDP4
ADDP4
RETP4
LABELV $64
endproc G_FindUserWeaponData 4 0
export G_FindUserWeaponSpawnData
proc G_FindUserWeaponSpawnData 8 0
ADDRLP4 0
CNSTI4 328
ASGNI4
ADDRLP4 4
CNSTI4 1968
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRI4
SUBI4
ADDRLP4 4
INDIRI4
ADDI4
ADDRLP4 4
INDIRI4
ADDI4
CNSTI4 7872
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 weaponPhysicsDatabase
ADDP4
ADDP4
RETP4
LABELV $65
endproc G_FindUserWeaponSpawnData 8 0
export G_FindUserAltWeaponData
proc G_FindUserAltWeaponData 4 0
ADDRLP4 0
CNSTI4 328
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRI4
SUBI4
CNSTI4 1968
ADDI4
CNSTI4 7872
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 weaponPhysicsDatabase
ADDP4
ADDP4
RETP4
LABELV $66
endproc G_FindUserAltWeaponData 4 0
export G_FindUserAltWeaponSpawnData
proc G_FindUserAltWeaponSpawnData 8 0
ADDRLP4 0
CNSTI4 328
ASGNI4
ADDRLP4 4
CNSTI4 1968
ASGNI4
ADDRLP4 0
INDIRI4
ADDRFP4 4
INDIRI4
MULI4
ADDRLP4 0
INDIRI4
SUBI4
ADDRLP4 4
INDIRI4
ADDI4
ADDRLP4 4
INDIRI4
ADDI4
ADDRLP4 4
INDIRI4
ADDI4
CNSTI4 7872
ADDRFP4 0
INDIRI4
MULI4
ADDRGP4 weaponPhysicsDatabase
ADDP4
ADDP4
RETP4
LABELV $67
endproc G_FindUserAltWeaponSpawnData 8 0
export G_CheckSkills
proc G_CheckSkills 100 8
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRLP4 0
CNSTI4 1
ASGNI4
ADDRLP4 4
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 4
INDIRP4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 -2
BANDI4
ASGNI4
ADDRLP4 8
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 8
INDIRP4
ADDRLP4 8
INDIRP4
INDIRI4
CNSTI4 -3
BANDI4
ASGNI4
ADDRLP4 12
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 12
INDIRP4
ADDRLP4 12
INDIRP4
INDIRI4
CNSTI4 -5
BANDI4
ASGNI4
ADDRLP4 16
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 16
INDIRP4
ADDRLP4 16
INDIRP4
INDIRI4
CNSTI4 -9
BANDI4
ASGNI4
ADDRLP4 20
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 20
INDIRP4
ADDRLP4 20
INDIRP4
INDIRI4
CNSTI4 -17
BANDI4
ASGNI4
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 -33
BANDI4
ASGNI4
ADDRGP4 $70
JUMPV
LABELV $69
ADDRLP4 32
CNSTI4 1
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 136
ADDP4
INDIRI4
ARGI4
ADDRLP4 0
INDIRI4
ARGI4
ADDRLP4 36
ADDRGP4 G_FindUserWeaponData
CALLP4
ASGNP4
ADDRLP4 28
ADDRLP4 36
INDIRP4
ASGNP4
ADDRLP4 40
ADDRLP4 28
INDIRP4
CNSTI4 76
ADDP4
INDIRI4
ASGNI4
ADDRLP4 40
INDIRI4
CNSTI4 0
EQI4 $72
ADDRFP4 0
INDIRP4
CNSTI4 564
ADDP4
INDIRI4
ADDRLP4 40
INDIRI4
GEI4 $72
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $72
ADDRLP4 44
ADDRLP4 28
INDIRP4
CNSTI4 80
ADDP4
INDIRI4
ASGNI4
ADDRLP4 44
INDIRI4
CNSTI4 0
EQI4 $74
ADDRFP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ADDRLP4 44
INDIRI4
GEI4 $74
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $74
ADDRLP4 48
ADDRLP4 28
INDIRP4
CNSTI4 84
ADDP4
INDIRI4
ASGNI4
ADDRLP4 48
INDIRI4
CNSTI4 0
EQI4 $76
ADDRFP4 0
INDIRP4
CNSTI4 548
ADDP4
INDIRI4
ADDRLP4 48
INDIRI4
LEI4 $76
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $76
ADDRLP4 52
ADDRLP4 28
INDIRP4
CNSTI4 96
ADDP4
INDIRI4
ASGNI4
ADDRLP4 52
INDIRI4
CNSTI4 0
EQI4 $78
ADDRFP4 0
INDIRP4
CNSTI4 552
ADDP4
INDIRI4
ADDRLP4 52
INDIRI4
GEI4 $78
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $78
ADDRLP4 56
ADDRLP4 28
INDIRP4
CNSTI4 100
ADDP4
INDIRI4
ASGNI4
ADDRLP4 56
INDIRI4
CNSTI4 0
EQI4 $80
ADDRFP4 0
INDIRP4
CNSTI4 552
ADDP4
INDIRI4
ADDRLP4 56
INDIRI4
LEI4 $80
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $80
ADDRLP4 60
ADDRLP4 28
INDIRP4
CNSTI4 88
ADDP4
INDIRI4
ASGNI4
ADDRLP4 60
INDIRI4
CNSTI4 0
EQI4 $82
ADDRFP4 0
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
ADDRLP4 60
INDIRI4
GEI4 $82
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $82
ADDRLP4 64
ADDRLP4 28
INDIRP4
CNSTI4 92
ADDP4
INDIRI4
ASGNI4
ADDRLP4 64
INDIRI4
CNSTI4 0
EQI4 $84
ADDRFP4 0
INDIRP4
CNSTI4 556
ADDP4
INDIRI4
ADDRLP4 64
INDIRI4
LEI4 $84
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $84
ADDRLP4 68
ADDRLP4 28
INDIRP4
CNSTI4 104
ADDP4
INDIRI4
ASGNI4
ADDRLP4 68
INDIRI4
CNSTI4 0
EQI4 $86
ADDRFP4 0
INDIRP4
CNSTI4 608
ADDP4
INDIRI4
ADDRLP4 68
INDIRI4
CNSTI4 1
SUBI4
GEI4 $86
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $86
ADDRLP4 72
ADDRLP4 28
INDIRP4
CNSTI4 108
ADDP4
INDIRI4
ASGNI4
ADDRLP4 72
INDIRI4
CNSTI4 0
EQI4 $88
ADDRFP4 0
INDIRP4
CNSTI4 608
ADDP4
INDIRI4
ADDRLP4 72
INDIRI4
CNSTI4 1
SUBI4
LEI4 $88
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $88
ADDRLP4 76
ADDRLP4 28
INDIRP4
CNSTI4 112
ADDP4
INDIRI4
ASGNI4
ADDRLP4 76
INDIRI4
CNSTI4 0
EQI4 $90
ADDRFP4 0
INDIRP4
CNSTI4 612
ADDP4
INDIRI4
ADDRLP4 76
INDIRI4
CNSTI4 1
SUBI4
GEI4 $90
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $90
ADDRLP4 80
ADDRLP4 28
INDIRP4
CNSTI4 116
ADDP4
INDIRI4
ASGNI4
ADDRLP4 80
INDIRI4
CNSTI4 0
EQI4 $92
ADDRFP4 0
INDIRP4
CNSTI4 612
ADDP4
INDIRI4
ADDRLP4 80
INDIRI4
CNSTI4 1
SUBI4
LEI4 $92
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $92
ADDRLP4 84
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRP4
CNSTI4 120
ADDP4
INDIRI4
ADDRLP4 84
INDIRI4
EQI4 $94
ADDRFP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 16777216
BANDI4
ADDRLP4 84
INDIRI4
NEI4 $94
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $94
ADDRLP4 88
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRP4
CNSTI4 124
ADDP4
INDIRI4
ADDRLP4 88
INDIRI4
EQI4 $96
ADDRFP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 128
BANDI4
ADDRLP4 88
INDIRI4
NEI4 $96
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $96
ADDRLP4 92
CNSTI4 0
ASGNI4
ADDRLP4 28
INDIRP4
CNSTI4 128
ADDP4
INDIRI4
ADDRLP4 92
INDIRI4
EQI4 $98
ADDRFP4 0
INDIRP4
CNSTI4 280
ADDP4
INDIRI4
CNSTI4 67108864
BANDI4
ADDRLP4 92
INDIRI4
NEI4 $98
ADDRLP4 32
CNSTI4 0
ASGNI4
LABELV $98
ADDRLP4 32
INDIRI4
CNSTI4 0
EQI4 $100
ADDRLP4 0
INDIRI4
CNSTI4 1
NEI4 $102
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 1
BORI4
ASGNI4
LABELV $102
ADDRLP4 0
INDIRI4
CNSTI4 2
NEI4 $104
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 2
BORI4
ASGNI4
LABELV $104
ADDRLP4 0
INDIRI4
CNSTI4 3
NEI4 $106
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 4
BORI4
ASGNI4
LABELV $106
ADDRLP4 0
INDIRI4
CNSTI4 4
NEI4 $108
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 8
BORI4
ASGNI4
LABELV $108
ADDRLP4 0
INDIRI4
CNSTI4 5
NEI4 $110
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 16
BORI4
ASGNI4
LABELV $110
ADDRLP4 0
INDIRI4
CNSTI4 6
NEI4 $112
ADDRLP4 96
ADDRFP4 0
INDIRP4
CNSTI4 816
ADDP4
ASGNP4
ADDRLP4 96
INDIRP4
ADDRLP4 96
INDIRP4
INDIRI4
CNSTI4 32
BORI4
ASGNI4
LABELV $112
LABELV $100
ADDRLP4 0
ADDRLP4 0
INDIRI4
CNSTI4 1
ADDI4
ASGNI4
LABELV $70
ADDRLP4 0
INDIRI4
CNSTI4 7
LTI4 $69
LABELV $68
endproc G_CheckSkills 100 8
export G_LinkUserWeaponData
proc G_LinkUserWeaponData 48 12
ADDRFP4 0
ADDRFP4 0
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
CNSTI4 0
NEI4 $115
ADDRFP4 0
INDIRP4
CNSTI4 964
ADDP4
ARGP4
CNSTI4 0
ARGI4
CNSTI4 128
ARGI4
ADDRGP4 memset
CALLP4
pop
ADDRGP4 $114
JUMPV
LABELV $115
ADDRFP4 0
INDIRP4
CNSTI4 136
ADDP4
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 12
ADDRGP4 G_FindUserWeaponData
CALLP4
ASGNP4
ADDRLP4 0
ADDRLP4 12
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 1028
ADDP4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 964
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 132
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 976
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 136
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 968
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 972
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 980
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 984
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 156
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 988
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 988
ADDP4
ADDRLP4 0
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 328
ADDP4
INDIRI4
ADDRLP4 0
INDIRP4
CNSTI4 152
ADDP4
INDIRI4
LTI4 $117
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
EQI4 $117
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
ADDRGP4 $118
JUMPV
LABELV $117
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 -65
BANDI4
ASGNI4
LABELV $118
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 3
NEI4 $119
ADDRLP4 24
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ASGNP4
ADDRLP4 24
INDIRP4
ADDRLP4 24
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRI4
CNSTI4 -33
BANDI4
ASGNI4
LABELV $119
ADDRLP4 0
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 2
EQI4 $123
ADDRLP4 0
INDIRP4
INDIRI4
CNSTI4 1
NEI4 $121
LABELV $123
ADDRLP4 28
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
ASGNP4
ADDRLP4 28
INDIRP4
ADDRLP4 28
INDIRP4
INDIRI4
CNSTI4 256
BORI4
ASGNI4
LABELV $121
ADDRFP4 0
INDIRP4
CNSTI4 992
ADDP4
INDIRI4
CNSTI4 8
BANDI4
CNSTI4 0
EQI4 $124
ADDRFP4 0
INDIRP4
CNSTI4 136
ADDP4
INDIRI4
ARGI4
ADDRFP4 0
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ARGI4
ADDRLP4 32
ADDRGP4 G_FindUserAltWeaponData
CALLP4
ASGNP4
ADDRLP4 4
ADDRLP4 32
INDIRP4
ASGNP4
ADDRFP4 0
INDIRP4
CNSTI4 996
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 132
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1008
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 136
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1000
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 140
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1004
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 144
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1012
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 148
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1016
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 156
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1020
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 4
ADDP4
INDIRI4
ASGNI4
ADDRFP4 0
INDIRP4
CNSTI4 1020
ADDP4
ADDRLP4 4
INDIRP4
CNSTI4 36
ADDP4
INDIRI4
ASGNI4
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 3
NEI4 $126
ADDRLP4 36
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ASGNP4
ADDRLP4 36
INDIRP4
ADDRLP4 36
INDIRP4
INDIRI4
CNSTI4 128
BORI4
ASGNI4
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 -33
BANDI4
ASGNI4
LABELV $126
ADDRLP4 4
INDIRP4
CNSTI4 24
ADDP4
INDIRI4
CNSTI4 2
EQI4 $130
ADDRLP4 4
INDIRP4
INDIRI4
CNSTI4 1
NEI4 $128
LABELV $130
ADDRLP4 40
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ASGNP4
ADDRLP4 40
INDIRP4
ADDRLP4 40
INDIRP4
INDIRI4
CNSTI4 256
BORI4
ASGNI4
LABELV $128
ADDRFP4 0
INDIRP4
CNSTI4 332
ADDP4
INDIRI4
ADDRLP4 4
INDIRP4
CNSTI4 152
ADDP4
INDIRI4
LTI4 $131
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
INDIRI4
CNSTI4 32
BANDI4
CNSTI4 0
EQI4 $131
ADDRLP4 44
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRI4
CNSTI4 64
BORI4
ASGNI4
ADDRGP4 $132
JUMPV
LABELV $131
ADDRLP4 44
ADDRFP4 0
INDIRP4
CNSTI4 1024
ADDP4
ASGNP4
ADDRLP4 44
INDIRP4
ADDRLP4 44
INDIRP4
INDIRI4
CNSTI4 -65
BANDI4
ASGNI4
LABELV $132
LABELV $124
LABELV $114
endproc G_LinkUserWeaponData 48 12
bss
align 4
LABELV weaponPhysicsDatabase
skip 503808
align 4
LABELV weaponPhysicsMasks
skip 256
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
