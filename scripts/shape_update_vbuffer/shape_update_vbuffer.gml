/// shape_update_vbuffer()
/// @desc Updates a shape's vertex buffer

var bend = bend_default_angle;

// Invert/Limit angle
for (var i = X; i <= Z; i++)
{
	bend[i] *= test(parent.bend_invert[i], -1, 1)
	bend[i] = clamp(bend[i], parent.bend_direction_min[i], parent.bend_direction_max[i])
}

// Clear previous vertex buffer
if (shape_vbuffer != null)
{
	vbuffer_destroy(shape_vbuffer)
	shape_vbuffer = null
}

// Generate new
if (type = "block")
	shape_vbuffer = model_shape_generate_block(bend)
	
if (type = "plane")
{
	if (value[e_value.PLANE_3D])
	{
		if (res != null)
		{
			// Define texture pixels to use
			var tw, th, texsize, texsizeuv, texuv, samplepos, samplesize, alphamap;
			tw = texture_width(res.sprite)
			th = texture_height(res.sprite)
			texsize = point3D_sub(to_noscale, from_noscale)
			texsizeuv = vec2_div(vec2(texsize[X], texsize[Z]), texture_size)
			texuv = vec2_div(uv, texture_size)
			samplepos = point2D(floor(texuv[X] * tw), floor(texuv[Y] * th))
			samplesize = vec2(ceil(texsizeuv[X] * tw), ceil(texsizeuv[Y] * th))
					
			// Generate array with the alpha values of the texture
			var surf = surface_create(samplesize[X], samplesize[Y]);
			draw_texture_start()
			surface_set_target(surf)
			{
				draw_clear_alpha(c_black, 0)
				draw_texture_part(res.sprite, 0, 0, samplepos[X], samplepos[Y], samplesize[X], samplesize[Y])
			}
			surface_reset_target()
			draw_texture_done()
			alphamap = surface_get_alpha_array(surf)
			surface_free(surf)
			
			shape_vbuffer = model_shape_generate_plane_3d(bend, alphamap)
		}
	}
	else
		shape_vbuffer = model_shape_generate_plane(bend)
}
