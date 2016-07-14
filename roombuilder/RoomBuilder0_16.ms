--Script makes simple room.
utility roomBuilderRollout "RoomBuilder 1.00" --width:162 height:643
(
	-- First variables definitions
	local wWidth = 4000
	local wLength = 5000
	local wHeight = 3000
	local wLevel = 0
	local wallArr = #() -- Create empty array for new walls
	local roomArr = #() -- Create empty array for all new objects
	-- UI setup
	groupBox 'roomGroupBox' "Room" pos:[6,4] width:150 height:56 align:#left
	radioButtons 'chooseShapeRdoBtns' "" pos:[8,24] width:130 height:32 labels:#("Use rectangular shape", "Use custom shape") align:#left
	groupBox 'rectangularRoomGroupBox' "Rectangular room" pos:[6,66] width:150 height:80 align:#left
	spinner 'lengthSpinner' "" pos:[80,91] width:70 height:16 range:[0,1000000,wLength] align:#left
	spinner 'widthSpinner' "" pos:[80,117] width:70 height:16 range:[0,1000000,wWidth] align:#left
	label 'lengthLabel' "Length:" pos:[36,92] width:39 height:16 align:#left
	label 'widthLabel' "Width:" pos:[40,118] width:36 height:16 align:#left
	button 'createRoomBtn' "Create Room" pos:[6,602] width:150 height:31 align:#left
	checkbox 'floorCheckBox' "Floor" pos:[14,464] width:48 height:16 checked:true align:#left
	checkbox 'plinthCheckBox' "Plinth" pos:[85,464] width:56 height:16 checked:true align:#left
	checkbox 'ceilingCheckBox' "Ceiling" pos:[14,488] width:48 height:16 checked:true align:#left
	checkbox 'corniceCheckBox' "Cornice" pos:[85,488] width:56 height:16 checked:true align:#left
	spinner 'roomHeightSpinner' "" pos:[80,409] width:70 height:16 range:[0,1000000,wHeight] align:#left
	label 'roomHeightLabel' "Height:" pos:[37,410] width:39 height:16 enabled:true align:#left
	GroupBox 'detailsGroupBox' "Room Details" pos:[6,383] width:150 height:212 align:#left
	checkbox 'createNewLayerCheckBox' "Create new layer" pos:[14,521] width:128 height:16 checked:true align:#left
	MultiListBox 'pickedShapesList' "" pos:[14,170] width:133 height:9 align:#left
	checkButton 'pickBtn' "Pick" pos:[15,297] width:64 height:27 enabled:false toolTip:"" align:#left
	fn shape_filt obj = superClassOf obj == Shape
	button 'deleteShapeBtn' "Delete" pos:[83,297] width:64 height:27 align:#left enabled:false
	checkbox 'normalsCheckBox' "Flip normals for walls" pos:[14,545] width:128 height:16 checked:true align:#left
	GroupBox 'customShapeGroupBox' "Custom shape" pos:[7,154] width:150 height:221 align:#left
	checkbox 'flattenShapesCheckBox' "Flatten shapes" pos:[17,331] width:128 height:16 checked:true enabled:false align:#left toolTip:"This option needs to fix shape's vertices with different Z values"
	checkbox 'removeGapsCheckBox' "Remove gaps" pos:[17,352] width:128 height:16 checked:true enabled:false align:#left toolTip:"Uncheck if your walls have openings for doors and windows"
	label 'floorLevelLabel' "Floor Level:" pos:[16,437] width:61 height:16 enabled:true align:#left
	spinner 'roomLevelSpinner' "" pos:[80,436] width:70 height:16 range:[-1000000,1000000,wLevel] align:#left toolTip:"Height of new room above zero"
	checkbox 'createMaterialsCheckBox' "Create sample materials" pos:[14,569] width:137 height:16 checked:true align:#left toolTip:"Create and applay Multi/Sub-object material for new room"
	-- Rollout events
	on roomBuilderRollout open  do free roomArr
	on roomBuilderRollout close  do free roomArr
	on roomBuilderRollout moved pos do ()
	on lengthSpinner changed val do wLength = val
	on widthSpinner changed val do wWidth = val
	on floorCheckBox changed state do ()
	on plinthCheckBox changed state do ()
	on ceilingCheckBox changed state do ()
	on corniceCheckBox changed state do ()
	on roomHeightSpinner changed val do wHeight = val
	on chooseShapeRdoBtns changed state do
(
	case chooseShapeRdoBtns.state of
	(
		1: (
			lengthSpinner.enabled = true
			widthSpinner.enabled = true
			pickBtn.enabled = false
			deleteShapeBtn.enabled = false
			pickedShapesList.enabled = false
			flattenShapesCheckBox.enabled = false
			removeGapsCheckBox.enabled = false
			)
		2: (
			lengthSpinner.enabled = false
			widthSpinner.enabled = false
			pickBtn.enabled = true
			deleteShapeBtn.enabled = true
			pickedShapesList.enabled = true
			flattenShapesCheckBox.enabled = true
			removeGapsCheckBox.enabled = true
			)
	)
)
	on createNewLayerCheckBox changed state do
(
	)
	on pickBtn changed theState do -- Select custom shapes
(
	case theState of
		(
			true: (
						pickBtn.text = "Stop!"
						while isvalidNode (local temp = pickObject filter:shape_filt) do
						(
							if appendIfUnique wallArr temp == true then
								(
									pickedShapesList.items = append pickedShapesList.items (temp.name as string)
									temp.wirecolor = red
								)
								else messageBox "Already added! Choose another shape or press 'Stop!' button to finish."
						)
					)
			false: (pickBtn.text = "Pick")
		)
	)
	on deleteShapeBtn pressed  do
(
	wallArr = for i in (-pickedShapesList.selection) collect wallArr[i] -- Delete selected items from pickedObj array
		pickedShapesList.items = for i in (-pickedShapesList.selection) collect pickedShapesList.items[i] -- Delete selected items from list
	)
	on normalsCheckBox changed state do ()
	on flattenShapesCheckBox changed state do ()
	on removeGapsCheckBox changed state do ()
	on roomLevelSpinner changed val do wLevel = val
	on createMaterialsCheckBox changed state do ()
-- Begin functions definition
-- Walls function definition
fn createWall wWidth wLength wHeight wLevel =
(
	if chooseShapeRdoBtns.state == 1 then
	(
		append wallArr (rectangle ())
		wallArr.width = wWidth
		wallArr.length = wLength
	)
	for i=1 to wallArr.count do wallArr[i].name = uniquename "Wall"
	wallArr.wirecolor = yellow; wallArr.backfacecull = on; wallArr.pos.z = wLevel
	append roomArr wallArr
)
fn wallsExtrude wHeight =
(
	wallHeight = extrude ()
	addModifier wallArr wallHeight
	wallHeight.amount = wHeight; wallHeight.capStart = off; wallHeight.capEnd = off; wallHeight.mapcoords = on
)
fn flattenShapes wLevel =
(
	for i=1 to wallArr.count do
	(
		convertToSplineShape wallArr[i] -- Convert each shape to a SplineShape object
	)	
	for i=1 to wallArr.count do
		(
			for s=1 to (numSplines wallArr[i]) do -- Do for each spline in a shape
			(
				for k=1 to (numKnots wallArr[i] s) do
				(
					knt = getKnotPoint wallArr[i] s k
					in_vec = getInVec wallArr[i] s k 
					out_vec = getOutVec wallArr[i] s k
					knt.z = in_vec.z = out_vec.z = wLevel
					setInVec wallArr[i] s k in_vec
					setOutVec wallArr[i] s k out_vec
					setKnotPoint wallArr[i] s k knt
				)
			)
			updateShape wallArr[i]
		)
)
fn removeGaps =
(
	for i=1 to wallArr.count do
		(
			-- Get point3 array of out knots
			spl = wallArr[i]
			if numSplines spl == 1 and isClosed spl 1 != true then close spl 1 else
				(
					outKnotsArr = #()
					for i=1 to (numSplines spl) do
					(
						if isClosed spl i != true do
						(
							firstPoint = getKnotPoint spl i 1
							lastPoint = getKnotPoint spl i (numKnots spl i)
							append  outKnotsArr firstPoint
							append  outKnotsArr lastPoint
						)
					)
					fn distanceSort v1 v2 checkKnot: = -- Function to sort points Array
					(
						local d1 = distance checkKnot v1
						local d2 = distance checkKnot v2
						case of
						(
							(d1<d2) : -1
							(d1>d2) : 1
							default : 0
						)
					)
					-- Sort array
					sortKnotsArr = deepCopy outKnotsArr
					for i=1 to (sortKnotsArr.count-1) do qsort sortKnotsArr distanceSort start:(i+1) checkKnot:sortKnotsArr[i]
					-- Create new segments
					for i=1 to sortKnotsArr.count/2 by 1 do
					(
						addNewSpline spl
						addKnot spl (numSplines spl) #corner #line sortKnotsArr[i*2-1]
						addKnot spl (numSplines spl) #corner #line sortKnotsArr[i*2]
						updateShape spl
					)
						-- Weld all vertices
					max modify mode -- Turn on modify panel
					select spl
					subObjectLevel = 1 -- Set sub-object level to vertex
					max select all -- Select all vertices
					weldSpline spl 0.001
					updateShape spl
					subObjectLevel = 0
				)
		)
)
fn groupCheck = -- Prevent errors if shapes belonge any group
(
	for i in wallArr do
	(
		if isGroupMember i == true and isOpenGroupMember i == false then -- Check wether shape belongs any groups
		setGroupOpen (getNodeByName i.parent.name) true -- Find the group head and open it
	)
)	
fn createFloor =
(
	maxOps.CloneNodes wallArr cloneType:#copy newNodes:&floorArr -- Clone objects from wallArr
	for i=1 to floorArr.count do floorArr[i].name = uniquename "Floor" -- Rename objects in new array
	floorArr.wirecolor = brown; floorArr.backfacecull = on
	for i=1 to floorArr.count do -- Change Extrude modifier for each object in array
	(
		floorArr[i].modifiers[#Extrude].capEnd = on
		floorArr[i].modifiers[#Extrude].amount = -(wHeight/20)
	)
	append roomArr floorArr
)
-- Ceiling function definition
fn createCeiling wHeight =
(
	maxOps.CloneNodes wallArr cloneType:#copy newNodes:&ceilingArr -- Clone objects from wallArr
	for i=1 to ceilingArr.count do ceilingArr[i].name = uniquename "Ceiling" -- Rename objects in new array
	ceilingArr.wirecolor = blue; ceilingArr.backfacecull = on
	for i=1 to ceilingArr.count do  -- Change Extrude modifier for each object in array
	(
		ceilingArr[i].modifiers[#Extrude].capEnd = on
		ceilingArr[i].modifiers[#Extrude].amount = -(wHeight/20)
	)
	addModifier ceilingArr (Mirror mirror_axis:2 offset:wHeight)
	append roomArr ceilingArr
)
-- Plinth function definition
fn createPlinth =
(
	maxOps.CloneNodes wallArr cloneType:#copy newNodes:&plinthArr -- Clone objects from wallArr
	for i=1 to plinthArr.count do plinthArr[i].name = uniquename "Plinth" -- Rename objects in new array
	deleteModifier plinthArr 1
	plinthArr.wirecolor = (color (random 0.0 255) (random 0.0 255) (random 0.0 255))
	plinthSweep = sweep ()
	addModifier plinthArr plinthSweep
	for i=1 to plinthArr.count do classof plinthArr[i] -- refresh the object's stack and make next properties available
		plinthSweep.CustomShape = 0; plinthSweep.CurrentBuiltInShape = 1
		plinthSweep[4].angle_length = (wHeight/30)
		plinthSweep[4].angle_width = (wHeight/300)
		plinthSweep[4].angle_thickness = (wHeight/200)
		plinthSweep.MirrorXZPlane = on; plinthSweep.MirrorXYPlane = on
		plinthSweep.PivotAlignment = 8
		plinthSweep.SmoothSection = off; plinthSweep.SmoothPath = off
	append roomArr plinthArr
)

-- Ceiling Cornice
fn createCornice =
(
	maxOps.CloneNodes wallArr cloneType:#copy newNodes:&corniceArr -- Clone objects from wallArr
	for i=1 to corniceArr.count do corniceArr[i].name = uniquename "Cornice" -- Rename objects in new array
	corniceArr.wirecolor = orange
	deleteModifier corniceArr 1
	corniceSweep = sweep ()
	addModifier corniceArr corniceSweep
	for i=1 to corniceArr.count do classof corniceArr[i] -- refresh the object's stack and make next properties available
		corniceSweep.CustomShape = 0; corniceSweep.CurrentBuiltInShape = 1
		corniceSweep[4].angle_length = (wHeight/30)
		corniceSweep[4].angle_width = (wHeight/300)
		corniceSweep[4].angle_thickness = (wHeight/200)
		corniceSweep.MirrorXZPlane = on; corniceSweep.MirrorXYPlane = on
		corniceSweep.PivotAlignment = 8
		corniceSweep.SmoothSection = off; corniceSweep.SmoothPath = off
	addModifier corniceArr (Mirror mirror_axis:2 offset:wHeight)
	append roomArr corniceArr
)

-- Assign sample materials
fn createSampleMaterial wHeight =
(
	roomMatArr = #() -- Base array for materials
	-- Wall material
	wallMap = checker ()
	wallMap.coordinates.U_Tiling = (wHeight/10); wallMap.coordinates.V_Tiling = (wHeight/15)
	wallMat = standard diffuseMap:wallMap
	wallMat.name = "SampleWallCovering"
	append roomMatArr wallMat
	-- Floor material
	floorMap =  tiles brick_color:(color 146 72 31) horizontal_count:(wHeight/750) vertical_count:(wHeight/150)
	floorMap.color_variance = 0.5; floorMap.horizontal_gap = 0.05; floorMap.vertical_gap = 0.05; floorMap.tile_type = 2
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
	roomMat.numsubs = roomArr.count -- Quantity of sub-material slots
	roomMat.name = "Room_Materials"
	roomMat.names = #("Walls") -- Names of sub-material slots
-- Check for created parts
if floorCheckBox.state == true do (
	appendIfUnique roomMat.names "Flooring"
	appendIfUnique roomMatArr floorMat
	)
if ceilingCheckBox.state == true do (
	appendIfUnique roomMat.names "Ceiling"
	appendIfUnique roomMatArr ceilingMat
	)
if plinthCheckBox.state == true do (
	appendIfUnique roomMat.names "Plinth"
	appendIfUnique roomMatArr plinthMat
	)
if corniceCheckBox.state == true do (
	appendIfUnique roomMat.names "Cornice"
	appendIfUnique roomMatArr corniceMat
	)
for i=1 to roomArr.count do ( -- Add material modifier for each object in this room
	roomArr[i].material = roomMat -- Assign material for array
	for a=1 to roomArr[i].count do addModifier roomArr[i][a] (materialModifier materialID:i)
	)
for i=1 to roomArr.count do ( -- Assign materials for sub-material slots
	roomMat[i] = roomMatArr[i] -- Assign material
	showTextureMap roomMat[i] on -- Show texture in viewport
	)
)
-- Create new layer function
fn createNewLayer =
(
	if (roomLayer = layermanager.getLayerFromName "AutoRoom") == undefined then
		roomLayer = layermanager.newLayerFromName "AutoRoom"
	else roomLayer = layermanager.getLayerFromName "AutoRoom"
	for i=1 to roomArr.count do (for a=1 to roomArr[i].count do roomLayer.addNode roomArr[i][a])
)

fn createRoom =
(
	if wallArr.count == 0 and chooseShapeRdoBtns.state == 2 then messageBox "Choose shape for wall!" else
	(
		start = timeStamp()
		createWall wWidth wLength wHeight wLevel
		groupCheck()
		if chooseShapeRdoBtns.state == 2 and flattenShapesCheckBox.state == true do flattenShapes wLevel
		if chooseShapeRdoBtns.state == 2 and removeGapsCheckBox.state == true do removeGaps()
		wallsExtrude wHeight
		if floorCheckBox.state == true do createFloor()
		if ceilingCheckBox.state == true do createCeiling wHeight
		if plinthCheckBox.state == true do createPlinth()
		if corniceCheckBox.state == true do createCornice()
		if createNewLayerCheckBox.state == true do createNewLayer()
		if normalsCheckBox.state == true do
		for i=1 to wallArr.count do addModifier wallArr[i] (Normalmodifier flip:on) -- Flip wall's normals! It's important to do that after copy to floor and others!
		if createMaterialsCheckBox.state == true do createSampleMaterial wHeight
		for i=1 to roomArr.count do free roomArr[i] -- Clean arrays
		free roomArr -- Clean base array
		if pickedShapesList.items.count > 0 do pickedShapesList.items = #() -- Clean MultiListBox
		end = timeStamp()
		format "Script took % seconds.\n" ((end-start)/1000.0)
	)
)
-- End of the functions difinitions
on createRoomBtn pressed do
(
	if pickBtn.state == true then (pickBtn.text = "Pick"; pickBtn.state = false) -- Switch button off
	createRoom ()
)
)-- end rollout
--createdialog roomBuilderRollout
