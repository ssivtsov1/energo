//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include <FileCtrl.hpp>
#include "Main.h"
#include "FormFtp.h"
#include "Query.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TftpForm *ftpForm;
AnsiString Host_;
//---------------------------------------------------------------------------
__fastcall TftpForm::TftpForm(TComponent* Owner)
        : TForm(Owner)
{
 EdHost->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Host",HostE);
 //((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","Alias",AliasE);
}
__fastcall TftpForm::~TftpForm()
{
   Close();
}

//---------------------------------------------------------------------------

void __fastcall TftpForm::Show(int mode)
{ AnsiString Path;
 AnsiString Alias;
   AnsiString pwd;
  TWTQuery *QueryZ=new TWTQuery(this);

  QueryZ->Sql->Add("select getsysvarc('local')::::varchar as ok");

  try
  {
   QueryZ->Open();
  }
  catch(...)
  {
   ShowMessage("Ошибка SQL ");
   return;
  }
   QueryZ->First();
    if ( QueryZ->RecordCount>0)
      pwd = QueryZ->FieldByName("ok")->AsString; 
      else
         pwd ="qwerty";
     QueryZ->Close();



 MyFtp->UserID="local";
 MyFtp->Password=pwd;
 if (mode==0)
 { Path="C:\\Temp\\In";
   BOutSpr->Visible=false;
     BAskue->Visible=false;
   EdPath->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","PathIn",Path);
     EdAlias->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Alias",Alias);

 }
 else if (mode==1)
 { Path="C:\\Temp\\Out";
   BInSpr->Visible=false;
   BAskue->Visible=false;
   EdPath->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","PathOut",Path);
   EdAlias->Text=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","Alias",Alias);

   Lab2->Visible=false;
   Lab4->Visible=false;
 }
 else
 { Path="C:\\Askue";
    BInSpr->Visible=false;
    BOutSpr->Visible=false;
  }
}


void __fastcall TftpForm::FormClose(TObject *Sender, TCloseAction &Action)
{
 Action = caFree;
}
//---------------------------------------------------------------------------
void __fastcall TftpForm::BOutSprClick(TObject *Sender)
{ int i;
SaveDialog->InitialDir=EdPath->Text;
 ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","PathOut",EdPath->Text);
TWTQuery *QueryOut=new TWTQuery(this);

QueryOut->Sql->Add("select sys_replicat_out_fun()");
try   {
QueryOut->ExecSql();
 }
           catch (Exception &exception)
           {
            Application->ShowException(&exception);
           }
//MyFtp->Reinitialize();
MyFtp->Host=EdHost->Text;
MyFtp->Connect();
if (MyFtp->Connected)
{
  //ShowMessage(MyFtp->CurrentDir);

MyFtp->ChangeDir("/home/local/replicat/out");

    MemState->Lines->Add("копирование с фтп Ждите...");

MyFtp->List();
for(i=0;i<MyFtp->FTPDirectoryList->Attribute->Count;i++)
{
 MyFtp->FTPDirectoryList->name->Strings[i];
if((MyFtp->FTPDirectoryList->Attribute->Strings[i])[1] == 'd')
{
//Папки:
//
}
else
{
//Файлы:

SaveDialog->FileName = SaveDialog->InitialDir+"\\"+MyFtp->FTPDirectoryList->name->Strings[i]; //Даем имя файлу

MyFtp->Download(MyFtp->FTPDirectoryList->name->Strings[i], SaveDialog->FileName); //Сохранено

      MemState->Lines->Add("Обработка "+MyFtp->FTPDirectoryList->name->Strings[i]+ " в "+SaveDialog->FileName+"   Ждите...");


//MyFtp->DownLoad("repl*");

}
}
}
else
ShowMessage("Сервер отказал в доступе");
MyFtp->Disconnect();
ShowMessage("Выгрузка завершена!");
return;
};

//---------------------------------------------------------------------------
void __fastcall TftpForm::BInSprClick(TObject *Sender)
{ int i;
 ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","PathIn",EdPath->Text);
 if (Ask("Вы уверены что хотите загрузить справочники?"))
 { //MyFtp->Reinitialize();
  MemState->Clear();
  MyFtp->Host=EdHost->Text;

  MyFtp->Connect();

  if (MyFtp->Connected)
  {  TSearchRec sr;
  // ShowMessage(MyFtp->CurrentDir);
        MyFtp->ChangeDir("/home/local/replicat/in");

    MyFtp->ChangeDir("/home/local/replicat/in");

     /* for (int I = 0; I <= (MyFtp->FTPDirectoryList->name->Count - 1); I++)

          {
             MemState->Lines->Add( MyFtp->FTPDirectoryList->name->Strings[I]);
            MemState->Lines->Add( MyFtp->FTPDirectoryList->Size->Strings[I]);
          MemState->Lines->Add(  MyFtp->FTPDirectoryList->ModifDate->Strings[I]);
           MemState->Lines->Add( MyFtp->FTPDirectoryList->Attribute->Strings[I]);
          };    */

  //  MyFtp->ChangeDir("in");
    AnsiString filename;
    TStringList *Files = new TStringList();
     AnsiString Dir = EdPath->Text;
 //   if (SelectDirectory(Dir, TSelectDirOpts() << sdAllowCreate << sdPerformCreate << sdPrompt,1000))
      Dir=EdPath->Text;
      if (FindFirst(Dir+"\\*.TXT", faAnyFile , sr) == 0)
     {
        do
        {   MemState->Lines->Add("Загрузка "+Dir+"\\"+filename);
            filename=sr.Name;
            MyFtp->Upload(Dir+"\\"+filename,filename );

        }
        while(FindNext(sr) == 0);
     }
    TWTQuery *QueryOut=new TWTQuery(this);
    QueryOut->Sql->Add("select sys_replicat_sys_in_fun()");
    try  {
      MemState->Lines->Add("Обработка системных таблиц.   Ждите...");
      QueryOut->ExecSql();
    }
    catch (Exception &exception)
    { Application->ShowException(&exception);
    }
    QueryOut->Sql->Clear();
    QueryOut->Sql->Add("select sys_replicat_in_fun()");
    try  {
      MemState->Lines->Add("Обработка справочников.    Ждите...");
      QueryOut->ExecSql();
     }
     catch (Exception &exception)
     {      Application->ShowException(&exception);
     }
  }
 else
 {  MemState->Lines->Add("Сервер отказал в доступе.");
   ShowMessage("Сервер отказал в доступе");
  };
 MemState->Lines->Add("Загрузка справочников завершена.");
ShowMessage("Загрузка завершена!");
MyFtp->Disconnect();
}
else
ShowMessage("Загрузка отменена пользователем!");
return;
}

void __fastcall TftpForm::DumpClick(TObject *Sender)
{  int i;
 // Server94->Host=EdHost->Text;
//  Server94->
  MyFtp->Connect();
SaveDialog->InitialDir=EdPath->Text;
 ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","PathOut",EdPath->Text);
MyFtp->Host=EdHost->Text;
MyFtp->Connect();
if (MyFtp->Connected)
{
  //ShowMessage(MyFtp->CurrentDir);
 MyFtp->ChangeDir("Dump");
 SaveDialog->FileName = SaveDialog->InitialDir+"\\"+Fname; //Даем имя файлу
 MyFtp->Download(Fname, SaveDialog->FileName); //Сохранено
//MyFtp->DownLoad("repl*");


}
else
ShowMessage("Сервер отказал в доступе");
MyFtp->Disconnect();
ShowMessage("Завершено!");
}
//---------------------------------------------------------------------------



void __fastcall TftpForm::SpeedButton1Click(TObject *Sender)
{ AnsiString Dir;
Dir=EdPath->Text;
if (SelectDirectory(Dir, TSelectDirOpts() << sdAllowCreate << sdPerformCreate << sdPrompt,1000))
{ EdPath->Text=Dir;
}
}
//---------------------------------------------------------------------------


void __fastcall TftpForm::LoadAckue(TObject *Sender)
{
 int i;
 int countlist;
 AnsiString filename_beg;
 ((TWTMainForm*)Application->MainForm)->StartupIniFile->WriteString("Base","PathIn",EdPath->Text);
 if (Ask("Вы уверены что хотите загрузить показания по АСКУЕ?"))
 { //MyFtp->Reinitialize();
  MemState->Clear();
  MyFtp->Host=EdHost->Text;
  MyFtp->Connect();
  if (MyFtp->Connected)
  {  TSearchRec sr;
    MyFtp->ChangeDir("/home/local/replicat/in/askue");
   // MyFtp->ChangeDir("in");
   //  MyFtp->ChangeDir("askue");
    AnsiString filename;
    AnsiString filename_end;
    AnsiString filename_begin;
    AnsiString filename_data;
          TWTQuery *QueryZ=new TWTQuery(this);
            QueryZ->Sql->Add("select getsysvar('kod_res') as res");
  try
  {
   QueryZ->Open();
  }
  catch(...)
  {
   ShowMessage("Ошибка SQL ");
   return;
  }
   AnsiString kod_res = QueryZ->FieldByName("res")->AsString;
    TStringList *Files = new TStringList();

     AnsiString Dir = EdPath->Text;
 //   if (SelectDirectory(Dir, TSelectDirOpts() << sdAllowCreate << sdPerformCreate << sdPrompt,1000))
      if (!DirectoryExists(Dir+"\\ready"))
       {
        if (!CreateDir(Dir+"\\ready"))
         { ShowMessage("Невозможно создать директорию "+Dir+"\\ready"+" Загрузка невозможна!");
          return;
          }
        }

  /*   if CreateDirectory(Dir+"\\ready", NULL) == FALSE
         ShowMessage("Невозможно создать директорию "+Dir+"\\ready"+" Загрузка невозможна!")
 */

       TWTQuery *QueryOut=new TWTQuery(this);
      if (FindFirst(Dir+"\\*.*", faAnyFile , sr) == 0)
     {
        do
        {   filename=sr.Name;
            if ((filename==".") || (filename==".."))
             continue;
            if (FileExists(Dir+"\\ready\\"+filename))
               DeleteFile(Dir+"\\ready\\"+filename);
             bool t;
             AnsiString of;
             AnsiString nf;
             of=Dir+"\\"+filename;
             nf=Dir+"\\ready\\"+filename;
             char *p1 = new char[of.Length()];
             char *p2 = new char[nf.Length()];
             strcpy(p1,of.c_str());
             strcpy(p2,nf.c_str());
             t=CopyFile(p1,p2,false);
             


            filename_end=filename.SubString(filename.Length()-6,3);
            filename_beg=filename.SubString(1,3);
            if ((filename_beg!=kod_res))
               continue;
             TStringList *List=new TStringList;
             List->LoadFromFile(Dir+"\\"+filename);
              for  (int i=0;i<=List->Count - 1;i++) {

             if (List->Strings[i].Pos("((//") > 0)
                     {   List->Delete(i); i--; continue;};
             if (List->Strings[i].Pos("==))") > 0)
                 {    List->Delete(i); i--;continue;};
            if (List->Strings[i].Pos(":")<0)
             { List->Delete(i);i--;};
             if (List->Strings[i].IsEmpty())
             { List->Delete(i);i--;};
             };
             List->SaveToFile( Dir+"\\"+filename );
             delete List;

            MemState->Lines->Add("Загрузка "+Dir+"\\"+filename);
            if  (filename_end=="818")
            {  QueryOut->Sql->Clear();
            //  MyFtp->Upload(Dir+"\\"+filename,"askue_day.txt" );
                MyFtp->Upload(Dir+"\\"+filename,filename );
              QueryOut->Sql->Add("select load_askue_day('"+filename+"')");
              try  {
                     MemState->Lines->Add("Загрузка дневного потребления.   Ждите...");
                     QueryOut->ExecSql();
                     if (FileExists(Dir+"\\"+filename))
                     DeleteFile(Dir+"\\"+filename);

                  }
              catch (Exception &exception)
              { Application->ShowException(&exception);
              }
              };
            if  (filename_end=="917")
            { QueryOut->Sql->Clear();

           //  MyFtp->Upload(Dir+"\\"+filename,"askue_hour.txt" );
             MyFtp->Upload(Dir+"\\"+filename,filename );
              QueryOut->Sql->Add("select load_askue_hour('"+filename+"')");
              try  {
                   MemState->Lines->Add("Загрузка почасовки.    Ждите...");
                    QueryOut->ExecSql();
                     if (FileExists(Dir+"\\"+filename))
                    DeleteFile(Dir+"\\"+filename);

                    }
               catch (Exception &exception)
            {      Application->ShowException(&exception);
            }
          }

      }
        while(FindNext(sr) == 0);
     }

  }
 else
 {  MemState->Lines->Add("Сервер отказал в доступе.");
   ShowMessage("Сервер отказал в доступе");
  };
 MemState->Lines->Add("Загрузка  завершена.");
ShowMessage("Загрузка завершена!");
MyFtp->Disconnect();
}
else
ShowMessage("Загрузка отменена пользователем!");
 return;
}
//---------------------------------------------------------------------------

void __fastcall TftpForm::btLoadL04Click(TObject *Sender)
{
 int i;
 AnsiString filename;
 AnsiString Dir;

 OpenDialog1->FileName="";
 OpenDialog1->Title="Выберете файл для загрузки";

 if (OpenDialog1->Execute())
 {

  MemState->Clear();
  MyFtp->Host=EdHost->Text;
  MyFtp->Connect();
  if (MyFtp->Connected)
  {
    TSearchRec sr;
    MyFtp->ChangeDir("/home/local/replicat/in");
  //  MyFtp->ChangeDir("in");
    filename = ExtractFileName(OpenDialog1->FileName);

    MyFtp->Upload(OpenDialog1->FileName,filename );

    TWTQuery *QueryOut=new TWTQuery(this);
    QueryOut->Sql->Add("select load_fider04('"+filename+"')");
    try  {
      MemState->Lines->Add("Обработка файла "+filename +"...   Ждите...");
      QueryOut->ExecSql();
    }
    catch (Exception &exception)
    { Application->ShowException(&exception);
    }
  }
 else
 {  MemState->Lines->Add("Сервер отказал в доступе.");
   ShowMessage("Сервер отказал в доступе");
  };

 MemState->Lines->Add("Загрузка  завершена.");
 ShowMessage("Загрузка завершена!");
 MyFtp->Disconnect();
}
 return;
}
//---------------------------------------------------------------------------

void __fastcall TftpForm::btLoadFizClick(TObject *Sender)
{
 int i;
 AnsiString filename;
 AnsiString Dir;

 OpenDialog1->FileName="";
 OpenDialog1->Title="Выберете файл для загрузки";

 if (OpenDialog1->Execute())
 {

  MemState->Clear();
  MyFtp->Host=EdHost->Text;
  MyFtp->Connect();
  if (MyFtp->Connected)
  {
    TSearchRec sr;
    MyFtp->ChangeDir("/home/local/replicat/in");
//    MyFtp->ChangeDir("in");
    filename = ExtractFileName(OpenDialog1->FileName);

    MyFtp->Upload(OpenDialog1->FileName,filename );

    TWTQuery *QueryOut=new TWTQuery(this);
    QueryOut->Sql->Add("select load_fiz_reconnect('"+filename+"')");
    try  {
      MemState->Lines->Add("Обработка файла "+filename +"...   Ждите...");
      QueryOut->ExecSql();
    }
    catch (Exception &exception)
    { Application->ShowException(&exception);
    }
  }
 else
 {  MemState->Lines->Add("Сервер отказал в доступе.");
   ShowMessage("Сервер отказал в доступе");
  };

 MemState->Lines->Add("Загрузка  завершена.");
 ShowMessage("Загрузка завершена!");
 MyFtp->Disconnect();
}
 return;

}
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------

void __fastcall TftpForm::btFiderFizClick(TObject *Sender)
{
  int i;
 AnsiString filename;
 AnsiString Dir;

 OpenDialog1->FileName="";
 OpenDialog1->Title="Выберете файл для загрузки";

 if (OpenDialog1->Execute())
 {

  MemState->Clear();
  MyFtp->Host=EdHost->Text;
  MyFtp->Connect();
  if (MyFtp->Connected)
  {
    TSearchRec sr;
    MyFtp->ChangeDir("/home/local/replicat/in");
  //  MyFtp->ChangeDir("in");
    filename = ExtractFileName(OpenDialog1->FileName);

    MyFtp->Upload(OpenDialog1->FileName,filename );

    TWTQuery *QueryOut=new TWTQuery(this);
    QueryOut->Sql->Add("select expimp_indemand_fun('"+filename+"')");
    //  ShowMessage(QueryOut->Sql->Text);
    try  {
      MemState->Lines->Add("Обработка файла "+filename +"...   Ждите...");
      QueryOut->ExecSql();
    }
    catch (Exception &exception)
    { Application->ShowException(&exception);
    }
  }
 else
 {  MemState->Lines->Add("Сервер отказал в доступе.");
   ShowMessage("Сервер отказал в доступе");
  };

 MemState->Lines->Add("Загрузка  завершена.");
 ShowMessage("Загрузка завершена!");
 MyFtp->Disconnect();
}
 return;

}
//---------------------------------------------------------------------------

void __fastcall TftpForm::EdUserExit(TObject *Sender)
{
if (  ((TEdit*)Sender)->Text!="" && (EdPwd->Text!=""))
{ MyFtp->UserID=((TEdit*)Sender)->Text;
 MyFtp->Password=EdPwd->Text;
} else
 if (((TEdit*)Sender)->Text=="" && EdPwd->Text=="")
 {  MyFtp->UserID="osa";
 MyFtp->Password="qwerty";
 };
}
//---------------------------------------------------------------------------

void __fastcall TftpForm::EdPwdExit(TObject *Sender)
{
if (((TEdit*)Sender)->Text!="" && (EdUser->Text!=""))
{ MyFtp->UserID=EdUser->Text;
 MyFtp->Password=((TEdit*)Sender)->Text;
} else
 if (((TEdit*)Sender)->Text=="" && (EdUser->Text==""))
 {  MyFtp->UserID="osa";
 MyFtp->Password="qwerty";
 };
}
//---------------------------------------------------------------------------

void __fastcall TftpForm::SpeedButton2DblClick(TObject *Sender)
{      Label3->Visible=true;
       EdUser->Visible=true;
       EdPwd->Visible=true;

}
//---------------------------------------------------------------------------

void __fastcall TftpForm::SpeedButton2Click(TObject *Sender)
{
  Label3->Visible=true;
       EdUser->Visible=true;
       EdPwd->Visible=true;        
}
//---------------------------------------------------------------------------

