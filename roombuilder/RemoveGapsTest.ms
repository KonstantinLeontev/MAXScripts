
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
-- Scheme for sorting Array
/*
tempArr = deepcopy outKnotsArr
if distance tempArr[1][1] tempArr[2][1] > distance tempArr[1][1] tempArr[2][2]
then tempArr[1][2] = tempArr[2][2]
else tempArr[1][2] = tempArr[2][1]
*/
-- The same as above in loop
resultKnotsArr = #()
for i=1 to (outKnotsArr.count-1) do
(
	tempArr = deepcopy outKnotsArr
	distArr = #()
	for a=1 to (outKnotsArr.count-1) do
	(
		d1 = distance tempArr[i][1] tempArr[a+1][1]
		d2 = distance tempArr[i][1] tempArr[a+1][2]
/*		d3 = distance tempArr[i][2] tempArr[a+1][1]
		d4 = distance tempArr[i][2] tempArr[a+1][2]*/
		--temp = #()
		if d1<d2 then
			(
				append distArr d1
				if a==1 then
					(
						temp = tempArr[i][2]
						tempArr[i][2] = tempArr[a+1][1]
						tempArr[a+1][1] = temp
					)
				else if d1<distArr[1] then
					(
						temp = tempArr[i][2]
						tempArr[i][2] = tempArr[a+1][1]
						tempArr[a+1][1] = temp
					)
		    ) else
			(
				append distArr d2
				if a==1 then
					(
						temp = tempArr[i][2]
						tempArr[i][2] = tempArr[a+1][2]
						tempArr[a+1][2] = temp
					)
				else if d2<distArr[1] then
					(
						temp = tempArr[i][2]
						tempArr[i][2] = tempArr[a+1][2]
						tempArr[a+1][2] = temp
					)
			)
/*		if d3<d4 then
			(
				append temp d3
				if a==1 then tempArr[i][1] = tempArr[a+1][2] else
						if d3<distArr[1][2] then tempArr[i][1] = tempArr[a+1][2]
		    ) else
			(
				append temp d4
				if a==1 then tempArr[i][1] = tempArr[a+1][1] else
					if d4<distArr[1][2] then tempArr[i][1] = tempArr[a+1][1]
			)*/
			--append distArr temp
	)
	append resultKnotsArr tempArr[i]
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
-- Check the distances between knots
distanceArr = #()
for i=1 to (outKnotsArr.count-1) where (i != 2) do
(
	temp = distance outKnotsArr[i] outKnotsArr[i+1]
	append distanceArr temp
)
print distanceArr
sort distanceArr
	
/*for i=1 to (outKnotsArr.count-2) do
(
	for a=(i+2) to (outKnotsArr.count-1) do
	(
		if (distance outKnotsArr[i] outKnotsArr[a]) > (distance outKnotsArr[i] outKnotsArr[a+1]) do
		(
			temp = outKnotsArr[a]
			outKnotsArr[a] = outKnotsArr[a+1]
			outKnotsArr[a+1] = temp
		)
	)
)*/

-- Create new segments
for i=1 to resultKnotsArr.count by 1 do
(
	addNewSpline $
	addKnot $ (numSplines $) #corner #line resultKnotsArr[i][1]
	addKnot $ (numSplines $) #corner #line resultKnotsArr[i][2]
	updateShape $
)