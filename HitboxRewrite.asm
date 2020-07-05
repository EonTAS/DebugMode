Draw Capsule [Eon, Masahiro Sakurai, Unpaid intern 3]
#DisplayBubble(Double Radius, Float[3][4] ScaleMatrix, Float[3] Pos1, Float[3] Pos2, Byte[4] Colour1, Byte[4] Colour2, Float[3][4] ViewingMatrix)
.macro callFunc(<addr>) 
{
.alias temp_Hi = <addr> / 0x10000
.alias temp_Lo = <addr> & 0xFFFF
  lis r12, temp_Hi
  ori r12, r12, temp_Lo
  mtctr r12
  bctrl	
}
#GX Functions
.macro GXClearVtxDesc() 
{
	%callFunc(0x801efb10)
}
.macro GXSetArray()
{
	%callFunc(0x801f0208)
}
.macro GXSetVtxDesc()
{
	%callFunc(0x801ef280)
}
.macro GXSetVtxAttrFmt()
{
	%callFunc(0x801efb44)
}
.macro GXLoadPosMtxImm()
{
	%callFunc(0x801f51dc)
}
.macro GXLoadNrmMtxImm()
{
	%callFunc(0x801f5258)
}
.macro GXCallDisplayList()
{
	%callFunc(0x801f4eac)
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
.macro GXSetTevColorIn()
{
	%callFunc(0x801f3c30)
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
.macro GXSetChanCtrl()
{
	%callFunc(0x801f2668)
}
.macro GXSetCullMode()
{
	%callFunc(0x801f136c)
}

#PSMTX Functions
.macro PSMTXInverse()
{
	%callFunc(0x801ec41c)
}
.macro PSMTXMultVec()
{
	%callFunc(0x801ecd70)
}
.macro PSMTXScale()
{
	%callFunc(0x801ec8b4)
}
.macro PSMTXIdentity()
{
	%callFunc(0x801ec158)
}
.macro PSMTXConcat()
{
	%callFunc(0x801ec1b8)
}
.macro PSMTXCopy()
{
	%callFunc(0x801ec184)
}
.macro PSMTXTrans()
{
	%callFunc(0x801ec834)
}
#PSVEC Functions
.macro PSVECNormalize()
{
	%callFunc(0x801ed008)
}
.macro PSVECCrossProduct()
{
	%callFunc(0x801ed0b0)
}


#Generic Functions
.macro rsqrtf()
{
	%callFunc(0x8003db58)
}

HOOK @ $801F4980
{
#doubles 
.alias Radius 				= 31
.alias distance 			= 30

#ints
.alias Pos1 				= 31
.alias Pos2 				= 30
.alias ViewingMatrix 		= 29
.alias ScaleMatrix 			= 28
.alias diffPos 				= 27
.alias basis2 				= 26
.alias basis3 				= 25
.alias dataBlock 			= 24
.alias Colour1 				= 23
.alias Colour2 				= 22

#Vectors, size 0xC each
.alias diffPosOffset 		= 0x10
.alias basis2Offset 		= 0x1C
.alias basis3Offset 		= 0x28
.alias Pos1Offset 			= 0x34
.alias Pos2Offset 			= 0x40
#Matrices, size 0x30 each
.alias TempMatrixOffset 	= 0x50
.alias RadiusMatrixOffset 	= 0x80
.alias End1MatrixOffset		= 0xB0
.alias End2MatrixOffset 	= 0x80
.alias CylinderMatrixOffset = 0xE0

#dataBlock offsets 
.alias zero 				= 0x0
.alias nearZeroPositive 	= 0x4
.alias nearZeroNegative 	= 0x8
.alias minusOne 			= 0xC
.alias half 				= 0x10
.alias CylinderPosAttr		= 0x20
.alias CylinderNrmAttr		= 0x20
.alias CylinderPosList		= 0x20
.alias CylinderPosListSize	= 0xA0
.alias HemiSpherePosAttr	= 0x20
.alias HemiSphereNrmAttr	= 0x20
.alias HemiSpherePosList	= 0x20
.alias HemiSpherePosListSize= 0xA0

.macro DrawPart(<dataOffsetPosAttr>, <dataOffsetNrmAttr>, <dataOffsetPos>, <posListSize>, <matrixOffset>, VTXAttrFMTThing)
{
  	%GXClearVtxDesc()
  	li r3, 9
  	addi r4, dataBlock, <dataOffsetPosAttr> 
  	li r5, 6
  	%GXSetArray()
  	li r3, 10
  	addi r4, dataBlock, <dataOffsetNrmAttr> 
  	li r5, 6
  	%GXSetArray()
  	li r3, 9
  	li r4, 2
  	%GXSetVtxDesc()
  	li r3, 0
  	li r4, 9
  	li r5, 1
  	li r6, 3
  	li r7, 0xE
  	%GXSetVtxAttrFmt()
  	li r3, 10
  	li r4, 2
  	%GXSetVtxDesc()
  	li r3, 0
  	li r4, 10
  	li r5, 0
  	li r6, 3
  	li r7, 0xE
  	%GXSetVtxAttrFmt();
  	mr r3, ViewingMatrix
  	addi r4, r1, <matrixOffset>
  	mr r5, r4
  	%PSMTXConcat();
  	addi r3, r1, <matrixOffset>
  	li r4, 0
  	%GXLoadPosMtxImm();
  	addi r3, r1, <matrixOffset>
  	mr r4, r3
  	%PSMTXInvXpose(<matrix>,<matrix>)
  	%GXLoadNrmMtxImm(<matrix>,0)
  	addi r3, dataBlock, <dataOffsetPos> 
  	li r4, <posListSize>
  	%GXCallDisplayList();
}
	fmr Radius, f1
	mr Pos1, r4
	mr Pos2, r5
	mr ViewingMatrix, r8
	mr ScaleMatrix, r3

	addi diffPos, r1, diffPosOffset
	addi basis2, r1, basis2Offset
	addi basis3, r1, basis3Offset
	li r3, 0
	#zero all of basis2 so only required modifications occur
	stw r3, 0x0(basis2)
	stw r3, 0x4(basis2)
	stw r3, 0x8(basis2)

	lis dataBlock, 0x8000
	ori dataBlock, dataBlock, 0x8000

	mr Colour1, r6
	mr Colour2, r7

SetGXSettings:
	li r3, 1
	%GXSetColorUpdate();
	li r3, 0
	%GXSetAlphaUpdate();				
	lfs f1, zero(dataBlock) # f1 = 0
	mr f2, f1
	mr f3, f1
	mr f4, f1
	li r3, 0
	addi r4, r1, 0xC
	stw r3, 0x0(r4)
	%GXSetFog();
	lbz r3, 0x3(Colour1)
	cmpwi r3, 0xFF
	li r3, 0
	beq 0x8
	li r3, 1
	li r4, 4
	li r5, 5
	li r6, 5
	%GXSetBlendMode() 					#((uint)((*param_1)[3] != 0xff),4,5,5);
	li r3, 4
	li r4, 0
	li r5, 0
	li r6, 4
	li r7, 0
	%GXSetAlphaCompare()
	li r3, 1
	li r4, 3	
	lbz r5, 0x3(Colour1)
	cmpwi r5, 0xFF
	li r5, 1
	beq 0x8
	li r5, 0
	%GXSetZMode()						#(1,3,(uint)((*param_1)[3] == 0xff));
	li r3, 0
	%GXSetZCompLoc()
	li r3, 0
	%GXSetNumTexGens()
	li r3, 1
	%GXSetNumTevStages()
	li r3, 0
	li r4, 0xFF
	li r5, 0xFF
	li r6, 4
	%GXSetTevOrder()
	li r3, 1
	lwz r4, 0x0(Colour1)
	%GXSetTevColor()
	li r3, 0
	li r4, 0xF
	li r5, 10
	li r6, 2
	li r7, 0xF
	%GXSetTevColorIn();
	li r3, 0
	li r4, 7
	li r5, 6
	li r6, 1
	li r7, 7
	%GXSetTevAlphaIn()
	li r3, 0
	li r4, 0
	li r5, 0
	li r6, 0
	li r7, 1
	li r8, 0
	%GXSetTevColorOp();
	li r3, 0
	li r4, 0
	li r5, 0
	li r6, 0
	li r7, 1
	li r8, 0
	%GXSetTevAlphaOp()
	li r3, 1
	%GXSetNumChans();
	li r3, 4
	lwz r4, 0x0(Colour2)
	%GXSetChanAmbColor();
	li r3, 4
	li r0, -1
	addi r4, r1, 0xC
	stw r0, 0x0(r4)
	%GXSetChanMatColor()
	li r3, 4
	li r4, 1
	li r5, 0
	li r6, 0
	li r7, 1
	li r8, 2
	li r9, 2

	lbz r0, 0x3(Colour1)
	cmpwi r0, 0xFF
	beq 0xC
	li r4, 0
	li r8, 0
	%GXSetChanCtrl()


	li r3, 2
  	%GXSetCullMode()
startShapeConstruction:
  	#scaleMatrix subtracts position and removes scale stuff to be reapplied later
  	mr r3, ScaleMatrix
  	addi r4, r1, TempMatrixOffset
  	%PSMTXInverse()

  	addi r3, r1, TempMatrixOffset
  	mr r5, Pos1
  	addi r5, r1, Pos1Offset
  	mr Pos1, r5
  	%PSMTXMultVec()
  	addi r3, r1, TempMatrixOffset
  	mr r5, Pos2
  	addi r5, r1, Pos2Offset
  	mr Pos2, r5
  	%PSMTXMultVec()

	fmr f1, Radius
	fmr f2, Radius
	fmr f3, Radius
	addi r3, r1, RadiusMatrixOffset
  	%PSMTXScale()

  	#get diff in positions
  	lfs f1, 0x0(Pos2)
  	lfs f2, 0x0(Pos1)
  	fsubs f3, f2, f1
  	stfs f3, 0x0(diffPos)

  	lfs f1, 0x4(Pos2)
  	lfs f2, 0x4(Pos1)
  	fsubs f4, f2, f1
  	stfs f4, 0x4(diffPos)

  	lfs f1, 0x8(Pos2)
  	lfs f2, 0x8(Pos1)
  	fsubs f5, f2, f1
  	stfs f5, 0x8(diffPos)

  	fmulls f1, f3, f3
  	fmulls f2, f4, f4
  	fadds f1, f1, f2
  	fmulls f2, f5, f5
  	fadds f1, f1, f2
  	fmr distance, f1
  	%rsqrtf()
  	fmulls distance, distance, f1

checkDistanceZero:
	#if absolute distance is neglibly small, draw a sphere
	lfs f1, nearZeroPositive(dataBlock) #0.000000001
	lfs f2, nearZeroNegative(dataBlock) #-0.000000001
	fcmpo cr0, distance, f1
	blt drawSphere
	fcmpo cr0, distance, f2
	bgt drawSphere

	#set basis2 to perpendicular of diffPos
	lfs f0, minusOne(dataBlock) #-1
	fmulls f0, f0, f3
	stfs f0, 0x4(basis2)
	stfs f4, 0x0(basis2)

	#if each individual distance is negligibly small, draw a sphere (unsure if this is needed, i think this is melee devs being dumb)
	fcmpo cr0, f3, f1
	bgt drawCapsule
	fcmpo cr0, f3, f2
	blt drawCapsule	
	fcmpo cr0, f4, f1
	bgt drawCapsule
	fcmpo cr0, f4, f2
	blt drawCapsule
	#both X and Y are zero, so to get a perpendicular basis, set X to positive
	stfs f5, 0x0(basis2)
	li r0, 0
	stw r0, 0x4(basis2)

	fcmpo cr0, f5, f1
	bgt drawCapsule
	fcmpo cr0, f5, f2
	blt drawCapsule
drawSphere:
	addi r3, r1, End1MatrixOffset
	%PSMTXIdentity()
	addi r3, r1, End1MatrixOffset
	lis r4, 0xDF80
	stw r4, 0x0(r3)
	stw r4, 0x28(r3)
	addi r4, r1, RadiusMatrixOffset
	mr r5, r3
	%PSMTXConcat()
	#addi r3, r1, RadiusMatrixOffset
	#addi r4, r1, End2MatrixOffset
	#%PSMTXCopy()
	b DrawSphereEnds

drawCapsule:
	fmr f1, distance
	fmr f2, Radius
	fmr f3, Radius
	addi r3, r1, CylinderMatrixOffset
	%PSMTXScale()

	mr r3, diffPos
	mr r4, diffPos
	%PSVECNormalize()
	mr r3, basis2
	mr r4, basis2
	%PSVECNormalize()
	mr r3, diffPos
	mr r4, basis2
	mr r5, basis3
	%PSVECCrossProduct()
	

	#tempMatrix = 
	#diffPos[0], basis2[0], basis3[0], 0
	#diffPos[1], basis2[1], basis3[1], 0
	#diffPos[2], basis2[2], basis3[2], 0
	addi r3, r1, TempMatrixOffset

	lwz r4, 0x0(diffPos)
	stw r4, 0x0(r3)
	lwz r4, 0x0(basis2)
	stw r4, 0x4(r3)
	lwz r4, 0x0(basis3)
	stw r4, 0x8(r3)

	lwz r4, 0x4(diffPos)
	stw r4, 0x10(r3)
	lwz r4, 0x4(basis2)
	stw r4, 0x14(r3)
	lwz r4, 0x4(basis3)
	stw r4, 0x18(r3)

	lwz r4, 0x8(diffPos)
	stw r4, 0x20(r3)
	lwz r4, 0x8(basis2)
	stw r4, 0x24(r3)
	lwz r4, 0x8(basis3)
	stw r4, 0x28(r3)

	li r4, 0
	stw r4, 0xC(r3)
	stw r4, 0x1C(r3)
	stw r4, 0x2C(r3)

	addi r4, r1, RadiusMatrixOffset
	addi r5, r1, End1MatrixOffset
	%PSMTXConcat()
	addi r3, r1, TempMatrixOffset
	addi r4, r1, CylinderMatrixOffset
	mr r5, r4
	%PSMTXConcat()
	#tempMatrix = 
	#-diffPos[0], basis2[0], -basis3[0], 0
	#-diffPos[1], basis2[1], -basis3[1], 0
	#-diffPos[2], basis2[2], -basis3[2], 0
	addi r3, r1, TempMatrixOffset
	#invert diffPos
	lwz r4, 0x0(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x0(r3)
	lwz r4, 0x10(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x10(r3)
	lwz r4, 0x20(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x20(r3)
	#invert basis3
	lwz r4, 0x8(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x8(r3)
	lwz r4, 0x18(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x18(r3)
	lwz r4, 0x28(r3)
	xoris r4, r4, 0x8000
	stw r4, 0x28(r3)

	addi r4, r1, RadiusMatrixOffset
	addi r5, r1, End2MatrixOffset
	%PSMTXConcat()

	#Draw Cylinder
	lfs f1, 0x0(Pos1)
	lfs f0, 0x0(Pos2)
	fadds f1, f0, f1
	lfs f2, 0x4(Pos1)
	lfs f0, 0x4(Pos2)
	fadds f2, f0, f3
	lfs f3, 0x8(Pos1)
	lfs f0, 0x8(Pos2)
	fadds f3, f0, f3
	lfs f0, half(dataBlock) #0.5
	fmulls f1, f1, f0
	fmulls f2, f2, f0
	fmulls f3, f3, f0
	addi r3, r1, TempMatrixOffset
	%PSMTXTrans()
	addi r3, r1, TempMatrixOffset
	addi r4, r1, CylinderMatrixOffset
	mr r5, r4
	%PSMTXConcat()
	mr r3, ScaleMatrix
	addi r5, r1, CylinderMatrixOffset
	%PSMTXConcat()

  	%DrawPart(CylinderPosAttr, CylinderNrmAttr, CylinderPosList, CylinderPosListSize, CylinderMatrixOffset, 0x6)

DrawSphereEnds:
	lfs f1, 0x0(Pos1)
	lfs f2, 0x4(Pos1)
	lfs f3, 0x8(Pos1)
	addi r3, r1, TempMatrixOffset
	%PSMTXTrans()
	addi r3, r1, TempMatrixOffset
	addi r4, r1, End1MatrixOffset
	mr r5, r4
	%PSMTXConcat()
	mr r3, ScaleMatrix
	addi r5, r1, End1MatrixOffset
	%PSMTXConcat()

	lfs f1, 0x0(Pos2)
	lfs f2, 0x4(Pos2)
	lfs f3, 0x8(Pos2)
	addi r3, r1, TempMatrixOffset
	%PSMTXTrans()
	addi r3, r1, TempMatrixOffset
	addi r4, r1, End2MatrixOffset
	mr r5, r4
	%PSMTXConcat()
	mr r3, ScaleMatrix
	addi r5, r1, End2MatrixOffset
	%PSMTXConcat()

  	%DrawPart(HemiSpherePosAttr, HemiSphereNrmAttr, HemiSpherePosList, HemiSpherePosListSize, End1MatrixOffset, 0xE)
  	%DrawPart(HemiSpherePosAttr, HemiSphereNrmAttr, HemiSpherePosList, HemiSpherePosListSize, End2MatrixOffset, 0xE)
  	
}

DebugFileLoader [Eon]
	.PO<-FileLoader
	.BA<-FileName
	54010000 00000000 #Write BA to PO, aka write address of Filename to the FileLoader chunk
    .GOTO->LoadFile
FileName:
    string "/../Debug/sphere.bin"
FileLoader:
	word 0; #File Path Address, loaded by gecko above
	word 0;
	word 0;
	word 0x80577060; #Address Where the file is loaded to
	word 0;
LoadFile:

HOOK @ $800B08A0
{
	mflr r0 			#backup link register
	bl 0x4 				#\get Address of current execution
	mflr r3 			#/
	mtlr r0 			#return original link register
	subi r3, r3, 0x28 	#r3 = FileLoader

	lwz r4, 0xC(r3) 	#address where file is to be loaded
	lwz r4, 0x0(r4) 	#beginning of file loaded 
	cmpwi r4, 0 		#if beginning has data, exit 
	bnelr
	lis r0, 0x8001    	#readFile
	ori r0, r0, 0xBF0C
	mtctr r0          
	bctr
}