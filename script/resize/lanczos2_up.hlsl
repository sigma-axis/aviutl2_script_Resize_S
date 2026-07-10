float ker(float x)
{
	static const float pi = 4 * atan(1);
	if (abs(x) < 1 / 256.0)
		return 1 - (pi * pi * (1 + 1 / 4.0) / 6) * (x * x); // differs only by O(x^4).
	return sin((pi / 2) * x) * sin(pi * x) / ((pi * pi / 2) * x * x);
}

float4 lanczos2_up(float4 pos : SV_Position) : SV_Target
{
	const int y = int(pos.x);
	float src_x_f = inv_zoom * pos.y - 0.5;
	const int src_x_i = floor(src_x_f);
	src_x_f -= src_x_i;

	float4 sum = 0.0; float wt = 0.0, w;
	w = ker(src_x_f + 1); sum += w * load(src_x_i - 1, y); wt += w;
	w = ker(src_x_f    ); sum += w * load(src_x_i    , y); wt += w;
	w = ker(src_x_f - 1); sum += w * load(src_x_i + 1, y); wt += w;
	w = ker(src_x_f - 2); sum += w * load(src_x_i + 2, y); wt += w;

	return sum / wt;
}
