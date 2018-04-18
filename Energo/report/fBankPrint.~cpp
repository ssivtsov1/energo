//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fBankPrint.h"
#include "main.h";
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPrintBank *fPrintBank;
//---------------------------------------------------------------------------
__fastcall TfPrintBank::TfPrintBank(TComponent* Owner)
        : TForm(Owner)
{

ZQHead->Database=TWTTable::Database;
ZQPay->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------
void __fastcall TfPrintBank::PrintBillAddReports(TObject *Sender)
{
PrintBill->Reports->Add(PrintPay);

}
//---------------------------------------------------------------------------
void __fastcall TfPrintBank::ShowBill(int id_doc)
{
//
   int id_head=id_doc;

   ZQHead->Close();


   ZQHead->ParamByName("doc")->AsInteger=id_head;
   ZQPay->ParamByName("doc")->AsInteger=id_head;

   try
   {
    ZQHead->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка ");
    ZQHead->Close();
    return;
   }
   if (ZQHead->RecordCount!=0)
   {
     ZQHead->First();
      lResName->Caption=ZQHead->FieldByName("resname")->AsString;
      lResAddr->Caption=ZQHead->FieldByName("resaddr")->AsString;

     lBillNo->Caption=ZQHead->FieldByName("reg_num")->AsString;
     lData->Caption= ZQHead->FieldByName("reg_date")->AsString;
     lAccount->Caption=ZQHead->FieldByName("account")->AsString;
     lMFO->Caption=ZQHead->FieldByName("mfo")->AsString;
     lBank->Caption=ZQHead->FieldByName("bank")->AsString;
     //lSaldoStart-Caption=ZQHead->FieldByName("saldostart")->AsString;

   };
   // Заполним временные таблици
   ZQHead->Close();

   // Теперь построчные данные
   try
   {

    ZQPay->Open();

   }
   catch(...)
   {
    ShowMessage("Ошибка формирования платежей.");

    ZQPay->Close();

    return;
   }


  PrintPay->Preview();
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::ChildBand_AbonBeforePrint(
      TQRCustomBand *Sender, bool &PrintBand)
{
// PrintBand=(StrToInt(DBTOwner->Caption)!=id_client);
//PrintBand=(PrintBill_p1->DataSet->FieldByName("id_client")->AsInteger!=id_client);

}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::GroupMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //PrintBand=(StrToInt(DBTTarif->Caption)!=0);
// PrintBand=(PrintBill_p1->DataSet->FieldByName("id_tarif")->AsInteger!=0);

}
//---------------------------------------------------------------------------



void __fastcall TfPrintBank::QRSDMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //DBTZone->Enabled=(QRSDMeter->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::QRSDPointBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //QRDBText9->Enabled=(QRSDPoint->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::QRBand2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //QRDBText8->Enabled=(PrintBill_p2->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------


void __fastcall TfPrintBank::PrintPayBeforePrint(
      TCustomQuickRep *Sender, bool &PrintReport)
{
/*QRLabel43_Left =QRLabel43->Left;
QRDBText14_Left=QRDBText14->Left;
QRLabel11_Left =QRLabel11->Left;
QRDBText15_Left=QRDBText15->Left;
QRDBText10_Left=QRDBText10->Left;
QRLabel32_Left =QRLabel32->Left;
QRDBText13_Left=QRDBText13->Left;
*/
}
//---------------------------------------------------------------------------





void __fastcall TfPrintBank::QRGroup1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
// PrintBand=(StrToInt(DBTOwner->Caption)!=id_client);
int i=PrintPay->DataSet->FieldByName("sign_pay")->AsInteger;
 ssign=i;
 all_val1=0;
  all_tax1=0;
  all_pay1=0;
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::DetailBand1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{

 all_val1=all_val1+PrintPay->DataSet->FieldByName("val")->AsFloat;
 all_tax1=all_tax1+PrintPay->DataSet->FieldByName("tax")->AsFloat;
 all_pay1=all_pay1+PrintPay->DataSet->FieldByName("pay")->AsFloat;
 /*ALL_VAL=all_val1+PrintPay->DataSet->FieldByName("val")->AsFloat;
 all_tax1=all_tax1+PrintPay->DataSet->FieldByName("tax")->AsFloat;
 all_pay1=all_pay1+PrintPay->DataSet->FieldByName("pay")->AsFloat;
   */
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBank::QRBand44BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 lVal->Caption=FloatToStrF(all_val1,ffNumber,12,2);
 lTax->Caption=FloatToStrF(all_tax1,ffNumber,12,2);
 lPay->Caption=FloatToStrF(all_pay1,ffNumber,12,2);
}
//---------------------------------------------------------------------------







