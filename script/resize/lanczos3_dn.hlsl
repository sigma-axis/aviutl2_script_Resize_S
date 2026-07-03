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
		return 1 - (pi * pi * (1 + 1 / 9.0) / 6) * (x * x); // differs only by O(x^4).
	return sin((pi / 3) * x) * sin(pi * x) / ((pi * pi / 3) * x * x);
}

float4 lanczos3_dn(float4 pos : SV_Position) : SV_Target
{
	float zoom = 1 / inv_zoom;
	int3 pos_src_i = floor(float3(inv_zoom * (pos.y - 3) + 1, inv_zoom * (pos.y + 3), pos.x) - 0.5);
	float t = zoom * (pos_src_i.x + 0.5) - pos.y;

	float4 sum = 0.0; float V = 0.0;
	for (int x = pos_src_i.x; x <= pos_src_i.y; x++) {
		float v = ker(t);
		sum += v * load(int2(x, pos_src_i.z));
		V += v; t += zoom;
	}

	return sum / V;
}
