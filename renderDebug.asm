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