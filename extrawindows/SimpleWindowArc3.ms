wW = 900.0 -- window width
wH = 2500.0 -- window height
tH = 150.0 -- transom height
fW = 30.0 -- frame width
segm = 30 -- number of segments
fD = 50 -- frame depth
gT = 10 -- glass thickness

radius1 = ((wW/2)^2 + tH^2)/(2*tH) -- outer radius from Pythagorean theorem
radius2 = radius1 - fW -- inner radius

ang = asin(wW/(2*radius1)) -- half of central angle
startAng = 90-ang -- start angle
stopAng = 90+ang -- end angle
stepAng = 2*ang/segm -- sztep angle for each segment

-- start to build glass
fn transGlass = 
(
	local vert_array = #()
	local face_array = #()
	for a=startAng to stopAng+0.1 by stepAng do append vert_array [radius2*cos(a), 0, radius2*sin(a)]
	append vert_array [0, 0, radius2*sin(startAng)] -- central point
	local vert = vert_array.count
	for i=1 to vert-2 do append face_array [vert, i, i+1]
	mesh vertices:vert_array faces:face_array
)

-- end to build glass

-- start to build arc frame
fn arcFrame = 
(	
	fn frontArc y =
	(
		local vert_array = #()
		local face_array = #()
		zStart = undefined
		-- start loop for front vertices	
		for a=startAng to stopAng+0.1 by stepAng do -- add 0.1 to compensate round float value
		(
				x1 = radius2*cos(a)
				z1 = radius2*sin(a)
				x2 = radius1*cos(a)
				z2 = radius1*sin(a)
				if zStart == undefined then zStart = z1+(fW-(x2-x1))*tan(90-startAng) -- base height for first and last inner vertex
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
		m = mesh vertices:vert_array faces:face_array
		if y==0 then meshop.flipNormals m #{1..m.numfaces} -- flip normals for front arc
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
	for i=1 to segm*2 by 2 do -- bottom and top faces
	(
		setFace arcMesh (firstNumF+i) [i, i+2, vert/2+i+2] -- bottom [1,3,13]  - example for 3 segm
		setFace arcMesh (firstNumF+i+1) [i, vert/2+i+2, vert/2+i] -- bottom [1,13,11] - example for 3 segm
		setFace arcMesh (secondNumF+i) [i+1, vert/2+i+1, vert/2+i+3] -- top [2,12,14]  - example for 3 segm
		setFace arcMesh (secondNumF+i+1) [i+1, vert/2+i+3, i+3] -- top [2,14,4] - example for 3 segm
	)
	-- right faces
	setFace arcMesh (endNumF-3) [2, vert/2-1, vert-1]
	setFace arcMesh (endNumF-2) [2, vert-1, vert/2+2]
	-- left faces
	setFace arcMesh (endNumF-1) [vert/2-2, vert-2, vert]
	setFace arcMesh endNumF [vert/2-2, vert, vert/2]
	-- set smoothing groups
	meshop.autoSmooth arcMesh #{1..endNumF} 0.0
	update arcMesh
) -- end to build arc frame
arcFrame()
transGlass()