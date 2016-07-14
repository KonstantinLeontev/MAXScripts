plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	parameters main rollout:params
	(
		windowWidth type:#float 
frameWidth = 50
widthW = 1000
lengthW = 1500
firstBox = box length:lengthW width:widthW height:frameWidth
secondBox = box length:(lengthW - frameWidth*2) width:(widthW - frameWidth*2) height:(frameWidth*2)
secondBox.pos.z = -frameWidth/2
frame = firstBox - secondBox
glazing = 10
secondBox.height = glazing
secondBox.pos.z = frameWidth/2 - glazing/2