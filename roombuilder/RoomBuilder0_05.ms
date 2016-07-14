--Script makes simple room.
-- First variables definitions
global wWidth = 4000
global wLength = 5000
global wHeight = 3000
global roomArray = #() -- Create empty array for new objects

-- Begin functions definition
-- Walls function definition
fn createWall wWidth wLength wHeight chooseShape =
(
if chooseShape == rectangular
	then
(
	global wall1 = rectangle ()
	wall1.width = wWidth
	wall1.length = wLength
)
else
(
	-- Some code for picked custom shape
)
wall1.name = "Wall"
wall1.wirecolor = yellow
wallHeight = extrude ()
addModifier wall1 wallHeight
wallHeight.amount = wHeight
wallHeight.capStart = off
wallHeight.capEnd = off
wallHeight.mapcoords = on
wall1.backfacecull = on
append roomArray wall1
)
	
-- Floor function definition
fn createFloor =
(
global floor1 = copy wall1
floor1.name = "Floor"
floor1.wirecolor = brown
floor1.backfacecull = on
floor1.modifiers[#Extrude].capEnd = on
floor1.modifiers[#Extrude].amount = -(wHeight/15)
append roomArray floor1
)

-- Ceiling function definition
fn createCeiling wHeight =
(
global ceiling1 = copy wall1
ceiling1.name = "Ceiling"
ceiling1.wirecolor = blue
ceiling1.backfacecull = on
ceiling1.modifiers[#Extrude].capEnd = on
ceiling1.modifiers[#Extrude].amount = -(wHeight/15)
addModifier ceiling1 (Mirror mirror_axis:2 offset:wHeight)
append roomArray ceiling1
)

-- Plinth function definition
fn createPlinth =
(
global plinth = copy wall1
plinth.name = "Plinth"
deleteModifier plinth 1
plinth.wirecolor = (color (random 0.0 255) (random 0.0 255) (random 0.0 255))
plinthSweep = sweep ()
addModifier plinth plinthSweep
classof plinth -- refresh the object's stack and make next properties available
plinthSweep.CustomShape = 0
plinthSweep.CurrentBuiltInShape = 1
plinthSweep[4].angle_length = 100
plinthSweep[4].angle_width = 10
plinthSweep[4].angle_thickness = 15
plinthSweep.MirrorXZPlane = on
plinthSweep.MirrorXYPlane = on
plinthSweep.PivotAlignment = 8
plinthSweep.SmoothSection = off
plinthSweep.SmoothPath = off
append roomArray plinth
)

-- Ceiling Cornice
fn createCornice =
(
global cornice = copy wall1
cornice.name = "Cornice"
cornice.wirecolor = orange
deleteModifier cornice 1
corniceSweep = sweep ()
addModifier cornice corniceSweep
classof cornice -- refresh the object's stack and make next properties available
corniceSweep.CustomShape = 0
corniceSweep.CurrentBuiltInShape = 1
corniceSweep[4].angle_length = 100
corniceSweep[4].angle_width = 10
corniceSweep[4].angle_thickness = 15
corniceSweep.MirrorXZPlane = on
corniceSweep.MirrorXYPlane = on
corniceSweep.PivotAlignment = 8
corniceSweep.SmoothSection = off
corniceSweep.SmoothPath = off
addModifier cornice (Mirror mirror_axis:2 offset:wHeight)
append roomArray cornice
)

-- Assign sample materials
fn createSampleMaterial =
(
-- Main material
roomMat = multimaterial ()
roomMat.numsubs = 5
roomMat.name = "Room_Materials"
roomMat.names = #("Walls", "Flooring", "Ceiling", "Plinth", "Cornice") -- Names of sub-material slots
roomArray = #(wall1, floor1, ceiling1, plinth, cornice) -- All created objects in this room are packing into the array
-- select roomArray !!! May be no need
roomArray.material = roomMat -- Assign material for array
a = roomArray.count
for i=1 to a do -- Add material modifier for each object in this room
(
	addModifier roomArray[i] (materialModifier materialID:i)
)
-- Wall material
wallMap = checker ()
wallMap.coordinates.U_Tiling = 300
wallMap.coordinates.V_Tiling = 20
wallMat = standard diffuseMap:wallMap
wallMat.name = "SampleWallCovering"
-- Floor material
floorMap =  tiles brick_color:(color 146 72 31) horizontal_count:4 vertical_count:20
floorMap.color_variance = 0.5
floorMap.horizontal_gap = 0.05
floorMap.vertical_gap = 0.05
floorMap.tile_type = 2
floorMat = standard diffuseMap:floorMap
floorMat.name = "SampleFloorCovering"
-- Plinth material
plinthMat = standard diffuse:(color 69 46 27)
plinthMat.name = "SamplePlinthMat"
-- Cornice material
corniceMat = standard diffuse:(color 253 253 253)
corniceMat.name = "SampleCorniceMat"
-- Ceiling material
ceilingMat = standard diffuse:(color 253 253 253)
ceilingMat.name = "SampleCeilingMat"
-- Materials array
roomMatArray = #(wallMat, floorMat, ceilingMat, plinthMat, corniceMat)
for i=1 to a do -- Assign materials for sub-material slots
(
	roomMat[i] = roomMatArray[i] -- Assign material
	showTextureMap roomMat[i] on -- Show texture in viewport
)
)

-- Create new layer function
fn createNewLayer =
(
	if (roomLayer = layermanager.getLayerFromName "AutoRoom") == undefined then
		roomLayer = layermanager.newLayerFromName "AutoRoom"
	else roomLayer = layermanager.getLayerFromName "AutoRoom"
	a = roomArray.count
	for i=1 to a do
	(
		roomLayer.addNode roomArray[i]
	)
)


-- UI setup
rollout autoRoomRollout "AutoRoom" width:160 height:390
(
	groupBox 'rectangularRoomGroupBox' "Rectangular room" pos:[5,66] width:150 height:80 align:#left
	spinner 'lengthSpinner' "" pos:[80,91] width:70 height:16 range:[0,100000,wLength] align:#left
	spinner 'widthSpinner' "" pos:[80,117] width:70 height:16 range:[0,100000,wWidth] align:#left
	label 'lengthLabel' "Length:" pos:[16,91] width:56 height:16 align:#left
	label 'widthLabel' "Width:" pos:[16,117] width:56 height:16 align:#left
	button 'createRoomButton' "Create Room" pos:[5,328] width:150 height:56 align:#left
	checkbox 'floorCheckBox' "Floor" pos:[16,247] width:48 height:16 checked:true align:#left
	checkbox 'plinthCheckBox' "Plinth" pos:[81,247] width:56 height:16 checked:true align:#left
	checkbox 'ceilingCheckBox' "Ceiling" pos:[16,271] width:48 height:16 checked:true align:#left
	checkbox 'corniceCheckBox' "Cornice" pos:[81,271] width:56 height:16 checked:true align:#left
	spinner 'roomHeightSpinner' "" pos:[80,217] width:70 height:16 range:[0,100000,wHeight] align:#left
	label 'roomHeightLabel' "Room Height" pos:[11,217] width:69 height:16 enabled:true align:#left
	radioButtons 'chooseShapeRadioButtons' "" pos:[8,24] width:130 height:32 labels:#("Use rectangular shape", "Use custom shape") align:#left
	groupBox 'roomGroupBox' "Room" pos:[5,4] width:150 height:56 align:#left
	pickButton 'pickCustomShapeButton' "Pick custom shape" pos:[5,154] width:150 height:33 align:#left
	groupBox 'detailsGroupBox' "Details" pos:[5,192] width:150 height:128 align:#left
	checkbox 'createNewLayerCheckBox' "Create new layer" pos:[16,296] width:128 height:16 checked:true align:#left
	on autoRoomRollout open  do
(
	)
	on autoRoomRollout close  do
(
	)
	on autoRoomRollout moved pos do
(
	)
	on lengthSpinner changed val do
(
	wLength = val
	)
	on widthSpinner changed val do
(
	wWidth = val
	)
	on floorCheckBox changed state do
(
)
	on plinthCheckBox changed state do
(
	)
	on ceilingCheckBox changed state do
(
	)
	on corniceCheckBox changed state do
(
	)
	on roomHeightSpinner changed val do
(
	wHeight = val
	)
	on chooseShapeRadioButtons changed stat do
(
	case stat of
	(
		1: global chooseShape = rectangular
		2: chooseShape = custom
	)
)
	on pickCustomShapeButton picked obj do
(
	)
	on createNewLayerCheckBox changed state do
(
	)
	on createRoomButton pressed  do
(
	createWall wWidth wLength wHeight chooseShape
	if floorCheckBox.state == true do createFloor()
	if ceilingCheckBox.state == true do createCeiling wHeight
	if plinthCheckBox.state == true do createPlinth()
	if corniceCheckBox.state == true do createCornice()
	createSampleMaterial()
	if createNewLayerCheckBox.state == true do createNewLayer()
				-- Flip wall's normals! Important to do it after copy to floor and others!
addModifier wall1 (Normalmodifier flip:on)
	)
)
createdialog autoRoomRollout