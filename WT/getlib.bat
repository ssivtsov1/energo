cd Lib
del VMachine.lib
del WTGrids.lib
cd ..
cd ..
cd CellGrid
tlib WTGrids.lib /C /P1024 +WTGrids.obj
cd ..
cd WT
copy ..\CellGrid\WTGrids.lib lib\*.*
copy ..\CellGrid\lib\vmachine.lib lib\*.*
del ..\CellGrid\WTGrids.lib
copy ..\CellGrid\include\*.h include\*.h

copy ..\CellGrid\*.h include\*.h

copy ..\CellGrid\pascal.kgc *.*

copy ..\CellGrid\Classes\grids.cch Classes\*.*
