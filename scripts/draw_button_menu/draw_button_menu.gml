/// draw_button_menu(name, type, x, y, width, height, value, text, script, [disabled, [texture]])
/// @arg name
/// @arg type
/// @arg x
/// @arg y
/// @arg width
/// @arg height
/// @arg value
/// @arg text
/// @arg script
/// @arg [disabled
/// @arg [texture]]

var name, type, xx, yy, wid, hei, value, text, script, tex, disabled;
var flip, imgsize, mouseon, pressed, textoff;
name = argument[0]
type = argument[1]
xx = argument[2] 
yy = argument[3]
wid = argument[4]
hei = argument[5]
value = argument[6]
text = argument[7]
script = argument[8]

if (xx + wid < content_x || xx > content_x + content_width || yy + hei < content_y || yy > content_y + content_height)
	return 0
	
if (argument_count > 9)
	disabled = argument[9]
else
	disabled = null
	
if (argument_count > 10)
	tex = argument[10]
else
	tex = null

yy += 48 - 28

flip = (yy + hei + hei * 4 > window_height)
imgsize = hei - 4

// Mouse
mouseon = app_mouse_box(xx, yy, wid, hei) && !disabled

if (!content_mouseon)
	mouseon = false

pressed = false
if (mouseon)
{
	if (mouse_left || mouse_left_released)
		pressed = true
	mouse_cursor = cr_handpoint
}

if (menu_name = name)
	pressed = true

microani_set(name, null, false, false, false)

var labelcolor, labelalpha;
labelcolor = merge_color(c_neutral50, c_neutral30, mcroani_arr[e_mcroani.DISABLED])
labelalpha = lerp(a_neutral50, a_neutral30, mcroani_arr[e_mcroani.DISABLED])

// Label
draw_label(text_get(name), xx, yy - 8, fa_left, fa_bottom, labelcolor, labelalpha, font_label)

// Button
draw_box(xx, yy, wid, hei, false, c_background, 1)
draw_outline(xx, yy, wid, hei, 2, labelcolor, labelalpha)

// Sprite
if (tex != null)
	draw_texture(tex, xx + 8, yy + 2, imgsize / texture_width(tex), imgsize / texture_height(tex))

// Text
var textcolor, textalpha;
textcolor = merge_color(c_neutral60, c_neutral30, mcroani_arr[e_mcroani.DISABLED])
textalpha = lerp(a_neutral60, a_neutral30, mcroani_arr[e_mcroani.DISABLED])

textoff = test(tex, (imgsize - 4), 0)
draw_label(string_limit(string_remove_newline(text), wid - textoff - hei - 8), xx + test(tex = null, 0, imgsize) + 8, yy + hei / 2, fa_left, fa_middle, textcolor, textalpha, font_value)

// Arrow
draw_image(spr_icons, test(test(menu_name = name, !flip, flip), e_icon.arrow_top_small, e_icon.arrow_down_small), xx + wid - hei / 2, yy + hei / 2, 1, 1, labelcolor, labelalpha)

microani_update(false, false, false, disabled)

// Update menu position
if (menu_name = name)
{
	menu_x = xx
	menu_y = yy
}

// Check click
if (mouseon && mouse_left_released)
{
	window_busy = "menu"
	window_focus = string(menu_scroll)
	app_mouse_clear()
	
	menu_name = name
	menu_type = type
	menu_script = script
	menu_value = value
	menu_ani = 0
	menu_ani_type = "show"
	menu_flip = flip
	menu_x = xx
	menu_y = yy
	menu_w = wid
	menu_button_h = hei
	menu_item_padding = 2
	menu_item_w = wid
	menu_item_h = menu_button_h + (menu_item_padding * 2)
	
	if (!flip)
		menu_top_y = yy - 2
	
	// Init
	menu_clear()
	if (type = e_menu.LIST)
		menu_list_init()
	//else if (type = e_menu.TIMELINE)
	//	menu_timeline_init()
	//else
	//	menu_transition_init()
	
	menu_focus_selected()
		
	// Flip
	if (menu_flip)
		menu_show_amount = floor((menu_y * 0.9) / menu_item_h)
	else
		menu_show_amount = floor(((window_height - (menu_y + menu_button_h)) * 0.9) / menu_item_h)
	
	return true
}

return false