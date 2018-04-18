//---------------------------------------------------------------------------

#ifndef fmonFiderWorkEditH
#define fmonFiderWorkEditH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
#include "ZPgSqlQuery.hpp"
#include "TWTCompatable.h"
#include "ZQuery.hpp"
#include <DBGrids.hpp>
#include <Grids.hpp>
#include <Db.hpp>
#include "ZUpdateSql.hpp"
#include <CurrEdit.hpp>
#include <RxLookup.hpp>
#include "ToolEdit.hpp"
//---------------------------------------------------------------------------
class TfMonitorFiderWorkEdit : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TPanel *Panel2;
        TLabel *Label3;
        TMaskEdit *edData;
        TLabel *Label8;
        TEdit *edFiderName;
        TSpeedButton *sbFider;
        TLabel *Label2;
        TMemo *mComment;
        TZPgSqlQuery *ZQWorkType;
        TDataSource *dsWorkType;
        TLabel *Label4;
        TRxLookupEdit *lcWork;
        TLabel *Label5;
        TEdit *edObject;
        TLabel *Label1;
        TRxCalcEdit *edCnt;
        TLabel *Label6;
        TEdit *edAbonCode;
        TEdit *edAbonName;
        TSpeedButton *sbAbon;
        TSpeedButton *SpeedButton1;
        TLabel *Label7;
        TEdit *edInspector;
        TSpeedButton *sbInspector;
        TSpeedButton *sbInspectorCl;
        void __fastcall sbFiderClick(TObject *Sender);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall sbAbonClick(TObject *Sender);
        void __fastcall edAbonCodeKeyPress(TObject *Sender, char &Key);
        void __fastcall sbInspectorClClick(TObject *Sender);
        void __fastcall sbInspectorClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfMonitorFiderWorkEdit(TComponent* Owner);
        void __fastcall PlaceAccept (TObject* Sender);
        void __fastcall AbonAccept (TObject* Sender);
        void __fastcall PosAccept (TObject* Sender);
        void ShowNew(void);
        void ShowData( int sw_id);

        int FiderFilterId;
        int FiderId;
        int mode;
        int Id;
        int AbonId;
        int InspectorId;
        TZPgSqlQuery *ZQBalans;
        TWTQuery*  qParent;
};
//---------------------------------------------------------------------------
extern PACKAGE TfMonitorFiderWorkEdit *fMonitorFiderWorkEdit;
//---------------------------------------------------------------------------
#endif