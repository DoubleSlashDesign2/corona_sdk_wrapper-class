-- Wrapper-Class sample. 
--
-- Try different text, heights, widths, fontSizes etc.
--

local Wrapper = require("wrapper")

local _W = display.contentWidth
local _H = display.contentHeight

myParagraph = Wrapper:newParagraph({
	text = "Corona's framework dramatically increase productivity. Tasks like animating objects in OpenGL or creating user-interface widgets take only one line of code, and changes are instantly viewable in the Corona Simulator.",
	--text = "Corona'sframeworkdramaticallyincreaseproductivity.TaskslikeanimatingobjectsinOpenGLorcreatinguserinterfacewidgetstakeonlyonelineofcode,andhangesareinstantlyviewableintheCoronaSimulator. ",
	width = 200,
	--height = 200, 			-- fontSize will be calculated automatically if set 
	--font = "helvetica", 	-- make sure the selected font is installed on your system
	fontSize = 14,
	lineSpace = 5,
	alignment  = "left"
})
myParagraph:setReferencePoint(display.TopCenterReferencePoint)
myParagraph.x = _W/2
myParagraph.y = 50
myParagraph:setTextColor({255,255})

--print(myParagraph.width)

rect = display.newRoundedRect(0,0,myParagraph.width+15, myParagraph.height+15, 15 )
rect:setReferencePoint(display.CenterReferencePoint)
rect.x = _W/2
rect.y = 50+myParagraph.height/2
rect:setFillColor(50,166)
rect:setStrokeColor(255,200)
rect.strokeWidth = 1

myParagraph:toFront()
