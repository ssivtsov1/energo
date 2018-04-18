//---------------------------------------------------------------------------

//#include <vcl.h>

#include "AbonConnect.h"
#include "Main.h"
#include "fChange.h"
#include "ftree.h"
//#include "ftree.h"
//#include "fEqpBase.h"

__fastcall TfAbonConnect::TfAbonConnect(TWinControl *owner, TWTQuery *query,bool IsMDI,int Code,
           bool def_list=true):TWTWinDBGrid(owner,query,IsMDI)
{
   def_mode=def_list;
   if (def_mode)
   {
    btAll=DBGrid->ToolBar->AddButton("AddCond", "Полный список", ShowAll);
    btConn=DBGrid->ToolBar->AddButton("RemCond", "Подключенные к данному объекту", ShowConnected);
    btAddr=DBGrid->ToolBar->AddButton("ADDADDR", "Подключить по адресу", ConnectAddr);
    btAddrStreet=DBGrid->ToolBar->AddButton("ADDSTREET", "Подключить по улице", ConnectStreet);
    btRemAddr=DBGrid->ToolBar->AddButton("REMADDR", "Отключить по адресу", UnConnectAddr);
    btRemAddrStreet=DBGrid->ToolBar->AddButton("REMSTREET", "Отключить по улице", UnConnectStreet);
    btRemAddrAll=DBGrid->ToolBar->AddButton("CANCEL", "Отключить все!", UnConnectAll);

    btAll->Visible=false;
   }

//   DBGrid->Query->AfterOpen=AfterOpen;
  // DBGrid->Query->AfterEdit=AfterEdit;
   //DBGrid->Query->BeforeEdit=BeforeEdit;
//   DBGrid->Query->AfterPost=AfterScroll;
   DBGrid->Query->BeforePost=AfterScroll;
   DBGrid->Query->AfterInsert=CancelInsert;
  // DBGrid->Query->BeforeClose=GridClose1;
   OnCloseQuery=GridClose;
   ZQUpdate = new TWTQuery(Application);
   ZQUpdate->MacroCheck=true;
   ZQUpdate->Options.Clear();
//   ZQUpdate->Options<< doQuickOpen;

  ZQUpdate->RequestLive=false;
  ZQUpdate->CachedUpdates=false;


  //AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client = :client ;";
  ZQUpdate->Sql->Clear();
//  ZQUpdate->Sql->Add(sqlstr);

//   ZQUpdate->Transaction->AutoCommit=false;

   CodeEqp=Code;

   ChDate  = TDateTime(0);
}
//---------------------------------------------------------------------------

void __fastcall TfAbonConnect::ShowAll(TObject* Sender)
{
//
 btConn->Visible=true;
 btAll->Visible=false;
 DBGrid->Query->Filtered=false;
 DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfAbonConnect::ShowConnected(TObject* Sender)
{
//
 btConn->Visible=false;
 btAll->Visible=true;

 if (DBGrid->Query->FindField("connected")!=NULL)
     {
     DBGrid->Query->Filtered=false;
      DBGrid->Query->Filter="connected = 1";
//      DBGrid->Query->Filter="id_eqpborder is not NULL";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }

//    DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::AfterEdit(TDataSet* DataSet)
{
  // int pid_client;
   pid_client=DataSet->FieldByName("id")->AsInteger;
  /*
   TfChangeDate* fChangeDate;

   if (ChDate  == TDateTime(0))
   {
    Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
    if (fChangeDate->ShowModal()!= mrOk)
     {
      delete fChangeDate;
      return ; // Отменить
     };
     try
     {
      ChDate=StrToDate(fChangeDate->edDt_change->Text);
     }
     catch(...)
     {
      ShowMessage("Неверная дата");
      delete fChangeDate;
      return ;
     }
     delete fChangeDate;
   }
    */

  ZQUpdate->Close();
  ZQUpdate->Sql->Clear();
//  AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp , dt_change = :dt where id_client = :client ;";
  AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = :eqp where id = :client ;";

  ZQUpdate->Sql->Add(sqlstr);

  ZQUpdate->ParamByName("client")->AsInteger=DataSet->FieldByName("id")->AsInteger;
//  ZQUpdate->ParamByName("dt")->AsDateTime=ChDate;
  if (DataSet->FieldByName("connected")->AsInteger!=1)
    {ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
     DataSet->FieldByName("connected")->AsInteger=0;
     }
  else
{    ZQUpdate->ParamByName("eqp")->Clear();
    //DataSet->FieldByName("connected")->AsInteger=1;
    };

  try
   {
   //ZQTree->Open();
   ZQUpdate->ExecSql();
   //DataSet->Refresh();

   }
  catch(...)
   {
//    ShowMessage("Ошибка SQL :"+sqlstr);
    ShowMessage("Ошибка.");
//    ZQTree->Close();
//    ZQUpdate->Transaction->Rollback();                 //<<<<

    return ;

  }
//  ZQUpdate->Transaction->Commit();
}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::AfterScroll(TDataSet* DataSet)
{
   pid_client=DataSet->FieldByName("id")->AsInteger;

   ZQUpdate->Close();
   ZQUpdate->Sql->Clear();

   AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = :eqp where id = :client ;";

   int con = DataSet->FieldByName("connected")->AsInteger;
   int oldcon = DataSet->FieldByName("oldconnected")->AsInteger;   

   ZQUpdate->Sql->Add(sqlstr);

   ZQUpdate->ParamByName("client")->AsInteger=pid_client;

   if (DataSet->FieldByName("connected")->AsInteger==1)
     {
      ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
     //     DataSet->FieldByName("connected")->AsInteger=0;
     }
   else
   {
    ZQUpdate->ParamByName("eqp")->Clear();
    //DataSet->FieldByName("connected")->AsInteger=1;
   };

   try
   {
    ZQUpdate->ExecSql();
   }
   catch(...)
   {
    //    ShowMessage("Ошибка SQL :"+sqlstr);
    ShowMessage("Ошибка.");
//    ZQUpdate->Transaction->Rollback();                 //<<<<
    return ;

   }
//   ZQUpdate->Transaction->Commit();


   //---------------------------------------------------------------------------
   /*
   TLocateOptions SearchOptions;
   SearchOptions.Clear();
   DataSet->Locate("id",pid_client ,SearchOptions);
   */
   };

//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::GridClose(TObject* Sender, bool &CanClose)
{
//  TWTWinDBGrid *WGrid = (TWTWinDBGrid *)Sender;
//  TDataSet* DataSet =WGrid->DBGrid->Query;

//  if (fTreeForm!=NULL)
//  {
//   ZQUpdate->Transaction->AutoCommit=false;
//   ZQUpdate->Transaction->TransactSafe=true;
//   ZQUpdate->Transaction->NewStyleTransactions=false;
//  }


/*
 TWTWinDBGrid *WGrid = (TWTWinDBGrid *)Sender;
 TDataSet* DataSet =WGrid->DBGrid->Query;
 DataSet->First();


 for(int i=1;i<=DataSet->RecordCount;i++)
 {
  if (DataSet->FieldByName("oldconnected")->AsInteger!=DataSet->FieldByName("connected")->AsInteger)
  {
 //  ZQUpdate->Close();

  ZQUpdate->ParamByName("client")->AsInteger=DataSet->FieldByName("id_client")->AsInteger;

  if (DataSet->FieldByName("connected")->AsInteger==1)
    ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
  else
    ZQUpdate->ParamByName("eqp")->Clear();

  try
   {
    ZQUpdate->ExecSql();
   }
  catch(...)
   {
//    ShowMessage("Ошибка SQL :"+sqlstr);
    ShowMessage("Ошибка.");
   }
  }

  DataSet->Next();
 }
  */
};


void __fastcall TfAbonConnect::GridClose1(TDataSet* Sender)
{
/*
 TDataSet* DataSet =DataSet;
// TWTWinDBGrid *WGrid = (TWTWinDBGrid *)Sender;
 DataSet->First();


 for(int i=1;i<=DataSet->RecordCount;i++)
 {
  if (DataSet->FieldByName("oldconnected")->AsInteger!=DataSet->FieldByName("connected")->AsInteger)
  {
 //  ZQUpdate->Close();

  ZQUpdate->ParamByName("client")->AsInteger=DataSet->FieldByName("id_client")->AsInteger;

  if (DataSet->FieldByName("connected")->AsInteger==1)
    ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
  else
    ZQUpdate->ParamByName("eqp")->Clear();

  try
   {
    ZQUpdate->ExecSql();
   }
  catch(...)
   {
//    ShowMessage("Ошибка SQL :"+sqlstr);
    ShowMessage("Ошибка.");
   }
  }

  DataSet->Next();
 }
  */
 };

//-----------------------------------------------------------
void __fastcall TfAbonConnect::ConnectAddr(TObject* Sender)
{
   TWTDBGrid* Grid;
   Grid=((TMainForm*)MainForm)->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=MainAddrAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::MainAddrAccept (TObject* Sender)
{
    int id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;
/*
    TfChangeDate* fChangeDate;

    if (ChDate  == TDateTime(0))
    {
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     if (fChangeDate->ShowModal()!= mrOk)
      {
       delete fChangeDate;
       return ; // Отменить
      };
      try
      {
       ChDate=StrToDate(fChangeDate->edDt_change->Text);
      }
      catch(...)
      {
       ShowMessage("Неверная дата");
       delete fChangeDate;
       return ;
      }
      delete fChangeDate;
    }
*/

///    and (coalesce(ad2.building_add,"_")=coalesce(ad2.building_add,"_"))
     /*
     AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client in \
     (select cl.id from clm_client_tbl as cl join adm_address_tbl as ad1 on (ad1.id=cl.id_addres) \
     join adm_address_tbl as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' ))) \
     where ad2.id = :addr );";
       */
/*
      AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp, dt_change = :dt  from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' )))) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is null;";
*/

     AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = :eqp  from \
     adm_address_tbl as ad1 where ad1.id = :addr and (clm_pclient_tbl.id_street=ad1.id_street)and(clm_pclient_tbl.build=ad1.building) \
     and (coalesce(clm_pclient_tbl.build_add,'_')=coalesce(ad1.building_add,'_' )) and id_eqpborder is null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
//     ZQUpdate->ParamByName("dt")->AsDateTime=ChDate;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
//      ZQUpdate->Transaction->Rollback();
//      ZQUpdate->Close();
      return;
     }

//   ZQUpdate->Transaction->Commit();
   DBGrid->Query->Refresh();
  };
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::ConnectStreet(TObject* Sender)
{
   TWTDBGrid* Grid;
   Grid=((TMainForm*)MainForm)->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=StreetAddrAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::StreetAddrAccept (TObject* Sender)
{
    int id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;
/*
    TfChangeDate* fChangeDate;

    if (ChDate  == TDateTime(0))
    {
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     if (fChangeDate->ShowModal()!= mrOk)
      {
       delete fChangeDate;
       return ; // Отменить
      };
      try
      {
       ChDate=StrToDate(fChangeDate->edDt_change->Text);
      }
      catch(...)
      {
       ShowMessage("Неверная дата");
       delete fChangeDate;
       return ;
      }
      delete fChangeDate;
    }
*/

    /*
     AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client in \
     (select cl.id from clm_client_tbl as cl join adm_address_tbl as ad1 on (ad1.id=cl.id_addres) \
     join adm_address_tbl as ad2 on (ad2.id_street=ad1.id_street) where ad2.id = :addr );";
    */
/*
 AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp , dt_change = :dt from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 \
     on (ad2.id_street=ad1.id_street)) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is null;";
*/


     AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = :eqp  from \
     adm_address_tbl as ad1 where ad1.id = :addr and (clm_pclient_tbl.id_street=ad1.id_street) \
     and id_eqpborder is null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
//     ZQUpdate->ParamByName("dt")->AsDateTime=ChDate;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
//      ZQUpdate->Close();
//      ZQUpdate->Transaction->Rollback();
      return;
     }
//   ZQUpdate->Transaction->Commit();
   DBGrid->Query->Refresh();
  };
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::UnConnectAddr(TObject* Sender)
{
   TWTDBGrid* Grid;
   Grid=((TMainForm*)MainForm)->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=RemAddrAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::UnConnectAll(TObject* Sender)
{
     if (MessageDlg("Отключить все абонентов от данного оборудования ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
         return;


     AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = null where id_eqpborder = :eqp ;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);

     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);

      return;
     }

   DBGrid->Query->Refresh();

}

//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::RemAddrAccept (TObject* Sender)
{
    int id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;

    TfChangeDate* fChangeDate;
/*
    if (ChDate  == TDateTime(0))
    {
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     if (fChangeDate->ShowModal()!= mrOk)
      {
       delete fChangeDate;
       return ; // Отменить
      };
      try
      {
       ChDate=StrToDate(fChangeDate->edDt_change->Text);
      }
      catch(...)
      {
       ShowMessage("Неверная дата");
       delete fChangeDate;
       return ;
      }
      delete fChangeDate;
    }
 */
/*
AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = null , dt_change = :dt from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' )))) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is not null;";
*/

     AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = null  from \
     adm_address_tbl as ad1 where ad1.id = :addr and (clm_pclient_tbl.id_street=ad1.id_street)and(clm_pclient_tbl.build=ad1.building) \
     and (coalesce(clm_pclient_tbl.build_add,'_')=coalesce(ad1.building_add,'_' )) and id_eqpborder = :eqp ;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
 //    ZQUpdate->ParamByName("dt")->AsDateTime=ChDate;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
//      ZQUpdate->Transaction->Rollback();
//      ZQUpdate->Close();
      return;
     }

//   ZQUpdate->Transaction->Commit();
   DBGrid->Query->Refresh();
  };
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::UnConnectStreet(TObject* Sender)
{
   TWTDBGrid* Grid;
   Grid=((TMainForm*)MainForm)->AdmAddressMSel(NULL);
   if(Grid==NULL) return;
   else WAddrGrid=Grid;

   WAddrGrid->StringDest = "1";
   WAddrGrid->OnAccept=RemStreetAddrAccept;

}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::RemStreetAddrAccept (TObject* Sender)
{
    int id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;
 /*
    TfChangeDate* fChangeDate;

    if (ChDate  == TDateTime(0))
    {
     Application->CreateForm(__classid(TfChangeDate), &fChangeDate);
     if (fChangeDate->ShowModal()!= mrOk)
      {
       delete fChangeDate;
       return ; // Отменить
      };
      try
      {
       ChDate=StrToDate(fChangeDate->edDt_change->Text);
      }
      catch(...)
      {
       ShowMessage("Неверная дата");
       delete fChangeDate;
       return ;
      }
      delete fChangeDate;
    }
   */
/*
 AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = null , dt_change = :dt from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 \
     on (ad2.id_street=ad1.id_street)) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is not null;";
*/

     AnsiString sqlstr="update clm_pclient_tbl set id_eqpborder = null  from \
     adm_address_tbl as ad1 where ad1.id = :addr and (clm_pclient_tbl.id_street=ad1.id_street) \
     and id_eqpborder = :eqp ;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
//     ZQUpdate->ParamByName("dt")->AsDateTime=ChDate;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);

//      ZQUpdate->Transaction->Rollback();
      return;
     }
//   ZQUpdate->Transaction->Commit();
   DBGrid->Query->Refresh();
  };
//---------------------------------------------------------------------------

void __fastcall TfAbonConnect::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
//9999999999999999999999999999999999999999999999999999999999999999999999999999


__fastcall TfGekConnect::TfGekConnect(TWinControl *owner, TWTQuery *query,bool IsMDI,int Code,
           bool def_list=true):TWTWinDBGrid(owner,query,IsMDI)
{
   def_mode=def_list;
   if (def_mode)
   {
    btAll=DBGrid->ToolBar->AddButton("AddCond", "Полный список", ShowAll);
    btConn=DBGrid->ToolBar->AddButton("RemCond", "Подключенные к данному объекту", ShowConnected);

    btAll->Visible=false;
   }
   DBGrid->Query->BeforePost=AfterScroll;
   DBGrid->Query->AfterInsert=CancelInsert;
   OnCloseQuery=GridClose;
   ZQUpdate = new TWTQuery(Application);
   ZQUpdate->MacroCheck=true;
   ZQUpdate->Options.Clear();

  ZQUpdate->RequestLive=false;
  ZQUpdate->CachedUpdates=false;


  ZQUpdate->Sql->Clear();

   CodeEqp=Code;

   ChDate  = TDateTime(0);
}
//---------------------------------------------------------------------------

void __fastcall TfGekConnect::ShowAll(TObject* Sender)
{
//
 btConn->Visible=true;
 btAll->Visible=false;
 DBGrid->Query->Filtered=false;
 DBGrid->Query->Refresh();
}
//---------------------------------------------------------------------------

void __fastcall TfGekConnect::ShowConnected(TObject* Sender)
{
//
 btConn->Visible=false;
 btAll->Visible=true;

 if (DBGrid->Query->FindField("connected")!=NULL)
     {
     DBGrid->Query->Filtered=false;
      DBGrid->Query->Filter="connected = 1";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }
}
//---------------------------------------------------------------------------
void __fastcall TfGekConnect::AfterEdit(TDataSet* DataSet)
{  pid_dom=DataSet->FieldByName("id")->AsInteger;
   ZQUpdate->Close();
   ZQUpdate->Sql->Clear();
   AnsiString sqlstr="update adi_build_tbl set code_eqp = :eqp where id = :id_dom ;";
   ZQUpdate->Sql->Add(sqlstr);

  ZQUpdate->ParamByName("id_dom")->AsInteger=DataSet->FieldByName("id")->AsInteger;

  if (DataSet->FieldByName("connected")->AsInteger!=1)
    {ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
     DataSet->FieldByName("connected")->AsInteger=0;
     }
  else
  {    ZQUpdate->ParamByName("eqp")->Clear();
  };

  try
   {
    ZQUpdate->ExecSql();
   }
  catch(...)
   {
    ShowMessage("Ошибка SQL :"+sqlstr);
    //   ShowMessage("Ошибка.");
//    ZQUpdate->Transaction->Rollback();                 //<<<<
    return ;
   }
//  ZQUpdate->Transaction->Commit();
}
//---------------------------------------------------------------------------
void __fastcall TfGekConnect::AfterScroll(TDataSet* DataSet)
{
   pid_dom=DataSet->FieldByName("id")->AsInteger;
   ZQUpdate->Close();
   ZQUpdate->Sql->Clear();
   AnsiString sqlstr="update adi_build_tbl set code_eqp = :eqp where id = :id_dom ;";
   int con = DataSet->FieldByName("connected")->AsInteger;
   int oldcon = DataSet->FieldByName("oldconnected")->AsInteger;
    ZQUpdate->Sql->Add(sqlstr);
    ZQUpdate->ParamByName("id_dom")->AsInteger=pid_dom;
    if (DataSet->FieldByName("connected")->AsInteger==1)
     {
      ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;
     }
   else
   {
    ZQUpdate->ParamByName("eqp")->Clear();
   };
    try
   {
    ZQUpdate->ExecSql();
   }
   catch(...)
   {      ShowMessage("Ошибка SQL :"+sqlstr);
    //ShowMessage("Ошибка.");
//    ZQUpdate->Transaction->Rollback();                 //<<<<
    return ;
   }
//   ZQUpdate->Transaction->Commit();
   };

//---------------------------------------------------------------------------
void __fastcall TfGekConnect::GridClose(TObject* Sender, bool &CanClose)
{
//  if (fTreeForm!=NULL)
//  {
//   ZQUpdate->Transaction->AutoCommit=false;
//   ZQUpdate->Transaction->TransactSafe=true;
//   ZQUpdate->Transaction->NewStyleTransactions=false;
//  }

};
//---------------------------------------------------------------------------

void __fastcall TfGekConnect::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------

