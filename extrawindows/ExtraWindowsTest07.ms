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
	)
	rollout params "SimpleWindow"
	(
		global vertex_array = #()
		global faces_array = #()
		spinner windowWidthSpn "Window Width" range:[0, 100000, 0]
		spinner windowHeightSpn "Window Height" range:[0, 100000, 0]
		spinner frameWidthSpn "Frame Width" range:[0, 100000, 0]
		spinner frameDepthSpn "Frame Depth" range:[0, 100000, 0]
		spinner glazingSpn "Glazing" range:[0,100000,0]
	)
	
	fn buildFrame = -- create frame
	(
		-- join outer verticies from 1 to 8
		for i=1 to 2 do join vertex_array #([0,i*fD-fD,0],[wW,i*fD-fD,0],[wW,i*fD-fD,wH],[0,i*fD-fD,wH])
		-- join inner verticies from 9 to 16
		for i=2 to 1 by -1 do join vertex_array #([fW,i*fD-fD,fW],[wW-fW,i*fD-fD,fW],[wW-fW,i*fD-fD,wH-fW],[fW,i*fD-fD,wH-fW])
		-- build frame faces
		for i=1 to 12 by 4 do
			(
				for a=1 to 3 do join faces_array #([a+i-1,i+a+3,i+a+4],[a+i-1,i+a+4,i+a]) -- first 3x2 outer faces
				join faces_array #([i+3,i+7,i+4],[i+3,i+4,i]) -- last 2 faces
			)
		for i=1 to 3 do join faces_array #([i,i+1,i+13],[i,i+13,i+12]) -- 3x2 bottom faces
		join faces_array #([4,1,13],[4,13,16])
	--	global vertexCount = vertex_array.count
	)
	fn incrementFaces_array tempFaces_array count = -- increment the vertecies values for each face in local faces arrays
	(
		for i=1 to tempFaces_array.count do
			for a=1 to 3 do tempFaces_array[i][a] += count
	)
	fn buildGlass count = -- create glass
	(
		local yInn = (fD-gT)/2 -- Y for inner verticies
		local yOut = (fD+gT)/2 -- Y for outer verticies
		local glassFaces_array = #() -- temp array for glass faces
		-- build verticies
		join vertex_array #([fW,yInn,fW],[wW-fW,yInn,fW],[wW-fW,yInn,wH-fW],[fW,yInn,wH-fW]) -- build inner
		join vertex_array #([fW,yOut,fW],[wW-fW,yOut,fW],[wW-fW,yOut,wH-fW],[fW,yOut,wH-fW]) -- build outer
		-- build faces
		join glassFaces_array #([1,2,3],[1,3,4]) -- inner faces of glass
		for i=1 to 3 do join glassFaces_array #([i,i+4,i+5],[i,i+5,i+1]) -- side faces of glass
		join glassFaces_array #([5,1,4],[5,4,8]) -- last side faces
		join glassFaces_array #([6,5,8],[6,8,7]) -- outer faces
		incrementFaces_array glassFaces_array count -- increase each member with current vertex_array.count value
		join faces_array glassFaces_array
	)
	on buildMesh do
	(
		vertex_array = #()
		faces_array = #()
		buildFrame()
		buildGlass vertex_array.count
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
			2:	wW = abs(gridDist.x)
			3: fD = abs(gridDist.y)
			4: wH = abs(gridDist.z)
			)
	) -- end create
) -- end plugin
