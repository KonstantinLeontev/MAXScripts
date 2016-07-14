--Script makes simple room.
-- First variables definitions
global wWidth = 4000
global wLength = 5000
global wHeight = 3000
global roomArray = #() -- Create empty array for new objects
-- UI setup
rollout autoRoomRollout "AutoRoom" width:160 height:390
(
	groupBox 'roomGroupBox' "Room" pos:[5,4] width:150 height:56 align:#left
	radioButtons 'chooseShapeRdoBtns' "" pos:[8,24] width:130 height:32 labels:#("Use rectangular shape", "Use custom shape") align:#left
	groupBox 'rectangularRoomGroupBox' "Rectangular room" pos:[5,66] width:150 height:80 align:#left
	spinner 'lengthSpinner' "" pos:[80,91] width:70 height:16 range:[0,1000000,wLength] align:#left
	spinner 'widthSpinner' "" pos:[80,117] width:70 height:16 range:[0,1000000,wWidth] align:#left
	label 'lengthLabel' "Length:" pos:[16,91] width:56 height:16 align:#left
	label 'widthLabel' "Width:" pos:[16,117] width:56 height:16 align:#left
	button 'createRoomBtn' "Create Room" pos:[5,328] width:150 height:56 align:#left
	checkbox 'floorCheckBox' "Floor" pos:[16,247] width:48 height:16 checked:true align:#left
	checkbox 'plinthCheckBox' "Plinth" pos:[81,247] width:56 height:16 checked:true align:#left
	checkbox 'ceilingCheckBox' "Ceiling" pos:[16,271] width:48 height:16 checked:true align:#left
	checkbox 'corniceCheckBox' "Cornice" pos:[81,271] width:56 height:16 checked:true align:#left
	spinner 'roomHeightSpinner' "" pos:[80,217] width:70 height:16 range:[0,1000000,wHeight] align:#left
	label 'roomHeightLabel' "Room Height" pos:[11,217] width:69 height:16 enabled:true align:#left
	fn shape_filt obj = superClassOf obj == shape
	pickButton 'pickCustomShapeBtn' "Pick custom shape" pos:[5,154] width:150 height:33 align:#left filter:shape_filt tooltip:"Pick your custom wall contour" enabled:false
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
	on chooseShapeRdoBtns changed state do
(
	case chooseShapeRdoBtns.state of
	(
		1: (
			lengthSpinner.enabled = true
			widthSpinner.enabled = true
			pickCustomShapeBtn.enabled = false
			createRoomBtn.enabled = true
			)
		2: (
			lengthSpinner.enabled = false
			widthSpinner.enabled = false
			pickCustomShapeBtn.enabled = true
			createRoomBtn.enabled = false
			)
	)
)
	on pickCustomShapeBtn picked obj do
(
	if obj != undefined do
	(
		global wall1 = copy obj
		obj.wirecolor = blue
		pickCustomShapeBtn.text = obj.name
		createRoomBtn.enabled = true
	)
)
	on createNewLayerCheckBox changed state do
(
	)
	
	-- Begin functions definition
-- Walls function definition
fn createWall wWidth wLength wHeight =
(
if chooseShapeRdoBtns.state == 1 do
(
	global wall1 = rectangle ()
	wall1.width = wWidth
	wall1.length = wLength
)
wall1.name = uniquename "Wall"
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
floor1 = copy wall1
floor1.name = uniquename "Floor"
floor1.wirecolor = brown
floor1.backfacecull = on
floor1.modifiers[#Extrude].capEnd = on
floor1.modifiers[#Extrude].amount = -(wHeight/20)
append roomArray floor1
)

-- Ceiling function definition
fn createCeiling wHeight =
(
ceiling1 = copy wall1
ceiling1.name = uniquename "Ceiling"
ceiling1.wirecolor = blue
ceiling1.backfacecull = on
ceiling1.modifiers[#Extrude].capEnd = on
ceiling1.modifiers[#Extrude].amount = -(wHeight/20)
addModifier ceiling1 (Mirror mirror_axis:2 offset:wHeight)
append roomArray ceiling1
)

-- Plinth function definition
fn createPlinth =
(
plinth = copy wall1
plinth.name = uniquename "Plinth"
deleteModifier plinth 1
plinth.wirecolor = (color (random 0.0 255) (random 0.0 255) (random 0.0 255))
plinthSweep = sweep ()
addModifier plinth plinthSweep
classof plinth -- refresh the object's stack and make next properties available
plinthSweep.CustomShape = 0
plinthSweep.CurrentBuiltInShape = 1
plinthSweep[4].angle_length = (wHeight/30)
plinthSweep[4].angle_width = (wHeight/300)
plinthSweep[4].angle_thickness = (wHeight/200)
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
cornice = copy wall1
cornice.name = uniquename "Cornice"
cornice.wirecolor = orange
deleteModifier cornice 1
corniceSweep = sweep ()
addModifier cornice corniceSweep
classof cornice -- refresh the object's stack and make next properties available
corniceSweep.CustomShape = 0
corniceSweep.CurrentBuiltInShape = 1
corniceSweep[4].angle_length = (wHeight/30)
corniceSweep[4].angle_width = (wHeight/300)
corniceSweep[4].angle_thickness = (wHeight/200)
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
roomMatArray = #()
-- Wall material
wallMap = checker ()
wallMap.coordinates.U_Tiling = (wHeight/10)
wallMap.coordinates.V_Tiling = (wHeight/15)
wallMat = standard diffuseMap:wallMap
wallMat.name = "SampleWallCovering"
append roomMatArray wallMat
-- Floor material
floorMap =  tiles brick_color:(color 146 72 31) horizontal_count:(wHeight/750) vertical_count:(wHeight/150)
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
-- Main material
roomMat = multimaterial ()
for i=roomArray.count to 1 by -1 where not isValidNode roomArray[i]  do deleteItem roomArray i -- Delete already deleted items from array
a = roomArray.count
roomMat.numsubs = a -- Quantity of sub-material slots
roomMat.name = "Room_Materials"
roomMat.names = #("Walls") -- Names of sub-material slots
-- Check for created parts
if floorCheckBox.state == true do
(
	appendIfUnique roomMat.names "Flooring"
	appendIfUnique roomMatArray floorMat
)
if ceilingCheckBox.state == true do
(
	appendIfUnique roomMat.names "Ceiling"
	appendIfUnique roomMatArray ceilingMat
)
if plinthCheckBox.state == true do
(
	appendIfUnique roomMat.names "Plinth"
	appendIfUnique roomMatArray plinthMat
)
if corniceCheckBox.state == true do
(
	appendIfUnique roomMat.names "Cornice"
	appendIfUnique roomMatArray corniceMat
)
roomArray.material = roomMat -- Assign material for array
for i=1 to a do -- Add material modifier for each object in this room
(
	addModifier roomArray[i] (materialModifier materialID:i)
)
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
-- End of the functions difinitions
	on createRoomBtn pressed  do
(
	createWall wWidth wLength wHeight
	if floorCheckBox.state == true do createFloor()
	if ceilingCheckBox.state == true do createCeiling wHeight
	if plinthCheckBox.state == true do createPlinth()
	if corniceCheckBox.state == true do createCornice()
	createSampleMaterial()
	if createNewLayerCheckBox.state == true do createNewLayer()
				-- Flip wall's normals! Important to do it after copy to floor and others!
addModifier wall1 (Normalmodifier flip:on)
	free roomArray
	pickCustomShapeBtn.text = "Pick custom shape"
	createRoomBtn.enabled = false
	)
)
createdialog autoRoomRollout