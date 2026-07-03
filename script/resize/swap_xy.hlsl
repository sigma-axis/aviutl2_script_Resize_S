Texture2D src : register(t0);
float4 swap_xy(float4 pos : SV_Position) : SV_Target
{
	return src[pos.yx];
}
