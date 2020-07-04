renderDebug/[grCollisionManager]
HOOK @ $80112c94
{
	stwu r1, -0x0020 (r1)
	mflr r0
	stw	r0, 0x0024 (r1)
	stw r31, 0x10(r1)
	stw r30, 0x14(r1)
	stw r29, 0x18(r1)
	stw r28, 0x1C(r1)

	mr	r30, r3

	li r3, 8
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 0
	beq end
	lwz r0, 0x40(r30)
	rlwinm.	r0, r0, 25, 31, 31
	beq end

	lis r29, 0x804A
	subi	r29, r29, 6788
	lwz	r31, 0x0004 (r29)
	addi	r29, 29, 4
	b checkLoop
loopStart:
	lbz	r0, -0x4(r31)
	rlwinm.	r0, r0, 28, 31, 31
	beq next


	subi	r28, r31, 48
	mr	r3, r28
	lis r12, 0x8054 
	ori r12, r12, 0x1F90 
	mtctr r12
	bctrl
next:
	lwz	r31, 0 (r31)
checkLoop:
	cmplw r31, r29
	bne loopStart
end:
	lwz r31, 0x10(r1)
	lwz r30, 0x14(r1)
	lwz r29, 0x18(r1)
	lwz r28, 0x1C(r1)

	lwz r0, 0x24(r1)
	mtlr r0 
	addi r1, r1, 0x20
	blr

}
#drawCollisionList
HOOK @ $80541F90
{
.alias input = 23
	stwu	r1, -0x0050 (r1)
	mflr	r0
	stw	r0, 0x0054 (r1)
	addi	r11, r1, 80
	lis r12, 0x803F 
	ori r12, r12, 0x1310 
	mtctr r12
	bctrl

	mr	input, r3

	lbz	r5, 0x002C (r3)

	rlwinm.	r0, r5, 25, 31, 31
	beq end

loopInit:
	li	r24, 0
	li	r30, 0
	b loopNext

#8153b440
loop:
	lwz	r0, 0x0018 (input)
	add	r31, r0, r30
	li r25, 0
	lhz r26, 0x2(r31)
	b innerLoopCheck
innerLoopStart:
	mr r3, r31
	mr r4, r25
	lis r12, 0x8011
	ori r12, r12, 0x2EA0 
	mtctr r12
	bctrl 	#getLine/[grCollisionJoint]
	mr r27, r3
	mr r3, input
	addi r4, r1, 0x18
	mr r5, r27
	li r6, 0
	lis r12, 0x8011 
	ori r12, r12, 0x1968
	mtctr r12
	bctrl 

	addi r3, r1, 0x18
	mr r4, r27
	lis r12, 0x8054
	ori r12, r12, 0x1F94
	mtctr r12
	bctrl

	addi r25, r25, 1


innerLoopCheck:
	cmplw r25, r26
	blt innerLoopStart
loopIterate:
	addi	r30, r30, 96
	addi	r24, r24, 1
loopNext:
	lhz	r0, 0x0006 (input)
	cmplw	r24, r0
	blt loop


end:
	addi	r11, r1, 80
	lis r12, 0x803F 
	ori r12, r12, 0x135C
	mtctr r12
	bctrl
	lwz	r0, 0x0054 (r1)
	mtlr	r0
	addi	r1, r1, 80
	blr	
}
#DrawCollision(SegmentData, CollisionData)
HOOK @ $80541F94
{
.alias SegmentData = 31
.alias CollisionData = 30
.alias flags = 3
.alias type = 4

.macro setColour(<r>, <g>, <b>)
{
	li r0, <r>
	stb r0, 0x8(r1)	
	li r0, <g>
	stb r0, 0x9(r1)	
	li r0, <b>
	stb r0, 0xA(r1)
}
.alias skipColour = 0x20
.macro setAlpha(<a>)
{
	li r0, <a>
	stb r0, 0xB(r1)
}
.alias skipAlpha = 0x10
.macro isntAssigned()
{
	andi. r0, type, 0xF
}
.macro isFloor()
{
	andi. r0, type, 0x01
}
.macro isCeiling()
{
	andi. r0, type, 0x02
}
.macro isRightWall()
{
	andi. r0, type, 0x04
}
.macro isLeftWall()
{
	andi. r0, type, 0x08
}

.macro isDropThrough()
{
	andi. r0, flags, 0x01
}
.macro isRotating()
{
	andi. r0, flags, 0x04
}
.macro isSuperSoft()
{
	andi. r0, flags, 0x08
}
.macro isLeftLedge()
{
	andi. r0, flags, 0x20
}
.macro isRightLedge()
{
	andi. r0, flags, 0x40
}
.macro isNonWalljump()
{
	andi. r0, flags, 0x80
}
.macro isPlayerCollidable()
{
	andi. r0, type, 0x10
}
.macro isItemCollidable()
{
	andi. r0, type, 0x20
}
.macro isPTCollidable()
{
	andi. r0, type, 0x40
}
.macro isSSECollidable()
{
	andi. r0, type, 0x80
}

	stwu r1, -0x0030 (r1)
	mflr r0
	stw	r0, 0x0034(r1)
	stw r31, 0x30(r1)
	stw r30, 0x2C(r1)

	mr SegmentData, r3 
	mr CollisionData, r4
	
	li r3, 255
	stw r3, 0x8(r1)

	lbz flags, 0x10(CollisionData)
	lbz type, 0xF(CollisionData)
	%isntAssigned()
	bne 0x10
	%setAlpha(0)
	beq draw
	%isPlayerCollidable()
	bne 0x10
	%setAlpha(128)
	b startColours
	%isSuperSoft()
	beq startColours
	%setAlpha(160)

startColours:
	%isDropThrough()
	beq solid 

testPassableFloor:
	%isFloor()
	beq solid 
	%setColour(255, 255, 0)
	b draw

solid:
testSolidFloor:
	%isFloor()
	beq testSolidCeiling 
solidFloor:
	%isLeftLedge()
	beq checkRightLedge

	lfs f3, -0x68DC(r2)
	lfs f2, 0x0(SegmentData)
	fadds f1, f2, f3
	stfs f1, 0x10(r1)
	fsubs f1, f2, f3
	stfs f1, 0x18(r1)
	lfs f2, 0x4(SegmentData)
	fadds f1, f2, f3
	stfs f1, 0x14(r1)
	fsubs f1, f2, f3
	stfs f1, 0x1C(r1)

	b drawLedge
checkRightLedge:
	%isRightLedge()
	beq drawFloor
	lfs f3, -0x68DC(r2)
	lfs f2, 0x8(SegmentData)
	fsubs f1, f2, f3
	stfs f1, 0x10(r1)
	fadds f1, f2, f3
	stfs f1, 0x18(r1)
	lfs f2, 0xC(SegmentData)
	fadds f1, f2, f3
	stfs f1, 0x14(r1)
	fsubs f1, f2, f3
	stfs f1, 0x1C(r1)

drawLedge:

	%setColour(255, 0, 255)
	lfs f1, -0x68CC(r2)
	fadds f1, f1, f1
	addi r3, r1, 0x10
	addi r4, r1, 0x08
	li r5, 0
	
	lis r12, 0x8004
	ori r12, r12, 0x1104
	mtctr r12
	bctrl

drawFloor:
	%setColour(0, 230, 230)
	b draw

testSolidCeiling:
	%isCeiling()
	beq testSolidWall 
solidCeiling:
	%setColour(230, 0, 0)
	b draw

testSolidWall:
	%isLeftWall()
	bne solidWall
	%isRightWall()
	beq draw
solidWall:
	%isNonWalljump
	beq walljumpableWall
nonWalljumpableWall:
	%setColour(0, 100, 0)
	b draw
walljumpableWall:
	%setColour(0, 230, 0)
	b draw

draw:
	lfs f1, -0x68CC(r2)
	mr r3, SegmentData
	addi r4, r1, 8
	li r5, 0
	
	lis r12, 0x8004
	ori r12, r12, 0x1104
	mtctr r12
	bctrl
	

	lwz r31, 0x30(r1)
	lwz r30, 0x2C(r1)
	lwz	r0, 0x34 (r1)
	mtlr r0
	addi r1, r1, 0x30
	blr	
}