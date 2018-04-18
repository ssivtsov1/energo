//---------------------------------------------------------------------------

#ifndef fCompIH
#define fCompIH
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
#include <ImgList.hpp>
#include "TWTCompatable.h"

//---------------------------------------------------------------------------
class TfCompISpr : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TToolBar *ToolBar1;
        TPanel *Panel1;
        TStatusBar *StatusBar1;
        TEdit *edType;
        TEdit *edNormative;
        TEdit *edVoltage_nom;
        TEdit *edAmperage_nom;
        TEdit *edVoltage_max;
        TEdit *edAmperage_max;
        TEdit *edSwathe;
        TEdit *edPower_nom;
        TEdit *edAmperage_no_load;
        TComboBox *cbPhase;
        TComboBox *cbHook_up;
        TLabel *Label16;
        TLabel *Label17;
        TLabel *Label18;
        TLabel *Label19;
        TLabel *Label20;
        TLabel *Label21;
        TLabel *Label22;
        TLabel *Label23;
        TLabel *Label24;
        TLabel *Label25;
        TLabel *Label26;
        TToolButton *tbSave;
        TToolButton *tbCancel;
        TEdit *edAccuracy;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TEdit *edVoltage2_nom;
        TEdit *edAmperage2_nom;
        TLabel *Label4;
        TComboBox *cbConversion;
        TBevel *Bevel1;
        TBevel *Bevel2;
        TImageList *ImageList1;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall cbPhaseChange(TObject *Sender);
        void __fastcall cbHook_upChange(TObject *Sender);
        void __fastcall cbConversionChange(TObject *Sender);
        void __fastcall tbSaveClick(TObject *Sender);
        void __fastcall tbCancelClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfCompISpr(TComponent* Owner);

//       void _fastcall ActivateMenu(TObject *Sender);
//       TMenuItem *WindowMenu;
//       AnsiString ID;

       void __fastcall ShowData(int id);
       bool SaveData(void);
       bool SaveNewData(void);

       // Массивы индексов фаз и способов соединения, а также их размеры
       int phaseid_arr[10];
       int hook_upid_arr[10];
       int conversionid_arr[5];
       int phase_no;
       int hook_up_no;
       int conversion_no;
       int phaseid;
       int hook_upid;
       int conversionid;

       //код тек. оборудования
       int eqid;
       // Местный Query
       TZPgSqlQuery *ZEqpQuery;
       // -- Запрос в списке, из которого вызвана форма(для обновления)
       TZPgSqlQuery *ParentDataSet;
       //-- Режим (вставка/ред)
       int mode;
       //
       int refresh;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfCompSpr *fCompSpr;
extern PACKAGE TWTWinDBGrid *WCompIGrid;
//---------------------------------------------------------------------------
#endif
