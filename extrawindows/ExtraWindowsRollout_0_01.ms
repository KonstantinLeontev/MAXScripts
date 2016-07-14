rollout extraWindows "Extra Windows" width:162 height:632
(
	groupBox 'grpSize' "Size" pos:[3,48] width:155 height:162 align:#left
	dropDownList 'ddlChooseWindowType' "Window Type" pos:[6,5] width:149 height:40 items:#(Rectangular, ArcTop, Round, Poly, Custom) selection:1 align:#left
	groupBox 'grpFrame' "Frame" pos:[3,254] width:155 height:92 align:#left
	groupBox 'grpGlazing' "Glazing" pos:[3,353] width:155 height:44 align:#left
	spinner 'spnHeight' "" pos:[78,70] width:77 height:16 range:???? align:#left
	spinner 'spnWidth' "" pos:[78,93] width:77 height:16 range:???? align:#left
	spinner 'spnDepth' "" pos:[78,116] width:77 height:16 range:???? align:#left
	spinner 'spnArcHeight' "" pos:[78,139] width:77 height:16 range:???? align:#left
	label 'lblHeight' "Height:" pos:[12,71] width:55 height:16 align:#left
	label 'lblWidth' "Width:" pos:[12,94] width:55 height:16 align:#left
	label 'lblDepth' "Depth:" pos:[12,117] width:55 height:16 align:#left
	label 'lblArcHeight' "Arc Height:" pos:[12,140] width:55 height:16 align:#left
	pickButton 'btnPickShape' "Pick Custom Shape" pos:[3,216] width:155 height:31 align:#left
	spinner 'spnRadius' "" pos:[78,162] width:77 height:16 range:???? align:#left
	label 'lblRadius' "Radius:" pos:[12,163] width:55 height:16 align:#left
	spinner 'spnSides' "" pos:[78,185] width:77 height:16 range:???? align:#left
	label 'lblSides' "Sides:" pos:[12,186] width:55 height:16 align:#left
	spinner 'spnHorizWidth' "" pos:[78,273] width:77 height:16 range:???? align:#left
	label 'lblHorizWidth' "Horiz. Width:" pos:[9,273] width:65 height:16 align:#left
	spinner 'spnVertWidth' "" pos:[78,297] width:77 height:16 range:???? align:#left
	label 'lblVertWidth' "Vert. Width:" pos:[9,297] width:65 height:16 align:#left
	spinner 'spnFrameThickness' "" pos:[78,321] width:77 height:16 range:???? align:#left
	label 'lblFrameThickness' "Thickness:" pos:[9,321] width:65 height:16 align:#left
	spinner 'spnGlazingThickness' "" pos:[78,372] width:77 height:16 range:???? align:#left
	label 'lblGlazingThickness' "Thickness:" pos:[9,372] width:65 height:16 align:#left
	groupBox 'grpCasements' "Casements" pos:[3,404] width:155 height:66 align:#left
	spinner 'spnPanelWidth' "" pos:[78,423] width:77 height:16 range:???? align:#left
	label 'lblPanelWidth' "Panel Width:" pos:[9,423] width:65 height:16 align:#left
	spinner 'spnPanelsNumber' "" pos:[98,447] width:57 height:16 range:???? type:#integer scale:1 align:#left
	label 'lblPanelsNumber' "Panels Number:" pos:[9,447] width:80 height:16 align:#left
	groupBox 'grpSill' "Sill" pos:[3,477] width:155 height:66 align:#left
	spinner 'spnSillDepth' "" pos:[78,496] width:77 height:16 range:???? align:#left
	label 'lblSillDepth' "Sill Depth:" pos:[9,496] width:65 height:16 align:#left
	spinner 'spnSillThickness' "" pos:[78,519] width:77 height:16 range:???? align:#left
	label 'lblSillThickness' "Thickness:" pos:[9,519] width:65 height:16 align:#left
	groupBox 'grpBoard' "Board" pos:[3,550] width:155 height:66 align:#left
	spinner 'spnBoardDepth' "" pos:[78,569] width:77 height:16 range:???? align:#left
	label 'lblBoardDepth' "Board Depth:" pos:[9,569] width:65 height:16 align:#left
	spinner 'spnBoardThickness' "" pos:[78,592] width:77 height:16 range:???? align:#left
	label 'lblBoardThickness' "Thickness:" pos:[9,592] width:65 height:16 align:#left
	on ddlChooseWindowType selected sel do
(
	
	)
	on spnHeight changed val do
(
	
	)
	on spnHeight entered text do
(
	
	)
	on spnWidth changed val do
(
	
	)
	on spnWidth entered text do
(
	
	)
	on spnDepth changed val do
(
	
	)
	on spnDepth entered text do
(
	
	)
	on spnArcHeight changed val do
(
	
	)
	on spnArcHeight entered text do
(
	
	)
	on spnRadius changed val do
(
	
	)
	on spnRadius entered text do
(
	
	)
	on spnSides changed val do
(
	
	)
	on spnSides entered text do
(
	
	)
	on spnHorizWidth changed val do
(
	
	)
	on spnHorizWidth entered text do
(
	
	)
	on spnVertWidth changed val do
(
	
	)
	on spnVertWidth entered text do
(
	
	)
	on spnFrameThickness changed val do
(
	
	)
	on spnFrameThickness entered text do
(
	
	)
	on spnGlazingThickness changed val do
(
	
	)
	on spnGlazingThickness entered text do
(
	
	)
	on spnPanelWidth changed val do
(
	
	)
	on spnPanelWidth entered text do
(
	
	)
	on spnPanelsNumber changed val do
(
	
	)
	on spnPanelsNumber entered text do
(
	
	)
	on spnSillDepth changed val do
(
	
	)
	on spnSillDepth entered text do
(
	
	)
	on spnSillThickness changed val do
(
	
	)
	on spnSillThickness entered text do
(
	
	)
	on spnBoardDepth changed val do
(
	
	)
	on spnBoardDepth entered text do
(
	
	)
	on spnBoardThickness changed val do
(
	
	)
	on spnBoardThickness entered text do
(
	
	)
)