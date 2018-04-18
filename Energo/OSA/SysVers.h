//---------------------------------------------------------------------------

#ifndef SysVersH
#define SysVersH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TFShowVers : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TLabel *Label1;
        TLabel *Label3;
        TLabel *LVersExe;
        TLabel *LVersScr;
        TLabel *Label2;
        TLabel *LCreateScr;
        TLabel *Label5;
        TLabel *LSetScr;
        TLabel *Label7;
        TLabel *LVersExeB;
        TLabel *Label4;
        TLabel *LDump;
        TLabel *Label8;
        TLabel *LActDump;
        TLabel *LabRes;


private:	// User declarations
 TWTQuery *QVers;

public:		// User declarations
        __fastcall TFShowVers(TComponent* Owner);
        void _fastcall Show(int Ver);
};
//---------------------------------------------------------------------------
extern PACKAGE TFShowVers *FShowVers;
//---------------------------------------------------------------------------
#endif
