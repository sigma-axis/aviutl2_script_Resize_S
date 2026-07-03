--information:ボックスリサイズσ@Resize_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Resize_S
--require:${LEAST_AVIUTL_VERSION}
---$track:X, min = 0, max = 4000, step = 1, scale = 0.25
local width = 256

---$track:Y, min = 0, max = 4000, step = 1, scale = 0.25
local height = 256

---$select:モード
---内接最大 = 0
---外接最小 = 1
local mode = 0

---$select:拡大縮小
---拡縮両方 = 0
---拡大のみ = 1
---縮小のみ = 2
local dir = 0

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

--group:整列,false
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

---$checksection:中心の位置を変更
local move_center = true

--group
---$checksection:余白/クリッピング
local crop_pad = true

--group:その他,false
---$value:PI
local PI = {}

local obj, math, tonumber, type = obj, math, tonumber, type;

-- take parameters.
--[==[
	PI = {
		sz:          table? { x, y },
		mode:        string?,
		dir:         string?,
		move_center: boolean|number?,
		crop_pad:    boolean|number?,
		align:       table? { ax, ay },
		upscale:     string?,
		downscale:   string?,
	}
--]==]
local function as_bool(t, v)
	if type(t) == "boolean" then return t;
	elseif type(t) == "number" then return t ~= 0;
	else return v end
end
if type(PI.sz) == "table" then
	width = tonumber(PI.sz[1]) or width;
	height = tonumber(PI.sz[2]) or height;
end
if PI.mode then
	local name2num = {
		[0] = 0, 1; -- legacy compatibility.
		["内接最大"] = 0, ["外接最小"] = 1,
	};
	mode = name2num[PI.mode] or mode;
end
if PI.dir then
	local name2num = {
		[0] = 0, 1, 2; -- legacy compatibility.
		["拡縮両方"] = 0, ["拡大のみ"] = 1, ["縮小のみ"] = 2,
	};
	dir = name2num[PI.dir] or dir;
end
move_center = as_bool(PI.move_center, move_center);
crop_pad = as_bool(PI.crop_pad, crop_pad);
if type(PI.align) == "table" then
	align_x = tonumber(PI.align[1]) or align_x;
	align_y = tonumber(PI.align[2]) or align_y;
end
if type(PI.upscale) == "string" then upscale = PI.upscale;
else
	local num2name = {
		[0] = "最近傍法", "双線形",
		"Mitchell-Netravali", "Catmull-Rom",
		"Lanczos2", "Lanczos3";
	};
	upscale = num2name[tonumber(PI.upscale) or upscale] or num2name[5];
end
if type(PI.downscale) == "string" then downscale = PI.downscale;
else
	-- ", [0] = "最近傍法", "単純平均", "双線形", "Hamming", "Lanczos2", "Lanczos3", "
	local num2name = {
		[0] = "最近傍法", "単純平均", "双線形",
		"Hamming", "Lanczos2", "Lanczos3";
	};
	downscale = num2name[tonumber(PI.downscale) or downscale] or num2name[5];
end

-- normalize paramters.
width, height = math.max(width, 0), math.max(height, 0);
mode = math.min(math.max(math.floor(0.5 + mode), 0), 1);
dir = math.min(math.max(math.floor(0.5 + dir), 0), 2);
align_x, align_y = math.min(math.max(align_x / 100, -1), 1), math.min(math.max(align_y / 100, -1), 1);

-- calculate the size.
local w, h = obj.w, obj.h;
local W, H, zoom;
if (mode == 0) == (width * h <= height * w) then
	W, H, zoom = width, math.floor(0.5 + width / w * h), width / w;
else W, H, zoom = math.floor(0.5 + height / h * w), height, height / h end
if (dir == 2 and (W >= w and H >= h)) or
	(dir == 1 and (W <= w and H <= h)) then
	W, H, zoom = w, h, 1; -- no resize.
end

-- restrict range to process.
local cr_l, cr_L, cr_t, cr_T, cr_r, cr_R, cr_b, cr_B = 0, 0, 0, 0, 0, 0, 0, 0;
if crop_pad and mode == 1 then
	if W > width then
		local len = w * (1 - width / W);
		cr_l, cr_L = math.modf(len * (1 + align_x) / 2);
		cr_r, cr_R = math.modf(len * (1 - align_x) / 2);
		w = w - (cr_l + cr_r);
		W = math.floor(0.5 + zoom * w);
		if cr_L + cr_R == 0 then cr_L, cr_R = 1, 1 end
		cr_L = math.floor(0.5 + (W - width) * cr_L / (cr_L + cr_R));
		cr_R = (W - width) - cr_L;
	end
	if H > height then
		local len = h * (1 - height / H);
		cr_t, cr_T = math.modf(len * (1 + align_y) / 2);
		cr_b, cr_B = math.modf(len * (1 - align_y) / 2);
		h = h - (cr_t + cr_b);
		H = math.floor(0.5 + zoom * h);
		if cr_T + cr_B == 0 then cr_T, cr_B = 1, 1 end
		cr_T = math.floor(0.5 + (H - height) * cr_T / (cr_T + cr_B));
		cr_B = (H - height) - cr_T;
	end
end
local max_W, max_H = obj.getinfo("image_max");
if W > max_W then
	local lr = math.ceil(w * (1 - max_W / W) / 2);
	w, W = w - 2 * lr, math.floor(0.5 + (1 - 2 * lr / w) * W);
	cr_l, cr_r = cr_l + lr, cr_r + lr;
end
if H > max_H then
	local tb = math.ceil(h * (1 - max_H / H) / 2);
	h, H = h - 2 * tb, math.floor(0.5 + (1 - 2 * tb / h) * H);
	cr_t, cr_b = cr_t + tb, cr_b + tb;
end
if cr_l > 0 or cr_r > 0 or cr_t > 0 or cr_b > 0 then
	obj.effect("クリッピング", "上", cr_t, "下", cr_b, "左", cr_l, "右", cr_r,
		"中心の位置を変更", move_center and 1 or 0);
end

-- apply resizing.
if W ~= w or H ~= h then
	obj.effect("リサイズσ@Resize_S", "PI", ([[
		sz = { %d, %d },
		move_center = %s,
		absolute = true,
		upscale = %q,
		downscale = %q,
	]]):format(W, H, move_center, upscale, downscale));
end

-- process cropping and padding.
if cr_L > 0 or cr_R > 0 or cr_T > 0 or cr_B > 0 then
	obj.effect("クリッピング", "上", cr_T, "下", cr_B, "左", cr_L, "右", cr_R,
		"中心の位置を変更", move_center and 1 or 0);
end
if crop_pad and mode == 0 then
	cr_L, cr_T, cr_R, cr_B = 0, 0, 0, 0;
	if obj.w < width then
		cr_L = math.floor(0.5 + (width - obj.w) * (1 + align_x) / 2);
		cr_R = (width - obj.w) - cr_L;
	end
	if obj.h < height then
		cr_T = math.floor(0.5 + (height - obj.h) * (1 + align_y) / 2);
		cr_B = (height - obj.h) - cr_T;
	end
	if cr_L > 0 or cr_R > 0 or cr_T > 0 or cr_B > 0 then
		obj.effect("領域拡張", "上", cr_T, "下", cr_B, "左", cr_L, "右", cr_R);

		-- adjust the center.
		if not move_center then
			obj.cx, obj.cy = obj.cx + (cr_L - cr_R) / 2, obj.cy + (cr_T - cr_B) / 2;
		end
	end
end
