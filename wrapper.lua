--
------------------------------------------------------------------------  
-- 						      Wrapper Class                           --
------------------------------------------------------------------------
--
-- Version: 1.0
--
-- Version 1.1
-- 1) Fixed errors with content scaling.
-- 2) Added a new feature: you can now use \n for line break
-- 3) In fact of the content-scaling error, alignment can not longer changed with the align function. 
--    Its now fix after initialization.
--
-- last change: 28.01.2012
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
-- use "\n" for line break
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
		local tA = {}
		local gW = 0
		local lf_flag = true
		
		for i=1, #t do

			if string.byte(t,i) == 10 and i ~= #t then
				if lf_flag == false then
					if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
					tA[#tA+1] = display.newRetinaText(tempS1,0,0,font, fontSize)
					tempS1 = string.sub(t, index,i)
				else
					tA[#tA+1] = display.newRetinaText(" ",0,0,font, fontSize)
				end
			end
			
			if string.sub(t,i,i) == " " or string.sub(t,i,i) == "-" or i == #t then
				lf_flag = false
				tempS2 = tempS1 .. string.sub(t, index,i)
				
				if i == #t then
					img = display.newRetinaText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						tA[#tA+1] = display.newRetinaText(tempS1,0,0,font, fontSize)
						tA[#tA+1] = display.newRetinaText(string.sub(t, index,i),0,0,font, fontSize)
						break
					else
						tA[#tA+1] = display.newRetinaText(tempS2,0,0,font, fontSize)
						break
					end
				end
				
				if count ~= 1 then
					img = display.newRetinaText(tempS2,0,0,font, fontSize)
					temp = img.width * sFx
					img:removeSelf()
					if temp > w then
						if string.sub(tempS1, -1,-1) == " " then tempS1 = string.sub(tempS1, 1,-2) end
						tA[#tA+1] = display.newRetinaText(tempS1,0,0,font, fontSize)
						tempS1 = string.sub(t, index,i)
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
		
		-- text alignment
		for i=1, #tA do
			if gW < tA[i].width * sFx then
				gW = tA[i].width * sFx
			end
		end
		
		if alignment == "center" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopCenterReferencePoint)
				tA[i].x = gW/2
				tA[i].y = i*cHeight+i*lineSpace
			end
		
		elseif alignment == "left" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopLeftReferencePoint)
				tA[i].x = 0
				tA[i].y = i*cHeight+i*lineSpace
			end
			
		elseif alignment == "right" then
			for i=1, #tA do
				tA[i]:setReferencePoint(display.TopRightReferencePoint)
				tA[i].x = gW
				tA[i].y = i*cHeight+i*lineSpace
			end
		end 
			
		-- group	
		for i=1, #tA do
			tmpGroup:insert(tA[i])
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
					tempWidth = group[i].width *sFx
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
	
	return group
end

return Wrapper



