/// history_save_loaded()
/// @desc Stores the newly loaded objects.

loaded_amount = 0

with (obj_texture)
{
	if (loaded)
	{
		other.loaded_save_id[other.loaded_amount] = save_id
		other.loaded_amount++
	}
}