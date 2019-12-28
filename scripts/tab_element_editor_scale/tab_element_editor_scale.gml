/// tab_element_editor_scale()

if (setting_combine_scale)
{
	tab_control(28)
	draw_textfield_num("elementeditorscalexyz", dx, dy, 86, el_edit.value[e_value.SCA_X], 0.1, 0.001, no_limit, 1, snap_value, tab.scale.tbx_x, action_el_sca_xyz)
	tab_next()
}
else
{
	tab_control(28)
	textfield_group_add("elementeditorscalex", el_edit.value[e_value.SCA_X], 1, action_el_sca, X, tab.scale.tbx_x)

	axis_edit = (setting_z_is_up ? Y : Z)
	textfield_group_add("elementeditorscaley", el_edit.value[e_value.SCA_X + axis_edit], 1, action_el_sca, axis_edit, tab.scale.tbx_y)

	axis_edit = (setting_z_is_up ? Z : Y)
	textfield_group_add("elementeditorscalez", el_edit.value[e_value.SCA_X + axis_edit], 1, action_el_sca, axis_edit, tab.scale.tbx_z)

	draw_textfield_group("elementeditorscale", dx, dy, dw, 0.1, 0.001, no_limit, snap_value)
	tab_next()
}
