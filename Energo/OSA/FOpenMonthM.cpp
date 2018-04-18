//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h"
#include "FOpenMonthM.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TFOpenMonth *FOpenMonth;
//---------------------------------------------------------------------------
__fastcall TFOpenMonth::TFOpenMonth(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TFOpenMonth::BitBtn1Click(TObject *Sender)
{     //ShortDateFormat="yyyy-mm-dd";
     TWTQuery *QMMGG=new TWTQuery (this);
     QMMGG->Sql->Add("select fun_mmgg(1)-interval '1 month' as val");
     QMMGG->Open();
     EdMMGG->Text=QMMGG->FieldByName("val")->AsString;
     TWTQuery *QuerCheck= new TWTQuery (this);
     QuerCheck->Sql->Add("select hash_cod from sys_month_tbl where \
      mmgg=:dt_mg and dt_open is null");
     QuerCheck->ParamByName("dt_mg")->AsDateTime=StrToDate(EdMMGG->Text);
     QuerCheck->Open();
     if (!QuerCheck->Eof )
     { if (QuerCheck->FieldByName("hash_cod")->AsInteger!=StrToInt(EdHash->Text))
        {  for (int i=1; i<3;i++)
            {   //Hide();
                EdHash->Color= clYellow;
                //this->Show();
                Refresh();
                sleep(1);
                //Hide();
                EdHash->Color= clRed;
                //this->Show();
                Refresh();                
                sleep(1);
            };
            this->Activate();
            EdHash->Color= clAqua;
            ShowMessage("Неверный код на открытие месяца");
            ShortDateFormat="dd.mm.yyyy";
            Close();
            return;
        };
      QuerCheck->Sql->Clear();
      ShortDateFormat="dd-mm-yyyy";
      AnsiString selText=" "+ EdMemo->Text;
      QuerCheck->Sql->Add("select clopm(:dt_mg,:hashc,:reason )  ");
      QuerCheck->ParamByName("dt_mg")->AsDateTime=StrToDate(EdMMGG->Text);
      QuerCheck->ParamByName("hashc")->AsInteger=StrToInt(EdHash->Text);
      QuerCheck->ParamByName("reason")->AsString=selText;
     try {
       ShortDateFormat="yyyy-mm-dd";
       QuerCheck->ExecSql();
       ShowMessage("Период успешно закрыт!");
      }
      catch(EDatabaseError &e)
   {  ShowMessage("Ошибка  "+e.Message.SubString(8,200));
   };
 }
 else
 { ShowMessage("Ошибка: Нет записи о закрытии месяца.");}
   ShortDateFormat="dd.mm.yyyy";
   TWTQuery *QCh= new TWTQuery(this);
   QCh->Sql->Clear();
   QCh->Sql->Add("select value_ident from syi_sysvars_tmp where ident='mmgg'");
   QCh->Open();
  AnsiString  Period=QCh->FieldByName("value_ident")->AsString;
   Application->MainForm->Caption = "Енергия --- Юридические лица        Период  _______         "+Period ;
   Close();
}
//---------------------------------------------------------------------------
void __fastcall TFOpenMonth::BitBtn2Click(TObject *Sender)
{
Close();        
}
//---------------------------------------------------------------------------

