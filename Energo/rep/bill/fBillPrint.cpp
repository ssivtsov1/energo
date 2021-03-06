//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "fBillPrint.h"
#include "xlcClasses.hpp"
#include "xlReport.hpp"

//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma resource "*.dfm"
TfPrintBill *fPrintBill;

 float  SumDemand;
 float  SumLosts1;
 float  SumLosts2;
 float  SumTovar;

//---------------------------------------------------------------------------
__fastcall TfPrintBill::TfPrintBill(TComponent* Owner)
        : TForm(Owner)
{

ZQBill->Database=TWTTable::Database;
ZQBillSumm->Database=TWTTable::Database;
ZQBillSummR->Database=TWTTable::Database;
ZQBillSummCor->Database=TWTTable::Database;
ZQBillDemand->Database=TWTTable::Database;
ZQPrepare->Database=TWTTable::Database;
ZQBillPoint->Database=TWTTable::Database;
ZQBillMeter->Database=TWTTable::Database;
ZQBillSumm2krp->Database=TWTTable::Database;

ZQBillSumm2kr_area_2013->Database=TWTTable::Database;
ZQBillSumm2kr_point_2013->Database=TWTTable::Database;

ZQuery = new TWTQuery(Application);
ZQuery->Options<< doQuickOpen;
ZQuery->RequestLive=false;
ZQuery->CachedUpdates=false;

}
//---------------------------------------------------------------------------
void __fastcall TfPrintBill::PrintBillAddReports(TObject *Sender)
{
 PrintBill->Reports->Add(PrintBill_p1);

 if (ident == "bill_2krd")
 {
  if (mmgg < TDateTime(2013,1,1) )  //2-�� �� �������� � �����
  {
    PrintBill->Reports->Add(PrintBill_p2krd);
  }
  else   //�� ���������
  {
    PrintBill->Reports->Add(PrintBill_p2kr2013);
  }

  return;
 }

 if (ident == "bill_2krn")
 {
  PrintBill->Reports->Add(PrintBill_p2kr2013_sum);
  return;
 }

 if (ident == "bill_2krp")
 {
  PrintBill->Reports->Add(PrintBill_p2krp);
  return;
 }

 if (ident == "bill_avans")
 {
  PrintBill->Reports->Add(PrintBill_p2av);
  return;
 }

 if (ident == "bill_cors")
 {
  PrintBill->Reports->Add(PrintBill_p2cor);
  return;
 }

 if ((ident == "bill_addp")||(ident == "bill_act")||(ident == "bill_div"))
 {
  if ((kind==520)||(kind==524))
    PrintBill->Reports->Add(PrintBill_p2krd);
  else
  {
    PrintBill->Reports->Add(PrintBill_p2cor);

    if (ident == "bill_div")
    {
      QRGroup5->Enabled = false;
      QRDBText42->Enabled = false;
    }
    else
    {
      QRGroup5->Enabled = true;
      QRDBText42->Enabled = true;      
    }
  }
  return;
 }

 if (ident == "bill_temp")
 {
  PrintBill->Reports->Add(PrintBill_p2tmp);
  return;
 }
 if ((kind==10)||(kind==101)) PrintBill->Reports->Add(PrintBill_p2a);
 // if ((kind==10)||(kind==11)||(kind==101)) PrintBill->Reports->Add(PrintBill_p2a);
  if ((kind==20)||(kind==201)) PrintBill->Reports->Add(PrintBill_p2r);

}
//---------------------------------------------------------------------------
void __fastcall TfPrintBill::ShowBill(int id_doc)
{
//
  // ShowMessage(" - - ������ - -");
   id_bill=id_doc;
   //kind = id_pref;

   ZQBill->Close();
   ZQBillSumm->Close();
   ZQBillSummR->Close();
   ZQBillSummCor->Close();
   ZQBillSumm2krp->Close();
   ZQBillMeter->Close();
   ZQBillPoint->Close();
   ZQBillDemand->Close();
   ZQPrepare->Close();
   ZQBillSumm2kr_area_2013->Close();
   ZQBillSumm2kr_point_2013->Close();


   ColumnHeaderBand1->Enabled = true;
   QRGroup2->Enabled = true;
   ChildBand_Abon->Enabled = true;
   DetailBand1->Enabled = true;
   QRSDMeter->Enabled = true;
   QRSDPoint->Enabled = true;
   SummaryBand2->Enabled = true;

   ZQBill->ParamByName("doc")->AsInteger=id_bill;
   ZQBillSumm->ParamByName("doc")->AsInteger=id_bill;
   ZQBillSummR->ParamByName("doc")->AsInteger=id_bill;
   ZQBillSummCor->ParamByName("doc")->AsInteger=id_bill;
//   ZQBillSumm->MacroByName("ttt")->AsString="bs.demand_val::numeric";
   ZQBillDemand->ParamByName("doc")->AsInteger=id_bill;
   ZQBillPoint->ParamByName("doc")->AsInteger=id_bill;
   ZQBillMeter->ParamByName("doc")->AsInteger=id_bill;
   ZQBillSumm2krp->ParamByName("doc")->AsInteger=id_bill;

   ZQBillSumm2kr_area_2013->ParamByName("doc")->AsInteger=id_bill;
   ZQBillSumm2kr_point_2013->ParamByName("doc")->AsInteger=id_bill;

   try
   {
    ZQBill->Open();
   }
   catch(...)
   {
    ShowMessage("������ ������������ �����1.");
    ZQBill->Close();
    return;
   }
   if (ZQBill->RecordCount!=0)
   {
     ZQBill->First();

     kind = ZQBill->FieldByName("id_pref")->AsInteger;
     ident = ZQBill->FieldByName("ident")->AsString;
     mmgg = ZQBill->FieldByName("mmgg")->AsDateTime;

     if (kind==110)
     {
      TransitBillXL(id_bill);
      ZQBill->Close();
      return;
     }

     if (kind==120)
     {
      InformBillXL(id_bill);
      ZQBill->Close();
      return;
     }

     lBillNo->Caption=ZQBill->FieldByName("reg_num")->AsString;
//     lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;

     if (ZQBill->FieldByName("doc_num_tend")->AsString.Trim()!="")
     {
      lContract->Caption="����� �������� ��� �������� ������ �� �������� ����� � "+ZQBill->FieldByName("doc_num_tend")->AsString+ " �� "+
            ZQBill->FieldByName("doc_dat_tend")->AsString;
     }
     else
     {
      lContract->Caption="����� �������� � "+ZQBill->FieldByName("doc_num")->AsString+ " �� "+
            ZQBill->FieldByName("doc_dat")->AsString;
     }

     //lContractNo->Caption=ZQBill->FieldByName("doc_num")->AsString;
     //lContractDate->Caption=ZQBill->FieldByName("doc_dat")->AsString;

     lResName->Caption=ZQBill->FieldByName("resname")->AsString;
     lResBank->Caption=ZQBill->FieldByName("bankname")->AsString;
     lResMFO->Caption=AnsiString("��� ")+ZQBill->FieldByName("mfo_self")->AsString;
     lResAcc->Caption= AnsiString("� ")+ZQBill->FieldByName("account_self")->AsString;
     lResPhone->Caption=ZQBill->FieldByName("resphone")->AsString;
     lAbonPhone->Caption=ZQBill->FieldByName("abonphone")->AsString;

     lCod->Caption=ZQBill->FieldByName("code")->AsString;

     lAbonKode->Caption=ZQBill->FieldByName("abon_okpo_num")->AsString.Trim();
     try
     {

     lResKode->Caption=FormatFloat("00000000",ZQBill->FieldByName("okpo_num")->AsFloat);
     }  catch(...) {};


     lAbonName->Caption=ZQBill->FieldByName("abonname")->AsString;
     id_client=ZQBill->FieldByName("abonid")->AsInteger;
     ZQBillPoint->ParamByName("client")->AsInteger=id_client;
     lAbonAddr->Caption=ZQBill->FieldByName("abonaddr")->AsString;

     lSum->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDS->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDS->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     lSumR->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDSR->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDSR->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     lSumAv->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDSAv->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDSAv->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     lSumCor->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDSCor->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDSCor->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     lSumTmp->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDSTmp->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);

     lSumAndNDSTmp->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     qrlPosada->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName->Caption =ZQBill->FieldByName("represent_name")->AsString;

     lSum_2kr->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDS_2kr->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDS_2kr->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
        ZQBill->FieldByName("value")->AsFloat);

     lSum_2kr_sum->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lSum_2kr_sum2->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);

     if (mmgg < TDateTime(2014,1,1) )
     {
        lNDS_2kr_sum->Enabled = true;
        lNDS_2kr_sum_label->Enabled = true;
        lNDS_2kr_sum->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     }
     else
     {
        lNDS_2kr_sum->Enabled = false;
        lNDS_2kr_sum_label->Enabled = false;
     }

     lSumAndNDS_2kr_sum->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
        ZQBill->FieldByName("value")->AsFloat);


     qrlPhoneExec->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec2->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec3->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec4->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec5->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec6->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec7->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec8->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();
     qrlPhoneExec9->Caption =ZQBill->FieldByName("usrphone")->AsString.Trim();

     if(qrlPhoneExec->Caption=="")
     {
      qrlPhoneExecLabel->Enabled = false;
      qrlPhoneExecLabel2->Enabled = false;
      qrlPhoneExecLabel3->Enabled = false;
      qrlPhoneExecLabel4->Enabled = false;
      qrlPhoneExecLabel5->Enabled = false;
      qrlPhoneExecLabel6->Enabled = false;
      qrlPhoneExecLabel7->Enabled = false;
      qrlPhoneExecLabel8->Enabled = false;
      qrlPhoneExecLabel9->Enabled = false;
     }
     else
     {
      qrlPhoneExecLabel->Enabled = true;
      qrlPhoneExecLabel2->Enabled = true;
      qrlPhoneExecLabel3->Enabled = true;
      qrlPhoneExecLabel4->Enabled = true;
      qrlPhoneExecLabel5->Enabled = true;
      qrlPhoneExecLabel6->Enabled = true;
      qrlPhoneExecLabel7->Enabled = true;
      qrlPhoneExecLabel8->Enabled = true;
      qrlPhoneExecLabel9->Enabled = true;
     }

     qrlPosada2->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName2->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada3->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName3->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada4->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName4->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada5->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName5->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada6->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName6->Caption =ZQBill->FieldByName("represent_name")->AsString;

     qrlPosada7->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName7->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada8->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName8->Caption =ZQBill->FieldByName("represent_name")->AsString;
     qrlPosada9->Caption =ZQBill->FieldByName("posname")->AsString;
     qrlUserName9->Caption =ZQBill->FieldByName("represent_name")->AsString;


//     lChnoeAddr->Caption=ZQBill->FieldByName("chnoeaddr")->AsString;
     lResAddr->Caption=ZQBill->FieldByName("resaddr")->AsString;
//     lChnoeName->Caption=ZQBill->FieldByName("chnoename")->AsString;
     lTax_num->Caption=ZQBill->FieldByName("tax_num")->AsString;
     lLicens_num->Caption=ZQBill->FieldByName("licens_num")->AsString;

     if (ZQBill->FieldByName("last_demand")->AsFloat > 0)
     {
       lPercent->Caption = FormatFloat("0.00",ZQBill->FieldByName("demand_val")->AsFloat*100/ZQBill->FieldByName("last_demand")->AsFloat)+"%";
     }
     else
      lPercent->Caption = "";

      qrlWarning1->Caption ="� ��� �������� ������� �������� "+ZQBill->FieldByName("day_pay_bill")->AsString +" ���������� ���� ������ ���� ������ ���� ���������� ����������������� ������ ���������� �������� � �. 7.5 (3) ������ ������������ ����������� ����㳺�.";
      qrlWarning2->Caption = qrlWarning1->Caption;
      qrlWarning3->Caption = qrlWarning1->Caption;
   }
   else
   {ShowMessage("������ ������� ��������� �����");
    return;
   };

   if ((kind==901)||(kind==902))
   {
    //��� ���� � �������� ������ ���� ����� ������ �����
    ShowMessage("����������� '������ ���������' ��� ������ ���������� � ���� � ��������.");    
    ZQBill->Close();
    return;
   }

   if ((kind==10)||(kind==11)||(kind==101))  {
        QRLKindEnergy->Caption= "�� ������� �������������";
        if (kind==11) QRLKindEnergy->Caption= QRLKindEnergy->Caption+" (�������)";
        QRLabel21->Caption="������.�� ��������� ����";
        QRLabel22->Caption="������. �� �.����� ����";
        QRLabel17->Caption="������, ����";
        QRLabel83->Caption="�������� ������, ����";
        QRLabel20->Caption="�����. ������, ����";
        lFormPay->Caption="�������� ������� �� ����������� ������� ������������";
    }

   if ((kind==20)||(kind==201)) {
        QRLKindEnergy->Caption= "�� ���������� ��������� �����������㳿";
        QRLabel21->Caption="������.�� ��������� �����";
        QRLabel22->Caption="������. �� �.����� �����";
        QRLabel17->Caption="������, �����";
        QRLabel83->Caption="�������� ������, �����";
        QRLabel20->Caption=" ������ ������., �����";
        lFormPay->Caption="�������� �������";
    }

   if (ident == "bill_avans") {

    TitleChild2->Enabled = false;
    TitleChild1->Enabled = true;

    if (ZQBill->FieldByName("dat_e")->AsDateTime < TDateTime(2006,1,1))
        lBillDate->Caption=ZQBill->FieldByName("dat_e")->AsString;
    else
        lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;

    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;

    lAvans->Enabled = true;
    lAvans->Caption="������ ������� ����������� ���������� �����������㳿 � ����� ";
    lAvansMonth->Enabled = true;
    lAvansMonth->Caption=FormatDateTime("mmmm yyyy",ZQBill->FieldByName("mmgg_bill")->AsDateTime);
   }

   if (((ident == "bill_addp")||(ident == "bill_act")||(ident == "bill_div") ) && (kind!=520)&& (kind!=524))
   {
    TitleChild2->Enabled = false;
    TitleChild1->Enabled = true;

  //  lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;
    if (ZQBill->FieldByName("dat_e")->AsDateTime < TDateTime(2006,1,1))
        lBillDate->Caption=ZQBill->FieldByName("dat_e")->AsString;
    else
        lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;

    // if Empty(lBillDate->Caption )
     // lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;
    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;

    lAvans->Enabled = true;
    // ��������� ��� ��� �������� �� ��� ��������� �� ���������
       lAvans->Caption="������������� ���������� �� ����� ";
   // ���� ����� �������������� �� ������ �� ��������
   if ((ident== "bill_div" ) )
         lAvans->Caption=" ";

    lAvansMonth->Enabled = false;
   }

   if ((ident == "bill_2krn")||(ident == "bill_2krd")||(((ident == "bill_addp")||(ident == "bill_div")) && ((kind==520)||(kind==524)) ))
   {
    lBillDate2->Caption=ZQBill->FieldByName("reg_date")->AsString;
    lBillNo2->Caption=ZQBill->FieldByName("reg_num")->AsString;

    if (mmgg < TDateTime(2013,1,1) )  //2-�� �� �������� � �����
    {

     lDemand2krd->Caption=ZQBill->FieldByName("demand_val")->AsString;
     lTariff2krd->Caption=FormatFloat("0.0000",ZQBill->FieldByName("value")->AsFloat/ZQBill->FieldByName("demand_val")->AsInteger);

     lSum2krd->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
     lNDS2krd->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat);
     lSumAndNDS2krd->Caption=FormatFloat("0.00",ZQBill->FieldByName("value_tax")->AsFloat+
     ZQBill->FieldByName("value")->AsFloat);

     QRLActType->Caption = "�� ����������  ���������� ����㳿 ����� �������� ��������";

     // lActNum->Caption = "A2D"+ZQBill->FieldByName("code")->AsString+"_"+
     //   FormatDateTime("mm-yyyy",ZQBill->FieldByName("mmgg")->AsDateTime);
     // lActDate->Caption = lBillDate2->Caption;
    }
    TitleChild1->Enabled = false;
    TitleChild2->Enabled = true;

    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;
   }

//   if ((ident == "bill_2krd")||((ident == "bill_addp") && (kind==520)))

   if (ident == "bill_2krp")
   {
    lBillDate2->Caption=ZQBill->FieldByName("reg_date")->AsString;
    lBillNo2->Caption=ZQBill->FieldByName("reg_num")->AsString;

//    lSum2krp->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);
    lSum2krp2->Caption=FormatFloat("0.00",ZQBill->FieldByName("value")->AsFloat);

    TitleChild1->Enabled = false;
    TitleChild2->Enabled = true;

    QRLActType->Caption = "�� ����������� ��������� ������� ���������� ���������� ��������� ";

    AnsiString sqlstr="select reg_num, reg_date from acm_headpowerindication_tbl where id_doc = :doc ;";
    ZQuery->Sql->Clear();
    ZQuery->Sql->Add(sqlstr);
    ZQuery->ParamByName("doc")->AsInteger=ZQBill->FieldByName("id_ind")->AsInteger;

    try
    {
     ZQuery->Open();
    }
    catch(EDatabaseError &e)
    {
     ShowMessage("������ "+e.Message.SubString(8,200));
     ZQuery->Close();
     delete ZQuery;
     return;
    }
   ZQuery->First();
   //lActNum->Caption = ZQuery->FieldByName("reg_num")->AsString;
   //lActDate->Caption = ZQuery->FieldByName("reg_date")->AsString;
   ZQuery->Close();


    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;
   }

   if (ident == "bill_cors")
   {
    TitleChild2->Enabled = false;
    TitleChild1->Enabled = true;

    lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;
    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;

    lAvans->Enabled = true;
    lAvans->Caption="����������� ���� ";
    lAvansMonth->Enabled = false;
   }

   if (ident == "bill_temp")
   {
    TitleChild2->Enabled = false;
    TitleChild1->Enabled = true;

    if (ZQBill->FieldByName("dat_e")->AsDateTime < TDateTime(2006,1,1))
        lBillDate->Caption=ZQBill->FieldByName("dat_e")->AsString;
    else
        lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;

    ColumnHeaderBand1->Enabled = false;
    QRGroup2->Enabled = false;
    ChildBand_Abon->Enabled = false;
    DetailBand1->Enabled = false;
    QRSDMeter->Enabled = false;
    QRSDPoint->Enabled = false;
    SummaryBand2->Enabled = false;

    lAvans->Enabled = true;
    lAvans->Caption="��������� ����������.";
    lAvansMonth->Enabled = false;
   }

   if (ident == "bill")
   {
    TitleChild2->Enabled = false;
    TitleChild1->Enabled = true;

    lAvans->Enabled = false;
    lAvansMonth->Enabled = false;

    if (ZQBill->FieldByName("dat_e")->AsDateTime < TDateTime(2006,1,1))
        lBillDate->Caption=ZQBill->FieldByName("dat_e")->AsString;
    else
        lBillDate->Caption=ZQBill->FieldByName("reg_date")->AsString;


    // �������� ��������� �������
    ZQPrepare->ParamByName("doc")->AsInteger=id_bill;
    ZQPrepare->ParamByName("dat")->AsDateTime=ZQBill->FieldByName("reg_date")->AsDateTime;
    ZQBill->Close();

    try
    {
     ZQPrepare->ExecSql();
    }
    catch(...)
    {
     ShowMessage("������ ������������ �����2.");
     return;
    }
   }
   // ������ ���������� ������

   SumDemand=0;
   SumLosts1=0;
   SumLosts2=0;
   SumTovar=0;


   try
   {

    if ((ident == "bill_addp")||(ident == "bill_div")||(ident == "bill_cors")||(ident == "bill_temp")||(ident == "bill_act"))
       ZQBillSummCor->Open();
    else
    {
     if ((kind==10)||(kind==101)||(ident == "bill_avans")) ZQBillSumm->Open();
     if ((kind==20)||(kind==201)) ZQBillSummR->Open();
    }
                                    
    if (ident == "bill_2krp")
     {
       ZQBillSumm2krp->ParamByName("mmgg")->AsDateTime=ZQBill->FieldByName("dat_e")->AsDateTime;
       ZQBillSumm2krp->Open();
     }

    if ((ident == "bill_2krd")&&(mmgg >= TDateTime(2013,1,1)))
     {
       ZQBillSumm2kr_area_2013->ParamByName("mmgg")->AsDateTime=mmgg;
       ZQBillSumm2kr_point_2013->ParamByName("mmgg")->AsDateTime=mmgg;

       ZQBillSumm2kr_area_2013->Open();
       ZQBillSumm2kr_point_2013->Open();
     }

    if (ident == "bill_2krn")
     {
       ZQBillSumm2kr_area_2013->ParamByName("mmgg")->AsDateTime=mmgg;
       //ZQBillSumm2kr_point_2013->ParamByName("mmgg")->AsDateTime=mmgg;

       ZQBillSumm2kr_area_2013->Open();
      // ZQBillSumm2kr_point_2013->Open();
     }

    if (ident == "bill") {
     ZQBillDemand->Open();
     ZQBillPoint->Open();
     ZQBillMeter->Open();
    }

   }
   catch(...)
   {
    ShowMessage("������ ������������ �����3.");
    if ((ident == "bill_addp")||(ident == "bill_div")||(ident == "bill_cors")||(ident == "bill_temp")||(ident == "bill_act")) ZQBillSummCor->Close();
    else
    {
     if ((kind==10)||(kind==101)||(ident == "bill_avans")) ZQBillSumm->Close();
     if ((kind==20)||(kind==201)) ZQBillSummR->Close();
    }

    if (ident == "bill") {
     ZQBillDemand->Close();
     ZQBillPoint->Close();
     ZQBillMeter->Close();                                                
    }
    return;
   }


  PrintBill->Preview();
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::ChildBand_AbonBeforePrint(
      TQRCustomBand *Sender, bool &PrintBand)
{
// PrintBand=(StrToInt(DBTOwner->Caption)!=id_client);
PrintBand=(PrintBill_p1->DataSet->FieldByName("id_client")->AsInteger!=id_client);

}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::GroupMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 //PrintBand=(StrToInt(DBTTarif->Caption)!=0);
// PrintBand=(PrintBill_p1->DataSet->FieldByName("id_tarif")->AsInteger!=0);

}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::QRGroup2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
switch ( PrintBill_p1->DataSet->FieldByName("level")->AsInteger ) {
  case 0 :{QRLFlag->Caption="-";}; break;
  case 1 :{QRLFlag->Caption="- -";}; break;
  case 2 :{QRLFlag->Caption="- - -";}; break;
  case 3 :{QRLFlag->Caption="- - - -";}; break;
  default :QRLFlag->Caption="- - - -" ;
}

if ( PrintBill_p1->DataSet->FieldByName("groundname")->AsString =="" )
 lAreaLabel->Enabled=false;
else
 lAreaLabel->Enabled=true;

//QRLFlag->Left=TfPrintBill::QRLFlag->Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRLabel43->Left=QRLabel43_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRDBText14->Left=QRDBText14_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
lAreaLabel->Left=QRLabel11_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRDBText15->Left=QRDBText15_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRDBText10->Left=QRDBText10_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRLabel32->Left=QRLabel32_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
QRDBText13->Left=QRDBText13_Left+PrintBill_p1->DataSet->FieldByName("level")->AsInteger*20;
}
//---------------------------------------------------------------------------


void __fastcall TfPrintBill::QRSDMeterBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 DBTZone->Enabled=(QRSDMeter->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::QRSDPointBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 QRDBText9->Enabled=(QRSDPoint->DataSet->FieldByName("id_zone")->AsInteger!=0);

// if (ZQBillDemand->FieldByName("level")->AsInteger==0)
 if (PrintBill_p1->DataSet->FieldByName("id_client")->AsInteger==id_client)
 {
  SumDemand+=QRSDPoint->DataSet->FieldByName("demand")->AsFloat;

  if (QRSDPoint->DataSet->FieldByName("losts")->AsFloat>=0)
   SumLosts1+=QRSDPoint->DataSet->FieldByName("losts")->AsFloat;
  else
   SumLosts2-=QRSDPoint->DataSet->FieldByName("losts")->AsFloat;

  SumTovar+=QRSDPoint->DataSet->FieldByName("sum_val")->AsFloat;
 }
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::QRBand2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
// QRDBText8->Enabled=(PrintBill_p2a->DataSet->FieldByName("id_zone")->AsInteger!=0);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::PrintBill_p1BeforePrint(
      TCustomQuickRep *Sender, bool &PrintReport)
{
QRLabel43_Left =QRLabel43->Left;
QRDBText14_Left=QRDBText14->Left;
QRLabel11_Left =lAreaLabel->Left;
QRDBText15_Left=QRDBText15->Left;
QRDBText10_Left=QRDBText10->Left;
QRLabel32_Left =QRLabel32->Left;
QRDBText13_Left=QRDBText13->Left;
}
//---------------------------------------------------------------------------


void __fastcall TfPrintBill::DetailBand1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
if (PrintBill_p1->DataSet->FieldByName("kind_energy")->AsInteger==2)
 QRLEnergy->Caption="���������� ��������� ����㳿 ";

if (PrintBill_p1->DataSet->FieldByName("kind_energy")->AsInteger==4)
 QRLEnergy->Caption="��������� ��������� ����㳿, ���������� �� k=3";

PrintBand=(PrintBill_p1->DataSet->FieldByName("kind_energy")->AsInteger!=1);
}
//---------------------------------------------------------------------------

void __fastcall TfPrintBill::SummaryBand2BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
//
  lSumDemand->Caption = FormatFloat("0",SumDemand);
  lSumLosts1->Caption = FormatFloat("0",SumLosts1);
  lSumLosts2->Caption = FormatFloat("0",SumLosts2);
  lSumTovar->Caption = FormatFloat("0",SumTovar);

}
//---------------------------------------------------------------------------



void __fastcall TfPrintBill::TitleBand1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
   SumDemand=0;
   SumLosts1=0;                                    
   SumLosts2=0;
   SumTovar=0;
       
}
//---------------------------------------------------------------------------
void __fastcall TfPrintBill::TransitBillXL(int id_doc)
{
 TxlReport* xlReport = new TxlReport(this);

                                                    
  AnsiString sqlstr="select b.reg_num, b.dat_e,b.reg_date,b.mfo_self,b.account_self,b.id_pref,bank.name as bankname, b.demand_val, \
  b.value, b.value_tax,abon.name as abonname, abon.code, abon.short_name, \
  abonpar.doc_num, abonpar.doc_dat, abonpar.okpo_num as abon_okpo_num, \
  users.represent_name, ip.name as posname, \
  b.mmgg,b.mmgg_bill, bs1.demand_val1, bs2.demand_val2, bs1.sum_val1, bs2.sum_val2 \
  from acm_bill_tbl as b \
  left join cmi_bank_tbl as bank on (bank.id = b.mfo_self) \
  left join clm_position_tbl as users on (users.id = b.id_person) \
  left join cli_position_tbl as ip  on (ip.id = users.id_position) \
  left join clm_client_tbl as abon on (b.id_client = abon.id) \
  left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id) \
  left join (select bs.id_doc, sum(demand_val)::::numeric as demand_val1, sum(sum_val)::::numeric as sum_val1 \
  from acd_billsum_tbl as bs \
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) \
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) \
  where bs.id_doc = :doc and tcl.ident = 'tcl1' \
  group by bs.id_doc ) as bs1 on (bs1.id_doc = b.id_doc) \
  left join (select bs.id_doc, sum(demand_val)::::numeric as demand_val2, sum(sum_val)::::numeric as sum_val2 \
  from acd_billsum_tbl as bs \
  join aci_tarif_tbl as tar on (tar.id=bs.id_tariff) \
  join eqi_classtarif_tbl as tcl on (tar.id_classtarif=tcl.id) \
  where bs.id_doc = :doc and tcl.ident = 'tcl2' \
  group by bs.id_doc ) as bs2 on (bs2.id_doc = b.id_doc) \
  where b.id_doc = :doc \
  and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <= coalesce(b.dat_e, b.reg_date));";

  /*
  'ϳ������: ������� � '||abonpar.doc_num||' �� '|| to_char(abonpar.doc_dat, 'DD.MM.YYYY') as doc, \
  '������� � '||b.reg_num||' �� '|| to_char(b.reg_date, 'DD.MM.YYYY') as bill, \
  '������ �� ������� � �������� ��.����㳿 ��� '||abon.short_name as comment \
  */
  //bs.demand_val1,bs.demand_val2,bs.sum_val1, bs.sum_val2

  ZQuery->Close();
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("doc")->AsInteger=id_bill;

  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }

  xlReport->XLSTemplate = "XL\\bill_tranzit.xls";

  TxlDataSource *Dsr;

  TxlReportParam *Param;
  xlReport->DataSources->Clear();
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQuery;
  Dsr->Alias =  "ZQXLReps";


  //  Dsr->Range = "Range";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="doc";
  Param=xlReport->Params->Add();
  Param->Name="bill";
  Param=xlReport->Params->Add();
  Param->Name="comment";
//  Param=xlReport->Params->Add();
//  Param->Name="linfo";

  xlReport->ParamByName["doc"]->Value = "ϳ������: ������� � "+ ZQuery->FieldByName("doc_num")->AsString+" �� "+
    FormatDateTime("dd.mm.yyyy ",ZQuery->FieldByName("doc_dat")->AsDateTime);

  xlReport->ParamByName["bill"]->Value = "������� �  "+ ZQuery->FieldByName("reg_num")->AsString+" �� "+
    FormatDateTime("dd.mm.yyyy ",ZQuery->FieldByName("reg_date")->AsDateTime);

  xlReport->ParamByName["comment"]->Value = "������ �� ������� � �������� ��.����㳿 ��� "+ ZQuery->FieldByName("short_name")->AsString;

  xlReport->Report();

  delete xlReport;
}
//---------------------------------------------------------------------------
void __fastcall TfPrintBill::InformBillXL(int id_doc)
{
 TxlReport* xlReport = new TxlReport(this);


  AnsiString sqlstr="select b.reg_num, b.dat_e,b.reg_date,b.mfo_self,b.account_self,b.id_pref,bank.name as bankname, b.demand_val, \
  b.value, b.value_tax,abon.name as abonname, abon.code, abon.short_name, \
  abonpar.doc_num, abonpar.doc_dat, abonpar.okpo_num as abon_okpo_num, \
  users.represent_name, ip.name as posname, \
  b.mmgg,b.mmgg_bill \
  from acm_bill_tbl as b \
  left join cmi_bank_tbl as bank on (bank.id = b.mfo_self) \
  left join clm_position_tbl as users on (users.id = b.id_person) \
  left join cli_position_tbl as ip  on (ip.id = users.id_position) \
  left join clm_client_tbl as abon on (b.id_client = abon.id) \
  left join clm_statecl_h as abonpar on (abonpar.id_client = abon.id) \
  where b.id_doc = :doc \
  and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as abonpar2 where abonpar2.id_client = abonpar.id_client and abonpar2.mmgg_b <= coalesce(b.dat_e, b.reg_date));";

  ZQuery->Close();
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
  ZQuery->ParamByName("doc")->AsInteger=id_bill;

  try
   {
    ZQuery->Open();
   }
  catch(...)
   {
    ShowMessage("������ SQL :"+sqlstr);
    ZQuery->Close();
    return;
   }

  xlReport->XLSTemplate = "XL\\bill_inform.xls";

  TxlDataSource *Dsr;

  TxlReportParam *Param;
  xlReport->DataSources->Clear();
  Dsr = xlReport->DataSources->Add();
  Dsr->DataSet = ZQuery;
  Dsr->Alias =  "ZQXLReps";


  //  Dsr->Range = "Range";

  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="doc";
  Param=xlReport->Params->Add();
  Param->Name="bill";
  Param=xlReport->Params->Add();
  Param->Name="comment";
//  Param=xlReport->Params->Add();
//  Param->Name="linfo";

  xlReport->ParamByName["doc"]->Value = "ϳ������: ������� � "+ ZQuery->FieldByName("doc_num")->AsString+" �� "+
    FormatDateTime("dd.mm.yyyy ",ZQuery->FieldByName("doc_dat")->AsDateTime);

  xlReport->ParamByName["bill"]->Value = "������� �  "+ ZQuery->FieldByName("reg_num")->AsString+" �� "+
    FormatDateTime("dd.mm.yyyy ",ZQuery->FieldByName("reg_date")->AsDateTime);

  xlReport->ParamByName["comment"]->Value = "������ �� ������ ������������ ������� ��� "+ ZQuery->FieldByName("short_name")->AsString+" �� ";

  xlReport->Report();

  delete xlReport;
}
//---------------------------------------------------------------------------

