#using scripts\zm\_zm_weapons;
#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

//bo4 carpenter
#using scripts\zm\_zm_weap_riotshield;

#using scripts\gfl\zm\gameplay;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#namespace tfoptions;

function init() {
    gameplay::init();
    thread main();
}

function main() {
    self waittill("choices_applied");
    applyChoices();
}

function applyChoices() {

}

function tempCallback(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasTimeJump) {
    
}

