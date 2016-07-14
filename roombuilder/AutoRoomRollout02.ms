rollout autoRoomRollout "AutoRoom" width:162 height:643
(
	GroupBox 'rectangularRoomGroupBox' "Rectangular room" pos:[6,66] width:150 height:80 align:#left
	spinner 'lengthSpinner' "" pos:[80,91] width:70 height:16 range:???? align:#left
	spinner 'widthSpinner' "" pos:[80,117] width:70 height:16 range:???? align:#left
	label 'lengthLabel' "Length:" pos:[36,92] width:39 height:16 align:#left
	label 'widthLabel' "Width:" pos:[40,118] width:36 height:16 align:#left
	button 'createRoomButton' "Create Room" pos:[6,602] width:150 height:31 align:#left
	checkbox 'floorCheckBox' "Floor" pos:[14,464] width:48 height:16 checked:true align:#left
	checkbox 'plinthCheckBox' "Plinth" pos:[85,464] width:56 height:16 checked:true align:#left
	checkbox 'ceilingCheckBox' "Ceiling" pos:[14,488] width:48 height:16 checked:true align:#left
	checkbox 'corniceCheckBox' "Cornice" pos:[85,488] width:56 height:16 checked:true align:#left
	spinner 'roomHeightSpinner' "" pos:[80,409] width:70 height:16 range:???? align:#left
	label 'roomHeightLabel' "Height:" pos:[37,410] width:39 height:16 enabled:true align:#left
	radiobuttons 'chooseShapeRadioButtons' "" pos:[8,24] width:130 height:32 labels:#("Use rectangular shape", "Use custom shape") align:#left
	GroupBox 'roomGroupBox' "Room" pos:[6,4] width:150 height:56 align:#left
	GroupBox 'detailsGroupBox' "Room Details" pos:[6,383] width:150 height:212 align:#left
	checkbox 'createNewLayerCheckBox' "Create new layer" pos:[14,521] width:128 height:16 checked:true align:#left
	MultiListBox 'pickedShapesList' "" pos:[14,170] width:133 height:119 align:#left
	checkButton 'pickBtn' "Pick" pos:[15,296] width:64 height:27 enabled:true toolTip:"" align:#left
	button 'deleteShapeBtn' "Delete" pos:[83,296] width:64 height:27 align:#left
	checkbox 'normalsCheckBox' "Flip normals for walls" pos:[14,545] width:128 height:16 checked:true align:#left
	GroupBox 'customShapeGroupBox' "Custom shape" pos:[7,154] width:150 height:221 align:#left
	checkbox 'flattenShapesCheckBox' "Flatten shapes" pos:[17,331] width:128 height:16 checked:true align:#left
	checkbox 'removeGapsCheckBox' "Remove gaps" pos:[17,352] width:128 height:16 checked:true align:#left
	label 'floorLevelLabel' "Floor Level:" pos:[16,437] width:61 height:16 enabled:true align:#left
	spinner 'roomLevelSpinner' "" pos:[80,436] width:70 height:16 range:???? align:#left
	checkbox 'createMaterialsCheckBox' "Create sample materials" pos:[14,569] width:137 height:16 checked:true align:#left
	on autoRoomRollout open do
	(
		
		)
	on autoRoomRollout close do
	(
		
		)
	on autoRoomRollout moved pos do
	(
		
		)
	on lengthSpinner changed val do
	(
		
		)
	on widthSpinner changed val do
	(
		
		)
	on createRoomButton pressed do
	(
		
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
		
		)
	on chooseShapeRadioButtons changed stat do
	(
		
		)
	on createNewLayerCheckBox changed state do
	(
		
		)
	on pickBtn changed state do
(
	
	)
	on deleteShapeBtn pressed  do
(
	
	)
	on normalsCheckBox changed state do
	(
		
		)
	on flattenShapesCheckBox changed state do
	(
		
		)
	on removeGapsCheckBox changed state do
	(
		
		)
	on roomLevelSpinner changed val do
	(
		
		)
	on createMaterialsCheckBox changed state do
	(
		
		)
)