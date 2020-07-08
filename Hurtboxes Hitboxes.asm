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
	mr r29, r3

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
	lwz r3, 0x30(r29)
	mr r4, r30
	lwz r12, 0(r3)
	lwz r12, 0xC(r12)
	mtctr r12
	bctrl 
	lwz r0, 0(r3)
	cmpwi r0, 0
	beq iterate

	mr r4, r30
	lwz r5, 0x88(r3)
	addi r3, r29, 0x68 
	lis r12, 0x8074
	ori r12, r12, 0x0A3C
	mtctr r12
	bctrl

	mr r5, r3
	mr r3, r31
	addi r4, r1, 8
	%callFunc(0x80541fa4)
	
iterate:
	addi r30, r30, 1
checkLoop:
	lwz r3, 0x30(r29)
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
	mtlr r0
	addi r1, r1, 80
	blr 
}

HOOK @ $80541fa4
{
debugDisplaySoCollisionAttackPart:
	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)
	stw r31, 0x1C(r1)
	stw r30, 0x18(r1)
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
skip:
	lwz r0, 0x24(r1)
	lwz r31, 0x1C(r1)
	lwz r30, 0x18(r1)
	mtlr r0
	addi r1, r1, 32
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
