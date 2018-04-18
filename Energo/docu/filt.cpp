//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "filt.h"
#include "docu.h"
#include "docu_mod.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFilter *Filter;
//---------------------------------------------------------------------------
__fastcall TFilter::TFilter(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TFilter::Button2Click(TObject *Sender)
{
Filter->Close();        
}
//---------------------------------------------------------------------------

void __fastcall TFilter::FormClose(TObject *Sender, TCloseAction &Action)
{
Main_doc->Enabled=true;
 TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TFilter::Button1Click(TObject *Sender)
{
//AnsiString par="",val="",oper="";
int fl=0;
try
{
Module2DB->Query_grp->Sql->Clear();
//ShowMessage("select * from dci_document_tbl where id_grp=1 and "+Memo1->Text);
Module2DB->Query_grp->Sql->Add("select * from dci_document_tbl where id_grp=1 and "+Memo1->Text);
Module2DB->Query_grp->ExecSql();
Module2DB->Query_grp->Active=true;
fl=1;
}
__except(1) {ShowMessage("Ошибка синтаксиса");}

if (fl==1)
 {
 Main_doc->filt_str=" and "+Memo1->Text;
 Filter->Close();
 AnsiString cap=Main_doc->Caption;
 Main_doc->Caption=cap+"| включен фильтр";

int ptr=Main_doc->GetIndex("Группы документов",Main_doc->GroupTree);
Main_doc->GroupTree->Items->Item[ptr]->Selected=true;
 }
}
//---------------------------------------------------------------------------
void __fastcall TFilter::Click(TObject *Sender)
{
TButton* but = (TButton*) Sender;

int pos = Memo1->SelStart+1;
AnsiString text=but->Caption;
pos+=text.Length();


//Text->Lines->Add(but->Caption);
AnsiString str=Memo1->Text;
Memo1->Text=str+text;
Memo1->SelStart=pos-1;
}
//---------------------------------------------------------------------------

void __fastcall TFilter::FormActivate(TObject *Sender)
{
Memo1->Clear();
}
//---------------------------------------------------------------------------

void __fastcall TFilter::SpeedButton11Click(TObject *Sender)
{
int id=ListParam->ItemIndex;
AnsiString str=ListParam->Items->Strings[id];


 if (str=="Наименование")
  {
  int pos = Memo1->SelStart+1;
  AnsiString text="name ";
  pos+=text.Length();

  AnsiString tmp=Memo1->Text;
  Memo1->Text=tmp+text;
  Memo1->SelStart=pos-1;
  }

 if (str=="Дата создания")
  {
  int pos = Memo1->SelStart+1;
  AnsiString text="reg_date ";
  pos+=text.Length();

  AnsiString tmp=Memo1->Text;
  Memo1->Text=tmp+text;
  Memo1->SelStart=pos-1;
  }

}
//---------------------------------------------------------------------------

