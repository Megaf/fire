fire = {}

minetest.register_craft({
	output = 'fire:flame',
	recipe = 	{
			{'default:coal_lump', 'default:coal_lump'},
			{'default:coal_lump', 'default:coal_lump'},
			{'default:torch',     'default:torch'},
		}
})

minetest.register_node("fire:flame", {
	description = "Non spreading Flame.",
	inventory_image = "inv_flame.png",
	drawtype = "plantlike",
	tiles = {{
		name="flame.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	light_source = 14,
	groups = {dig_immediate=3,hot=3},
	drop = 'default:coal_lump',
	walkable = false,
	buildable_to = false,
	damage_per_second = 1,
})

minetest.register_node("fire:basic_flame", {
	description = "Non spreading Flame.",
	inventory_image = "inv_flame.png",
	drawtype = "plantlike",
	tiles = {{
		name="flame.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1},
	}},
	light_source = 14,
	groups = {dig_immediate=3,hot=3},
	drop = 'default:coal_lump',
	walkable = false,
	buildable_to = false,
	damage_per_second = 1,
})
