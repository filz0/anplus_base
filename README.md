![AnpLogo](https://i.imgur.com/Un3AR9h.png)
# ANPlus[BASE]
*Warning! Reading the code of this BASE may cause a severe brain aneurysm (not really).*

**Viewer Discretion is Advised**

Description
-
A small project of mine aims to add more features to the default AddNPC. While Your good old AddNPC works as intended, I find it very limited. Therefore I present you this monstrosity. 

Features
-
* Ability to set localized % damage resistance/vulnerability
* Ability to set output % damage increase/decrease:
>Damage resistance based on body parts.
* Ability to set random or specified body groups,
* Ability to set random or specified skins,
* Ability to set a custom material,
* Ability to override or edit sounds,
* Ability to edit the model scale,
* Ability to edit bones, 
>Scale, position, angle, or to enable jigglebones.
* Ability to add custom dispositions/relations, 
>Based on names, entity classes, NPC classes, and VJ classes.
* Ability to increase/decrease the speed or even replace certain activities like reloading,
* Ability to set weapon proficiency and range,
* Full save and dupe support,
* Available custom functions to customize engine NPCs even further,
* Kill feed NPC's name support,
* Build in health regeneration mechanic,
* Support for in-engine entities,
>Ever wanted a spawnable Citadel Super Suit Charger?
* Support for the Hammer Editor? 
>In theory you can change NPC's/Entity's parentname KeyValue to a certain ANP NPC/Entity name and it will be applied on the map load.
* Level Transition support,
>In theory you can change NPC's/Entity's parentname KeyValue to a certain ANP NPC/Entity name and it will be applied on the map load.

Commands
-
* anplus_reload_ents
>The BASE will look over all of the currently spawned NPCs and if it finds an NPC with a matching ANPlus NPC name (and entity class) it will turn that NPC into one.

* anplus_set_ent ANPNAME
>Allows you to turn any NPC (with a matching entity class) into an ANPlus NPC.

* anplus_start_invasion
>A command to start the invasion.

* anplus_ff_disabled 0/1
>Disable the Anti-Friendly Fire feature.

Templates
-
<a href="https://github.com/filz0/anplus_base/blob/main/lua/autorun/_template_empty.lua">Empty Template</a>

<a href="https://github.com/filz0/anplus_base/blob/main/lua/autorun/template_npc.lua">Mega Odessa Code + Dummy</a>

Credit
-
<a href="https://github.com/vercas/vON">vON by vercas</a>

