fn removeGaps =
(
	-- Get point3 array of out knots
	spl = $
	outKnotsArr = #()
	for i=1 to (numSplines spl) do
	(
		if isClosed spl i != true do
		(
			firstPoint = getKnotPoint spl i 1
			lastPoint = getKnotPoint spl i (numKnots spl i)
			append  outKnotsArr firstPoint
			append  outKnotsArr lastPoint
		)
	)
	--	format ">> outKnotsArr >>\n"
	--	print outKnotsArr
	-- Function to sort points Array
	fn distanceSort v1 v2 checkKnot: =
	(
		local d1 = distance checkKnot v1
		local d2 = distance checkKnot v2
		case of
		(
			(d1<d2) : -1
			(d1>d2) : 1
			default : 0
		)
	)
	-- Sort array
	sortKnotsArr = deepCopy outKnotsArr
	for i=1 to (sortKnotsArr.count-1) do qsort sortKnotsArr distanceSort start:(i+1) checkKnot:sortKnotsArr[i]
	--	format ">> sortKnotsArr >>\n"
	--	print sortKnotsArr
	-- Create new segments
	for i=1 to sortKnotsArr.count/2 by 1 do
	(
		addNewSpline spl
		addKnot spl (numSplines spl) #corner #line sortKnotsArr[i*2-1]
		addKnot spl (numSplines spl) #corner #line sortKnotsArr[i*2]
		updateShape spl
	)
	-- Weld all vertices
	subObjectLevel = 1
	max select all
	splineOps.weld $
	
)

