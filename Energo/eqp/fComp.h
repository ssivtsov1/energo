//---------------------------------------------------------------------------

#ifndef fCompH
#define fCompH
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
class TfCompSpr : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TToolBar *ToolBar1;
        TPanel *Panel1;
        TStatusBar *StatusBar1;
        TPanel *p2swathe;
        TPanel *p3swathe;
        TEdit *edType;
        TEdit *edNormative;
        TEdit *edVoltage_nom;
        TEdit *edAmperage_nom;
        TEdit *edVoltage_max;
        TEdit *edAmperage_max;
        TComboBox *edSwathe;
        TEdit *edPower_nom;
        TEdit *edAmperage_no_load;
        TComboBox *cbPhase;
        TComboBox *cbHook_up;
        TEdit *edVoltage_short_circuit;
        TEdit *edIron;
        TEdit *edCopper;
        TEdit *edPower_h;
        TEdit *edPower_m;
        TEdit *edPower_l;
        TEdit *edCopper_hl;
        TEdit *edCopper_ml;
        TEdit *edCopper_hm;
        TEdit *edVoltage_short_hl;
        TEdit *edVoltage_short_ml;
        TEdit *edVoltage_short_hm;
        TLabel *Label1;
        TLabel *Label2;
        TLabel *Label3;
        TLabel *Label4;
        TLabel *Label5;
        TLabel *Label6;
        TLabel *Label7;
        TLabel *Label8;
        TLabel *Label9;
        TLabel *Label10;
        TLabel *Label11;
        TLabel *Label12;
        TLabel *Label13;
        TLabel *Label15;
        TLabel *Label14;
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
        TEdit *edVoltage2_nom;
        TLabel *Label27;
        TLabel *Label28;
        TEdit *edAmperage2_nom;
        TBevel *Bevel1;
        TImageList *ImageList1;
        TLabel *Label29;
        TEdit *edVoltage3_nom;
        TLabel *Label30;
        TEdit *edAmperage3_nom;
        TLabel *Label31;
        TEdit *edIron3;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall cbPhaseChange(TObject *Sender);
        void __fastcall cbHook_upChange(TObject *Sender);
        void __fastcall edSwatheChange(TObject *Sender);
        void __fastcall tbSaveClick(TObject *Sender);
        void __fastcall tbCancelClick(TObject *Sender);
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfCompSpr(TComponent* Owner);

//       void _fastcall ActivateMenu(TObject *Sender);
//       TMenuItem *WindowMenu;
//       AnsiString ID;

       void __fastcall ShowData(int id);
       bool SaveData(void);
       bool SaveNewData(void);

       // Массивы индексов фаз и способов соединения, а также их размеры
       int phaseid_arr[10];
       int hook_upid_arr[10];
       int phase_no;
       int hook_up_no;
       int phaseid;
       int hook_upid;
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
extern PACKAGE TWTWinDBGrid *WCompGrid;
//---------------------------------------------------------------------------
#endif
