#using scripts\shared\ai\zombie_utility;
#using scripts\shared\bots\_bot;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flag_shared;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;

#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

#namespace teamBots;

function start()
{	
	level endon( "game_ended" );
SetDvar("bot_difficulty","3");
SetDvar("player_meleeRangeDefault","24");
zombie_utility::set_zombie_var("zombie_health_increase_multiplier",0,true);
callback::on_spawned(&suicide);
level waitTill("initial_players_connected");
for(i=0;i<3;i++) {
	bot = addTestClient();
	bot thread bgoal(); }
level.camp = 0;
level.Dswitch = 0; level.Htoggle = 0;
level waitTill("initial_blackscreen_passed");
player = thread mplayer();
choice1 = 0;
choice2 = 0;
thread togglall();
thread doorsPrint();
player thread showMenu("^9--Instructions--\nAt any time:\n^7Press ^3[{+actionslot 3}] ^7to use mod menu\nPress ^3[{+gostand}] ^7to exit menu");
player thread showMenu("\n\n\n\nPress ^3[{+weaphero}]^7 to toggle bots mode\ngamepad: ^3[{+smoke}] ^7and ^3[{+frag}]");
while(1) {
if(player ActionSlotThreeButtonPressed()) {
	thread paused(true);
	player thread showMenu("^9--Mod menu--\n^7Press ^3[{+actionslot 3}] ^7for allies menu\nPress ^3[{+actionslot 4}] ^7for weapons menu\nPress ^3[{+actionslot 2}] ^7for cheat menu\nPress ^3[{+gostand}] ^7to cancel and exit menu");
	wait(.2);
	while(1) {
		if(player ActionSlotThreeButtonPressed()) {
			player thread showMenu("^9--Allies menu--\n^7Press ^3[{+actionslot 3}] ^7to add 1 ally\nPress ^3[{+actionslot 4}] ^7to dismiss 1 ally\nPress ^3[{+actionslot 2}] ^7to add all allies\nPress ^3[{+gostand}] ^7to cancel and exit menu");
			choice1 = 1; break; }
		if(player ActionSlotFourButtonPressed()) {
			player thread showMenu("^9--Weapons menu--\n^7Press ^3[{+actionslot 3}] ^7to choose guns for allies\nPress ^3[{+actionslot 4}] ^7to refill your ammo\n^7Press ^3[{+actionslot 2}] ^7to get a random weapon for yourself\nPress ^3[{+gostand}] ^7to cancel and exit menu");
			choice1 = 2; break; }
		if(player ActionSlotTwoButtonPressed()) {
			player thread showMenu("^9--Cheat menu--\n^7Press ^3[{+actionslot 3}] ^7to get 5000 points\nPress ^3[{+actionslot 4}] ^7to teleport all allies to your location\nPress ^3[{+actionslot 2}] ^7to change bot health\nPress ^3[{+gostand}] ^7to cancel and exit menu");
			choice1 = 3; break; }
		if(player jumpButtonPressed()) { thread paused(false); break; }
		wait(.05); }
	wait(.2);
	while(choice1==1) {
		if(player ActionSlotThreeButtonPressed()) {
			player thread spawnEm();
			thread paused(false); choice1 = 0; break; }
		if(player ActionSlotFourButtonPressed()) {
			player thread throwEm();
			thread paused(false); choice1 = 0; break; }
		if(player ActionSlotTwoButtonPressed()) {
			player thread spawnAll();
			thread paused(false); choice1 = 0; break; }
		if(player jumpButtonPressed()) { thread paused(false); choice1 = 0; break; }
		wait(.05); }
	while(choice1==2) {
		if(player ActionSlotThreeButtonPressed()) {
			player thread showMenu("^9--Choose gun for allies--\n^7Press ^3[{+actionslot 3}] ^7to give them your gun\nPress ^3[{+actionslot 4}] ^7to give random guns\nPress ^3[{+gostand}] ^7to cancel and exit menu");
			choice2 = 1; choice1 = 0; break; }
		if(player ActionSlotFourButtonPressed()) {
			thread paused(false); wait(.2);
			weap = player GetCurrentWeapon();
			player giveMaxAmmo(weap);
			choice2 = 0; choice1 = 0; break; }
		if(player ActionSlotTwoButtonPressed()) {
			thread paused(false); wait(.2);
			weap1 = randGun();
			weap = player GetCurrentWeapon();
			weapa = player GetWeaponsListPrimaries();
			if(weapa.size>=2) {
				player takeWeapon(weap);
				player giveWeapon(weap1);
				player switchToWeapon(weap1); }
			if(weapa.size<=1) {
				player giveWeapon(weap1);
				player switchToWeapon(weap1);
				player giveWeapon(weap);
				player giveWeapon(getWeapon("bowie_knife")); }
			choice2 = 0; choice1 = 0; break; }
		if(player jumpButtonPressed()) { thread paused(false); choice2 = 0; choice1 = 0; break; }
		wait(.05); }
	while(choice1==3) {
		if(player ActionSlotThreeButtonPressed()) {
			player zm_score::add_to_player_score(5000);
			thread paused(false); choice1 = 0; break; }
		if(player ActionSlotFourButtonPressed()) {
			player thread tport();
			thread paused(false); choice1 = 0; break; }
		if(player ActionSlotTwoButtonPressed()) {
			level.Htoggle notify("BHC"); wait(1);
			if(level.Htoggle==0) {
				IPrintLnBold("^9Bot max health: ^7"+level.zombie_health); }
			if(level.Htoggle==1) {
				IPrintLnBold("^9Bot max health: ^7"+level.zombie_health*(0.5)); }
			thread paused(false); choice1 = 0; break; }
		if(player jumpButtonPressed()) { thread paused(false); choice1 = 0; break; }
		wait(.05); }
	wait(.2);
	while(choice2==1) {
		if(player ActionSlotThreeButtonPressed()) {
			thread paused(false); wait(.2);
			weap1 = player GetCurrentWeapon();
			foreach(bot in getPlayers()) {
				if(bot IsTestClient()) {
					weap = bot GetCurrentWeapon();
					weapa = bot GetWeaponsListPrimaries();
					if(weapa.size>=2) {
						bot takeWeapon(weap);
						bot giveWeapon(weap1);
						bot switchToWeapon(weap1); }
					if(weapa.size<=1) {
						bot giveWeapon(weap1);
						bot switchToWeapon(weap1);
						bot giveWeapon(weap);
						bot giveWeapon(getWeapon("bowie_knife")); }}}
			choice2 = 0; break; }
		if(player ActionSlotFourButtonPressed()) {
			thread paused(false); wait(.2);
			foreach(bot in getPlayers()) {
				if(bot IsTestClient()) {
					weap1 = randGun();
					weap = bot GetCurrentWeapon();
					weapa = bot GetWeaponsListPrimaries();
					if(weapa.size>=2) {
						bot takeWeapon(weap);
						bot giveWeapon(weap1);
						bot switchToWeapon(weap1); }
					if(weapa.size<=1) {
						bot giveWeapon(weap1);
						bot switchToWeapon(weap1);
						bot giveWeapon(weap);
						bot giveWeapon(getWeapon("bowie_knife")); }}}
			choice2 = 0; break; }
		if(player ActionSlotTwoButtonPressed()) { thread paused(false); choice2 = 0; break; }
		if(player jumpButtonPressed()) { thread paused(false); choice2 = 0; break; }
		wait(.05); }
	}
wait(.05); }
}
function mplayer()
{	level endon( "game_ended" );
mhost = 0;
playersall = GetPlayers();
foreach(player in playersall) {
	if(player isHost()) {
		mhost = player; }
return mhost; }
}
function spawnEm()
{
bots = GetPlayers();
if(bots.size<=3) {
	bot1 = addTestClient();
	wait(.5); bot1 [[level.spawnPlayer]]();
	bot1 thread bgoal(); }
level.camp=0;
player = thread mplayer();
IPrintLnBold("Bots will now follow ^3"+player.name);
}
function spawnAll()
{
while(1) {
bots = GetPlayers();
if(bots.size<=3) {
	bot1 = addTestClient();
	bot1 thread bgoal(); }
if(bots.size>=4) { break; }
wait(.05); }
wait(1);
foreach(bot in getPlayers()) {
	if(bot IsTestClient()) {
		if(bot.sessionstate!="playing") { bot [[level.spawnPlayer]](); }}}
level.camp=0;
player = thread mplayer();
IPrintLnBold("Bots will now follow ^3"+player.name);
}
function throwEm()
{
num = 0;
bots = getPlayers();
for(i=0;i<bots.size;i++) {
	if(bots[i] IsTestClient()) { num = i; }}
bots[num] BotDropClient();
}
function paused(boole)
{
SetPauseWorld(boole);
if(boole==true) level flag::clear( "spawn_zombies" );
if(boole==false) level flag::set( "spawn_zombies" );
foreach(bot in getPlayers()) {
	if(bot IsTestClient()) { bot freezeControls(boole); }
	else {
		if(boole==true) { bot disableWeapons(); }
		if(boole==false) { bot enableWeapons(); }
		}}
}
function bgoal()
{	level endon( "game_ended" );
self thread pesSuit();
player = thread mplayer();
self thread botHealth();
while(1) {
	if(level.camp==0) self BotSetGoal(player.origin,144);
	if(level.camp==1) self BotSetGoal(self.origin);
	if(level.camp==2 && level.Dswitch==0) { wait(.1); level.Dswitch = 1; wait(.1); self thread doorLoop(); }
	while(isDefined(player.revivetrigger) && isAlive(player)) {
			self bot::revive_player(player);
			self.health = self.maxHealth;
			if(isDefined(player.revivetrigger) && isDefined(player.revivetrigger.beingRevived) && player.revivetrigger.beingRevived==1) {
				wait(1.4);
				player zm_laststand::auto_revive();
				player needsRevive(false); }
			wait(.05); }
	if(isDefined(self.revivetrigger)) {
		wait(10);
		self zm_laststand::auto_revive();
		self needsRevive(false); }
	wait(.2); }
}
function hRegen()
{	level endon( "game_ended" );
while(1) {
	self.health = self.maxHealth;
	weap3 = self GetCurrentWeapon();
	self giveMaxAmmo(weap3);
	wait(3); }
}
function botHealth()
{	level endon( "game_ended" );
self thread bmHealth();
self thread hRegen();
while(1) {
	level.Htoggle waitTill("BHC"); wait(.05);
	if(level.Htoggle==0) { wait(.05);
		self SetMaxHealth(level.zombie_health*(0.5)); level.Htoggle = 1; }
	else { self SetMaxHealth(level.zombie_health); level.Htoggle = 0; }
	wait(.5); }
}
function bmHealth()
{	level endon( "game_ended" );
while(1) {
	level waitTill("start_of_round");
	if(level.Htoggle==1) { wait(.05);
		self SetMaxHealth(level.zombie_health*(0.5)); }
	else { self SetMaxHealth(level.zombie_health); }
	wait(1); }
}
function suicide()
{	level endon( "game_ended" );
while(1) {
	if(self IsTestClient()) { break; }
	self waitTill("player_downed");
	sPrompt = newclientHudElem(self);
	sPrompt.alignX = "center";
	sPrompt.alignY = "bottom";
	sPrompt.horzAlign = "center";
	sPrompt.vertAlign = "bottom";
	sPrompt.y = -170;
	if(self IsSplitScreen()) { sPrompt.y = -85; }
	sPrompt.fontScale = 1.5;
	sPrompt.foreground = true;
	sPrompt.hidewheninmenu = true;
	sPrompt SetText("Enable suicide?(^3[{+activate}]^7)");
	while(isDefined(self.revivetrigger) && isAlive(self)) {
		if(self useButtonPressed()) {
			sPrompt destroy();
			self thread zm_laststand::suicide_trigger_spawn();
			break; }
		wait(.05); }
	wait(.05);
	sPrompt destroy();
	wait(.05); }
}
function showMenu(text)
{	level endon( "game_ended" );
menu = NewClientHudElem(self); 
menu.alignX = "center"; 
menu.alignY = "bottom"; 
menu.horzAlign = "user_center"; 
menu.vertAlign = "user_bottom"; 
menu.foreground = true; 
menu.hidewheninmenu = true;
menu.fontScale = 1.8; 
num1 = 0.1*randomIntRange(1,11);
num2 = 0.1*randomIntRange(1,11);
num3 = 0.1*randomIntRange(1,11);
menu.color = (num1,num2,num3);
menu.y = -113; 	
if(self IsSplitScreen()) {
	menu.fontScale = 1;
	menu.x = 40;
	menu.y = -60; }
menu SetText(text); 
wait(.2);
while(1) {
	if(self ActionSlotTwoButtonPressed()) { menu Destroy(); break; }
	if(self ActionSlotThreeButtonPressed()) { menu Destroy(); break; }
	if(self ActionSlotFourButtonPressed()) { menu Destroy(); break; }
	if(self jumpButtonPressed()) { menu Destroy(); break; }
wait(.05); }
}
function pesSuit()
{	level endon("game_ended");
	self endon("disconnect");
map = GetDvarString("mapname","NOTHING");
player = thread mplayer();
wait(3);
while(map=="zm_moon") {
	clothes = self zm_equipment::get_player_equipment();
	suit = player zm_equipment::get_player_equipment();
	if(clothes != suit && player.sessionstate=="playing") {
		self zm_equipment::take(clothes);
		self zm_equipment::give(suit);
		self zm_equipment::set_player_equipment(suit);
		self setactionslot(2,"weapon",suit);
		self switchToWeapon(suit); }
	wait(5); }
}
function tport()
{
num = 0;
foreach(bot in getPlayers()) {
	if(bot IsTestClient()) {
		if(num==0) { bot setOrigin(self.origin+(0,72,0)); }
		if(num==1) { bot setOrigin(self.origin+(72,0,0)); }
		if(num==2) { bot setOrigin(self.origin+(-72,0,0)); }
		num++; }
	}
}
function togglall()
{	level endon( "game_ended" );
player = thread mplayer();
while(1) {
	if(player OffhandSpecialButtonPressed()) {
		level.Dswitch = 0;
		if(level.camp==0) {
			IPrintLnBold("Bots will now camp"); 
			level.camp = 1; wait(.5); continue; }
		if(level.camp==1) {
			IPrintLnBold("Bots will now hunt");
			level.camp = 2; wait(.5); continue; }
		if(level.camp==2) {
			IPrintLnBold("Bots will now follow ^3"+player.name);
			foreach(bot in getPlayers()) {
				if(bot IsTestClient() ) {
					self thread bot::stuck_resolution(); }}
			level.camp = 0; wait(.5); }}
	wait(.1); }
}
function doorLoop()
{	level endon("game_ended");
player = thread mplayer();
while(level.Dswitch==1) {
	if(!isdefined(player.revivetrigger)) {
		self thread openDoors();
		wait(3.5);
		self BotTapButton(3);
		self thread bot::stuck_resolution();
		wait(3.5); }
	wait(.05); }
}
function openDoors()
{	level endon("game_ended");
nearDoor = arrayGetClosest(self.origin+(0,0,60),level.dtargets);
self bot::approach_goal_trigger(nearDoor);
wait(.05);
self bot::sprint_to_goal();
if(nearDoor.zombie_cost > self.score || !isDefined(nearDoor) || nearDoor._door_open==true || level.dtargets.size<1) {
	self bot::navmesh_wander(); return; } //self openDoors();
for(i=0; i<4; i++) {
	wait(1);
	if(self isTouching(nearDoor) || (self BotGoalReached() && self BotGetGoalPosition()==nearDoor)) {
		self BotTapButton(3); }}
}
function randGun()
{	level endon( "game_ended" );
gun1 = level.zombie_weapons_upgraded;
gun2 = level.zombie_weapons;
while(1) {
	wait(.05);
	flipCoin = RandomInt(2);
	if(flipCoin==0) {
		gun3 = GetArrayKeys(gun1);
		rand = RandomInt(gun1.size); }
	if(flipCoin==1) {
		gun3 = GetArrayKeys(gun2);
		rand = RandomInt(gun2.size); }
	if(zm_utility::is_offhand_weapon(gun3[rand]) || gun3[rand].name=="bowie_knife") continue;
	break; }
both = arrayCombine(gun1,gun2,true,false);
IPrintLnBold((both.size-8)+" guns are available");
return(gun3[rand]);
}
function doorsPrint()
{	level endon("game_ended");
doors1 = getEntArray("zombie_door","targetname");
doors2 = getEntArray("zombie_debris","targetname");
doors3 = getEntArray("zombie_airlock_buy","targetname");
doors4 = arrayCombine(doors1,doors2,true,true);
level.dtargets = arrayCombine(doors3,doors4,true,false);
for(i=0;i<level.dtargets.size;i++) {
	if(level.dtargets[i]._door_open==true || level.dtargets[i].script_noteworthy=="local_electric_door" || level.dtargets[i].script_noteworthy=="electric_door") // level.dtargets[i].script_noteworthy=="electric_buyable_door" ||
		ArrayRemoveIndex(level.dtargets,i);
	else { level.dtargets[i] thread doorsWatch(doors1,doors2,doors3,doors4); }}
}
function doorsWatch(doors1,doors2,doors3,doors4)
{
buyer = undefined;
if(self.targetname=="zombie_door" || self.targetname=="zombie_airlock_buy") {
	self waitTill("door_opened"); //airlocks- level waitTill("kill_door_think" level waitTill("door_opened"
	buyer = self.purchaser;
	for(i=0;i<level.dtargets.size;i++) {
		if(!isDefined(level.dtargets[i].zombie_cost) || level.dtargets[i]==self || !isDefined(level.dtargets[i])) ArrayRemoveIndex(level.dtargets,i); }}
if(self.targetname=="zombie_debris") {
	self waitTill("trigger",buyer); //level waitTill("junk purchased" "kill_debris_prompt_thread"
	for(i=0;i<level.dtargets.size;i++) {
		if(level.dtargets[i]==self || !isDefined(level.dtargets[i])) ArrayRemoveIndex(level.dtargets,i); }}
opened = doors4.size+doors3.size-level.dtargets.size;
IPrintLnBold("^3"+buyer.name+" ^7opened a door.");
IPrintLnBold("Doors: "+doors1.size+"  Debris: "+doors2.size+"  Airlocks: "+doors3.size);
IPrintLnBold("Total opened: "+opened+"  Still closed: "+level.dtargets.size);
level.camp=0;
wait(1);
level.camp=1;
wait(1);
level.camp=2;
}
