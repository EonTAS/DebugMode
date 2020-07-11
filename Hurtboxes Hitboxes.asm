renderDebug/[soCollisionAttackModuleImpl]
.macro callFunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $8074BDB0
{
	stwu r1, -0x50(r1)
	mflr r0
	stw r0, 0x54(r1)
	stw r31, 0x4C(r1)
	stw r30, 0x48(r1)
	stw r29, 0x44(r1)
	stw r28, 0x40(r1)
	mr r28, r3

#getCameraMatrix	
	lis r12, 0x8001
	ori r12, r12, 0x9FA4
	mtctr r12
	bctrl
	lwz r4, 0(r3)
	li r30, 0
	lwz r0, 0x4(r3)
	stw r4, 0x8(r1)
	stw r0, 0xC(r1)
	lwz r4, 0x8(r3)
	lwz r0, 0xC(r3)
	stw r4, 0x10(r1)
	stw r0, 0x14(r1)
	lwz r4, 0x10(r3)
	lwz r0, 0x14(r3)
	stw r4, 0x18(r1)
	stw r0, 0x1C(r1)
	lwz r4, 0x18(r3)
	lwz r0, 0x1C(r3)
	stw r4, 0x20(r1)
	stw r0, 0x24(r1)
	lwz r4, 0x20(r3)
	lwz r0, 0x24(r3)
	stw r4, 0x28(r1)
	stw r0, 0x2C(r1)
	lwz r4, 0x28(r3)
	lwz r0, 0x2C(r3)
	stw r4, 0x30(r1)
	stw r0, 0x34(r1)

	b checkLoop
loop:
	lwz r3, 0x30(r28)
	mr r4, r30
	lwz r12, 0(r3)
	lwz r12, 0xC(r12)
	mtctr r12
	bctrl 
	lwz r0, 0(r3)
	cmpwi r0, 0
	beq iterate
	mr r29, r3
	mr r4, r30
	lwz r5, 0x88(r3)
	addi r3, r28, 0x68 
	lis r12, 0x8074
	ori r12, r12, 0x0A3C
	mtctr r12
	bctrl

	mr r6, r29
	mr r5, r3
	mr r3, r31
	addi r4, r1, 8
	%callFunc(0x80541fa4)
	
iterate:
	addi r30, r30, 1
checkLoop:
	lwz r3, 0x30(r28)
	lwz r12, 0(r3)
	lwz r12, 0x14(r12)
	mtctr r12
	bctrl 
	cmpw r30, r3
	blt loop

end:
	lwz r0, 0x54(r1)
	lwz r31, 0x4C(r1)
	lwz r30, 0x48(r1)
	lwz r29, 0x44(r1)
	lwz r28, 0x40(r1)
	mtlr r0
	addi r1, r1, 80
	blr 
}

HOOK @ $80541fa4
{
debugDisplaySoCollisionAttackPart:
	stwu r1, -0xA0(r1)
	mflr r0
	stw r0, 0xA4(r1)
	stw r31, 0x1C(r1)
	stw r30, 0x18(r1)
	stw r29, 0x14(r1)
	mr r30, r5
	mr r29, r6
	lwz r0, 0(r3)
	cmpwi r0, 1
	beq skip

	mr r3, r5
	addi r5, r1, 12
	addi r6, r1, 8
	lis r0, 0xFF00
	ori r0, r0, 0x0080
	stw r0, 0xC(r1)

	lis r0, 0x4000
	ori r0, r0, 0x0080
	stw r0, 0x8(r1)

	lwz r12, 0x30(r3)
	lwz r12, 0x24(r12)
	mtctr r12
	bctrl 
#TODO: decide if i should keep angle render
#	lis r3, 0x4330
#	stw r3, 0x30(r1)
#
#	lwz r3, 0x18(r29) #angle in degrees 
#
#	cmpwi r3, 361
#	beq skip
#	cmpwi r3, 363
#	beq skip
#	cmpwi r3, 365
#	beq skip
#
#	stw r3, 0x34(r1)
#	lfd f1, 0x30(r1)
#	lfd f2, -0x6F98(r2) 
#	fsubs f1, f1, f2 
#	lfs f2, -0x5A6C(r2)
#	fmuls f1, f1, f2
#	lfs f2, -0x5B2C(r2)
#	fdivs f1, f1, f2
#
#
#	
#	%callFunc(0x804004d8)
#	lfd f2, 0x30(r1)
#	stfs f1, 0x30(r1)
#	lfd f1, -0x6F98(r2)
#	fsubs f1, f2, f1
#	lfs f2, -0x5A6C(r2)
#	fmuls f1, f1, f2
#	lfs f2, -0x5B2C(r2)
#	fdivs f1, f1, f2
#	%callFunc(0x804009e0)
#
#
#	stfs f1, 0x34(r1)
#
#
#	#do maths, put sin(r3) into 0x30(r1)
#	#do maths, put cos(r3) into 0x34(r1)
#	li r0, 0
#	stw r0, 0x38(r1)
#
##getType
#	mr r3, r30
#	lwz r12, 0x30(r30)
#	lwz r12, 0xC(r12)
#	mtctr r12
#	bctrl #get type
#	cmpwi r3, 1
#	beq capsule
#sphere:
#	lfs f1, 0xC(r30)
#	lfs f2, 0x30(r1)
#	lfs f3, 0x34(r1)
#	fmuls f2, f1, f2
#	fmuls f3, f1, f3
#
#	lfs f4, 0x0(r30)
#	fadds f2, f2, f4
#	lfs f5, 0x4(r30)
#	fadds f3, f3, f5
#	lfs f4, 0x8(r30)
#
#	stfs f2, 0x30(r1)
#	stfs f3, 0x34(r1)
#	stfs f4, 0x38(r1)
#
#	#pos1 = 0x0(r30)
#	#pos2 = 0x30(r1)
#
#	lis r3, 0x4000
#	stw r3, 0x3C(r1)
#	lfs f1, 0x3C(r1)
#
#	mr r3, r30
#	addi r4, r1, 0x30
#	lis r5, 0xA0A0
#	ori r5, r5, 0xA0FF
#	stw r5, 0x3C(r1)
#	addi r5, r1, 0x3C
#	li r6, 1
#	%callFunc(0x80541fb8)
#	#drawLine(pos1, pos2, colour, linewidth)
#	b skip
#
capsule:
#	addi r3, r30, 0x40
#	addi r4, r1, 0x40
#	%callFunc(0x801ec184)
#	
#	addi r3, r1, 0x40
#	addi r4, r1, 0x70
#	%callFunc(0x801ec41c)
#	#0x30 = transformation matrix
#	#0x60 = inverse of transformation
#	li r0, 0
#	stw r0, 0x20(r1)
#	stw r0, 0x24(r1)
#	stw r0, 0x28(r1)
#
#	addi r3, r1, 0x40
#	addi r4, r1, 0x20
#	mr r5, r4
#	%callFunc(0x801ecd70)
#	addi r3, r1, 0x20
#	addi r4, r1, 0x30
#	mr r5, r4
#	%callFunc(0x801ecfe4) #add angle offset to centre pos
#
#
#	#at this point 0x20(r1) = center of sphere
#	#at this point 0x30(r1) = point at angle theta away from centre unit length
#
#	
#	addi r3, r1, 0x70 #inverse
#	addi r4, r1, 0x30 #point
#	mr r5, r4
#	%callFunc(0x801ecd70)
#	addi r3, r1, 0x30
#	mr r4, r3
#	%callFunc(0x801ed008) #normalise
#	lfs f1, 0xC(r30)
#
#	lfs f2, 0x30(r1)
#	lfs f3, 0x34(r1)
#	lfs f4, 0x38(r1)
#
#	fmuls f2, f2, f1
#	fmuls f3, f3, f1
#	fmuls f4, f4, f1
#
#	stfs f2, 0x30(r1)
#	stfs f3, 0x34(r1)
#	stfs f4, 0x38(r1)
#
#	#scaled to fit radius now
#
#	addi r3, r1, 0x40
#	addi r4, r1, 0x30
#	mr r5, r4
#	%callFunc(0x801ecd70)
#
#	#0x20 = pos1
#	#0x30 = pos2
#	#now draw a line joining the two 
#
#
skip:
	lwz r0, 0xA4(r1)
	
	lwz r31, 0x1C(r1)
	lwz r30, 0x18(r1)
	lwz r29, 0x14(r1)
	mtlr r0
	addi r1, r1, 0xA0
	blr 
}

renderDebug/[soCollisionHitModuleImpl]
.macro callFunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $80750F58
{
	stwu r1, -0x50(r1)
	mflr r0
	stw r0, 0x54(r1)
	stw r31, 0x4C(r1)
	stw r30, 0x48(r1)
	stw r29, 0x44(r1)
	stw r28, 0x40(r1)
	mr r28, r3
	mr r29, r4

	lhz	r0, 0x0066(r3)
	rlwinm.	r0, r0, 18, 31, 31
	bne end

#getCameraMatrix
	lis r12, 0x8001
	ori r12, r12, 0x9FA4
	mtctr r12
	bctrl
	
	lwz r4, 0(r3)
	li r30, 0
	lwz r0, 0x4(r3)
	stw r4, 0x8(r1)
	stw r0, 0xC(r1)
	lwz r4, 0x8(r3)
	lwz r0, 0xC(r3)
	stw r4, 0x10(r1)
	stw r0, 0x14(r1)
	lwz r4, 0x10(r3)
	lwz r0, 0x14(r3)
	stw r4, 0x18(r1)
	stw r0, 0x1C(r1)
	lwz r4, 0x18(r3)
	lwz r0, 0x1C(r3)
	stw r4, 0x20(r1)
	stw r0, 0x24(r1)
	lwz r4, 0x20(r3)
	lwz r0, 0x24(r3)
	stw r4, 0x28(r1)
	stw r0, 0x2C(r1)
	lwz r4, 0x28(r3)
	lwz r0, 0x2C(r3)
	stw r4, 0x30(r1)
	stw r0, 0x34(r1)
start:
	#getGroupNumber
	mr r3, r28
	lwz r12, 0x0(r28)
	lwz r12, 0xBC(r12)
	mtctr r12
	bctrl 

	mr r31, r3
	li r30, 0
	b checkLoop
loop:
	mr r3, r28
	mr r4, r29
	mr r5, r30
	addi r6, r1, 0x8
	%callFunc(0x80541fa8)
iterate:
	addi r30, r30, 1
checkLoop:
	cmpw r30, r31
	blt loop
end:
	lwz r0, 0x54(r1)
	lwz r31, 0x4C(r1)
	lwz r30, 0x48(r1)
	lwz r29, 0x44(r1)
	lwz r28, 0x40(r1)
	mtlr r0
	addi r1, r1, 0x50
	blr 
}
HOOK @ $80541fa8
{
renderDebugSoCollisionHitGroup:
	stwu r1, -0x30(r1)
	mflr r0
	stw r0, 0x34(r1)
	stw r31, 0x2C(r1)
	stw r30, 0x28(r1)
	stw r29, 0x24(r1)
	stw r28, 0x20(r1)
	stw r27, 0x16(r1)
	mr r29, r3
	mr r30, r4
	mr r31, r5
	mr r28, r6
	
	lhz r0, 0x66(r3)
	rlwinm r0, r0, 18, 31, 31
	cmpwi r0, 1
	beq endInner

	lwz r6, 0x2C(r3)
	mr r4, r5
	lwz r3, 0x58(r3)
	lwz r5, 0xD8(r6)
	lwz r12, 0(r3)
	lwz r31, 0x4(r5)
	lwz r12, 0xC(r12)
	mtctr r12
	bctrl 


	addi	r4, r29, 56
	lwz	r5, 0x30(r29)
	mr	r6, r31
	mr r7, r28

	%callFunc(0x80541fac)
	
endInner:
	lwz r0, 0x34(r1)
	lwz r31, 0x2C(r1)
	lwz r30, 0x28(r1)
	lwz r29, 0x24(r1)
	lwz r28, 0x20(r1)
	mtlr r0
	addi r1, r1, 0x30
	blr 
}
HOOK @ $80541fac
{
renderDebugSoCollisionHitGroupInner:
	stwu r1, -0x40(r1)
	mflr r0
	stw r0, 0x44(r1)
	addi r11, r1, 0x40
	lis r12, 0x803F
	ori r12, r12, 0x130C
	mtctr r12
	bctrl
	
	lwz r0, 0(r3)
	cmpwi r0, -1
	beq renderDebugSoCollisionHitGroupEnd
	mr r28, r3
	mr r29, r4
	mr r30, r5
	mr r31, r6 
	mr r26, r7
	
	

renderDebugSoCollisionHitGroupLoopStart:
	li r22, 0
	b renderDebugSoCollisionHitGroupLoopCheck
renderDebugSoCollisionHitGroupLoop:
	lwz r12, 0(r30)
	mr r3, r30
	lha r0, 0x4(r28)
	lwz r12, 0xC(r12)
	add r4, r0, r22
	mtctr r12
	bctrl 
	lwz r5, 0(r28)
	mr r27, r3
	mr r3, r29
	mr r4, r22
	lis r12, 0x8074
	ori r12, r12 0x0A3C 
	mtctr r12
	bctrl

	mr r5, r3
	mr r3, r31
	mr r4, r26
	mr r6, r27
	mr r7, r28
	%callFunc(0x80541fb0)
renderDebugSoCollisionHitGroupIterate:
	addi r22, r22, 1
renderDebugSoCollisionHitGroupLoopCheck:
	lha r0, 0x6(r28)
	cmpw r22, r0
	blt renderDebugSoCollisionHitGrouploop
renderDebugSoCollisionHitGroupEnd:
	addi r11, r1, 0x40
	lis r12, 0x803F
	ori r12, r12, 0x1358
	mtctr r12
	bctrl
	
	lwz r0, 0x44(r1)
	mtlr r0
	addi r1, r1, 0x40
	blr 
}
HOOK @ $80541fb0
{
debugDisplaySoCollisionHitPart:
	stwu r1, -0x40(r1)
	mflr r0
	stw r0, 0x44(r1)
	stw r31, 0x3C(r1)
	stw r30, 0x38(r1)
	stw r29, 0x34(r1)
	stw r28, 0x30(r1)
	stw r27, 0x2C(r1)
	mr r28, r3 
	mr r29, r4 #camera data?
	mr r30, r5 #hurtbox location
	mr r31, r6 #specific hurtbox pointer
	mr r27, r7 #overarching hurtbox container



	lwz r0, 0(r31)
	cmpwi r0, 3
	beq skip

	lwz r0, 0x1C(r27)
	cmpwi r0, 3
	beq skip
	cmpwi r0, 0
	bne checkStates

	lwz r3, 0x54(r31)
	subi r0, r3, 1
	cmplwi r0, 0
	bgt checkStates
	lwz r0, 0(r31)

checkStates:
	cmpwi r0, 0
	beq normal
	cmpwi r0, 1
	beq invince
	cmpwi r0, 2
	beq intang 
	cmpwi r0, 3
	beq intang 
	cmpwi r0, 4
	beq intang 
	b skip 
normal:
	lis r3, 0xFFFF
	ori r3, r3, 0x0080
	lis r4, 0x8080
	ori r4, r4, 0x0080
	b drawHurtbox
invince:
	lis r3, 0x00FF
	ori r3, r3, 0x0080
	lis r4, 0x0080
	ori r4, r4, 0x0080
	b drawHurtbox
intang: 
	lis r3, 0x0000
	ori r3, r3, 0xFF80
	lis r4, 0x0000
	ori r4, r4, 0x8080
	b drawHurtbox
drawHurtbox:

	stw r3, 0xC(r1)
	stw r4, 0x8(r1)

	addi r5, r1, 12
	addi r6, r1, 8
	mr r3, r30
	mr r4, r29
	lwz r12, 0x30(r3)
	lwz r12, 0x24(r12)
	mtctr r12
	bctrl 
skip:
	lwz r0, 0x44(r1)
	lwz r31, 0x3C(r1)
	lwz r30, 0x38(r1)
	lwz r29, 0x34(r1)
	lwz r28, 0x30(r1)
	lwz r27, 0x2C(r1)
	
	mtlr r0
	addi r1, r1, 0x40
	blr 
}
