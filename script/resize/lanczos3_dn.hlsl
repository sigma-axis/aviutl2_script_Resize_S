float ker(float x)
{
	static const float pi = 4 * atan(1);
	if (abs(x) < 1 / 256.0)
		return 1 - (pi * pi * (1 + 1.0 / 9) / 6) * (x * x); // differs only by O(x^4).
	return sin((pi / 3) * x) * sin(pi * x) / ((pi * pi / 3) * x * x);
}

float4 lanczos3_dn(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float2 src_x_f = inv_zoom * (pos.y + float2(-2, 2));
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
