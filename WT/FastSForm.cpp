//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "FastSForm.h"

//---------------------------------------------------------------------
//---------------------------------------------------------------------


__fastcall TWTFastSForm::TWTFastSForm(TWinControl *Owner): TWTMDIWindow(Owner) {

  SearchParams=new TWTSearchParams();

  DBGrid=(TWTDBGrid*)Owner;
  TWTField *Field;
  if (DBGrid->Table) Field=(TWTField*)DBGrid->SelectedField;
  else Field=(TWTField*)DBGrid->SelectedField;
  Width = 430;

  Height = 160;
  BorderStyle=bsDialog;
  Position=poScreenCenter;
  Caption="Поиск";

  Panel1=new TPanel(this);
  Panel1->Top=30;
  Panel1->Left=0;
  Panel1->Width=Width-6;
  Panel1->Height=Height-75-30;
  Panel1->Anchors=Panel1->Anchors >> akLeft >> akTop >> akRight >> akBottom;
  Panel1->Caption="";
  Panel1->BevelInner=bvNone;
  Panel1->BevelOuter=bvLowered;
  Panel1->Parent=this;

  TEdit *SeekStr=new TEdit(this);
  SeekStr->Parent=Panel1;
  SeekStr->Top=10;
  SeekStr->Left=10;
  SeekStr->Text="";
  SeekStr->Width=500;
  SeekStr->OnKeyPress=FOnKeyPress;
  SeekStr->OnChange=OnChSeekStr;

  Panel2=new TPanel(this);
  Panel2->Top=30+75+10;
  Panel2->Left=0;
  Panel2->Width=Width-6;
  Panel2->Height=Height-30-75-10-20;
  Panel2->Anchors=Panel1->Anchors >> akLeft >> akTop >> akRight >> akBottom;
  Panel2->Caption="";
  Panel2->BevelInner=bvNone;
  Panel2->BevelOuter=bvLowered;
  Panel2->Parent=this;


  ChPart=new TCheckBox(this);
  ChPart->Parent=Panel2;
  ChPart->Checked=true;
  ChPart->Caption="по подстроке";
  ChPart->Top=5;
  ChPart->Left=90;

  ChCase=new TCheckBox(this);
  ChCase->Parent=Panel2;
  ChCase->Checked=false;
  ChCase->Caption="учет регистра";
  ChCase->Top=5;
  ChCase->Left=180;

//  ChPart->Left=300;
  //SeekStr->Text="";
 // SeekStr->Width=500;


}
__fastcall TWTFastSForm::~TWTFastSForm(){
  delete SearchParams;
}

  /*
void __fastcall TWTFastSForm::FindRecord(TObject *Sender){
  DBGrid->SearchParams->Assign(SearchParams);
  SearchParams->Down=RGroup->ItemIndex;
  SearchParams->Case=CBox1->Checked;
  SearchParams->Part=CBox2->Checked;
  DBGrid->FSearchMenu(NULL);
}
               */
//---------------------------------------------------------------------
void _fastcall TWTFastSForm::FOnKeyPress(TObject *Sender, char &Key) {
  // По Enter выходим
  if (Key == 27)
    { ModalResult = -1;
     };
}

void __fastcall TWTFastSForm::OnChSeekStr(TObject * Sender)
{          SearchParams->AddLine(DBGrid->Fields[DBGrid->SelectedIndex]->FieldName,"=",((TEdit*)Sender)->Text);
     DBGrid->SearchFParams->Assign(SearchParams);
     DBGrid->SearchFParams->Down=true;
     DBGrid->SearchFParams->Case=ChCase->Checked;;
     DBGrid->SearchFParams->Part=ChPart->Checked;
    if (DBGrid->Table)
     DBGrid->SearchTable(((TEdit*)Sender)->Text,0);
    else 
     DBGrid->SearchQuery(((TEdit*)Sender)->Text,0);
  SearchParams->RemoveLine();




};
//---------------------------------------------------------------------------
#pragma package(smart_init)
