Debug Loaded check 
string "DEV" @ $80541f8c

ToggleDebugFlag
HOOK @ $80541F98
{
	mr r0, r3
	lis r3, 0x8054
	ori r3, r3, 0x2000

}
Read Debug Flag 
HOOK @ $80541F9C
{
	mr r0, r3 
	lis r3, 0x8054
	ori r3, r3, 0x2000
	lbzx r3, r3, r0
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

!Code Menu Interface
C0000000 0000000E
9421FFE0 7C0802A6
90010024 90610020
9081001C 90A10018
90C10014 3C608054
60632000 3C80804E
60840938 38A00010
48000018 80040000
98030000 38630001
38840028 38A5FFFF
2C050000 4080FFE8
80610020 8081001C
80A10018 80C10014
80010024 7C0803A6
38210020 4E800020


!Debug Start Input v1.2 [Magus, ???] 
HOOK @ $801E6D1C #x+dpadup = start press, gotta get r4 going into process to be 1 so frame doesnt advance
{
loc_0x0:
  lwzx r0, r3, r4
  lis r6, 0x8058
  ori r6, r6, 0x3FFE
  lhz r5, 0(r6)
  rlwinm. r5, r5, 0, 31, 31
  lis r6, 0x805B
  ori r6, r6, 0x8A0A
  lhz r5, 0(r6)
  bne- loc_0x30
  rlwinm. r7, r0, 0, 3, 3
  beq+ loc_0x60
  b loc_0x50

loc_0x30:
  lis r7, 0x1000
  not r7, r7
  and. r0, r0, r7
  andis. r7, r0, 0x408
  lis r8, 0x408
  cmpw r7, r8
  bne+ loc_0x60
  oris r0, r0, 0x1000

loc_0x50:
  cmpwi r5, 0x0
  beq+ loc_0x60
  li r5, 0x0
  sth r5, 0(r6)

loc_0x60:
}

[Project+] Debug Controls v1.4 (Dolphin Fix v1.1) [Magus, ???, Eon] to be modified
#op lbz r0, 11(r25) @ $8002E5AC
HOOK @ $8002E5AC
{
	lbz r3, 0xB(r25)
	andi. r3, r3, 2
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
end:
	lbz r0, 0xB(r25)
}

#80028a08 might be good place to hook to understand inputs, maybe just stick at the bottom of this and use contents of r3
#r3 is input struct, 
#0x0 current held
#0x4 current held, 
#0x8 held for more than 1 frame, 0xC is pressed this frame 
#0xC pressed this frame
#0x10 released this frame
#0x18 pressed this frame

#0x38 controller active
#0x3C controller type, 0 = gcc, 1 = classic controller, 2 = wiimote, 3 = mote+nunchuk
HOOK @ $8002A5E4
{
.alias inputVariable = 27
.alias currInputs = 28
.alias heldInputs = 29

.alias inputData = 31
.alias toggleList = 30
#pretending this is an arg so i dont have to mess with things
	mr r3, r27

	stwu r1, -0x30(r1)	# make space for 18 registers
	stmw r27, 0x8(r1)	# push r3-r31 onto the stack
	mflr r0
	stw r0, 0x34(r1)

	mr inputData, r3
	bl data
	mflr toggleList #pointer to data

	lbz r4, 0x38(inputData)
	cmpwi r4, 0 #controller enabled
	bne end
	lwz r4, 0x3C(inputData)
	cmpwi r4, 0 #gamecube controller
	bne end

	lwz currInputs, 0x0(inputData)
	lwz heldInputs, 0xC(inputData)
inputLoop:
	lwz inputVariable, 0x4(toggleList)
	cmpwi inputVariable, -1
	beq end 
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
	#r5 = max value of toggled value read
	lwz r5, 0x8(toggleList)
	#debug list
	lis r3, 0x8054
	ori r3, r3, 0x2000
writeValue:
	#debug value
	lbzx r4, r3, inputVariable

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
	stbx r4, r3, inputVariable
specialCases:
	cmpwi inputVariable, 0
	beq debugToggle
	cmpwi inputVariable, 3
	beq debugFrameAdvanceFast

debugToggle:
	#enable everything
	li r3, -1
	cmpwi r4, 1
	beq 0x8
	li r3, 1
#	setInputMask()
	b next
debugFrameAdvanceFast:
	cmpwi r4, 0
	beq next
	cmpw r4, r5
	blt next
	subi r4, r5, 2
	stbx r4, r3, inputVariable #set timer for next z input to 2 frames from now
	li inputVariable, 2 #set type to frame advance input
	li r5, 8 #
	b writeValue

next:
	addi toggleList, toggleList, 0xC
	b inputLoop

end:
	mr r3, inputData

	lwz r0, 0x34(r1)
	mtlr r0
	lmw r27, 0x8(r1)
	addi r1, r1, 0x30

	#original command
	addi r29, r29, 1
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
	word 0x00001000; word 1; word 1 	#start press 				#pause
	word 0x00100000; word 2; word 0		#z held						#frame advance clear
	word 0x00000010; word 2; word 8 	#z press 					#frame advance
	word 0x00000010; word 3; word 0 	#z press					#frame advance fast clear
	word 0x00100000; word 3; word 60	#z held 					#frame advance fast, will count up to 60 frames and then start doing auto frame advance
	word 0x00200002; word 4; word 2 	#R held dpadright press 	#hitbox toggle, 0,1,2
	word 0x00400001; word 5; word 1 	#L held dpadleft press 		#camera lock
	word 0x08000002; word 6; word 1 	#y held dpad right press 	#ledge grab box display
	word 0x08000001; word 7; word 2 	#y held dpad left press 	#ecb display, press twice to enable "ground stood on"
	word 0x00400002; word 8; word 2 	#L held dpadright press 	#stage collision display, twice to disable stage
	word 0x04000001; word 9; word -32	#X held dpadleft press 		#areamanager presets to scroll through
	word 0x04000002; word 9; word 32 	#X held dpadright press 	#areamanager presets to scroll through

	word 0xFFFFFFFF; word -1 #end

}

