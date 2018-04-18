//---------------------------------------------------------------------------

#ifndef fMeterH
#define fMeterH

#include "ParamsForm.h"
class TfMeterSpr : public TWTDoc
{
public:
 TEdit *edType;
 TEdit *edNormative;
 TEdit *edVoltage_nom;
 TEdit *edAmperage_nom;
 TEdit *edVoltage_max;
 TEdit *edAmperage_max;

 TEdit *edCarry;
 TEdit *edAmperage_nom_s;
 TEdit *edVoltage_nom_s;
 TEdit *edZones;
 TEdit *edZone_time_min;
 TEdit *edTerm_control;
 TEdit *edBuffle; 

 TComboBox *cbPhase;
 TComboBox *cbKind_count;
 TComboBox *cbKind_meter;
 TComboBox *cbSchema_inst;
 TComboBox *cbHook_up;

 TWTDBGrid* WTPrecGrid;
 TWTQuery*  qPrec;
 TWTDBGrid* WTEnergyGrid;
 TWTQuery*  qEnergy;

 //код тек. оборудования
  int eqid;

 // Массивы индексов , а также их размеры
  int phaseid_arr[10];
  int hook_upid_arr[10];
  int kind_countid_arr[10];
  int kind_meterid_arr[10];
  int schema_instid_arr[10];

  int phase_no;
  int hook_up_no;
  int kind_count_no;
  int kind_meter_no;
  int schema_inst_no;

  int phaseid;
  int hook_upid;
  int kind_countid;
  int kind_meterid;
  int schema_instid;

  // -- Запрос в списке, из которого вызвана форма(для обновления)
  TZPgSqlQuery *ParentDataSet;
  // Местный Query
  TZPgSqlQuery *ZEqpQuery;
  //-- Режим (вставка/ред)
  int mode;
  //
  int refresh;

  
 __fastcall TfMeterSpr (TComponent* AOwner,AnsiString FName="");
 void __fastcall FormCreate(TObject *Sender);
 void __fastcall FormClose(TObject *Sender, bool &CanClose);
 void __fastcall ShowData(int compid);
 void __fastcall NewPrecClass(TDataSet* DataSet);
 void __fastcall NewEnergyKind(TDataSet* DataSet);
 bool SaveNewData(void);
 bool SaveData(void);
 void __fastcall tbSaveClick(TObject *Sender);
 void __fastcall tbCancelClick(TObject *Sender);
 void __fastcall ShowGrids(void);

 void __fastcall cbSchema_instChange(TObject *Sender);
 void __fastcall cbKind_meterChange(TObject *Sender);
 void __fastcall cbKind_countChange(TObject *Sender);
 void __fastcall cbHook_upChange(TObject *Sender);
 void __fastcall cbPhaseChange(TObject *Sender);

};
//---------------------------------------------------------------------------
extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
