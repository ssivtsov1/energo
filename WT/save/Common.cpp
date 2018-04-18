//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Common.h"
#include "func.h"

__fastcall TWTCoolBar::TWTCoolBar(TComponent* AOwner) :TCoolBar(AOwner){
  Height=31;
  AutoSize=True;
  EdgeBorders=EdgeBorders >> ebTop;
  BarsList=new TList();
  PopupMenu=new TPopupMenu(this);
  PopupMenu->OnPopup=ShowBarsList;
}

__fastcall TWTCoolBar::~TWTCoolBar(){
  delete BarsList;
}
  /*
 void __fastcall TWTCoolBar::PaintWindow(HDC DC)
 {
 }; */
//приводит размеры TCoolBand в соответствии с лежащими на ToolBar элементами
void __fastcall TWTCoolBar::AlignSize(TWTToolBar* ToolBar){
  for (int x=0;x<Bands->Count;x++){
    if (Bands->Items[x]->Control==ToolBar) {
      int MaxX=0;
      for (int x=0;x<ToolBar->ControlCount;x++) if (ToolBar->Controls[x]->Visible) MaxX+=ToolBar->Controls[x]->Width;
      MaxX+=5;
      Bands->Items[x]->Visible=ToolBar->Active;
      Bands->Items[x]->MinWidth=MaxX;
      Bands->Items[x]->Width=MaxX;
      Bands->Items[x]->Break=false;
      if (x!=0) {
        Bands->Items[x-1]->Width=Bands->Items[x-1]->MinWidth;
      }
      return;
    }
  }
}

void __fastcall TWTCoolBar::AddToolBar(TWTToolBar* ToolBar){
  ToolBar->Parent=this;
  AlignSize(ToolBar);
  ToolBar->Height=29;
  BarsList->Add(ToolBar);
}

void __fastcall TWTCoolBar::RemoveToolBar(TWTToolBar* ToolBar){
  ToolBar->Parent=NULL;
  BarsList->Remove(ToolBar);
}

void __fastcall TWTCoolBar::ShowBarsList(TObject* Sender){
  while (PopupMenu->Items->Count) PopupMenu->Items->Delete(0);
  for (int x=0;x<BarsList->Count;x++) {
    TWTToolBar* TB=(TWTToolBar*)BarsList->Items[x];
    TMenuItem* MI=new TMenuItem(PopupMenu);
    MI->Caption=TB->ID;
    MI->Checked=TB->Active;
    MI->OnClick=UpdateToolBar;
    PopupMenu->Items->Add(MI);
  }
}

void __fastcall TWTCoolBar::UpdateToolBar(TObject* Sender){
  TMenuItem *MI=(TMenuItem*)Sender;
  MI->Checked=!MI->Checked;
  for (int x=0;x<BarsList->Count;x++) {
    TWTToolBar* TB=(TWTToolBar*)BarsList->Items[x];
    if (TB->ID==MI->Caption) {
      int CCount=0;
      for (int x=0;x<Bands->Count;x++){
        if (Bands->Items[x]->Visible) {
          CCount++;
        }
      }
      for (int x=0;x<Bands->Count;x++){
        if (Bands->Items[x]->Control==TB) {
          TB->Active=MI->Checked;
          if (!MI->Checked) {
            if (CCount==1) AutoSize=false;
            Bands->Items[x]->Visible=false;
          } else {
            Bands->Items[x]->Visible=true;
            if (CCount==0) AutoSize=true;
          }
          return;
        }
      }
    }
  }
}



//==============================================================================
//==============================================================================
//==============================================================================


__fastcall TWTToolBar::TWTToolBar(TComponent* AOwner): TToolBar(AOwner){
  Active=true;
  Flat=true;
  BorderWidth=1;
  Width=0;
  Height=29;
  Visible=true;
  Align=alLeft;
  ID="";

  ImageList=NULL;
}

__fastcall TWTToolBar::~TWTToolBar(){
}

TWTToolButton* _fastcall TWTToolBar::AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick)
{
  if (!ImageList) {
    ImageList=new TImageList(this);
    Images=ImageList;
    Width=0;
  }
  Width+=24;
  TWTToolButton *ToolButton1=new TWTToolButton(this);
  ToolButton1->Left=1000*ControlCount;
  ToolButton1->Top=1000*ControlCount;
  if (Path!='|') {
    ToolButton1->Style=tbsButton;
    ToolButton1->OnClick=EventOnClick;
    ToolButton1->Hint=BHint;
    ToolButton1->ShowHint=true;
    Graphics::TBitmap *Bitmap1=new Graphics::TBitmap();
    Bitmap1->LoadFromResourceName(0,Path);
    ImageList->Add(Bitmap1,NULL);
    delete Bitmap1;
    ToolButton1->ImageIndex=ImageList->Count-1;
  } else {
    ToolButton1->Style=tbsSeparator;
  }
  Height= 29;
  ToolButton1->Parent=this;
  return ToolButton1;
}

void __fastcall TWTToolBar::DisableButton(AnsiString ID){
  for (int x=0;x<ControlCount;x++) {
    if (CheckParent(Controls[x],"TWTToolButton")) {
      if (((TWTToolButton*)Controls[x])->ID==ID) {
        ((TWTToolButton*)Controls[x])->Enabled=false;
      }
    }
  }
}

void __fastcall TWTToolBar::EnableButton(AnsiString ID){
  for (int x=0;x<ControlCount;x++) {
    if (CheckParent(Controls[x],"TWTToolButton")) {
      if (((TWTToolButton*)Controls[x])->ID==ID) {
        ((TWTToolButton*)Controls[x])->Enabled=true;
      }
    }
  }
}

void __fastcall TWTToolBar::HideButton(AnsiString ID){
  for (int x=0;x<ControlCount;x++) {
    if (CheckParent(Controls[x],"TWTToolButton")) {
      if (((TWTToolButton*)Controls[x])->ID==ID) {
        ((TWTToolButton*)Controls[x])->Visible=false;
        TWTCoolBar* CB;
        if (CheckParent(Parent,"TWTCoolBar")) {
          CB=(TWTCoolBar*)Parent;
          CB->AlignSize(this);
        }
      }
    }
  }
}

void __fastcall TWTToolBar::ShowButton(AnsiString ID){
  for (int x=0;x<ControlCount;x++) {
    if (CheckParent(Controls[x],"TWTToolButton")) {
      if (((TWTToolButton*)Controls[x])->ID==ID) {
        ((TWTToolButton*)Controls[x])->Visible=true;
        TWTCoolBar* CB;
        if (CheckParent(Parent,"TWTCoolBar")) {
          CB=(TWTCoolBar*)Parent;
          CB->AlignSize(this);
        }
      }
    }
  }
}


TCoolBand* __fastcall TWTToolBar::GetCoolBand(){
  if (CheckParent(Parent,"TCoolBar")) {
  TCoolBar* CB=(TCoolBar*)Parent;
    for (int x=0;x<CB->Bands->Count;x++) {
      if (CB->Bands->Items[x]->Control==this) return CB->Bands->Items[x];
    }
  }
  return NULL;
}

//==============================================================================
//==============================================================================
//==============================================================================


__fastcall TWTToolButton::TWTToolButton(TComponent* AOwner): TToolButton(AOwner){
  ID="";
}

__fastcall TWTToolButton::~TWTToolButton(){
}


//---------------------------------------------------------------------------
#pragma package(smart_init)
