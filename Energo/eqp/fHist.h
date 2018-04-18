//---------------------------------------------------------------------------

#ifndef fHistH
#define fHistH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <ToolWin.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include "ParamsForm.h"
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>

//---------------------------------------------------------------------------
class TfHistoryEdit : public TWTDoc
{
public:
       __fastcall TfHistoryEdit(TComponent* AOwner,int object, int cl, AnsiString table, AnsiString table_ind );


       void __fastcall ShowData(void);


       int id_object;
       int id_class;
       AnsiString name_table_ind;     //имя таблици справочника
       AnsiString name_table;         //имя таблици
//       AnsiString name_vw;         //имя таблици


//       TWTDBGrid *LifeGrid;
//       TWTQuery *LifeQuery;
       TWTDBGrid *BasicGrid;
       TWTQuery *BasicQuery;
       TWTDBGrid *DetalGrid;
       TWTQuery *DetalQuery;
       TWTDBGrid *ZoneGrid;
       TWTQuery *ZoneQuery;
       TWTDBGrid *EnergyGrid;
       TWTQuery *EnergyQuery;
       TWTDBGrid *UseGrid;
       TWTQuery *UseQuery;
       TWTDBGrid *TreeGrid;
       TWTQuery *TreeQuery;
       TWTDBGrid *AreaGrid;
       TWTQuery  *AreaQuery;

       TPageControl *PageControl1;  

       void __fastcall ShowAreaGrid();
       void __fastcall ShowBasicGrid();
       void __fastcall ShowDetalGrid();
       void __fastcall ShowEnZnGrid();
       void __fastcall ShowUseGrid();       
       void __fastcall CancelInsert(TDataSet* DataSet);
       void __fastcall CheckDelete(TDataSet* DataSet);
       void __fastcall PageControl1Change(TObject *Sender);
       void __fastcall ValidateDate(TField* Sender, const AnsiString Text);

       bool edit_enable;           
};
//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WCableGrid;
//---------------------------------------------------------------------------
#endif
