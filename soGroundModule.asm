Collision Debug Function [Arthur] #draws collision that is stood on and its normal
#setIgnoreDepth
op li r5, 0 @ $80137860
op li r5, 0 @ $8013789C
op li r5, 0 @ $801378d8
op li r5, 0 @ $80137914
op li r5, 0 @ $80137b34
op li r5, 0 @ $80137bf0
op li r5, 0 @ $80137CF8
op li r5, 0 @ $80137e3c
op li r5, 0 @ $80137eec

#set ECBChange to same orange as ecb drawn
word 0xFFC040A0 @ $805A2A5C



DrawECB
.macro drawPart(<a>, <b>)
{

	lfs f2, <a>(r3)
	lfs f3, <a>+4(r3)
	lfs f4, <b>(r3)
	lfs f5, <b>+4(r3)
	stfs f2, 0x10(r1)
	stfs f3, 0x14(r1)
	stfs f4, 0x18(r1)
	stfs f5, 0x1C(r1)

	lfs f1, -0x68CC(r2)
	addi r3, r1, 0x10
	addi r4, r1, 0x08
	li r5, 0
	
	lis r12, 0x8004
	ori r12, r12, 0x1104
	mtctr r12
	bctrl

	lwz r3, 0x300(r1)
}
HOOK @ $8004380C
{
	stw r3, 0x300(r1)
	cmpwi r5, 1
	bne prevFrame
currentFrame:
	lis r0, 0xFFC0
	ori r0, r0, 0x40FF
	b draw
prevFrame:
	lis r0, 0xFFC0
	ori r0, r0, 0x4080
draw:
	stw r0, 0x8(r1)

	%drawPart(0x8, 0x18)
	%drawPart(0x8, 0x20)

	%drawPart(0x10, 0x18)
	%drawPart(0x10, 0x20)
}
Draw Ledgegrab
.macro drawPart(<a>, <b>, <c>, <d>)
{

	lfs f2, <a>(r1)
	lfs f3, <b>(r1)
	lfs f4, <c>(r1)
	lfs f5, <d>(r1)
	stfs f2, 0x20(r1)
	stfs f3, 0x24(r1)
	stfs f4, 0x28(r1)
	stfs f5, 0x2C(r1)

	lfs f1, -0x68CC(r2)
	addi r3, r1, 0x20
	addi r4, r1, 0x18
	li r5, 0
	
	lis r12, 0x8004
	ori r12, r12, 0x1104
	mtctr r12
	bctrl

}

HOOK @ $80137F44
{

    lis r0, 0x4000
    stw r0, 0x18(r1)
    lfs f1, 0x18(r1)

    lis r0, 0x0000
    stw r0, 0x18(r1)
    lfs f2, 0x18(r1)

	lwz r3, 0x08(r1)
	lwz r4, 0x0C(r1)
	lwz r5, 0x10(r1)
	lwz r6, 0x14(r1)


	stw r3, 0x20(r1)
	stw r4, 0x24(r1)

	stw r5, 0x28(r1)
	stw r4, 0x2C(r1)

	stw r5, 0x30(r1)
	stw r6, 0x34(r1)

	stw r3, 0x38(r1)
	stw r6, 0x3C(r1)
	

	lis r0, 0x00FF
	ori r0, r0, 0x10FF
	stw r0, 0x18(r1)

    addi r3, r1, 0x20 #positions
    addi r4, r1, 0x18 #colour


	%callfunc(0x80541fb4)
    lwz r0, 0x3A4(r1)
    mtlr r0
    addi r1, r1, 0x3A0
    blr
}

