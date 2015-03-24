--[[ Requires all of the lua scripts in a given directory
The 2nd argument specifies whether or not to descend recursively.
Defaults to recursive. ]]--
function require_dir(dir, recursive)
  --Default for recursive is false
	if recursive == nil then recursive = true end

	local files = love.filesystem.getDirectoryItems(dir)
	_.each(files, function(file)
		if  love.filesystem.isFile( dir .. "/" .. file ) then
			if string.sub(file, -4, -1) == ".lua" then
				modulename = string.sub(file, 0, -5)
				require(dir .. "/" .. modulename)
			end
		end
	end)

	if recursive then
		_.each(files, function(file)
			if love.filesystem.isDirectory( dir .. "/" .. file ) then
				require_dir( dir .. "/" .. file, recursive)
			end
		end)
	end
end

--[[ Utility function to get a reference to an image.
This prevents calling love.graphics.newImage many times,
as image data does not have to be re-loaded for each entity.
This saves both time and memory ]]--
local images = {}
setmetatable(images, {__mode = "v"})

function getImage(filename)
	local image = images[filename]
	if image == nil then
		image = love.graphics.newImage( filename )
		image:setFilter("linear", "nearest")
		images[filename] = image
	end
	return image
end

--[[ Same as above, but for shaders ]]--
local shaders = {}
setmetatable(shaders, {__mode = "v"})

function getShader(filename)
	local shader = shaders[filename]
	if shader == nil then
		shader = love.graphics.newShader(filename)
		shaders[filename] = shader
	end
	return shader
end

--[[ Same as above, but for fonts]]--
local fonts = {}
setmetatable(fonts, {__mode = "v"})

function getFont(filename, size)
	local key = filename .. size
	local font = fonts[key]
	if font == nil then
		font = love.graphics.newFont(filename, size)
		fonts[key] = font
	end
	return font
end

-- String utilities
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function string.ends(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function formatTimer(time)
	minutes = math.floor(time / 60)
	seconds = math.floor(time) % 60

	return string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds)
end

--[[ Returns the coordinates of a polygon representing an oval.
Coordinates returned as a list of tables, as {{x1, y1}, {x2, y2}} ]]--
function ovalShape(width, height, segments)
	local shape = {}
	for i=0, segments - 1 do
		local angle = (i / segments)*2*math.pi
		local x, y = math.sin(angle), math.cos(angle)
		_.push(shape, {x * width, y * height})
	end
	return shape
end