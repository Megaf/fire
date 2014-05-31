minetest.register_node("fire:flame", {
	description = "Non spreading Flame.",
	drawtype = "plantlike",
	tiles = {{
		name="flame.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	inventory_image = "inv_flame.png",
	light_source = 14,
	groups = {dig_immediate=3,hot=3},
	drop = 'default:coal_lump',
	walkable = false,
	buildable_to = true,
	damage_per_second = 1,
	
	after_place_node = function(pos, placer)
		fire.on_flame_add_at(pos)
	end,
	
	after_dig_node = function(pos, oldnode, oldmetadata, digger)
		fire.on_flame_remove_at(pos)
	end,
})

fire = {}
fire.D = 6
-- key: position hash of low corner of area
-- value: {handle=sound handle, name=sound name}
fire.sounds = {}

function fire.get_area_p0p1(pos)
	local p0 = {
		x=math.floor(pos.x/fire.D)*fire.D,
		y=math.floor(pos.y/fire.D)*fire.D,
		z=math.floor(pos.z/fire.D)*fire.D,
	}
	local p1 = {
		x=p0.x+fire.D-1,
		y=p0.y+fire.D-1,
		z=p0.z+fire.D-1
	}
	return p0, p1
end

function fire.update_sounds_around(pos)
	local p0, p1 = fire.get_area_p0p1(pos)
	local cp = {x=(p0.x+p1.x)/2, y=(p0.y+p1.y)/2, z=(p0.z+p1.z)/2}
	local flames_p = minetest.find_nodes_in_area(p0, p1, {"fire:flame"})
	--print("number of flames at "..minetest.pos_to_string(p0).."/"
	--		..minetest.pos_to_string(p1)..": "..#flames_p)
	local should_have_sound = (#flames_p > 0)
	local wanted_sound = nil
	if #flames_p >= 9 then
		wanted_sound = {name="fire_large", gain=1.5}
	elseif #flames_p > 0 then
		wanted_sound = {name="fire_small", gain=1.5}
	end
	local p0_hash = minetest.hash_node_position(p0)
	local sound = fire.sounds[p0_hash]
	if not sound then
		if should_have_sound then
			fire.sounds[p0_hash] = {
				handle = minetest.sound_play(wanted_sound, {pos=cp, loop=true}),
				name = wanted_sound.name,
			}
		end
	else
		if not wanted_sound then
			minetest.sound_stop(sound.handle)
			fire.sounds[p0_hash] = nil
		elseif sound.name ~= wanted_sound.name then
			minetest.sound_stop(sound.handle)
			fire.sounds[p0_hash] = {
				handle = minetest.sound_play(wanted_sound, {pos=cp, loop=true}),
				name = wanted_sound.name,
			}
		end
	end
end

function fire.on_flame_add_at(pos)
	--print("flame added at "..minetest.pos_to_string(pos))
	fire.update_sounds_around(pos)
end

function fire.on_flame_remove_at(pos)
	--print("flame removed at "..minetest.pos_to_string(pos))
	fire.update_sounds_around(pos)
end

function fire.find_pos_for_flame_around(pos)
	return minetest.find_node_near(pos, 1, {"air"})
end

function fire.flame_should_extinguish(pos)
	if minetest.setting_getbool("disable_fire") then return true end
	--return minetest.find_node_near(pos, 1, {"group:puts_out_fire"})
	local p0 = {x=pos.x-2, y=pos.y, z=pos.z-2}
	local p1 = {x=pos.x+2, y=pos.y, z=pos.z+2}
	local ps = minetest.find_nodes_in_area(p0, p1, {"group:puts_out_fire"})
	return (#ps ~= 0)
end
