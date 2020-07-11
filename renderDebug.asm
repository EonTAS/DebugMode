Set Cull Mode within default colour drawer [Eon]
HOOK @ $8001a79C
{
	li r3, 0
	lis r12, 0x801f
	ori r12, r12, 0x136c
	mtctr r12
	bctrl
	lwz r0, 0x24(r1)
}

Custom RenderDebug Call
.alias ProcessPosition = 0
HOOK @ $8002DD24
{
	ble %end%
	cmplwi r0, 8
	bgtlr 
	lwz r12, 0x3C(r3)
	lwz r12, 0x58(r12)
	mtctr r12
	bctr
}
op cmpwi r29, 17 @ $8002e684

HOOK @ $8002E62C
{
	cmplwi r29, ProcessPosition
	beq %end%
	rlwinm. r0, r0, 31,31,31
}
HOOK @ $8002E604
{
	cmplwi r29, ProcessPosition
	beq %end%
	rlwinm. r0, r3, 27,31,31
}

HOOK @ $8002e610
{
	cmplwi r29, ProcessPosition
	mr r4, r29
	blt %end%
	li r4, 16
	beq %end%
	subi r4, r29, 1
}
HOOK @ $8002e638
{
	cmplwi r29, ProcessPosition
	mr r4, r29
	blt %end%
	li r4, 16
	beq %end%
	subi r4, r29, 1
}
#HOOK @ $8002DC74
#{
#	cmplwi r4, ProcessPosition
#	blt end
#	li r4, 16
#	beq end
#	subi r4, r4, 1
#end:
#	cmpwi r4, 8	
#}
Frame Advance Convert
HOOK @ $8002E5C4
{
	cmpwi r0, 2
	bne original
DebugPause:
#	cmpwi r26, 0
#	beq %end%
	cmpwi r29, 0
	beq %end%
original:
	slw. r0, r31, r29
}
#testCode
#.alias dpl = 0x0001
#.alias dpr = 0x0002
#.alias dpd = 0x0004
#.alias dpu = 0x0008
#.alias   z = 0x0010
#.alias   r = 0x0020
#.alias   l = 0x0040
#.alias  na = 0x0080
#.alias   a = 0x0100
#.alias   b = 0x0200
#.alias   x = 0x0400
#.alias   y = 0x0800
#.alias   s = 0x1000
#.alias debuginput = l || 0x1
#
#CODE @ $8000000
#{
#    word debuginput
#}


drawQuadOutline [Eon]
.macro callfunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $80541FB4 
{
    stwu r1, -0x50(r1)
    mflr r0
    stw r0, 0x54(r1)
    stfd f31, 0x20(r1)
    stfd f30, 0x28(r1)
	word 0xf3e10030; //    psq_st p31, 0x30(r1), 0, qr0
	word 0xf3c10040; //    psq_st p30, 0x40(r1), 0, qr0
    fmr f30, f1
	fmr f31, f2
    stw r31, 0x1C(r1)
    mr r31, r4
    stw r30, 0x18(r1)
    mr r30, r5
    stw r29, 0x14(r1)
    mr r29, r3


    %callfunc(0x80019FA4)
    %callfunc(0x80018DE4)
    lwz r31, 0(r31)
    %callfunc(0x8001A5C0)

	#convert line width as double into line width as integer
	lfs f0, -0x7B68(r2)
	fmuls f0, f0, f30
	fctiwz f0, f0
	stfd f0, 0x8(r1)
	lwz r3, 0xC(r1)
	rlwinm r3, r3, 0, 24, 31
	
	li r4, 2
	%callfunc(0x801f12ac)

	 

    li r3, 0xB0 #line strip
    li r4, 1
    li r5, 5 #4 vertices
    %callfunc(0x801F1088)
    lis r3, 0xCC01 #gfx mem-loc

.macro drawVertex(<offset>) 
{
	lfs f0, <offset>(r29)
	lfs f1, <offset>+0x4(r29)
	
    stfs f0, -0x8000(r3) #x
    stfs f1, -0x8000(r3) #y
	stfs f31, -0x8000(r3)  #z

    stw r31, -0x8000(r3) #colour
}
	
	#v0
	%drawVertex(0x00)
	#v1
	%drawVertex(0x8)
	#v2
	%drawVertex(0x10)
	#v3
	%drawVertex(0x18)
	#v0
	%drawVertex(0x00)

	#draws lines attaching each point

    lfd f31, 0x20(r1)
    lfd f30, 0x28(r1)
	word 0xe3e10030; //    psq_l p31, 0x30(r1), 0, qr0
	word 0xe3c10040; //    psq_l p30, 0x40(r1), 0, qr0

    lwz r0, 0x54(r1)
    lwz r31, 0x1C(r1)
    lwz r30, 0x18(r1)
    lwz r29, 0x14(r1)
    mtlr r0
    addi r1, r1, 0x50
    blr 
}
drawLine3D [Eon]
.macro callfunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
HOOK @ $80541fb8 
{
    stwu r1, -0x50(r1)
    mflr r0
    stw r0, 0x54(r1)
    stfd f31, 0x20(r1)
	word 0xf3e10030; //    psq_st p31, 0x30(r1), 0, qr0
    fmr f31, f1



    stw r31, 0x1C(r1) #pos1
    mr r31, r3
    stw r30, 0x18(r1) #pos2
    mr r30, r4
    stw r29, 0x14(r1) #colour
	lwz r29, 0x0(r5)

	stw r28, 0x10(r1) #zmode
	mr r28, r6


    %callfunc(0x80019FA4)
    %callfunc(0x80018DE4)
    %callfunc(0x8001A5C0)

	#convert line width as double into line width as integer
	lfs f0, -0x7B68(r2)
	fmuls f0, f0, f31
	fctiwz f0, f0
	stfd f0, 0x8(r1)
	lwz r3, 0xC(r1)
	rlwinm r3, r3, 0, 24, 31
	
	li r4, 2
	%callfunc(0x801f12ac)

	 

    li r3, 0xA8 #line
    li r4, 1
    li r5, 2 #2 vertices
    %callfunc(0x801F1088)
    lis r3, 0xCC01 #gfx mem-loc

.macro drawVertex(<arg>) 
{
	lfs f0, 0x0(<arg>)
	lfs f1, 0x4(<arg>)
	lfs f2, 0x8(<arg>)
    stfs f0, -0x8000(r3) #x
    stfs f1, -0x8000(r3) #y
	stfs f2, -0x8000(r3)  #z

    stw r29, -0x8000(r3) #colour
}
	
	#v0
	%drawVertex(31)
	#v1
	%drawVertex(30)

	#draws line attaching each point

    lfd f31, 0x20(r1)
	word 0xe3e10030; //    psq_l p31, 0x30(r1), 0, qr0

    lwz r0, 0x54(r1)
    lwz r31, 0x1C(r1)
    lwz r30, 0x18(r1)
    lwz r29, 0x14(r1)
    lwz r28, 0x10(r1)
    mtlr r0
    addi r1, r1, 0x50
    blr 
}
