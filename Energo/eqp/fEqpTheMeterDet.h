//---------------------------------------------------------------------------

#ifndef fEqpTheMeterDetH
#define fEqpTheMeterDetH
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
class TfEqpMeterDet : public TfEqpDet
{
__published:	// IDE-managed Components
        TPageControl *CompensatorPageControl;
        TTabSheet *TabSheetMain;
        TTabSheet *TabSheetOther;
        TPanel *pMeterMain;
        TLabel *Label1;
        TEdit *edMeterTypeName;
        TSpeedButton *bEqpTypeSel;
        TLabel *Label2;
        TMemo *mObjName;
        TLabel *Label4;
        TPanel *pMeterOther;
        TLabel *Label6;
        TSpeedButton *sbAddZone;
        TSpeedButton *sbDelZone;
        TSpeedButton *sbAddEnergy;
        TSpeedButton *sbDelEnergy;
        TDBGrid *dgEnergy;
        TDBGrid *dgZones;
        TSpeedButton *sbSaveZone;
        TLabel *Label14;
        TCheckBox *cbWarm;
        TMaskEdit *edControlData;
        TLabel *Label11;
        TLabel *Label3;
        TCheckBox *cbCount_met;
        TEdit *edMet_comment;
        TLabel *Label5;
        TEdit *edWarm_comment;
        TTabSheet *TabSheetZDubl;
        TPanel *Panel1;
        TLabel *Label7;
        TSpeedButton *sbAddZone2;
        TSpeedButton *sbDelZone2;
        TSpeedButton *sbSaveZone2;
        TDBGrid *dgZoneProc;
        TCheckBox *cbMagnet;
        TLabel *lMeterType;
        TSpeedButton *sbGetControlData;
        void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
        void __fastcall FormShow(TObject *Sender);
        void __fastcall bEqpTypeSelClick(TObject *Sender);
        void __fastcall sbDelEnergyClick(TObject *Sender);
        void __fastcall sbAddEnergyClick(TObject *Sender);
//        void __fastcall sbGotoCompClick(TObject *Sender);
        void __fastcall sbAddZoneClick(TObject *Sender);
        void __fastcall sbAddZone2Click(TObject *Sender);        
        void __fastcall sbDelZoneClick(TObject *Sender);
        void __fastcall sbDelZoneProcClick(TObject *Sender);
        void __fastcall dgZonesColEnter(TObject *Sender);
        void __fastcall sbSaveZoneClick(TObject *Sender);
        void __fastcall sbSaveEnergyClick(TObject *Sender);
        void __fastcall dgEnergyEnter(TObject *Sender);
        void __fastcall dgZonesEnter(TObject *Sender);
//        void __fastcall sbSelAccountClick(TObject *Sender);
//        void __fastcall sbTarifSelClick(TObject *Sender);
        void __fastcall edDataChange(TObject *Sender);
        void __fastcall cbCounLostClick(TObject *Sender);
        void __fastcall dgZoneProcEnter(TObject *Sender);
        void __fastcall sbGetControlDataClick(TObject *Sender);
//        void __fastcall sbSelIndustryClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TfEqpMeterDet(TComponent* Owner);

        bool SaveNewData(int id);
        bool SaveData(void);
        bool CheckData(void);
        void _fastcall ShowMeter(AnsiString retvalue);
        void __fastcall MeterAccept(TObject* Sender);
        void _fastcall ShowEnergy(AnsiString retvalue);
        void __fastcall EnergyAccept(TObject* Sender);
        void __fastcall ZoneAccept (TObject* Sender);
        void __fastcall PostZone(TDataSet* DataSet);
        void ShowEnergyGrid(void);
        void ShowZonesGrid(void);
        void ShowZonesProcGrid(void);
        void __fastcall NewZone(TDataSet* DataSet);
        void __fastcall ZonesScroll(TDataSet* DataSet);
        void FindCompensator(void);
        void __fastcall CancelInsert(TDataSet* DataSet);


        int MeterId;
        int TarifId;
        int AccountId;
        int IndustryId;

        TWTQuery* ZEnergyQuery;
        TWTQuery* ZZoneQuery;
        TWTQuery* ZZoneProcQuery;
        TDataSource* dsEnergyQuery;
        TDataSource* dsZoneQuery;
        TDataSource* dsZoneProcQuery;        

        void __fastcall ZoneAccept2(TObject* Sender);
        void __fastcall EditZoneProc(TDataSet* DataSet);
        void __fastcall ZoneProcChanged(TDataSet* DataSet);

        TfSelParam* fSelParam; //форма для выбора отраслей
       // bool CangeLogEnabled;
        int operation; //Текущая операция замены оборудования
        // временно, пока не станет ясно, откуда его брать
//        int usr_id;
        bool edit_enable;
};
//---------------------------------------------------------------------------
//extern PACKAGE TfEqpCompensDet *fEqpCompensDet;
//---------------------------------------------------------------------------
#endif
