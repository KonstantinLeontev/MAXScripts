plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	parameters main rollout:params
	(
		wW type:#float ui:windowWidthSpn default:1000 -- window width
		wL type:#float ui:windowLengthSpn default:1500 -- window length
		fW type:#float ui:frameWidthSpn default:50 -- frame width
		fD type:#float ui:frameDepthSpn default:50 -- frame thickness
		gT type:#float ui:glazingSpn default:10 -- glass thickness
	)
	rollout params "SimpleWindow"
	(
		global vertex_array = #()
		global faces_array = #()
		spinner windowWidthSpn "Window Width" range:[0, 10000, 0]
		spinner windowLengthSpn "Window Length" range:[0, 10000, 0]
		spinner frameWidthSpn "Frame Width" range:[0, 10000, 0]
		spinner frameDepthSpn "Frame Depth" range:[0, 10000, 0]
		spinner glazingSpn "Glazing" range:[0,10000,0]
	)
	
	fn buildFrame = -- create frame
	(
		-- join outer verticies from 1 to 8
		for i=1 to 2 do join vertex_array #([0,0,i*fD-fD],[wW,0,i*fD-fD],[wW,wL,i*fD-fD],[0,wL,i*fD-fD])
		-- join inner verticies from 9 to 16
		for i=2 to 1 by -1 do join vertex_array #([fW,fW,fD*i-fD],[wW-fW,fw,fD*i-fD],[wW-fW,wL-fW,fD*i-fD],[fW,wL-fW,fD*i-fD])
		-- build frame faces
		for i=1 to 12 by 4 do -- create side and top faces
			(
				for a=1 to 3 do join faces_array #([i+a-1,i+a,i+a+4],[i+a-1,i+a+4,i+a+3]) -- first 3x2 faces
				join faces_array #([i+3,i,i+4],[i+3,i+4,i+7]) -- last 2 faces
			)
		for i=1 to 3 do join faces_array #([i,i+12,i+13],[i,i+13,i+1]) -- 3x2 bottom faces
		join faces_array #([4,16,13],[4,13,1])
	)
	fn buildGlass = -- create glass
	(
		local zLow = (fD-gT)/2 -- Z for bottom verticies
		local zHigh = (fD+gT)/2 -- Z for top verticies
		join vertex_array #([fW,fW,zLow],[wW-fW,fW,zLow],[wW-fW,wL-fW,zLow],[fW,wL-fW,zLow]) -- build bottom
		join vertex_array #([fW,fW,zHigh],[fW,wL-fW,zHigh],[wW-fW,wL-fW,zHigh],[wW-fW,fW,zHigh]) -- build top
		local fVC = 16 -- frame vertex count
		 -- build local faces (1,4,3)(1,3,2) and (5,8,7)(5,7,6)
		for i=1 to 5 by 4 do join faces_array #([fVC+i,fVC+i+3,fVC+i+2],[fVC+i,fVC+i+2,fVC+i+1])
	)
	on buildMesh do
	(
		vertex_array = #()
		faces_array = #()
		buildFrame()
		buildGlass()
		setMesh mesh vertices:vertex_array faces:faces_array -- build mesh
		meshop.autoSmooth mesh #{1..faces_array.count} 0.0 -- remove smooth
		for i=1 to mesh.numFaces do setEdgeVis mesh i 3 false
		for i=1 to mesh.numFaces do setEdgeVis mesh i 1 false
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
			2:	(wW = abs(gridDist.x); wL = abs(gridDist.y))
			4: fD = abs(gridDist.z)
			3: fW = abs(gridDist.x)
			)
	) -- end create
) -- end plugin
