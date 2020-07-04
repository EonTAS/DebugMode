
StressTest

word 0x1 @ $80541F90
word 0xF @ $80541F94
word 0x20 @ $80541F98
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
	addi tempMatrix1, r1, 0x50
	addi tempMatrix2, r1, 0x80
	addi tempMatrix3, r1, 0xB0


	mr r3, tempMatrix2
	%PSMTXIdentity()
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
	lis r3, 0x8054 
	lwz r4, 0x1F98(r3)
	lwz r3, 0x1F94(r3)

	%GXDrawSphere()


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


HOOK @ $8071045C
{
	bctrl 

	b start
cameraMatrix:
	blrl 
	word 0x3f800000; word 0x00000000; word 0x00000000; word 0x00000000;
	word 0x00000000; word 0x3F5DB3D0; word 0x3F000000; word 0xC1200000;
	word 0x00000000; word 0x3F000000; word 0x3F5DB3D0; word 0xC2C80000;
sphere1:
	blrl
	word 0x00000000; word 0x00000000; word 0x00000000; word 0x3F800000; 
sphere2:
	blrl
	word 0x41200000; word 0x00000000; word 0x00000000; word 0x41200000; 
sphere3:
	blrl
	word 0x3F800000; word 0x41200000; word 0x00000000; word 0x41000000; 
sphere4:
	blrl
	word 0x41200000; word 0x00000000; word 0x41200000; word 0x40C00000; 
sphere5:
	blrl
	word 0x3F800000; word 0x41500000; word 0x00000000; word 0x3F000000; 
start:
	stwu r1,-0x80(r1)	# make space for 18 registers
	stmw r20,8(r1)	# push r3-r31 onto the stack
	mflr r0
	stw r0, 0x80(r1)
	lis r31, 0x8054 
	lwz r31, 0x1F90(r31)
loop:
	bl sphere1 
	mflr r3
	bl cameraMatrix
	mflr r4

	lis r12, 0x8070 
	ori r12, r12, 0xDE4C 
	mtctr r12 
	bctrl 

	bl sphere2
	mflr r3
	bl cameraMatrix
	mflr r4
	lis r12, 0x8070 
	ori r12, r12, 0xDE4C 
	mtctr r12 
	bctrl 
	bl sphere3
	mflr r3
	bl cameraMatrix
	mflr r4
	lis r12, 0x8070 
	ori r12, r12, 0xDE4C 
	mtctr r12 
	bctrl 
	bl sphere4
	mflr r3
	bl cameraMatrix
	mflr r4
	lis r12, 0x8070 
	ori r12, r12, 0xDE4C 
	mtctr r12 
	bctrl 
	bl sphere5
	mflr r3
	bl cameraMatrix
	mflr r4
	lis r12, 0x8070 
	ori r12, r12, 0xDE4C 
	mtctr r12 
	bctrl
	subi r31, r31, 1
	cmpwi r31, 0
	bgt loop

	lwz r0, 0x80(r1)
	mtlr r0
	lmw r20, 0x8(r1)
	addi r1, r1, 0x80
}



.macro callFunc(<addr>)
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
.macro sin(<theta>)
{
	fmr f1, <theta>
	%callFunc(0x804009E0)
}
.macro cos(<theta>)
{
	fmr f1, <theta>
	%callFunc(0x804004D8)
}
.macro drawPoint(<x>, <y>, <z>, <c>)
{
	stfs <x>, -0x8000(GrRegister)
	stfs <y>, -0x8000(GrRegister)
	stfs <z>, -0x8000(GrRegister)
	stw <c>, -0x8000(GrRegister)
}
HOOK @ $801F4980
{
#int registers
.alias numMajor = 25
.alias numMinor = 26
.alias currentMajor = 28
.alias currentMinor = 27
.alias colours = 29
.alias numMinorPlusOne = 30
.alias GrRegister = 31

#float Registers
.alias currentMinorRotation = 19
.alias currentMajorRotation = 20
.alias minorScale = 24
.alias majorScale = 25
.alias radius = 26
.alias intToFloat = 28
.alias zero = 29
.alias length = 30
	stwu r1, -0x0110(r1)
	mflr r0
	stw r0, 0x0114(r1)

	word 0xDBE10100 #stfd f31, 0x0100(r1)
	word 0xF3E10108 #psq_st p31, 264(r1), 0, qr0
	word 0xDBC100F0 #stfd f30, 0x00F0(r1)
	word 0xF3C100F8	#psq_st p30, 248(r1), 0, qr0
	word 0xDBA100E0 #stfd f29, 0x00E0(r1)
	word 0xF3A100E8 #psq_st p29, 232(r1), 0, qr0
	word 0xDB8100D0 #stfd f28, 0x00D0(r1)
	word 0xF38100D8 #psq_st p28, 216(r1), 0, qr0
	word 0xDB6100C0 #stfd f27, 0x00C0(r1)
	word 0xF36100C8 #psq_st p27, 200(r1), 0, qr0
	word 0xDB4100B0 #stfd f26, 0x00B0(r1)
	word 0xF34100B8 #psq_st p26, 184(r1), 0, qr0
	word 0xDB2100A0 #stfd f25, 0x00A0(r1)
	word 0xF32100A8 #psq_st p25, 168(r1), 0, qr0
	word 0xDB010090 #stfd f24, 0x0090(r1)
	word 0xF3010098 #psq_st p24, 152(r1), 0, qr0
	word 0xDAE10080 #stfd f23, 0x0080(r1)
	word 0xF2E10088 #psq_st p23, 136(r1), 0, qr0
	word 0xDAC10070 #stfd f22, 0x0070(r1)
	word 0xF2C10078 #psq_st p22, 120(r1), 0, qr0
	word 0xDAA10060 #stfd f21, 0x0060(r1)
	word 0xF2A10068 #psq_st p21, 104(r1), 0, qr0
	word 0xDA810050 #stfd f20, 0x0050(r1)
	word 0xF2810058 #psq_st p20, 88(r1), 0, qr0
	word 0xDA610040 #stfd f19, 0x0040(r1)
	word 0xF2610048 #psq_st p19, 72(r1), 0, qr0


	addi r11, r1, 64
	%callFunc(0x803F1318)	#initialFunctionSetup

	lfs zero, -0x5A74(r2) #0
	mr numMajor, r3
	mr numMinor, r4
	addi colours, r1, 0x20
	lis r5, 0x0077
	ori r5, r5, 0x7777
	stw r5, 0x0(colours)
	stw r5, 0x4(colours)
	fmr length, f1
	lis r0, 0x4330
	stw r0, 0x0010(r1)
	stw r3, 0x0014(r1)
	lfd f0, 0x0010(r1)

	lfd f4, -0x5A60(r2)
	fsubs f3,f0,f4

	stw r0, 0x0018(r1)
	stw r4, 0x001C(r1)
	lfd f1, 0x0018(r1)
	lfs f0, -0x5A58(r2)
	
	lfs f2, -0x5A6C(r2)
	fsubs f1,f1,f4
	fdivs minorScale,f0,f1 #2pi/numMinor
	fdivs majorScale,f2,f3 #pi/numMajor	
	lfs radius, -0x5A70(r2) #radius == 1

	#%callFunc(0x8001A5C0)
	#b skipStuff

	%callFunc(0x801EFB10) # GXClearVtxDesc
	#Position
	li r3, 9
	li r4, 1
	%callFunc(0x801EF280) # GXSetVtxDesc
	#Colour
	li r3, 11
	li r4, 1
	%callFunc(0x801EF280) # GXSetVtxDesc

	#Position
	li r3, 1
	li r4, 9
	li r5, 1
	li r6, 4
	li r7, 0
	%callFunc(0x801efb44) # GXSetVtxAttrFmt
	#Colour
	li r3, 1
	li r4, 11
	li r5, 1
	li r6, 5
	li r7, 0
	%callFunc(0x801efb44) # GXSetVtxAttrFmt


	li r3, 4
	addi r4, colours, 0
	%callFunc(0x801F256C) #GXSetChanMatColor
	li r3, 4
	addi r4, colours, 4
	%callFunc(0x801F2494) #GXSetChanAmbColor
	li r3, 1
	li r4, 4
	li r5, 5
	li r6, 0
	%callFunc(0x801F46CC) #GXSetBlendMode
	li r3, 1
	li r4, 3
	li r5, 1
	%callFunc(0x801F4774) #GXSetZMode
	li r3, 0
	%callFunc(0x801F47A8) #GXSetZCompLogic
	li r3, 7 
	li r4, 0
	li r5, 1
	li r6, 7
	li r7, 0
	%callFunc(0x801F3FD8) #GXSetAlphaCompare

	li r3, 0
	li r4, 255
	li r5, 255
	li r6, 4
	%callFunc(0x801F0480) #GXSetTevOrder
	li r3, 0
	li r4, 4
	%callFunc(0x801F3B9C) #GXSetTevOp
	li r3, 1
	%callFunc(0x801F41F8) #GXSetNumTevStages
	li r3, 0
	%callFunc(0x801F3AFC) #GXSetTevDirect


	li r3, 1
	%callFunc(0x801f2644) #GXSetNumChans


	li r3, 2
	%callFunc(0x801F136C) #GXSetCullMode
	li r3, 0
	li r4, 0
	li r5, 0
	%callFunc(0x801F3F20) #GXSetTevSwapMode
	li r3, 0
	li r4, 0
	li r5, 1
	li r6, 2
	li r7, 3
	%callFunc(0x801F3F5C) #GXSetTevSwapModeTable
skipStuff:
	lfd intToFloat, -0x5A68(r2)

	addi r0, numMinor, 1
	rlwinm numMinorPlusOne, r0, 1, 0, 30 #7FFFFFFF
	li currentMajor, 0
	lis GrRegister, 0xCC01
	b outerCheck


outerStart:
		xoris r0, currentMajor, 0x8000
		stw r0, 0x0014(r1)
		lfd f0, 0x0010(r1)
		fsubs f0,f0,intToFloat 				#CurrentMajor converted to float

		fmuls currentMajorRotation,f0,majorScale
		%sin(currentMajorRotation)
		fmuls f23,radius,f1

		fadds f21,currentMajorRotation,majorScale
		%sin(f21)
		fmuls f22,radius,f1

		%cos(currentMajorRotation)
		fmr f20, f21
		fmuls f21,radius,f1

		%cos(f20)
		fmuls f20,radius,f1

		rlwinm r5, numMinorPlusOne, 0, 16, 31
		li r3, 152
		li r4, 3
		%callFunc(0x801F1088) # GXBegin
		li currentMinor, 0
		b innerCheck
innerStart:
			xoris r0, currentMinor, 0x8000 	
			stw r0, 0x001C(r1)
			lfd f0, 0x0018(r1) 		
			fsubs f0,f0,intToFloat 			#CurrentMinor converted to a float 

			fmuls currentMinorRotation,f0,minorScale 			#CurrentMinor multiplied by scale
			%cos(currentMinorRotation)
			fmr f27,f1
			%sin(currentMinorRotation)
			fmr f4,f1

			fmuls f2,f27,f22
			fmuls f0,f4,f22
			fcmpo cr0, f0, zero
			lwz r0, 0x0(colours)
			%drawPoint(2, 0, currentMajorRotation, 0)
			
			fmuls f2,f27,f23
			fmuls f0,f4,f23
			lwz r0, 0x0(colours)
			%drawPoint(2, 0, 21, 0)
innerIterate:
			addi currentMinor, currentMinor, 1
innerCheck:
			cmpw currentMinor, numMinor
			ble innerStart
outerIterate:
		addi currentMajor, currentMajor, 1
outerCheck:
		cmpw currentMajor, numMajor
		blt outerStart


	word 0xE3E10108 #psq_l p31, 264(r1), 0, qr0
	word 0xCBE10100 #lfd f31, 0x0100(r1)
	word 0xE3C100F8 #psq_l p30, 248(r1), 0, qr0
	word 0xCBC100F0 #lfd f30, 0x00F0(r1)
	word 0xE3A100E8 #psq_l p29, 232(r1), 0, qr0
	word 0xCBA100E0 #lfd f29, 0x00E0(r1)
	word 0xE38100D8 #psq_l p28, 216(r1), 0, qr0
	word 0xCB8100D0 #lfd f28, 0x00D0(r1)
	word 0xE36100C8 #psq_l p27, 200(r1), 0, qr0
	word 0xCB6100C0 #lfd f27, 0x00C0(r1)
	word 0xE34100B8 #psq_l p26, 184(r1), 0, qr0
	word 0xCB4100B0 #lfd f26, 0x00B0(r1)
	word 0xE32100A8 #psq_l p25, 168(r1), 0, qr0
	word 0xCB2100A0 #lfd f25, 0x00A0(r1)
	word 0xE3010098 #psq_l p24, 152(r1), 0, qr0
	word 0xCB010090 #lfd f24, 0x0090(r1)
	word 0xE2E10088 #psq_l p23, 136(r1), 0, qr0
	word 0xCAE10080 #lfd f23, 0x0080(r1)
	word 0xE2C10078 #psq_l p22, 120(r1), 0, qr0
	word 0xCAC10070 #lfd f22, 0x0070(r1)
	word 0xE2A10068 #psq_l p21, 104(r1), 0, qr0
	word 0xCAA10060 #lfd f21, 0x0060(r1)
	word 0xE2810058 #psq_l p20, 88(r1), 0, qr0
	word 0xCA810050 #lfd f20, 0x0050(r1)
	word 0xE2610048 #psq_l p19, 72(r1), 0, qr0


	addi r11, r1, 64
	lfd f19, 0x0040(r1)
	%callFunc(0x803F1364)
	lwz r0, 0x0114(r1)
	mtlr r0
	addi r1, r1, 272
	blr 
}