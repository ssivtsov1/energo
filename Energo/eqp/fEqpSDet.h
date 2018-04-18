//---------------------------------------------------------------------------

#ifndef fEqpSDetH
#define fEqpSDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "Main.h"
#include "fDet.h"
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TfSimpleEqpDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TSpeedButton *bEqpTypeSel;
        TLabel *lAddData;
        TEdit *edTypeName;
        TLabel *Label14;
        TLabel *lAddReq;
        TLabel *lVoltage;
        TLabel *lVEeq;
        TEdit *edClassId;
        TLabel *lClassVal;
        TSpeedButton *sbClassSel;
        TMaskEdit *edAddData;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall bEqpTypeSelClick(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall sbClassSelClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
//        AnsiString name_table_ind;
//        AnsiString name_table;
//        int TypeId;

//        AnsiString sqlstr;
        __fastcall TfSimpleEqpDet(TComponent* Owner);
        void _fastcall ShowDict(AnsiString retvalue);
        void __fastcall Accept (TObject* Sender);
        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowVoltage(AnsiString retvalue);
        void __fastcall VoltageAccept(TObject* Sender);

       bool edit_enable;
       int AddDataType; // 0 -empty, 1- string, 2- int, 3 - date     
             
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
