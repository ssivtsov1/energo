//---------------------------------------------------------------------------
#include <vcl.h>
#include <comctrls.hpp>
#include <dialogs.hpp>
#pragma hdrstop

#include "ScriptForm.h"

#include "include\\pascal.h"

int __fastcall fff(int x,int y){
  return x+y;
}

AnsiString __fastcall ffff(AnsiString x,AnsiString y,AnsiString z){
  return x+y+z;
}

void __fastcall ShowInt(int i) {
  ShowMessage(i);
}

void __fastcall ShowString(AnsiString s) {
  ShowMessage(s);
}

void __fastcall ShowFloat(float f) {
  ShowMessage(f);
}

void * Form(){
  return Application->MainForm;
}

__fastcall TWTScriptForm::TWTScriptForm(TComponent* Owner): TWTMDIWindow(Owner) {
 // FormStyle=fsMDIChild;
  IsChange=true;
  TPComp=new TWTTPC();
//  TPComp->Analizer->Generator->FuncTable=FTable;
  WindowState=wsMaximized;
//  SetSize(600,400);
//  Height=400;
//  Width=600;
  Left=0;
  Top=0;
  Caption="Script Editor";
  KeyPreview=true;
  Position=poScreenCenter;

  TCoolBar *CoolBar=new TCoolBar(this);
  CoolBar->EdgeBorders=CoolBar->EdgeBorders >> ebTop;
  TToolBar *ToolBar=new TToolBar(this);
  ToolBar->Flat=true;
  ToolBar->BorderWidth=1;
  ToolBar->Width=100;
  ToolBar->Height=29;
  ToolBar->Visible=true;
//  ToolBar->Align=alTop;

  CoolBar->Parent=this;
  ToolBar->Parent=CoolBar;
  CoolBar->Bands->Items[0]->MinWidth = 130;
  CoolBar->Bands->Items[0]->Break = false;
  ToolBar->AutoSize=true;

  Graphics::TBitmap *BM=new Graphics::TBitmap();
  BM->LoadFromFile("Images\\RunScript.bmp");

  TCustomImageList *ImageList1=new TCustomImageList(this);
  ToolBar->Images=ImageList1;
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\SaveFile.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\Step.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\Compile.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\RunTo.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\OpenFile.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\New.bmp");
  ImageList1->Add(BM,NULL);
  BM->LoadFromFile("Images\\Inspect.bmp");
  ImageList1->Add(BM,NULL);

  TToolButton *ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=Step;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=2;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=RunTo;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=4;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=Compile;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=3;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=Inspect;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=7;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=RunProcess;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=0;
  ToolButton1->Parent=ToolBar;

  ToolBar=new TToolBar(CoolBar);
  ToolBar->Flat=true;
  ToolBar->BorderWidth=1;
  ToolBar->Width=100;
  ToolBar->Height=29;
  ToolBar->Visible=true;
//  ToolBar->Align=alLeft;

  ToolBar->Parent=CoolBar;
  CoolBar->Bands->Items[1]->Width = CoolBar->Width-130;
  CoolBar->Bands->Items[0]->Width = 130;
  CoolBar->Bands->Items[1]->MinWidth = 100;
  CoolBar->Bands->Items[1]->Break = false;
  CoolBar->AutoSize=true;
  ToolBar->AutoSize=true;
  ToolBar->Images=ImageList1;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=Save;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=1;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=Open;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=5;
  ToolButton1->Parent=ToolBar;

  ToolButton1=new TToolButton(ToolBar);
  ToolButton1->Style=tbsButton;
  ToolButton1->OnClick=New;
  ToolButton1->Hint="";
  ToolButton1->ShowHint=true;
  ToolButton1->ImageIndex=6;
  ToolButton1->Parent=ToolBar;

/*  ResultText=new TMemo(this);
  ResultText->Align=alRight;
  ResultText->Font->Name="Courier New";
  ResultText->Font->Size=10;
  ResultText->Parent=this;
  ResultText->Lines->Clear();
  ResultText->WordWrap=false;
  ResultText->ScrollBars=ssBoth;
  ResultText->Font->Color=clGreen;*/
//  ResultText->Font->Style=ResultText->Font->Style << fsBold;

  TSplitter *Splitter=new TSplitter(this);
  Splitter->Align=alRight;
  Splitter->MinSize=100;
  Splitter->Parent=this;

  SrcText=new TMemo(this);
  SrcText->Align=alClient;
  SrcText->Font->Name="Courier New";
  SrcText->Font->Size=10;
  SrcText->Parent=this;
  SrcText->Lines->Clear();
  SrcText->WordWrap=false;
  SrcText->ScrollBars=ssBoth;
  SrcText->OnKeyDown=KeyDown;

  StatusBar=new TStatusBar(this);
  StatusBar->SimplePanel=true;
  StatusBar->Parent=this;
  StatusBar->SimpleText="Line: 0";


//  TWTTPC * TPComp=new TWTTPC(SrcText->Lines);
  OpenFile("scripts\\temp.sef");
  ActiveControl=SrcText;
  FTable[0]=fff;
  FTable[1]=ffff;
  FTable[2]=MethodAddress("SetSize");
  FTable[3]=Form;
  FTable[4]=ShowInt;
  FTable[5]=ShowString;
  FTable[6]=ShowFloat;
//  FTable[0]=TWTScriptForm::SetSize;
  FormStyle=fsMDIChild;
}


void __fastcall TWTScriptForm::Test(int& s,int a){
  s=a;
}


void __fastcall TWTScriptForm::FShowCurrentLine(){
  if (TPComp->Analizer->Generator->VMachine->ProgramOver) {
    SrcText->SelLength=0;
  }
  int a=TPComp->Analizer->Generator->VMachine->LineNumber;
  StatusBar->SimpleText="Line: "+IntToStr(a);
  int cc=0;
  for (int x=0;x<a-1;x++) {
    cc+=SrcText->Lines->Strings[x].Length()+2;
  }
  SrcText->SetFocus();
  SrcText->SelStart=cc;
  SrcText->SelLength=SrcText->Lines->Strings[a-1].Length();
}

__fastcall TWTScriptForm::~TWTScriptForm(){
  delete TPComp;
}

void __fastcall TWTScriptForm::RunProcess(TObject *Sender){
 if ((IsChange) || (TPComp->ErrorCode)) Compile(NULL);
 if (TPComp->ErrorCode) return;
 TPComp->Analizer->Generator->VMachine->Run();
}

void __fastcall TWTScriptForm::RunTo(TObject *Sender){
  if ((IsChange) || (TPComp->ErrorCode)) Compile(NULL);
  if (TPComp->ErrorCode) return;
  int cc=0;
  int x=-1;
  while (cc<SrcText->SelStart+1) {
    x++;
    cc+=SrcText->Lines->Strings[x].Length()+2;
  }
  if (x+1>0) TPComp->Analizer->Generator->VMachine->RunTo(x+1);
  FShowCurrentLine();
}

void __fastcall TWTScriptForm::KeyDown(System::TObject* Sender, Word &Key, Classes::TShiftState Shift){
  switch (Key) {
    case 115: {
      RunTo(NULL);
      break;
    }
    case 119: {
      Step(NULL);
      break;
    }
    case 120: {
      RunProcess(NULL);
      break;
    }
    default: IsChange=true;
  }
}

void __fastcall TWTScriptForm::New(TObject *Sender){
  SrcText->Clear();
  CurrentFile="";
  Caption="Script Editor";
}

void __fastcall TWTScriptForm::Compile(TObject *Sender){
 TPComp->Analizer->Generator->AddExternalVar("Form",3,"TForm");
 TPComp->Process(SrcText->Lines);
 IsChange=false;
 if (TPComp->ErrorCode) return;
 if (CurrentFile=="") return;
 int len=CurrentFile.Length();
 char FName[255];
 strcpy(FName,CurrentFile.c_str());
 while ((len>=0) && (FName[len]!=46)) len--;
 if (len) FName[len]=0;
 TPComp->Analizer->Generator->SaveToFile(AnsiString(FName)+".vmf");
}

void __fastcall TWTScriptForm::Step(TObject *Sender){
 if ((IsChange) || (TPComp->ErrorCode)) Compile(NULL);
 if (TPComp->ErrorCode) return;
 TPComp->Analizer->Generator->VMachine->Next();
 FShowCurrentLine();
}

void __fastcall TWTScriptForm::Open(TObject *Sender){
  TOpenDialog* OD=new TOpenDialog(this);
  OD->DefaultExt="*.sef";
  OD->Options.Clear();
  OD->InitialDir="Scripts";
  OD->Options=OD->Options << ofHideReadOnly << ofPathMustExist << ofFileMustExist;
  OD->Filter="Исходный файл Script Editor|*.sef";
  if (OD->Execute()) {
    OpenFile(OD->Files->Strings[0]);
  }
  delete OD;
}

int __fastcall TWTScriptForm::OpenFile(AnsiString Path){
    CurrentFile=Path;
    Caption="Script Editor ["+CurrentFile+"]";
    FILE *f=fopen(CurrentFile.c_str(),"r");
    if (f==NULL) return 1;
    SrcText->Clear();
    char a[1000];
    while (!feof(f)) {
      fgets(a,100,f);
      a[strlen(a)-1]=0;
      if (!feof(f)) SrcText->Lines->Add(a);
    }
    fclose(f);
    return 0;
}

void __fastcall TWTScriptForm::Save(TObject *Sender){
  if (CurrentFile!="") {
    SaveFile(CurrentFile);
    return;
  }
  TSaveDialog* SD=new TSaveDialog(this);
  SD->DefaultExt="*.rpt";
  SD->Options.Clear();
  SD->Options=SD->Options << ofHideReadOnly << ofOverwritePrompt;
  SD->InitialDir="Scripts";
  SD->Filter="Исходный файл Script Editor|*.sef";
  if (SD->Execute()) {
    SaveFile(SD->Files->Strings[0]);
  }
  delete SD;
}

void __fastcall TWTScriptForm::SaveFile(AnsiString Path){
    CurrentFile=Path;
    Caption="Script Editor ["+CurrentFile+"]";
//    char s[255];
//    strcpy(s,CurrentFile.c_str());
    FILE *f=fopen(Path.c_str(),"w");
    for (int x=0;x<SrcText->Lines->Count;x++) {
      fputs(SrcText->Lines->Strings[x].c_str(),f);
      fputs("\n",f);
    }
    fclose(f);
}

void __fastcall TWTScriptForm::SetSize(int x,int y){
  Width=x;
  Height=y;
}

void __fastcall TWTScriptForm::Inspect(TObject *Sender){
  AnsiString V=InputBox("Inspect", "Inspected Value:","");
  ShowMessage(TPComp->Analizer->Generator->InspectValue(V));
}


//---------------------------------------------------------------------------
#pragma package(smart_init)
