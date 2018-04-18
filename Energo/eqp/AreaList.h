//---------------------------------------------------------------------------
#ifndef AreaListH
#define AreaListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfAreaList : public TWTWinDBGrid
{
public:
       __fastcall TfAreaList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int kind,int client,AnsiString WinName, bool IsInsert);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
       void __fastcall NewEqp(TObject* Sender);
       void _fastcall  NewEqpGr(TWTDBGrid *Sender);
       void __fastcall DelEqp(TObject* Sender);
       void __fastcall EqpAccept (TObject* Sender);
//       AnsiString name_table_ind;
       int kindid;
       int usr_id;
       bool ReadOnly;
       int abonent_id;
       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------
#endif
