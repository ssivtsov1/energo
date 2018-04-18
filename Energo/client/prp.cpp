//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("prp.res");
USEFORM("prop.cpp", Client_par);
USEFORM("data.cpp", Base); /* TDataModule: File Type */
USEFORM("client_main.cpp", Client);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TClient), &Client);
                 Application->CreateForm(__classid(TClient_par), &Client_par);
                 Application->CreateForm(__classid(TBase), &Base);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
