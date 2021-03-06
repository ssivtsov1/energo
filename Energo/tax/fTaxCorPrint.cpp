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
//TfRepTaxCor *fRepTaxCor;
//---------------------------------------------------------------------------
__fastcall TfRepTaxCor::TfRepTaxCor(TComponent* Owner)
        : TfTaxCorPrintPrnt(Owner)
{
 ZQTax->Database=TWTTable::Database;
 ZQTaxSumm->Database=TWTTable::Database;
}
//---------------------------------------------------------------------------

void TfRepTaxCor::ShowTaxCor(int id_doc, int print)
{
  int len;

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
    ShowMessage("������ ������������ ��.");
    ZQTax->Close();
    return;
   }
   if (ZQTax->RecordCount!=0)
   {
     ZQTax->First();

//     lCorNum->Caption=ZQTax->FieldByName("reg_num")->AsString;

     AnsiString ScorNum;

     ScorNum =(ZQTax->FieldByName("reg_num")->AsString).SubString(1,AnsiPos("/",ZQTax->FieldByName("reg_num")->AsString)-1);

     len =ScorNum.Length();
     for(int i = 0; i< (8-len); i++  ) {ScorNum = " "+ScorNum;}


     lCorNum1->Caption =ScorNum[1];
     lCorNum2->Caption =ScorNum[2];
     lCorNum3->Caption =ScorNum[3];
     lCorNum4->Caption =ScorNum[4];
     lCorNum5->Caption =ScorNum[5];
     lCorNum6->Caption =ScorNum[6];
     lCorNum7->Caption =ScorNum[7];
     lCorNum8->Caption =ScorNum[8];

     lCorNum1_2->Caption =lCorNum1->Caption;
     lCorNum2_2->Caption =lCorNum2->Caption;
     lCorNum3_2->Caption =lCorNum3->Caption;
     lCorNum4_2->Caption =lCorNum4->Caption;
     lCorNum5_2->Caption =lCorNum5->Caption;
     lCorNum6_2->Caption =lCorNum6->Caption;
     lCorNum7_2->Caption =lCorNum7->Caption;
     lCorNum8_2->Caption =lCorNum8->Caption;


     AnsiString StaxDate =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("tax_date")->AsDateTime);
     lTaxDate1->Caption= StaxDate[1];
     lTaxDate2->Caption= StaxDate[2];
     lTaxDate3->Caption= StaxDate[3];
     lTaxDate4->Caption= StaxDate[4];
     lTaxDate5->Caption= StaxDate[5];
     lTaxDate6->Caption= StaxDate[6];
     lTaxDate7->Caption= StaxDate[7];
     lTaxDate8->Caption= StaxDate[8];

     lTaxDate1_2->Caption=lTaxDate1->Caption;
     lTaxDate2_2->Caption=lTaxDate2->Caption;
     lTaxDate3_2->Caption=lTaxDate3->Caption;
     lTaxDate4_2->Caption=lTaxDate4->Caption;
     lTaxDate5_2->Caption=lTaxDate5->Caption;
     lTaxDate6_2->Caption=lTaxDate6->Caption;
     lTaxDate7_2->Caption=lTaxDate7->Caption;
     lTaxDate8_2->Caption=lTaxDate8->Caption;

//     AnsiString StaxNum =FormatFloat ("0000000",ZQTax->FieldByName("int_num")->AsInteger);
//     AnsiString StaxNum =ZQTax->FieldByName("int_num")->AsString;

     AnsiString StaxNum;
     if (AnsiPos("/",ZQTax->FieldByName("tax_num")->AsString)!=0)
       StaxNum=(ZQTax->FieldByName("tax_num")->AsString).SubString(1,AnsiPos("/",ZQTax->FieldByName("tax_num")->AsString)-1);
     else
       StaxNum=ZQTax->FieldByName("tax_num")->AsString;

     len =StaxNum.Length();
     for(int i = 0; i< (7-len); i++  ) {StaxNum = " "+StaxNum;}

     lTaxNum1->Caption= StaxNum[1];
     lTaxNum2->Caption= StaxNum[2];
     lTaxNum3->Caption= StaxNum[3];
     lTaxNum4->Caption= StaxNum[4];
     lTaxNum5->Caption= StaxNum[5];
     lTaxNum6->Caption= StaxNum[6];
     lTaxNum7->Caption= StaxNum[7];

     lTaxNum1_2->Caption=lTaxNum1->Caption;
     lTaxNum2_2->Caption=lTaxNum2->Caption;
     lTaxNum3_2->Caption=lTaxNum3->Caption;
     lTaxNum4_2->Caption=lTaxNum4->Caption;
     lTaxNum5_2->Caption=lTaxNum5->Caption;
     lTaxNum6_2->Caption=lTaxNum6->Caption;
     lTaxNum7_2->Caption=lTaxNum7->Caption;

     AnsiString StaxNum2;
     //StaxNum2=(ZQTax->FieldByName("tax_num")->AsString).SubString(AnsiPos("/",ZQTax->FieldByName("tax_num")->AsString)+1,3);
     StaxNum2=(ZQTax->FieldByName("reg_num")->AsString).SubString(AnsiPos("/",ZQTax->FieldByName("reg_num")->AsString)+1,3);

     len =StaxNum2.Length();
     for(int i = 0; i< (3-len); i++  ) {StaxNum2 = "0"+StaxNum2;}

     lCorNum9 ->Caption= " ";
     lCorNum10->Caption= StaxNum2[1];
     lCorNum11->Caption= StaxNum2[2];
     lCorNum12->Caption= StaxNum2[3];

     lCorNum9_2 ->Caption=lCorNum9 ->Caption;
     lCorNum10_2->Caption=lCorNum10->Caption;
     lCorNum11_2->Caption=lCorNum11->Caption;
     lCorNum12_2->Caption=lCorNum12->Caption;

     AnsiString StaxNum3=(ZQTax->FieldByName("tax_num")->AsString).SubString(AnsiPos("/",ZQTax->FieldByName("tax_num")->AsString)+1,10);

     TReplaceFlags flags ;
     flags <<rfReplaceAll;

     StaxNum3=StringReplace(StaxNum3.Trim(),"-","",flags);
     StaxNum3=StringReplace(StaxNum3.Trim()," ","",flags);

     len =StaxNum3.Length();
     for(int i = 0; i< (3-len); i++  ) {StaxNum3 = " "+StaxNum3;}

     lTaxNum8->Caption= " ";
     lTaxNum9->Caption= StaxNum3[1];
     lTaxNum10->Caption= StaxNum3[2];
     lTaxNum11->Caption= StaxNum3[3];

     lTaxNum8_2->Caption=lTaxNum8->Caption;
     lTaxNum9_2->Caption=lTaxNum9->Caption;
     lTaxNum10_2->Caption=lTaxNum10->Caption;
     lTaxNum11_2->Caption=lTaxNum11->Caption;


     AnsiString SdocDate =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("doc_dat")->AsDateTime);
     lDogovorDate1->Caption= SdocDate[1];
     lDogovorDate2->Caption= SdocDate[2];
     lDogovorDate3->Caption= SdocDate[3];
     lDogovorDate4->Caption= SdocDate[4];
     lDogovorDate5->Caption= SdocDate[5];
     lDogovorDate6->Caption= SdocDate[6];
     lDogovorDate7->Caption= SdocDate[7];
     lDogovorDate8->Caption= SdocDate[8];

     lDogovorDate1_1->Caption=lDogovorDate1->Caption;
     lDogovorDate2_1->Caption=lDogovorDate2->Caption;
     lDogovorDate3_1->Caption=lDogovorDate3->Caption;
     lDogovorDate4_1->Caption=lDogovorDate4->Caption;
     lDogovorDate5_1->Caption=lDogovorDate5->Caption;
     lDogovorDate6_1->Caption=lDogovorDate6->Caption;
     lDogovorDate7_1->Caption=lDogovorDate7->Caption;
     lDogovorDate8_1->Caption=lDogovorDate8->Caption;

     lDogovorDate1_2->Caption=lDogovorDate1->Caption;
     lDogovorDate2_2->Caption=lDogovorDate2->Caption;
     lDogovorDate3_2->Caption=lDogovorDate3->Caption;
     lDogovorDate4_2->Caption=lDogovorDate4->Caption;
     lDogovorDate5_2->Caption=lDogovorDate5->Caption;
     lDogovorDate6_2->Caption=lDogovorDate6->Caption;
     lDogovorDate7_2->Caption=lDogovorDate7->Caption;
     lDogovorDate8_2->Caption=lDogovorDate8->Caption;

     lDogovorDate1_3->Caption=lDogovorDate1->Caption;
     lDogovorDate2_3->Caption=lDogovorDate2->Caption;
     lDogovorDate3_3->Caption=lDogovorDate3->Caption;
     lDogovorDate4_3->Caption=lDogovorDate4->Caption;
     lDogovorDate5_3->Caption=lDogovorDate5->Caption;
     lDogovorDate6_3->Caption=lDogovorDate6->Caption;
     lDogovorDate7_3->Caption=lDogovorDate7->Caption;
     lDogovorDate8_3->Caption=lDogovorDate8->Caption;


     AnsiString SdocNum =ZQTax->FieldByName("doc_num")->AsString.Trim();

//     len =SdocNum.Length();
//     for(int i = 0; i< (6-len); i++  ) {SdocNum = SdocNum+" ";}

     lDogovorNum->Caption= SdocNum;
//     lDogovorNum2->Caption= SdocNum[2];
//     lDogovorNum3->Caption= SdocNum[3];
//     lDogovorNum4->Caption= SdocNum[4];
//     lDogovorNum5->Caption= SdocNum[5];
//     lDogovorNum6->Caption= SdocNum[6];

     lDogovorNum_2->Caption=lDogovorNum->Caption;
//     lDogovorNum2_2->Caption=lDogovorNum2->Caption;
//     lDogovorNum3_2->Caption=lDogovorNum3->Caption;
//     lDogovorNum4_2->Caption=lDogovorNum4->Caption;
//     lDogovorNum5_2->Caption=lDogovorNum5->Caption;
//     lDogovorNum6_2->Caption=lDogovorNum6->Caption;

     lDogovorNum_1->Caption=lDogovorNum->Caption;
//     lDogovorNum2_1->Caption=lDogovorNum2->Caption;
//     lDogovorNum3_1->Caption=lDogovorNum3->Caption;
//     lDogovorNum4_1->Caption=lDogovorNum4->Caption;
//     lDogovorNum5_1->Caption=lDogovorNum5->Caption;
//     lDogovorNum6_1->Caption=lDogovorNum6->Caption;
//     lDogovorNum7_1->Caption=" ";
//     lDogovorNum8_1->Caption=" ";
//     lDogovorNum9_1->Caption=" ";
//     lDogovorNum10_1->Caption=" ";
//     lDogovorNum11_1->Caption=" ";
//     lDogovorNum12_1->Caption=" ";

     lDogovorNum_3->Caption=lDogovorNum->Caption;
//     lDogovorNum2_3->Caption=lDogovorNum2->Caption;
//     lDogovorNum3_3->Caption=lDogovorNum3->Caption;
//     lDogovorNum4_3->Caption=lDogovorNum4->Caption;
//     lDogovorNum5_3->Caption=lDogovorNum5->Caption;
//     lDogovorNum6_3->Caption=lDogovorNum6->Caption;
//     lDogovorNum7_3->Caption=" ";
//     lDogovorNum8_3->Caption=" ";
//     lDogovorNum9_3->Caption=" ";
//     lDogovorNum10_3->Caption=" ";
//     lDogovorNum11_3->Caption=" ";
//     lDogovorNum12_3->Caption=" ";

//     lTaxInfo->Caption="�� "+ZQTax->FieldByName("tax_date")->AsString+
//     " � "+ZQTax->FieldByName("tax_num")->AsString+
//     " �� ��������� �� "+ZQTax->FieldByName("doc_dat")->AsString+
//     " � "+ZQTax->FieldByName("doc_num")->AsString;
//     lTaxInfo_2->Caption=lTaxInfo->Caption;

     AnsiString SRegDate =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("reg_date")->AsDateTime);
     lRegDate1->Caption= SRegDate[1];
     lRegDate2->Caption= SRegDate[2];
     lRegDate3->Caption= SRegDate[3];
     lRegDate4->Caption= SRegDate[4];
     lRegDate5->Caption= SRegDate[5];
     lRegDate6->Caption= SRegDate[6];
     lRegDate7->Caption= SRegDate[7];
     lRegDate8->Caption= SRegDate[8];

     lRegDate1_2->Caption= SRegDate[1];
     lRegDate2_2->Caption= SRegDate[2];
     lRegDate3_2->Caption= SRegDate[3];
     lRegDate4_2->Caption= SRegDate[4];
     lRegDate5_2->Caption= SRegDate[5];
     lRegDate6_2->Caption= SRegDate[6];
     lRegDate7_2->Caption= SRegDate[7];
     lRegDate8_2->Caption= SRegDate[8];


     lBottomText->Caption="���������� ����������� �� "+ZQTax->FieldByName("reg_date")->AsString+
     " � "+ZQTax->FieldByName("reg_num")->AsString+
     " �� ��������� �������� �� "+ZQTax->FieldByName("tax_date")->AsString+
     " � "+ZQTax->FieldByName("tax_num")->AsString+
     " ������� � �����'������ �������� ���� ����������� �� ������ ������� �� ��������� ���������� ��������� �� ��� ����������� ������� � ����������� �����'������";
     lBottomText_2->Caption=lBottomText->Caption;

     lResName->Caption=ZQTax->FieldByName("resname")->AsString;
     lAbonName->Caption=ZQTax->FieldByName("abonname")->AsString;
     lResName_2->Caption = lResName->Caption;
     lAbonName_2->Caption =  lAbonName->Caption;

//     AnsiString taxNum_res =FormatFloat("000000000000",ZQTax->FieldByName("taxNum_res")->AsFloat);
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

     QRLabel77_2->Caption= taxNum_res[1];
     QRLabel78_2->Caption= taxNum_res[2];
     QRLabel79_2->Caption= taxNum_res[3];
     QRLabel80_2->Caption= taxNum_res[4];
     QRLabel81_2->Caption= taxNum_res[5];
     QRLabel82_2->Caption= taxNum_res[6];
     QRLabel83_2->Caption= taxNum_res[7];
     QRLabel84_2->Caption= taxNum_res[8];
     QRLabel85_2->Caption= taxNum_res[9];
     QRLabel86_2->Caption= taxNum_res[10];
     QRLabel87_2->Caption= taxNum_res[11];
     QRLabel88_2->Caption= taxNum_res[12];

     //AnsiString taxNum_abon =FormatFloat("000000000000",ZQTax->FieldByName("taxNum_abon")->AsFloat);
     AnsiString taxNum_abon;

     if (ZQTax->FieldByName("flag_taxpay")->AsInteger==1)
     {

      //lAbonSvidNum->Caption=ZQTax->FieldByName("SvidNum_abon")->AsString;
      lAbonSvidNum->Caption=FormatFloat("##00000000",ZQTax->FieldByName("SvidNum_abon")->AsFloat);
      lAbonSvidNum_2->Caption=lAbonSvidNum->Caption;

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

      QRLabel89_2->Caption=taxNum_abon[1];
      QRLabel90_2->Caption=taxNum_abon[2];
      QRLabel91_2->Caption=taxNum_abon[3];
      QRLabel92_2->Caption=taxNum_abon[4];
      QRLabel93_2->Caption=taxNum_abon[5];
      QRLabel94_2->Caption=taxNum_abon[6];
      QRLabel95_2->Caption=taxNum_abon[7];
      QRLabel96_2->Caption=taxNum_abon[8];
      QRLabel97_2->Caption=taxNum_abon[9];
      QRLabel98_2->Caption=taxNum_abon[10];
      QRLabel99_2->Caption=taxNum_abon[11];
      QRLabel100_2->Caption=taxNum_abon[12];

      lNoGive->Enabled = false;
      lNoGive1->Enabled = false;
      lNoGive2->Enabled = false;
      lMain->Enabled = true;
     }
     else
     {
      lAbonSvidNum->Caption="0";
      lAbonSvidNum_2->Caption=lAbonSvidNum->Caption;

      QRLabel89->Caption=" ";
      QRLabel90->Caption=" ";
      QRLabel91->Caption=" ";
      QRLabel92->Caption=" ";
      QRLabel93->Caption=" ";
      QRLabel94->Caption=" ";
      QRLabel95->Caption=" ";
      QRLabel96->Caption=" ";
      QRLabel97->Caption=" ";
      QRLabel98->Caption=" ";
      QRLabel99->Caption=" ";
      QRLabel100->Caption="0";

      QRLabel89_2->Caption=" ";
      QRLabel90_2->Caption=" ";
      QRLabel91_2->Caption=" ";
      QRLabel92_2->Caption=" ";
      QRLabel93_2->Caption=" ";
      QRLabel94_2->Caption=" ";
      QRLabel95_2->Caption=" ";
      QRLabel96_2->Caption=" ";
      QRLabel97_2->Caption=" ";
      QRLabel98_2->Caption=" ";
      QRLabel99_2->Caption=" ";
      QRLabel100_2->Caption="0";

      lNoGive->Enabled = true;
      lNoGive1->Enabled = true;
      lNoGive2->Enabled = true;
      lMain->Enabled = false;
     }

     QRLabel76->Caption = ZQTax->FieldByName("represent_name")->AsString;
     QRLabel76_2->Caption = QRLabel76->Caption;

     lAbonAddr->Caption=ZQTax->FieldByName("abonaddr")->AsString;
     lResAddr->Caption=ZQTax->FieldByName("resaddr")->AsString;
     lAbonAddr_2->Caption = lAbonAddr->Caption;
     lResAddr_2->Caption = lResAddr->Caption;

//     lResPhone->Caption=ZQTax->FieldByName("resphone")->AsString;
//     lAbonPhone->Caption=ZQTax->FieldByName("abonphone")->AsString;

     AnsiString resPhone =ZQTax->FieldByName("resphone")->AsString.Trim();


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
      lResPhone1->Caption= "-";
      lResPhone2->Caption= "-";
      lResPhone3->Caption= "-";
      lResPhone4->Caption= "-";
      lResPhone5->Caption= "-";
      lResPhone6->Caption= "-";
      lResPhone7->Caption= "-";
      lResPhone8->Caption= "-";
      lResPhone9->Caption= "-";
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

     lResPhone1_2->Caption= lResPhone1->Caption;
     lResPhone2_2->Caption= lResPhone2->Caption;
     lResPhone3_2->Caption= lResPhone3->Caption;
     lResPhone4_2->Caption= lResPhone4->Caption;
     lResPhone5_2->Caption= lResPhone5->Caption;
     lResPhone6_2->Caption= lResPhone6->Caption;
     lResPhone7_2->Caption= lResPhone7->Caption;
     lResPhone8_2->Caption= lResPhone8->Caption;
     lResPhone9_2->Caption= lResPhone9->Caption;
     lResPhone10_2->Caption=lResPhone10->Caption;

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

     AnsiString SpayDate;
     if (ZQTax->FieldByName("pay_date")->IsNull)
     {
      lPayDate1_1->Caption= " ";
      lPayDate2_1->Caption= " ";
      lPayDate3_1->Caption= " ";
      lPayDate4_1->Caption= " ";
      lPayDate5_1->Caption= " ";
      lPayDate6_1->Caption= " ";
      lPayDate7_1->Caption= " ";
      lPayDate8_1->Caption= " ";

     }
     else
     {
      SpayDate =FormatDateTime ("ddmmyyyy",ZQTax->FieldByName("pay_date")->AsDateTime);
      lPayDate1_1->Caption= SpayDate[1];
      lPayDate2_1->Caption= SpayDate[2];
      lPayDate3_1->Caption= SpayDate[3];
      lPayDate4_1->Caption= SpayDate[4];
      lPayDate5_1->Caption= SpayDate[5];
      lPayDate6_1->Caption= SpayDate[6];
      lPayDate7_1->Caption= SpayDate[7];
      lPayDate8_1->Caption= SpayDate[8];
     }

     
     lPayDate1_2->Caption=lPayDate1_1->Caption;
     lPayDate2_2->Caption=lPayDate2_1->Caption;
     lPayDate3_2->Caption=lPayDate3_1->Caption;
     lPayDate4_2->Caption=lPayDate4_1->Caption;
     lPayDate5_2->Caption=lPayDate5_1->Caption;
     lPayDate6_2->Caption=lPayDate6_1->Caption;
     lPayDate7_2->Caption=lPayDate7_1->Caption;
     lPayDate8_2->Caption=lPayDate8_1->Caption;

     lAbonPhone1_2->Caption= lAbonPhone1->Caption;
     lAbonPhone2_2->Caption= lAbonPhone2->Caption;
     lAbonPhone3_2->Caption= lAbonPhone3->Caption;
     lAbonPhone4_2->Caption= lAbonPhone4->Caption;
     lAbonPhone5_2->Caption= lAbonPhone5->Caption;
     lAbonPhone6_2->Caption= lAbonPhone6->Caption;
     lAbonPhone7_2->Caption= lAbonPhone7->Caption;
     lAbonPhone8_2->Caption= lAbonPhone8->Caption;
     lAbonPhone9_2->Caption= lAbonPhone9->Caption;
     lAbonPhone10_2->Caption=lAbonPhone10->Caption;


//     lResPhone_2->Caption = lResPhone->Caption;
//     lAbonPhone_2->Caption = lAbonPhone->Caption;

//     lResSvidNum->Caption=ZQTax->FieldByName("SvidNum_res")->AsString;
     lResSvidNum->Caption=FormatFloat("##00000000",ZQTax->FieldByName("SvidNum_res")->AsFloat);
     lResSvidNum_2->Caption = lResSvidNum->Caption;

//     lContract->Caption="����� �������� � "+ZQTax->FieldByName("doc_num")->AsString+
//     " �� "+ZQTax->FieldByName("doc_dat")->AsString;
     lContract->Caption="������ ��� ���������� ���������� ����㳿";
     lContract_2->Caption = lContract->Caption;

//     lReason->Caption="��������� ���� �������������";
     lReason->Caption=ZQTax->FieldByName("reason")->AsString;
     lDateStr->Caption= FormatDateTime("ddmmyyyy",ZQTax->FieldByName("reg_date")->AsDateTime);
     lReason_2->Caption = lReason->Caption;
     lDateStr_2->Caption = lDateStr->Caption;

     int id_client=ZQTax->FieldByName("abonid")->AsInteger;

     if (ZQTax->FieldByName("flag_reg")->AsInteger!=0)
     {
       lMain2->Enabled = true;
       lMain22->Enabled = true;
     }
     else
     {
       lMain2->Enabled = false;
       lMain22->Enabled = false;
     }  

   };
   ZQTax->Close();


   // ������ ���������� ������
   try
   {
    ZQTaxSumm->Open();
   }
   catch(...)
   {
    ShowMessage("������ ������������ ��.");
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
 if (ZQTaxSumm->FieldByName("cor_tariff")->AsFloat == 0)
 {
   QRDBText4->Enabled=false;
   QRDBText16->Enabled=false;
 }
 else
 {
   QRDBText4->Enabled=true;
   QRDBText16->Enabled=true;
 }

 if (ZQTaxSumm->FieldByName("tariff")->AsFloat == 0)
 {
  QRDBText7->Enabled=false;
  QRDBText6->Enabled=false;
 }
 else
 {
  QRDBText7->Enabled=true;
  QRDBText6->Enabled=true;
 }

}
//---------------------------------------------------------------------------


