//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "prop1.h"
#include "doc_tmp.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TProperties *Properties;
 typedef struct MList
 {
  int id_elem;
  int id_elem_parent;
  AnsiString teg;
  AnsiString value;
  AnsiString id_type;
  TImage *image;
  int level;
  int num;
  AnsiString name;
 } MaList;

typedef MaList* StrList;

//---------------------------------------------------------------------------
__fastcall TProperties::TProperties(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TProperties::FormCreate(TObject *Sender)
{
MainList = new TList;
}
//---------------------------------------------------------------------------
void __fastcall TProperties::Button1Click(TObject *Sender)
{
 Properties->Close();
}
//---------------------------------------------------------------------------
void __fastcall TProperties::FormClose(TObject *Sender,
      TCloseAction &Action)
{
Doc_temp->Enabled=true;
TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
AnsiString __fastcall TProperties::GetType(AnsiString teg)
{
AnsiString temp="Неопределенный тип";
 if (teg=="paragraph") temp="Параграф";
 if (teg=="text") temp="Текст";
 if (teg=="picture") temp="Рисунок";
return temp;
}
//---------------------------------------------------------------------------
void __fastcall TProperties::FormActivate(TObject *Sender)
{
Memo1->Clear();
StrList Struct;
for (int i=0;i<MainList->Count;i++)
 //прохождение по списку элементов, и нахожнение элементов с нужным уровнем - начало цикла
 {
 Struct = (StrList) MainList->Items[i];
 if (Struct->id_elem==id_elem)
        {
        Text_name->Text=Struct->name;
        Text_type->Caption=GetType(Struct->id_type);
        }
 }//прохождение по списку элементов, и нахожнение элементов с нужным уровнем - конец цикла

 for (int i=0;i<MainList->Count;i++)
 {
  Struct = (StrList) MainList->Items[i];
  if (Struct->id_elem_parent==id_elem) if (Struct->id_type!="eol") Memo1->Lines->Add(IntToStr(Struct->id_elem));
 }
}
//---------------------------------------------------------------------------
