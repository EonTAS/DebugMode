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

#80B31FA0 = stOperatorInfo # might use this to render char info, is pointer list of stOperatorInfo = can use it to access each active char proper.
#try using loop found within setSlow (80817C48), iterates through every fighter in the match. maybe place this function call within stage module so it runs only once?
#still need text output  

Write Fighter Data to screen
#getData/soStatusModuleImpl (mainIndex)
.macro callfunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $80541Fbc
{
.alias mainIndex = 31
.alias output = 30
#dataPointers
.alias actionID = 0x00
.alias previousActionID = 0x04
.alias subactionID = 0x08
.alias actionNamePointer = 0x0C
.alias subactionNamePointer = 0x10
.alias currentFrame = 0x14
.alias totalFrames = 0x18
.alias currentFSM = 0x1C
.alias previousActionID = 0x20

.alias outputSize = 0x24

	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)

	stw r31, 0x10(r1)
	stw r30, 0x14(r1)

    mr mainIndex, r3
    mr output, r4

#soMotionModule
    #gets subaction id
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x5C(r12)
    mtctr r12
    bctrl #returns subaction id in r3
    stw r3, subactionID(output)
    #gets subaction name
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x58(r12)
    mtctr r12
    bctrl #returns pointer to subaction name in r3
    stw r3, subactionNamePointer(output)

    #get Frame
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x38(r12)
    mtctr r12
    bctrl #returns frame number in f1
    stfs f1, currentFrame(output)
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x20(r12)
    mtctr r12
    bctrl #returns fsm in f1
    stfs f1, currentFSM(output)
    lwz r3, 0xD8(r3)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x44(r12)
    mtctr r12
    bctrl #returns animation length in f1
    stfs f1, totalFrames(output)
    #soStatusModule
    #get current action ID
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x48(r12)
    mtctr r12
    bctrl
    stw r3, actionID(output)
    #get current action name
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x80(r12)
    li r3, 0xasdf #current action ID
    mtctr r12
    bctrl
    stw r3, actionNamePointer(output)
    #get previous action id
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x88(r12)
    mtctr r12
    bctrl
    stw r3, previousActionID(output)

    #isEnableTermGroup/[soTransitionModuleImpl]/so_transition_ will allow specific interupt checks, loop over every and output a bitmask?
    #isEnableCancel/[ftCancelModuleImpl] will allow catching an allow interupt? 

    mr r3, r31 #return data object

    lwz r31, 0x10(r1)
    lwz r30, 0x1C(r1)

	lwz r0, 0x24(r1)
	mtlr r0
	addi r1, r1, 0x20
	blr
}

#writeAllFighterData(ftManager a) #ftManager =  lis r3, 0x80b8
#                                               lwz r3, 0x7C28(r3)
#                                 #call this from within stage?

HOOK @ $80541FC0
{
#ints
.alias ftManager = 31
.alias FighterCount = 30
.alias count = 29
.alias fighter = 28



    stwu r1, -0x20(r1)
    mflr r0
    stw r0, 0x24 (r1)
    stmw r28, 0x10(r1)
    lis r3, 0x80b8
    lwz r3, 0x7C28(r3)
    
    mr ftManager, r3

    lwz r3, 0x154(r3)
    lwzu r12, 0x8(r3)
    lwz r12, 0x14(r12)
    mtctr r12
    bctrl	  #getFighterCount

    mr FighterCount, r3
    li count, 0
    b checkContinue

loop:
    lwz r3, 0x0154 (ftManager)
    mr r4, count
    lwzu r12, 0x8(r3)
    lwz r12, 0xC(r12)
    mtctr r12
    bctrl 

    lwz fighter, 0 (r3) #gets entry

Fighters:
    lbz	r0, 0x000F (fighter)
    cmplwi	r0, 6
    bne nextFighter
Entry1:
    lbz	r0, 0x000A (fighter)
    rlwinm	r0, r0, 3, 0, 28
    add	r3, r3, r0
    lwz	r3, 0x0034 (fighter)
    mr r4, count
    li r5, 0
    bl doStuffToEntry

Entry2: #nana
    lbz	r0, 0x000E (fighter)
    rlwinm.	r0, r0, 0, 30, 30
    beq nextFighter
    lwz	r3, 0x003C (fighter)
    mr r4, count
    li r5, 1
    bl	doStuffToEntry

nextFighter:
    addi count, count, 1
checkContinue:
    cmpw count, FighterCount
    blt loop


    lmw r28, 0x10(r1)
    lwz r0, 0x24(r1)
    mtlr r0
    addi r1, r1, 0x20
    blr

doStuffToEntry: #(Entry char, int portNum, Bool nana) #call char.getData(this, dataBlock), format strings, print to screen 
    blr
}
#
#
#
#
#if object not created yet:
#    pointer = __nw/[srHeapType]/sr_common(480, 15) = get memory pointer, might just replace with pointer to data i want if possible #size, heap
#    if pointer != 0 #make sure pointer assigned works
#        msg = __ct/[Message]/ms_message.o(pointer, 10, 15) #pointer something heap
#        if msg != 0
#            message.allocMsgBuf/[Message]/ms_message.o(msg, 1024, 1, 15) #pointer, buffer size, 
#
#on each frame you want to clear the inputs through 
#message.clearMsgBuf/[Message]/ms_message(Message this)
#
#message.setMessageLocation(this, Double x1,Double y1,Double x2,Double y2) #0x80069AF0
#message.setFace(this, int face) #0x8006A550 #pictochat/generic font = 4, victory screen font = 2
#message.setFixedWidth(this, Double width) #0x8006A600 #only get results for -1 or 0, any other result is functionally equivalent 
#message.setColour(this, int Colour) #0x8006A600
#
#message.setScale(this, double xScale, double yScale) #8006A018
#message.setCursorX(this, double CursorX)    #0x80069970
#message.setCursorY(this, double CursorY)    #0x80069A30
#message.printf(this, Char* text, ....) #0x80069D40 crclr 6, 6 for no, cmp 1,1,1 to use float regs  
#
#static Message.std2DView() #0x8006B360 #creates matrix of 
#[1,0,0,0]
#[0,1,0,0]
#[0,0,0,0] and makes GX use it, so good for writing to the screen
#
#message.printMsgBuf(this, int something) #0x8006AB48 #print to screen