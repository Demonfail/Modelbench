/// new_element(type)
/// @arg type

with (new(obj_model_element))
{
	if (argument0 > TYPE_PART)
	{
		element_type = TYPE_SHAPE
		
		if (argument0 = e_element.PLANE_3D)
			type = "plane"
		else
			type = el_type_name_list[|argument0]
	}
	else
		element_type = TYPE_PART
		
	el_set_parent_root()
	
	return id
}