//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "fDemandPrint.h"
#include "main.h";
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPrintDemand *fPrintDemand;
//---------------------------------------------------------------------------
__fastcall TfPrintDemand::TfPrintDemand(TComponent* Owner)
        : TForm(Owner)
{

ZQBill->Database=TWTTable::Database;
ZQBillMeter->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------
void __fastcall TfPrintDemand::PrintBillAddReports(TObject *Sender)
{
PrintBill->Reports->Add(PrintBill_p1);

}
//---------------------------------------------------------------------------
void __fastcall TfPrintDemand::ShowBill(int id_doc)
{
//
   id_bill=id_doc;

   ZQBill->Close();


   ZQBill->ParamByName("doc")->AsInteger=id_bill;
   ZQBillMeter->ParamByName("doc")->AsInteger=id_bill;

   try
   {
    ZQBill->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка формирования счета1.");
    ZQBill->Close();
    return;
   }
   if (ZQBill->RecordCount!=0)
   {
   ZQBill->First();

     lBillNo->Caption=ZQBill->FieldByName("reg_num")->AsString;
     lContractNo->Caption=ZQBill->FieldByName("doc_num")->AsString;
     lContractDate->Caption=ZQBill->FieldByName("doc_dat")->AsString;
     lResName->Caption=ZQBill->FieldByName("resname")->AsString;
     lAbonName->Caption=ZQBill->FieldByName("abonname")->AsString;
     id_client=ZQBill->FieldByName("abonid")->AsInteger;
     lAbonAddr->Caption=ZQBill->FieldByName("abonaddr")->AsString;
     lResAddr->Caption=ZQBill->FieldByName("resaddr")->AsString;
       LInspect->Caption=ZQBill->FieldByName("represent_name")->AsString;

   TWTQuery *QPBill=new TWTQuery(this);
   QPBill->Sql->Add(" select max(date_end) as prev_date from acm_headindication_tbl \
                    where  date_end<:dat and id_client=:pid_client \
                    and idk_document in (300,310) \
    ");
     QPBill->ParamByName("dat")->AsDateTime=ZQBill->FieldByName("date_end")->AsDateTime;
     QPBill->ParamByName("pid_client")->AsInteger=ZQBill->FieldByName("abonid")->AsInteger;
     QPBill->Open();
     AnsiString pdate;
     if (QPBill->RecordCount!=0)
      pdate=QPBill->FieldByName("prev_date")->AsString;
      else
       pdate=ZQBill->FieldByName("date_end")->AsString;

     //lPeriod->Caption=" з     "+pdate+"   по   "+ZQBill->FieldByName("date_end")->AsString;
   };
   // Заполним временные таблици
   ZQBill->Close();

   // Теперь построчные данные
   try
   {

    ZQBillMeter->Open();

   }
   catch(...)
   {
    ShowMessage("Ошибка формирования счета3.");

    ZQBillMeter->Close();

    return;
   }


  PrintBill->Preview();
}
//---------------------------------------------------------------------------

void __fastcall TfPrintDemand::ChildBand_AbonBeforePrint(
      TQRCustomBand *Sender, bool &PrintBand)
{
// PrintBand=(StrToInt(DBTOwner->Caption)!=id_client);
PrintBand=(PrintBill_p1->DataSet->FieldByName("id_client")->AsInteger!=id_client);

}
//---------------------------------------------------------------------------

void __fastcall TfPrintDemand::GroupMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //PrintBand=(StrToInt(DBTTarif->Caption)!=0);
// PrintBand=(PrintBill_p1->DataSet->FieldByName("id_tarif")->AsInteger!=0);

}
//---------------------------------------------------------------------------



void __fastcall TfPrintDemand::QRSDMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //DBTZone->Enabled=(QRSDMeter->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintDemand::QRSDPointBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //QRDBText9->Enabled=(QRSDPoint->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintDemand::QRBand2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //QRDBText8->Enabled=(PrintBill_p2->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------


void __fastcall TfPrintDemand::PrintBill_p1BeforePrint(
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





