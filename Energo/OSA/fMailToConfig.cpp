//---------------------------------------------------------------------------

#include <vcl.h>
#include <registry.hpp>
#pragma hdrstop

#include "fMailToConfig.h"
#include "Main.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TMailToConfig *MailToConfig;
//---------------------------------------------------------------------------
__fastcall TMailToConfig::TMailToConfig(TComponent* Owner)
        : TForm(Owner)
{
          command_list=new TStringList;
}
//---------------------------------------------------------------------------

void __fastcall TMailToConfig::FormShow(TObject *Sender)
{
      AnsiString command_path = "\\Protocols\\mailto\\shell\\open\\command"  ;
      AnsiString command;

      command_list->Clear();
      lbMails->Items->Clear();

      AnsiString mail_client=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","mail_app","");


      TRegistry *reg=new TRegistry(KEY_ALL_ACCESS);
          TStringList *l=new TStringList;
          TStringList *s=new TStringList;
          TStringList *k=new TStringList;
          TStringList *k1=new TStringList;

          reg->RootKey=HKEY_LOCAL_MACHINE;
          AnsiString bl="\\SOFTWARE\\Clients\\Mail\\";
          reg->OpenKey(bl,0);
          reg->GetKeyNames(l);
          reg->GetValueNames(s);


          AnsiString default_mail ="";
          if(s->Count!=0)
          {
           default_mail=reg->ReadString(s->Strings[0]);
          } 

          if(reg->HasSubKeys()==true || s>0)
          {
              for(int v=0;v<l->Count;v++)
              {
                  reg->OpenKey(bl+l->Strings[v],0);       //"\\"

                  if (reg->OpenKey(bl+l->Strings[v]+command_path,0))
                  {
                    //  reg->GetKeyNames(k);
                      lbMails->Items->Add(l->Strings[v]);
                      reg->GetValueNames(k1);
                      command = reg->ReadString(k1->Strings[0]);

                      command_list->Add(command);
                  }
              }

              int def_index;

              if (mail_client!="")
               def_index = lbMails->Items->IndexOf(mail_client) ;
              else
               def_index = lbMails->Items->IndexOf(default_mail) ;

              if(def_index!=-1)
              {
                lbMails->ItemIndex =def_index;
              }
              else
              {
                lbMails->ItemIndex=0;
              }
              edCommand->Text = command_list->Strings[lbMails->ItemIndex];              

          }

          delete reg;
      
}
//---------------------------------------------------------------------------
void __fastcall TMailToConfig::lbMailsClick(TObject *Sender)
{

  edCommand->Text = command_list->Strings[lbMails->ItemIndex];
}
//---------------------------------------------------------------------------
void __fastcall TMailToConfig::btCancelClick(TObject *Sender)
{
 Close();        
}
//---------------------------------------------------------------------------
void __fastcall TMailToConfig::btOkClick(TObject *Sender)
{
  ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","mailto",command_list->Strings[lbMails->ItemIndex]);
  ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","mail_app",lbMails->Items->Strings[lbMails->ItemIndex]);

}
//---------------------------------------------------------------------------
