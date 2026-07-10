float4 average_dn(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float2 src_x_f = inv_zoom * (pos.y + float2(-0.5, 0.5));
	const int2 src_x_i = floor(src_x_f);
	src_x_f -= src_x_i;

	float4 sum = (1 - src_x_f[0]) * load(src_x_i[0], y);
	for (int x = src_x_i[0] + 1; x < src_x_i[1]; x++)
		sum += load(x, y);
	sum += src_x_f[1] * load(src_x_i[1], y);

	return sum * zoom;
}
