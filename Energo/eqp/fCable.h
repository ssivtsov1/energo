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
       //��� ���. ������������
       int eqid;
       // ������� Query
       TZPgSqlQuery *ZEqpQuery;
       // ������� Query ��� ����������� �������
       TWTQuery *CableQuery;
       TWTDBGrid *CableGrid;
       //���������� ��������
       TWTWinDBGrid* WCoverGrid;
       int CoverId;
//       TWTWinDBGrid *WCableGrid;
       // -- ������ � ������, �� �������� ������� �����(��� ����������)
       TZPgSqlQuery *ParentDataSet;
       //-- ����� (�������/���)
       int mode;
       //
       int refresh;
};
//---------------------------------------------------------------------------
extern PACKAGE TWTWinDBGrid *WCableGrid;
//---------------------------------------------------------------------------
#endif
