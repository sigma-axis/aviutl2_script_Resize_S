Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float zoom, inv_zoom, width_f;
};
const static int width = int(width_f);
float4 load(int x, int y)
{
	return src[uint2(clamp(x, 0, width - 1), y)];
}

float ker0(float x)
{
	return (1 + x - 1.5 * x * x) * (1 - x);
}
float ker1(float x)
{
	return 0.5 * (1 - x) * (2 - x) * (2 - x);
}

float4 cubic_CR_up(float4 pos : SV_Position) : SV_Target
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
