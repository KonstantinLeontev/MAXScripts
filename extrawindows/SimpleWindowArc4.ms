wW = 900.0 -- window width
wH = 2500.0 -- window height
tH = 400.0 -- transom height
fW = 30.0 -- frame width
segm = 235 -- number of segments
fD = 50 -- frame depth
gT = 10 -- glass thickness

radius1 = ((wW/2)^2 + tH^2)/(2*tH) -- outer radius from Pythagorean theorem
radius2 = radius1 - fW -- inner radius

ang = asin(wW/(2*radius1)) -- half of central angle
startAng = 90-ang -- start angle
stopAng = 90+ang -- end angle
stepAng = 2*ang/segm -- sztep angle for each segment

zStart = radius2*sin(startAng)+(fW-(radius1*cos(startAng)-radius2*cos(startAng)))*tan(90-startAng) -- base height for first and last inner vertex

-- start to build glass
fn transGlass = 
	(
		local vert_array = #()
		local face_array = #()
		for i=1 to 2 do
		(
			y = i*gT - gT -- glass planes offset along Y axis
			for a=startAng to stopAng+0.1 by stepAng do
				(
					x1 = radius2*cos(a)
					z1 = radius2*sin(a)
					x2 = radius1*cos(a)
					z2 = radius1*sin(a)
					if a==startAng then append vert_array [x2-fW, y, zStart] else -- move first vertex to align with frame
					if ((stopAng-a)<0.1) then append vert_array [x2+fW, y, zStart] else -- move last vertex to align with frame
					if (z1 > zStart) then append vert_array [x1, y, z1]
				)
			append vert_array [0, y, zStart] -- central point
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
		m = mesh vertices:vert_array faces:face_array
		numFaces = face_array.count
		for i=1 to numFaces do setFaceSmoothGroup m i 0
		meshop.ApplyUVWMap m #box utile:0.01 vtile:0.01 wtile:0.01
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
	fn frontArc y =
	(
		local vert_array = #()
		local face_array = #()
		-- start loop for front vertices	
		for a=startAng to stopAng+0.1 by stepAng do -- add 0.1 to compensate round float value
		(
				x1 = radius2*cos(a)
				z1 = radius2*sin(a)
				x2 = radius1*cos(a)
				z2 = radius1*sin(a)
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
		)
		-- end loop for front vertices
		-- extra left and right verttices
		append vert_array [radius1*cos(startAng), y, zStart] -- right vertex
		append vert_array [radius1*cos(stopAng), y, zStart] -- left vertex
		-- build faces
		num = vert_array.count
		for i=1 to num/2-2 do join face_array #([i*2-1, i*2+1, i*2+2],[i*2-1, i*2+2, i*2])    -- #([1,3,4],[1,4,2])
		-- extra faces
		join face_array #([1, 2, num-1],[num-3, num, num-2])
		m = mesh vertices:vert_array faces:face_array -- build mesh
		numF = m.numFaces
		-- set UVW coords
		-- coord for first vert
		A = [radius2*cos(startAng), y, radius2*sin(startAng)] -- first probably point
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
		for i=1 to numF-2 by 2 do -- set edge vis
		(
			setEdgeVis m i 3 false
			setEdgeVis m (i+1) 1 false
		)
		if y==0 then meshop.flipNormals m #{1..numF} -- flip normals for front arc
		update m
		m
	)

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
			setTVFace arcMesh (firstNumF+i) [3,4,1] -- uvw
			setEdgeVis arcMesh (firstNumF+i) 1 true -- edge visiblity
			setEdgeVis arcMesh (firstNumF+i) 2 true
		setFace arcMesh (firstNumF+i+1) [i, vert/2+i+2, vert/2+i] -- bottom [1,13,11] - example for 3 segm
			setTVFace arcMesh (firstNumF+i+1) [3,1,2]
			setEdgeVis arcMesh (firstNumF+i+1) 2 true
			setEdgeVis arcMesh (firstNumF+i+1) 3 true
		setFace arcMesh (secondNumF+i) [i+1, vert/2+i+1, vert/2+i+3] -- top [2,12,14]  - example for 3 segm
			setTVFace arcMesh (secondNumF+i) [2,3,4]
			setEdgeVis arcMesh (secondNumF+i) 1 true
			setEdgeVis arcMesh (secondNumF+i) 2 true
		setFace arcMesh (secondNumF+i+1) [i+1, vert/2+i+3, i+3] -- top [2,14,4] - example for 3 segm
			setTVFace arcMesh (secondNumF+i+1) [2,4,1]
			setEdgeVis arcMesh (secondNumF+i+1) 2 true
			setEdgeVis arcMesh (secondNumF+i+1) 3 true
	)
	-- right faces
	setFace arcMesh (endNumF-3) [2, vert/2-1, vert-1]
		setTVFace arcMesh (endNumF-3) [4,1,2]
		setEdgeVis arcMesh (endNumF-3) 1 true
		setEdgeVis arcMesh (endNumF-3) 2 true
	setFace arcMesh (endNumF-2) [2, vert-1, vert/2+2]
		setTVFace arcMesh (endNumF-2) [4,2,3]
		setEdgeVis arcMesh (endNumF-2) 2 true
		setEdgeVis arcMesh (endNumF-2) 3 true
	-- left faces
	setFace arcMesh (endNumF-1) [vert/2-2, vert-2, vert]
		setTVFace arcMesh (endNumF-1) [3,4,1]
		setEdgeVis arcMesh (endNumF-1) 1 true
		setEdgeVis arcMesh (endNumF-1) 2 true
	setFace arcMesh endNumF [vert/2-2, vert, vert/2]
		setTVFace arcMesh endNumF [3,1,2]
		setEdgeVis arcMesh endNumF 2 true
		setEdgeVis arcMesh endNumF 3 true
	-- set UVW coords
	--format "Number of TVerts is: %\n" (getNumTVerts arcMesh)
	--for i=1 to (getNumTVerts arcMesh) do format "% vert is: %\n" i (getTvert arcMesh i)
	--buildTVFaces arcMesh true
	-- set smoothing groups
	meshop.autoSmooth arcMesh #{1..endNumF} 0.0
	-- meshop.ApplyUVWMap arcMesh #box utile:0.01 vtile:0.01 wtile:0.01
	update arcMesh
) -- end to build arc frame
arcFrame()
transGlass()