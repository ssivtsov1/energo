//---------------------------------------------------------------------------
#ifndef fEqpBorderDetH
#define fEqpBorderDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include "Main.h"
#include "fDet.h"
#include <ExtCtrls.hpp>
#include "CliSald.h"
//---------------------------------------------------------------------------
class TfBorderDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TLabel *Label1;
        TLabel *Label3;
        TLabel *Label2;
        TEdit *edClientA;
        TEdit *edClientB;
        TMemo *mInf;
        TLabel *Label4;
        TEdit *edDoc;
        TSpeedButton *bDocSel;
        TLabel *Label14;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall edClientAChange(TObject *Sender);
        void __fastcall edClientBChange(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall sbCliDocClick(TObject *Sender);
        void __fastcall DocAccept(TObject *Sender);
private:	// User declarations
public:		// User declarations

        // коды loockup полей
        int ClientAId;
        int ClientBId;
        int DocId;
           TfCliCDocs* Grid;
        __fastcall TfBorderDet(TComponent* Owner);

        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);

        bool edit_enable;        
};
//---------------------------------------------------------------------------
//extern PACKAGE TfSimpleEqpDet *fSimpleEqpDet;
//---------------------------------------------------------------------------
#endif
