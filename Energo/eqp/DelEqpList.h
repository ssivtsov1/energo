//---------------------------------------------------------------------------

#ifndef DelEqpListH
#define DelEqpListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfDelEqpList : public TWTWinDBGrid
{
public:
       __fastcall TfDelEqpList(TWinControl *owner, TWTQuery *query,bool IsMDI,
           int id_client, AnsiString ClientName);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
//       void __fastcall NewEqp(TObject* Sender);
//       void _fastcall  NewEqpGr(TWTDBGrid *Sender);
//       void __fastcall DelEqp(TObject* Sender);
       void __fastcall EqpAccept (TObject* Sender);
//       AnsiString name_table_ind;
       int kindid;
       int usr_id;
       bool ReadOnly;
//       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------
#endif
