renderDebug/[StageObject]
HOOK @ $80710AE4
{
	stwu r1, -0x20(r1)
	mflr r0
	stw r0, 0x24(r1)
	stw r31, 0x10(r1)
	lwz r31, 0x60(r3)

hurthitetcdraw:
	li r3, 4
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 0
	beq ecbDraw

	#collisionHit
	lwz r3, 0xD8(r31)
	lwz r3, 0x20(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0xD8(r12)
	mtctr r12
	bctrl
	#collisionAttack
	lwz r3, 0xD8(r31)
	lwz r3, 0x1C(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x120(r12)
	mtctr r12
	bctrl
	#collisionShield
	lwz r3, 0xD8(r31)
	lwz r3, 0x24(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x88(r12)
	mtctr r12
	bctrl
	#collisionShield
	lwz r3, 0xD8(r31)
	lwz r3, 0x28(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x88(r12)
	mtctr r12
	bctrl
	#collisionShield
	lwz r3, 0xD8(r31)
	lwz r3, 0x2C(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x88(r12)
	mtctr r12
	bctrl
	#collisionCatch
	lwz r3, 0xD8(r31)
	lwz r3, 0x30(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x48(r12)
	mtctr r12
	bctrl
	#collisionSearch
	lwz r3, 0xD8(r31)
	lwz r3, 0x34(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x50(r12)
	mtctr r12
	bctrl

ecbDraw:
	#soGroundModule

	li r3, 7
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 0
	beq end
	lwz r3, 0xD8(r31)
	lwz r3, 0x10(r3)
	lwz r12, 0x8(r3)
	lwz r12, 0x21C(r12)
	mtctr r12
	bctrl
soCameraModule:
	lwz r3, 0xD8(r31)
	lwz r3, 0x60(r3)
	lwz r12, 0x0(r3)
	lwz r12, 0x64(r12)
	mtctr r12
	bctrl 
end:
	lwz r31, 0x10(r1)
	lwz r0, 0x24(r1)
	mtlr r0 
	addi r1, r1, 0x20
	blr
}

renderDebug/[Yakumono]
HOOK @ $8096e040
{
	lis r12, 0x8071 
	ori r12, r12, 0x0AE4
	mtctr r12
	bctr
}