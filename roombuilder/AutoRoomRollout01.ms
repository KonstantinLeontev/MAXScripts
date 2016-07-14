rollout autoRoomRollout "AutoRoom" width:160 height:390
(
	groupBox 'rectangularRoomGroupBox' "Rectangular room" pos:[5,66] width:150 height:80 align:#left
	spinner 'lengthSpinner' "" pos:[80,91] width:70 height:16 range:[0,100000,100] align:#left
	spinner 'widthSpinner' "" pos:[80,117] width:70 height:16 range:[0,100000,100] align:#left
	label 'lengthLabel' "Length:" pos:[16,91] width:56 height:16 align:#left
	label 'widthLabel' "Width:" pos:[16,117] width:56 height:16 align:#left
	button 'createRoomButton' "Create Room" pos:[5,328] width:150 height:56 align:#left
	checkbox 'floorCheckBox' "Floor" pos:[16,247] width:48 height:16 checked:true align:#left
	checkbox 'plinthCheckBox' "Plinth" pos:[81,247] width:56 height:16 checked:true align:#left
	checkbox 'ceilingCheckBox' "Ceiling" pos:[16,271] width:48 height:16 checked:true align:#left
	checkbox 'corniceCheckBox' "Cornice" pos:[81,271] width:56 height:16 checked:true align:#left
	spinner 'roomHeightSpinner' "" pos:[80,217] width:70 height:16 range:[0,100000,100] align:#left
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
	
	)
	on widthSpinner changed val do
(
	
	)
	on createRoomButton pressed  do
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
	on pickCustomShapeButton picked obj do
(
	
	)
	on createNewLayerCheckBox changed state do
(
	
	)
)