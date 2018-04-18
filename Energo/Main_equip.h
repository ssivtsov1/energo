//----------------------------------------------------------------------------
// Классы программы
//----------------------------------------------------------------------------
#ifndef Main_equipH
#define Main_equipH
//----------------------------------------------------------------------------

//-------------------Оборудование -----------------

  void _fastcall ShowEqpTree(TObject *Sender);
  void _fastcall ShowLog(TObject *Sender);

  void _fastcall EqiMatBtn(TObject *Sender);
  void _fastcall EqiMatSpr(TWTField *Sender);
  void _fastcall EqiCoverBtn(TObject *Sender);
  void _fastcall EqiCoverSpr(TWTField *Sender);
  TWTWinDBGrid*  EqiCoverGrid(TWTField *Sender); 
  void _fastcall EqiPhaseBtn(TObject *Sender);
  void _fastcall EqiPhaseSpr(TWTField *Sender);
  void _fastcall EqiEnergyBtn(TObject *Sender);
  void _fastcall EqiEnergySpr(TWTField *Sender);
  void _fastcall EqiVoltageBtn(TObject *Sender);
  void _fastcall EqiVoltageSpr(TWTField *Sender);
  void _fastcall EqiSchemainsBtn(TObject *Sender);
  void _fastcall EqiSchemainsSpr(TWTField *Sender);
  void _fastcall EqiHookupBtn(TObject *Sender);
  void _fastcall EqiHookupSpr(TWTField *Sender);
  void _fastcall EqiSyncBtn(TObject *Sender);
  void _fastcall EqiSyncSpr(TWTField *Sender);
  void _fastcall EqiSwitchsGrBtn(TObject *Sender);
  void _fastcall EqiSwitchsGrSpr(TWTField *Sender);
  void _fastcall EqiMeterBtn(TObject *Sender);
  void _fastcall EqiMeterSpr(TWTField *Sender);
  void _fastcall EqiKindCountBtn(TObject *Sender);
  void _fastcall EqiKindCountSpr(TWTField *Sender);        
  void _fastcall EqiCordeBtn(TObject *Sender);
  void _fastcall EqiPendantBtn(TObject *Sender);
  void _fastcall EqiEarthBtn(TObject *Sender);
  void _fastcall EqiPillarBtn(TObject *Sender);
  void _fastcall EqiSwitchBtn(TObject *Sender);
  void _fastcall EqiFuseBtn(TObject *Sender);
  void _fastcall EqiJackBtn(TObject *Sender);

  void _fastcall ShowEqpList(int kind,AnsiString AddFilds[],AnsiString AddFildsName[],int FildsCount,AnsiString WinName,bool IsInsert=false);
  void _fastcall ShowAreasList(int kind,int client,AnsiString WinName,bool IsInsert=false);
  void _fastcall EqmMeterBtn(TObject *Sender) ;
  void _fastcall EqmLandingBtn(TObject *Sender);
  void _fastcall EqmCompStBtn(TObject *Sender);
  void _fastcall EqmCompIBtn(TObject *Sender) ;
  void _fastcall EqmLineABtn(TObject *Sender) ;
  void _fastcall EqmLineCBtn(TObject *Sender) ;
  void _fastcall EqmFuseBtn(TObject *Sender) ;
  void _fastcall EqmJackBtn(TObject *Sender) ;
  void _fastcall EqmSwitchBtn(TObject *Sender) ;
  void _fastcall EqmCompBtn(TObject *Sender) ;
  void _fastcall EqmConnectBtn(TObject *Sender);
  void _fastcall EqmDESBtn(TObject *Sender) ;  
  void _fastcall EqmPointBtn(TObject *Sender) ;

  void _fastcall EqiCompBtn(TObject *Sender);
  void __fastcall CompAccept (TObject* Sender);
  void __fastcall NewComp(TObject* Sender);
  void _fastcall NewCompGr(TWTDBGrid *Sender);
  void __fastcall CompKeyDown(TObject* Sender, Word &Key, TShiftState Shift);
  void _fastcall EqiCableBtn(TObject *Sender);
  void __fastcall CableAccept (TObject* Sender);
  void __fastcall NewCable(TObject* Sender);
  void _fastcall NewCableGr(TWTDBGrid *Sender);
  void _fastcall EqiAMeterBtn(TObject *Sender);
  void __fastcall MeterAccept (TObject* Sender);
  void __fastcall NewMeter(TObject* Sender);
  void _fastcall NewMeterGr(TWTDBGrid *Sender) ;
  void _fastcall EqiZoneBtn(TObject *Sender);
  void __fastcall CompGridClose(TObject *Sender, bool &CanClose);
  void __fastcall MeterGridClose(TObject *Sender, bool &CanClose);
  void __fastcall CableGridClose(TObject *Sender, bool &CanClose);

  void __fastcall CompIGridClose(TObject *Sender, bool &CanClose);
  void _fastcall EqiCompIBtn(TObject *Sender);
  void __fastcall CompIAccept (TObject* Sender);
  void __fastcall NewCompI(TObject* Sender);
  void _fastcall NewCompIGr(TWTDBGrid *Sender);
  // Функции открытия справочников для выбора
  TWTWinDBGrid* EqiEarthSpr(AnsiString name);
  TWTWinDBGrid* EqiPendantSpr(AnsiString name) ;
  TWTWinDBGrid* EqiPillarSpr(AnsiString name) ;
  TWTWinDBGrid* EqiCordeSpr(AnsiString name) ;
  TWTWinDBGrid* EqiAMeterSpr(AnsiString name) ;
  TWTWinDBGrid* EqiZoneSpr(AnsiString name) ;
  TWTWinDBGrid* EqiSwitchSpr(AnsiString name) ;
  TWTWinDBGrid* EqiFuseSpr(AnsiString name) ;
  TWTWinDBGrid* EqiJackSpr(AnsiString name) ;
  TWTWinDBGrid* EqiCompSpr(AnsiString name) ;
  TWTWinDBGrid* EqiCableSpr(AnsiString name) ;
  TWTWinDBGrid* EqiCompISpr(AnsiString name) ;
  void _fastcall EqiDESBtn(TObject *Sender);
  TWTWinDBGrid* EqiDESSpr(AnsiString name) ;  

  void _fastcall EqkTgBtn(TObject *Sender);
  TWTWinDBGrid* EqkTgSpr(AnsiString name);
  TWTWinDBGrid* EqmAbonConnect(int CodeEqp);
  TWTWinDBGrid* EqmGekConnect(int CodeEqp);
//  void _fastcall EqmTreesBtn(TObject *Sender);

  void _fastcall AfterChange(TZPgSqlQuery* Query,int operation,bool enabled);
  int _fastcall PrepareChange(TZPgSqlQuery* Query,int mode, int treeid,int eqpid,int usrid,bool enabled,TDateTime ChangeDate=0);

  void _fastcall ShowBalansForm(TObject *Sender);
  void _fastcall EqmPrognozBasiks(TObject *Sender);
  void _fastcall RepNDSFizManual(TObject *Sender);

  void _fastcall PeriodSel(TObject *Sender);


//----------------------------------------------------------------------------
#endif
