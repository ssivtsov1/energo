//---------------------------------------------------------------------------

#ifndef fEqpPointDetH
#define fEqpPiomtDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "fDet.h"
#include <Mask.hpp>
#include <DBGrids.hpp>
#include "Query.h"
#include <Db.hpp>
#include <DBTables.hpp>
#include "fParamSel.h"
//---------------------------------------------------------------------------
class TfEqpPointDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPageControl *PageControl1;
        TTabSheet *TabSheet1;
        TTabSheet *TabSheet2;
        TPanel *pMeterMain;
        TLabel *Label1;
        TLabel *Label2;
        TSpeedButton *sbAddEnergy;
        TSpeedButton *sbDelEnergy;
        TLabel *Label9;
        TLabel *lTarifReq;
        TSpeedButton *sbTarifSel;
        TLabel *lPowerReq;
        TLabel *Label7;
        TLabel *Label4;
        TLabel *Label5;
        TSpeedButton *sbTgSel;
        TEdit *edPower;
        TDBGrid *dgEnergy;
        TEdit *edTarifName;
        TCheckBox *cbCounLost;
        TEdit *edEkvivalent;
        TEdit *edWorkTime;
        TEdit *edTgName;
        TPanel *Panel1;
        TSpeedButton *sbSelIndustry;
        TLabel *lWtimeReq;
        TLabel *lTgReq;
        TLabel *Label6;
        TMaskEdit *EdKwed;
        TLabel *LabKwed;
        TLabel *Label8;
        TEdit *edShare;
        TCheckBox *cbCount_itr;
        TLabel *Label10;
        TEdit *edCmp;
        TEdit *edItr_comment;
        TLabel *Label11;
        TEdit *edLdemand;
        TEdit *edPdays;
        TLabel *Label12;
        TLabel *Label3;
        TEdit *edClassId;
        TLabel *lClassVal;
        TSpeedButton *sbClassSel;
        TLabel *Label13;
        TSpeedButton *sbSelZone;
        TEdit *edZone;
        TCheckBox *cbHlosts;
        TEdit *edDepart;
        TSpeedButton *sbDepart;
        TLabel *Label14;
        TCheckBox *cbMainLosts;
        TEdit *edLdemandr;
        TEdit *edLdemandg;
        TEdit *edUn;
        TLabel *Label15;
        TLabel *lUnName;
        TSpeedButton *sbUnSel;
        TCheckBox *cbLost_Nolost;
        TLabel *Label16;
        TEdit *edExtra;
        TSpeedButton *sbExtra;
        TSpeedButton *spExtraClean;
        TLabel *Label17;
        TEdit *edControlDay;
        TCheckBox *cbReserv;
        TCheckBox *cbInLost;
        TLabel *Label18;
        TEdit *edConnect;
        TLabel *Label19;
        TEdit *EdPosition;
        TSpeedButton *sbPosition;
        TSpeedButton *spPositionClear;
        TSpeedButton *sbPassport;
        TBitBtn *btAktMEM;
        TLabel *Label20;
        TCheckBox *cbKVA;
        TEdit *edSafeCategory;
        TLabel *Label21;
        TCheckBox *cbDisabled;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall sbDelEnergyClick(TObject *Sender);
        void __fastcall sbAddEnergyClick(TObject *Sender);
        void __fastcall dgEnergyEnter(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall sbTarifSelClick(TObject *Sender);
        void __fastcall sbSelIndustryClick(TObject *Sender);
        void __fastcall cbCounLostClick(TObject *Sender);
        void __fastcall sbTgSelClick(TObject *Sender);
        void __fastcall sbClassSelClick(TObject *Sender);
        void __fastcall sbSelZoneClick(TObject *Sender);
        void __fastcall sbDepartClick(TObject *Sender);
        void __fastcall sbUnSelClick(TObject *Sender);
        void __fastcall sbExtraClick(TObject *Sender);
        void __fastcall spExtraCleanClick(TObject *Sender);
        void __fastcall spPositionClearClick(TObject *Sender);
        void __fastcall sbPositionClick(TObject *Sender);
        void __fastcall sbPassportClick(TObject *Sender);
        void __fastcall btAktMEMClick(TObject *Sender);
        
private:	// User declarations
public:		// User declarations
        __fastcall TfEqpPointDet(TComponent* Owner);

        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowEnergy(AnsiString retvalue);
        void __fastcall EnergyAccept(TObject* Sender);
        void ShowEnergyGrid(void);
        void __fastcall CancelInsert(TDataSet* DataSet);
//        void __fastcall TreeDblClick(TObject *Sender);
        void __fastcall KwedAccept (TObject* Sender);
        void __fastcall TarAccept(TObject *Sender);
        void __fastcall TgAccept(TObject *Sender);
        void _fastcall ShowVoltage(AnsiString retvalue);
        void __fastcall VoltageAccept(TObject* Sender);
        void __fastcall ZoneAccept (TObject* Sender);
        void __fastcall DepAccept (TObject* Sender);
        void __fastcall ExtraAccept(TObject* Sender);
        void __fastcall PosAccept (TObject* Sender);        
        TWTQuery* ZEnergyQuery;
        TDataSource* dsEnergyQuery;

        TfSelParam* fSelParam; //форма для выбора отраслей
        int TarifId;
        int TgId;  //  справочник тангенс фи
        int ZoneId;
        int IndustryId;
        int DepartId;
        int ExtraId;

       // bool CangeLogEnabled;
        int operation; //Текущая операция замены оборудования
        // временно, пока не станет ясно, откуда его брать
//        int usr_id;
        bool edit_enable;
        int id_position;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfEqpCompensDet *fEqpCompensDet;
//---------------------------------------------------------------------------
#endif
