--
------------------------------------------------------------------------  
-- 						      Wrapper Class                           --
------------------------------------------------------------------------
--
-- Version: 1.0
--
-- last change: 22.12.2011
-- 
------------------------------------------------------------------------
-- Restrictions
------------------------------------------------------------------------
--
-- This class is free to use
--
------------------------------------------------------------------------
-- Known issues
------------------------------------------------------------------------
--
-- 1. does not work with crawlspace library included (probobly by reason of some overwritten functions)
--
-- 2. single words, which are wider then the preset-width will not split if no height is set, 
--	  width will be adjusted instead.
--
-- 3. In fact that a new text must be wrapped anyway, you have to generate a new object for text changes.
--
------------------------------------------------------------------------
-- Instructions
------------------------------------------------------------------------
--
-- what you get with the newParagraph-function is a normal display-group with text objects inside,
-- so certainly they can handeld as those.
--
-- Study the samle-code and the parameter- and function-List for usage.
--
-- Feel free to contact me, if you have any questions or suggestions.
--
-- If you find a bug, please report it. Thanks.
--
------------------------------------------------------------------------
-- Parameters
------------------------------------------------------------------------
--
-- text 
-- string. The text to display.
--	
-- width (optional, display-width*0.9 by default)   
-- number. the desired width
--
-- height (optional, will be appointed automatically if not set)
-- number. IMPORTANT: If a height is set, The fontsize will be ignored and appointed automatically.
--
-- font (optional, systemFont by default)   
-- string. The desired font.
-- 	
-- fontSize (optional, thirtieth of display-height by default) 
-- number. The desired fontSize. Ignored if height is set.
--  
-- lineSpace (optional, depends on fontSize by default)
-- number. You can increase/decrease with +/- values
--
-- alignment (optional, "center" by default)
-- string. left, center or right
--
-- fontColor must be set with myParagraph:setTextColor({r,g,b,[alpha]}) resp. myParagraph:setTextColor({gray,[alpha]})
--

local _W = display.contentWidth
local _H = display.contentHeight

local sFx = display.contentScaleX
local sFy = display.contentScaleY

local Wrapper = {}

function Wrapper:newParagraph(params)
	
	if params.height and params.fontSize then print(); print("Wrapper Class:: fontSize will be appointed automatically, related to the given height") end
	
	local t = params.text
	local h = params.height
	
	local w = 			params.width 		or 	_W * 0.9
	local font = 		params.font 		or 	native.systemFont
	local fontSize = 	params.fontSize		or 	_H / 30	
	local lineSpace	= 	params.lineSpace 	or 	0
	local alignment	=	params.alignment	or "center"
	
	local group = display.newGroup() 
	local img
	local cHeight
	local temp
	local tempWidth = 0


	img = display.newRetinaText("H",0,0,font, fontSize)
	cHeight = img.height * sFy
	img:removeSelf()


	local function wrap()
		local tempS1 = "" 	
		local tempS2
		local index = 1
		local count = 1
		local row = 0
		local tmpGroup = display.newGroup()
		
		for i=1, #t do
			if string.sub(t,i,i) == " " or string.sub(t,i,i) == "-" or i == #t then
				tempS2 = tempS1 .. string.sub(t, index,i)
				if i == #t then
					img = display.newRetinaText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						img = display.newRetinaText(tempS1,0,0,font, fontSize)
						img:setReferencePoint(display.TopLeftReferencePoint)
						img.y = row*cHeight+row*lineSpace
						tmpGroup:insert(img)
						img = display.newRetinaText(string.sub(t, index,i),0,0,font, fontSize)
						img:setReferencePoint(display.TopLeftReferencePoint)
						img.y = (row+1)*cHeight+(row+1)*lineSpace
						tmpGroup:insert(img)
						break
					else
						img = display.newRetinaText(tempS2,0,0,font, fontSize)
						img:setReferencePoint(display.TopLeftReferencePoint)
						img.y = row*cHeight+row*lineSpace
						tmpGroup:insert(img)
						break
					end
				end
				if count ~= 1 then
					img = display.newRetinaText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						img = display.newRetinaText(tempS1,0,0,font, fontSize)
						img:setReferencePoint(display.TopLeftReferencePoint)
						img.y = row*cHeight+row*lineSpace
						tmpGroup:insert(img)
						tempS1 = string.sub(t, index,i)
						row = row + 1
						else
							tempS1 = tempS2
					end
				else
					tempS1 = tempS2
				end
				index = i+1
				count = count+1
			end
		end
		return tmpGroup
	end
	
	-- font-sizing if height is set
	if params.height ~= nil then
		fontSize = 6
		while 1 do
			img = display.newRetinaText("H",0,0,font, fontSize)
			cHeight = img.height * sFy
			img:removeSelf()
			group = wrap()
			for i=1, group.numChildren do
				if group[i].width > tempWidth then
					tempWidth = group[i].width
				end
			end
			if tempWidth > w or group.height > h then
				break
			end
			group:removeSelf()
			fontSize = fontSize+1
		end
		group:removeSelf()
		fontSize = fontSize-1
		print("Wrapper Class:: calculated fontsize: " .. fontSize)
		img = display.newRetinaText("H",0,0,font, fontSize)
		cHeight = img.height * sFy
		img:removeSelf()
		group = wrap()	
	
	-- else normal wrapping
	else
		group = wrap()
	end

	-- public functions
	function group:setTextColor(a)
		for i=1, self.numChildren do
			self[i]:setTextColor(unpack(a))
		end	
	end
	
	function group:alignText(a)
		local groupWidth = self.width
		
		if a == "center" then
			for i=1, self.numChildren do
				self[i]:setReferencePoint(display.TopCenterReferencePoint)
				self[i].x = 0
			end
		
		elseif a == "left" then
			for i=1, self.numChildren do
				self[i]:setReferencePoint(display.TopLeftReferencePoint)
				self[i].x = groupWidth / 2
				
			end
			
		elseif a == "right" then
			for i=1, self.numChildren do
				self[i]:setReferencePoint(display.TopRightReferencePoint)
				self[i].x = groupWidth
			end
		end
	
	group:alignText(alignment)
	return group
end

return Wrapper



