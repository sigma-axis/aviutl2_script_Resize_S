Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float zoom, inv_zoom, width_f;
};
const static int width = int(width_f);
float4 load(int x, int y)
{
	return src[uint2(clamp(x, 0, width - 1), y)];
}
