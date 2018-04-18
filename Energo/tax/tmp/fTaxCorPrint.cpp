//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h";
#include "fTaxCorPrint.h"
#include "fLogin.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfRepTaxCor *fRepTaxCor;
//---------------------------------------------------------------------------
__fastcall TfRepTaxCor::TfRepTaxCor(TComponent* Owner)
        : TForm(Owner)
{
 ZQTax->Database=TWTTable::Database;
 ZQTaxSumm->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------

void __fastcall TfRepTaxCor::ShowTaxCor(int id_doc, int print)
{
  ZQTax->Close();
  ZQTaxSumm->Close();

  ZQTax->ParamByName("doc")->AsInteger=id_doc;
  ZQTaxSumm->ParamByName("doc")->AsInteger=id_doc;

   try
   {
    ZQTax->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка формирования НН.");
    ZQTax->Close();
    return;
   }
   if (ZQTax->RecordCount!=0)
   {
     ZQTax->First();

     lCorNum->Caption=ZQTax->FieldByName("reg_num")->AsString;
     //lTaxDate->Caption=ZQTax->FieldByName("reg_date")->AsString;

     lTaxInfo->Caption="від "+ZQTax->FieldByName("tax_date")->AsString+
     " № "+ZQTax->FieldByName("tax_num")->AsString+
     " за договором від "+ZQTax->FieldByName("doc_dat")->AsString+
     " № "+ZQTax->FieldByName("doc_num")->AsString;

     lBottomText->Caption="Розрахунок коригування від "+ZQTax->FieldByName("reg_date")->AsString+
     " № "+ZQTax->FieldByName("reg_num")->AsString+
     " до податкової накладної від "+ZQTax->FieldByName("tax_date")->AsString+
     " № "+ZQTax->FieldByName("tax_num")->AsString+
     " отримав і зобов'язуюся включити суми коригування до реєстру отриманих та виданих податкових накладних та сум податкового кредиту і податкового зобов'язання";

     lResName->Caption=ZQTax->FieldByName("resname")->AsString;
     lAbonName->Caption=ZQTax->FieldByName("abonname")->AsString;

     AnsiString taxNum_res =FormatFloat("000000000000",ZQTax->FieldByName("taxNum_res")->AsFloat);

     QRLabel77->Caption= taxNum_res[1];
     QRLabel78->Caption= taxNum_res[2];
     QRLabel79->Caption= taxNum_res[3];
     QRLabel80->Caption= taxNum_res[4];
     QRLabel81->Caption= taxNum_res[5];
     QRLabel82->Caption= taxNum_res[6];
     QRLabel83->Caption= taxNum_res[7];
     QRLabel84->Caption= taxNum_res[8];
     QRLabel85->Caption= taxNum_res[9];
     QRLabel86->Caption= taxNum_res[10];
     QRLabel87->Caption= taxNum_res[11];
     QRLabel88->Caption= taxNum_res[12];

     //AnsiString taxNum_abon =FormatFloat("000000000000",ZQTax->FieldByName("taxNum_abon")->AsFloat);
      AnsiString taxNum_abon = ZQTax->FieldByName("taxNum_abon")->AsString;
     if (ZQTax->FieldByName("flag_taxpay")->AsInteger==1)
     {

      //lAbonSvidNum->Caption=ZQTax->FieldByName("SvidNum_abon")->AsString;
      lAbonSvidNum->Caption=FormatFloat("00000000",ZQTax->FieldByName("SvidNum_abon")->AsFloat);
     if ((taxNum_abon.Length())<12)
            taxNum_abon="  "+taxNum_abon;
      QRLabel89->Caption=taxNum_abon[1];
      QRLabel90->Caption=taxNum_abon[2];
      QRLabel91->Caption=taxNum_abon[3];
      QRLabel92->Caption=taxNum_abon[4];
      QRLabel93->Caption=taxNum_abon[5];
      QRLabel94->Caption=taxNum_abon[6];
      QRLabel95->Caption=taxNum_abon[7];
      QRLabel96->Caption=taxNum_abon[8];
      QRLabel97->Caption=taxNum_abon[9];
      QRLabel98->Caption=taxNum_abon[10];
      QRLabel99->Caption=taxNum_abon[11];
      QRLabel100->Caption=taxNum_abon[12];
     }
     else
     {
      lAbonSvidNum->Caption="XXXXXXXX";

      QRLabel89->Caption="X";
      QRLabel90->Caption="X";
      QRLabel91->Caption="X";
      QRLabel92->Caption="X";
      QRLabel93->Caption="X";
      QRLabel94->Caption="X";
      QRLabel95->Caption="X";
      QRLabel96->Caption="X";
      QRLabel97->Caption="X";
      QRLabel98->Caption="X";
      QRLabel99->Caption="X";
      QRLabel100->Caption="X";
     }

     QRLabel76->Caption = ZQTax->FieldByName("represent_name")->AsString;

     lAbonAddr->Caption=ZQTax->FieldByName("abonaddr")->AsString;
     lResAddr->Caption=ZQTax->FieldByName("resaddr")->AsString;

     lResPhone->Caption=ZQTax->FieldByName("resphone")->AsString;
     lAbonPhone->Caption=ZQTax->FieldByName("abonphone")->AsString;

//     lResSvidNum->Caption=ZQTax->FieldByName("SvidNum_res")->AsString;
     lResSvidNum->Caption=FormatFloat("00000000",ZQTax->FieldByName("SvidNum_res")->AsFloat);

     lContract->Caption="Згідно договору № "+ZQTax->FieldByName("doc_num")->AsString+
     " від "+ZQTax->FieldByName("doc_dat")->AsString;

//     lReason->Caption="зменшення бази оподаткування";
     lReason->Caption=ZQTax->FieldByName("reason")->AsString;
     lDateStr->Caption=ZQTax->FieldByName("reg_date")->AsString;

     int id_client=ZQTax->FieldByName("abonid")->AsInteger;

   };
   ZQTax->Close();


   // Теперь построчные данные
   try
   {
    ZQTaxSumm->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка формирования НН.");
    ZQTaxSumm->Close();
    return;
   }



  if (print ==1 ) PrintTax->Print();
  else PrintTax->Preview();

}
//---------------------------------------------------------------------------
void __fastcall TfRepTaxCor::QRBand3BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 if (ZQTaxSumm->FieldByName("cor_tariff")->AsFloat == 0) QRDBText4->Enabled=false;
 else QRDBText4->Enabled=true;

 if (ZQTaxSumm->FieldByName("tariff")->AsFloat == 0) QRDBText7->Enabled=false;
 else QRDBText7->Enabled=true;

}
//---------------------------------------------------------------------------

