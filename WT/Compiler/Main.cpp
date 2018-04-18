//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#include "pascal.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::ToolButton1Click(TObject *Sender)
{
/* FILE *f;
 f=fopen("--temp.pas","w");
 fputs(Memo1->Lines->Text.c_str(),f);
 fclose(f);*/

 TPC * TPComp=new TPC(Memo1->Lines);
 int Error=TPComp->Process();
 if (Error) {
   throw Exception("Error "+IntToStr(Error));
 }
 delete TPComp;
}
//---------------------------------------------------------------------------
void __fastcall TForm1::ToolButton2Click(TObject *Sender)
{
 FILE *f=fopen("--temp.tmp","w");
 for (int x=0;x<Memo1->Lines->Count;x++) {
   fputs(Memo1->Lines->Strings[x].c_str(),f);
   fputs("\n",f);
 }
 fclose(f);
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{

 Memo1->Lines->Clear();
 FILE *f=fopen("--temp.tmp","r");
 char a[1000];
 while (!feof(f)) {
   fgets(a,100,f);
   a[strlen(a)-1]=0;
   if (!feof(f)) Memo1->Lines->Add(a);
 }
 fclose(f);
}
//---------------------------------------------------------------------------

