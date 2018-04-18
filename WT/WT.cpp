//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//USERC("tools.rc");
USEUNIT("Query.cpp");
USEUNIT("About.cpp");
USEUNIT("Edit.cpp");
USEUNIT("DBGrid.cpp");
USEUNIT("WinGrid.cpp");
USEUNIT("Form.cpp");
USEUNIT("List.cpp");
USEUNIT("MainForm.cpp");
USEUNIT("Message.cpp");
USEUNIT("SetQuery.cpp");
USEUNIT("SprGrid.cpp");
USEUNIT("FilterForm.cpp");
USEUNIT("SetWFForm.cpp");
USEUNIT("ReportView.cpp");
USEUNIT("MyThread.cpp");
USEUNIT("SetGrp.cpp");
USEUNIT("SelFields.cpp");
USEUNIT("Table.cpp");
USEUNIT("Defines.cpp");
USEUNIT("func.cpp");
USELIB("Lib\VMachine.lib");
USERES("tools.res");
USEUNIT("WTGrids.cpp");
USEFORM("TWTCompatable.cpp", fTWTCompForm);
USEUNIT("Common.cpp");
USEUNIT("Main.cpp");
USEUNIT("Address.cpp");
USEUNIT("AddrMain.cpp");
USEUNIT("FastSForm.cpp");
USEUNIT("ParamsForm.cpp");
//---------------------------------------------------------------------------
#include "Main.h"
//---------------------------------------------------------------------
// Указатель главную форму программы
TMainForm *MainForm;
//---------------------------------------------------------------------

//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
    Application->Initialize();
    Application->Title = "Отладочное приложение WinTools";
    Application->ShowHint = true;
    Application->CreateForm(__classid(TMainForm), &MainForm);
                 Application->Run();
  }
  catch (Exception &exception)
  {
     Application->ShowException(&exception);
  }
  return 0;
}
//---------------------------------------------------------------------------





