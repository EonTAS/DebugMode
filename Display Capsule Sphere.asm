Display/[clCapsule/clSphere]
.macro callFunc(<addr>)
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
.macro PSMTXIdentity()
{
	%callFunc(0x801EC158)
}
.macro PSMTXTrans()
{
	%callFunc(0x801EC834)
}
.macro PSMTXConcat()
{
	%callFunc(0x801EC1B8)
}
.macro PSMTXScale()
{
	%callFunc(0x801ec8b4)
}
.macro PSMTXRotRad()
{
	%callFunc(0x801ec5dc)
}
.macro GXLoadPosMtxImm()
{
	%callFunc(0x801f51dc)
}
.macro GXSetCurrentMtx()
{
	%callFunc(0x801f52e4)
}
.macro GXDrawSphere()
{
	%callFunc(0x801f4980)
}
.macro GXSetColorUpdate()
{
	%callFunc(0x801f471c)
}
.macro GXSetAlphaUpdate()
{
	%callFunc(0x801f4748)
}
.macro GXSetFog()
{
	%callFunc(0x801f421c)
}
.macro GXSetBlendMode()
{
	%callFunc(0x801f46cc)
}
.macro GXSetAlphaCompare()
{
	%callFunc(0x801f3fd8)
}
.macro GXSetZMode()
{
	%callFunc(0x801f4774)
}
.macro GXSetZCompLoc()
{
	%callFunc(0x801f47a8)
}
.macro GXSetNumTexGens()
{
	%callFunc(0x801f0480)
}
.macro GXSetNumTevStages()
{
	%callFunc(0x801f41f8)
}
.macro GXSetTevOrder()
{
	%callFunc(0x801f409c)
}
.macro GXSetTevColor()
{
	%callFunc(0x801f3d60)
}
.macro GXSetColorIn()
{
	%callFunc(0x801f3c30)
}
.macro GXSetTevAlphaIn()
{
	%callFunc(0x801f3c70)
}
.macro GXSetTevColorOp()
{
	%callFunc(0x801f3cb0)
}
.macro GXSetTevAlphaOp()
{
	%callFunc(0x801f3d08)
}
.macro GXSetNumChans()
{
	%callFunc(0x801f2644)
}
.macro GXSetChanAmbColor()
{
	%callFunc(0x801f2494)
}
.macro GXSetChanMatColor()
{
	%callFunc(0x801f256c)
}
.macro GXSetChanMatCtrl()
{
	%callFunc(0x801f2668)
}
.macro PSMTXInverse()
{
	%callFunc(0x801ec41c)
}
.macro PSMTXMultVec()
{
	%callFunc(0x801ecd70)
}
.macro PSVECMag()
{
	%callFunc(0x801ed04c)
}
.macro PSVECNormalize()
{
	%callFunc(0x801ed008)
}
.macro PSVECCrossProduct()
{
	%callFunc(0x801ED0B0)
}
.macro PSVECDotProduct()
{
	%callFunc(0x801ed090)
}
#display/[clCapsule]
HOOK @ $8070d2a8
{
.alias tempMatrix1 = 27
.alias tempMatrix2 = 26
.alias tempMatrix3 = 24
.alias Capsule = 28
.alias Capsule.x1 = 0x0
.alias Capsule.y1 = 0x4
.alias Capsule.z1 = 0x8	
.alias Capsule.x2 = 0x34
.alias Capsule.y2 = 0x38
.alias Capsule.z2 = 0x3C
.alias Capsule.r = 0xC 
.alias Capsule.scaleMatrix = 0x40
.alias Capsule.scaleX = 0x70
.alias Capsule.scaleY = 0x74
.alias Capsule.scaleZ = 0x78
.alias CamMatrix = 29
.alias Colour1 = 30
.alias Colour2 = 31
.alias offset = 25
.alias offset.x = 0x0
.alias offset.y = 0x4 
.alias offset.z = 0x8

	stwu r1, -0x100(r1)
	mflr r0
	stw r0, 0x104(r1)
	stw r31, 0x10(r1)
	stw r30, 0x14(r1)
	stw r29, 0x18(r1)
	stw r28, 0x20(r1)
	stw r27, 0x24(r1)
	stw r26, 0x28(r1)
	stw r25, 0x30(r1)
	stw r24, 0x34(r1)
	mr Capsule, r3
	mr CamMatrix, r4
	mr Colour1, r5
	mr Colour2, r6
	addi tempMatrix1, r1, 0x50
	addi tempMatrix2, r1, 0x80
	addi tempMatrix3, r1, 0xB0
	addi offset, r1, 0x40 


	lfs f1, Capsule.x1(Capsule)
	lfs f2, Capsule.y1(Capsule)
	lfs f3, Capsule.z1(Capsule)
	lfs f4, Capsule.x2(Capsule)
	lfs f5, Capsule.y2(Capsule)
	lfs f6, Capsule.z2(Capsule)
	fsubs f1, f4, f1
	fsubs f2, f5, f2
	fsubs f3, f6, f3
	stfs f1, offset.x(offset)
	stfs f2, offset.y(offset)
	stfs f3, offset.z(offset)


	mr r3, tempMatrix2
	%PSMTXIdentity()
	lwz r12, 0x30(r28)
	lwz r12, 0xC(r12)
	mtctr r12
	bctrl 
	cmpwi r3, 1
	bne skipScaling
	lfs f1, Capsule.scaleX(Capsule)
	lfs f2, Capsule.scaleY(Capsule)
	lfs f3, Capsule.scaleZ(Capsule)
	mr r3, tempMatrix2
	%PSMTXScale()
skipScaling:
	lfs f1, Capsule.r(Capsule)
	lfs f2, Capsule.r(Capsule)
	lfs f3, Capsule.r(Capsule)
	mr r3, tempMatrix1
	%PSMTXScale()
	mr r3, tempMatrix2
	mr r4, tempMatrix1
	mr r5, tempMatrix1
	%PSMTXConcat()

	mr r3, tempMatrix1
	mr r4, tempMatrix2
	%PSMTXInverse()
	mr r3, tempMatrix2
	mr r4, offset
	mr r5, offset
	%PSMTXMultVec()

	mr r3, offset
	%PSVECMag()
	fsubs f0, f1, f1
	fcmpo cr0, f1, f0
	ble skipRotation

	#if coincident with the y-axis, then logic below doesnt work, so checking if x or z != 0
	lfs f1, 0x0(offset)
	fcmpo cr0, f1, f0 
	bne rotateSafe
	lfs f1, 0x8(offset)
	fcmpo cr0, f1, f0 
	bne rotateSafe

	#if coincident with the y-axis, then logic below doesnt work.
	lfs f1, 0x4(offset)
	fcmpo cr0, f1, f0 
	bge skipRotation #if pointing upwards, no need to transform
	#else flip y-scale
	lfs f1, 0x14(tempMatrix1)
	fsubs f1, f0, f1
	stfs f1, 0x14(tempMatrix1)
	b skipRotation

rotateSafe:
	#tempMatrix2 = from 
	#tempMatrix3 = to 

	#rotation logic from here
	#https://math.stackexchange.com/a/2470436
	mr r3, offset
	addi r4, tempMatrix3, 0x0
	%PSVECNormalize()

	lis r0, 0x3F80
	stw r0, 0x04(tempMatrix2)
	li r0, 0
	stw r0, 0x00(tempMatrix2)
	stw r0, 0x08(tempMatrix2)
	#tidying of the matrices
	stw r0, 0x0C(tempMatrix2)
	stw r0, 0x1C(tempMatrix2)
	stw r0, 0x2C(tempMatrix2)
	stw r0, 0x0C(tempMatrix3)
	stw r0, 0x1C(tempMatrix3)
	stw r0, 0x2C(tempMatrix3)

	addi r3, tempMatrix2, 0x0
	addi r4, tempMatrix3, 0x0
	addi r5, tempMatrix2, 0x10
	%PSVECCrossProduct()
	addi r3, tempMatrix2, 0x10 
	addi r4, tempMatrix2, 0x10
	%PSVECNormalize()
	addi r3, tempMatrix2, 0x10 
	addi r4, tempMatrix3, 0x10
	%PSVECNormalize()
	addi r3, tempMatrix2, 0x0
	addi r4, tempMatrix2, 0x10
	addi r5, tempMatrix2, 0x20
	%PSVECCrossProduct()
	addi r3, tempMatrix3, 0x0
	addi r4, tempMatrix3, 0x10
	addi r5, tempMatrix3, 0x20
	%PSVECCrossProduct()
	lfs f2, 0x4(tempMatrix3)
	lfs f3, 0x10(tempMatrix3)
	stfs f3, 0x4(tempMatrix3)
	stfs f2, 0x10(tempMatrix3)
	lfs f2, 0x8(tempMatrix3)
	lfs f3, 0x20(tempMatrix3)
	stfs f3, 0x8(tempMatrix3)
	stfs f2, 0x20(tempMatrix3)
	lfs f2, 0x18(tempMatrix3)
	lfs f3, 0x24(tempMatrix3)
	stfs f3, 0x18(tempMatrix3)
	stfs f2, 0x24(tempMatrix3)
	mr r3, tempMatrix3
	mr r4, tempMatrix2
	mr r5, tempMatrix2
	%PSMTXConcat()
	mr r3, tempMatrix2
	mr r4, tempMatrix1
	mr r5, tempMatrix1
	%PSMTXConcat()
skipRotation:
	

	lfs f1, Capsule.x1(Capsule)
	lfs f2, Capsule.y1(Capsule)
	lfs f3, Capsule.z1(Capsule)
	mr r3, tempMatrix2
	%PSMTXTrans()
	mr r3, tempMatrix2
	mr r4, tempMatrix1
	mr r5, tempMatrix1
	%PSMTXConcat()
	mr r3, CamMatrix
	mr r4, tempMatrix1
	mr r5, tempMatrix1
	%PSMTXConcat()
	mr r3, tempMatrix1
	li r4, 3
	%GXLoadPosMtxImm()
	li r3, 3
	%GXSetCurrentMtx()
	mr r3, offset
	%PSVECMag()
	li r3, 0xF
	li r4, 0x20
	lwz r5, 0(Colour1)
	lwz r6, 0(Colour2)

	%GXDrawSphere()

	#mr r3, Capsule
	#mr r4, CamMatrix
	#mr r5, Colour1
	#mr r6, Colour2
	#lis r12, 0x8070
	#ori r12, r12, 0xDE4C 
	#mtctr r12
	#bctrl

	lwz r31, 0x10(r1)
	lwz r30, 0x14(r1)
	lwz r29, 0x18(r1)
	lwz r28, 0x20(r1)
	lwz r27, 0x24(r1)
	lwz r26, 0x28(r1)
	lwz r25, 0x30(r1)
	stw r24, 0x34(r1)
	lwz r0, 0x104(r1)
	mtlr r0
	addi r1, r1, 0x100
	blr

}

#display/[clSphere]
HOOK @ $8070de4c
{

	lis r12, 0x8070
	ori r12, r12, 0xd2a8
	mtctr r12
	bctr
}