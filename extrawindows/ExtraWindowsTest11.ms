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
	)
	
	fn panelSize =
	(
		global panW = ((wW-fW*2) - mulW*(panHoriz-1))/panHoriz  -- width of each glazing panel
		global panH = ((wH-fW*2) - mulH*(panVert-1))/panVert -- height of each glazing panel
	)
		
	fn meshFromArrays vertex_array faces_array = -- build meshes from local arrays for each part of window
	(
		tempMesh = createInstance box()
				resultMesh = copy tempMesh.mesh
			setMesh resultMesh vertices:vertex_array faces:faces_array
			meshop.autoSmooth resultMesh #{1..resultMesh.numFaces} 0.0 -- remove smooth
			for i=1 to resultMesh.numFaces by 2 do
				(
					setEdgeVis resultMesh i 3 false
					setEdgeVis resultMesh (i+1) 1 false
				)
			mesh = resultMesh
	)
	
	fn buildFrame = -- create frame
	(
		-- local arrays to building frame mesh
		local frameVertex_array = #()
		local frameFaces_array = #()
		-- join outer verticies from 1 to 8
		for i=1 to 2 do join frameVertex_array #([0,i*fD-fD,0],[wW,i*fD-fD,0],[wW,i*fD-fD,wH],[0,i*fD-fD,wH])
		-- join inner verticies from 9 to 16
		for i=2 to 1 by -1 do join frameVertex_array #([fW,i*fD-fD,fW],[wW-fW,i*fD-fD,fW],[wW-fW,i*fD-fD,wH-fW],[fW,i*fD-fD,wH-fW])
		-- build frame faces
		for i=1 to 12 by 4 do
			(
				for a=1 to 3 do join frameFaces_array #([a+i-1,i+a+3,i+a+4],[a+i-1,i+a+4,i+a]) -- first 3x2 outer faces
				join frameFaces_array #([i+3,i+7,i+4],[i+3,i+4,i]) -- last 2 faces
			)
		for i=1 to 3 do join frameFaces_array #([i,i+1,i+13],[i,i+13,i+12]) -- 3x2 bottom faces
		join frameFaces_array #([4,1,13],[4,13,16])
		mesh = meshFromArrays frameVertex_array frameFaces_array
	)
	
	fn buildGlass = -- create glass
	(
		local yInn = (fD-gT)/2 -- Y for inner verticies
		local yOut = (fD+gT)/2 -- Y for outer verticies
		local glassVertex_array = #() -- temp array for glass verticies
		local glassFaces_array = #() -- temp array for glass faces
		-- build verticies
		for i=1 to panVert do
			for a=1 to panHoriz do
				(
					join glassVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- start build inner verticies - 1 
													[fW+panW*a+(mulW*a-mulW),yInn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)], -- end build inner vertecies - 4
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- start build outer verticies - 5
													[fW+panW*a+(mulW*a-mulW),yOut,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- 6
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- 7
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)]) -- end build outer vertecies - 8
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
		mesh = meshFromArrays glassVertex_array glassFaces_array
	)
	
	fn buildVertMullions = -- create mullions
	(
		local yInn = (fD-mulD)/2 -- Y for inner verticies
		local yOut = (fD+mulD)/2 -- Y for outer verticies
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for vertical mullions
		for a=1 to (panHoriz-1) do
				(
					join mullionVertex_array #([fW+panW*a+(mulW*a-mulW),yInn,fW],\ -- start build inner verticies - 1 
													[fW+panW*a+mulW*a,yInn,fW],\ -- 2
													[fW+panW*a+mulW*a,yInn,wH-fW],\ -- 3
													[fW+panW*a+(mulW*a-mulW),yInn,wH-fW], -- end build inner vertecies - 4
													[fW+panW*a+(mulW*a-mulW),yOut,fW],\ -- start build outer verticies - 5
													[fW+panW*a+mulW*a,yOut,fW],\ -- 6
													[fW+panW*a+mulW*a,yOut,wH-fW],\ -- 7
													[fW+panW*a+(mulW*a-mulW),yOut,wH-fW]) -- end build outer vertecies - 8
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
		mesh = meshFromArrays mullionVertex_array mullionFaces_array
	)
	
	fn buildHorizMullions = -- create mullions
	(
		local yInn = (fD-mulDH)/2 -- Y for inner verticies
		local yOut = (fD+mulDH)/2 -- Y for outer verticies
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for horizontal mullions
		for i=1 to (panVert-1) do
			for a=1 to panHoriz do
				(
					join mullionVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- start build inner verticies - 1 
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yInn,fW+panH*i+mulH*i],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yInn,fW+panH*i+mulH*i], -- end build inner vertecies - 4
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- start build outer verticies - 5
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+(mulH*i-mulH)],\ -- 6
													[fW+panW*a+(mulW*a-mulW),yOut,fW+panH*i+mulH*i],\ -- 7
													[fW+(panW*a-panW)+(mulW*a-mulW),yOut,fW+panH*i+mulH*i]) -- end build outer vertecies - 8
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
		mesh = meshFromArrays mullionVertex_array mullionFaces_array
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
		mesh = meshFromArrays boardVertex_array boardFaces_array
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
		mesh = meshFromArrays baseVertex_array baseFaces_array
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
		mesh = meshFromArrays sillVertex_array sillFaces_array
	)
	
	on buildMesh do
	(
		panelSize()
		if (frameW == true) then -- if you need frame
		(
			frameMesh = buildFrame()
			if (glassW == true) then meshop.attach frameMesh (buildGlass()) -- if you need glass too
			if (mullionsVert == true and panHoriz > 1) then meshop.attach frameMesh (buildVertMullions()) -- if you need vert mullions
			if (mullionsHoriz == true and panHoriz > 1) then meshop.attach frameMesh (buildHorizMullions()) -- if you need horiz mullions
			if (board == true) then meshop.attach frameMesh (buildBoard()) -- if you need board
			if (sill == true) then meshop.attach frameMesh (buildSill()) -- if you need sill
			if (board == true or sill == true) then meshop.attach frameMesh (buildBase()) -- if you need board or sill
			mesh = frameMesh
		)
		else
		(
			if (glassW == true) then
			(
				glassMesh = buildGlass() -- only glass appears
				if (mullionsVert == true and panHoriz > 1) then meshop.attach glassMesh (buildVertMullions()) -- if you need vert mullions
				if (mullionsHoriz == true and panHoriz > 1) then meshop.attach glassMesh (buildHorizMullions()) -- if you need horiz mullions
				mesh = glassMesh
			)
			if (glassW == false) then
				(
					if (mullionsVert == true and mullionsHoriz == false) then mesh = buildVertMullions()
					if (mullionsHoriz == true and mullionsVert == false) then mesh = buildHorizMullions()
					if (mullionsHoriz == false and mullionsVert == false) then
					(
						frameCheck = true
						frame = true
					)
				)
		)
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
