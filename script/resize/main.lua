--information:リサイズσ@Resize_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Resize_S
--require:${LEAST_AVIUTL_VERSION}
---$track:拡大率, min = 0, max = 5000, step = 0.001, scale = 0.04
local zoom = 100

---$track:X, min = 0, max = 5000, step = 0.001, scale = 0.04
local sz_x = 100

---$track:Y, min = 0, max = 5000, step = 0.001, scale = 0.04
local sz_y = 100

---$checksection:ピクセル数でサイズ指定
local absolute = false

--group:アルゴリズム,true
---$select:拡大方法
---最近傍法 = 0
---双線形 = 1
---Mitchell-Netravali = 2
---Catmull-Rom = 3
---Lanczos2 = 4
---Lanczos3 = 5
local upscale = 5

---$select:縮小方法
---最近傍法 = 0
---単純平均 = 1
---双線形 = 2
---Hamming = 3
---Lanczos2 = 4
---Lanczos3 = 5
local downscale = 5

--group
---$checksection:中心の位置を変更
local move_center = false

--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@transpose:
---$include "transpose.hlsl"
]]
--[[pixelshader@nearest:
---$include "header.hlsl"
---$include "nearest.hlsl"
]]
--[[pixelshader@bilinear_up:
---$include "header.hlsl"
---$include "bilinear_up.hlsl"
]]
--[[pixelshader@cubic_MN_up:
---$include "header.hlsl"
---$include "cubic_MN_up.hlsl"
]]
--[[pixelshader@cubic_CR_up:
---$include "header.hlsl"
---$include "cubic_CR_up.hlsl"
]]
--[[pixelshader@lanczos2_up:
---$include "header.hlsl"
---$include "lanczos2_up.hlsl"
]]
--[[pixelshader@lanczos3_up:
---$include "header.hlsl"
---$include "lanczos3_up.hlsl"
]]
--[[pixelshader@average_dn:
---$include "header.hlsl"
---$include "average_dn.hlsl"
]]
--[[pixelshader@bilinear_dn:
---$include "header.hlsl"
---$include "bilinear_dn.hlsl"
]]
--[[pixelshader@hamming_dn:
---$include "header.hlsl"
---$include "hamming_dn.hlsl"
]]
--[[pixelshader@lanczos2_dn:
---$include "header.hlsl"
---$include "lanczos2_dn.hlsl"
]]
--[[pixelshader@lanczos3_dn:
---$include "header.hlsl"
---$include "lanczos3_dn.hlsl"
]]

local obj, math, tonumber, type = obj, math, tonumber, type;

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		zoom:        number?,
		sz:          table? { x, y },
		absolute:    boolean|number|nil,
		upscale:     string?,
		downscale:   string?,
		move_center: boolean|number|nil,
	}
--]==]
local function as_bool(t, v)
	if type(t) == "boolean" then return t;
	elseif type(t) == "number" then return t ~= 0;
	else return v end
end
zoom = tonumber(PI.zoom) or zoom;
if type(PI.sz) == "table" then
	sz_x = tonumber(PI.sz[1]) or sz_x;
	sz_y = tonumber(PI.sz[2]) or sz_y;
end
absolute = as_bool(PI.absolute, absolute);
if PI.upscale then
	local name2num = {
		[0] = 0, 1, 2, 3, 4, 5; -- legacy compatibility.
		["最近傍法"] = 0, ["双線形"] = 1,
		["Mitchell-Netravali"] = 2, ["Catmull-Rom"] = 3,
		["Lanczos2"] = 4, ["Lanczos3"] = 5,
	};
	upscale = name2num[PI.upscale] or upscale;
end
if PI.downscale then
	local name2num = {
		[0] = 0, 1, 2, 3, 4, 5; -- legacy compatibility.
		["最近傍法"] = 0, ["単純平均"] = 1,
		["双線形"] = 2, ["Hamming"] = 3,
		["Lanczos2"] = 4, ["Lanczos3"] = 5,
	};
	downscale = name2num[PI.downscale] or downscale;
end
move_center = as_bool(PI.move_center, move_center);

-- normalize paramters.
zoom = math.max(zoom / 100, 0);
sz_x, sz_y = math.max(sz_x, 0), math.max(sz_y, 0);
if absolute then
	sz_x, sz_y = math.floor(sz_x), math.floor(sz_y);
else sz_x, sz_y = sz_x / 100, sz_y / 100 end
upscale = math.min(math.max(math.floor(0.5 + upscale), 0), 5);
downscale = math.min(math.max(math.floor(0.5 + downscale), 0), 5);

--#endregion PI / normalize parameters.

-- calculate the size.
local w, h = obj.w, obj.h;
local W, H = w, h;
if absolute then W, H = sz_x, sz_y;
else W, H = sz_x * W, sz_y * H end
local max_W, max_H = obj.getinfo("image_max");
W, H = math.min(math.floor(0.5 + zoom * W), max_W), math.min(math.floor(0.5 + zoom * H), max_H);
if W == w and H == h then return end -- no resize.
if W == 0 or H == 0 then obj.load("text", ""); return end

-- prepare shaders.
local cache_name = "cache:resize_s/temp"
local shader_up, shader_dn = ({
	"nearest",
	"bilinear_up",
	"cubic_MN_up",
	"cubic_CR_up",
	"lanczos2_up",
	"lanczos3_up",
})[upscale + 1], ({
	"nearest",
	"average_dn",
	"bilinear_dn",
	"hamming_dn",
	"lanczos2_dn",
	"lanczos3_dn",
})[downscale + 1];
local shader_x, shader_y =
	(W > w and shader_up) or (W < w and shader_dn) or "transpose",
	(H > h and shader_up) or (H < h and shader_dn) or "transpose";

-- first along x-axis.
obj.clearbuffer(cache_name, h, W);
obj.pixelshader(shader_x, cache_name, "object",
{
	W / w, w / W, w
});

-- then along y-axis.
obj.clearbuffer("object", W, H);
obj.pixelshader(shader_y, "object", cache_name,
{
	H / h, h / H, h
});

-- adjust the center.
if not move_center then
	local cx, cy, _ = obj.getvalue("center");
	obj.cx = (obj.cx + cx) * W / w - cx;
	obj.cy = (obj.cy + cy) * H / h - cy;
end
