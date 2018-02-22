-- Konstantin Leontev
-- kleontev.ru
-- 2018
plugin simpleObject tile_stacker
name: "TileStacker"
classID:#(0x16d2cd0e, 0x2e5173c7)
version: 1
category:"Tiles"
(
	parameters main rollout: params
	(
		tileWidth type:#worldUnits ui:tileWidth default: 100
		tileLength type:#worldUnits ui:tileLength default: 100
		tileDepth type:#worldUnits ui:tileDepth default: 2
		tilingX type:#integer ui:tilingX default: 10
		tilingY type:#integer ui:tilingY default: 10
		grout type:#boolean ui:grout default: false
		groutWidth type:#worldUnits ui:groutWidth default: 1
		groutDepth type:#worldUnits ui:groutDepth default: 1
		numOfMaterials type:#integer ui:numOfMaterials default: 2
		randomMatId type:#boolean ui:randomMatId default: true animatable:false
		randomRotate type:#boolean ui:randomRotate default: false animatable:false
		genMapCoords type:#boolean ui:genMapCoords default:false animatable:false		
	)
	rollout params "Tile Stacker"
	(
		group "Tiles"
		(
			spinner tileWidth "Tile Width" range: [0, 10000, 0]
			spinner tileLength "Tile Length:" range: [0, 10000, 0]
			spinner tileDepth "Tile Depth" range: [0, 10000, 0]
			spinner tilingX "Tiling along X" range: [0, 10000, 0]
			spinner tilingY "Tiling along Y" range: [0, 10000, 0]
		)
		group "Grouts"
		(
			checkbox grout "Grout"
			spinner groutWidth "Grout width" range: [0, 10000, 0]
			spinner groutDepth "GroutDepth" range: [0, 10000, 0]
		)
		group "Materials"
		(
			spinner numOfMaterials "Num. Materials" type:#integer range: [1, 100, 0]
			checkBox randomMatId "Random Mat IDs"
			checkBox randomRotate "Random Rotate Tiles"
			checkBox genMapCoords "Generate Mapping Coords."
		)
	)
	
	-- check if object has UV coordinates
	on hasUVW do genMapCoords
		
	-- handler checks the checkbutton connected to genMapCoords
	on setGenUVW bool do genMapCoords = bool
		
	--struct matProperties (id, colorById)
	
	fn setColor =
	(
		-- create arrey for colors
		colorArr = #()
		colorArr.count = numOfMaterials
		-- last id is always for grout
		for i = 1 to numOfMaterials do
		(
			-- create pair for each material id
			colorArr[i] = DataPair id:i color:(random black white)
		)
		-- return array with IDs and colors
		colorArr
	)
	
	fn setRotateAngles =
	(
		local rotateAngles = #()
		rotateAngles.count = 4
		for i = 1 to 4 do
		(
			rotateAngles[i] = eulerAngles 0 0 ((i - 1) * 90)
		)
		rotateAngles
	)
	
	fn setRotatedTiles &tileMesh &colorArr &tilesArr =
	(
			-- get rotate angles
			local rotateAngles = setRotateAngles()
			-- set number of rotated tiles
			tilesArr.count = 4
			-- collect all rotated tiles
			for i = 1 to 4 do
			(
				-- set a copy of tileMesh to temp mesh
				local tileTemp = copy tileMesh
				-- rotate this member
				rotate tileTemp rotateAngles[i]
				-- if angle is not zero - move the tile to compensate that
				case i of
				(
					-- rotate 90 deg
					2: move tileTemp [tileWidth, 0, 0]
					-- rotate 180 deg
					3: move tileTemp [tileWidth, tileLength, 0]
					-- rotate 270 deg
					4: move tileTemp [0, tileLength, 0]
				)
				-- set rotated temp mesh to array
				tilesArr[i] = tileTemp
			)
	)
	
	fn createTiles =
	(
		-- create empty mesh object
		local tileMesh = TriMesh()
		-- setup tile as a plane
		SetMesh tileMesh length:tileLength width:tileWidth lengthsegs:1 widthsegs:1
		-- extrude all 2 faces on tileDepth amount up
		extrudeFace tileMesh #(1, 2) tileDepth 100
		-- get number of faces
		local numFaces = tileMesh.numfaces
		-- set UVW coordinates
		if genMapCoords then meshop.applyUVWMap tileMesh #face

		-- empty temp mesh for all tiles
		local temp = TriMesh()
		
		-- set and collect 4 rotated tiles 
		if (randomMatId == true) then
		(
			-- get the color array for random colors in viewport
			local colorArr = setColor()
			if (randomRotate == true) do
			(
				-- set up array for rotated tiles
				local tilesArr = #()
				-- and pass it to function to fill up with rotated tiles
				setRotatedTiles &tileMesh &colorArr &tilesArr
			)			
			
			-- copy tile mesh through the loop
			for i = 0 to tilingX do
			(
				for j = 0 to tilingY do
				(
					-- if rotate get one rotated tile from array
					if (randomRotate == true) then
					(
						mNew = copy tilesArr[random 1 4]
					)
					-- otherwise get from tileMesh
					else
					(
						mNew = copy tileMesh
					)					
					-- get random number for material ID settings
					randomId = random 1 numOfMaterials
					-- set this number to all faces
					for k = 1 to numFaces do setFaceMatId mNew k randomId
							
					-- set support for map channel
					meshop.setMapSupport mNew 0 true
					-- get the number of map faces
					numMapFaces = meshOp.getNumMapFaces mNew 0
					-- set color spcified for this id in colorArr
					for i = 1 to numMapFaces do meshop.setFaceColor mNew 0 i colorArr[randomID].color
					
					-- move tile to the next position
					move mNew [(tileWidth + groutWidth) * i, (tileLength + groutWidth) * j, 0]
					-- attach to temp mesh
					meshop.attach temp mNew
				)
			)
		)
		-- otherwise just get a tile from tileMesh
		else
		(
			-- set material id to 1
			for i = 1 to numFaces do setFaceMatId tileMesh i 1
			-- copy tile mesh through the loop
			for i = 0 to tilingX do
			(
				for j = 0 to tilingY do
				(		
					mNew = copy tileMesh
					-- move tile to the next position
					move mNew [(tileWidth + groutWidth) * i, (tileLength + groutWidth) * j, 0]
					-- attach to temp mesh
					meshop.attach temp mNew
				)
			)
		)
		-- return temp mesh
		temp
	)
	
	fn createGrout =
	(
		local groutMeshX = TriMesh()
		local groutMeshY = TriMesh()
		local groutMeshSquare = TriMesh()
		local temp = TriMesh()
		
		-- 3 meshes make L shape that will be reproduce through object in loop
		SetMesh groutMeshY length:tileLength width:groutWidth lengthsegs:1 widthsegs:1
		SetMesh groutMeshX length:groutWidth width:tileWidth lengthsegs:1 widthsegs:1
		SetMesh groutMeshSquare length:groutWidth width:groutWidth lengthsegs:1 widthsegs:1
		
		-- move grout to after 1st tile position
		move groutMeshX [0, tileLength, groutDepth]
		move groutMeshY [tileWidth, 0, groutDepth]
		move groutMeshSquare [tileWidth, tileLength, groutDepth]
		
		-- add material id
		if (randomMatId == true) then local groutId = (numOfMaterials + 1) else local groutId = 2
		for i = 1 to 2 do
		(
			setFaceMatId groutMeshX i groutId
			setFaceMatId groutMeshY i groutId
			setFaceMatId groutMeshSquare i groutId
		)
		
		-- set texture coordinates
		if (genMapCoords == true) then
		(
			meshop.applyUVWMap groutMeshX #face
			meshop.applyUVWMap groutMeshY #face
			meshop.applyUVWMap groutMeshSquare #face
		)	
		
		-- layout all grout parts
		for i = 0 to tilingX do
		(
			for j = 0 to tilingY do
			(
				mX = copy groutMeshX
				mY = copy groutMeshY
				mSq = copy groutMeshSquare
				-- move grout to the next position
				move mX [(tileWidth + groutWidth) * i, (tileLength + groutWidth) * j, 0]
				move mY [(tileWidth + groutWidth) * i, (tileLength + groutWidth) * j, 0]
				move mSq [(tileWidth + groutWidth) * i , (tileLength + groutWidth) * j, 0]
				-- attach to temp mesh
				meshop.attach temp mX
				meshop.attach temp mY
				meshop.attach temp mSq
			)
		)
		temp
	)
		
	on buildMesh do
	(
		mesh = createTiles()
		if (grout == true) then meshop.attach mesh (createGrout())
	)
	tool create
	(
		on mousePoint click do
			case click of
			(
				1: nodeTM.translation = gridPoint
				2: #stop
			)
	)
)