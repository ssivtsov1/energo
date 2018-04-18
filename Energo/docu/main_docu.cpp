//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("main_doc.res");
USEFORM("docu.cpp", Main_doc);
USEFORM("docu_mod.cpp", Module2DB); /* TDataModule: File Type */
USEFORM("doc_tmp.cpp", Doc_temp);
USEFORM("add_grp.cpp", Grp_add);
USEFORM("ins_grp.cpp", Grp_ins);
USEFORM("wait.cpp", wt);
USEFORM("prop1.cpp", Properties);
USEFORM("move.cpp", Mv);
USEFORM("findd.cpp", Find);
USEFORM("create_tab.cpp", CreateTab);
USEFORM("ins_doc.cpp", InsForm);
USEFORM("save_doc.cpp", SaveDoc);
USEFORM("cr_elem.cpp", CreateForm);
USEFORM("add_field.cpp", AddField);
USEFORM("findd_a.cpp", FindAdv);
USEFORM("filt.cpp", Filter);
USEFORM("Otch\sql.cpp", Generator);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
        try
        {
                 Application->Initialize();
                 Application->CreateForm(__classid(TModule2DB), &Module2DB);
                 Application->CreateForm(__classid(TMain_doc), &Main_doc);
                 Application->CreateForm(__classid(TDoc_temp), &Doc_temp);
                 Application->CreateForm(__classid(TGrp_add), &Grp_add);
                 Application->CreateForm(__classid(TGrp_ins), &Grp_ins);
                 Application->CreateForm(__classid(Twt), &wt);
                 Application->CreateForm(__classid(TProperties), &Properties);
                 Application->CreateForm(__classid(TMv), &Mv);
                 Application->CreateForm(__classid(TFind), &Find);
                 Application->CreateForm(__classid(TCreateTab), &CreateTab);
                 Application->CreateForm(__classid(TInsForm), &InsForm);
                 Application->CreateForm(__classid(TSaveDoc), &SaveDoc);
                 Application->CreateForm(__classid(TCreateForm), &CreateForm);
                 Application->CreateForm(__classid(TAddField), &AddField);
                 Application->CreateForm(__classid(TFindAdv), &FindAdv);
                 Application->CreateForm(__classid(TFilter), &Filter);
                 Application->CreateForm(__classid(TGenerator), &Generator);
                 Application->Run();
        }
        catch (Exception &exception)
        {
                 Application->ShowException(&exception);
        }
        return 0;
}
//---------------------------------------------------------------------------
