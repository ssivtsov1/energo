//---------------------------------------------------------------------------

#ifndef PlombListH
#define PlombListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfPlombList : public TWTWinDBGrid
{
public:
       __fastcall TfPlombList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int client, int point);
       _fastcall ~TfPlombList();
//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
//       void __fastcall NewEqp(TObject* Sender);
//       void _fastcall  NewEqpGr(TWTDBGrid *Sender);
       void __fastcall DelPlomb(TObject* Sender);
       void _fastcall AfterIns(TWTDBGrid *Sender);
       void __fastcall EqpAccept (TObject* Sender);

       void _fastcall PlombNewGr(TWTDBGrid *Sender);
       void __fastcall PlombNew(TObject* Sender);
       void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
       void _fastcall  OnPlombRemove(TWTField  *Sender);

       AnsiString Abon_name;
       AnsiString ResName;
       AnsiString Point_name;
       TDateTime list_date;       
       int id_point;
       int id_client;
       int id_type;
       TWTQuery* qPosition;
       TWTQuery* qPositionOff;

       TWTToolButton* btAll;
       TWTToolButton* btNow;
       void __fastcall ShowNow(TObject* Sender);
       void __fastcall ShowAll(TObject* Sender);
       void __fastcall PrintPlombList(TObject *Sender);


//       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------
#endif
