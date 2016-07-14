
-- Check open or close splines are
-- Get point3 of first and end knots of each open spline and add them to array
-- Check the distances between points and sort them
-- Connect points


-- Get point3 array of out knots
outKnotsArr = #()
for i=1 to (numSplines $) do
(
	if isClosed $ i != true do
	(
		tempArr = #()
		firstPoint = getKnotPoint $ i 1
		lastPoint = getKnotPoint $ i (numKnots $ i)
		append  tempArr firstPoint
		append  tempArr lastPoint
		append outKnotsArr tempArr		
	)
)
print outKnotsArr

-- The same as above in loop
resultKnotsArr = #()
for i=1 to (outKnotsArr.count) do
(
	tempArr = deepcopy outKnotsArr
	if i > 1 do (for d=i to 2 by -1 do append tempArr outKnotsArr[d-1])
	distArr = #()
	for a=1 to (outKnotsArr.count-1) do
	(
		d1 = distance tempArr[i][1] tempArr[i+a][1]
		d2 = distance tempArr[i][1] tempArr[i+a][2]
		if d1<d2 then
			(
				append distArr d1
				if (a==1 or d1<distArr[1]) then tempArr[i][2] = tempArr[i+a][1]
		    )
		else
			(
				append distArr d2
				if (a==1 or d2<distArr[1]) then tempArr[i][2] = tempArr[i+a][2]
			)
	)
	format ">> tempArr >>\n"
	print tempArr
	format "\n"
	append resultKnotsArr tempArr[i]
	format ">> resultKnotsArr >>\n"
	print resultKnotsArr
	format "\n"
)
print resultKnotsArr

-- Function to sort points Array
/*fn distanceSort v1 v2 startKnot =
(
	local d = distance startKnot v1
	local dd = distance startKnot v2
	case of
	(
		(d>dd) : -1
		(d<dd) : 1
		default : 0
	)
)
-- Sort array
/*resultKnotsArr = #()
tempArr = deepcopy outKnotsArr
qsort tempArr distanceSort startKnot:outKnotsArr[1][1]
append resultKnotsArr tempArr
*/

-- Create new segments
for i=1 to resultKnotsArr.count by 1 do
(
	addNewSpline $
	addKnot $ (numSplines $) #corner #line resultKnotsArr[i][1]
	addKnot $ (numSplines $) #corner #line resultKnotsArr[i][2]
	updateShape $
)