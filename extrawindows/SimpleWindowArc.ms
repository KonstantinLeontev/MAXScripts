wW = 900.0 -- window width
wH = 2500.0 -- window height
tH = 150.0 -- transom height
fW = 30.0 -- frame width
segm = 8 -- number of segments

radius1 = ((wW/2)^2 + tH^2)/(2*tH) -- outer radius from Pythagorean theorem
radius2 = radius1 - fW -- inner radius

ang = asin(wW/(2*radius1)) -- half of central angle
startAng = 90-ang -- start angle
stopAng = 90+ang -- end angle
stepAng = 2*ang/segm -- step angle for each segment

--radius1 = 450
--radius2 = 500	

vert_array = #()
face_array = #()

for a=startAng to stopAng+0.1 by stepAng do -- add 0.1 to compensate round float value
(
	--if a==startAng then v1 = [radius1*cos(a)-fW, 0, radius1*sin(a)] else-- to make horizontal first edge-- to make horizontal last edge
	--if a==stopAng then v1 = [radius1*cos(a)+fW, 0, radius1*sin(a)] else
	v1 = [radius2*cos(a), 0, radius2*sin(a)] -- inner vertex
	v2 = [radius1*cos(a), 0, radius1*sin(a)] -- outer vertex	
	format "vert 1 = %,vert 2 = %, stepAng = % and a = %, then next must be as % when stop is %\n" v1 v2 stepAng  a (a+stepAng) stopAng
	append vert_array v1
	append vert_array v2
)
-- extra verttices
append vert_array [radius1*cos(startAng), 0, radius2*sin(startAng)] -- right vertex
append vert_array [radius1*cos(stopAng), 0, radius2*sin(stopAng)] -- left vertex

-- build faces
for i=1 to segm do join face_array #([i*2-1, i*2+1, i*2+2],[i*2-1, i*2+2, i*2])    -- #([1,3,4],[1,4,2])
-- extra faces
num = vert_array.count
join face_array #([1, 2, num-1],[num-3, num, num-2])

m = mesh vertices:vert_array faces:face_array

/*
fn createMesh = 
(
	local arcMesh = editable_mesh
	arcMesh = mesh vertices:vert_array faces:face_array
)

createMesh()