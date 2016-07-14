wW = 1000 -- window width
fW = 50 -- frame width
fD = 50 -- frame depth
seg = 18 -- number of segments

a = wW/2 -- x coord for circle centre
b = wW/2 -- z coord for circle centre
radOut = wW/2 -- outer radius
radIn = wW/2 - fW -- inner radius
ang = 360/seg -- angle for 1 segment

-- building vertecies
vert_array = #()
for i=1 to 2 do -- for front and back vertices
(
	for j=1 to seg do -- inner vertices
	(
		join vert_array #([a + radIn*cos(ang*j), fD*i - fD, b + radIn*sin(ang*j)]\
				[a + radOut*cos(ang*j), fD*i - fD, b + radOut*sin(ang*j)])		-- vertecies 1 - inner, 2 - outer
	)
)
face_array = #()
for i=1 to segm-1 do -- for 1, 2 faces row, exclude last couple
(	
	join face_array #([i*2-1, i*2+1, i*2+2], [i*2-1, i*2+2, i*2] -- faces [1,3,4] and [1,4,2] ... 
)
join face_array #([


