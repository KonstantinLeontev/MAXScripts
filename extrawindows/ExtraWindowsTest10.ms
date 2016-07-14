plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	parameters main rollout:params
	(
		wW type:#float ui:windowWidthSpn default:1000 -- window width
		wH type:#float ui:windowHeightSpn default:1500 -- window height
		fW type:#float ui:frameWidthSpn default:50 -- frame width
		fD type:#float ui:frameDepthSpn default:50 -- frame depth
		gT type:#float ui:glazingSpn default:10 -- glass thickness
		panHoriz type:#integer ui:panHorizSpn default:1 -- quantity of horizontal panels (along X)
		panVert type:#integer ui:panVertSpn default:1 -- quantity of vertical panels (along Z)
		mulW type:#float ui:mullionWidthSpn default:20 -- mullion width
		mulH type:#float ui:mullionHeightSpn default:20 -- mullion height
		mulD type:#float ui:mullionDepthSpn default:30 -- mullion depth
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
		spinner windowWidthSpn "Window Width" range:[0, 100000, 0]
		spinner windowHeightSpn "Window Height" range:[0, 100000, 0]
		spinner frameWidthSpn "Frame Width" range:[0, 100000, 0]
		spinner frameDepthSpn "Frame Depth" range:[0, 100000, 0]
		spinner glazingSpn "Glazing" range:[0,100000,0]
		spinner panHorizSpn "Panels Horiz" range:[1,10000,1]
		spinner panVertSpn "Panels Vert" range:[1,10000,1]
		spinner mullionWidthSpn "Mullion Width" range:[0,100000,0]
		spinner mullionHeightSpn "Mullion Height" range:[0,100000,0]
		spinner mullionDepthSpn "Mullion Depth" range:[0,100000,0]
		checkBox boardCheck "Board"
		spinner boardDepthSpn "Board Depth" range:[0,100000,0]
		spinner boardHeightSpn "Board Height" range:[0,100000,0]
		checkBox sillCheck "Sill"
		spinner sillDepthSpn "Sill Depth" range:[0,100000,0]
		spinner sillInnerHeightSpn "Sill Inner Height" range:[0,100000,0]
		spinner sillOuterHeightSpn "Sill Outer Height" range:[0,100000,0]
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
		-- building temp mesh for a frame
		tempMesh = createInstance box()
			global frameMesh = copy tempMesh.mesh
			--delete tempMesh
			setMesh frameMesh vertices:frameVertex_array faces:frameFaces_array
			meshop.autoSmooth frameMesh #{1..frameMesh.numFaces} 0.0 -- remove smooth
			--for i=1 to frameMesh.numFaces do setEdgeVis frameMesh i 3 false
			--for i=1 to frameMesh.numFaces do setEdgeVis frameMesh i 1 false
			update frameMesh
	)
	
	fn buildGlass = -- create glass
	(
		local yInn = (fD-gT)/2 -- Y for inner verticies
		local yOut = (fD+gT)/2 -- Y for outer verticies
		local glassVertex_array = #() -- temp array for glass verticies
		local glassFaces_array = #() -- temp array for glass faces
		local panW = ((wW-fW*2) - mulW*(panHoriz-1))/panHoriz -- width of each glazing panel
		local panH = ((wH-fW*2) - mulH*(panVert-1))/panVert -- height of each glazing panel
		-- build verticies
		-- divide variant
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
					--join glassVertex_array #([fW,yOut,fW],[wW-fW,yOut,fW],[wW-fW,yOut,wH-fW],[fW,yOut,wH-fW]) -- build outer vertecies
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
		tempMesh = createInstance box()
			global glassMesh = copy tempMesh.mesh
		setMesh glassMesh vertices:glassVertex_array faces:glassFaces_array
		meshop.autoSmooth glassMesh #{1..glassMesh.numFaces} 0.0 -- remove smooth
		for i=1 to glassMesh.numFaces by 2 do
			(
				setEdgeVis glassMesh i 3 false
				setEdgeVis glassMesh (i+1) 1 false
			)
			update glassMesh
	)
	
	fn buildMullions = -- create mullions
	(
		
	)
	
	fn buildBoard = -- create board
	(
		
	)
	
	fn buildBase = -- create base of frame part between sill and board
	(
		local baseH = boardH -- temp varable for base height
		if (board == true and sill == true) then
			(if boardH < sillH then baseH = sillH) -- set height of base part to biggest value
		else (if board == false then baseH = sillH) -- only sill option
		local baseVertex_array = #()
		local baseFaces_array = #()
		-- build vertices
		for i=1 to 2 do join baseVertex_array #([0,i*fD-fD,-boardH],[wW,i*fD-fD,-boardH],[wW,i*fD-fD,0],[0,i*fD-fD,0])
		-- build faces
		join baseFaces_array #([1,2,3],[1,3,4],[6,5,8],[6,8,7])
		for i=1 to 3 do join baseFaces_array #([i+1, i, i+4],[i+1, i+4, i+5])
		join baseFaces_array #([1,4,8],[1,8,5])
		-- build temp mesh
		tempMesh = createInstance box()
			global baseMesh = copy tempMesh.mesh
		setMesh baseMesh vertices:baseVertex_array faces:baseFaces_array
		meshop.autoSmooth baseMesh #{1..baseMesh.numFaces} 0.0 -- remove smooth
		/*for i=1 to baseMesh.numFaces by 2 do
			(
				setEdgeVis baseMesh i 3 false
				--setEdgeVis baseMesh (i+1) 1 false
			)
			update baseMesh*/
	)
	
	fn buildSill = -- create sill
	(
	)
	
	on buildMesh do
	(
		buildFrame()
		buildGlass()
		/*if (board == false and sill == false) then mesh = frameMesh.mesh + glassMesh.mesh
		if (board == true or sill == true) then
			(
				buildBase()
				mesh = frameMesh.mesh + glassMesh.mesh + baseMesh.mesh
			)*/
		if (board == false and sill == false) then 
		(
			meshop.attach frameMesh glassMesh
			--update frameMesh.mesh
			mesh = frameMesh.mesh
		)
		if (board == true or sill == true) then
			(
				buildBase()
				mesh = meshop.attach glassMesh.mesh frameMesh.mesh
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
