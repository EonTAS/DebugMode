renderDebug/[Stage]
.macro drawPart(<a>, <b>, <c>, <d>, <r>)
{

	lfs f2, <a>(<r>)
	lfs f3, <b>(<r>)
	lfs f4, <c>(<r>)
	lfs f5, <d>(<r>)
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

}
.macro drawPoint(<Offset>, <size>, <colour>)
{
.alias temp_Hi = <colour> / 0x10000
.alias temp_Lo = <colour> & 0xFFFF
	lis r3, temp_Hi
	ori r3, r3, temp_Lo
	stw r3, 0x8(r1)

	lis r3, <size>
	stw r3, <Offset>+0x8(r1)
	lfs f1, -0x68CC(r2)
	addi r3, r1, <Offset>
	addi r4, r1, 0x08
	li r5, 0
	#0x800415E8
	lis r12, 0x8004
	ori r12, r12, 0x15E8
	mtctr r12
	bctrl
}

#8154e320
HOOK @ $8092d4bc
{
	stwu r1, -0x0040(r1)
	mflr r0
	stw r0, 0x0044(r1)
	stw r31, 0x0040(r1)
	stw r30, 0x003C(r1)


	mr r31, r3
	li r3, 8
	lis r12, 0x8054 
	ori r12, r12, 0x1F9C
	mtctr r12 
	bctrl
	cmpwi r3, 0
	beq end
	mr r3, r31
	lwz r30, 0x78(r31)
	
	lwz r0, 0x0090(r3)
	cmpwi r0, 0
	beq end
	#Blastzones render 
	#red
	lis r0, 0xFF00
	ori r0, r0, 0x00FF
	stw r0, 0x8(r1)

	lfs f1, 0x58(r31)
	lfs f2, 0x20(r30)
	fadds f1, f1, f2
	stfs f1, 0x20(r1)
	lfs f1, 0x5C(r31)
	lfs f2, 0x20(r30)
	fadds f1, f1, f2
	stfs f1, 0x24(r1)
	lfs f1, 0x60(r31)
	lfs f2, 0x24(r30)
	fadds f1, f1, f2
	stfs f1, 0x28(r1)
	lfs f1, 0x64(r31)
	lfs f2, 0x24(r30)
	fadds f1, f1, f2
	stfs f1, 0x2C(r1)



	
	%drawPart(0x20, 0x28, 0x20, 0x2C, 1)
	%drawPart(0x20, 0x2C, 0x24, 0x2C, 1)
	%drawPart(0x24, 0x2C, 0x24, 0x28, 1)
	%drawPart(0x24, 0x28, 0x20, 0x28, 1)
	#Camera Boundary render 
	#blue 
	lis r0, 0x0000
	ori r0, r0, 0xFFFF
	stw r0, 0x8(r1)

	lfs f1, 0x0(r30)
	lfs f2, 0x20(r30)
	fadds f1, f1, f2
	stfs f1, 0x20(r1)
	lfs f1, 0x4(r30)
	lfs f2, 0x20(r30)
	fadds f1, f1, f2
	stfs f1, 0x24(r1)
	lfs f1, 0x8(r30)
	lfs f2, 0x24(r30)
	fadds f1, f1, f2
	stfs f1, 0x28(r1)
	lfs f1, 0xC(r30)
	lfs f2, 0x24(r30)
	fadds f1, f1, f2
	stfs f1, 0x2C(r1)

	%drawPart(0x20, 0x28, 0x20, 0x2C, 1)
	%drawPart(0x20, 0x2C, 0x24, 0x2C, 1)
	%drawPart(0x24, 0x2C, 0x24, 0x28, 1)
	%drawPart(0x24, 0x28, 0x20, 0x28, 1)

	li r30, 0
charLoop:
	mr r3, r31
	addi r4, r1, 0x20
	mr r5, r30
	lis r12, 0x8092
	ori r12, r12, 0xDE30
	mtctr r12
	bctrl

	%drawPoint(0x20, 0x4040, 0x0000D0FF)

	mr r3, r31
	addi r4, r1, 0x20
	mr r5, r30
	lis r12, 0x8092
	ori r12, r12, 0xDE6C
	mtctr r12
	bctrl

	%drawPoint(0x20, 0x4040, 0x00A0A0FF)

	addi r30, r30, 1
	cmpwi r30, 4
	blt charLoop


	#print char action data
	lis r3, 0x80b8
    lwz r3, 0x7C28(r3)
	lis r12, 0x8054
	ori r12, r12, 0x1FC0
	mtctr r12
	bctrl
end:
	lwz r0, 0x0044(r1)
	lwz r31, 0x0040(r1)
	lwz r30, 0x003C(r1)
	mtlr r0
	addi r1, r1, 0x40
	blr 

}

renderDebug/[grGimmick]
HOOK @ $80978840
{
	stwu r1, -0x0010 (r1)
	mflr r0
	stw r0, 0x14(r1)
	stw r31, 0x0C(r1)
	mr r31, r3
	lis r12, 0x8096
	ori r12, r12, 0xB334
	mtctr 12 
	bctrl
	lwz r0, 0x14(r1)
	lwz r31, 0x0C(r1)
	mtlr r0
	addi r1, r1, 16
	blr	

}

gfAreaManager


#getAreaColour
HOOK @ $80541FD0
{
	stwu r1, -0x10(r1)
	mflr r0
	stw r0, 0x14(r1)
	stw r31, 0x8(r1)
	mr r31, r3
	li r3, 9
	lis r12, 0x8054
	ori r12, r12, 0x1F9C
	mtctr r12
	bctrl
	cmpwi r3, 0
	beq dontDraw
	mr r5, r3
	lwz r4, 0x8(r31)
	li r6, 1
	slw r6, r6, r5
	and. r0, r4, r6
	bne listener
	lbz r6, 0x1D(r31)
	cmpw r5, r6
	beq presenter
dontDraw:
	li r3, 0
	b end
listener:
	lis r3, 0x00AA
	ori r3, r3, 0xAAFF
	b end
presenter:
	lis r3, 0x0 
	ori r3, r3, 0xFFFF
end:
	lwz r31, 0x8(r1)
	lwz r0, 0x14(r1)
	mtlr r0
	addi r1, r1, 0x10
	blr
}

#debug check
HOOK @ $80012908
{
	li r3, 9
	lis r12, 0x8054
	ori r12, r12, 0x1F9C
	mtctr r12
	bctrl
	cmpwi r3, 0
	mr r3, r31
}

####
#rectangles
####
#for "off" boxes
#set "off" colour to transparent, catch this is renderer
word 0x00000000 @ $8059ff8c
#gfAreaRect
CODE @ $8001146C
{
	stw r3, 0x8(r1)
	lis r12, 0x8054
	ori r12, r12, 0x1FD0
	mtctr r12
	bctrl
	stw r3, 0xC(r1)
	lwz r3, 0x8(r1)
	addi r3, r3, 0x2C
	addi r4, r1, 0xC
	li r5, 1
	lfs f1, -0x7F80(r2)
	nop 
}
#gfAreaCircle
CODE @ $80011798
{
	lis r12, 0x8054
	ori r12, r12, 0x1FD0
	mtctr r12
	bctrl
	stw r3, 0xC(r1)

	addi r3, r1, 0x10
	addi r4, r1, 0xC
	li r5, 1
	lfs f1, -0x7F80(r2)
	nop 
	nop 
	nop 
}
#gfAreaTriangle
CODE @ $80011BC8
{
	lis r12, 0x8054
	ori r12, r12, 0x1FD0
	mtctr r12
	bctrl
	stw r3, 0xC(r1)

	addi r3, r1, 0x10
	addi r4, r1, 0xC
	li r5, 1
	lfs f1, -0x7F80(r2)
	nop 
	nop 
	nop 
}



/*
0 = nop?, empty presenter used by boxes that dont outwardly state their function
1 = surrounds ecb, unknown purpose
2 = footstool event
3 = under feat in air
4 = item grabbox presented action? if an item wants to know if in range? no items have the counterpart afaik
5 = eatbox (17) presented action, same as above
6 =
7 =
8 = 
9 = surrounds ecb of all subspace enemies
10 = unk 
11 = subspace ai controller logic? theres a tonne of presenters on each primid + surrounding entire stage
12 =  
13 = 
14 = footstoolbox for subspace enemies e.g. koopas/goombas
15 = 
16 = 
17 = kirby/wario/dedede item "eatbox", also used for shell item bounce e.g. autofootstol. also on all items even if not edible/jumpable
18 = small item
19 = large item
20 = unk 
21 = doors/subspace springs/Catapult/barrel
22 = ladder
23 = elevator
24 = unk,
25 = surrounds ecb 
26 = whispy wind, gravity changer etc + aesthetic wind.
27 = conveyor
28 = water 
29 = Dedede Waddle grab range 
30 = surrounds ecb
31 = spring

#0x8  target group
#0xC  target local group
#0x14 team id
*/

clCircle draws perimeter instead of area [Eon]

op li r3, 0xB0 @ $80041748 #change from filled in area to line strip
op li r5, 17 @ $80041750
HOOK @ $80041758
{
	li r0, 17
	addi r4, r1, 0x34
	mtctr r0
top:
	lfs f0, 0x0(r4)
	lfs f1, 0x4(r4)
	lfs f2, 0x8(r4)
	stfs f0, -0x8000(r3)
	stfs f1, -0x8000(r3)
	stfs f2, -0x8000(r3)
	stw r30, -0x8000(r3)
	addi r4, r4, 0xC
	bdnz top
	lis r12, 0x8004
	ori r12, r12, 0x1818
	mtctr r12
	bctr
}