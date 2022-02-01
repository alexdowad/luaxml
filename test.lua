local xml = require('LuaXml')

function assertEquals(expression, actual, expected)
	if actual ~= expected then
		error("Expected "..expression.." to equal "..tostring(expected).."; was actually "..tostring(actual))
	end
end

-- Load XML file, search it for a specific node
local root = assert(xml.load("test.xml"))
local scene = assert(root:find("scene"))
assertEquals('scene:tag()', scene:tag(), 'scene')
assertEquals('scene[0]', scene[0], 'scene')
assertEquals('scene[xml.TAG]', scene[xml.TAG], 'scene')
assertEquals('scene.id', scene.id, '0')

-- Check that tostring(node) emits valid XML, which can be parsed back in
local child = assert(xml.eval(tostring(scene[1])))
assertEquals('child:tag()', child:tag(), 'object')
assertEquals('child.id', child.id, '0')
assertEquals('child.input', child.input, 'window')
assertEquals('child.name', child.name, 'observer')
assertEquals('child.script', child.script, 'camera.lua')

-- Search by attribute/value
local resource = assert(root:find("resource", "id", "1"))
assertEquals('resource.name', resource.name, "virtualab")

-- Save XML file
scene.id = '1'
scene:save("scene.xml")
local f = assert(io.open("scene.xml", "r"))
local content = f:read("*all")
f:close()
assert('content of scene.xml', content, [[Hello]])

-- Build an XML object
local x = assert(xml.new("root"))
x:append("child")[1] = 123

assertEquals('x:str()', x:str(), [[
<root>
	<child>123</child>
</root>
]])

-- Load XML from a string
local bar = assert(xml.eval('<bar><foo>abc</foo></bar>'))
assertEquals('bar:tag()', bar:tag(), 'bar')

-- NOTE: xml.registerCode is not tested
