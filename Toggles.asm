Debug Loaded check 
string "DEV" @ $80541f8c

WriteDebugFlag
HOOK @ $80541F98
{
	lis r5, 0x8054
	ori r5, r5, 0x2000
	stbx r4, r5, r3
	blr

}
Read Debug Flag 
HOOK @ $80541F9C
{
	lis r4, 0x8054
	ori r4, r4, 0x2000
	lbzx r3, r4, r3
	blr
}

renderDebug/[gfSceneRoot]
.alias stageID = 0
.alias fighterID = 1
.alias itemsarticlesID = 2 #also includes primids etc
.alias specialItemsID = 3 #specific items e.g. beam sword for some reason, assist trophy, food, starman, lightning, warpstar, star rod, goey bomb, freezie, hothead, team healer, screw attack, 
.alias gfxID = 4
.alias specificFXID = 5 #seems like it might literally just be the blue falcon
.alias unk2ID = 6 #not spawned at all on spawn
.alias unk3ID = 7 #appears once on spawn, is always on #ecMgr, seems to literally just be the manager itself, not what it draws?
.alias interfaceID = 8

#3,5,6,7 are confusing ones, everything else is understood

HOOK @ $8000E7AC
{
	stwu r1, -0x10 (r1)
	mflr r0
	stw r0, 0x14(r1)
	stw r31, 0x0C(r1)
	stw r30, 0x08(r1)
	mr r31, r3

	lis r4, 0x8054
	ori r4, r4, 0x1f8c
	lwz r4, 0x0(r4)
	cmpwi r4, 0
	beq end

	lis r30, 0x8000
	ori r30, r30, 0xD234
char:
	li r3, 4
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 1
	li r5, 1
	bne 0x8
	li r5, 0
	mr r3, r31
	li r4, fighterID
	mtctr r30
	bctrl
	#r5 is untouched within function, probably shouldnt trust that if im good
	mr r3, r31
	li r4, gfxID
	mtctr r30
	bctrl
	rlwimi r0, r5, 5, 26, 26
	stb r0, 0x399(r3) #disables gfx draw too
	#r5 is untouched within function, probably shouldnt trust that if im good
	mr r3, r31
	li r4, itemsarticlesID
	mtctr r30
	bctrl	
	mr r3, r31
	li r4, specialItemsID
	mtctr r30
	bctrl
	mr r3, r31
	li r4, specificFXID
	mtctr r30
	bctrl
#disable stage render
stage:
	li r3, 8
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 2
	li r5, 1
	bne 0x8
	li r5, 0
	mr r3, r31
	li r4, stageID
	mtctr r30
	bctrl
interface:
	li r3, 5
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 1
	li r5, 1
	bne 0x8
	li r5, 0
	mr r3, r31
	li r4, interfaceID
	mtctr r30
	bctrl
end:
	lwz r0, 0x14(r1)
	lwz r31, 0x0C(r1)
	lwz r30, 0x08(r1)
	mtlr r0
	addi r1, r1, 0x10
	blr	

}
#0,4,7

Item Destruction fix 
HOOK @ $80712EA0
{
	lwz r4, 0xC(r31)
	lis r3, 0x805A
	lwz r3, -0x80(r3)
	lis r12, 0x8000
	ori r12, r12, 0xD10C
	mtctr r12
	bctrl
	lwz r3, 0xC(r31)
	lis r12, 0x8019
	ori r12, r12, 0xD8D8
	mtctr r12
	bctrl
}
op b 0x14 @ $80712EA4

[Project+] Debug Controls v1.4 (Dolphin Fix v1.1) [Magus, ???, Eon] to be modified
#op lbz r0, 11(r25) @ $8002E5AC
HOOK @ $8002E5AC
{
	lbz r3, 0xB(r25)
	andi. r0, r3, 4
	bne unpause
	andi. r0, r3, 2
	beq end
	li r3, 2
	lis r12, 0x8054
	ori r12, r12, 0x1F9C
	mtctr r12
	bctrl
	cmpwi r3, 0
	beq end
	li r0, 0
	b %end%
unpause:
	li r4, 0x6
	not r4, r4
	and r3, r3, r4
	stb r3, 0xB(r25)
	li r26, 0 #force pause this frame to disable inputs from being processed
end:
	lbz r0, 0xB(r25)
}
HOOK @ $8002E68C
{	
	lbz r3, 0xB(r25)
	andi. r3, r3, 2
	beq end
	li r3, 2
	li r4, 0
	lis r12, 0x8054
	ori r12, r12, 0x1F98
	mtctr r12
	bctrl
end:
	lhz r30, 0x140(r25)
}
#80028a08 might be good place to hook to understand inputs, maybe just stick at the bottom of this and use contents of r3
#r3 is input struct, 
#0x0 current held
#0x4 current held, 
#0x8 held for more than 1 frame, 0xC is pressed this frame 
#0xC pressed this frame
#0x10 released this frame
#0x14 pressed this frame

#0x38 controller active
#0x3C controller type, 0 = gcc, 1 = classic controller, 2 = wiimote, 3 = mote+nunchuk
#modifying 0x0 offset lets me edit controls before processed, can likely delete 
HOOK @ $8002A258
{
.alias inputsOtherList = 26

.alias inputVariable = 27
.alias currInputs = 28
.alias heldInputs = 29

.alias inputData = 31
.alias toggleList = 30

.alias debugData = 25

.alias debugMask = 24
#pretending this is an arg so i dont have to mess with things
	mr r3, r29
	mr r4, r28

	stwu r1, -0x30(r1)
	stmw r24, 0x8(r1)
	mflr r0
	stw r0, 0x34(r1)

	mr inputData, r3
	mr inputsOtherList, r4
	bl data
	mflr toggleList #pointer to data

	lbz r4, 0x38(inputData)
	cmpwi r4, 0 #controller enabled
	bne end
	lwz r4, 0x3C(inputData)
	cmpwi r4, 0 #gamecube controller
	bne end
	#li r4, 0
	#stw r4, 0x0(inputData)
	#b end
	lis debugData, 0x8054
	ori debugData, debugData, 0x2000
	lwz debugMask, 0x20(debugData)

	lwz currInputs, 0x0(inputData)
	lwz heldInputs, 0xC(inputData)
inputLoop:
	lwz inputVariable, 0x4(toggleList)
	cmpwi inputVariable, -1
	beq end 
	li r3, 1
	slw r3, r3, inputVariable
	and. r3, debugMask, r3 
	beq next

	lhz r3, 0x0(toggleList)
	lhz r4, 0x2(toggleList)
	#if current input matches toggles input
	and r0, currInputs, r3
	cmpw r3, r0
	bne next
	#if held input matches toggles input
	and r0, heldInputs, r4
	cmpw r4, r0
	bne next

	lbzx r4, debugData, inputVariable
	#r5 = max value of toggled value read
	lwz r5, 0x8(toggleList)
writeValue:
	#debug value
	lbzx r4, debugData, inputVariable

	cmpwi r5, 0
	blt dec
inc:
	addi r4, r4, 1
	b wrap
dec:
	subi r4, r4, 1
	mulli r5, r5, -1
wrap:
	cmpw r4, r5
	bgt wrapOver
	cmpwi r4, 0
	bge store
wrapUnder:
	mr r4, r5
	b store
wrapOver:
	li r4, 0
store:
	stbx r4, debugData, inputVariable
specialCases:
	cmpwi inputVariable, 0
	beq debugToggle
	cmpwi inputVariable, 1
	beq debugPause
	cmpwi inputVariable, 2
	beq debugFrameAdvance
	cmpwi inputVariable, 3
	beq debugFrameAdvanceFast
	cmpwi inputVariable, 10
	beq fakePause
	b next

debugToggle:
	#enable everything
	cmpwi r4, 1
	beq debugOn
debugOff:
	
	lis r3, 0x805A
	lwz r3, 0x1D0(r3)
	li r4, 0x28
	li r5, -1
	li r6, 0
	li r7, 0
	li r8, -1
	lis r12, 0x8007
	ori r12, r12, 0x42b0
	mtctr r12
	bctrl

	li r3, 0x1
	b debugToggleEnd
debugOn:
	
	lis r3, 0x805A
	lwz r3, 0x1D0(r3)
	li r4, 0x1ef1
	li r5, -1
	li r6, 0
	li r7, 0
	li r8, -1
	lis r12, 0x8007
	ori r12, r12, 0x42b0
	mtctr r12
	bctrl
	
	li r3, -1
	li r4, 0xC #disable frame advance and fast frame advance
	xor r3, r3, r4
debugToggleEnd:
	stw r3, 0x20(debugData)
	b next
debugPause:
	#change all blind xor's to specifically checking if should be on or off and toggling appropriately
	cmpwi r4, 0
	
	lwz r3, 0xC(inputData)
	xori r3, r3, 0x1000 #delete start input
	stw r3, 0xC(inputData)
	
	
	beq debugPauseOff
debugPauseOn:
	lwz r3, 0x20(debugData)
	ori r3, r3, 0xC
	stw r3, 0x20(debugData)

	lis r3, 0x805b
	ori r3, r3, 0x8a00
	lbz r4, 0xB(r3)
	ori r4, r4, 0x2
	stb r4, 0xB(r3)

	b debugPauseEnd
debugPauseOff:
	lwz r3, 0x20(debugData)
	li r4, 0xC
	not r4, r4
	and r3, r3, r4
	stw r3, 0x20(debugData)

	lis r3, 0x805b
	ori r3, r3, 0x8a00
	lbz r4, 0xB(r3)
	li r5, 0x2
	not r5, r5
	and r4, r4, r5
	ori r4, r4, 0x4
	stb r4, 0xB(r3)

debugPauseEnd:

	lis r3, 0x805A
	lwz r3, 0x1D0(r3)
	li r4, 0x24
	li r5, -1
	li r6, 0
	li r7, 0
	li r8, -1
	lis r12, 0x8007
	ori r12, r12, 0x42b0
	mtctr r12
	bctrl
	b end
	

debugFrameAdvance:
	li r3, -1
	subi r3, r3, 0x10
	
	lwz r4, 0x0(inputsOtherList)
	and r4, r3, r4
	stw r4, 0x0(inputsOtherList)
	
	lwz r4, 0x4(inputsOtherList)
	and r4, r3, r4
	stw r4, 0x4(inputsOtherList)
	b next
debugFrameAdvanceFast:
	cmpwi r4, 0
	beq next
	cmpw r4, r5
	blt next
	subi r4, r5, 2
	stbx r4, debugData, inputVariable #set timer for next z input to 2 frames from now
	li inputVariable, 2 #set type to frame advance input
	li r5, 8 #
	b writeValue
fakePause:
	cmpwi r4, 0
	
	lwz r3, 0x4(inputData)
	ori r3, r3, 0x1000 #add start input (used by lra-start)=
	stw r3, 0x4(inputData)

	
	li r4, 0
	stbx r4, debugData, inputVariable
	bne next
	
	lwz r3, 0xC(inputData)
	ori r3, r3, 0x1000 #add start input to game
	stw r3, 0xC(inputData)
	#turn off debug pause if first frame doing this
	li r4, 0
	li inputVariable, 0x1
	
	stbx r4, debugData, inputVariable
	b debugPauseOff 

next:
	addi toggleList, toggleList, 0xC
	b inputLoop

end:
	mr r3, inputData

	lwz r0, 0x34(r1)
	mtlr r0
	lmw r24, 0x8(r1)
	addi r1, r1, 0x30

	#original command
	addi r27, r27, 1
	b %end%
data:
	blrl
	######################## 
	#dpl = 0b0000000000000001, 0x0001
	#dpr = 0b0000000000000010, 0x0002
	#dpd = 0b0000000000000100, 0x0004
	#dpu = 0b0000000000001000, 0x0008
	#  z = 0b0000000000010000, 0x0010
	#  r = 0b0000000000100000, 0x0020
	#  l = 0b0000000001000000, 0x0040
	#n/a = 0b0000000010000000, 0x0080
	#  a = 0b0000000100000000, 0x0100
	#  b = 0b0000001000000000, 0x0200
	#  x = 0b0000010000000000, 0x0400
	#  y = 0b0000100000000000, 0x0800
	#  s = 0b0001000000000000, 0x1000

	# HHHH = inputs required to be held
	# PPPP = input to be pressed on that frame to trigger
	# ID = which debug option its changing, ID of -1 = end of list
	# max = max value to set value to before wrap-around kicks in
	#		if max is negative, denotes you should decrement value, not increment.
	#      HHHHPPPP;   ID  ;  max
	word 0x00600004; word 0; word 1 	#l-r held dpaddown press 	#debug toggle
	word 0x00001000; word 1; word 1 	#start press 				#debug pause
	word 0x04000008; word 10;  word 0 	#x+dpad up
	word 0x04080000; word 10;  word 1 	#x+dpad up	
	word 0x00000010; word 2; word 8 	#z press 					#frame advance
	word 0x00000010; word 3; word 0 	#z press					#frame advance fast clear
	word 0x00100000; word 3; word 30	#z held 					#frame advance fast, will count up to 60 frames and then start doing auto frame advance
	word 0x00200002; word 4; word 2 	#R held dpadright press 	#hitbox toggle, 0,1,2
	word 0x00400001; word 5; word 1 	#L held dpadleft press 		#camera lock
	word 0x08000002; word 6; word 1 	#y held dpad right press 	#ledge grab box display
	word 0x08000001; word 7; word 2 	#y held dpad left press 	#ecb display, press twice to enable "ground stood on"
	word 0x00400002; word 8; word 2 	#L held dpadright press 	#stage collision display, twice to disable stage
	word 0x04000001; word 9; word -32	#X held dpadleft press 		#areamanager presets to scroll through
	word 0x04000002; word 9; word 32 	#X held dpadright press 	#areamanager presets to scroll through

	word 0xFFFFFFFF; word -1 #end

}
