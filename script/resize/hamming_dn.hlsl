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
	const float pi = 3.14159265358979323846,
		a0 = 0.53836, a1 = 0.46164;
	return a0 - a1 * cos(pi / 2 * x);
}

float4 hamming_dn(float4 pos : SV_Position) : SV_Target
{
	float zoom = 1 / inv_zoom;
	int3 pos_src_i = floor(float3(inv_zoom * (pos.y - 1) + 1, inv_zoom * (pos.y + 1), pos.x) - 0.5);
	float t = zoom * (pos_src_i.x + 0.5) - pos.y;

	float4 sum = 0.0; float V = 0.0;
	for (int x = pos_src_i.x; x <= pos_src_i.y; x++) {
		float v = ker(t);
		sum += v * load(int2(x, pos_src_i.z));
		V += v; t += zoom;
	}

	return sum / V;
}
