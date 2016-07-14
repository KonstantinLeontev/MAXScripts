plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	--local arcTopMaxH = 500
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
		arcTop type:#boolean ui:arcTopCheck default:false
		arcH type:#float ui:arcHeight default:400
		segm type:#integer ui:numberOfSegm default:9
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
		group "Arc Top"
		(
			checkBox arcTopCheck "Arc Top"
			spinner arcHeight "Arc Height" range:[1,100000,0]
			spinner numberOfSegm "Segments" range:[2,1000,0]
		)
		checkBox gen_Map_Coords "Generate Mapping Coords."
	)
	
	on hasUVW do genMapCoords -- check for wether the object has UV coords, value stored in genMapCoords
		
	on setGenUVW bool do genMapCoords = bool -- check the coonection between checkBox and genMapCoords param
	
		
	
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
	
	fn buildArcTop =
	(
		global radius1 = ((wW/2)^2 + arcH^2)/(2*arcH) -- outer radius from Pythagorean theorem
		global radius2 = radius1 - fW -- inner radius

		local ang = asin(wW/(2*radius1)) -- half of central angle
		global startAng = 90-ang -- start angle
		global stopAng = 90+ang -- end angle
		global stepAng = 2*ang/segm -- step angle for each segment

		local zBase = radius2*sin(startAng)+(fW-(radius1*cos(startAng)-radius2*cos(startAng)))*tan(90-startAng) -- base height for first and last inner vertex
		global dZ = wH - zBase -- increment for z to align with window top
		global zStart = zBase + dZ
		global dX = wW/2 -- offset along X to align with window
		-- start to build glass
		fn arcGlass = 
		(
			local vert_array = #()
			local face_array = #()
			local yIn = (fD-gT)/2 -- Y for inner vertices
			local yOut = (fD+gT)/2 -- Y for outer vertices
			for i=1 to 2 do
			(
				if i==1 then y = yIn else y = yOut
				for a=startAng to stopAng+0.1 by stepAng do
					(
						x1 = radius2*cos(a) + dX
						z1 = radius2*sin(a) + dZ
						x2 = radius1*cos(a) + dX
						z2 = radius1*sin(a) + dZ
						if a==startAng then append vert_array [x2-fW, y, zStart] else -- move first vertex to align with frame
						if ((stopAng-a)<0.1) then append vert_array [x2+fW, y, zStart] else -- move last vertex to align with frame
						if (z1 > zStart) then append vert_array [x1, y, z1]
					)
				append vert_array [dX, y, zStart] -- central point
			)
			vert = vert_array.count
			for i=1 to vert/2-2 do append face_array [vert/2, i, i+1] -- front faces
			for i=vert/2+1 to vert-2 do append face_array [vert, i+1, i] -- back faces
			for i=1 to vert/2-2 do -- top faces
			(
				append face_array [i, vert/2+i, vert/2+i+1]
				append face_array [i, vert/2+i+1, i+1]
			)
			-- bottom faces
			append face_array [1, vert/2, vert]
			append face_array [1, vert, vert/2+1]
			append face_array [vert/2, vert/2-1, vert-1]
			append face_array [vert/2, vert-1, vert]
			m = mesh.mesh
			setMesh m vertices:vert_array faces:face_array
			numFaces = face_array.count
			for i=1 to numFaces do setFaceSmoothGroup m i 0
			if genMapCoords then meshop.ApplyUVWMap m #box utile:0.01 vtile:0.01 wtile:0.01 else cleanMapCoords m
			-- set edge visiblity
			setEdgeVis m 1 3 false -- first front face
			for i=2 to vert/2-3 do -- front faces
			(
				setEdgeVis m i 3 false
				setEdgeVis m i 1 false
			)
			setEdgeVis m (vert/2-2) 1 false -- last front face
			setEdgeVis m (vert/2-1) 1 false -- first back face
			for i=vert/2 to vert-5 do -- back faces
			(
				setEdgeVis m i 1 false
				setEdgeVis m i 3 false
			)
			setEdgeVis m (vert-4) 3 false -- last back face
			for i=vert-3 to numFaces by 2 do -- top and bottom faces
			(
				setEdgeVis m i 3 false
				setEdgeVis m (i+1) 1 false
			) -- end edge visiblity
			update m
			m
		)
		-- end to build glass

		-- start to build arc frame
		fn arcFrame = 
		(	
			fn frontArc y = -- build front faces
			(
				local vert_array = #()
				local face_array = #()
				-- start loop for front vertices	
				for a=startAng to stopAng+0.1 by stepAng do -- add 0.1 to compensate round float value
				(
						x1 = radius2*cos(a) + dX
						z1 = radius2*sin(a) + dZ
						x2 = radius1*cos(a) + dX
						z2 = radius1*sin(a) + dZ
					if a==startAng then -- inner vertex
					(
						v1 = [x2-fW, y, zStart] -- move first inner vertex to align with frame
					) else
					if ((stopAng-a)<0.1) then -- compare with 0.1 to compensate round float value
					(
						v1 = [x2+fW, y, zStart] -- move last inner vertex to align with frame
					) else
					if (z1 > zStart) then v1 = [x1, y, z1] else continue
					v2 = [x2, y, z2] -- outer vertex
					append vert_array v1
					append vert_array v2
				) -- end loop for front vertices
				-- extra left and right verttices
				append vert_array [radius1*cos(startAng)+dX, y, zStart] -- right vertex
				append vert_array [radius1*cos(stopAng)+dX, y, zStart] -- left vertex
				-- build faces
				num = vert_array.count
				for i=1 to num/2-2 do join face_array #([i*2-1, i*2+1, i*2+2],[i*2-1, i*2+2, i*2])    -- #([1,3,4],[1,4,2])
				-- extra faces
				join face_array #([1, 2, num-1],[num-3, num, num-2])
				m = mesh.mesh
				setMesh m vertices:vert_array faces:face_array -- build mesh
				numF = m.numFaces
				-- set UVW coords
				if genMapCoords then
				(
					A = [radius2*cos(startAng)+dX, y, radius2*sin(startAng) + dZ] -- first probably point
					B = getVert m 1 -- first vertex in mesh
					C = getVert m 3 -- third vertex in mesh
					uvwOffset = (length (B-C))/(length (A-C))
					local uvw_array = #([0,0,0],[1,0,0],[1,1,0],[0,1,0],[uvwOffset,0,0],[1-uvwOffset,0,0])
					setNumTVerts m 6 false -- set number of TVerts
					for i=1 to 6 do setTVert m i uvw_array[i] -- set each TVert to own coord
					buildTVFaces m
					setTVFace m 1 [5,1,4] -- first small face
					setTVFace m 2 [5,4,3] -- first big face
					for i=3 to numF-4 by 2 do -- front faces
					(
						setTVFace m i [2,1,4]
						setTVFace m (i+1) [2,4,3]
					)
					setTVFace m (numF-3) [2,6,4] -- last small face
					setTVFace m (numF-2) [2,4,3] -- last big face
					setTVFace m (numF-1) [1,3,2] -- right face
					setTVFace m numF [2,1,4] -- left face
				) else cleanMapCoords m 	-- end UVW
				for i=1 to numF-2 by 2 do -- set edge vis
				(
					setEdgeVis m i 3 false
					setEdgeVis m (i+1) 1 false
				)
				if y==0 then meshop.flipNormals m #{1..numF} -- flip normals for front arc
				update m
				m
			) -- end build front faces
			arcMesh = frontArc 0
			meshop.attach arcMesh (frontArc fD)
			vert = arcMesh.numVerts
			firstNumF = arcMesh.numFaces -- start number of faces
			secondNumF = firstNumF + segm*2 -- start + bottom faces
			endNumF = firstNumF + segm*4 + 4 -- total number of faces
			setNumFaces arcMesh endNumF true
			for i=1 to vert/2-4 by 2 do -- bottom and top faces segm*2
			(
				setFace arcMesh (firstNumF+i) [i, i+2, vert/2+i+2] -- bottom [1,3,13]  - example for 3 segm
					if genMapCoords then setTVFace arcMesh (firstNumF+i) [3,4,1] -- uvw
					setEdgeVis arcMesh (firstNumF+i) 1 true -- edge visiblity
					setEdgeVis arcMesh (firstNumF+i) 2 true
				setFace arcMesh (firstNumF+i+1) [i, vert/2+i+2, vert/2+i] -- bottom [1,13,11] - example for 3 segm
					if genMapCoords then setTVFace arcMesh (firstNumF+i+1) [3,1,2]
					setEdgeVis arcMesh (firstNumF+i+1) 2 true
					setEdgeVis arcMesh (firstNumF+i+1) 3 true
				setFace arcMesh (secondNumF+i) [i+1, vert/2+i+1, vert/2+i+3] -- top [2,12,14]  - example for 3 segm
					if genMapCoords then setTVFace arcMesh (secondNumF+i) [2,3,4]
					setEdgeVis arcMesh (secondNumF+i) 1 true
					setEdgeVis arcMesh (secondNumF+i) 2 true
				setFace arcMesh (secondNumF+i+1) [i+1, vert/2+i+3, i+3] -- top [2,14,4] - example for 3 segm
					if genMapCoords then setTVFace arcMesh (secondNumF+i+1) [2,4,1]
					setEdgeVis arcMesh (secondNumF+i+1) 2 true
					setEdgeVis arcMesh (secondNumF+i+1) 3 true
			)
			-- right faces
			setFace arcMesh (endNumF-3) [2, vert/2-1, vert-1]
				if genMapCoords then setTVFace arcMesh (endNumF-3) [4,1,2]
				setEdgeVis arcMesh (endNumF-3) 1 true
				setEdgeVis arcMesh (endNumF-3) 2 true
			setFace arcMesh (endNumF-2) [2, vert-1, vert/2+2]
				if genMapCoords then setTVFace arcMesh (endNumF-2) [4,2,3]
				setEdgeVis arcMesh (endNumF-2) 2 true
				setEdgeVis arcMesh (endNumF-2) 3 true
			-- left faces
			setFace arcMesh (endNumF-1) [vert/2-2, vert-2, vert]
				if genMapCoords then setTVFace arcMesh (endNumF-1) [3,4,1]
				setEdgeVis arcMesh (endNumF-1) 1 true
				setEdgeVis arcMesh (endNumF-1) 2 true
			setFace arcMesh endNumF [vert/2-2, vert, vert/2]
				if genMapCoords then setTVFace arcMesh endNumF [3,1,2]
				setEdgeVis arcMesh endNumF 2 true
				setEdgeVis arcMesh endNumF 3 true
			-- set smoothing groups
			meshop.autoSmooth arcMesh #{1..endNumF} 0.0
			-- meshop.ApplyUVWMap arcMesh #box utile:0.01 vtile:0.01 wtile:0.01
			update arcMesh
			arcMesh
		) -- end to build arc frame
		topArcMesh = mesh.mesh
		if (frameW == true and glassW == false) then meshop.attach topArcMesh (arcFrame())
		if (frameW == true and glassW == true) then
			(
				meshop.attach topArcMesh (arcGlass())
				meshop.attach topArcMesh (arcFrame())
			)
		if (frameW == false and glassW == true) then meshop.attach topArcMesh (arcGlass())
		--if genMapCoords == false then cleanMapCoords topArcMesh -- clean if coords no need more
		topArcMesh
	) -- end build arcTop
	
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
		if genMapCoords then -- this code overrides coordinates from meshFromArrays function to make them more correct
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
		local glassVertex_array = #() -- temp array for glass vertices
		local glassFaces_array = #() -- temp array for glass faces
		local yIn = (fD-gT)/2 -- Y for inner vertices
		local yOut = (fD+gT)/2 -- Y for outer vertices
		-- build vertices
		for i=1 to panVert do
			for a=1 to panHoriz do
				(
					join glassVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yIn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- start build inner vertices - 1 
													[fW+panW*a+(mulW*a-mulW),yIn,fW+(panH*i-panH)+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yIn,fW+panH*i+(mulH*i-mulH)],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yIn,fW+panH*i+(mulH*i-mulH)], -- end build inner vertices - 4
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
		local yIn = (fD-mulD)/2 -- Y for inner vertices
		local yOut = (fD+mulD)/2 -- Y for outer vertices
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for vertical mullions
		for a=1 to (panHoriz-1) do
				(
					join mullionVertex_array #([fW+panW*a+(mulW*a-mulW),yIn,fW],\ -- start build inner vertices - 1 
													[fW+panW*a+mulW*a,yIn,fW],\ -- 2
													[fW+panW*a+mulW*a,yIn,wH-fW],\ -- 3
													[fW+panW*a+(mulW*a-mulW),yIn,wH-fW], -- end build inner vertices - 4
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
		local yIn = (fD-mulDH)/2 -- Y for inner vertices
		local yOut = (fD+mulDH)/2 -- Y for outer vertices
		local mullionVertex_array = #()
		local mullionFaces_array = #()
		-- build vertices for horizontal mullions
		for i=1 to (panVert-1) do
			for a=1 to panHoriz do
				(
					join mullionVertex_array #([fW+(panW*a-panW)+(mulW*a-mulW),yIn,fW+panH*i+(mulH*i-mulH)],\ -- start build inner vertices - 1 
													[fW+panW*a+(mulW*a-mulW),yIn,fW+panH*i+(mulH*i-mulH)],\ -- 2
													[fW+panW*a+(mulW*a-mulW),yIn,fW+panH*i+mulH*i],\ -- 3
													[fW+(panW*a-panW)+(mulW*a-mulW),yIn,fW+panH*i+mulH*i], -- end build inner vertices - 4
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
		if (arcTop == true and (frameW == true or glassW == true)) then meshop.attach firstMesh (buildArcTop())
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
