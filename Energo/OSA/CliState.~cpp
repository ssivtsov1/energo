//---------------------phon-------------------------------a-----------------------

#include <vcl.h>
#pragma hdrstop

#include "CliState.h"
#include "func.h"
#include "main.h"
#include "MainForm.h"
#include "SysUser.h"
#include "fMailToConfig.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "ZConnect"
#pragma link "ZPgSqlCon"
#pragma link "ZPgSqlQuery"
#pragma link "ZPgSqlTr"
#pragma link "ZQuery"
#pragma link "ZTransact"

#pragma resource "*.dfm"
TFCliState *FCliState;
TWTDBGrid *WAbonGrid;
TWTDBGrid *WAbonAccount;
TWTDBGrid *WAddrGrid;
TWTDBGrid *WBudGrid;
TWTDBGrid *WKwedGrid;
TWTDBGrid *WPropGrid;
TWTDBGrid *WPosGrid;
TWTDBGrid *WKontGrid;
TWTDBGrid *WGrpGrid;
TWTDBGrid *WRozGrid;
TWTDBGrid *WFldGrid;
TWTDBGrid *WDepGrid;
//TWTWinDBGrid *MeterGrid;
//---------------------------------------------------------------------------
__fastcall TFCliState::TFCliState(TComponent* Owner)
        : TfTWTCompForm(Owner)
{

QuerHeadPay->Database=TWTTable::Database;
QuerPay->Database=TWTTable::Database;

 DayPayQuery = new TWTQuery(Application);
 DayPayQuery->Options.Clear();
 DayPayQuery->Options<< doQuickOpen;
 DayPayQuery->RequestLive=true;
 DayPayQuery->CachedUpdates=false;
 DayPayQuery->BeforeInsert=BefInsDayPay;
  DayPayQuery->AfterInsert=BefInsDayPay;

   dsDayPayQuery=new TDataSource(Application);
  dsDayPayQuery->DataSet=DayPayQuery;
  //DBGrDayPay->BeforeInsert=BefInsDayPay;
   //  dsDayPayQuery->BeforeInsert=BefInsDayPay;



//GrSal= new TWTDBGrid(Owner,QuerSal);

}
//---------------------------------------------------------------------------

void _fastcall TFCliState::BefInsDayPay(TDataSet *Sender)
{
//Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=StrToInt(fid_client);
//Sender->FieldByName("id_client")->AsInteger=StrToInt(fid_client);


};
 /*
void _fastcall TFCliState::BefInsDayPay(TDataSet *Sender)
{
//Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=StrToInt(fid_client);
Sender->FieldByName("id_client")->AsInteger=StrToInt(fid_client);


}; */
//---------------------------------------------------------------------------
void __fastcall TFCliState::ShowData(int id_client)
{    if (CheckLevel("Карт.клиента - Счета (закладка)")==0)
      {TShBill->Enabled=false;
      TShBill->TabVisible=false;
      };
     if (CheckLevel("Карт.клиента - Финансовое положение (закладка)")==0)
      {TShFin->Enabled=false;
       TShFin->TabVisible=false;
      };
     if (CheckLevel("Карт.клиента - Основной (закладка)")==0)
      {TShGeneral->Enabled=false;
      TShGeneral->TabVisible=false;
      };
      if (CheckLevel("Карт.клиента - Параметры оплаты (закладка)")==0)
      {TShPay->Enabled=false;
       TShPay->TabVisible=false;
       };

       if (CheckLevel("Карт.клиента - сохранение",1)==0)
     { Caption=Caption+" - только просмотр ";
        TBtnSave->Enabled=false;

    };
   fid_client=id_client;
   TWTQuery *QuerSt=new TWTQuery(this);
   QuerSt->Sql->Clear();
   QuerSt->Sql->Add("select * from clm_statecl_tbl where id_client="+ToStrSQL(fid_client));
   QuerSt->Open();
   TWTQuery *QuerCl=new TWTQuery(this);
   QuerCl->Sql->Clear();
   QuerCl->Sql->Add("select * from clm_client_tbl where id="+ToStrSQL(fid_client));
   QuerCl->Open();
QuerSal= new TWTQuery(this);
   QuerSal->Sql->Clear();
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id \
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   DBGrSald->DataSource=QuerSal->DataSource;
   QuerSal->Open();
QuerBill= new TWTQuery(this);
   QuerBill->Sql->Clear();
   QuerBill->Sql->Add("select b.*,b.value+b.value_tax as value_all, \
      bv.pay,bv.pay_tax,bv.pay+bv.pay_tax as pay_all,bv.rest,bv.rest_tax,bv.rest+bv.rest_tax as rest_all\
               from ( select s.*,p.name as pref from acm_bill_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id \
                          )   b left join  \
                          (select bv.*  from acv_billpay bv \
                           where id_client= :pid_client \
                          ) as bv \
                        on (b.id_doc=bv.id_doc) \
                      order by b.mmgg desc");
   QuerBill->ParamByName("pid_client")->AsInteger=fid_client;
   DBGrBill->DataSource=QuerBill->DataSource;
   QuerBill->Open();

//   LabNClient->Caption=QuerCl->FieldByName("name")->AsString;
   LabIdClient->Caption=QuerCl->FieldByName("id")->AsString;
   EdNName->Text=QuerCl->FieldByName("short_name")->AsString;
    EdAddName->Text=QuerCl->FieldByName("add_name")->AsString;
   EdLName->Text=QuerCl->FieldByName("name")->AsString;
   EdCodeClient->Text=QuerCl->FieldByName("code")->AsString;
   EdPhone->Text=QuerSt->FieldByName("phone")->AsString;
   if (QuerSt->Eof)
   {
     ShowBlank();

     EdOKPO->Text=QuerCl->FieldByName("code_okpo")->AsString;
     fid_addres=QuerCl->FieldByName("id_addres")->AsInteger;
    // fid_addresM=QuerCl->FieldByName("id_addr_main")->AsInteger;
     TWTQuery* QuerAdr=new TWTQuery(this);
     QuerAdr->Sql->Clear();
     QuerAdr->Sql->Add("select  full_adr from  adv_address_tbl where id="+ToStrSQL(fid_addres));
     QuerAdr->Open();
     if (!(QuerAdr->Eof))
       EdAddres->Text=QuerAdr->FieldByName("full_adr")->AsString;
     else
       EdAddres->Text="";
     //QuerAdr->Sql->Clear();
     //QuerAdr->Sql->Add("select  full_adr from  adv_address_tbl where id="+ToStrSQL(fid_addresM));
     //QuerAdr->Open();
     //if (!(QuerAdr->Eof))
       EdAddresM->Text=QuerSt->FieldByName("addr_main")->AsString;
       EdAddresT->Text=QuerSt->FieldByName("addr_tax")->AsString;
       EdAddresLocal->Text=QuerSt->FieldByName("addr_local")->AsString;
     //else
     //  EdAddresM->Text="";
    //

     }
   else
   {
     fins=0;
     fid_addres=QuerCl->FieldByName("id_addres")->AsInteger;
    // fid_addresM=QuerCl->FieldByName("id_addr_main")->AsInteger;
     TWTQuery* QuerAdr=new TWTQuery(this);
     QuerAdr->Sql->Clear();
     QuerAdr->Sql->Add("select  full_adr from  adv_address_tbl where id="+ToStrSQL(fid_addres));
     QuerAdr->Open();
     if (!(QuerAdr->Eof))
       EdAddres->Text=QuerAdr->FieldByName("full_adr")->AsString;
     else
       EdAddres->Text="";
     /*
       QuerAdr->Sql->Clear();
     QuerAdr->Sql->Add("select  full_adr from  adv_address_tbl where id="+ToStrSQL(fid_addresM));
     QuerAdr->Open();
     if (!(QuerAdr->Eof))  */
       EdAddresM->Text=QuerSt->FieldByName("addr_main")->AsString;
       EdAddresT->Text=QuerSt->FieldByName("addr_tax")->AsString;
       EdAddresLocal->Text=QuerSt->FieldByName("addr_local")->AsString;
   /*  else
       EdAddresM->Text="";
     */
     if  (QuerSt->FieldByName("okpo_num")->AsString.IsEmpty())
       EdOKPO->Text=QuerCl->FieldByName("code_okpo")->AsString;
     else
      EdOKPO->Text=QuerSt->FieldByName("okpo_num")->AsString;

     EdLicNum->Text=QuerSt->FieldByName("licens_num")->AsString;
     EdTaxNum->Text=QuerSt->FieldByName("Tax_num")->AsString;
     EdComment->Text=QuerSt->FieldByName("for_undef")->AsString;
     EdMail->Text=QuerSt->FieldByName("e_mail")->AsString;
     EdNumDoc->Text=QuerSt->FieldByName("doc_num")->AsString;

     EdDateDoc->Text=DateToStr(QuerSt->FieldByName("doc_dat")->AsDateTime);
     EdDtClose->Text=DateToStr(QuerCl->FieldByName("dt_close")->AsDateTime);
     //ShowMessage(IntToStr(Now()-50000)+" "+DateToStr(Now()-20000) );
     if  (QuerCl->FieldByName("dt_close")->AsDateTime<Now()-30000)

        EdDtClose->Text="";

     if (!(QuerSt->FieldByName("date_digital")->IsNull))
        EdDateDigital->Text=DateToStr(QuerSt->FieldByName("date_digital")->AsDateTime);

     EdNumDocTend->Text=QuerSt->FieldByName("doc_num_tend")->AsString;
     if (!(QuerSt->FieldByName("doc_dat_tend")->IsNull))
         EdDatDocTend->Text=DateToStr(QuerSt->FieldByName("doc_dat_tend")->AsDateTime);
     fperind=QuerSt->FieldByName("period_indicat")->AsInteger;
     switch( fperind)
     {
      case 1 : { EdPerIndic->Text="месяц";
                break;
                };
      case 2 :  { EdPerIndic->Text="2 месяца";
                 break;
                };
      case 3 :  { EdPerIndic->Text="квартал";
                 break;
                 };
      default : { EdPerIndic->Text="месяц";
                break;
              }
      };
     if (QuerSt->FieldByName("dt_indicat")->AsString.IsEmpty())
        EdDtIndicat->Text="1";
      else
        EdDtIndicat->Text=QuerSt->FieldByName("dt_indicat")->AsString;

     if (!(QuerSt->FieldByName("dt_start")->AsString.IsEmpty()))
         EdDtStart->Text=QuerSt->FieldByName("dt_start")->AsString;
       else
     EdDtStart->Text=EdDtIndicat->Text;
       EdFld->Text=QuerSt->FieldByName("filial_num")->AsString;
     EdMonthIndicat->Text=QuerSt->FieldByName("month_indicat")->AsString;
     EdMonthControl->Text=QuerSt->FieldByName("month_control")->AsString;
     EdPayDay->Text=QuerSt->FieldByName("day_pay_bill")->AsString;
     EdCountPeni->Text=QuerSt->FieldByName("count_peni")->AsString;
     EdComment->Text=QuerSt->FieldByName("for_undef")->AsString;
     EdMail->Text=QuerSt->FieldByName("e_mail")->AsString;
     EdDocGround->Text=QuerSt->FieldByName("doc_ground")->AsString;
     fch_peni=QuerSt->FieldByName("type_peni")->AsInteger;
     fch_3perc_year=QuerSt->FieldByName("flag_3perc_year")->AsInteger;    //from yana

     if (fch_peni==1)
       ChBoxPeni->Checked=true;
     else
       ChBoxPeni->Checked=false;

     if (fch_3perc_year==1)            //from yana
       ChBox3PercYear->Checked=true;    //from yana
     else
       ChBox3PercYear->Checked=false;      //from yana

     fch_cabinet=QuerSt->FieldByName("fl_cabinet")->AsInteger;
     if (fch_cabinet==1)
       ChBoxCabinet->Checked=true;
     else
       ChBoxCabinet->Checked=false;


     fch_bankday=QuerSt->FieldByName("flag_bank_day")->AsInteger;
     if (fch_bankday==1)
       ChBankDay->Checked=true;
     else
       ChBankDay->Checked=false;
     fch_lost=QuerSt->FieldByName("flag_hlosts")->AsInteger;
     if (fch_lost==1)
       ChLost->Checked=true;
     else
       ChLost->Checked=false;

     fch_tax=QuerSt->FieldByName("flag_taxpay")->AsInteger;
     if (fch_tax==1)
       ChBoxTaxPay->Checked=true;
     else
       ChBoxTaxPay->Checked=false;
      fch_budjet=QuerSt->FieldByName("flag_budjet")->AsInteger;
     if (fch_budjet==1)
       ChBoxBudjet->Checked=true;
     else
       ChBoxBudjet->Checked=false;

     fch_ed=QuerSt->FieldByName("flag_ed")->AsInteger;
     if (fch_ed==1)
       ChBoxEd->Checked=true;
     else
       ChBoxEd->Checked=false;

     fch_reactiv=QuerSt->FieldByName("flag_reactive")->AsInteger;
     if (fch_reactiv==5)
       ChBoxReactiv->Checked=true;
     else
       ChBoxReactiv->Checked=false;

     fch_key=QuerSt->FieldByName("flag_key")->AsInteger;
     if (fch_key==1)
       ChBoxKey->Checked=true;
     else
       ChBoxKey->Checked=false;

     fch_del2kr=QuerSt->FieldByName("flag_del2kr")->AsInteger;
     if (fch_del2kr==1)
       Ch2krDel->Checked=true;
     else
       Ch2krDel->Checked=false;

   // EdDt_end_rent->Text=DateToStr(QuerSt->FieldByName("dt_end_rent")->AsDateTime);
      frad_pay=QuerSt->FieldByName("type_pay")->AsInteger;
     if (frad_pay==1)
       RadGrPay->ItemIndex=0;
     else
       RadGrPay->ItemIndex=1;

    frad_jur=QuerSt->FieldByName("flag_jur")->AsInteger;
     if (frad_jur==1)
       RadGrJur->ItemIndex=0;
     else
       RadGrJur->ItemIndex=1;
     LabPClient->Caption=" ";
     fid_kwed=QuerSt->FieldByName("id_kwed")->AsInteger;
     TWTQuery* QuerRep=new TWTQuery(this);
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_kwed));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       {EdKwed->Text=QuerRep->FieldByName("kod")->AsString;
        LabKwed->Caption=QuerRep->FieldByName("val")->AsString;
        }
     else
       {
       EdKwed->Text="";
       LabKwed->Caption="";
       };
     fid_budjet=QuerSt->FieldByName("id_budjet")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_budjet));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdBudjet->Text=QuerRep->FieldByName("name")->AsString;
     else
     EdBudjet->Text="";
     fid_roz=QuerSt->FieldByName("id_section")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_roz));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdRoz->Text=QuerRep->FieldByName("name")->AsString;
     else
     EdRoz->Text="";

     fid_grp=QuerSt->FieldByName("id_grp_industr")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_grp));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdGrp->Text=QuerRep->FieldByName("name")->AsString;
     else
     EdGrp->Text="";

     fid_fld=QuerSt->FieldByName("id_fld_industr")->AsInteger;
    /* QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_fld));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdFld->Text=QuerRep->FieldByName("name")->AsString;
     else  */


     fid_dep=QuerSt->FieldByName("id_depart")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_dep));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdDep->Text=QuerRep->FieldByName("name")->AsString;
     else
     EdDep->Text="";

     /*
     fid_taxprop=QuerSt->FieldByName("id_taxprop")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  cla_param_tbl where id="+ToStrSQL(fid_taxprop));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdTaxProp->Text=QuerRep->FieldByName("name")->AsString;
     else
       EdTaxProp->Text="";
*/
     fid_position=QuerSt->FieldByName("id_position")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  clm_position_tbl where id="+ToStrSQL(fid_position));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdPosition->Text=QuerRep->FieldByName("represent_name")->AsString;
     else
       EdPosition->Text="";

        fid_kontrol=QuerSt->FieldByName("id_kur")->AsInteger;
     QuerRep->Sql->Clear();
     QuerRep->Sql->Add(" select  * from  clm_position_tbl where id="+ToStrSQL(fid_kontrol));
     QuerRep->Open();
     if (!(QuerRep->Eof))
       EdKontrol->Text=QuerRep->FieldByName("represent_name")->AsString;
     else
       EdKontrol->Text="";

       //LabPClient->Caption=LabPClient->Caption+" "+QuerRep->FieldByName("name")->AsString;

       EdPrePayGrn->Text=QuerSt->FieldByName("pre_pay_grn")->AsString;
       EdPrePayDay1->Text=QuerSt->FieldByName("pre_pay_day1")->AsString;
       EdPrePayPerc1->Text=QuerSt->FieldByName("pre_pay_perc1")->AsString;
       EdPrePayDay2->Text=QuerSt->FieldByName("pre_pay_day2")->AsString;
       EdPrePayPerc2->Text=QuerSt->FieldByName("pre_pay_perc2")->AsString;
       EdPrePayDay3->Text=QuerSt->FieldByName("pre_pay_day3")->AsString;
       EdPrePayPerc3->Text=QuerSt->FieldByName("pre_pay_perc3")->AsString;
      edTrDocNum->Text = QuerSt->FieldByName("tr_doc_num")->AsString;

    if (!(QuerSt->FieldByName("tr_doc_date")->IsNull))
      edTrDocDate->Text = DateToStr(QuerSt->FieldByName("tr_doc_date")->AsDateTime);

    if (!(QuerSt->FieldByName("kosht_date_b")->IsNull))
      edKoshtDateB->Text = DateToStr(QuerSt->FieldByName("kosht_date_b")->AsDateTime);       // from yana

    if (!(QuerSt->FieldByName("kosht_date_e")->IsNull))
      edKoshtDateE->Text = DateToStr(QuerSt->FieldByName("kosht_date_e")->AsDateTime);      // from yana

    edTrYearPrice->Text = QuerSt->FieldByName("tr_year_price")->AsString;

    if (QuerSt->FieldByName("tr_doc_type")->AsInteger==0)
      cbTrDocType->ItemIndex = 3;
    else
      cbTrDocType->ItemIndex = QuerSt->FieldByName("tr_doc_type")->AsInteger-1;

    if (QuerSt->FieldByName("tr_doc_period")->AsInteger==0)
      cbTrPayPeriod->ItemIndex = 3;
    else
      cbTrPayPeriod->ItemIndex = QuerSt->FieldByName("tr_doc_period")->AsInteger-1;


};
  ShowDayPayGrid();
};
void __fastcall TFCliState::SaveData()
{

};
//--------------------------------------------------------------------------------------
void __fastcall TFCliState::ShowBlank()
{
 // fid_client=0;
   //LabNClient->Caption="";
  TWTQuery *ZQuery = new TWTQuery(this);
    ZQuery->Options<< doQuickOpen;
  ZQuery->RequestLive=false;
  ZQuery->CachedUpdates=false;
  AnsiString sqlstr="select getsysvar('pay_day') as pay_day;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
    try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("Ошибка SQL :"+sqlstr);
   return;
  }
   EdPayDay->Text = ZQuery->FieldByName("pay_day")->AsString;
   ZQuery->Close();

  sqlstr="select getsysvar('penalty') as penalty;";
  ZQuery->Sql->Clear();
  ZQuery->Sql->Add(sqlstr);
    try
  {
   ZQuery->Open();
  }
  catch(...)
  {
   ShowMessage("Ошибка SQL :"+sqlstr);
   return;
  }
   EdCountPeni->Text = ZQuery->FieldByName("penalty")->AsString;
   ZQuery->Close();

   LabIdClient->Caption="";
   //EdCodeClient->Text="";
   EdAddres->Text="";
   EdAddresM->Text="";
   EdAddresT->Text="";
   EdAddresLocal->Text="";
   EdOKPO->Text="";
   EdLicNum->Text="";
   EdTaxNum->Text="";
   EdComment->Text="";
   EdMail->Text="";
   EdKwed->Text="";
   LabKwed->Caption="";
   EdPosition->Text="";
   EdKontrol->Text="";
   EdPhone->Text="";
   EdDocGround->Text="згідно статуту";
   //EdLName->Text="";
     EdNumDoc->Text="";
     EdDateDoc->Text="";
     EdDtClose->Text="";
     EdDateDigital->Text="";
     //EdDt_end_rent->Text="";
     fperind=1;
     EdPerIndic->Text="месяц";
     EdDtIndicat->Text="1";
     EdDtStart->Text="2";
     EdMonthIndicat->Text="1";
     EdMonthControl->Text="1";

     //EdPayDay->Text="3";
     //EdCountPeni->Text="0";

     fch_cabinet = 0;
     fch_peni=1;
     fch_3perc_year=0;       // from yana
     if (fch_peni==1)
       ChBoxPeni->Checked=true;
     else
       ChBoxPeni->Checked=false;

       if (fch_3perc_year==1)           //from yana
       ChBox3PercYear->Checked=true;              //from yana
     else
       ChBox3PercYear->Checked=false;         //from yana

     fch_bankday=0;
     if (fch_bankday==1)
       ChBankDay->Checked=true;
     else
       ChBankDay->Checked=false;
     fch_tax=1;
     if (fch_tax==1)
       ChBoxTaxPay->Checked=true;
     else
       ChBoxTaxPay->Checked=false;
     fch_reactiv=0;
     if (fch_reactiv==5)
       ChBoxReactiv->Checked=true;
     else
       ChBoxReactiv->Checked=false;

     fch_key=0;
     if (fch_key==1)
       ChBoxKey->Checked=true;
     else
       ChBoxKey->Checked=false;


     fch_lost=0;
     if (fch_lost==1)
       ChLost->Checked=true;
     else
       ChLost->Checked=false;

     fch_del2kr=0;
     Ch2krDel->Checked=false;

      frad_pay=0;
     if (frad_pay==1)
       RadGrPay->ItemIndex=0;
     else
       RadGrPay->ItemIndex=1;
             frad_jur=1;
     if (frad_jur==1)
       RadGrJur->ItemIndex=0;
     else
       RadGrJur->ItemIndex=1;

     LabPClient->Caption=" ";
     fid_kwed=0;
     EdKwed->Text="";
     LabKwed->Caption="";
     fid_budjet=0;
     EdBudjet->Text="";
     fid_position=0;
     EdPosition->Text="";
      fid_kontrol=0;
     EdKontrol->Text="";
     fid_roz=0;
     EdRoz->Text="";
     fid_grp=0;
     EdGrp->Text="";
     fid_fld=0;
     EdFld->Text="";
     fid_dep=0;
     EdDep->Text="";
  //   fid_taxprop=0;
  //   EdTaxProp->Text="";
       EdPrePayGrn->Text="0";
       EdPrePayDay1->Text="0";
       EdPrePayPerc1->Text="0";
       EdPrePayDay2->Text="0";
       EdPrePayPerc2->Text="0";
       EdPrePayDay3->Text="0";
       EdPrePayPerc3->Text="0";
        edTrDocNum->Text = "";
     edTrDocDate->Text = "";
     edKoshtDateB->Text = "";   // from yana
     edKoshtDateE->Text = "";   // from yana

     edTrYearPrice->Text = "0";
     cbTrDocType->ItemIndex = 2;
     cbTrPayPeriod->ItemIndex = 2;

};
//---------------------------------------------------------------------------

void __fastcall TFCliState::FormClose(TObject *Sender, TCloseAction &Action)
{       CheckDoState(this);
        TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::EdIntKeyPress(TObject *Sender, char &Key)
{    if (( Key==VK_BACK)||( Key==VK_TAB)||( Key==VK_ESCAPE)||( Key==VK_END)
  ||( Key==VK_HOME)||( Key==VK_LEFT)||  ( Key==VK_RIGHT)||( Key==VK_DELETE))
   {    return;
   };

   if ((Key > '9') || (Key < '0')) Key=NULL;
}

void __fastcall TFCliState::EdFloatKeyPress(TObject *Sender, char &Key)
{
    if (DecimalSeparator=='.')
      { if (Key==',')
        { Key='.';
          return;
         };
       }
      else
        if (Key=='.')
         { Key=',';
         return;
         };


    if (Key=='-')
      { Key='-';
        return;
      }
     if (( Key==VK_BACK)||( Key==VK_TAB)||( Key==VK_ESCAPE)||( Key==VK_END)
  ||( Key==VK_HOME)||( Key==VK_LEFT)||  ( Key==VK_RIGHT)||( Key==VK_DELETE))
   {  Key=Key;
      return;
   };

     if ((Key > '9') || (Key < '0')) Key=NULL;

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::EdCodeClientChange(TObject *Sender)
{   TWTQuery *QuerC=new TWTQuery(this);
  if (ALLTRIM(((TEdit*)Sender)->Text).IsEmpty()) return;
    QuerC->Sql->Add("select c.id,c.code,c.name as namecl ");
    QuerC->Sql->Add("from clm_client_tbl c ");
    QuerC->Sql->Add("where c.book<0 and c.code="+ ToStrSQL(StrToInt(ALLTRIM(((TEdit*)Sender)->Text))));


    //QuerC->ParamByName("pid_client")->AsInteger=StrToInt(ToStrSQL(((TEdit*)Sender)->Text));
    QuerC->Open();
    if ((QuerC->Eof))
     {
//        ShowMessage("Нет такого лицевого счета! Вызовите справочник!");
        EdNName->Text="";
        EdAddName->Text="";
        EdLName->Text="";
        fid_client=0;
        ShowBlank();
     }
     else
     {  CheckDoState(this);
       ShowData(QuerC->FieldByName("id")->AsInteger);

      };

}

int __fastcall TFCliState::StrToIntI(AnsiString Send)
{ if (Send.IsEmpty()) Send="0";
  return StrToInt(Send);
}

float __fastcall TFCliState::StrToFloatI(AnsiString Send)
{ if (Send.IsEmpty()) Send="00";
  return StrToFloat(Send);
}

//---------------------------------------------------------------------------

void __fastcall TFCliState::SBtnClientClick(TObject *Sender)
{
   // Выбрать абонента
  TWTDBGrid* Grid;
  Grid=MainForm->CliClientMSel();
  if(Grid==NULL) return;
  else WAbonGrid=Grid;

 // WAbonGrid->FieldSource = WAbonGrid->Table->GetTField("id");
 WAbonGrid->FieldSource = WAbonGrid->Query->GetTField("id");
  WAbonGrid->StringDest = "1";
  WAbonGrid->OnAccept=AbonAccept;

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::AbonAccept (TObject* Sender)
{
   if(fid_client!=WAbonGrid->Query->FieldByName("id")->AsInteger)
   {

   };

   fid_client=WAbonGrid->Query->FieldByName("id")->AsInteger;
   EdCodeClient->Text=WAbonGrid->Query->FieldByName("code")->AsString;
   ShowData(fid_client);

};
void __fastcall TFCliState::SBtnBankClick(TObject *Sender)
{
 TWTDBGrid* Grid;
  Grid=MainForm->AccClientSel(fid_client,NULL);
  if(Grid==NULL) return;
  else WAbonAccount=Grid;

  WAbonAccount->FieldSource = WAbonAccount->Table->GetTField("account");
  WAbonAccount->StringDest = "1";

}



//---------------------------------------------------------------------------

void __fastcall TFCliState::BtnAdrClick(TObject *Sender)
{  int EmpS=1;
    TWTDBGrid* Grid;
   Grid=MainForm->AdmAddressMSel(NULL,fid_addres);
   if(Grid==NULL) return;
    else WAddrGrid=Grid;
   WAddrGrid->FieldSource= WAddrGrid->Table->GetTField("id");
   WAddrGrid->StringDest = fid_addres;
  //WFBudGrid->FieldSource= WFBudGrid->Table->GetTField("name");
   if (!EdAddres->Text.IsEmpty())
    WAddrGrid->StringDest = fid_addres;
   else
     WAddrGrid->StringDest = EmpS;

   WAddrGrid->OnAccept=MainAddrAccept;
}
#define WinName "Протоколы согласования по абоненту  "
void __fastcall TFCliState::BtnProtClick(TObject *Sender)
{    if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner)) {
   // return null;
  }
      TWTQuery *QuerC;
   QuerC=new  TWTQuery(this);
   QuerC->Sql->Add("select *  from clm_client_tbl where id=:pid_client ");
   QuerC->ParamByName("pid_client")->AsInteger=fid_client;
   QuerC->Open();
    AnsiString namecl=QuerC->FieldByName("short_name")->AsString;
   TWTQuery *QEnv=new TWTQuery(this);
        QEnv->Sql->Clear();
    QEnv->Sql->Add("select * from clm_protocol_tbl u  \
          where u.id_client=:pid_client");
    QEnv->ParamByName("pid_client")->AsInteger=fid_client;
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QEnv,false);
      WGrid->SetCaption(WinName);

    TWTDBGrid* DBGrEnv=WGrid->DBGrid;

      TStringList *WListI=new TStringList();
     DBGrEnv->Query->Open();
   WListI->Add("id");
   TStringList *NListI=new TStringList();

   DBGrEnv->Query->SetSQLModify("clm_protocol_tbl",WListI,NListI,true,true,true);


  TWTField *Field;


  Field = DBGrEnv->AddColumn("mmgg", "Период протокола", "Период протокола");
  Field->SetWidth(90);

  Field = DBGrEnv->AddColumn("reg_num", "Номер протокола", "Номер протокола");
  Field->SetWidth(300);

  Field = DBGrEnv->AddColumn("reg_date", "Период протокола", "Период протокола");
  Field->SetWidth(90);

  Field = DBGrEnv->AddColumn("comment", "примечания", "примечания");
   Field->SetWidth(300);
  DBGrEnv->AfterInsert=AfterInsGrParam;

 WGrid->DBGrid->Visible = true;
 WGrid->SetCaption(WinName+namecl);
  WGrid->ShowAs("table");
}
void _fastcall TFCliState::AfterInsGrParam(TWTDBGrid *Sender)
{
Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=fid_client;
};
#undef WinName



#define WinName "Список окончания договоров аренды"
void __fastcall TFCliState::BtnRentClick(TObject *Sender)
{    if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner))
{
   // return null;
  }
   TWTQuery *QEnv=new TWTQuery(this);
        QEnv->Sql->Clear();
    QEnv->Sql->Add("select * from clm_renthist_tbl u  \
          where u.id_client=:pid_client");
    QEnv->ParamByName("pid_client")->AsInteger=fid_client;
   // QEnv->Open();
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QEnv,false);
      WGrid->SetCaption(WinName);

    DBGrEnv=WGrid->DBGrid;

      TWTQuery *QueryAdr;
   QueryAdr=new  TWTQuery(this);
   QueryAdr->Sql->Add("select a.id,a.adr::::varchar(255),a.dom_reg::::varchar(255) from adv_address_tbl a ");
   QueryAdr->Open();


    DBGrEnv->Query->AddLookupField("name_adr", "ID_ADDRES", QueryAdr, "adr","id");
      TWTQuery * QEqp=new TWTQuery(this);
   QEqp->Sql->Add("select id ,name_eqp from eqm_equipment_tbl where type_eqp=12");
   QEqp->Open();
   DBGrEnv->Query->AddLookupField("point","id_point",QEqp,"name_eqp","id");

     TStringList *WListI=new TStringList();
     DBGrEnv->Query->Open();
   WListI->Add("id");
   TStringList *NListI=new TStringList();
   //NListI->Add("name_adr");
    DBGrEnv->Query->SetSQLModify("clm_renthist_tbl",WListI,NListI,true,true,true);




  TWTField *Field;

    Field = DBGrEnv->AddColumn("point", "Точка учета", "Точка учета");
    Field->SetOnHelp(BtnPointClick);
    Field->SetWidth(300);

  Field = DBGrEnv->AddColumn("name_object", "Название обьекта", "Обьект");
  Field->SetWidth(300);

  Field = DBGrEnv->AddColumn("dt_rent_end", "Дата окончания", "Дата окончания");
  Field->SetWidth(90);

  Field = DBGrEnv->AddColumn("name_adr", "Адрес", "Адрес");
  Field->SetOnHelp(((TMainForm*)MainForm)->AdmAddressMineSpr);
  Field->SetWidth(300);

   Field = DBGrEnv->AddColumn("flag", "призн.", "");
   Field->AddFixedVariable("0", "     ");
   Field->AddFixedVariable("9", "откл.");
   Field->SetDefValue("0");
   Field->SetWidth(50);


  Field = DBGrEnv->AddColumn("comment", "примечания", "примечания");
   Field->SetWidth(300);
  DBGrEnv->AfterInsert=AfterInsGrParam;

 WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("table");
}
/*void _fastcall TFCliState::AfterInsGrParam(TWTDBGrid *Sender)
{
Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=fid_client;
};*/
#undef WinName

void __fastcall TFCliState::BtnPointClick(TWTField *Sender)
{

  Application->CreateForm(__classid(TfTreeForm), &fSelectTree);
  fSelectTree->tTreeEdit->OnDblClick=tTreeEditDblClick;
  fSelectTree->OnCloseQuery=FormCloseQuery;
  int fid_eqp=Sender->Field->AsInteger;
  fid_cl=fid_client;
  fSelectTree->ShowTrees(fid_cl,true,fid_eqp);

 };



void __fastcall TFCliState::tTreeEditDblClick(TObject *Sender)
{
if ((fSelectTree->CurrNode!=NULL)&&(fSelectTree->CurrNode->ImageIndex!=0))
 {
 fid_eqp=fSelectTree->CurrNode->StateIndex;
 if (!((DBGrEnv->DataSource->DataSet->State==dsInsert) ||
        (DBGrEnv->DataSource->DataSet->State==dsEdit)) )

 //((DBGrInd->DataSource->DataSet->State!=dsEdit) || (DBGrInd->DataSource->DataSet!=dsInsert))
          DBGrEnv->DataSource->DataSet->Edit();

 if (PTreeNodeData(fSelectTree->CurrNode->Data)->type_eqp!=12)
   { ShowMessage("Выберите точку учета !!");
     return;
   };
 DBGrEnv->DataSource->DataSet->FieldByName("id_point")->AsInteger=fid_eqp;
 if (fid_eqp>=0)
 {
  TWTQuery *QAdrP=new TWTQuery(this);
  QAdrP->Sql->Add("select e.*,a.adr from eqm_equipment_tbl e \
   left join adv_address_tbl a on a.id=e.id_addres where e.id="+ToStrSQL(fid_eqp));
  QAdrP->Open();
  if (QAdrP->FieldByName("id_addres")->AsInteger>0)
   { DBGrEnv->DataSource->DataSet->FieldByName("id_addres")->AsInteger=QAdrP->FieldByName("id_addres")->AsInteger;
    //DBGrEnv->DataSource->DataSet->FieldByName("name_object")->AsString=QAdrP->FieldByName("name_eqp")->AsString+" "+QAdrP->FieldByName("adr")->AsString;
   };
 };
 TTreeNode *Node1;
 Node1=fSelectTree->CurrNode;
 /*while(Node1->ImageIndex!=0){
    Node1=Node1->Parent;
 }; */
// fid_treeparent=Node1->StateIndex;
 fSelectTree->Close();
 };

}

void __fastcall TFCliState::FormCloseQuery(TObject *Sender, bool &CanClose)
{

 fSelectTree->ClearTemp();

 }
void __fastcall TFCliState::MainAddrAccept (TObject* Sender)
{
    fid_addres=WAddrGrid->Table->FieldByName("id")->AsInteger;
     TWTQuery *QuerAdr=new TWTQuery(this);
     QuerAdr->Sql->Clear();
     QuerAdr->Sql->Add("select adr::::varchar(255) from adv_address_tbl where id = :pid_adr");
     QuerAdr->ParamByName("pid_adr")->AsInteger=fid_addres;
     try
     {
      QuerAdr->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerAdr->Close();
      return;
     }
     QuerAdr->First();

     EdAddres->Text=QuerAdr->Fields->Fields[0]->AsString;
     QuerAdr->Close();
     //IsModified=true;

};
/*
void __fastcall TFCliState::BtnAdrClickM(TObject *Sender)
{  int EmpS=1;
    TWTDBGrid* Grid;
   Grid=MainForm->AdmAddressMSel(NULL,fid_addresM);
   if(Grid==NULL) return;
    else WAddrGrid=Grid;
   WAddrGrid->FieldSource= WAddrGrid->Table->GetTField("id");
   WAddrGrid->StringDest = fid_addres;
  //WFBudGrid->FieldSource= WFBudGrid->Table->GetTField("name");
   if (!EdAddresM->Text.IsEmpty())
    WAddrGrid->StringDest = fid_addresM;
   else
     WAddrGrid->StringDest = EmpS;

   WAddrGrid->OnAccept=MainAddrAcceptM;
}

void __fastcall TFCliState::MainAddrAcceptM (TObject* Sender)
{
    fid_addresM=WAddrGrid->Table->FieldByName("id")->AsInteger;
     TWTQuery *QuerAdr=new TWTQuery(this);
     QuerAdr->Sql->Clear();
     QuerAdr->Sql->Add("select full_adr from adv_address_tbl where id = :pid_adr");
     QuerAdr->ParamByName("pid_adr")->AsInteger=fid_addresM;
     try
     {
      QuerAdr->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerAdr->Close();
      return;
     }
     QuerAdr->First();

     EdAddresM->Text=QuerAdr->Fields->Fields[0]->AsString;
     QuerAdr->Close();
     //IsModified=true;

};

 */
void __fastcall TFCliState::ChBoxTaxPayClick(TObject *Sender)
{
 if(ChBoxTaxPay->Checked==false) fch_tax=0; else fch_tax=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBoxReactivClick(TObject *Sender)
{
   if(ChBoxReactiv->Checked==false) fch_reactiv=0; else fch_reactiv=5;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::RadGrPayExit(TObject *Sender)
{                              /*
     frad_pay==QuerSt->FieldByName("type_pay")->AsInteger;
     if (frad_pay==1)
       RadGrPay->ItemIndex=0;
     else
       RadGrPay->ItemIndex=1;*/

   if(RadGrPay->ItemIndex==1) frad_pay=0; else frad_pay=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBoxPeniClick(TObject *Sender)
{
   if(ChBoxPeni->Checked==false) fch_peni=0; else fch_peni=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::BtnKwedClick(TObject *Sender)
{  AnsiString EmpS="  ";
   TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_kwed");
   if(Grid==NULL) return;
    else WKwedGrid=Grid;
   WKwedGrid->FieldSource= WKwedGrid->Table->GetTField("kod");
   if (!EdKwed->Text.IsEmpty())
    { TWTQuery *QuerKw=new TWTQuery(this);
     //AnsiString st=STRTRAN(EdKwed->Text," ","");
       AnsiString st=EdKwed->Text;
    st=STRTRAN(st,"..",".");
   // st=STRTRAN(st," .","");
    st=STRTRAN(st,"  .","");
    st=STRTRAN(st,".  ","");
    st=STRTRAN(st,". ",".");
     st=STRTRAN(st," .",".");
       st=ALLTRIM(st);
     QuerKw->Sql->Add("select * ");
     QuerKw->Sql->Add("from cla_param_tbl  ");
     QuerKw->Sql->Add("where kod like '"+st+"%'");
     QuerKw->Sql->Add(" order by kod");
     QuerKw->Open();
     AnsiString St1=" ";
     if (!(QuerKw->Eof))
           St1=QuerKw->FieldByName("kod")->AsString;
     WKwedGrid->StringDest = St1;
   }
   else
     WKwedGrid->StringDest = EmpS;
   WKwedGrid->OnAccept=KwedAccept;
}

void __fastcall TFCliState::KwedAccept (TObject* Sender)
{
    fid_kwed=WKwedGrid->Table->FieldByName("id")->AsInteger;


     TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select kod,name,val from cla_param_tbl where id = :pid_kwed");
     QuerFld->ParamByName("pid_kwed")->AsInteger=fid_kwed;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdKwed->Text=QuerFld->Fields->Fields[0]->AsString;
     LabKwed->Caption=QuerFld->Fields->Fields[2]->AsString;
     QuerFld->Close();
     delete QuerFld;
     //IsModified=true;

     };

//---------------------------------------------------------------------------

 void __fastcall TFCliState::BtnBudjetClick(TObject *Sender)
{  AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_budjet");
   if(Grid==NULL) return;
    else WBudGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WBudGrid->FieldSource= WBudGrid->Table->GetTField("name");
   if (!EdBudjet->Text.IsEmpty())
    WBudGrid->StringDest = EdBudjet->Text;
   else
     WBudGrid->StringDest = EmpS;

   WBudGrid->OnAccept=BudAccept;

}

void __fastcall TFCliState::BudAccept (TObject* Sender)
{
    fid_budjet=WBudGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_budjet;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdBudjet->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
     //IsModified=true;


};
//---------------------------------------------------------------------------
void __fastcall TFCliState::BtnPosClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
  int id_res=0;
  AnsiString filt="";
  TWTQuery *QuerRes=new TWTQuery(this);
  QuerRes->Sql->Add("select syi_resid_fun() as idres");
  QuerRes->Open();
   id_res=QuerRes->FieldByName("idres")->AsInteger;
   filt="id_client="+ToStrSQL(id_res);
  Grid=MainForm->CliPositionSel(NULL,filt);
   if(Grid==NULL) return;
    else WPosGrid=Grid;
   WPosGrid->FieldSource= WPosGrid->Table->GetTField("id");
   if (!EdPosition->Text.IsEmpty())
    WPosGrid->StringDest = EdPosition->Text;
   else
     WPosGrid->StringDest = EmpS;
   WPosGrid->OnAccept=PosAccept;
}

void __fastcall TFCliState::PosAccept (TObject* Sender)
{
  fid_position=WPosGrid->Table->FieldByName("id")->AsInteger;
       TWTQuery *QuerFld=new TWTQuery(this);
     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select represent_name from clm_position_tbl where id = :pid_position");
     QuerFld->ParamByName("pid_position")->AsInteger=fid_position;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdPosition->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
     //IsModified=true;


};

void __fastcall TFCliState::BtnKontClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
  int id_res=0;
  AnsiString filt="";
  TWTQuery *QuerRes=new TWTQuery(this);
  QuerRes->Sql->Add("select syi_resid_fun() as idres");
  QuerRes->Open();
   id_res=QuerRes->FieldByName("idres")->AsInteger;
   filt="id_client="+ToStrSQL(id_res);
  Grid=MainForm->CliPositionSel(NULL,filt);
   if(Grid==NULL) return;
    else WKontGrid=Grid;
   WKontGrid->FieldSource= WKontGrid->Table->GetTField("id");
   if (!EdKontrol->Text.IsEmpty())
    WKontGrid->StringDest = EdKontrol->Text;
   else
     WKontGrid->StringDest = EmpS;
   WKontGrid->OnAccept=KontAccept;
}

void __fastcall TFCliState::KontAccept (TObject* Sender)
{
  fid_kontrol=WKontGrid->Table->FieldByName("id")->AsInteger;
       TWTQuery *QuerFld=new TWTQuery(this);
     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select represent_name from clm_position_tbl where id = :pid_kontrol");
     QuerFld->ParamByName("pid_kontrol")->AsInteger=fid_kontrol;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdKontrol->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
     //IsModified=true;


};


 /*AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_act");
   if(Grid==NULL) return;
    else WPosGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WPosGrid->FieldSource= WPosGrid->Table->GetTField("name");
   if (!EdActivity->Text.IsEmpty())
    WActGrid->StringDest = EdActivity->Text;
   else
     WActGrid->StringDest = EmpS;

   WActGrid->OnAccept=ActAccept;
   */
//}

//void __fastcall TFCliState::ActAccept (TObject* Sender)
//{
  /*  fid_activity=WActGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_activity;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdActivity->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
     //IsModified=true;

    */
//};


//---------------------------------------------------------------------------

void __fastcall TFCliState::BtnGrpClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_ind");
   if(Grid==NULL) return;
    else WGrpGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WGrpGrid->FieldSource= WGrpGrid->Table->GetTField("name");
   if (!EdGrp->Text.IsEmpty())
    WGrpGrid->StringDest = EdGrp->Text;
   else
     WGrpGrid->StringDest = EmpS;

   WGrpGrid->OnAccept=GrpAccept;

}

void __fastcall TFCliState::GrpAccept (TObject* Sender)
{
    fid_grp=WGrpGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_grp;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdGrp->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
};


void __fastcall TFCliState::BtnRozClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_sect");
   if(Grid==NULL) return;
    else WRozGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WRozGrid->FieldSource= WRozGrid->Table->GetTField("name");
   if (!EdRoz->Text.IsEmpty())
    WRozGrid->StringDest = EdRoz->Text;
   else
     WRozGrid->StringDest = EmpS;

   WRozGrid->OnAccept=RozAccept;

}

void __fastcall TFCliState::RozAccept (TObject* Sender)
{
    fid_roz=WRozGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_roz;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdRoz->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
};

void __fastcall TFCliState::BtnFldClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_fld");
   if(Grid==NULL) return;
    else WFldGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WFldGrid->FieldSource= WFldGrid->Table->GetTField("name");
   /*if (!EdFld->Text.IsEmpty())
    WFldGrid->StringDest = EdFld->Text;
   else
     WFldGrid->StringDest = EmpS;

   WFldGrid->OnAccept=FldAccept;
  */
}

void __fastcall TFCliState::FldAccept (TObject* Sender)
{
    fid_fld=WFldGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_fld;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

   //  EdFld->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
};

void __fastcall TFCliState::BtnDepClick(TObject *Sender)
{
 AnsiString EmpS="  ";
  TWTDBGrid* Grid;
   Grid=MainForm->ClmSprParSMSel(NULL,NULL,"~gr_min");
   if(Grid==NULL) return;
    else WDepGrid=Grid;
   //WFldGrid->FieldSource= WFldGrid->Table->GetTField("id");
  // WAddrGrid->StringDest = fid_addres;
   WDepGrid->FieldSource= WDepGrid->Table->GetTField("name");
   if (!EdDep->Text.IsEmpty())
    WDepGrid->StringDest = EdDep->Text;
   else
     WDepGrid->StringDest = EmpS;

   WDepGrid->OnAccept=DepAccept;

}

void __fastcall TFCliState::DepAccept (TObject* Sender)
{
    fid_dep=WDepGrid->Table->FieldByName("id")->AsInteger;

       TWTQuery *QuerFld=new TWTQuery(this);

     QuerFld->Sql->Clear();
     QuerFld->Sql->Add("select name from cla_param_tbl where id = :pid_industr");
     QuerFld->ParamByName("pid_industr")->AsInteger=fid_dep;
     try
     {
      QuerFld->Open();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :");
      QuerFld->Close();
      return;
     }
     QuerFld->First();

     EdDep->Text=QuerFld->Fields->Fields[0]->AsString;
     QuerFld->Close();
     delete QuerFld;
};



void __fastcall TFCliState::TBtnSaveClick(TObject *Sender)
{
   if (CheckLevel("Карт.клиента - сохранение",0)==0)
     { ShowMessage("У вас нет прав на изменение карточки!");
       return;
    };

  int inscl=0;
   int insst=0;
   if (EdCodeClient->Text.IsEmpty())
     { ShowMessage ("Заполните код клиента !");
       return;
     }


   if (fch_ed==1 && frad_jur!=1 && EdAddName->Text.IsEmpty())
     { ShowMessage ("Для ФОП на ед.налоге заполните фамилию,имя,отчество на вкладке <Параметры оплаты>!");
       return;
     }


   TWTQuery *QuerInCl=new TWTQuery(this);
   TWTQuery *QuerInSt=new TWTQuery(this);
   TWTQuery *QuerCl=new TWTQuery(this);
    QuerCl->Sql->Add("select * from clm_client_tbl c where id= "+ToStrSQL(fid_client));
    QuerCl->Open();
    if(QuerCl->Eof)
      inscl=1;
   TWTQuery *QuerSt=new TWTQuery(this);
    QuerSt->Sql->Add("select * from clm_statecl_tbl c where id_client= "+ToStrSQL(fid_client));
    QuerSt->Open();
    if(QuerSt->Eof)
      insst=1;

  if (inscl)
  {
      int pid_newres=0;
      AnsiString fres=MainForm->GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='id_res'");
       if (!(fres.IsEmpty()))
   {
    pid_newres=StrToInt(fres);
    };
     int pid_newdep=0;
       fres=MainForm->GetValueFromBase("select value_ident from syi_sysvars_tbl where ident='kod_res'");
       if (!(fres.IsEmpty()))
   {
    pid_newdep=StrToInt(fres);
    };

    QuerInCl->Sql->Add("insert into clm_client_tbl (  code,id_department,kind_dep,idk_work,name,short_name, \
         id_addres,code_okpo,add_name ) \
      values ( :pcode,:pid_department,:pid_dep,:pidk_work,:pname,:psname, \
       :pid_addres, :pcode_okpo,:paname ) ");

    QuerInCl->ParamByName("pcode")->AsInteger=StrToInt(EdCodeClient->Text);
    QuerInCl->ParamByName("pid_addres")->AsInteger=fid_addres;
     QuerInCl->ParamByName("pcode_okpo")->AsString=EdOKPO->Text;
    QuerInCl->ParamByName("pname")->AsString=EdLName->Text;
    QuerInCl->ParamByName("psname")->AsString=EdNName->Text;
     QuerInCl->ParamByName("paname")->AsString=EdAddName->Text;
    QuerInCl->ParamByName("pid_department")->AsInteger=pid_newres;
    QuerInCl->ParamByName("pid_dep")->AsInteger=pid_newdep;
    QuerInCl->ParamByName("pidk_work")->AsInteger=1;

    QuerInCl->ExecSql();
    TWTQuery *QuerIns=new TWTQuery(this);
    QuerIns->Sql->Add("select currval('clm_client_seq')::::int");
    QuerIns->Open();
    fid_client=QuerIns->FieldByName("currval")->AsInteger;
   }
  else
  {
    QuerInCl->Sql->Add("update clm_client_tbl set code=:pcode ,  ");
    QuerInCl->Sql->Add(" id_addres=:pid_addres,code_okpo=:pcode_okpo, ");
    QuerInCl->Sql->Add(" name=:pname,short_name=:psname,add_name=:paname,dt_close=:pdt_close ");
    QuerInCl->Sql->Add(" where id="+ToStrSQL(fid_client));
    QuerInCl->ParamByName("pcode")->AsInteger=StrToInt(EdCodeClient->Text);
    QuerInCl->ParamByName("pid_addres")->AsInteger=fid_addres;

    QuerInCl->ParamByName("pcode_okpo")->AsString=EdOKPO->Text;
    QuerInCl->ParamByName("pname")->AsString=EdLName->Text;
    QuerInCl->ParamByName("psname")->AsString=EdNName->Text;
    QuerInCl->ParamByName("paname")->AsString=EdAddName->Text;
        QuerInCl->ParamByName("pdt_close")->Clear();
   if  ((EdDtClose->Text!="") && (EdDtClose->Text!="  .  .    "))
    QuerInCl->ParamByName("pdt_close")->AsDateTime=EdDtClose->Text;

    QuerInCl->ExecSql();
  };

  if (insst)
  {
    QuerInSt->Sql->Add("insert into clm_statecl_tbl (  id_client,tax_num,flag_taxpay,  ");
    QuerInSt->Sql->Add("licens_num,okpo_num, doc_num,doc_dat,doc_ground,");
    QuerInSt->Sql->Add("id_budjet,id_kwed,id_taxprop,id_position,id_kur,flag_reactive,flag_budjet,");
    QuerInSt->Sql->Add("period_indicat,dt_indicat,month_indicat,month_control,dt_start,day_pay_bill,type_pay,");
    QuerInSt->Sql->Add("pre_pay_grn,pre_pay_day1,pre_pay_perc1,pre_pay_day2,pre_pay_perc2,pre_pay_day3,pre_pay_perc3,");
    QuerInSt->Sql->Add("type_peni,count_peni,flag_3perc_year,phone,flag_hlosts,\
     id_section,filial_num,id_grp_industr,id_depart,for_undef,addr_main,addr_tax, addr_local, flag_key,flag_bank_day,flag_del2kr, \
     tr_doc_num,tr_doc_date,kosht_date_b,kosht_date_e,tr_year_price,tr_doc_type,tr_doc_period,doc_num_tend,doc_dat_tend, flag_ed, flag_jur,e_mail, fl_cabinet, date_digital  )");
    QuerInSt->Sql->Add(" values (:pid_client,:ptax_num,:pflag_taxpay,  ");
    QuerInSt->Sql->Add(" :plicens_num,:pokpo_num,:pdoc_num,:pdoc_dat,:pdoc_ground, ");
    QuerInSt->Sql->Add(":pid_budjet,:pid_kwed,:pid_taxprop,:pid_position,:pid_kur,:pflag_reactive,:pflag_budjet,");
    QuerInSt->Sql->Add(":pperiod_indicat,:pdt_indicat,:pmonth_indicat,:pmonth_control,:pdt_start,:pday_pay_bill,:ptype_pay,");
    QuerInSt->Sql->Add(":ppre_pay_grn,:ppre_pay_day1,:ppre_pay_perc1,:ppre_pay_day2,:ppre_pay_perc2,:ppre_pay_day3,:ppre_pay_perc3,");
    QuerInSt->Sql->Add(":ptype_peni,:pcount_peni,:pflag_3perc_year,:pphone,:pflag_hlosts,\
    :pid_roz,:pid_fld,:pid_grp,:pid_dep,:pcomment,:paddr_main,:paddr_tax, :paddr_local, :pflag_key,:pbank_day, :pflag_del2kr, \
    :ptr_doc_num,:ptr_doc_date,:pkosht_date_b,:pkosht_date_e,:ptr_year_price,:ptr_doc_type, :ptr_doc_period, :pdoc_num_tend,:pdoc_dat_tend,:pflag_ed, :pflag_jur, :pmail, :pcabinet, :pdate_digital )");

  }
  else
  {
    QuerInSt->Sql->Add("update clm_statecl_tbl set tax_num=:ptax_num,flag_taxpay=:pflag_taxpay,  ");
    QuerInSt->Sql->Add(" licens_num=:plicens_num,okpo_num=:pokpo_num, doc_num=:pdoc_num,doc_dat=:pdoc_dat,");
    QuerInSt->Sql->Add("id_budjet=:pid_budjet,id_kwed=:pid_kwed,id_taxprop=:pid_taxprop,");
    QuerInSt->Sql->Add("doc_ground=:pdoc_ground,id_position=:pid_position,id_kur=:pid_kur,flag_reactive=:pflag_reactive,");
    QuerInSt->Sql->Add("period_indicat=:pperiod_indicat,dt_indicat=:pdt_indicat,month_indicat=:pmonth_indicat,month_control=:pmonth_control,dt_start=:pdt_start,");
    QuerInSt->Sql->Add("day_pay_bill=:pday_pay_bill,type_pay=:ptype_pay,pre_pay_grn=:ppre_pay_grn,");
    QuerInSt->Sql->Add("pre_pay_day1=:ppre_pay_day1,pre_pay_perc1=:ppre_pay_perc1,");
    QuerInSt->Sql->Add("pre_pay_day2=:ppre_pay_day2,pre_pay_perc2=:ppre_pay_perc2,");
    QuerInSt->Sql->Add("pre_pay_day3=:ppre_pay_day3,pre_pay_perc3=:ppre_pay_perc3,");
    QuerInSt->Sql->Add("type_peni=:ptype_peni,count_peni=:pcount_peni,flag_3perc_year=:pflag_3perc_year,flag_budjet=:pflag_budjet,");
     QuerInSt->Sql->Add("phone=:pphone,flag_hlosts=:pflag_hlosts,flag_key=:pflag_key, flag_ed=:pflag_ed, flag_jur=:pflag_jur,\
      id_section=:pid_roz,filial_num=:pid_fld,id_grp_industr=:pid_grp,id_depart=:pid_dep,\
      for_undef=:pcomment,addr_main=:paddr_main,addr_tax=:paddr_tax, addr_local = :paddr_local, flag_bank_day=:pbank_day,  \
      tr_doc_num =:ptr_doc_num,tr_doc_date=:ptr_doc_date,kosht_date_b=:pkosht_date_b,kosht_date_e=:pkosht_date_e,tr_year_price=:ptr_year_price,tr_doc_type = :ptr_doc_type, tr_doc_period = :ptr_doc_period, \
      doc_num_tend =:pdoc_num_tend,doc_dat_tend=:pdoc_dat_tend, e_mail = :pmail, fl_cabinet = :pcabinet,  date_digital = :pdate_digital, ");
    QuerInSt->Sql->Add("flag_del2kr=:pflag_del2kr ");
    QuerInSt->Sql->Add(" where id_client=:pid_client  ");

  };
    QuerInSt->ParamByName("pid_client")->AsInteger=fid_client;
    QuerInSt->ParamByName("ptax_num")->AsString=EdTaxNum->Text;
    QuerInSt->ParamByName("pflag_taxpay")->AsInteger=fch_tax;
    QuerInSt->ParamByName("plicens_num")->AsString=EdLicNum->Text;
    QuerInSt->ParamByName("pokpo_num")->AsString=EdOKPO->Text;
    QuerInSt->ParamByName("pdoc_num")->AsString=(EdNumDoc->Text);
    QuerInSt->ParamByName("pdoc_ground")->AsString=(EdDocGround->Text);
    QuerInSt->ParamByName("paddr_main")->AsString=(EdAddresM->Text);
    QuerInSt->ParamByName("paddr_tax")->AsString=(EdAddresT->Text);
    QuerInSt->ParamByName("paddr_local")->AsString=EdAddresLocal->Text;
     QuerInSt->ParamByName("pid_fld")->AsString=EdFld->Text;
   // TDateTime doc=StrToDate(EdDateDoc->Text);

    TDateTime tdoc=0;
    if (StrToDate(EdDateDoc->Text,"")<=tdoc)
    { ShowMessage ("Заполните дату договора !");
       return;
       //QuerInSt->ParamByName("pdoc_dat")->AsDateTime=StrToDate("01.01.1000");
     }
    else
    {
     QuerInSt->ParamByName("pdoc_dat")->AsDateTime=StrToDate(EdDateDoc->Text);

    };
    QuerInSt->ParamByName("pid_budjet")->AsInteger=fid_budjet;
    QuerInSt->ParamByName("pid_kwed")->AsInteger=fid_kwed;
   // QuerInSt->ParamByName("pid_taxprop")->AsInteger=fid_taxprop;
    QuerInSt->ParamByName("pid_dep")->AsInteger=fid_dep;
    QuerInSt->ParamByName("pid_grp")->AsInteger=fid_grp;

    QuerInSt->ParamByName("pid_roz")->AsInteger=fid_roz;

    QuerInSt->ParamByName("pid_position")->AsInteger=fid_position;
        QuerInSt->ParamByName("pid_kur")->AsInteger=fid_kontrol;
    QuerInSt->ParamByName("pflag_reactive")->AsInteger=fch_reactiv;
    QuerInSt->ParamByName("pflag_key")->AsInteger=fch_key;

    QuerInSt->ParamByName("pcabinet")->AsInteger=fch_cabinet;

    if (EdDateDigital->Text!="  .  .    ")
       QuerInSt->ParamByName("pdate_digital")->AsDateTime=StrToDate(EdDateDigital->Text);
    else
       QuerInSt->ParamByName("pdate_digital")->Clear();

    QuerInSt->ParamByName("pflag_budjet")->AsInteger=fch_budjet;
    QuerInSt->ParamByName("pflag_ed")->AsInteger=fch_ed;
    QuerInSt->ParamByName("pflag_jur")->AsInteger=frad_jur;
    QuerInSt->ParamByName("pperiod_indicat")->AsInteger=fperind;
    QuerInSt->ParamByName("pdt_indicat")->AsInteger=StrToIntI(ALLTRIM(EdDtIndicat->Text));
    QuerInSt->ParamByName("pdt_start")->AsInteger=StrToIntI(ALLTRIM(EdDtStart->Text));

    QuerInSt->ParamByName("pmonth_indicat")->AsInteger=StrToIntI(ALLTRIM(EdMonthIndicat->Text));
    QuerInSt->ParamByName("pmonth_control")->AsInteger=StrToIntI(ALLTRIM(EdMonthControl->Text));
    QuerInSt->ParamByName("pday_pay_bill")->AsInteger=StrToIntI(ALLTRIM(EdPayDay->Text));
    QuerInSt->ParamByName("ptype_pay")->AsInteger=frad_pay;
    QuerInSt->ParamByName("ppre_pay_grn")->AsFloat=StrToFloatI(EdPrePayGrn->Text);
    QuerInSt->ParamByName("ppre_pay_day1")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay1->Text));
    QuerInSt->ParamByName("ppre_pay_perc1")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc1->Text));
    QuerInSt->ParamByName("ppre_pay_day2")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay2->Text));
    QuerInSt->ParamByName("ppre_pay_perc2")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc2->Text));
    QuerInSt->ParamByName("ppre_pay_day3")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay3->Text));
    QuerInSt->ParamByName("ppre_pay_perc3")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc3->Text));
    QuerInSt->ParamByName("ptype_peni")->AsInteger=fch_peni;
    QuerInSt->ParamByName("pflag_3perc_year")->AsInteger=fch_3perc_year; //from yana


    QuerInSt->ParamByName("pcount_peni")->AsInteger=StrToIntI(ALLTRIM(EdCountPeni->Text));
    QuerInSt->ParamByName("pphone")->AsString=EdPhone->Text;
    QuerInSt->ParamByName("pcomment")->AsString=(EdComment->Text);
    QuerInSt->ParamByName("pmail")->AsString=(EdMail->Text);
    QuerInSt->ParamByName("pflag_hlosts")->AsInteger=fch_lost;
    QuerInSt->ParamByName("pbank_day")->AsInteger=fch_bankday;
    QuerInSt->ParamByName("pflag_del2kr")->AsInteger=fch_del2kr;

      //QuerInSt->ParamByName("pid_client")->AsInteger=fid_client;
      if (edTrDocNum->Text.Trim()!="")
    {
     QuerInSt->ParamByName("ptr_doc_num")->AsString=edTrDocNum->Text.Trim();
     QuerInSt->ParamByName("ptr_doc_date")->AsDateTime=StrToDate(edTrDocDate->Text);

     QuerInSt->ParamByName("pkosht_date_b")->AsDateTime=StrToDate(edKoshtDateB->Text);    //from yana
     QuerInSt->ParamByName("pkosht_date_e")->AsDateTime=StrToDate(edKoshtDateE->Text);     //from yana

     QuerInSt->ParamByName("ptr_year_price")->AsFloat = StrToFloat(edTrYearPrice->Text);

     if (cbTrDocType->ItemIndex == 3)
      QuerInSt->ParamByName("ptr_doc_type")->Clear();
     else
      QuerInSt->ParamByName("ptr_doc_type")->AsInteger =cbTrDocType->ItemIndex+1;

     if (cbTrPayPeriod->ItemIndex == 3)
      QuerInSt->ParamByName("ptr_doc_period")->Clear();
     else
      QuerInSt->ParamByName("ptr_doc_period")->AsInteger =cbTrPayPeriod->ItemIndex+1;

    }
    else
    {
     QuerInSt->ParamByName("ptr_doc_num")->Clear();
     QuerInSt->ParamByName("ptr_doc_date")->Clear();
     QuerInSt->ParamByName("pkosht_date_b")->Clear();       //from yana
     QuerInSt->ParamByName("pkosht_date_e")->Clear();       //from yana

     QuerInSt->ParamByName("ptr_year_price")->Clear();
     QuerInSt->ParamByName("ptr_doc_type")->Clear();
     QuerInSt->ParamByName("ptr_doc_period")->Clear();     
    }
      if (EdNumDocTend->Text.Trim()!="")
    {
     QuerInSt->ParamByName("pdoc_num_tend")->AsString=EdNumDocTend->Text.Trim();
     QuerInSt->ParamByName("pdoc_dat_tend")->AsDateTime=StrToDate(EdDatDocTend->Text);
    }
    else
    {
     QuerInSt->ParamByName("pdoc_num_tend")->Clear();
     QuerInSt->ParamByName("pdoc_dat_tend")->Clear();
    }


    QuerInSt->ExecSql();
}
//---------------------------------------------------------------------------



void __fastcall TFCliState::ChBoxBudjetClick(TObject *Sender)
{

if(ChBoxBudjet->Checked==false) fch_budjet=0; else fch_budjet=1;

}

void __fastcall TFCliState::EdPerIndicChange(TObject *Sender)
{

   if (EdPerIndic->Text=="месяц")    fperind=1;
   if (EdPerIndic->Text=="2 месяца") fperind=2;
   if (EdPerIndic->Text=="квартал") fperind=3;
}
//--------------


void __fastcall TFCliState::TBtnPrevClick(TObject *Sender)
{  if (!ParentDataSet->Bof)
    {int cli=0;
     CheckDoState(this);
     ParentDataSet->Prior();
     cli=ParentDataSet->FieldByName("id")->AsInteger;
     ShowData(cli);
     };

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::TBtnNextClick(TObject *Sender)
{
if (!ParentDataSet->Eof)
    {int cli=0;
     CheckDoState(this);
     ParentDataSet->Next();
     cli=ParentDataSet->FieldByName("id")->AsInteger;
     ShowData(cli);
     };

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::TBtnLastClick(TObject *Sender)
{   int cli=0;
   CheckDoState(this);
     ParentDataSet->Last();
     cli=ParentDataSet->FieldByName("id")->AsInteger;
     ShowData(cli);

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::TBtnFirstClick(TObject *Sender)
{
 int cli=0;
 CheckDoState(this);
     ParentDataSet->First();
     cli=ParentDataSet->FieldByName("id")->AsInteger;
     ShowData(cli);
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::TBtnCanselClick(TObject *Sender)
{ if (Ask("Вы уверены что хотите отменить изменения? "))
    { int cli=0;
     cli=ParentDataSet->FieldByName("id")->AsInteger;
     ShowData(cli);
     };
}
//---------------------------------------------------------------------------

int __fastcall TFCliState::CheckState(TObject *Sender)
{ int ret_check;
  ret_check=0;

   int inscl=0;
   int insst=0;
 /*  if (EdCodeClient->Text.IsEmpty())
     { ShowMessage ("Заполните код клиента !");
       return ;
     }
     */
   TWTQuery *QuerChSt=new TWTQuery(this);
   TWTQuery *QuerCl=new TWTQuery(this);
    QuerCl->Sql->Add("select * from clm_client_tbl c where id= "+ToStrSQL(fid_client));
    QuerCl->Open();
    if(QuerCl->Eof)
     { inscl=1;
       ret_check=1;
       };
   TWTQuery *QuerSt=new TWTQuery(this);
    QuerSt->Sql->Add("select * from clm_statecl_tbl c where id_client= "+ToStrSQL(fid_client));
    QuerSt->Open();
    if(QuerCl->Eof)
     { insst=1;
       ret_check=1;
       };

  if (ret_check==0)
 {
    TWTQuery *QuerChCl=new TWTQuery(this);
    QuerChCl->Sql->Clear();

    QuerChCl->Sql->Add("select * from clm_client_tbl where  ");
    QuerChCl->Sql->Add(" code=:pcode  and code_okpo=:pcode_okpo and id=:pid and ");
    QuerChCl->Sql->Add(" name=:pname and short_name=:psname and add_name=:paname and (id_addres=:pid_addres or :pid_addres=0) ");
    QuerChCl->ParamByName("pcode")->AsInteger=StrToInt(EdCodeClient->Text);
    QuerChCl->ParamByName("pid_addres")->AsInteger=fid_addres;
    QuerChCl->ParamByName("pcode_okpo")->AsString=EdOKPO->Text;
    QuerChCl->ParamByName("pname")->AsString=EdLName->Text;
    QuerChCl->ParamByName("psname")->AsString=EdNName->Text;
    QuerChCl->ParamByName("paname")->AsString=EdAddName->Text;
    QuerChCl->ParamByName("pid")->AsInteger=fid_client;
    QuerChCl->Open();
    if(QuerChCl->Eof)
     {
       ret_check=1;
     };
 }

  if(ret_check==0)
  {

    QuerChSt->Sql->Add("select * from clm_statecl_tbl  where  id_client=:pid_client and ");
    QuerChSt->Sql->Add("tax_num=:ptax_num and flag_taxpay=:pflag_taxpay and flag_bank_day=:pbank_day");
    QuerChSt->Sql->Add("licens_num=:plicens_num and okpo_num=:pokpo_num and doc_num=:pdoc_num and ");
    QuerChSt->Sql->Add(" doc_dat=:pdoc_dat and doc_ground=:pdoc_ground and id_budjet=:pid_budjet and  ");
    QuerChSt->Sql->Add(" id_kwed=:pid_kwed and id_taxprop=:pid_taxprop and id_position=:pid_position and ");
QuerChSt->Sql->Add(" id_kur=:pid_kur and ");
    QuerChSt->Sql->Add(" flag_reactive=:pflag_reactive and flag_key=:pflag_key and period_indicat=:pperiod_indicat and  ");
    QuerChSt->Sql->Add("dt_indicat=:pdt_indicat and month_indicat=:pmonth_indicat and month_control=:pmonth_control and dt_start=:pdt_start and day_pay_bill=:pday_pay_bill and  ");
    QuerChSt->Sql->Add(" type_pay=:ptype_pay and pre_pay_grn=:ppre_pay_grn and ");
    QuerChSt->Sql->Add(" pre_pay_day1=:ppre_pay_day1 and pre_pay_perc1=:ppre_pay_perc1 and ");
    QuerChSt->Sql->Add(" pre_pay_day2=:ppre_pay_day2 and  pre_pay_perc2=:ppre_pay_perc2 and ");
    QuerChSt->Sql->Add(" pre_pay_day3=:ppre_pay_day3 and pre_pay_perc3=:ppre_pay_perc3 and ");
    QuerChSt->Sql->Add(" type_peni=:ptype_peni and count_peni=:pcount_peni and for_undef=:pfor_undef");

    QuerChSt->ParamByName("pid_client")->AsInteger=fid_client;
    QuerChSt->ParamByName("ptax_num")->AsString=EdTaxNum->Text;
    QuerChSt->ParamByName("pflag_taxpay")->AsInteger=fch_tax;
    QuerChSt->ParamByName("plicens_num")->AsString=EdLicNum->Text;
    QuerChSt->ParamByName("pokpo_num")->AsString=EdOKPO->Text;
    QuerChSt->ParamByName("pdoc_num")->AsString=(EdNumDoc->Text);
    QuerChSt->ParamByName("pfor_undef")->AsString=(EdComment->Text);
    TDateTime doc;
    TDateTime tdoc=-1;
    if (StrToDate(EdDateDoc->Text,"")!=tdoc)
     QuerChSt->ParamByName("pdoc_dat")->AsDateTime=StrToDate(EdDateDoc->Text);
    else
    {
     QuerChSt->ParamByName("pdoc_dat")->AsDateTime=StrToDate("01.01.1000");
    };
    QuerChSt->ParamByName("pdoc_ground")->AsString=EdDocGround->Text;
    QuerChSt->ParamByName("pid_budjet")->AsInteger=fid_budjet;
    QuerChSt->ParamByName("pid_kwed")->AsInteger=fid_kwed;
    QuerChSt->ParamByName("pid_taxprop")->AsInteger=fid_taxprop;
    QuerChSt->ParamByName("pid_position")->AsInteger=fid_position;
    QuerChSt->ParamByName("pid_kur")->AsInteger=fid_kontrol;
    QuerChSt->ParamByName("pflag_reactive")->AsInteger=fch_reactiv;
    QuerChSt->ParamByName("pflag_key")->AsInteger=fch_key;
    QuerChSt->ParamByName("pperiod_indicat")->AsInteger=fperind;
    QuerChSt->ParamByName("pdt_indicat")->AsInteger=StrToIntI(ALLTRIM(EdDtIndicat->Text));
    QuerChSt->ParamByName("pdt_start")->AsInteger=StrToIntI(ALLTRIM(EdDtStart->Text));
    QuerChSt->ParamByName("pmonth_indicat")->AsInteger=StrToIntI(ALLTRIM(EdMonthIndicat->Text));
        QuerChSt->ParamByName("pmonth_control")->AsInteger=StrToIntI(ALLTRIM(EdMonthControl->Text));
    QuerChSt->ParamByName("pday_pay_bill")->AsInteger=StrToIntI(ALLTRIM(EdPayDay->Text));
    QuerChSt->ParamByName("ptype_pay")->AsInteger=frad_pay;
    QuerChSt->ParamByName("ppre_pay_grn")->AsFloat=StrToFloatI(EdPrePayGrn->Text);
    QuerChSt->ParamByName("ppre_pay_day1")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay1->Text));
    QuerChSt->ParamByName("ppre_pay_perc1")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc1->Text));
    QuerChSt->ParamByName("ppre_pay_day2")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay2->Text));
    QuerChSt->ParamByName("ppre_pay_perc2")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc2->Text));
    QuerChSt->ParamByName("ppre_pay_day3")->AsInteger=StrToIntI(ALLTRIM(EdPrePayDay3->Text));
    QuerChSt->ParamByName("ppre_pay_perc3")->AsInteger=StrToIntI(ALLTRIM(EdPrePayPerc3->Text));
    QuerChSt->ParamByName("ptype_peni")->AsInteger=fch_peni;
    QuerChSt->ParamByName("pflag_3perc_year")->AsInteger=fch_3perc_year;         //from yana
    QuerChSt->ParamByName("pbank_day")->AsInteger=fch_bankday;
    QuerChSt->ParamByName("pcount_peni")->AsInteger=StrToIntI(ALLTRIM(EdCountPeni->Text));

    QuerChSt->Open();
    if(QuerChSt->Eof)
     {
       ret_check=1;
     };
 }
 return ret_check;
}

void __fastcall TFCliState::CheckDoState(TObject *Sender)
{ int ret_check;
  /*ret_check=CheckState(this);
  if (ret_check==1)
  { if (Ask(" Записать ?")==1)
   {
    TBtnSaveClick(this);
    };
  };*/
}



void __fastcall TFCliState::EdKwedChange(TObject *Sender)
{  TWTQuery *QuerKw=new TWTQuery(this);
  if (ALLTRIM(((TEdit*)Sender)->Text).IsEmpty()) return;
    //AnsiString st=STRTRAN(ALLTRIM(((TEdit*)Sender)->Text)," ","");

    AnsiString st=((TEdit*)Sender)->Text;
    st=STRTRAN(st,"..",".");
    st=STRTRAN(st,"  .","");
    //st=STRTRAN(st," .","");
    st=STRTRAN(st,".  ","");
     st=STRTRAN(st,". ",".");
     st=STRTRAN(st," .",".");
    st=ALLTRIM(st);
    QuerKw->Sql->Add("select * ");
    QuerKw->Sql->Add("from cla_param_tbl  ");
    QuerKw->Sql->Add("where kod like '"+st+"%'");
    QuerKw->Sql->Add(" order by kod  ");
    QuerKw->Open();
    if (!(QuerKw->Eof))
    {     LabKwed->Caption=QuerKw->FieldByName("val")->AsString;
          fid_kwed=QuerKw->FieldByName("id")->AsInteger;
    //  EdAccount->Text=QuerC->FieldByName("account")->AsString;
     }
     else {
        LabKwed->Caption="";
        fid_kwed=0; };
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::sbDelDayPayClick(TObject *Sender)
{    if (MessageDlg("Удалить  ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;
    try
   {
    DayPayQuery->Delete();
   }
   catch(...)
   {
    ShowMessage("Ошибка .");
    DayPayQuery->Refresh();
    return ;
   }
  DayPayQuery->Refresh();

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::sbAddDayPayClick(TObject *Sender)
{   if (MessageDlg("Добавить  ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
      return;
    try
   {
   TWTQuery *Que=new TWTQuery(Application);
   Que->Sql->Clear();
   Que->Sql->Add("insert into clm_daypay_tbl(id_client,day,flag) ");
   Que->Sql->Add("values ( :pid_client,:pid_dat,0);");

   Que->ParamByName("pid_client")->AsInteger=fid_client;
   Que->ParamByName("pid_dat")->AsInteger=15;
   Que->ExecSql();
   // WarmQuery->Insert();
   }
   catch(...)
   {
    ShowMessage("Ошибка .");
    DayPayQuery->Refresh();
    return ;
   }
  DayPayQuery->Refresh();

}
//---------------------------------------------------------------------------
  /*
void TFCliState::ShowWarmGrid(void)
{
   WarmQuery->Close();
   WarmQuery->Sql->Clear();
   WarmQuery->Sql->Add("select * from warm_period where id_client= :pid_client \
    order by dat_b");
   WarmQuery->ParamByName("pid_client")->AsInteger=fid_client;

   try
   {
    WarmQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL ");
    WarmQuery->Close();
    return ;
   }

   TStringList *WList=new TStringList();
   WList->Add("id_client");
   WList->Add("dat_b");
   WList->Add("dat_e");
   WList->Add("mmgg");


   TStringList *NList=new TStringList();
  // NList->Add("name");
   WarmQuery->SetSQLModify("warm_period",WList,NList,true,true,true);

   DBGrWarm->DataSource=dsWarmQuery;
}
   */


void __fastcall TFCliState::ChLostClick(TObject *Sender)
{
 if(ChLost->Checked==false) fch_lost=0; else fch_lost=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::EdTaxNumExit(TObject *Sender)
{ TEdit  * ed;
   ed=(TEdit*)Sender;
   TVarRec args[1] = {0};

   AnsiString ee;
  // ee=FmtStr(ed->Text,"000000000000",args,12);
  /*
  if (ALLTRIM(ed->Text).Length<12)
  { Sender->Text=

  }
    */
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBoxKeyClick(TObject *Sender)
{
   if(ChBoxKey->Checked) fch_key=1; else fch_key=0;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::N1Click(TObject *Sender)
{
QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=10;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 
/*
     QuerSal->Filter="id_pref=10";
     QuerSal->Filtered=true;
     QuerSal->Refresh();
     */
}
void __fastcall TFCliState::N2Click(TObject *Sender)
{
   QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=20;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 


}
void __fastcall TFCliState::N3Click(TObject *Sender)
{
QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=510;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 


}
void __fastcall TFCliState::N4Click(TObject *Sender)
{
     QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=520;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 

}
void __fastcall TFCliState::N5Click(TObject *Sender)
{
    QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=901;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 

}
void __fastcall TFCliState::N6Click(TObject *Sender)
{
     QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  and s.id_pref=:ppref\
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");

   QuerSal->ParamByName("ppref")->AsInteger=902;
   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {};

}
void __fastcall TFCliState::N7Click(TObject *Sender)
{
    QuerSal->Close();
QuerSal->Sql->Clear();
 QuerSal->Params->Clear();
   DBGrSald->DataSource=NULL;
   QuerSal->Sql->Add("select s.*, coalesce(b.demand,0) as demand,s.b_val+s.b_valtax as b_sum, s.dt_val+s.dt_valtax as dt_sum, \
                             s.kt_val+s.kt_valtax as kt_sum, s.e_val+s.e_valtax as e_sum \
                     from ( select s.*,p.name as pref from acm_saldo_tbl s \
                            ,aci_pref_tbl p where s.id_client=:pid_client and s.id_pref=p.id  \
                          )   s left join  \
                          (select b.mmgg,b.id_pref,b.id_client,sum(coalesce(demand_val,0))::::int as demand from acm_bill_tbl b \
                           where id_client= :pid_client \
                            group by  b.mmgg,b.id_pref,b.id_client \
                          ) as b \
                        on (b.mmgg=s.mmgg and b.id_pref=s.id_pref and  s.id_client=b.id_client) \
                      order by s.mmgg desc");


   QuerSal->ParamByName("pid_client")->AsInteger=fid_client;
   try {
   QuerSal->Open();
     DBGrSald->DataSource=QuerSal->DataSource;
   } catch (...)
   {}; 

}
//---------------------------------------------------------------------------
#define WinName "История изменения параметров клиентов"

void __fastcall TFCliState::SBHistoryClick(TObject *Sender)
{

    if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner))
{
   // return null;
  }


   TWTQuery *QEnv=new TWTQuery(this);
        QEnv->Sql->Clear();
    QEnv->Sql->Add("select st.*,sect.name as section, budj.name as budjet,dep.name as depart \
         from (select * from clm_statecl_h where id_client=:pid_client) st \
           left join cla_param_tbl sect on st.id_section=sect.id \
           left join cla_param_tbl budj on st.id_budjet=budj.id \
           left join cla_param_tbl dep on st.id_depart=dep.id \
          order by st.mmgg_b");
    QEnv->ParamByName("pid_client")->AsInteger=fid_client;
   // QEnv->Open();
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QEnv,false);
      WGrid->SetCaption(WinName);

    TWTDBGrid* DBGrEnv=WGrid->DBGrid;

 /*     TWTQuery *QueryAdr;
   QueryAdr=new  TWTQuery(this);
   QueryAdr->Sql->Add("select a.id,a.adr::::varchar,a.dom_reg::::varchar from adv_address_tbl a ");
   QueryAdr->Open();

    DBGrEnv->Query->AddLookupField("name_adr", "ID_ADDRES", QueryAdr, "adr","id");
   */
     TStringList *WListI=new TStringList();
     DBGrEnv->Query->Open();
   WListI->Add("id_s");
   TStringList *NListI=new TStringList();
   NListI->Add("section");
   NListI->Add("budjet");
   NListI->Add("depart");
   DBGrEnv->Query->SetSQLModify("clm_statecl_h",WListI,NListI,true,true,true);

  TWTField *Field;
  Field = DBGrEnv->AddColumn("mmgg_b", "Период с", "Период с");
  Field->SetWidth(80);
  Field->Field->OnSetText = ValidateDate;

  Field = DBGrEnv->AddColumn("mmgg_e", "Период по", "Период по");
  Field->SetWidth(80);
  Field->Field->OnSetText = ValidateDate;

    Field = DBGrEnv->AddColumn("dt", "dt", "dt");
  Field->SetWidth(80);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("doc_num", "Номер договора", "Номер договора");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("doc_dat", "Дата договора", "Дата договора");
  Field->SetWidth(80);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("licens_num", "Номер свидетелства", "Номер свидетелства");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("okpo_num", "ЕДРПОУ", "ЕДРПОУ");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("tax_num", "Налоговый номер", "Налоговый номер");
  Field->SetWidth(150);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("flag_taxpay", "Плат НДС", "Плат НДС");
  Field->SetWidth(80);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("flag_budjet", "Бюджетник", "Бюджетник");
  Field->SetWidth(30);
  Field->SetReadOnly();

    Field = DBGrEnv->AddColumn("flag_bank_day", "Банк дни ", "Банковские дни в предупреждениях");
  Field->SetWidth(30);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("budjet", "Бюджет", "Бюджет");
  Field->SetWidth(100);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("section", "Группа", "Группа");
  Field->SetWidth(100);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("depart", "Министерство", "Министерство");
  Field->SetWidth(100);
  Field->SetReadOnly();

    Field = DBGrEnv->AddColumn("doc_num_tend", "№ тенд.дог.", "№ тенд.дог");
  Field->SetWidth(150);
 // Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("doc_dat_tend", "Дата тенд.дог.", "Дата тенд.дог.");
  Field->SetWidth(80);
 // Field->SetReadOnly();

     Field = DBGrEnv->AddColumn("flag_ed", "Ед.налог", "Ед.налог");
      Field->AddFixedVariable("1", "Ед.нал.");
   Field->AddFixedVariable("0", "       ");
  Field->SetWidth(50);
 // Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("flag_jur", "Юридич.", "Юридич.");
   Field->AddFixedVariable("1", "Юр. ");
   Field->AddFixedVariable("0", "Физ.");
  Field->SetWidth(50);
 // Field->SetReadOnly();


  Field = DBGrEnv->AddColumn("addr_tax", "Адрес в налоговой", "Адрес в налоговой");
  Field->SetWidth(300);

  Field = DBGrEnv->AddColumn("addr_main", "Адрес головного офиса", "Адрес  головного офиса");
//  Field->SetOnHelp(((TMainForm*)MainForm)->AdmAddressMineSpr);
  Field->SetWidth(300);

 WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("HistoryState");
}

#undef WinName
//--------------------------------------------------
void __fastcall TFCliState::ValidateDate(TField* Sender, const AnsiString Text)
{
   if (Text =="  .  .    ") Sender->Clear();
   else Sender->AsString =Text;

};
//--------------------------------------------------

#define WinName "История изменения инспектора клиента"
//---------------------------------------------------------------------------

void __fastcall TFCliState::sbInspectorHistoryClick(TObject *Sender)
{
  if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner))
  {
   // return null;
  }

   TWTQuery *QEnv=new TWTQuery(this);

    QEnv->Sql->Clear();
    QEnv->Sql->Add("select st.*,cp.represent_name \
         from (select * from clm_statecl_h where id_client=:pid_client) st \
          left join clm_position_tbl as cp on (st.id_position = cp.id) \
          order by st.mmgg_b");
    QEnv->ParamByName("pid_client")->AsInteger=fid_client;
   // QEnv->Open();
     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QEnv,false);
      WGrid->SetCaption(WinName);

    TWTDBGrid* DBGrEnv=WGrid->DBGrid;

   TStringList *WListI=new TStringList();
   DBGrEnv->Query->Open();
   WListI->Add("id");
   TStringList *NListI=new TStringList();
   NListI->Add("represent_name");
   DBGrEnv->Query->SetSQLModify("clm_statecl_h",WListI,NListI,false,false,false);

  TWTField *Field;
  Field = DBGrEnv->AddColumn("mmgg_b", "Период с", "Период с");
  Field->SetWidth(80);

  Field = DBGrEnv->AddColumn("mmgg_e", "Период по", "Период по");
  Field->SetWidth(80);

    Field = DBGrEnv->AddColumn("dt", "dt", "dt");
  Field->SetWidth(80);
  Field->SetReadOnly();

  Field = DBGrEnv->AddColumn("represent_name", "Инспектор", "Инспектор");
  Field->SetWidth(200);
  Field->SetReadOnly();

 WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("HistoryInspector");

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBankDayClick(TObject *Sender)
{
 if(ChBankDay->Checked==false) fch_bankday=0; else fch_bankday=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::Ch2krDelClick(TObject *Sender)
{
   if(Ch2krDel->Checked) fch_del2kr=1; else fch_del2kr=0;

}
//---------------------------------------------------------------------------
   void __fastcall TFCliState::sbTrDocClearClick(TObject *Sender)
{
 edTrDocNum->Text = "";
 edTrDocDate->Text = "";

 edKoshtDateB->Text = "";     //yana
 edKoshtDateE->Text = ""; // yana
 edTrYearPrice->Text = "0";
 cbTrDocType->ItemIndex = 2;
 cbTrPayPeriod->ItemIndex = 2;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::cbTrDocTypeChange(TObject *Sender)
{
//
}
//---------------------------------------------------------------------------



void __fastcall TFCliState::RadGrJurClick(TObject *Sender)
{  /*
 frad_jur==QuerSt->FieldByName("type_pay")->AsInteger;
     if (frad_pay==1)
       RadGrPay->ItemIndex=0;
     else
       RadGrPay->ItemIndex=1;*/

   if(RadGrJur->ItemIndex==1) frad_jur=0; else frad_jur=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBoxEdClick(TObject *Sender)
{
if(ChBoxEd->Checked==false) fch_ed=0; else fch_ed=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::btSendEMailClick(TObject *Sender)
{
 AnsiString mail_client;
 AnsiString mail_command;
 if (EdMail->Text.Trim()=="") return;

 mail_client=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","mailto","");

 AnsiString mail_url = "mailto:"+EdMail->Text.Trim()+"?subject=Рахунок%20за%20електроенергію&body=";

 if (mail_client=="")
 {
  MailToConfig->ShowModal();

  mail_client=((TWTMainForm*)Application->MainForm)->StartupIniFile->ReadString("Base","mailto","");
  if (mail_client=="") return;

 }

  TReplaceFlags flags;
  flags<<rfReplaceAll;

  mail_command = StringReplace(mail_client,"%1",mail_url,flags);

//        AnsiString command = "cmd.exe /c  "+ AnsiQuotedStr( mail_command, '"');
//        int rez= WinExec( command.c_str(), SW_SHOW);
  int rez= WinExec( mail_command.c_str(), SW_SHOW);

   //     ShellExecute(NULL, "open", AnsiQuotedStr( mail_command, '"').c_str(), NULL, ExtractFilePath(Application->ExeName).c_str() , SW_SHOWNORMAL);
//        ShellExecute(NULL, "open", mail_command.c_str(), NULL, ExtractFilePath(Application->ExeName).c_str() , SW_SHOWNORMAL);

}
//---------------------------------------------------------------------------

void __fastcall TFCliState::btMailSetupClick(TObject *Sender)
{
  MailToConfig->ShowModal();
}
//---------------------------------------------------------------------------



void __fastcall TFCliState::SpeedButton1Click(TObject *Sender)
{
DayPayQuery->Post();
}
//---------------------------------------------------------------------------

#define WinName "Список дней предоплаты"
void __fastcall TFCliState::DBGrDayPayDblClick(TObject *Sender)
{
   if (((TWTMainForm*)Application->MainForm)->ShowMDIChild(WinName, Owner))
{
   // return null;
  }
   TWTQuery *QEnv=new TWTQuery(this);
    QEnv->Sql->Clear();
    QEnv->Sql->Add("select d.*  from clm_daypay_tbl d  where id_client= :pid_client \
    order by flag,day");
    QEnv->ParamByName("pid_client")->AsInteger=fid_client;

     TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, QEnv,false);
      WGrid->SetCaption(WinName);

    DBGrEnv=WGrid->DBGrid;
     TStringList *WListI=new TStringList();

     DBGrEnv->Query->Open();
   WListI->Add("id");
   TStringList *NListI=new TStringList();

    DBGrEnv->Query->SetSQLModify("clm_daypay_tbl",WListI,NListI,true,true,true);
    TWTField *Field;

    Field = DBGrEnv->AddColumn("day", "День оплаты", "День оплаты");
    Field->SetRange(1,31,"Значение дня от 1 до 31");
     Field->SetWidth(80);

  Field = DBGrEnv->AddColumn("perc", "Процент оплаты", "Процент");
  Field->SetRange(1,100,"Значение процента от 1 до 100");
  Field->SetWidth(80);

   Field = DBGrEnv->AddColumn("flag", "аванс?", "");
   Field->AddFixedVariable("-1", "Да");
   Field->AddFixedVariable("0", "  ");
   Field->SetDefValue("0");
   Field->SetWidth(50);

  //  TWTWinDBGrid->OnClose
/*  Field = DBGrEnv->AddColumn("comment", "примечания", "примечания");
   Field->SetWidth(300);
  */
  //DBGrEnv->Query->OnClose=BefClosePayQ;
  DBGrEnv->AfterInsert=BefInsPay;
  WGrid->DBGrid->AfterPost=BefClosePay;
    WGrid->DBGrid->AfterDelete=BefClosePay;

 WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("table");
}
void _fastcall TFCliState::BefInsPay(TWTDBGrid *Sender)
{
Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=fid_client;
};
#undef WinName

void _fastcall TFCliState::BefClosePay(TWTDBGrid *Sender){
 DayPayQuery->Close();
   DayPayQuery->Open();
 DBGrDayPay->Refresh();
//dsDayPayQuery->Refresh();
}
void _fastcall TFCliState::BefClosePayQ(TWTQuery *Sender){
 DayPayQuery->Refresh();
 DBGrDayPay->Refresh();


}

void TFCliState::ShowDayPayGrid(void)
{
   DayPayQuery->Close();
   DayPayQuery->Sql->Clear();
   DayPayQuery->Sql->Add("select d.*,(case when flag=-1 then 'аванс' else '     ' end)::::varchar(10) as avans\
      from clm_daypay_tbl d  where id_client= :pid_client \
    order by flag,day");
   DayPayQuery->ParamByName("pid_client")->AsInteger=fid_client;

   try
   {
    DayPayQuery->Open();
   }
   catch(...)
   {
    ShowMessage("Ошибка SQL ");
    DayPayQuery->Close();
    return ;
   }


   TStringList *WList=new TStringList();
   WList->Add("id_client");
   WList->Add("day");

   TStringList *NList=new TStringList();
   WList->Add("avans");
   DayPayQuery->SetSQLModify("clm_daypay_tbl",WList,NList,false,false,false);

   DBGrDayPay->DataSource=dsDayPayQuery;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBoxCabinetClick(TObject *Sender)
{
   if(ChBoxCabinet->Checked==false) fch_cabinet=0; else fch_cabinet=1;
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::sbDigitalClearClick(TObject *Sender)
{
  EdDateDigital->Text = "";
}
//---------------------------------------------------------------------------

void __fastcall TFCliState::ChBox3PercYearClick(TObject *Sender)
{
     if(ChBox3PercYear->Checked==false) fch_3perc_year=0; else fch_3perc_year=1;
}
//---------------------------------------------------------------------------

