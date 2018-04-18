//---------------------------------------------------------------------------

//#include <vcl.h>

#include "AbonConnect.h"
#include "Main.h"
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

    btAll->Visible=false;
   }

//   DBGrid->Query->AfterOpen=AfterOpen;
   DBGrid->Query->AfterEdit=AfterEdit;
   //DBGrid->Query->BeforeEdit=BeforeEdit;
   DBGrid->Query->AfterPost=AfterScroll;
  // DBGrid->Query->BeforeClose=GridClose1;
//   OnCloseQuery=GridClose;
   ZQUpdate = new TWTQuery(Application);
   ZQUpdate->MacroCheck=true;
   ZQUpdate->Options.Clear();
//   ZQUpdate->Options<< doQuickOpen;

   ZQUpdate->RequestLive=false;
   ZQUpdate->CachedUpdates=false;


  AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client = :client ;";
  ZQUpdate->Sql->Clear();
  ZQUpdate->Sql->Add(sqlstr);

//   ZQUpdate->Transaction->AutoCommit=false;

   CodeEqp=Code;

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
      DBGrid->Query->Filter="connected=1";
      DBGrid->Query->Filtered=true;
      DBGrid->Query->Refresh();
     }
}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::AfterEdit(TDataSet* DataSet)
{
  // int pid_client;
   pid_client=DataSet->FieldByName("id_client")->AsInteger;


  ZQUpdate->Close();
   ZQUpdate->Sql->Clear();
  AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client = :client ;";

  ZQUpdate->Sql->Add(sqlstr);

  ZQUpdate->ParamByName("client")->AsInteger=DataSet->FieldByName("id_client")->AsInteger;

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
    ZQUpdate->Transaction->Rollback();                 //<<<<

    return ;

  }
  ZQUpdate->Transaction->Commit();
}
//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::AfterScroll(TDataSet* DataSet)
{

 TLocateOptions SearchOptions;
   SearchOptions.Clear();
   DataSet->Locate("id_client",pid_client ,SearchOptions);
   };

//---------------------------------------------------------------------------
void __fastcall TfAbonConnect::GridClose(TObject* Sender, bool &CanClose)
{

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

};


void __fastcall TfAbonConnect::GridClose1(TDataSet* Sender)
{
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

///    and (coalesce(ad2.building_add,"_")=coalesce(ad2.building_add,"_"))
     /*
     AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client in \
     (select cl.id from clm_client_tbl as cl join adm_address_tbl as ad1 on (ad1.id=cl.id_addres) \
     join adm_address_tbl as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' ))) \
     where ad2.id = :addr );";
       */
AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' )))) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZQUpdate->Transaction->Rollback();
//      ZQUpdate->Close();
      return;
     }

   ZQUpdate->Transaction->Commit();
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
     AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  where id_client in \
     (select cl.id from clm_client_tbl as cl join adm_address_tbl as ad1 on (ad1.id=cl.id_addres) \
     join adm_address_tbl as ad2 on (ad2.id_street=ad1.id_street) where ad2.id = :addr );";
    */

 AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = :eqp  from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 \
     on (ad2.id_street=ad1.id_street)) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;
     ZQUpdate->ParamByName("eqp")->AsInteger=CodeEqp;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
//      ZQUpdate->Close();
      ZQUpdate->Transaction->Rollback();
      return;
     }
   ZQUpdate->Transaction->Commit();
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
void __fastcall TfAbonConnect::RemAddrAccept (TObject* Sender)
{
    int id_address=WAddrGrid->Table->FieldByName("id")->AsInteger;

AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = null  from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 on ((ad2.id_street=ad1.id_street)and(ad2.building=ad1.building) \
     and (coalesce(ad2.building_add,'_')=coalesce(ad1.building_add,'_' )))) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is not null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;

     try
     {
      ZQUpdate->ExecSql();
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);
      ZQUpdate->Transaction->Rollback();
//      ZQUpdate->Close();
      return;
     }

   ZQUpdate->Transaction->Commit();
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

 AnsiString sqlstr="update eqm_privmeter_tbl set id_eqmborder = null  from \
     (select cl.id from clm_client_tbl as cl inner join (select ad1.id  from adm_address_tbl as ad1 \
     right join ( select * from adm_address_tbl where id = :addr) as ad2 \
     on (ad2.id_street=ad1.id_street)) as ad3 on (ad3.id=cl.id_addres) \
     ) as a where eqm_privmeter_tbl.id_client=a.id and id_eqmborder is not null;";

     ZQUpdate->Sql->Clear();
     ZQUpdate->Sql->Add(sqlstr);
     ZQUpdate->ParamByName("addr")->AsInteger=id_address;

     try
     {
      ZQUpdate->ExecSql();                   
     }
     catch(...)
     {
      ShowMessage("Ошибка SQL :"+sqlstr);

      ZQUpdate->Transaction->Rollback();
      return;
     }
   ZQUpdate->Transaction->Commit();
   DBGrid->Query->Refresh();
  };
//---------------------------------------------------------------------------


