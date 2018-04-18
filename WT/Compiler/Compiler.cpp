//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("Compiler.res");
USEFORM("Main.cpp", Form1);
USEUNIT("boolmatr.cpp");
USEUNIT("gener.cpp");
USEUNIT("getgramm.cpp");
USEUNIT("gramm.cpp");
USEUNIT("lexan.cpp");
USEUNIT("lexem.cpp");
USEUNIT("pascal.cpp");
USEUNIT("sstack.cpp");
USEFILE("ustack.h");
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TForm1), &Form1);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
