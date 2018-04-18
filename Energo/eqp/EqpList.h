//---------------------------------------------------------------------------

#ifndef EqpListH
#define EqpListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfEqpList : public TWTWinDBGrid
{
public:
       __fastcall TfEqpList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int kind,AnsiString AddFilds[],AnsiString AddFildsName[],int FildsCount,AnsiString WinName, bool IsInsert);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
       void __fastcall NewEqp(TObject* Sender);
       void _fastcall  NewEqpGr(TWTDBGrid *Sender);
       void __fastcall DelEqp(TObject* Sender);
       void __fastcall EqpAccept (TObject* Sender);
       AnsiString name_table_ind;
       int kindid;
       int usr_id;
       bool ReadOnly;
       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------
#endif
