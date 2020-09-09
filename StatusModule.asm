Custom Action Names List [Eon]
HOOK @ $8077f474
{
    
.macro loadFileLoc(<reg>) 
{
	lis <reg>, 0x8054
	ori <reg>, <reg>, 0x8400 
}
.alias ActionNamesListOffset = 0x900
    cmpwi r30, 0x116
    bgt unknown
    %loadFileLoc(3)
    mulli r4, r30, 0x4
    addi r4, r4, ActionNamesListOffset
    lwzx r4, r3, r4
    cmpwi r4, 0
    beq unknown
    add r3, r3, r4
    b %end%

unknown:
    addi r3, r31, 0
}

Get End Frame crash fixed [Eon]
HOOK @ $8071f714
{
    lwzu r4, 0x3C(r3)
    cmpwi r4, 0
    bne %end% 
    stwu r1, -0xC(r1)
    lis r0, 0xBF80
    stw r0, 0x8(r1)
    lfs f1, 0x8(r1)
    addi r1, r1, 0xC
    blr
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

.alias outputSize = 0x20

	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)

	stw r31, 0x10(r1)
	stw r30, 0x14(r1)

    lwz mainIndex, 0x60(r3)
    mr output, r4

#soMotionModule
    #gets subaction id
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x8(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x5C(r12)
    mtctr r12
    bctrl #returns subaction id in r3
    cmpwi r3, 0
    bge 0x8
    li r3, 0xFFF
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
    lwz r3, 0xD8(mainIndex)
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
    cmpwi r3, 0
    bge 0x8
    li r3, 0xFFF
    stw r3, actionID(output)
    #get current action name
    mr r4, r3
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    lwz r12, 0x0(r3)
    lwz r12, 0x80(r12)
    mtctr r12
    bctrl
    stw r3, actionNamePointer(output)
    #get previous action id
    lwz r3, 0xD8(mainIndex)
    lwz r3, 0x70(r3)
    li r4, 0
    lwz r12, 0x0(r3)
    lwz r12, 0x88(r12)
    mtctr r12
    bctrl
    cmpwi r3, 0
    bge 0x8
    li r3, 0xFFF
    stw r3, previousActionID(output)

    #isEnableTermGroup/[soTransitionModuleImpl]/so_transition_ will allow specific interupt checks, loop over every and output a bitmask?
    #isEnableCancel/[ftCancelModuleImpl] will allow catching an allow interupt? 

    mr r3, r31 #return data object

    lwz r31, 0x10(r1)
    lwz r30, 0x14(r1)

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
.alias totalCount = 28
.alias fighter = 27

.alias messageObjOffset = 0x87C

.alias initYOffset = 0x890
.alias yoffsetEach = 0x894


    stwu r1, -0x60(r1)
    mflr r0
    stw r0, 0x64(r1)
    stmw r27, 0x40(r1)
    lis r3, 0x80b8
    lwz r3, 0x7C28(r3)
    
    mr ftManager, r3
    lwz r3, 0x154(r3)
    lwzu r12, 0x8(r3)
    lwz r12, 0x14(r12)
    mtctr r12
    bctrl	  #getFighterCount

    mr FighterCount, r3

    lis r3, 0x8054
    ori r3, r3, 0x8400
    lwz r3, messageObjOffset(r3)
    %callfunc(0x8006b674)
    %callfunc(0x80541fcc)


    li count, 0
    li totalCount, 0
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
    mr r6, totalCount
    %callfunc(0x80541FC4) 
    addi totalCount, totalCount, 1
Entry2: #nana
    lbz	r0, 0x000E (fighter)
    rlwinm.	r0, r0, 0, 30, 30
    beq nextFighter
    lwz	r3, 0x003C (fighter)
    mr r4, count
    li r5, 1
    mr r6, totalCount
    %callfunc(0x80541FC4)
    addi totalCount, totalCount, 1

nextFighter:
    addi count, count, 1
checkContinue:
    cmpw count, FighterCount
    blt loop


end:
    lmw r27, 0x40(r1)
    lwz r0, 0x64(r1)
    mtlr r0
    addi r1, r1, 0x60
    blr
}
HOOK @ $80541FC4
{
#(Entry char, int portNum, Bool nana, int totalCount) #call char.getData(this, dataBlock), format strings, print to screen 
.alias char = 31
.alias portNum = 30
.alias nana = 29
.alias charData = 28
.alias data = 27
.alias messageObj = 26

.alias messageObjOffset = 0x87C

.alias portPos = 0x8A0
.alias actionPos = 0x8A4
.alias subactionPos = 0x8A8
.alias framePos = 0x8AC

.alias mainPortString = 0x8B0
.alias nanaPortString = 0x8B4
.alias actionString = 0x8B9
.alias subactionString = 0x8CD
.alias frameString = 0x8DB

.alias initYOffset = 0x890
.alias yoffsetEach = 0x894

#charData offsets 
.alias charData.actionID = 0x00
.alias charData.previousActionID = 0x04
.alias charData.subactionID = 0x08
.alias charData.actionNamePointer = 0x0C
.alias charData.subactionNamePointer = 0x10
.alias charData.currentFrame = 0x14
.alias charData.totalFrames = 0x18
.alias charData.currentFSM = 0x1C
    stwu r1, -0x80(r1)
    mflr r0
    stw r0, 0x84(r1)
    stmw r26, 0x40(r1)
    stfd f31, 0x78(r1)

    mr char, r3
    mr portNum, r4
    mr nana, r5
    addi charData, r1, 0x10
    lis data, 0x8054
    ori data, data, 0x8400
    lwz messageObj, messageObjOffset(data)

    
    mr r3, messageObj
    lfs f1, initYOffset(data)
    lfs f2, yoffsetEach(data)
offsetLoopStart:
    cmpwi r6, 0
    ble offsetLoopEnd
    fadds f1, f1, f2
    subi r6, r6, 1
    b offsetLoopStart
offsetLoopEnd:
    fmr f31, f1
    %callfunc(0x80069A30)

    mr r3, char
    mr r4, charData 
    %callfunc(0x80541FBC)



    mr r3, messageObj
    lfs f1, portPos(data)
    %callfunc(0x80069970) #setCursorX

    cmpwi nana, 1
    bne 0xC
    addi r4, data, nanaPortString #"%db)" 
    b 0x8
    addi r4, data, mainPortString #"%d)"
    mr r3, messageObj
    mr r5, portNum
    crxor 6,6,6
    %callfunc(0x80541fc8) #printf(message, "%db)", portNum)

    mr r3, messageObj
    lfs f1, actionPos(data)
    %callfunc(0x80069970) #setCursorX    
    mr r3, messageObj
    fmr f1, f31
    %callfunc(0x80069A30)


    mr r3, messageObj
    addi r4, data, actionString # "%s (0x%3X)"

    lwz r5, charData.actionNamePointer(charData)
    lwz r6, charData.previousActionID(charData)
    lwz r7, charData.actionID(charData)
    crxor 6,6,6
    %callfunc(0x80541fc8) #printf(message, "%s (0x%3x->0x%3x)", actionName, previousActionID, actionID) and then print to screen

    mr r3, messageObj
    lfs f1, subactionPos(data)
    %callfunc(0x80069970) #setCursorX 
    mr r3, messageObj
    fmr f1, f31
    %callfunc(0x80069A30)


    mr r3, messageObj
    addi r4, data, subactionString # ": %s (0x%03x)"
    lwz r5, charData.subactionNamePointer(charData)
    lwz r6, charData.subactionID(charData)
    crxor 6,6,6
    %callfunc(0x80541fc8) #printf(message, ": %s (0x%03x)", subactionName, subactionID)

    mr r3, messageObj
    lfs f1, framePos(data)
    %callfunc(0x80069970) #setCursorX 
    mr r3, messageObj
    fmr f1, f31
    %callfunc(0x80069A30)

    mr r3, messageObj
    addi r4, data, frameString # ": %.2f/%.2f (%.2f"
    lfs f1, charData.currentFrame(charData)
    lfs f2, charData.totalFrames(charData)
    lfs f3, charData.currentFSM(charData)
    creqv 6,6,6
    %callfunc(0x80541fc8) #printf(": %.2f/%.2f (%.2f", currentFrame, totalFrames, currentFSM);
    
    lfd f31, 0x78(r1)
    lmw r26, 0x40(r1)
    lwz r0, 0x84(r1)
    mtlr r0
    addi r1, r1, 0x80

    blr
}

printftoscreen
.macro callfunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $80541fc8
{
.alias messageObjOffset = 0x87C
    stwu r1, -0x10(r1)
    mflr r0
    stw r0, 0x14(r1)
    #printf(args*)
    %callfunc(0x80069D40)


    #std2DView
    %callfunc(0x8006b360)
    
    li r3, 0
    %callfunc(0x801f4748);
    li r3, 1
    li r4, 3
    li r5, 1
    %callfunc(0x801F4774) #GXSetZmode(1,4,1)
    li r3, 4
    li r4, 0
    li r5, 0
    li r6, 4
    li r7, 0
    %callfunc(0x801f3fd8) #GXSetAlphaCompare(4,0,0,4,0)


    #drawbackgroundSquare
    #r3 = 4 positions, x1,y1, x2, y2, x3,y3, x4,y4
    #r4 = colour
    #r5 = Zmode
    #f1 = z (probably originally line width but fuck them, this is now a full shape with no outline)
    #%callfunc(0x800437dc)

    lis r3, 0x8054
    ori r3, r3, 0x8400
    lwz r3, messageObjOffset(r3)
    li r4, 9
    %callfunc(0x8006AB48)    
    lis r3, 0x8054
    ori r3, r3, 0x8400
    lwz r3, messageObjOffset(r3)
    %callfunc(0x8006b674)
    

    %callfunc(0x80541fcc)
    lwz r0, 0x14(r1)
    mtlr r0
    addi r1, r1, 0x10
    blr
}
initialisePrinter
.macro callfunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
.alias messageObj = 0x87C

.alias WriterX0 = 0x880
.alias WriterY0 = 0x884
.alias WriterX1 = 0x888
.alias WriterY1 = 0x88C

.alias scaleX = 0x898
.alias scaleY = 0x89C

.alias Data = 31
HOOK @ $80541fcc
{
    stwu r1, -0x10(r1)
    mflr r0
    stw r0, 0x14(r1)
    stw r31, 0xC(r1)
	lis Data, 0x8054
	ori Data, Data, 0x8400


	#0x80069AF0

	lfs f1, WriterX0(Data)
	lfs f2, WriterY0(Data)
	lfs f3, WriterX1(Data)
	lfs f4, WriterY1(Data)
	lwz r3, messageObj(Data)
	lis r12, 0x8006
	ori r12, r12, 0x9AF0
	mtctr r12
	bctrl
	#0x8006A550
	lwz r3, messageObj(Data)
	li r4, 0x4
	lis r12, 0x8006
	ori r12, r12, 0xA550	
	mtctr r12
	bctrl 
	#0x8006a600
	lwz r3, messageObj(Data)
	lfs f1, 0xC(Data) #-1
	lis r12, 0x8006
	ori r12, r12, 0xA600
	mtctr r12 
	bctrl
	#0x8006A018
	lwz r3, messageObj(data)
	lfs f1, scaleX(data)
	lfs f2, scaleY(data)
	lis r12, 0x8006
	ori r12, r12, 0xA018
	mtctr r12 
	bctrl
    
    lwz r31, 0xC(r1)    
    lwz r0, 0x14(r1)
    mtlr r0
    addi r1, r1, 0x10
    blr
}