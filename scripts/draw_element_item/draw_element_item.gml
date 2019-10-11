/// draw_element_item(element, y, [increment])
/// @arg element
/// @arg y
/// @arg [increment]
/// @desc Draws an element item

var element, yy, increment;
var itemx, itemy, itemw, itemh, movehover, itemhover, expandhover, lockhover, visiblehover, itemvisible, xx, ww, linex, minw, mouseonlist;
var hideshapes;
element = argument[0]
yy = argument[1]
increment = 0

if (argument_count > 2)
	increment = argument[2]

itemx = dx + (24 * increment)
itemy = yy
itemw = dw - (24 * increment)
itemh = 28
movehover = app_mouse_box_busy(dx, itemy, dw, itemh, "elementmove")
itemhover = app_mouse_box(dx, itemy, dw, itemh) && content_mouseon
expandhover = false
lockhover = false
itemvisible = (itemy < window_height) && (itemy + itemh > 0)

hideshapes = setting_hide_shapes || (element_move_parts > 0 && window_busy = "elementmove")

if (itemvisible)
{
	// Hover highlight
	if (itemhover)
		mouse_cursor = cr_handpoint
	
	// Select highlight
	if (itemhover && mouse_left && element.list_mouseon)
		draw_box(dx, itemy, dw, itemh, false, c_accent_overlay, a_accent_overlay)
	else if (element.selected || itemhover || element = context_menu_value)
		draw_box(dx, itemy, dw, itemh, false, c_overlay, a_overlay)
	
	// Add to select list
	if ((window_busy = "elementselection" || window_busy = "elementselectiondone"))
	{
		var highlight = box_intersect(dx, itemy, dw, itemh, element_select_x, element_select_y, element_select_width, element_select_height);
	
		if (highlight)
			draw_box(dx, itemy, dw, itemh, false, c_accent_overlay, a_accent_overlay)
	
		if (element_select_list != null && highlight)
			ds_list_add(element_select_list, element)
	}
	
	draw_set_font(font_value)
}



xx = itemx + itemw - 24
minw = 4 + 20 + 4 + 20 + 8 + string_width("...") + (8 + 20 + 4 + 20)

#region Right side icons

// Visible
if (itemvisible)
{
	if (itemhover || element.hidden)
	{
		if (draw_button_icon("assetselementhidden" + string(element), xx, itemy + 4, 20, 20, element.hidden, e_icon.show + element.hidden, null, window_busy = "elementselection", test(element.hidden, "tooltipshow", "tooltiphide")))
		{
			element.hidden = !element.hidden
			el_update_hidden_tree(false)
		}
		visiblehover = app_mouse_box(xx, itemy + 4, 20, 20)
	}
	else if (element.tree_hidden)
		draw_image(spr_icons, e_icon.dot, xx + 10, itemy + 14, 1, 1, c_text_secondary, a_text_secondary)
}


xx -= 24

// Locked
if (itemvisible)
{
	if (itemhover || element.locked)
	{
		if (draw_button_icon("assetselementlock" + string(element), xx, itemy + 4, 20, 20, element.locked, e_icon.unlock - element.locked, null, window_busy = "elementselection", test(element.locked, "tooltipunlock", "tooltiplock")))
		{
			element.locked = !element.locked
			el_update_lock_tree(false)
		}
		lockhover = app_mouse_box(xx, itemy + 4, 20, 20)
	}
	else if (element.tree_locked)
		draw_image(spr_icons, e_icon.dot, xx + 10, itemy + 14, 1, 1, c_text_secondary, a_text_secondary)
}

#endregion

xx = min((dx + dw - minw) + 4, itemx + 4)
ww = max(minw, itemw)

#region Left side icons

// Expand/collapse children/shape list(s)
var haschildren;
haschildren = element.element_type = TYPE_PART
haschildren = haschildren && ((element.part_list != null && ds_list_size(element.part_list) > 0) || (!hideshapes && (element.shape_list != null && ds_list_size(element.shape_list) > 0)))
if (itemvisible && haschildren)
{
	if (draw_button_icon("assetspartshowchildren" + string(element), xx, itemy + 4, 20, 20, element.extend, null, null, window_busy = "elementselection", test(element.extend, "tooltipcollapse", "tooltipexpand"), spr_arrow_small_ani))
		element.extend = !element.extend
}
expandhover = app_mouse_box(xx, itemy + 4, 20, 20)

xx += 24
mouseonlist = (itemvisible && itemhover && !expandhover && !lockhover && !visiblehover)

// Element icon
if (itemvisible)
{
	var icon, iconcolor, iconalpha;
	if (element.element_type = TYPE_PART)
		icon = e_icon.part
	else
	{
		if (element.type = "block")
			icon = e_icon.block
		else if (element.type = "plane")
		{
			if (element.value[e_value.EXTRUDE])
				icon = e_icon.plane3d
			else
				icon = e_icon.plane
		}
	}
	
	if (element.selected || (mouseonlist && (mouse_left || mouse_left_released)))
	{
		iconcolor = c_accent
		iconalpha = 1
	}
	else
	{
		iconcolor = c_text_tertiary
		iconalpha = a_text_tertiary
	}
	
	if (element.name_duplicate || element.name_empty)
	{
		iconcolor = c_error
		iconalpha = 1
	}
	
	draw_image(spr_icons, icon, xx + 10, itemy + (itemh/2), 1, 1, iconcolor, iconalpha)
}

#endregion

linex = xx + 10
xx += 28

#region Extend if moving elements

if (movehover && (mouse_still > 15 * (60 / room_speed)) && window_busy = "elementmove" && haschildren)
	element.extend = true
	
#endregion

#region Element name
if (itemvisible)
{
	var labelname, labelshort, labelcolor, labelalpha;
	labelname = element.name
	
	if (labelname = "")
	{
		if (element.element_type = TYPE_PART)
			labelname = text_get("assetsnewpart")
		else
			labelname = text_get("assetsnewshape")
	}
	
	if (element.name = "" || element.hidden || element.tree_hidden)
	{
		labelcolor = c_text_secondary
		labelalpha = a_text_secondary
	}
	else
	{
		labelcolor = c_text_main
		labelalpha = a_text_main
	}
	
	if (element.selected || (mouseonlist && (mouse_left || mouse_left_released)))
	{
		labelcolor = c_accent
		labelalpha = 1
	}
	
	if (element.name_duplicate || element.name_empty)
	{
		labelcolor = c_error
		labelalpha = 1
	}
	
	labelshort = string_limit_font(labelname, itemw - (xx - itemx) - 52, font_value)
	draw_label(labelshort, xx, itemy + (itemh/2), fa_left, fa_middle, labelcolor, labelalpha)
	
	// Preview name tooltip
	if (string_width(labelname) > itemw - (xx - itemx) - 52)
		tip_set(labelname, xx, itemy, string_width_font(labelshort, font_value), 28)
}
#endregion

if (itemvisible && itemhover && !expandhover && !lockhover && !visiblehover)
{
	element.list_mouseon = true
	context_menu_area(itemx, itemy, itemw, itemh, "contextmenuelement", element, e_value_type.NONE, null, null)
	
	if (mouse_move > 5)
	{
		// Start box selection or moving
		if (element.selected)
		{
			window_busy = "elementmovestart"
		}
		else
		{
			window_busy = "elementselectionstart"
			element_select_start_x = mouse_x
			element_select_start_y = mouse_y + tab.scroll.value
		}
	}
	
	if (mouse_left_released && window_busy = "")
		action_el_select(element)
}
else
	element.list_mouseon = false

// Move elements
if (itemvisible && movehover && window_busy = "elementmove")
{
	var indexmove, list, index, movesize;
	indexmove = test(element_move_parts = 0 && element.element_type = TYPE_PART, false, true)
	list = element_get_list(element.parent, element)
	index = ds_list_find_index(list, element)
	movesize = test(element_move_parts = 0, 10, 6)
	
	// Shapes can't be parented to root
	if (element_move_shapes > 0 && element.parent.object_index = app)
		indexmove = false
	
	xx = dx + dw - ww
	
	if (indexmove && mouse_y < (itemy + movesize)) // Parent to above this element's index
	{
		draw_box(xx, itemy - 3, ww, 6, false, c_hover, a_hover)
		
		if (index = 0)
			tip_set(text_get("assetsmoveabove", element_name_get(element)), xx + ww/2, itemy, null, null, false)
		else
			tip_set(text_get("assetsmovebelow", element_name_get(list[|index - 1])), xx + ww/2, itemy, null, null, false)
		
		element_move_parent = element.parent
		element_move_index = index
	}
	else if (indexmove && mouse_y > (itemy + itemh - movesize)) // Parent below this element's index
	{
		draw_box(xx, itemy + itemh - 3, ww, 6, false, c_hover, a_hover)
		tip_set(text_get("assetsmovebelow", element_name_get(element)), xx + ww/2, itemy + itemh, null, null, false)
		element_move_parent = element.parent
		element_move_index = index + 1
	}
	else if (element.element_type = TYPE_PART) // Parent to the end of this element
	{
		draw_box(xx, itemy, ww, itemh, false, c_hover, a_hover)
		tip_set(text_get("assetsparentto", element_name_get(element)), xx + ww/2, itemy + itemh, null, null, false)
		element_move_parent = element
	}
	
}

#region Continue hierarchy
dy += 28

if (element.element_type = TYPE_PART && element.extend)
{
	// Draw shapes
	if (element.shape_list != null && !hideshapes)
	{
		if (itemvisible)
			draw_box(linex, itemy + itemh, 1, (28 * ds_list_size(element.shape_list)) - 13, false, c_border, a_border)
		
		for(var i = 0; i < ds_list_size(element.shape_list); i++)
		{
			if (itemvisible)
				draw_box(linex + 1, dy + (itemh/2), 9, 1, false, c_border, a_border)
			
			draw_element_item(element.shape_list[|i], dy, increment + 1)
		}
	}
	
	// Draw children parts
	if (element.part_list != null)
	{
		for(var i = 0; i < ds_list_size(element.part_list); i++)
			draw_element_item(element.part_list[|i], dy, increment + 1)
	}
}
#endregion
