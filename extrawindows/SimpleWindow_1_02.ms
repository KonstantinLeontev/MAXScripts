plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	parameters main rollout:params
	(
		wW type:#float ui:windowWidthSpn default:1000 -- window width
		wH type:#float ui:windowHeightSpn default:1500 -- window height
		frameW type:#boolean ui:frameCheck default:true
		fW type:#float ui:frameWidthSpn default:50 -- frame width
		fD type:#float ui:frameDepthSpn default:50 -- frame depth
		glassW type:#boolean ui:glassCheck default:true
		gT type:#float ui:glazingSpn default:10 -- glass thickness
		panHoriz type:#integer ui:panHorizSpn default:1 -- quantity of horizontal panels (along X)
		panVert type:#integer ui:panVertSpn default:1 -- quantity of vertical panels (along Z)
		mullionsVert type:#boolean ui:mullionsVertCheck default:true
		mulW type:#float ui:mullionWidthSpn default:20 -- mullion width
		mulD type:#float ui:mullionDepthSpn default:30 -- mullion depth
		mullionsHoriz type:#boolean ui:mullionsHorizCheck default:true
		mulH type:#float ui:mullionHeightSpn default:20 -- mullion height
		mulDH type:#float ui:mullionDepthHorSpn default:30 -- mullion depth
		board type:#boolean ui:boardCheck default:false -- window board
		boardD type:#float ui:boardDepthSpn default:300 -- board depth
		boardH type:#float ui:boardHeightSpn default:25 -- board height (thickness)
		sill type:#boolean ui:sillCheck default:false -- window sill
		sillD type:#float ui:sillDepthSpn default:120 -- sill depth
		sillInnH type:#float ui:sillInnerHeightSpn default:50 -- sill inner height (thickness)
		sillOutH type:#float ui:sillOuterHeightSpn default:10 -- sill outer height (thickness)
		genMapCoords type:#boolean ui:gen_Map_Coords default:false animatable:false
		--boolBody type:#boolean ui:boolBodyBtn default:false
	)
	rollout params "SimpleWindow"
	(
		spinner windowWidthSpn "Width" range:[0, 100000, 0]
		spinner windowHeightSpn "Height" range:[0, 100000, 0]
		group ""
		(
			checkBox frameCheck "Frame"
			spinner frameWidthSpn "Frame Width" range:[0, 100000, 0]
			spinner frameDepthSpn "Frame Depth" range:[0, 100000, 0]
			checkBox glassCheck "Glass"
			spinner glazingSpn "Glazing" range:[0,100000,0]
			spinner panHorizSpn "Panels Horiz" range:[1,10000,1]
			spinner panVertSpn "Panels Vert" range:[1,10000,1]
		)
		group "Mullions"
		(
			checkBox mullionsVertCheck "Vert. Mullions"
			spinner mullionWidthSpn "Mullion Width" range:[0,100000,0]
			spinner mullionDepthSpn "Mullion Depth" range:[0,100000,0]
			checkBox mullionsHorizCheck "Horiz. Mullions"
			spinner mullionHeightSpn "Mullion Height" range:[0,100000,0]
			spinner mullionDepthHorSpn "Mullion Depth" range:[0,100000,0]
		)
		group ""
		(
			checkBox boardCheck "Board"
			spinner boardDepthSpn "Board Depth" range:[0,100000,0]
			spinner boardHeightSpn "Board Height" range:[0,100000,0]
			checkBox sillCheck "Sill"
			spinner sillDepthSpn "Sill Depth" range:[0,100000,0]
			spinner sillInnerHeightSpn "Sill Inn Height" range:[0,100000,0]
			spinner sillOuterHeightSpn "Sill Out Height" range:[0,100000,0]
		)
		checkBox gen_Map_Coords "Generate Mapping Coords."
	)
	
	rollout test_rollout "Test"
	(
		button test_button "Test"
	)
	
	on hasUVW do genMapCoords -- check for wether the object has UV coords, value stored in genMapCoords
		
	on setGenUVW bool do genMapCoords = bool -- check the coonection between checkBox and genMapCoords param
		
	fn buildBoxFacesArray =
	(
		local tempBox_array = #()
		join tempBox_array #([1,2,3],[1,3,4]\ -- inner faces
											[6,5,8],[6,8,7]\ -- outer faces
											[4,8,5],[4,5,1]) -- left side
		for i=1 to 3 do join tempBox_array #([i,i+4,i+5],[i,i+5,i+1]) -- other side faces
		tempBox_array
	)
	
	on test_button pressed do
	(
		messageBox "Yes!"
	)

	/*on test_button pressed do -- create solid for boolean operations
	(
		-- followed code creates main body for window dimensions
		messageBox"Remember: never press unknown button!"
		local boolMainVertex_array = #()
		join boolMainVertex_array #([0,-boardD,0],[wW,-boardD,0],[wW,-boardD,wH],[0,-boardD,wH],\ -- 1, 2, 3, 4
										[0,sillD,0],[wW,sillD,0],[wW,sillD,wH],[0,sillD,wH]) -- 5, 6, 7, 8
		local boolMainFaces_array = buildBoxFacesArray()
		boolMainMesh = editable_mesh name:"BoolBody"
		setMesh boolMainMesh vertices:boolMainVertex_array faces:boolMainFaces_array
		b = box name:"test_box" width:10 length:50 height:30
		-- create bool body for board
		if board == true then
		(
			local boolBoardVertex_array = #()
			join boolBoardVertex_array #([0,-boardD,-boardH],[wW,-boardD,-boardH],[wW,-boardD,0],[0,-boardD,0],\ -- 1, 2, 3, 4
											[0,fD,-boardH],[wW,fD,-boardH],[wW,fD,0],[0,fD,0]) -- 5, 6, 7, 8
			local boolBoardFaces_array = buildBoxFacesArray()
			boolBoardMesh = mesh
			setMesh boolBoardMesh vertices:boolBoardVertex_array faces:boolBoardFaces_array
			boolMainMesh = boolMainMesh + boolBoardMesh
		)
		-- create bool body for sill
		if sill == true then
		(
			local boolSillVertex_array = #()
			join boolSillVertex_array #([0,0,-SillH],[wW,0,-SillH],[wW,0,0],[0,0,0],\ -- 1, 2, 3, 4
											[0,sillD,-sillH],[wW,sillD,-SillH],[wW,sillD,0],[0,sillD,0]) -- 5, 6, 7, 8
			local boolSillFaces_array = buildBoxFacesArray()
			boolSillMesh = mesh
			setMesh boolSillMesh vertices:boolSillVertex_array faces:boolSillFaces_array
			boolMainMesh = boolMainMesh + boolSillMesh
		)
	)*/
	
	fn setGenMapCoords windowMesh direction =
	(
		setNumTVerts windowMesh (windowMesh.numFaces*2) false -- define number T vertices
		if direction == 0 then local uvw_array = #([0,0,0], [1,0,0], [1,1,0], [0,1,0]) -- T vertices UVW coordinates array for horiz elements
		else local uvw_array = #([0,1,0], [0,0,0], [1,0,0], [1,1,0]) -- T vertices UVW coordinates array for vertical elements
		for f=1 to windowMesh.numTVerts by 4 do (for v=1 to 4 do setTVert windowMesh (f+v-1) uvw_array[v])  -- set all T vertices
		buildTVFaces windowMesh false -- build new T faces array, existing T faces will be lost
		for i=1 to windowMesh.numFaces by 2 do (setTVFace windowMesh i [i*2-1,i*2,i*2+1]; setTVFace windowMesh (i+1) [i*2-1,i*2+1,i*2+2]) -- set all T faces
	)
	
	fn cleanMapCoords windowMesh =
	(
		if meshop.getMapSupport mesh 1 then meshop.freeMapChannel mesh 1
	)
	
	fn panelSize =
	(
		global panW = ((wW-fW*2) - mulW*(panHoriz-1))/panHoriz  -- width of each glazing panel
		global panH = ((wH-fW*2) - mulH*(panVert-1))/panVert -- height of each glazing panel
	)
		
	fn meshFromArrays vertex_array faces_array matID direction = -- build meshes from local arrays for each part of window
	(
		numFaces = faces_array.count
		resultMesh = mesh
		setMesh resultMesh vertices:vertex_array faces:faces_array
		for i=1 to numFaces do setFaceMatID resultMesh i matID
		meshop.autoSmooth resultMesh #{1..numFaces} 0.0 -- remove smooth
		for i=1 to numFaces by 2 do
			(
				setEdgeVis resultMesh i 3 false
				setEdgeVis resultMesh (i+1) 1 false
			)
		if genMapCoords then setGenMapCoords resultMesh direction else cleanMapCoords resultMesh -- clean Map Coords
		resultMesh
	)
	
	fn buildFrame = -- create frame
	(
		-- local arrays to building frame mesh
		local frameVertex_array = #()
		local frameFaces_array = #()
		-- join outer vertices from 1 to 8
		for i=1 to 2 do join frameVertex_array #([0,i*fD-fD,0],[wW,i*fD-fD,0],[wW,i*fD-fD,wH],[0,i*fD-fD,wH])
		-- join inner vertices from 9 to 16
		for i=2 to 1 by -1 do join frameVertex_array #([fW,i*fD-fD,fW],[wW-fW,i*fD-fD,fW],[wW-fW,i*fD-fD,wH-fW],[fW,i*fD-fD,wH-fW])
		-- build frame faces
		for i=1 to 12 by 4 do
			(
				for a=1 to 3 do join frameFaces_array #([a+i-1,i+a+3,i+a+4],[a+i-1,i+a+4,i+a]) -- first 3x2 outer faces
				join frameFaces_array #([i+3,i+7,i+4],[i+3,i+4,i]) -- last 2 faces
			)
		for i=1 to 3 do join frameFaces_array #([i,i+1,i+13],[i,i+13,i+12]) -- 3x2 bottom faces
		join frameFaces_array #([4,1,13],[4,13,16])
		frameMesh = meshFromArrays frameVertex_array frameFaces_array 1 0
		-- building UVW coordinates for frame only
		if genMapCoords then -- this code overrides coordinates from meshFromArrays function to make it more correct
		(
			uO = fW/wW -- U offset for inner vertices
			vO = fW/wH -- V offset for inner vertices
			setNumTVerts frameMesh 8 false -- define number T vertices
			local uvw_array = #([0,0,0], [1,0,0], [1,1,0], [0,1,0],\ -- for outer TVerts
										 [1-vO,1,0], [vO,1,0], [1-uO,1,0], [uO,1,0]) -- for inner TVerts
			for f=1 to frameMesh.numTVerts do setTVert frameMesh (f) uvw_array[f]
			buildTVFaces frameMesh false -- build new T faces array, existing T faces will be lost
			for i=1 to 8 by 2 do (setTVFace frameMesh i [4,1,2]; setTVFace frameMesh (i+1) [4,2,3]) -- set outer T faces [4,1,2][4,2,3]
			for i=9 to 16 by 4 do  -- set sill side T faces [5,9,10],[5,10,6]
				(
					setTVFace frameMesh i [2,7,8]; setTVFace frameMesh (i+1) [2,8,1] -- horizontal faces
					setTVFace frameMesh (i+2) [2,5,6]; setTVFace frameMesh (i+3) [2,6,1] -- vertical faces
				)
			for i=17 to 24 by 2 do (setTVFace frameMesh i [4,1,2]; setTVFace frameMesh (i+1) [4,2,3]) -- set outer T faces [4,1,2][4,2,3]
			for i=25 to 32 by 4 do -- set board side T faces [1,2,14],[1,14,13]
				(
					setTVFace frameMesh i [1,2,7]; setTVFace frameMesh (i+1) [1,7,8] -- horizontal faces
					setTVFace frameMesh (i+2) [1,2,5]; setTVFace frameMesh (i+3) [1,5,6] -- vertical faces
				) 
		)
		else cleanMapCoords frameMesh -- clean if coords no need more
		-- end UVW
		frameMesh
	)
	
	fn buildGlass = -- create glass
	(
		local yInn = (fD-gT)/2 -- Y for inner vertices
		local yOut = (fD+gT)/2 -- Y for outer vertices
		local glassVertex_array = #() -- temp array for glass vertices
		local glassFaces_array = #() -- temp array for glass faces
		-- build vertices
		for i=1 to panVert do
			for a=1 to panHoriz do
				(
					join glassVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- start build inner vertices - 1 
													[fW+panW*a+(mulW*a-mulW),yInn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)], -- end build inner vertices - 4
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- start build outer vertices - 5
													[fW+panW*a+(mulW*a-mulW),yOut,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- 6
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- 7
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)]) -- end build outer vertices - 8
				)
		-- build inner and outer faces
		for i=1 to panVert do
			for a=1 to panHoriz do
				(
					k = a + panHoriz*(i-1) -- coefficient for correct numbers in loop
					join glassFaces_array #([k*8-7, k*8-6, k*8-5],[k*8-7,k*8-5,k*8-4],\ -- inner faces [1,2,3],[1,3,4]
													[k*8,k*8-1,k*8-2],[k*8,k*8-2,k*8-3]) -- outer faces [8,7,6],[8,6,5]
					-- build side faces
					for b=1 to 3 do join glassFaces_array #([k*8-8+b,k*8-4+b,k*8-3+b],[k*8-8+b,k*8-3+b,k*8-7+b]) -- [1,5,6],[1,6,2],[2,6,7],[2,7,3],[3,7,8],[3,8,4]
					join glassFaces_array #	([k*8-4,k*8,k*8-3],[k*8-4,k*8-3,k*8-7]) -- [4,8,5],[4,5,1]
				)
		mesh = meshFromArrays glassVertex_array glassFaces_array 2 0
	)
	
	fn buildVertMullions = -- create mullions
	(
		local yInn = (fD-mulD)/2 -- Y for inner vertices
		local yOut = (fD+mulD)/2 -- Y for outer vertices
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for vertical mullions
		for a=1 to (panHoriz-1) do
				(
					join mullionVertex_array #([fW+panW*a+(mulW*a-mulW),yInn,fW],\ -- start build inner vertices - 1 
													[fW+panW*a+mulW*a,yInn,fW],\ -- 2
													[fW+panW*a+mulW*a,yInn,wH-fW],\ -- 3
													[fW+panW*a+(mulW*a-mulW),yInn,wH-fW], -- end build inner vertices - 4
													[fW+panW*a+(mulW*a-mulW),yOut,fW],\ -- start build outer vertices - 5
													[fW+panW*a+mulW*a,yOut,fW],\ -- 6
													[fW+panW*a+mulW*a,yOut,wH-fW],\ -- 7
													[fW+panW*a+(mulW*a-mulW),yOut,wH-fW]) -- end build outer vertices - 8
				)
		-- build faces
		for a=1 to (panHoriz-1) do
				(
					join mullionFaces_array #([a*8-7, a*8-6, a*8-5],[a*8-7,a*8-5,a*8-4],\ -- inner faces [1,2,3],[1,3,4]
													[a*8,a*8-1,a*8-2],[a*8,a*8-2,a*8-3]) -- outer faces [8,7,6],[8,6,5]
					-- build side faces
					for b=1 to 3 do join mullionFaces_array #([a*8-8+b,a*8-4+b,a*8-3+b],[a*8-8+b,a*8-3+b,a*8-7+b]) -- [1,5,6],[1,6,2],[2,6,7],[2,7,3],[3,7,8],[3,8,4]
					join mullionFaces_array #	([a*8-4,a*8,a*8-3],[a*8-4,a*8-3,a*8-7]) -- [4,8,5],[4,5,1]
				)
		mesh = meshFromArrays mullionVertex_array mullionFaces_array 3 1
	)
	
	fn buildHorizMullions = -- create mullions
	(
		local yInn = (fD-mulDH)/2 -- Y for inner vertices
		local yOut = (fD+mulDH)/2 -- Y for outer vertices
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for horizontal mullions
		for i=1 to (panVert-1) do
			for a=1 to panHoriz do
				(
					join mullionVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- start build inner vertices - 1 
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+mulH*i],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+mulH*i], -- end build inner vertices - 4
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- start build outer vertices - 5
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- 6
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+mulH*i],\ -- 7
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+mulH*i]) -- end build outer vertices - 8
				)
		-- build inner and outer faces
		for i=1 to (panVert-1) do
			for a=1 to panHoriz do
				(
					k = a + panHoriz*(i-1) -- coefficient for correct numbers in loop
					join mullionFaces_array #([k*8-7, k*8-6, k*8-5],[k*8-7,k*8-5,k*8-4],\ -- inner faces [1,2,3],[1,3,4]
													[k*8,k*8-1,k*8-2],[k*8,k*8-2,k*8-3]) -- outer faces [8,7,6],[8,6,5]
					-- build side faces
					for b=1 to 3 do join mullionFaces_array #([k*8-8+b,k*8-4+b,k*8-3+b],[k*8-8+b,k*8-3+b,k*8-7+b]) -- [1,5,6],[1,6,2],[2,6,7],[2,7,3],[3,7,8],[3,8,4]
					join mullionFaces_array #	([k*8-4,k*8,k*8-3],[k*8-4,k*8-3,k*8-7]) -- [4,8,5],[4,5,1]
				)
		mesh = meshFromArrays mullionVertex_array mullionFaces_array 4 0
	)
	
	fn buildBoard = -- create board
	(
		local boardVertex_array = #()
		local boardFaces_array = #()
		-- build vertices
		for i=2 to 1 by -1 do join boardVertex_array #([0,-(i*boardD-boardD),-boardH],[wW,-(i*boardD-boardD),-boardH],\ 
																[wW,-(i*boardD-boardD),0],[0,-(i*boardD-boardD),0])
		-- build faces
		join boardFaces_array #([1,2,3],[1,3,4],[6,5,8],[6,8,7])
		for i=1 to 3 do join boardFaces_array #([i+1, i, i+4],[i+1, i+4, i+5])
		join boardFaces_array #([1,4,8],[1,8,5])
		mesh = meshFromArrays boardVertex_array boardFaces_array 5 0
	)
	
	fn buildBase = -- create base of frame part between sill and board
	(
		local baseH = boardH -- temp varable for base height
		if ((board == true and sill == true) and boardH < sillInnH) then baseH = sillInnH -- set height of base part to biggest value
		if board == false then baseH = sillInnH -- only sill option
		local baseVertex_array = #()
		local baseFaces_array = #()
		-- build vertices
		for i=1 to 2 do join baseVertex_array #([0,i*fD-fD,-baseH],[wW,i*fD-fD,-baseH],[wW,i*fD-fD,0],[0,i*fD-fD,0])
		-- build faces
		join baseFaces_array #([1,2,3],[1,3,4],[6,5,8],[6,8,7])
		for i=1 to 3 do join baseFaces_array #([i+1, i, i+4],[i+1, i+4, i+5])
		join baseFaces_array #([1,4,8],[1,8,5])
		mesh = meshFromArrays baseVertex_array baseFaces_array 6 0
	)
	
	fn buildSill = -- create sill
	(
		local sillVertex_array = #()
		local sillFaces_array = #()
		-- build vertices
		join sillVertex_array #([0,fD,-sillInnH],[wW,fD,-sillInnH],[wW,fD,0],[0,fD,0]) -- inner vertices 1, 2, 3, 4
		join sillVertex_array #([0,fD+sillD,-sillInnH],[wW,fD+sillD,-sillInnH],[wW,fD+sillD,-(sillInnH-sillOutH)],[0,fD+sillD,-(sillInnH-sillOutH)]) -- outer vertices 5, 6, 7, 8
		-- build faces
		join sillFaces_array #([1,2,3],[1,3,4],[6,5,8],[6,8,7])
		for i=1 to 3 do join sillFaces_array #([i+1, i, i+4],[i+1, i+4, i+5])
		join sillFaces_array #([1,4,8],[1,8,5])
		mesh = meshFromArrays sillVertex_array sillFaces_array 7 0
	)
	
	on buildMesh do
	(
		panelSize()
		temp = createInstance plane width:0 length:0
		firstMesh = copy temp.mesh
		meshop.weldVertSet firstMesh #{1..3}
		if (frameW == true) then meshop.attach firstMesh (buildFrame()) -- if you need frame
		if (glassW == true) then meshop.attach firstMesh (buildGlass()) -- create glass panels
		if (mullionsVert == true and panHoriz>1) then meshop.attach firstMesh (buildVertMullions()) -- vertical mullions
		if (mullionsHoriz == true and panVert>1) then meshop.attach firstMesh (buildHorizMullions()) -- horizontal mullions
		if (board == true) then meshop.attach firstMesh (buildBoard()) -- if you need board
		if (sill == true) then meshop.attach firstMesh (buildSill()) -- if you need sill
		if ((board == true or sill == true) and fD > 0) then meshop.attach firstMesh (buildBase()) -- makes base element if there is board or sill
		mesh = firstMesh
	) -- end build mesh
	
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
			1: nodeTM.translation = gridPoint
			4: #stop
			)
		)
		on mouseMove click do
			case click of
			(
			2:	wW = abs(gridDist.x)
			3: fD = abs(gridDist.y)
			4: wH = abs(gridDist.z)
			)
	) -- end create
) -- end plugin
