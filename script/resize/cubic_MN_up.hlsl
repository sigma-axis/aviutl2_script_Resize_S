Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float inv_zoom;
};

int get_width()
{
	uint w_src_u, _;
	src.GetDimensions(w_src_u, _);
	return int(w_src_u);
}
const static int max_src = get_width() - 1;
float4 load(int2 pos)
{
	return src.Load(int3(clamp(pos.x, 0, max_src), pos.y, 0));
}

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
	float2 pos_src = float2(inv_zoom * pos.y, pos.x) - 0.5;
	int2 pos_src_i = floor(pos_src);
	float t = pos_src.x - pos_src_i.x;

	float4 sum = 0.0;
	sum += ker1(t + 1) * load(pos_src_i - int2(1, 0));
	sum += ker0(t    ) * load(pos_src_i);
	sum += ker0(1 - t) * load(pos_src_i + int2(1, 0));
	sum += ker1(2 - t) * load(pos_src_i + int2(2, 0));

	return saturate(sum);
}
