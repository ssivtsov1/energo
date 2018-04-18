//---------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "main.h";
#include "fTaxPrint2014.h"              
#include "fLogin.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#pragma link "IcXMLParser"
#pragma resource "*.dfm"
//TfRepTaxN *fRepTaxN;
int counter;
int str_cnt;
//---------------------------------------------------------------------------
__fastcall TfRepTaxN2014::TfRepTaxN2014(TComponent* Owner)
        : TfTaxPrintPrnt(Owner)

{
 ZQTax->Database=TWTTable::Database;
 ZQTaxSumm->Database=TWTTable::Database;

}
//---------------------------------------------------------------------------

void  TfRepTaxN2014::ShowTaxNal(int id_doc, int print)
{
  float val;
  int len;

  ZQTax->Close();
  ZQTaxSumm->Close();

  ZQTax->ParamByName("doc")->AsInteger=id_doc;
  ZQTaxSumm->ParamByName("doc")->AsInteger=id_doc;

  int print1page=0;

  try
   {
    ZQTax->Open();
//    ZQTaxSumm->Open();
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

     int id_client=ZQTax->FieldByName("abonid")->AsInteger;

     print1page =ZQTax->FieldByName("print_1_copy")->AsInteger;

     lCode->Caption=ZQTax->FieldByName("code")->AsString;

     if (ZQTax->FieldByName("flag_reg")->AsInteger!=0)
       lMain2->Enabled = true;
     else
       lMain2->Enabled = false;

//     lTaxNum->Caption=ZQTax->FieldByName("reg_num")->AsString;
//     lTaxDate->Caption=ZQTax->FieldByName("reg_date")->AsString;

     lFormPay->Caption="Оплата з поточного рахунку";

     AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("reg_date")->AsDateTime);
     lTaxDate1->Caption= StaxDate[1];
     lTaxDate2->Caption= StaxDate[2];
     lTaxDate3->Caption= StaxDate[3];
     lTaxDate4->Caption= StaxDate[4];
     lTaxDate5->Caption= StaxDate[5];
     lTaxDate6->Caption= StaxDate[6];
     lTaxDate7->Caption= StaxDate[7];
     lTaxDate8->Caption= StaxDate[8];

//     AnsiString StaxNum =FormatFloat ("0000000",ZQTax->FieldByName("int_num")->AsInteger);
     AnsiString StaxNum =ZQTax->FieldByName("int_num")->AsString;
     len =StaxNum.Length();
     for(int i = 0; i< (7-len); i++  ) {StaxNum = " "+StaxNum;}

     lTaxNum1->Caption= StaxNum[1];
     lTaxNum2->Caption= StaxNum[2];
     lTaxNum3->Caption= StaxNum[3];
     lTaxNum4->Caption= StaxNum[4];
     lTaxNum5->Caption= StaxNum[5];
     lTaxNum6->Caption= StaxNum[6];
     lTaxNum7->Caption= StaxNum[7];

     AnsiString StaxNum2;
//     if (ZQTax->FieldByName("reg_date")->AsDateTime >= TDateTime('01.04.2014'))

     StaxNum2=(ZQTax->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTax->FieldByName("reg_num")->AsString)+1,3).Trim();
     len =StaxNum2.Length();
     for(int i = 0; i< (3-len); i++  ) {StaxNum2 = " "+StaxNum2;}

     lTaxNum8->Caption= " ";
     lTaxNum9->Caption=  StaxNum2[1];
     lTaxNum10->Caption= StaxNum2[2];
     lTaxNum11->Caption= StaxNum2[3];


     lResName->Caption=ZQTax->FieldByName("resname")->AsString;
     lAbonName->Caption=ZQTax->FieldByName("abonname")->AsString;

     flag_taxpay = ZQTax->FieldByName("flag_taxpay")->AsInteger;

          /*
     try {
      taxNum_res =FormatFloat("000000000000",ZQTax->FieldByName("taxNum_res")->AsFloat);
     }
     catch(...)
     {
      ShowMessage("Не заполнен индивидуальный налоговый номер РЕС.");
     }  */
     AnsiString taxNum_res =  ZQTax->FieldByName("taxNum_res")->AsString.Trim();

     len =taxNum_res.Length();
     for(int i = 0; i< (12-len); i++  ) {taxNum_res = " "+taxNum_res;} //{taxNum_res = taxNum_res+"-";}

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

     AnsiString svidNum_res ;
/*
//     lResSvidNum->Caption=ZQTax->FieldByName("SvidNum_res")->AsString.Trim();
     svidNum_res=ZQTax->FieldByName("SvidNum_res")->AsString.Trim();

     len =svidNum_res.Length();
     for(int i = 0; i< (10-len); i++  ) {svidNum_res = " "+svidNum_res ;} //{svidNum_res = svidNum_res+"-" ;}

     lResSvidNum1->Caption=svidNum_res[1];
     lResSvidNum2->Caption=svidNum_res[2];
     lResSvidNum3->Caption=svidNum_res[3];
     lResSvidNum4->Caption=svidNum_res[4];
     lResSvidNum5->Caption=svidNum_res[5];
     lResSvidNum6->Caption=svidNum_res[6];
     lResSvidNum7->Caption=svidNum_res[7];
     lResSvidNum8->Caption=svidNum_res[8];
     lResSvidNum9->Caption=svidNum_res[9];
     lResSvidNum10->Caption=svidNum_res[10];
*/

     AnsiString taxNum_abon ;
     AnsiString svidNum_abon ;

     if (ZQTax->FieldByName("flag_taxpay")->AsInteger==1)
     {
      taxNum_abon = ZQTax->FieldByName("taxNum_abon")->AsString.Trim();

      len =taxNum_abon.Length();
      for(int i = 0; i< (12-len); i++  ) {taxNum_abon = " "+taxNum_abon ;} //{taxNum_abon = taxNum_abon+"-" ;}

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

//      lAbonSvidNum->Caption=ZQTax->FieldByName("SvidNum_abon")->AsString.Trim();
/*
      svidNum_abon=ZQTax->FieldByName("SvidNum_abon")->AsString.Trim();

      len =svidNum_abon.Length();
      for(int i = 0; i< (10-len); i++  ) {svidNum_abon = " "+svidNum_abon;} //{svidNum_abon = svidNum_abon+"-" ;}

      lAbonSvidNum1->Caption=svidNum_abon[1];
      lAbonSvidNum2->Caption=svidNum_abon[2];
      lAbonSvidNum3->Caption=svidNum_abon[3];
      lAbonSvidNum4->Caption=svidNum_abon[4];
      lAbonSvidNum5->Caption=svidNum_abon[5];
      lAbonSvidNum6->Caption=svidNum_abon[6];
      lAbonSvidNum7->Caption=svidNum_abon[7];
      lAbonSvidNum8->Caption=svidNum_abon[8];
      lAbonSvidNum9->Caption=svidNum_abon[9];
      lAbonSvidNum10->Caption=svidNum_abon[10];
  */
      val =0;
     }
     else
     {
//      lAbonSvidNum->Caption="XXXXXXXX";

      QRLabel89->Caption="4";
      QRLabel90->Caption="0";
      QRLabel91->Caption="0";
      QRLabel92->Caption="0";
      QRLabel93->Caption="0";
      QRLabel94->Caption="0";
      QRLabel95->Caption="0";
      QRLabel96->Caption="0";
      QRLabel97->Caption="0";
      QRLabel98->Caption="0";
      QRLabel99->Caption="0";
      QRLabel100->Caption="0";
/*
      lAbonSvidNum1->Caption=" ";
      lAbonSvidNum2->Caption=" ";
      lAbonSvidNum3->Caption=" ";
      lAbonSvidNum4->Caption=" ";
      lAbonSvidNum5->Caption=" ";
      lAbonSvidNum6->Caption=" ";
      lAbonSvidNum7->Caption=" ";
      lAbonSvidNum8->Caption=" ";
      lAbonSvidNum9->Caption=" ";
      lAbonSvidNum10->Caption="0";
*/
     }

     QRLabel76->Caption = ZQTax->FieldByName("represent_name")->AsString;

     lAbonAddr->Caption=ZQTax->FieldByName("abonaddr")->AsString;
     lResAddr->Caption=ZQTax->FieldByName("resaddr")->AsString;

//-------------
//     lResPhone->Caption=ZQTax->FieldByName("resphone")->AsString;

     AnsiString resPhone =ZQTax->FieldByName("resphone")->AsString.Trim();

     TReplaceFlags flags ;
     flags <<rfReplaceAll;

     resPhone = StringReplace(resPhone,"-","",flags);
     resPhone = StringReplace(resPhone,"(","",flags);
     resPhone = StringReplace(resPhone,")","",flags);

     if (AnsiPos("/",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos("/",resPhone )-1);
     if (AnsiPos(",",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(",",resPhone )-1);
     if (AnsiPos(";",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(";",resPhone )-1);
     if (AnsiPos(".",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(".",resPhone )-1);
     if (AnsiPos(" ",resPhone )!=0 ) resPhone = resPhone.SubString(1, AnsiPos(" ",resPhone )-1);

     resPhone = resPhone.SubString(1, 10).Trim();

     if ((resPhone=="0")||(resPhone==""))
     {
      lResPhone1->Caption="-";
      lResPhone2->Caption="-";
      lResPhone3->Caption="-";
      lResPhone4->Caption="-";
      lResPhone5->Caption="-";
      lResPhone6->Caption="-";
      lResPhone7->Caption="-";
      lResPhone8->Caption="-";
      lResPhone9->Caption="-";
      lResPhone10->Caption="-";
     }
     else
     {
      len =resPhone.Length();
      for(int i = 0; i< (10-len); i++  ) {resPhone = resPhone+"-" ;}

      lResPhone1->Caption=resPhone[1];
      lResPhone2->Caption=resPhone[2];
      lResPhone3->Caption=resPhone[3];
      lResPhone4->Caption=resPhone[4];
      lResPhone5->Caption=resPhone[5];
      lResPhone6->Caption=resPhone[6];
      lResPhone7->Caption=resPhone[7];
      lResPhone8->Caption=resPhone[8];
      lResPhone9->Caption=resPhone[9];
      lResPhone10->Caption=resPhone[10];

     }

//------------------
//     lAbonPhone->Caption=ZQTax->FieldByName("abonphone")->AsString;

     AnsiString abonPhone =ZQTax->FieldByName("abonphone")->AsString.Trim();

     abonPhone = StringReplace(abonPhone,"-","",flags);
     abonPhone = StringReplace(abonPhone,"(","",flags);
     abonPhone = StringReplace(abonPhone,")","",flags);

     if (AnsiPos("/",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos("/",abonPhone)-1);
     if (AnsiPos(",",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(",",abonPhone)-1);
     if (AnsiPos(";",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(";",abonPhone)-1);
     if (AnsiPos(".",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(".",abonPhone)-1);
     if (AnsiPos(" ",abonPhone )!=0 ) abonPhone = abonPhone.SubString(1, AnsiPos(" ",abonPhone)-1);

     abonPhone = abonPhone.SubString(1, 10).Trim();

     if ((abonPhone=="0")||(abonPhone==""))
     {
      lAbonPhone1->Caption="-";
      lAbonPhone2->Caption="-";
      lAbonPhone3->Caption="-";
      lAbonPhone4->Caption="-";
      lAbonPhone5->Caption="-";
      lAbonPhone6->Caption="-";
      lAbonPhone7->Caption="-";
      lAbonPhone8->Caption="-";
      lAbonPhone9->Caption="-";
      lAbonPhone10->Caption="-";
     }
     else
     {
      len =abonPhone.Length();
      for(int i = 0; i< (10-len); i++  ) {abonPhone = abonPhone+"-" ;}

      lAbonPhone1->Caption=abonPhone[1];
      lAbonPhone2->Caption=abonPhone[2];
      lAbonPhone3->Caption=abonPhone[3];
      lAbonPhone4->Caption=abonPhone[4];
      lAbonPhone5->Caption=abonPhone[5];
      lAbonPhone6->Caption=abonPhone[6];
      lAbonPhone7->Caption=abonPhone[7];
      lAbonPhone8->Caption=abonPhone[8];
      lAbonPhone9->Caption=abonPhone[9];
      lAbonPhone10->Caption=abonPhone[10];

     }

     qrlNDS->Caption=FormatFloat("0.00",ZQTax->FieldByName("value_tax")->AsFloat);
     qrlNDS2->Caption=FormatFloat("0.00",ZQTax->FieldByName("value_tax")->AsFloat);

     if (ZQTax->FieldByName("sum_val7")->AsFloat!=0)
       qrlSum->Caption=FormatFloat("0.00",ZQTax->FieldByName("value")->AsFloat+ZQTax->FieldByName("value_tax")->AsFloat);
     else
       qrlSum->Caption=FormatFloat("0.00",0);

     qrlSum2->Caption=FormatFloat("0.00",ZQTax->FieldByName("value")->AsFloat+ZQTax->FieldByName("value_tax")->AsFloat);

     if ((ZQTax->FieldByName("id_section")->AsInteger  ==206)||(ZQTax->FieldByName("id_section")->AsInteger  ==207))
     {
     // льготы и субсидии отдельный случай
     // 2011 год порядок изменен

//      lContract->Caption=ZQTax->FieldByName("abonnamesh")->AsString;

       lContract->Caption="договір про користування електричною енергією";

       lDogovorDate1->Caption= "-";
       lDogovorDate2->Caption= "-";
       lDogovorDate3->Caption= "-";
       lDogovorDate4->Caption= "-";
       lDogovorDate5->Caption= "-";
       lDogovorDate6->Caption= "-";
       lDogovorDate7->Caption= "-";
       lDogovorDate8->Caption= "-";

       lDogovorNum->Caption= "-";
//       lDogovorNum2->Caption= "-";
//       lDogovorNum3->Caption= "-";
//       lDogovorNum4->Caption= "-";
//       lDogovorNum5->Caption= "-";
//       lDogovorNum6->Caption= "-";

      lFormPay->Caption=ZQTax->FieldByName("taxtext")->AsString;
      bSimple->Enabled= false;
      bLgota->Enabled= true;
     }
     else
     {

      if ((ZQTax->FieldByName("id_section")->AsInteger  ==205)||(ZQTax->FieldByName("id_section")->AsInteger  ==208)) //население
      {
       lContract->Caption="договір про користування електричною енергією";

       lDogovorDate1->Caption= "-";
       lDogovorDate2->Caption= "-";
       lDogovorDate3->Caption= "-";
       lDogovorDate4->Caption= "-";
       lDogovorDate5->Caption= "-";
       lDogovorDate6->Caption= "-";
       lDogovorDate7->Caption= "-";
       lDogovorDate8->Caption= "-";

       lDogovorNum->Caption= "-";
//       lDogovorNum2->Caption= "-";
//       lDogovorNum3->Caption= "-";
//       lDogovorNum4->Caption= "-";
//       lDogovorNum5->Caption= "-";
//       lDogovorNum6->Caption= "-";

      }
      else
      {
       lContract->Caption="договір про постачання електричної енергії";
       AnsiString SdocDate;
       if (ZQTax->FieldByName("doc_dat")->IsNull )
       {
           SdocDate = "--------";
       }
       else
       {
           SdocDate  =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("doc_dat")->AsDateTime);       }


       lDogovorDate1->Caption= SdocDate[1];
       lDogovorDate2->Caption= SdocDate[2];
       lDogovorDate3->Caption= SdocDate[3];
       lDogovorDate4->Caption= SdocDate[4];
       lDogovorDate5->Caption= SdocDate[5];
       lDogovorDate6->Caption= SdocDate[6];
       lDogovorDate7->Caption= SdocDate[7];
       lDogovorDate8->Caption= SdocDate[8];

       AnsiString SdocNum =ZQTax->FieldByName("doc_num")->AsString.Trim();

       lDogovorNum->Caption= SdocNum;
/*
       len =SdocNum.Length();
       for(int i = 0; i< (6-len); i++  ) {SdocNum = SdocNum+" ";}

       lDogovorNum1->Caption= SdocNum[1];
       lDogovorNum2->Caption= SdocNum[2];
       lDogovorNum3->Caption= SdocNum[3];
       lDogovorNum4->Caption= SdocNum[4];
       lDogovorNum5->Caption= SdocNum[5];
       lDogovorNum6->Caption= SdocNum[6];
*/

  //     lContract->Caption="Згідно договору № "+ZQTax->FieldByName("doc_num")->AsString+
  //     " від "+ZQTax->FieldByName("doc_dat")->AsString;
      }

      if (ZQTax->FieldByName("id_pref")->AsInteger  ==10 )
      {
        bSimple->Enabled= true;
        bLgota->Enabled= false;
      }
      else
      {
        bSimple->Enabled= false;
        bLgota->Enabled= true;
      }
/*
      if ((ZQTax->FieldByName("id_pref")->AsInteger  ==10 )||(ZQTax->FieldByName("id_pref")->AsInteger  ==520 ))
      {
//        lFormPay->Caption="Оплата на поточний рахунок із спеціальним режимом використання";
      }
      else
      {
//        lFormPay->Caption="Оплата на поточний рахунок";
      }
*/
     }

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

  //PrintTax->Preview();
  counter=0;
  str_cnt = 0;

  if (print1page==0)
  {
   if (print ==1 ) crTwoPages->Print();
   else crTwoPages->Preview();
  }
  else
  {
   if (print ==1 )
    {PrintTax->Print();
     PrintTax->Print(); }
   else
    {PrintTax->Preview();
     PrintTax->Preview(); }
  }
}
//------------------------------------------------------------------------------
void __fastcall TfRepTaxN2014::crTwoPagesAddReports(TObject *Sender)
{
 crTwoPages->Reports->Add(PrintTax);
 crTwoPages->Reports->Add(PrintTax);
}
//---------------------------------------------------------------------------

void __fastcall TfRepTaxN2014::PrintTaxBeforePrint(TCustomQuickRep *Sender,
      bool &PrintReport)
{
 if (counter == 0)
 {
  lMain->Enabled = true;
  lCopy->Enabled = false;

  if(flag_taxpay==1)
  {
   lNoGive->Enabled = false;
   lNoGive1->Enabled = false;
   lNoGive2->Enabled = false;
  }
  else
  {
   lNoGive->Enabled = true;
   lNoGive1->Enabled = true;
   lNoGive2->Enabled = true;
  }

  counter = 1;
 }
 else
 {
  //Sender->NewPage();
  lCopy->Enabled = true;
  lMain->Enabled = false;

  if(flag_taxpay==1)
  {
   lNoGive->Enabled = false;
   lNoGive1->Enabled = false;
   lNoGive2->Enabled = false;
  }
  else
  {
   lNoGive->Enabled = true;
   lNoGive1->Enabled = true;
   lNoGive2->Enabled = true;
  }

  counter = 0;
 }

}
//---------------------------------------------------------------------------

void __fastcall TfRepTaxN2014::bLgotaBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
  if (str_cnt!=0) l_1_1->Enabled = false;
  else l_1_1->Enabled = true;

  str_cnt++;
//QRBand3->Height = QRDBText8->Height+2;
// QRShape46->Height = QRDBText8->Height+2;
// QRShape47->Height = QRDBText8->Height+2;
// QRShape48->Height = QRDBText8->Height+2;
// QRShape49->Height = QRDBText8->Height+2;
// QRShape50->Height = QRDBText8->Height+2;
// QRShape51->Height = QRDBText8->Height+2;
// QRShape52->Height = QRDBText8->Height+2;
// QRShape53->Height = QRDBText8->Height+2;
// QRShape54->Height = QRDBText8->Height+2;
}
//---------------------------------------------------------------------------



void __fastcall TfRepTaxN2014::QRBand1BeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{
 // TQuickRep(Sender->Parent).NewPage();
  str_cnt=0;
}
//---------------------------------------------------------------------------

void __fastcall TfRepTaxN2014::bSimpleBeforePrint(TQRCustomBand *Sender,
      bool &PrintBand)
{

  if (str_cnt!=0) l_1->Enabled = false;
  else l_1->Enabled = true;

  str_cnt++;
}
//---------------------------------------------------------------------------


void __fastcall TfRepTaxN2014::QRBand2AfterPrint(TQRCustomBand *Sender,
      bool BandPrinted)
{
 if (counter == 1)
  PrintTax->NewPage();
}
//---------------------------------------------------------------------------

