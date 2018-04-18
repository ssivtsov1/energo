del wt.lib
for %%i in (OBJ\*.obj) do tlib wt.lib /C /P1024 +%%i
tlib wt.lib /C /P1024 +VMachine.lib
rem tlib wt.lib /C /P1024 +wtgrids.lib
tlib wt.lib -main.obj -wt.obj -address.obj
