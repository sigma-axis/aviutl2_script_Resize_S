float4 bilinear_up(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float src_x_f = inv_zoom * pos.y - 0.5;
	const int src_x_i = floor(src_x_f);
	src_x_f -= src_x_i;

	return lerp(load(src_x_i, y), load(src_x_i + 1, y), src_x_f);
}
