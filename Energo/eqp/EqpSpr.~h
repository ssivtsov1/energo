//---------------------------------------------------------------------------

#ifndef EqpSprH
#define EqpSprH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
class TfEqpSpr : public TWTWinDBGrid
{
public:
       __fastcall TfEqpSpr(TWinControl *owner, TWTQuery *query,bool IsMDI, 
		bool def_list);

//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
       void __fastcall ShowDef(TObject* Sender);
       void __fastcall ShowAll(TObject* Sender);
       void __fastcall AfterOpen(TDataSet* DataSet);
              
//       void __fastcall  NewEqpGr(TWTDBGrid *Sender);
//       void __fastcall DelEqp(TObject* Sender);
//       void __fastcall EqpAccept (TObject* Sender);
//       AnsiString name_table_ind;

//       int kindid;
//       int usr_id;
       TWTToolButton* btAll;
       TWTToolButton* btDef;
       //int ShowState;
       bool def_mode;
       bool ReadOnly;
//       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------
#endif
