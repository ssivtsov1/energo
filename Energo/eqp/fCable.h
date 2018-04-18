//---------------------------------------------------------------------------

#ifndef fCableH
#define fCableH
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
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Buttons.hpp>

//---------------------------------------------------------------------------
class TfCableSpr : public TWTDoc
{
public:
        TEdit *edType;
        TEdit *edNormative;
        TEdit *edVoltage_nom;
        TEdit *edAmperage_nom;
        TEdit *edVoltage_max;
        TEdit *edAmperage_max;
        TEdit *edCords;
        TEdit *edCover;
        TEdit *edRo;
        TEdit *edDPo;
        TEdit *edSnom;        

       __fastcall TfCableSpr(TComponent* AOwner,AnsiString FName="");

        void __fastcall FormClose(TObject *Sender, bool &CanClose);
        void __fastcall tbSaveClick(TObject *Sender);
        void __fastcall tbCancelClick(TObject *Sender);
        void __fastcall CoverClick(TObject *Sender);
        void __fastcall CoverAccept (TObject* Sender);
        void __fastcall NewCord(TDataSet* DataSet);

       void __fastcall ShowData(int);
       bool SaveData(void);
       bool SaveNewData(void);
       void __fastcall ShowCordeGrid();
       //код тек. оборудования
       int eqid;
       // Местный Query
       TZPgSqlQuery *ZEqpQuery;
       // Местный Query для подчиненной таблици
       TWTQuery *CableQuery;
       TWTDBGrid *CableGrid;
       //Справочник изоляций
       TWTWinDBGrid* WCoverGrid;
       int CoverId;
//       TWTWinDBGrid *WCableGrid;
       // -- Запрос в списке, из которого вызвана форма(для обновления)
       TZPgSqlQuery *ParentDataSet;
       //-- Режим (вставка/ред)
       int mode;
       //
       int refresh;
};
//---------------------------------------------------------------------------
extern PACKAGE TWTWinDBGrid *WCableGrid;
//---------------------------------------------------------------------------
#endif
