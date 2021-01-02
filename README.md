# DebugMode
A full implementation of debug mode for Brawl/PM based on unused functions within vBrawl alongside full implimentation of features. 

Enables the RenderDebug function of all gfTasks and implements functionality into all that are wanted.

# Installation
Place all .asm as well as debug.bin files within a a new folder at the path `./Source/Extras/DebugMode/` in your game folder and then write `.include "Source/Extras/DebugMode/includeDebug.asm` into your codeset to include all the codes (requires GCTRM to include at the moment).

Place the sora_enemy.rel into the `/pf/modules/` folder, this one file contains a module edit to allow all subspace enemies to correctly use the hurtbox renderer.

Delete/comment out the `.include` for vPM's debug.asm if it is in your build.

To use when code menu is in the build, set the `code menu activation` to `PM 3.6` 

The RSBE01.map includes a lot of the functions i've written at the top so you can stick this into your `Dolphin/User/Maps` to be able to search the debug functions in dolphin.
# Features
Activate debug mode with L+R+DpadDown, you should hear a sound effect to indicate its enabled.

__Frame Pause/Advance__

Pressing start when debug mode is enabled will freeze the game and z will advance one frame. Pressing X + dpad up will pause the game. This is reworked from PMs implementation and the x+dpad up input will no longer advance a frame when exitting the debug pause, allowing you to look at the exact frame you were frozen at. 

__Hurtbox/Hitbox Renderer__

Press R + Dpad right to toggle through 2 different settings for the hurtbox viewer. 

Pressing it once will disable all player models and the majority of gfx and the show only the capsules:
![Model Disabled](https://imgur.com/sUHhBwp.png)

Pressing it twice will reenable all models and still show collisions: 
![Models Enabled](https://imgur.com/AhY0Oi8.png)

This collision viewer is reworked from PM to use the actual graphics renderer code of brawl instead of using gfx objects, meaning interpolation and capsules can be rendered in full, and the number of possible objects shown is insanely increased, meaning hurtbox viewing is possible without lagging/glitching out.

<ins>Colour Code</ins>
| Colour | Meaning
|----|----|
| Yellow | Hurtbox
| Light Yellow | ungrabbable hurtbox
| Red | Hitbox
| Purple | Grabbox
| Light Blue | Shieldbox
| Light Green | Reflectbox
| Dark Blue | Absorbbox
| White | SearchBox

__Ground Collision view__

Y+Dpad Left toggles ECB View, which allows you to see the collision diamond of all stage objects, and highlights all stage collisions they are currently touching. In the air this also shows the ledgegrab box of the fighter
![ECB Enabled](https://imgur.com/xsHAUb2.png)
![Ledgegrab box](https://imgur.com/pyhkdvc.png)

__Stage Collisions__
L+DpadRight enables stage collision viewing. This enables the view of all stage collisions, the blastzones, and stage spawn locations
![Stage Collisions](https://imgur.com/c7MT6xK.png)
A second input of this disables all stage rendering, leaving the game looking very much like brawlcrate
![Stage disabled](https://imgur.com/GwKOorI.png)
Colour coding for this feature is based heavily on brawlcrates collision renderers colour scheme.

__Status Module Display__

Currently this feature is tied to the stage collision renderer, so L+DpadRight. This writes to the top of the screen the current action name and ID, previous action ID, subaction name and ID, current frame and animation length and the frame speed modifier of every fighter currently active.  This feature is currently quite buggy and stops functioning if the player does something that prints too much text to the screen (e.g. aerialAttackLandingLag) so needs some polish
![Status Module](https://imgur.com/S33WTOw.png)

__UI Toggle__

L+DpadLeft allows you to enable and disable the UI at any time. This will also be attached to camera lock in the future.

__Area Manager__

X + dpad left and right scrolls through what the game calls areas. This is things like item pickup range, whispy wind detection, sonic spring detection and footstool ranges. There are currently 31 individual settings for this option, with no clear visual indicator, so its not very user friendly, sorry. Heres a list of all known areas if you want to try to look at stuff 
|ID | known use |
|---|-----------|
| 1 | surrounds ecb, unknown purpose |
|2 | footstool event
|3 | under feat in air
|4 | item grabbox presented action? if an item wants to know if in range? no items have the counterpart afaik
|5 | eatbox (17) presented action, same as above
|6 |
|7 |
|8 | 
|9 | surrounds ecb of all subspace enemies
|10 | unk 
|11 | subspace ai controller logic? theres a tonne of presenters on each |primid + surrounding entire stage
|12 |  
|13 | 
|14 | footstoolbox for subspace enemies e.g. koopas/goombas
|15 | 
|16 | 
|17 | kirby/wario/dedede item "eatbox", also used for shell item bounce e.g. autofootstol. also on all items even if not edible/jumpable
|18 | small item
|19 | large item
|20 | unk 
|21 | doors/subspace springs/Catapult/barrel
|22 | ladder
|23 | elevator
|24 | unk,
|25 | surrounds ecb 
|26 | whispy wind, gravity changer etc + aesthetic wind.
|27 | conveyor
|28 | water 
|29 | Dedede Waddle grab range 
|30 | surrounds ecb
|31 | spring

The colours of the areas is for either event presenters and event searchers, light blue means it sends the event, dark blue means its passively there.

Here is an example of the footstool setup, here you can see falco is currently able to footstool lucas as his light blue box overlaps lucas' dark blue box.

![Footstool example](https://imgur.com/C1EInNU.png)

# TODO

The debug mode still has a few things i either have not yet implemented or have implemented poorly that need addressing. 

|todo|
|------|
|status module renderer crashes at long names
|game crashes when models are disabled and then certain chars need loading
|Camera Lock needs implemented
|Armour is not displayed at all currently
|TopN Should be shown when ecb is rendered, this is way harder than it deserves to be
|item spawns should show up in stage render
|subspace needs some polish
|input system needs tidied up and seperated
|integration with code menu etc.
|a few other bits and bobs i definitely forget

I have put this project out in this current state due to burnout from being only one working on it, so i hope people can take this in its current form while I have a break before returning to it. :)
