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

--[[pixelshader@swap_xy:
---$include "swap_xy.hlsl"
]]
--[[pixelshader@cubic_MN_up:
---$include "cubic_MN_up.hlsl"
]]
--[[pixelshader@cubic_CR_up:
---$include "cubic_CR_up.hlsl"
]]
--[[pixelshader@lanczos2_up:
---$include "lanczos2_up.hlsl"
]]
--[[pixelshader@lanczos3_up:
---$include "lanczos3_up.hlsl"
]]
--[[pixelshader@bilinear_dn:
---$include "bilinear_dn.hlsl"
]]
--[[pixelshader@hamming_dn:
---$include "hamming_dn.hlsl"
]]
--[[pixelshader@lanczos2_dn:
---$include "lanczos2_dn.hlsl"
]]
--[[pixelshader@lanczos3_dn:
---$include "lanczos3_dn.hlsl"
]]

local obj, math, tonumber, type = obj, math, tonumber, type;

-- take parameters.
--[==[
	PI = {
		zoom:        number?,
		sz:          table? { x, y },
		move_center: boolean|number|nil,
		absolute:    boolean|number|nil,
		upscale:     string?,
		downscale:   string?,
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
move_center = as_bool(PI.move_center, move_center);
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

-- normalize paramters.
zoom = math.max(zoom / 100, 0);
sz_x, sz_y = math.max(sz_x, 0), math.max(sz_y, 0);
if absolute then
	sz_x, sz_y = math.floor(sz_x), math.floor(sz_y);
else sz_x, sz_y = sz_x / 100, sz_y / 100 end
upscale = math.min(math.max(math.floor(0.5 + upscale), 0), 5);
downscale = math.min(math.max(math.floor(0.5 + downscale), 0), 5);

-- calculate the size.
local w, h = obj.w, obj.h;
local W, H = w, h;
if absolute then W, H = sz_x, sz_y;
else W, H = sz_x * W, sz_y * H end
local max_W, max_H = obj.getinfo("image_max");
W, H = math.min(math.floor(0.5 + zoom * W), max_W), math.min(math.floor(0.5 + zoom * H), max_H);

-- apply resizing.
local alg_x, alg_y =
	(W > w and upscale) or (W < w and downscale) or 0,
	(H > h and upscale) or (H < h and downscale) or 0;
if W == w and H == h then return end -- no resize.

local function resize_builtin(W, H, interpolate)
	obj.effect("リサイズ", "ピクセル数でサイズ指定", 1,
		"補間なし", interpolate and 0 or 1, "X", W, "Y", H);
end
if W == 0 or H == 0 or (alg_x <= 1 and alg_y <= 1) then
	-- 標準の補間ありリサイズはバイリニアで拡大 / 単純平均 (最大 16 ドットサンプル?) で縮小．
	if alg_x == alg_y then resize_builtin(W, H, alg_x == 1);
	else
		resize_builtin(W, h, alg_x == 1);
		resize_builtin(W, H, alg_y == 1);
	end
else
	local upscale_names, downscale_names = {
		[2] = "cubic_MN_up",
		[3] = "cubic_CR_up",
		[4] = "lanczos2_up",
		[5] = "lanczos3_up",
	}, {
		[2] = "bilinear_dn",
		[3] = "hamming_dn",
		[4] = "lanczos2_dn",
		[5] = "lanczos3_dn",
	};

	-- first along x-axis.
	obj.clearbuffer("tempbuffer", h, W);
	if alg_x <= 1 then
		if W ~= w then resize_builtin(W, h, alg_x == 1) end
		obj.pixelshader("swap_xy", "tempbuffer", "object");
	else
		obj.pixelshader((W > w and upscale_names or downscale_names)[alg_x], "tempbuffer", "object",
		{
			w / W
		});
	end

	-- then along y-axis.
	if alg_y <= 1 then
		obj.clearbuffer("object", W, h);
		obj.pixelshader("swap_xy", "object", "tempbuffer");
		if H ~= h then resize_builtin(W, H, alg_y == 1) end
	else
		obj.clearbuffer("object", W, H);
		obj.pixelshader((H > h and upscale_names or downscale_names)[alg_y], "object", "tempbuffer",
		{
			h / H
		});
	end
end

-- adjust the center.
if not move_center then
	local cx, cy, _ = obj.getvalue("center");
	obj.cx = (obj.cx + cx) * W / w - cx;
	obj.cy = (obj.cy + cy) * H / h - cy;
end
