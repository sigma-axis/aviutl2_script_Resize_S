float4 nearest(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float src_x_f = inv_zoom * pos.y;
	const int src_x_i = floor(src_x_f);

	return load(src_x_i, y);
}
