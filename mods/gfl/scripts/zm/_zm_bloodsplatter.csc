// -------------------------------------------------------------------------------
// Flashlight Script for Black Ops III - Bloc Edition
// Copyright (c) 2022 Philip/Scobalula
// -------------------------------------------------------------------------------
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// -------------------------------------------------------------------------------
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// -------------------------------------------------------------------------------
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// -------------------------------------------------------------------------------
#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;

#insert scripts\shared\duplicaterender.gsh;
#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_bloodsplatter.gsh;

#namespace zm_bloodsplatter;

REGISTER_SYSTEM("zm_bloodsplatter", &__init__, undefined)

function __init__()
{
	// Clientfields
	clientfield::register("allplayers", "bloodsplatter_toggle", VERSION_DLC3, 1, "counter", &splash_blood_cf, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT);
	// Dupe render definitions
	duplicate_render::set_dr_filter_framebuffer_duplicate("vmb_0", 98, "vm_blood_0", undefined, DR_TYPE_FRAMEBUFFER_DUPLICATE, "mc/mtl_bloodsplatter_scripted", DR_CULL_NEVER);
}

function private lerp( start_time, end_time )
{
	if((end_time - start_time) <= 0)
		return 0;
	
	now = self GetClientTime();
	frac = float(end_time - now) / float(end_time - start_time);

	return math::clamp(frac, 0, 1);
}

function private splash_blood_cf(n_local_client, n_old, n_new, b_new_ent, b_initial_snap, str_field, b_was_time_jump)
{
	self notify("blood_splash");
	self endon("blood_splash");
	self endon("entity_shutdown");

	self duplicate_render::set_dr_flag("vm_blood_0", 1);
	self duplicate_render::update_dr_filters(n_local_client);
	self MapShaderConstant(n_local_client, 0, "scriptVector0", 1.0); 

	// Let the blood sit for a bit >:)
	waitrealtime(BLOOD_SPASH_TIME);

	// Check for spectators, people respawning, and end game
	if(!isdefined(self))
		return;

	start_time = self GetClientTime();
	end_time = start_time + int(BLOOD_SPASH_FADE_TIME * 1000);
	val = 1.0;

	// Fade out the blood FX using script material vectors
	// This doesn't interfere with emissives as they use 2
	// If you do swap out for an emissive material, this 
	// may cause issues with wonder weapons, you'll need to
	// account for that, I have no need to account for it,
	// as the script does what I need it to.
	while (isdefined(self) && val > 0)
	{
		self MapShaderConstant(n_local_client, 0, "scriptVector0", val);
		val = self lerp(start_time, end_time);
		WAIT_CLIENT_FRAME;
	}
    
	if(isdefined(self))
	{
		self duplicate_render::set_dr_flag("vm_blood_0", 0);
		self duplicate_render::update_dr_filters(n_local_client);
		self MapShaderConstant(n_local_client, 0, "scriptVector0", 0.0);
	}
}