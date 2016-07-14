rollout pick_shape_test "Pick shape"
(
	fn shape_filt obj = superClassOf obj == Shape
	checkbutton chooseBtn "Press to Select shapes" toolTip:"Select all what you can!"
	MultiListBox pickedShapesList "Picked shapes"
	button deleteShapeBtn "Delete shape"
	global pickedObjArr = #()
	--free pickedObjArr
	on chooseBtn changed theState do
	(
		case theState of
		(
			true: (chooseBtn.text = "Pick your shapes!"
						while isvalidNode (local temp = pickObject filter:shape_filt) do
						(
							if appendIfUnique pickedObjArr temp == true then (pickedShapesList.items = append pickedShapesList.items (temp.name as string))
								else messageBox "Already added! Choose another shape or press pick button to finish."
						)
					)
			false: (chooseBtn.text = "Press to Select shapes")
		)
	)
	on deleteShapeBtn pressed do
	(
		pickedObjArr = for i in (-pickedShapesList.selection) collect pickedObjArr[i] -- Delete selected items from pickedObj array
		pickedShapesList.items = for i in (-pickedShapesList.selection) collect pickedShapesList.items[i] -- Delete selected items from list
	)
)
	createDialog pick_shape_test
	