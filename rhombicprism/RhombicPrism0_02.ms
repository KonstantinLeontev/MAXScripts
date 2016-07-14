plugin simpleObject RhombicPrism
name:"RhombicPrism"
classID:#(0x7bf53528, 0x24d72cd7)
category:"Extended Primitives"
(
	parameters main rollout:params
	(
		widthR type:#float ui:widthSpn default:100
		lengthR type:#float ui:lengthSpn default:150
		heightR type:#float ui:heightSpn default:200
		scaleR type:#float ui:scaleSpn default:100
		heightSegs type:#integer ui:heightSegsSpn default:1
		genMapCoords type:#boolean ui:gen_Map_Coords default:false animatable:false
	)
	rollout params "RhombicPrism Parameters"
	(
		spinner widthSpn "Whidth:" type:#float range:[0,100000,100]
		spinner lengthSpn "Length:" type:#float range:[0,100000,150]
		spinner heightSpn "Height:" type:#float range:[-100000,100000,200]
		spinner scaleSpn "Scale:" type:#float range:[0,10000,100]
		spinner heightSegsSpn "Height Segs:" type:#integer range:[1,1000,1]
		checkBox gen_Map_Coords "Generate Mapping coords."
	) -- end rollout
	on hasUVW do genMapCoords -- check for wether the object has UV coords, value stored in genMapCoords
	on setGenUVW bool do genMapCoords = bool -- check the coonection between checkBox and genMapCoords param
	on buildMesh do
	(
		setMesh mesh \
		verts:#([-widthR/2,0,0],[0,-lengthR/2,0],[widthR/2,0,0],[0,lengthR/2,0]) \
		faces:#([1,2,3],[1,3,4]) -- build base mesh object
		for i=1 to heightSegs do extrudeFace mesh #(1,2) (heightR/heightSegs) scaleR dir:#common -- set prism height
		setNumFaces mesh (mesh.numFaces + 2) true -- increas number of faces
		setFace mesh (mesh.numFaces - 1) 1 2 3 -- cap first 1/2 of base hole
		setFace mesh mesh.numFaces 1 3 4 -- cap second 1/2 of base hole
	-- Followed code generates texture coordinates
	if genMapCoords then
		(
			--meshop.defaultmapfaces mesh 1
			/*setNumTVerts mesh (mesh.numFaces*2) -- define number T vertecies
			uvw_array = #([0,0,0], [1,0,0], [1,1,0], [0,1,0]) -- T vertecies UVW coordinates array
			for f=1 to mesh.numFaces*2 by 4 do (for v=1 to 4 do setTVert mesh (f+v-1) uvw_array[v])  -- set all T vertecies
			buildTVFaces mesh false -- build T faces array
			for i=1 to mesh.numFaces by 2 do (setTVFace mesh i [i*2-1,i*2,i*2+1]; setTVFace mesh (i+1) [i*2+1,i*2+2,i*2-1]) -- set all T faces
			setTVFace mesh 2 [1,3,4] -- fix 2 face
			setTVFace mesh mesh.numFaces [mesh.numTVerts-3,mesh.numTVerts-1,mesh.numTVerts] -- fix last face
			update mesh  -- */
		)
	--else if meshop.getMapSupport mesh 1 then meshop.freeMapChannel mesh 1
		-- end of coordinates*/
	) -- end on buildMesh
	tool create
	(
		on mousePoint click do
			case click of
			(
				1: nodeTM.translation = gridPoint
				3: #stop
			)
		on mouseMove click do
			case click of
			(
				2: (widthR = abs(gridDist.x); lengthR = abs(gridDist.y))
				3: heightR = gridDist.z
			)
	)
)