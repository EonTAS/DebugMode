
.include "source/Extras/DebugMode/Camera(unfinished).asm"
.include "source/Extras/DebugMode/Collision Manager Render Debug.asm" #should move colours into debug.bin
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
Teams Thing
HOOK @ $80689BAC
{
    mr r0, r27
    lwz r27, 0x44(r3)
    lwz r4, 0xC(r26)
    andi. r4, r4, 0x40
    li r4, 0
    bne end
    li r4, 1 #changeTeam
end:
    cmpwi r0, 0
}
HOOK @ $806998B0
{
    cmpwi r4, 1
    beq changeCostume
changeTeam:
    addi r29, r29, 1
    b %end%
changeCostume:
    addi r28, r28, 1
}
op nop @ $806998D0
HOOK @ $80699BF8
{
    cmpwi r4, 1
    beq changeCostume
changeTeam:
    subic. r29, r29, 1
    b %end%
changeCostume:
    subi r28, r28, 1
}
op nop @ $80699C14


#.include "source/Extras/DebugMode/Madeline.asm"
