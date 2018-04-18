//---------------------------------------------------------------------------

#ifndef fDemLimitH
#define fDemLimitH

#include "Main.h"
#include "ParamsForm.h"
class TfDemandLimit : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
 TWTDBGrid* DBGrDocLines;
 TWTQuery*  qDocLines;
 TDateTime mmgg;
// TWTPanel* PTax;
 int id_client;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfDemandLimit(TComponent* AOwner,TDataSet* ZQAbonList);

/*
void __fastcall TaxDelete(TObject *Sender);
//void __fastcall TaxRebuild(TObject *Sender);
void __fastcall ClientTaxPrint(TObject *Sender);
void __fastcall AllTaxPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall TaxCorManual(TObject *Sender);
void __fastcall AbonAccept (TObject* Sender);
void __fastcall AbonClose(System::TObject* Sender, bool &CanClose);
void __fastcall PrefAccept (TObject* Sender);
*/
void __fastcall ShowData(void);
void __fastcall NewDocInsert(TDataSet* DataSet);
void __fastcall NewStrInsert(TDataSet* DataSet);
void __fastcall LimitIns(TObject *Sender);
void __fastcall AutoFill(TObject *Sender);

void __fastcall NewStrError (TDataSet* DataSet, EDatabaseError* E, TDataAction &Action);


//int abonent;
};


//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
