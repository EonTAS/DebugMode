
.include "source/Extras/DebugMode/Camera(unfinished).asm"
.include "source/Extras/DebugMode/Collision Manager Render Debug.asm"
.include "source/Extras/DebugMode/Hurtboxes Hitboxes.asm"
.include "source/Extras/DebugMode/renderDebug.asm"
.include "source/Extras/DebugMode/soGroundModule.asm"
.include "source/Extras/DebugMode/Capsule Renderer.asm"
.include "source/Extras/DebugMode/Stage Object.asm"
.include "source/Extras/DebugMode/Stage(unfinished).asm"
.include "source/Extras/DebugMode/Toggles.asm"
.include "source/Extras/DebugMode/StatusModule.asm"
/*
Debug Custom Things

=====
Collision Manager Render Debug
=====
drawCollisionList(collisionObject r3) - 0x80541F90
drawCollision(segmentData r3, collisionData r4) - 0x80541F94

=====
Toggles
=====
0 = display hurtboxes/hitboxes. 0 = no, 1 = hurtboxes only, 2 = body and hurtboxes
1 = stage render, 0 = no, 1 = stage + render, 2 = just render, stage cant properly be reenabled currently
2 = setting of area manager, 
3 = ecb etc draw
4 = blastzone render and stuff

====
TODO
====
Remake frame advance in a friendly way, temp method done, needs to be changed to flip 2nd bit of pause function.
	l-r-dpaddown 	= enable all toggles
	x + dpad up 	= pause
	r + dpad right 	= 1x = hurtbox visualisation on, 2x = hurtbox + bodys on
things that i have plans to complete for sure :
draw topN location when ecb draw is on (much harder than it should be)
move camera-zone, blastzone, and the area manager draws to my custom rectangle drawer function (super simple)
create better button mapping for things so that everything is useable (easy for the most part except the area manager coz its got 32 different valid states to be in atm)
integrate with code menu (mostly just chat with fracture for a bit probably)
fix point drawer for stuff to be a cross instead of a circle (not hard just effort)
tidy up files and comment everything (hopefully not bad)
tidy writing each ports current action, frame number, subaction etc to the top of the screen like melee (hard but i can see a way forward with it)
tidy drawing item spawn locations in stage renderer (not too bad just gotta find correct part)


potential steps i probably plan to do if im in the mood :
add subspace emissary trigger areas to renderer, so that speedrunners etc can see what they are dealing with in testing (just gotta find where that stuff is defined, so not too hard)
	 

fix subspace enemies - waiting for brawlcrate bugfix
better map out toggles
better stage render toggle so it can be reenabled safely
*/

#TEXT RENDERING BREAKS GRAPHICS BUT IS FIXED BY STAGE RENDERING, DONT WANT THAT
#GET FIXED CAMERA WORKING

#Relative PSA Pointers [Eon]
##sub routine override
#HOOK @ $8013B4D4
#{
#    cmpwi r0, 0
#    beq %end%
#lowCheck:
#    lis r4, 0x8000
#    cmplw r0, r4
#    blt add 
#highCheck: 
#    lis r4, 0x9800
#    cmplw r0, r4
#    blt %end%
#add:
#    add r0, r0, r3
#}
##goto override
#HOOK @ $8013B5FC
#{
#    cmpwi r0, 0
#    beq %end%
#lowCheck:
#    lis r4, 0x8000
#    cmplw r0, r4
#    blt add 
#highCheck: 
#    lis r4, 0x9800
#    cmplw r0, r4
#    blt %end%
#add:
#    add r0, r0, r3
#}
#
##arg reading 
#HOOK @ $8013CABC
#{
#    cmpwi r0, 0
#    beq %end%
#lowCheck:
#    lis r4, 0x8000
#    cmplw r0, r4
#    blt add 
#highCheck: 
#    lis r4, 0x9800
#    cmplw r0, r4
#    blt %end%
#add:
#    add r0, r0, r3
#}
##get arg offset
#HOOK @ $8013CB34
#{
#    add r4, r5, r4
#lowCheck:
#    lis r5, 0x8000
#    cmplw r4, r5
#    blt add
#highCheck:
#    lis r5, 0x9800
#    cmplw r4, r5
#    blt %end%
#add:
#    lwz r5, 0x8(r29)
#    add r4, r4, r5
#}
##get arg List
#HOOK @ $8013CBD0
#{
#    cmpwi r5, 0
#    beq %end%
#lowCheck:
#    lis r0, 0x8000
#    cmplw r5, r0
#    blt add 
#highCheck: 
#    lis r0, 0x9800
#    cmplw r5, r0
#    blt %end%
#add:
#    lwz r4, 0x8(r31)
#    add r5, r4, r5
#}
#
#Relocate Attempted Detector 
#HOOK @ $80043F30
#{
#    cmplwi r0, 0xEA60 
#    beq alert
#    li r7, 0 
#    cmpw r0, r7 
#    beq alert
#    lis r7, 0x4
#    cmplw r0, r7
#    bgt alert
#    b end
#alert:
#    nop
#end:
#    add r0, r0, r6
#}
#
#Clear Specific Transition Term Group PSA Command [Eon]
##020E0100 = Clear Specific transition term, with argument
##020E0000 = Original command, left in tact, clears all transition terms
#HOOK @ $80781F04
#{   
#    addi r3, r1, 0x138
#    lwz r12, 0x0(r3)
#    lwz r12, 0x18(r12)
#    mtctr r12
#    bctrl
#    cmpwi r3, 1
#    li r4, -1
#    beq end
#    addi r3, r1, 0x138
#    li r4, 0
#    stw r28, 0x10(r3)
#    lis r12, 0x8077
#    ori r12, r12, 0xDFDC
#    mtctr r12
#    bctrl
#    mr r4, r3
#end:
#    mr r3, r26
#    lwz r12, 0x0(r26)
#}
#
#Custom Reflectors Dont Corrupt Default settings v1.0 [Eon]
#HOOK @ $80754644
#{
#    #check if getType = reflector somehow 
#
#    mr r3, r31 #store current collision data pointer
#    #get pointer to hurtbox array
#    lwz r3, 0x1C(r28)
#    li r4, 0
#    ori r4, r4, 0xA803
#    li r5, 0
#    lis r12, 0x8079
#    ori r12, r12, 0x6E2C
#    mtctr r12
#    bctrl
#    #get specific hurtbox that should be copied
#    lwz r3, 0x0(r3)
#    mulli r4, r29, 0x20
#    add r4, r3, r4
#
#    #copy hitbox data onto original stored collision
#    mr r3, r31
#    lis r12, 0x8075
#    ori r12, r12, 0x1198
#    mtctr r12
#    bctrl
#    #adjust flags slightly coz devs weird
#    lwz r4, 0x1C(r3)
#    andis. r5, r4, 0xFF80
#    rlwimi r5, r4, 6,9,9 #(shifts 0x0001000 to 0x00040000 in flags, 0xCC810000 => 0xCCC00000)
#    stw r5, 0x1C(r3)
#    li r0, 0 # set this to either 0 or 2, dependent on franklin badge state
#    stw r0, 0x5C(r3)
#}
##Add something to approx 80751A28 that sets to 2 if franklin badge is enabled, and also resets shapes and sizes
#
#
#!Angle 0x200/0x202 and 0x201/0x203 are inwards and outwards sending autolinks, 0x202 and 0x203 are based on distance from centre and users speed [Eon]
#HOOK @ $8076B57C
#{
#    beq %end%
#    cmpwi r4, 0x200 #inwards sending
#    beq inwards
#    cmpwi r4, 0x202
#    beq inwards 
#    cmpwi r4, 0x201 #outwards sending
#    beq outwards
#    cmpwi r4, 0x203 #outwards sending
#    beq outwards
#	b %end%
#inwards:
#    lfs f0, 0x20(r8) #x hit position
#    lfs f1, 0x80(r8) #x hitbox position
#    fsubs f0, f1, f0 #x = hitbox-hitpos
#    lfs f1, 0x24(r8) #y hit position
#    lfs f2, 0x84(r8) #y hitbox position
#    fsubs f1, f2, f1 #y = hitbox-hitpos
#	stfs f0, 0x0(r6)
#	stfs f1, 0x4(r6)
#	b %end%
#	
#outwards:
#    lfs f0, 0x20(r8) #x hit position
#    lfs f1, 0x80(r8) #x hitbox position
#    fsubs f0, f0, f1 #x = hitbox-hitpos
#    lfs f1, 0x24(r8) #y hit position
#    lfs f2, 0x84(r8) #y hitbox position
#    fsubs f1, f1, f2 #y = hitbox-hitpos
#	stfs f0, 0x0(r6)
#	stfs f1, 0x4(r6)
#	#eq flag is currently set to true so will continue into autolink code but with position dif instead of speed
#}
##custom knockback values for angles 0x202 and 0x203
#HOOK @ $8076cefc
#{
#    cmpwi r0, 365
#    beq %end%
#    cmpwi r0, 0x202 #inwards sending
#    beq inwards
#    cmpwi r0, 0x203 #outwards sending
#    beq outwards
#	b %end%
#inwards:
#    lis r0, 0xBE80 #multiplier of distance from 
#    b both
#outwards:
#    lis r0, 0x3E80
#both:
#    stw r0, 0x20(r1)
#    lfs f0, 0x20(r1)
#    
#    lfs f1, 0x8C(r19) #xspeed
#    lfs f2, 0x20(r19) #x hit position
#    lfs f3, 0x80(r19) #x hitbox position
#    fsubs f2, f2, f3 #x = hitbox-hitpos
#    fmuls f2, f2, f0 #x = x*0.25 or x*-0.25
#    #maybe add a cap to how much this has an effect/could do inverse or something depending on use
#
#    fadds f1, f1, f2 #x = x + speed
#    stfs f1, 0x20(r1)
#
#    lfs f1, 0x90(r19) #yspeed of attacker
#    lfs f2, 0x24(r19) #y hit position
#    lfs f3, 0x84(r19) #y hitbox position
#    fsubs f2, f2, f3 #y = hitbox-hitpos
#    fmuls f2, f2, f0 #y = y*0.25 or y*-0.25
#    #maybe add a cap to how much this has an effect/could do inverse or something depending on use
#    
#    fadds f1, f1, f2 #y = y + speed
#    stfs f1, 0x24(r1)
#
#    #could also add some overall cap to this
#
#end:
#    lis r12, 0x8076
#    ori r12, r12, 0xCF48
#    mtctr r12
#    bctr
#}
#
#Hitbox Object Passed as extra Arg to getDamageAngle [Eon] 
#HOOK @ $8076D948
#{
#	mr r3, r30
#	mr r6, r31 #add arg 4 to be ConnectedHitbox
#}
#HOOK @ $8076CCF8
#{
#	mr r3, r18
#	mr r6, r19 #add arg 4 to be ConnectedHitbox
#}
#
##adding arg4 of getDamageAngle/[soDamageUtilActor]  
#HOOK @ $8076DF8C
#{
#	stw r6, 0x10(r1)
#	lwz r6, 0x0(r5) #original command
#}
##passing it as arg 6 of getDamageAngle/[soDamageUtil]
#HOOK @ $8076E03C
#{
#	fmr r6, f28 #original command
#	lwz r8, 0x10(r1)
#}
#
#!Graphic effects accept variable arguments for rotation and rand elements [Eon]
#
#.macro checkVariable(<argPointer>) 
#{
#	#make r3 the pointer to argument list
#	addi r3, r1, <argPointer>
#	#add variable accessor as part of passed arg
#	lwz r4, 0x10(r3)
#	stw r4, 0x14(r3)
#	stw r31, 0x10(r3)
#	#look at top of arg list
#    li r4, 0
#	#get Float, will auto handle scalars and variables
#    lis r12, 0x8077
#    ori r12, r12, 0xE0CC
#    mtctr r12
#    bctrl
#	#puts result in correct place
#    fmr f0,f1
#	lwz r4, (0x14+<argPointer>)(r1)
#	stw r4, (0x10+<argPointer>)(r1)
#
#	#expects after it a break that takes you to the float write that the game usually performs
#}
###########
##DETACHED# 0x111b1000
###########
##Zrot
#CODE @ $807A5AE0
#{
#    %checkVariable(0x818)
#}
##Yrot
#CODE @ $807A5B5C
#{
#    %checkVariable(0x818)
#}
##Xrot
#CODE @ $807A5BD8
#{
#    %checkVariable(0x818)
#}
##ZOffsetRand
#CODE @ $807A5D8C
#{
#    %checkVariable(0x818)
#}
##YOffsetRand
#CODE @ $807A5E08
#{
#    %checkVariable(0x818)
#}
##XOffsetRand
#CODE @ $807A5E84
#{
#    %checkVariable(0x818)
#}
##ZRotRand
#CODE @ $807A5F00
#{
#    %checkVariable(0x818)
#}
##YRotRand
#CODE @ $807A5F7C
#{
#    %checkVariable(0x818)
#}
##YRotRand
#CODE @ $807A5FF8
#{
#    %checkVariable(0x818)
#}
#
###########
##ATTACHED# 0x11010a00 
###########
##Zrot
#CODE @ $807A74D0
#{
#    %checkVariable(0x798)
#}
##Yrot
#CODE @ $807A754C
#{
#    %checkVariable(0x798)
#}
##Xrot
#CODE @ $807A75C8
#{
#    %checkVariable(0x798)
#}