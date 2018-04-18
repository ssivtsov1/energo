
//---------------------------------------------------------------------------

#ifndef filnmH
#define filnmH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include "TWTCompatable.h"
//---------------------------------------------------------------------------
class TSetFieldName : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label2;
        TListView *ListView1;
        TSpeedButton *SpeedButton1;
        void __fastcall SpeedButton1Click(TObject *Sender);
        void __fastcall Refresh(int id_docum,int id);
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall ListView1Change(TObject *Sender, TListItem *Item,
          TItemChange Change);
private:	// User declarations
public:		// User declarations
        __fastcall TSetFieldName(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TSetFieldName *SetFieldName;
//---------------------------------------------------------------------------
#endif
