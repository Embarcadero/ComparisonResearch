**Created in Delphi using RAD Studio 10.4.1**

# Windows 10 Calculator Clone - Delphi Instructions

## Setup
1. Open RAD Studio.  Click File->New->Multi-Device Application - Delphi and select "Blank Application".
2. Press Cntl+Shift+S to save all files.  Save the .pas file as *"fCalcMain"* and the project as *"Calculator"*.

## Visual Interface

You'll have this software after following the instructions. Of course you are free to choose the colors you prefer.

![](doc-img/calculator.png)

Use the structure panel to verify the components are at the good place.

![](doc-img/struct-frmCalcMain.png)

On the main form:
1. add a TLayout and change it's properties :
	1. "Name" => "lBackground"
	2. "Align" => "client"
2. add a TStyleBook

![](doc-img/struct-lBackground.png)

On the lBaground layout:
1. add a TRectangle and change it's properties :
	1. "Name" => "rDisplay"
	2. "Fill.Color" => "Peru" or the color you wants for the top parts of the screen where equation and result will be displayed.
	3. "Align" => "top"
	4. "Height" => 100
	5. "Padding" => 10 pixels for the 4 subproperties
2. add a TGridPanelLayout and change it's properties :
	1. "Name" => "gplButtons"
	2. "Align" => "Client"
	3. Save the file (Ctrl+S)
	4. Press Alt+F12 to enter the source of the form
	5. Localize the "ColumnCollection" part under "gplButtons". Copy "item" bloc to have it 4 times and change their "Value" to "25.000000000000000000" (the number of 0 and indentation are important).
	6. Press Alt+F12, the grid must now have 4 columns.
	7. Save the file (Ctrl+S)
	8. Press Alt+F12 to enter the source of the form
	9. Localize the "RowCollection" part under "gplButtons". Copy "item" bloc to have it 6 times and change their "Value" to "16.666666666666660000" (the number of 0 and indentation are important).
	10. Press Alt+F12, the grid must now have 4 columns and 6 rows.
	11. Save the file (Ctrl+S)
	
![](doc-img/struct-grid-cells.png)

You could use the "add element" in the popup menu directly from the structure panel, but the size must be changed in the form source directly.

