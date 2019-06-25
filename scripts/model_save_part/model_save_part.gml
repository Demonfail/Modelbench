/// model_save_part()

json_save_var("name", name)

if (depth != 0)
	json_save_var("depth", depth)

model_save_texture()

model_save_colors()

json_save_var_point3D("position", point3D(value[e_value.POS_X], value[e_value.POS_Y], value[e_value.POS_Z]))

if (value[e_value.OPEN_POSITION_TAB])
	json_save_var("show_position", true)

if (value[e_value.OPEN_ROTATION_TAB])
	json_save_var("show_rotation", true)

if (value[e_value.OPEN_SCALE_TAB])
	json_save_var("show_scale", true)

var rot, sca;
rot = point3D(value[e_value.ROT_X], value[e_value.ROT_Y], value[e_value.ROT_Z])
sca = point3D(value[e_value.SCA_X], value[e_value.SCA_Y], value[e_value.SCA_Z])

if (!vec3_equals(rot, vec3(0)))
	json_save_var_point3D("rotation", rot)
	
if (!vec3_equals(sca, vec3(1)))
	json_save_var_point3D("scale", sca)

if (!value[e_value.BEND_LOCK])
	json_save_var("lock_bend", value[e_value.BEND_LOCK])

model_save_bend()

if (shape_list != null)
{
	json_save_array_start("shapes")
	
	for (var i = 0; i < ds_list_size(shape_list); i++)
	{
		with (shape_list[|i])
		{
			json_save_object_start()
			model_save_shape()
			json_save_object_done()
		}
	}
	
	json_save_array_done()
}

model_save_children()
