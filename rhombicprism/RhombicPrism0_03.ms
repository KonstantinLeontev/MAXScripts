-- RhombicPrism 0.03
-- Konstantin Leontev, 2016
-- My blog - kleontev.ru (rus)
-- Script makes simple room.
plugin simpleObject RhombicPrism
name:"RhombicPrism"
classID:#(0x7bf53528, 0x24d72cd7)
category:"Extended Primitives"
(
	parameters main rollout:params
	(
		w type:#float ui:widthSpn default:100
		len type:#float ui:lengthSpn default:150
		h type:#float ui:heightSpn default:200
		sc type:#float ui:scaleSpn default:100
		segm type:#integer ui:heightSegsSpn default:1
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
		local vertex_array = #() -- create empty vertex array
		join vertex_array #([-w/2,0,0],[0,-len/2,0],[w/2,0,0],[0,len/2,0]) -- create base vertecies
		for i=1 to segm do -- create all other vertecies
			join vertex_array #([-(w/2-(w/2-w*sc/200)*i/segm), 0, h*i/segm],\
										[0, -(len/2-(len/2-len*sc/200)*i/segm), h*i/segm],\
										[(w/2-(w/2-w*sc/200)*i/segm), 0, h*i/segm],\
										[0, (len/2-(len/2-len*sc/200)*i/segm), h*i/segm])
		local faces_array = #() -- create empty faces array
		join faces_array #([3,2,1],[3,1,4]) -- create 1st and 2nd faces
		for i=1 to segm*2 by 2 do
			(
				for a=1 to 3 do join faces_array #([i*2+a-2, i*2+a-1, i*2+a+3],[i*2+a-2, i*2+a+3, i*2+a+2]) -- build 3 side polygons
				join faces_array #([i*2+2, i*2-1, i*2+3],[i*2+2, i*2+3, i*2+6]) -- 4th side polygon
			)
		join faces_array #([segm*4+1, segm*4+2, segm*4+3],[segm*4+1, segm*4+3, segm*4+4]) -- cap faces
		setMesh mesh vertices:vertex_array faces:faces_array -- build mesh
		meshop.autoSmooth mesh #{1..faces_array.count} 0.0 -- remove smooth
		for i=1 to mesh.numFaces do setEdgeVis mesh i 1 false -- set edge 1 in each face as invisible
		for i=1 to mesh.numFaces do setEdgeVis mesh i 3 false -- set edge 3 in each face as invisible
	-- Followed code generates texture coordinates
	if genMapCoords then
		(
			--meshop.defaultmapfaces mesh 1
			setNumTVerts mesh (mesh.numFaces*2) -- define number T vertecies
			local uvw_array = #([0,0,0], [1,0,0], [1,1,0], [0,1,0]) -- T vertecies UVW coordinates array
			for f=1 to mesh.numTVerts by 4 do (for v=1 to 4 do setTVert mesh (f+v-1) uvw_array[v])  -- set all T vertecies
			buildTVFaces mesh false -- build T faces array
			for i=1 to mesh.numFaces by 2 do (setTVFace mesh i [i*2-1,i*2,i*2+1]; setTVFace mesh (i+1) [i*2+1,i*2-1,i*2+2]) -- set all T faces*/
		)
	else if meshop.getMapSupport mesh 1 then meshop.freeMapChannel mesh 1
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
				2: (w = abs(gridDist.x); len = abs(gridDist.y))
				3: h = gridDist.z
			)
	)
)