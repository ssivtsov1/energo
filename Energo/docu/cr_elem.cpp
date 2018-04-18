//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "cr_elem.h"
#include "doc_tmp.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TCreateForm *CreateForm;
int id_type,insert,id_head,data_type;
AnsiString name_elem;
//---------------------------------------------------------------------------
__fastcall TCreateForm::TCreateForm(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TCreateForm::SpeedButton2Click(TObject *Sender)
{
CreateForm->Close();
}
//---------------------------------------------------------------------------
void __fastcall TCreateForm::FormActivate(TObject *Sender)
{
insert=0;
id_head=0;
data_type=0;
 Panel3->Visible=false;

TypeList->Items->Clear();
id_type=0;

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dck_template_tbl where description is not null");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

Module2DB->QueryExec->First();
for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
TypeList->Items->Add(Module2DB->QueryExec->FieldByName("description")->AsString);
Module2DB->QueryExec->Next();
}

  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from syi_type_tbl");
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;

  Module2DB->QueryExec->First();
        for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
        ComboBox1->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
        Module2DB->QueryExec->Next();
        }

  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from dci_head_tbl");
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;

  Module2DB->QueryExec->First();
        for (int i=0;i<Module2DB->QueryExec->RecordCount;i++) {
        ComboBox2->Items->Add(Module2DB->QueryExec->FieldByName("name")->AsString);
        Module2DB->QueryExec->Next();
        }

}
//---------------------------------------------------------------------------
void __fastcall TCreateForm::FormClose(TObject *Sender,
      TCloseAction &Action)
{
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TCreateForm::TypeListChange(TObject *Sender)
{
Panel2->Visible=true;

Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dck_template_tbl where description='"+TypeList->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

id_type=Module2DB->QueryExec->FieldByName("id")->AsInteger;

if (TypeList->Text=="Поле для ввода")
{
 Panel3->Visible=true;
// Label3->Visible=true;
// Edit2->Visible=true;
}
else
{
 Panel3->Visible=false;
 insert=1;

 if (TypeList->Text=="Заголовок")
 {
  Module2DB->QueryExec->Sql->Clear();
  Module2DB->QueryExec->Sql->Add("select * from dcm_template_tbl where id_document="+IntToStr(id_doc)+" and idk_template=12");
  Module2DB->QueryExec->ExecSql();
  Module2DB->QueryExec->Active=true;

  if (Module2DB->QueryExec->RecordCount>0)
  { ShowMessage("Документ уже имеет заголовок"); TypeList->Text=""; insert=0;}
  else
  {
  Panel2->Visible=false;
  Edit1->Text="Заголовок";
  }
 }

}
}
//---------------------------------------------------------------------------
void __fastcall TCreateForm::SpeedButton1Click(TObject *Sender)
{
//ShowMessage("select create_elem("+IntToStr(id_parent)+","+IntToStr(id_doc)+","+IntToStr(id_type)+","+IntToStr(num)+",'"+Edit1->Text+"')");
AnsiString head="";
AnsiString type="";

//проверяем, установлена ли переменная или нет
if (id_head==0)
{head="null";}
else
{head=IntToStr(id_head);}

//проверяем, установлена ли переменная или нет
if (data_type==0)
{type="null";}
else
{type=IntToStr(data_type);}

//добавляем элемент
Module2DB->QueryExec->Sql->Clear();
if (TypeList->Text=="Поле для ввода")
{
Module2DB->QueryExec->Sql->Add("select create_elem("+IntToStr(id_parent)+","+IntToStr(id_doc)+","+IntToStr(id_type)+","+IntToStr(num)+",'"+Module2DB->MainDB->Login+"',"+head+","+type+")");
Module2DB->QueryExec->ExecSql();
}
else
{
  if (insert==1)
  {
        if (id_type==12)
        {
        id_parent=0;num=0;
        Module2DB->QueryExec->Sql->Clear();
        Module2DB->QueryExec->Sql->Add("update dcm_template_tbl set num=num+1 where id_document="+IntToStr(id_doc)+" and id_parent is null and num>0;");
        Module2DB->QueryExec->ExecSql();
        }
   Module2DB->QueryExec->Sql->Clear();
                      ShowMessage("select create_elem("+IntToStr(id_parent)+","+IntToStr(id_doc)+","+IntToStr(id_type)+","+IntToStr(num)+",'"+Edit1->Text+"',"+head+","+type+")");
   Module2DB->QueryExec->Sql->Add("select create_elem("+IntToStr(id_parent)+","+IntToStr(id_doc)+","+IntToStr(id_type)+","+IntToStr(num)+",'"+Edit1->Text+"',"+head+","+type+")");
   Module2DB->QueryExec->ExecSql();
  }
  else {ShowMessage("Элемент не добавлен");}
}//of else

if (TypeList->Text=="Поле для ввода")
{
 AnsiString prp="";
 if (Edit2->Text!="") {prp+="length="+Edit2->Text;}

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("update dcm_template_tbl set prop='"+prp+"' where name='"+Module2DB->MainDB->Login+"'");
 Module2DB->QueryExec->ExecSql();

 Module2DB->QueryExec->Sql->Clear();
 Module2DB->QueryExec->Sql->Add("update dcm_template_tbl set name='"+Edit1->Text+"' where name='"+Module2DB->MainDB->Login+"'");
 Module2DB->QueryExec->ExecSql();
 insert=1;
}
        if (insert==1)
        {
        ShowMessage("Элемент создан");
        Doc_temp->Refresh();
        CreateForm->Close();
        }
}
//---------------------------------------------------------------------------
void __fastcall TCreateForm::ComboBox2Change(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from dci_head_tbl where name='"+ComboBox2->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

id_head=Module2DB->QueryExec->FieldByName("id")->AsInteger;
ShowMessage(IntToStr(id_head));
}
//---------------------------------------------------------------------------

void __fastcall TCreateForm::ComboBox1Change(TObject *Sender)
{
Module2DB->QueryExec->Sql->Clear();
Module2DB->QueryExec->Sql->Add("select * from syi_type_tbl where name='"+ComboBox1->Text+"'");
Module2DB->QueryExec->ExecSql();
Module2DB->QueryExec->Active=true;

data_type=Module2DB->QueryExec->FieldByName("id")->AsInteger;

}
//---------------------------------------------------------------------------


