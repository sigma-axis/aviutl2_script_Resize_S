float ker(float x)
{
	static const float pi = 4 * atan(1), a0 = 25.0 / 46, a1 = 1 - a0;
	return a0 - a1 * cos(pi / 2 * x);
}

float4 hamming_dn(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float2 src_x_f = inv_zoom * (pos.y + float2(-1, 1));
	const int2 src_x_i = floor(src_x_f + 0.5);
	float t = zoom * (src_x_i[0] + 0.5) - pos.y;

	float4 sum = 0.0; float wt = 0.0;
	for (int x = src_x_i[0]; x < src_x_i[1]; x++) {
		const float w = ker(t);
		sum += w * load(x, y);
		wt += w; t += zoom;
	}

	return sum / wt;
}
