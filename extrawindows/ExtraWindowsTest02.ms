plugin simpleObject SimpleWindow
name:"SimpleWindow"
classID:#(0x7f83d37d, 0x27969a54)
category:"Windows"
(
	local Box1, Box2, Box3
	parameters main rollout:params
	(
		wW type:#float ui:windowWidthSpn default:1000
		wL type:#float ui:windowLengthSpn default:1500
		fW type:#float ui:frameWidthSpn default:50
		gL type:#float ui:glazingSpn default:10
	)
	rollout params "SimpleWindow"
	(
		spinner windowWidthSpn "Window Width" range:[1, 10000, 0]
		spinner windowLengthSpn "Window Length" range:[1, 10000, 0]
		spinner frameWidthSpn "Frame Width" range:[1, 10000, 0]
		spinner glazingSpn "Glazing" range:[0,10000,0]
	)
		
	on buildMesh do
	(
		if box1 == udefined do
		(
			box1 = createInstance box
			box2 = createInstance box
			box3 = createInstance box
		)
		box1.length=wL; box1.width=wW; box1.height=fW
		box2.length=(wL-fW*2); box2.width=(wW-fW*2); box2.height=fW
		box3.length=(wL-fW*2); box3.width=(wW-fW*2); box3.height=gL
		--meshop.moveVert box3.mesh #{1..8} [0,0,-fW]
		mesh = (box1.mesh - box2.mesh) + box3.mesh
	) -- end build mesh
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
			1: nodeTM.translation = gridPoint
			3: #stop
			)
		)
		on mouseMove click do
			case click of
			(
			2:	(wW = abs(gridDist.x); wL = abs(gridDist.y))
			3: fW = abs(gridDist.z)
			)
	) -- end create
) -- end plugin
