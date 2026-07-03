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

float ker(float x)
{
	const float pi = 3.14159265358979323846;
	if (abs(x) < 1 / 256.0)
		return 1 - (pi * pi * (1 + 1 / 4.0) / 6) * (x * x); // differs only by O(x^4).
	return sin((pi / 2) * x) * sin(pi * x) / ((pi * pi / 2) * x * x);
}

float4 lanczos2_up(float4 pos : SV_Position) : SV_Target
{
	float2 pos_src = float2(inv_zoom * pos.y, pos.x) - 0.5;
	int2 pos_src_i = floor(pos_src);
	float t = pos_src.x - pos_src_i.x;

	float4 sum = 0.0; float V = 0.0, v;
	v = ker(t + 1); sum += v * load(pos_src_i - int2(1, 0)); V += v;
	v = ker(t    ); sum += v * load(pos_src_i);              V += v;
	v = ker(t - 1); sum += v * load(pos_src_i + int2(1, 0)); V += v;
	v = ker(t - 2); sum += v * load(pos_src_i + int2(2, 0)); V += v;

	return saturate(sum / V);
}
