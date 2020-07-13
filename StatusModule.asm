Custom Action Names List [Eon]
HOOK @ $8077f474
{
    
.macro loadFileLoc(<reg>) 
{
	lis <reg>, 0x8054
	ori <reg>, <reg>, 0x8400 
}
.alias ActionNamesListOffset = 0x900
    %loadFileLoc(3)
    mulli r4, r4, 0x4
    addi r4, r4, ActionNamesListOffset
    lwzx r4, r3, r4
    cmpwi r4, 0
    beq unknown
    add r3, r3, r4
    b %end%

unknown:
    addi r3, r31, 0
}

renderDebug/soStatusModuleImpl
HOOK @ $80541Fbc
{
.alias mainIndex = 2

#soMotionModule
    #gets subaction id
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x5C(r12)
    mtctr r12
    bctrl #returns subaction id in r3
    #gets subaction name
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x58(r12)
    mtctr r12
    bctrl #returns pointer to subaction name in r3
    #get Frame
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x38(r12)
    mtctr r12
    bctrl #returns frame number in f1
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x20(r12)
    mtctr r12
    bctrl #returns fsm in f1
    lwz r3, 0xD8(r3)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x44(r12)
    mtctr r12
    bctrl #returns animation length in f1
    #soStatusModule
    #get current action ID
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x48(r12)
    mtctr r12
    bctrl
    #get current action name
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x80(r12)
    li r3, 0xasdf #current action ID
    mtctr r12
    bctrl
    #get previous action name
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x88(r12)
    mtctr r12
    bctrl

#sprintf/printf.o
    blr
}