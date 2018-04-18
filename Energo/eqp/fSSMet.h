//---------------------------------------------------------------------------

#ifndef fSSMetH
#define fSSMetH


#include "ParamsForm.h"

class TfSSMetList : public TWTDoc
{
public:

 TWTDBGrid* DBGrMet;
 TWTQuery*  qMetList;
 TWTDBGrid* DBGrMetLines;
 TWTQuery*  qMetLines;
 TDateTime mmgg;
// TWTPanel* PMet;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;


 __fastcall TfSSMetList(TComponent* AOwner);
 __fastcall ~TfSSMetList(void);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

//void __fastcall MetDelete(TObject *Sender);
//void __fastcall MetRebuild(TObject *Sender);
//void __fastcall MetFizRebuild(TObject *Sender);
//void __fastcall MetLgtRebuild(TObject *Sender);
//void __fastcall ClientMetPrint(TObject *Sender);
//void __fastcall AllMetPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
//void __fastcall PeriodSel(TObject *Sender);
void __fastcall ShowData(void);
//void __fastcall MetDeleteAll(TObject *Sender);
//void __fastcall MetToXML(TObject *Sender);
//void __fastcall MetToXMLAll(TObject *Sender);
//int BuildXML(int id_Met);

AnsiString xmlfilename;

void __fastcall PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action);

//TButton *BtnPrintAll;      
//void __fastcall ReBuildGrid(void);
};


//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
