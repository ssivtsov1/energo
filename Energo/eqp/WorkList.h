//---------------------------------------------------------------------------

#ifndef WorkListH
#define WorkListH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <WinGrid.h>
#include <Grids.hpp>
#include "ParamsForm.h"
//class TfWorkList : public TWTWinDBGrid
class TfWorkList : public TWTDoc
{
public:
//       __fastcall TfWorkList(TWinControl *owner, TWTQuery *query,bool IsMDI, int client, int point);
       __fastcall TfWorkList(TComponent* AOwner, int client, int point);

        TWTDBGrid* DBGrWorks;
        TWTDBGrid* DBGrIndic;
        TWTQuery*  qWorkList;
        TWTQuery*  qIndications;
        TWTPanel* PIndic;

       _fastcall ~TfWorkList();
//        void __fastcall FormClose(TObject *Sender, bool &CanClose);
//       void __fastcall NewEqp(TObject* Sender);
//       void _fastcall  NewEqpGr(TWTDBGrid *Sender);
//       void __fastcall DelEqp(TObject* Sender);
       void _fastcall AfterIns(TWTDBGrid *Sender);
       void _fastcall WorksScroll(TWTDBGrid *Sender);
//       void __fastcall EqpAccept (TObject* Sender);
       void __fastcall CancelInsert(TDataSet* DataSet);
       void __fastcall WorkAfterPost(TWTDBGrid *Sender);
//       AnsiString name_table_ind;
       int id_point;
       int id_client;
       int id_type;
       AnsiString Abon_name;
       AnsiString ResName;
       AnsiString Point_name;

       TWTQuery* qPosition;
       void __fastcall PrintWorkList(TObject *Sender);
       void __fastcall WorkDelList(TObject *Sender);
       void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
       void _fastcall  OnChangeAct(TWTField *Sender);
       void __fastcall WorkBeforePost(TWTDBGrid *Sender);
//       TNotifyEvent OldDelEqp; // Системная процедура удаления строки

};
//-----------------------------

class TfWorkHistory : public TWTDoc
{
public:

       __fastcall TfWorkHistory(TComponent* AOwner, int client, int point);

        TWTDBGrid* DBGrWorks;
        TWTDBGrid* DBGrIndic;
        TWTQuery*  qWorkList;
        TWTQuery*  qIndications;
        TWTPanel* PIndic;

       _fastcall ~TfWorkHistory();

       int id_point;
       int id_client;
       int id_type;
       AnsiString Abon_name;
       AnsiString ResName;
       AnsiString Point_name;

       TWTQuery* qPosition;
};

#endif
