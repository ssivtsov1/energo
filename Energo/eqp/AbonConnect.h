//---------------------------------------------------------------------------

#ifndef AbonConnectH
#define AbonConnectH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfAbonConnect : public TWTWinDBGrid
{
public:
       __fastcall TfAbonConnect(TWinControl *owner, TWTQuery *query,bool IsMDI,int Code, 
		bool def_list);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
       void __fastcall ShowConnected(TObject* Sender);
       void __fastcall ShowAll(TObject* Sender);
       void __fastcall AfterEdit(TDataSet* DataSet);
       void __fastcall AfterScroll(TDataSet* DataSet);
       void __fastcall GridClose(TObject* Sender, bool &CanClose);
       void __fastcall GridClose1(TDataSet* Sender);
       void __fastcall ConnectAddr(TObject* Sender);
       void __fastcall MainAddrAccept (TObject* Sender);

       void __fastcall ConnectStreet(TObject* Sender);
       void __fastcall StreetAddrAccept (TObject* Sender);
       void __fastcall RemStreetAddrAccept (TObject* Sender);
       void __fastcall RemAddrAccept (TObject* Sender);
       void __fastcall UnConnectAddr(TObject* Sender);
       void __fastcall UnConnectStreet(TObject* Sender);
       void __fastcall UnConnectAll(TObject* Sender);

       void __fastcall CancelInsert(TDataSet* DataSet);       

       int CodeEqp;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;

       TWTToolButton* btAll;
       TWTToolButton* btConn;
       TWTToolButton* btAddr;
       TWTToolButton* btAddrStreet;
       TWTToolButton* btRemAddr;
       TWTToolButton* btRemAddrStreet;
       TWTToolButton* btRemAddrAll;

       int pid_client;
       bool def_mode;
       bool ReadOnly;

       TDateTime ChDate;
};



class TfGekConnect : public TWTWinDBGrid
{
public:
       __fastcall TfGekConnect(TWinControl *owner, TWTQuery *query,bool IsMDI,int Code,
		bool def_list);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
       void __fastcall ShowConnected(TObject* Sender);
       void __fastcall ShowAll(TObject* Sender);
       void __fastcall AfterEdit(TDataSet* DataSet);
       void __fastcall AfterScroll(TDataSet* DataSet);
       void __fastcall GridClose(TObject* Sender, bool &CanClose);
       void __fastcall CancelInsert(TDataSet* DataSet);

       int CodeEqp;
       TWTQuery* ZQUpdate;
       TWTDBGrid * WAddrGrid;

       TWTToolButton* btAll;
       TWTToolButton* btConn;

       int pid_dom;
       bool def_mode;
       bool ReadOnly;

       TDateTime ChDate;
};
//-----------------------------
#endif