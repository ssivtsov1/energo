//---------------------------------------------------------------------------

#ifndef point_cardH
#define point_cardH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include "TWTCompatable.h"
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include <DBGrids.hpp>
#include <Grids.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"
#include <Db.hpp>
#include <ComCtrls.hpp>
#include "xlcClasses.hpp"
#include "xlReport.hpp"
//---------------------------------------------------------------------------
class TfPointCard : public TfTWTCompForm
{
__published:	// IDE-managed Components
        TPanel *Panel1;
        TBitBtn *btOk;
        TBitBtn *btCancel;
        TPanel *Panel2;
        TLabel *Label1;
        TLabel *Label2;
        TPanel *Panel3;
        TPanel *Panel4;
        TPanel *Panel5;
        TDBGrid *DBGrid3;
        TDBGrid *DBGrid5;
        TZPgSqlQuery *ZQMeters;
        TDataSource *dsMeters;
        TDateTimePicker *DateTimePicker;
        TDBGrid *DBGrid1;
        TDataSource *dsCompI;
        TZPgSqlQuery *ZQCompI;
        TLabel *lPointName;
        TLabel *lAreaName;
        TLabel *lAddressc;
        TLabel *lAddress;
        TZPgSqlQuery *ZQPoint;
        TPanel *Panel6;
        TSpeedButton *sbWorkList;
        TDBGrid *dgWorks;
        TPanel *Panel7;
        TDataSource *dsWorks;
        TZPgSqlQuery *ZQWorks;
        TSpeedButton *sbRefresh;
        TDataSource *dsPlombs;
        TZPgSqlQuery *ZQPlombs;
        TSpeedButton *sbPlombsRefresh;
        TSpeedButton *sbPlombsList;
        TxlReport *xlReport;
        TLabel *Label3;
        TLabel *lLastDate;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall btCancelClick(TObject *Sender);
        void __fastcall DateTimePickerChange(TObject *Sender);
        void __fastcall sbWorkListClick(TObject *Sender);
        void __fastcall dgWorksDblClick(TObject *Sender);
        void __fastcall sbRefreshClick(TObject *Sender);
        void __fastcall sbPlombsRefreshClick(TObject *Sender);
        void __fastcall sbPlombsListClick(TObject *Sender);
        void __fastcall btOkClick(TObject *Sender);
        void __fastcall DateTimePickerKeyPress(TObject *Sender, char &Key);
private:	// User declarations
public:		// User declarations
        __fastcall TfPointCard(TComponent* Owner);
        void __fastcall WorkListClose(TObject *Sender, bool &CanClose);
        void __fastcall PlombListClose(TObject *Sender, bool &CanClose);
        void __fastcall ShowData(int id);

        TWTQuery *ZQWorksList;
        TWTQuery *ZQPlombList;
        int id_point;
        AnsiString AbonName;
        AnsiString ResName;
        AnsiString CurUserName;        
        int id_client;        
};
//---------------------------------------------------------------------------
extern PACKAGE TfPointCard *fPointCard;
//---------------------------------------------------------------------------
#endif
 