float ker0(float x)
{
	return (8 / 9.0) - (2 - (7 / 6.0) * x) * x * x;
}
float ker1(float x)
{
	return (8 - 7 * x) * (2 - x) * (2 - x) / 18.0;
}

float4 cubic_MN_up(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float src_x_f = inv_zoom * pos.y - 0.5;
	const int src_x_i = floor(src_x_f);
	src_x_f -= src_x_i;

	float4 sum = 0.0;
	sum += ker1(src_x_f + 1) * load(src_x_i - 1, y);
	sum += ker0(src_x_f    ) * load(src_x_i    , y);
	sum += ker0(1 - src_x_f) * load(src_x_i + 1, y);
	sum += ker1(2 - src_x_f) * load(src_x_i + 2, y);

	return sum;
}
