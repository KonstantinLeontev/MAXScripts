wW = 900.0 -- window width
wH = 2500.0 -- window height
tH = 50.0 -- transom height
fW = 30.0 -- frame width
segm = 150 -- number of segments

radius1 = ((wW/2)^2 + tH^2)/(2*tH) -- outer radius from Pythagorean theorem
radius2 = radius1 - fW -- inner radius

ang = asin(wW/(2*radius1)) -- half of central angle
startAng = 90-ang -- start angle
stopAng = 90+ang -- end angle
stepAng = 2*ang/segm -- step angle for each segment

vert_array = #()
face_array = #()
zStart = undefined
	
for a=startAng to stopAng+0.1 by stepAng do -- add 0.1 to compensate round float value
(
		x1 = radius2*cos(a)
		z1 = radius2*sin(a)
		x2 = radius1*cos(a)
		z2 = radius1*sin(a)
		if zStart == undefined then zStart = z1+(fW-(x2-x1))*tan(90-startAng) -- base height for first and last inner vertex
	if a==startAng then -- inner vertex
	(
		v1 = [x2-fW, 0, zStart]
	) else
	if ((stopAng-a)<0.1) then
	(
		v1 = [x2+fW, 0, zStart]
	) else
	if (z1 > zStart) then v1 = [x1, 0, z1] else continue
	v2 = [x2, 0, z2] -- outer vertex
	--format "vert 1 = %,vert 2 = %, stepAng = % and a = %, then next must be as % when stop is %\n" v1 v2 stepAng  a (a+stepAng) stopAng
	append vert_array v1
	append vert_array v2
)
-- extra left and right verttices
append vert_array [radius1*cos(startAng), 0, zStart] -- right vertex
append vert_array [radius1*cos(stopAng), 0, zStart] -- left vertex

-- build faces
num = vert_array.count
for i=1 to num/2-2 do join face_array #([i*2-1, i*2+1, i*2+2],[i*2-1, i*2+2, i*2])    -- #([1,3,4],[1,4,2])
-- extra faces
join face_array #([1, 2, num-1],[num-3, num, num-2])

m = mesh vertices:vert_array faces:face_array

/*
fn createMesh = 
(
	local arcMesh = editable_mesh
	arcMesh = mesh vertices:vert_array faces:face_array
)

createMesh()