#using scripts\codescripts\struct;
#using scripts\shared\_character_customization;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\util_shared;

#namespace frontend_cam_override;

function init_lobby_rooms()
{
	if ( !isdefined(level.current_zm_lobby_room) )
	{
		level.current_zm_lobby_room = 0;
	}

	level.zm_lobby_rooms = [];
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room_read;
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room;
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room_work;
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room_idle;
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room_type;
	level.zm_lobby_rooms[level.zm_lobby_rooms.size] = &zm_lobby_room_cpzm;
}

function zm_lobby_room_base( localclientnum )
{
	level endon("new_lobby");
	while (true)
	{
		if ( !isdefined(level.zm_lobby_rooms) || level.zm_lobby_rooms.size == 0 )
		{
			break;
		}

		[[ level.zm_lobby_rooms[level.current_zm_lobby_room] ]]( localclientnum );
		wait 0.05;
		level waittill("lobby_room_changed");
		lobby = (level.current_zm_lobby_room + 1) % level.zm_lobby_rooms.size;
		level.current_zm_lobby_room = lobby;
	}
}

function zm_lobby_room_idle(localclientnum)
{
	zm_lobby_room_cp_core(localclientnum, 0);
}

function zm_lobby_room_read(localclientnum)
{
	zm_lobby_room_cp_core(localclientnum, 1);
}

function zm_lobby_room_work(localclientnum)
{
	zm_lobby_room_cp_core(localclientnum, 2);
}

function zm_lobby_room_type(localclientnum)
{
	zm_lobby_room_cp_core(localclientnum, 3);
}

function zm_lobby_room_cpzm(localclientnum)
{
	str_safehouse = "cairo";
	level.a_str_bunk_scenes = [];
	level.active_str_cpzm_scene = ("zm_cp_" + str_safehouse) + "_lobby_idle";
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = level.active_str_cpzm_scene;
	if(isdefined(level.a_str_bunk_scene_exploders))
	{
		for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
		{
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
	}
	level.a_str_bunk_scene_exploders = [];
	if(str_safehouse == "cairo")
	{
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
	}
	else
	{
		if(str_safehouse == "mobile")
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
		}
		else
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
		}
	}
	level.a_str_bunk_scene_hints = [];
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	level.n_cp_index = 0;
	setpbgactivebank(localclientnum, 1);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);

	if(isdefined(s_scene.femalebundle))
	{
		s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
	}

	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 0;

	load_equipped_character(localclientnum, level.cp_lobby_data_struct, s_params);
	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
}

function first_time_flow(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

function cp_bunk_anim_type(localclientnum, oldval, newval, bnewent, binitialsnap, fieldname, bwastimejump)
{
}

function streamer_change(hint, data_struct)
{
	if(isdefined(hint))
	{
		setstreamerrequest(0, hint);
	}
	else
	{
		clearstreamerrequest(0);
	}
	level notify("streamer_change", data_struct);
}

function plaympherovignettecam(localclientnum, data_struct, changed)
{
	fields = getcharacterfields(data_struct.characterindex, 1);
	if(isdefined(fields) && isdefined(fields.frontendvignettestruct) && isdefined(fields.frontendvignettexcam))
	{
		if(isdefined(fields.frontendvignettestreamerhint))
		{
			streamer_change(fields.frontendvignettestreamerhint, data_struct);
		}
		position = struct::get(fields.frontendvignettestruct);
		playmaincamxcam(localclientnum, fields.frontendvignettexcam, 0, "", "", position.origin, position.angles);
	}
}

function load_lobby_room(str_safehouse)
{
	level.a_str_bunk_scenes = [];
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cp_cac_cp_lobby_idle_" + str_safehouse;
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_bunk_vign_smoke_read_" + str_safehouse;
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_desk_vign_work_" + str_safehouse;
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = "cin_fe_cp_desk_vign_type_" + str_safehouse;

	if(isdefined(level.a_str_bunk_scene_exploders))
	{
		for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
		{
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
	}

	level.a_str_bunk_scene_exploders = [];
	if(!isdefined(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = [];
	}
	else if(!isarray(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
	}
	level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_idle";
	if(!isdefined(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = [];
	}
	else if(!isarray(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
	}
	level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_read";
	if(!isdefined(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = [];
	}
	else if(!isarray(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
	}
	level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_work";
	if(!isdefined(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = [];
	}
	else if(!isarray(level.a_str_bunk_scene_exploders))
	{
		level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
	}
	level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "cp_frontend_type";
	
	level.a_str_bunk_scene_hints = [];
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_idle";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_read";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_work";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cp_frontend_type";
}

function cp_lobby_room(localclientnum)
{
	level endon("new_lobby");
	while(true)
	{
		str_queued_level = getdvarstring("ui_mapname");
		if(util::is_safehouse(str_queued_level))
		{
			str_safehouse = str_queued_level;
		}
		else
		{
			str_safehouse = util::get_next_safehouse(str_queued_level);
		}
		str_safehouse = getsubstr(str_safehouse, "cp_sh_".size);
		load_lobby_room(str_safehouse);

		if(!isdefined(level.n_cp_index))
		{
			if(level clientfield::get("first_time_flow"))
			{
				level.n_cp_index = 0;
			}
			else
			{
				if(level clientfield::get("cp_bunk_anim_type") == 0)
				{
					level.n_cp_index = randomintrange(0, 2);
				}
				else if(level clientfield::get("cp_bunk_anim_type") == 1)
				{
					level.n_cp_index = randomintrange(2, 4);
				}
			}
		}
		
		s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
		str_gender = getherogender(getequippedheroindex(localclientnum, 2), "cp");
		if(str_gender === "female" && isdefined(s_scene.femalebundle))
		{
			s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
		}
		
		s_align = struct::get(s_scene.aligntarget, "targetname");
		playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
		for(i = 0; i < level.a_str_bunk_scenes.size; i++)
		{
			if(i == level.n_cp_index)
			{
				playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
				continue;
			}
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
		// s_params = spawnstruct();
		// s_params.scene = s_scene.name;
		// s_params.sessionmode = 2;
		// character_customization::loadequippedcharacteronmodel(localclientnum, level.cp_lobby_data_struct, undefined, s_params);
		load_random_char_model_cp(localclientnum, s_scene);
		streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
		setpbgactivebank(localclientnum, 1);
		
		do
		{
			wait(0.016);
			str_queued_level_new = getdvarstring("ui_mapname");
		}
		while(str_queued_level_new == str_queued_level);
	}
}

function get_cp_bodystyle_count()
{
	bodystyle_count = 12;
	return bodystyle_count;
}

function load_random_char_model_cp(localclientnum, s_scene)
{
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 2;
	characterindex = getequippedheroindex(localclientnum, s_params.sessionmode);
	body = randomint(get_cp_bodystyle_count());
	loadcpzmcharacteronmodel(localclientnum, level.cp_lobby_data_struct, characterindex, s_params, body);
}

function cpzm_lobby_room(localclientnum)
{
	str_safehouse = level.str_current_safehouse;
	level.a_str_bunk_scenes = [];
	level.active_str_cpzm_scene = ("zm_cp_" + str_safehouse) + "_lobby_idle";
	if(!isdefined(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = [];
	}
	else if(!isarray(level.a_str_bunk_scenes))
	{
		level.a_str_bunk_scenes = array(level.a_str_bunk_scenes);
	}
	level.a_str_bunk_scenes[level.a_str_bunk_scenes.size] = level.active_str_cpzm_scene;
	if(isdefined(level.a_str_bunk_scene_exploders))
	{
		for(i = 0; i < level.a_str_bunk_scene_exploders.size; i++)
		{
			killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
		}
	}
	level.a_str_bunk_scene_exploders = [];
	if(str_safehouse == "cairo")
	{
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
		if(!isdefined(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = [];
		}
		else if(!isarray(level.a_str_bunk_scene_exploders))
		{
			level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
		}
		level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_cairo";
	}
	else
	{
		if(str_safehouse == "mobile")
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_mobile";
		}
		else
		{
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
			if(!isdefined(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = [];
			}
			else if(!isarray(level.a_str_bunk_scene_exploders))
			{
				level.a_str_bunk_scene_exploders = array(level.a_str_bunk_scene_exploders);
			}
			level.a_str_bunk_scene_exploders[level.a_str_bunk_scene_exploders.size] = "fx_frontend_zombie_fog_singapore";
		}
	}
	level.a_str_bunk_scene_hints = [];
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	if(!isdefined(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = [];
	}
	else if(!isarray(level.a_str_bunk_scene_hints))
	{
		level.a_str_bunk_scene_hints = array(level.a_str_bunk_scene_hints);
	}
	level.a_str_bunk_scene_hints[level.a_str_bunk_scene_hints.size] = "cpzm_frontend";
	level.n_cp_index = 0;
	setpbgactivebank(localclientnum, 2);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
	str_gender = getherogender(getequippedheroindex(localclientnum, 2), "cp");
	if(str_gender === "female" && isdefined(s_scene.femalebundle))
	{
		s_scene = struct::get_script_bundle("scene", s_scene.femalebundle);
	}
	/#
		printtoprightln(s_scene.name, (1, 1, 1));
	#/
	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			if(getdvarint("tu6_ffotd_zombieSpecialDayEffectsClient"))
			{
				switch(level.a_str_bunk_scene_exploders[i])
				{
					case "fx_frontend_zombie_fog_mobile":
					case "zm_bonus_idle":
					{
						position = (-1269, 1178, 562);
						break;
					}
					case "fx_frontend_zombie_fog_singapore":
					{
						position = (-1273, 1180, 320);
						break;
					}
					case "fx_frontend_zombie_fog_cairo":
					{
						position = (-1256, 1235, 61);
						break;
					}
				}
				level.frontendspecialfx = playfx(localclientnum, level._effect["frontend_special_day"], position);
			}
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 2;

	characterindex = 1;
	body = randomint(get_cp_bodystyle_count());
	loadcpzmcharacteronmodel(localclientnum, level.cp_lobby_data_struct, characterindex, s_params, body);
	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
}

function doa_lobby_room(localclientnum)
{
	str_safehouse = "mobile";
	load_lobby_room(str_safehouse);

	level.n_cp_index = 3;
	setpbgactivebank(localclientnum, 1);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}

	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 2;
	female = 1;

	// RFB
	loadcpzmcharacteronmodel(localclientnum, level.cp_lobby_data_struct, female, s_params);
	level.cp_lobby_data_struct.show_helmets = 0;
	level.cp_lobby_data_struct.charactermodel setmodel("t7_gfl_rfb_fb_mp");

	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
	level.n_cp_index = 0;
}

function zm_lobby_room_cp_core(localclientnum, lobby_index = 0, str_safehouse = "cairo")
{
	// level.active_str_cpzm_scene = "cp_cac_cp_lobby_idle_" + str_safehouse;
	load_lobby_room(str_safehouse);

	level.n_cp_index = lobby_index;
	setpbgactivebank(localclientnum, 1);
	s_scene = struct::get_script_bundle("scene", level.a_str_bunk_scenes[level.n_cp_index]);
	s_align = struct::get(s_scene.aligntarget, "targetname");
	playmaincamxcam(localclientnum, s_scene.cameraswitcher, 0, "", "", s_align.origin, s_align.angles);
	for(i = 0; i < level.a_str_bunk_scenes.size; i++)
	{
		if(i == level.n_cp_index)
		{
			playradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
			continue;
		}
		killradiantexploder(0, level.a_str_bunk_scene_exploders[i]);
	}

	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 0;

	load_equipped_character(localclientnum, level.cp_lobby_data_struct, s_params);
	streamer_change(level.a_str_bunk_scene_hints[level.n_cp_index], level.cp_lobby_data_struct);
	level.n_cp_index = 0;
}

function loadcpzmcharacteronmodel(localclientnum, data_struct, characterindex, params, bodystyle = 0)
{
	defaultindex = undefined;
	if(isdefined(params.isdefaulthero) && params.isdefaulthero)
	{
		defaultindex = 0;
	}
	character_customization::set_character(data_struct, characterindex);
	charactermode = params.sessionmode;
	character_customization::set_character_mode(data_struct, charactermode);
	bodycolors = character_customization::get_character_body_colors(localclientnum, charactermode, characterindex, bodystyle, params.extracam_data);
	character_customization::set_body(data_struct, charactermode, characterindex, bodystyle, bodycolors);
	head = 0;
	character_customization::set_head(data_struct, charactermode, head);
	helmet = 0;
	helmetcolors = character_customization::get_character_helmet_colors(localclientnum, charactermode, data_struct.characterindex, helmet, params.extracam_data);
	character_customization::set_helmet(data_struct, charactermode, characterindex, helmet, helmetcolors);
	return character_customization::update(localclientnum, data_struct, params);
}

function load_equipped_character(localclientnum, data_struct, params)
{
	bodytype = GetEquippedHeroIndex(localclientnum, params.sessionmode);
	bodystyle = GetEquippedBodyIndexForHero(localclientnum, params.sessionmode, bodytype);
	result = loadcpzmcharacteronmodel(localclientnum, data_struct, bodytype, params, bodystyle);
	return result;
}

function revolve_zm_character(localclientnum, data_struct, params)
{
	level endon("new_lobby");
	body = 0;
    bodytype_total = 16;
    while(true)
    {
		if (body >= bodytype_total)
		{
			body = 0;
		}

        if (body == 4)
        {
        	body = body + 1;
            continue;
        }

		loadcpzmcharacteronmodel(localclientnum, data_struct, body, params);
        body = body + 1;
		wait(10);
    }
}

function zm_lobby_room(localclientnum)
{
	streamer_change("core_frontend_zm_lobby");
	camera_ent = struct::get("zm_frontend_camera");
	if(isdefined(camera_ent))
	{
		playmaincamxcam(localclientnum, "zm_lobby_cam", 0, "default", "", camera_ent.origin, camera_ent.angles);
	}

	s_scene = struct::get_script_bundle("scene", "cin_fe_zm_forest_vign_sitting");
	s_params = spawnstruct();
	s_params.scene = s_scene.name;
	s_params.sessionmode = 0;
	changed = character_customization::loadequippedcharacteronmodel(localclientnum, level.zm_lobby_data_struct, level.zm_debug_index, s_params);
	// plaympherovignettecam(localclientnum, level.zm_lobby_data_struct, changed);
}

function mp_lobby_room(localclientnum, state)
{
	character_index = getequippedheroindex(localclientnum, 1);
	fields = getcharacterfields(character_index, 1);
	params = spawnstruct();
	if(!isdefined(fields))
	{
		fields = spawnstruct();
	}
	if(isdefined(fields.frontendvignettestruct))
	{
		params.align_struct = struct::get(fields.frontendvignettestruct);
	}
	params.weapon_left = fields.frontendvignetteweaponleftmodel;
	params.weapon_right = fields.frontendvignetteweaponmodel;
	isabilityequipped = 1 == getequippedloadoutitemforhero(localclientnum, character_index);
	if(isabilityequipped)
	{
		params.anim_intro_name = fields.frontendvignetteabilityxanimintro;
		params.anim_name = fields.frontendvignetteabilityxanim;
		params.weapon_left_anim_intro = fields.frontendvignetteabilityweaponleftanimintro;
		params.weapon_left_anim = fields.frontendvignetteabilityweaponleftanim;
		params.weapon_right_anim_intro = fields.frontendvignetteabilityweaponrightanimintro;
		params.weapon_right_anim = fields.frontendvignetteabilityweaponrightanim;
		if(isdefined(fields.frontendvignetteuseweaponhidetagsforability) && fields.frontendvignetteuseweaponhidetagsforability)
		{
			params.weapon = getweaponforcharacter(character_index, 1);
		}
	}
	else
	{
		params.anim_intro_name = fields.frontendvignettexanimintro;
		params.anim_name = fields.frontendvignettexanim;
		params.weapon_left_anim_intro = fields.frontendvignetteweaponleftanimintro;
		params.weapon_left_anim = fields.frontendvignetteweaponleftanim;
		params.weapon_right_anim_intro = fields.frontendvignetteweaponanimintro;
		params.weapon_right_anim = fields.frontendvignetteweaponanim;
		params.weapon = getweaponforcharacter(character_index, 1);
	}
	params.sessionmode = 1;
	changed = character_customization::loadequippedcharacteronmodel(localclientnum, level.mp_lobby_data_struct, character_index, params);
	if(isdefined(level.mp_lobby_data_struct.charactermodel))
	{
		level.mp_lobby_data_struct.charactermodel sethighdetail(1, 1);
		if(isdefined(params.weapon))
		{
			level.mp_lobby_data_struct.charactermodel useweaponhidetags(params.weapon);
		}
		else
		{
			wait(0.016);
			level.mp_lobby_data_struct.charactermodel showallparts(localclientnum);
		}
		if(isdefined(level.mp_lobby_data_struct.stopsoundid))
		{
			stopsound(level.mp_lobby_data_struct.stopsoundid);
			level.mp_lobby_data_struct.stopsoundid = undefined;
		}
		if(isdefined(level.mp_lobby_data_struct.playsound))
		{
			level.mp_lobby_data_struct.stopsoundid = level.mp_lobby_data_struct.charactermodel playsound(undefined, level.mp_lobby_data_struct.playsound);
			level.mp_lobby_data_struct.playsound = undefined;
		}
	}
	plaympherovignettecam(localclientnum, level.mp_lobby_data_struct, changed);
}

function lobby_main(localclientnum, menu_name, state)
{
	level notify("new_lobby");
	init_lobby_rooms();
	setpbgactivebank(localclientnum, 1);
	if(isdefined(state) && !strstartswith(state, "cpzm") && !strstartswith(state, "doa"))
	{
		if(isdefined(level.frontendspecialfx))
		{
			killfx(localclientnum, level.frontendspecialfx);
		}
	}
	if(!isdefined(state) || state == "room2")
	{
		// streamer_change();
		// camera_ent = struct::get("mainmenu_frontend_camera");
		// if(isdefined(camera_ent))
		// {
		// 	playmaincamxcam(localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
		// }
		streamer_change("core_frontend_sitting_bull");
		camera_ent = struct::get("room1_frontend_camera");
		setallcontrollerslightbarcolor((1, 0.4, 0));
		level thread pulse_controller_color();
		if(isdefined(camera_ent))
		{
			playmaincamxcam(localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
		}
	}
	else
	{
		if(state == "room1")
		{
			streamer_change("core_frontend_sitting_bull");
			camera_ent = struct::get("room1_frontend_camera");
			setallcontrollerslightbarcolor((1, 0.4, 0));
			level thread pulse_controller_color();
			if(isdefined(camera_ent))
			{
				playmaincamxcam(localclientnum, "startmenu_camera_01", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
			}
		}
		else
		{
			if(state == "mp_theater")
			{
				streamer_change("frontend_theater");
				camera_ent = struct::get("frontend_theater");
				if(isdefined(camera_ent))
				{
					playmaincamxcam(localclientnum, "ui_cam_frontend_theater", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
				}
			}
			else
			{
				if(state == "mp_freerun")
				{
					streamer_change("frontend_freerun");
					camera_ent = struct::get("frontend_freerun");
					if(isdefined(camera_ent))
					{
						playmaincamxcam(localclientnum, "ui_cam_frontend_freerun", 0, "cam1", "", camera_ent.origin, camera_ent.angles);
					}
				}
				else
				{
					if(strstartswith(state, "doa"))
					{
						doa_lobby_room(localclientnum);
					}
					else
					{
						if(strstartswith(state, "cpzm"))
						{
							cpzm_lobby_room(localclientnum);
						}
						else
						{
							if(strstartswith(state, "cp"))
							{
								cp_lobby_room(localclientnum);
							}
							else
							{
								if(strstartswith(state, "mp"))
								{
									mp_lobby_room(localclientnum, state);
								}
								else
								{
									if(strstartswith(state, "zm"))
									{
                                        zm_lobby_room_base(localclientnum);
									}
									else
									{
										streamer_change();
									}
								}
							}
						}
					}
				}
			}
		}
	}
	if(!isdefined(state) || state != "room1")
	{
		setallcontrollerslightbarcolor();
		level notify("end_controller_pulse");
	}
}

function pulse_controller_color()
{
	level endon("end_controller_pulse");
	delta_t = -0.01;
	t = 1;
	while(true)
	{
		setallcontrollerslightbarcolor((1 * t, 0.2 * t, 0));
		t = t + delta_t;
		if(t < 0.2 || t > 0.99)
		{
			delta_t = delta_t * -1;
		}
		wait(0.016);
	}
}

