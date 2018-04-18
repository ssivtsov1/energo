//---------------------------------------------------------------------------

#ifndef fTaxListAllH
#define fTaxListAllH


#include "ParamsForm.h"
#include "fTaxPrint.h"
#include "fTaxCorPrint.h"

class TfTaxListFull : public TWTDoc
{
public:

 TWTDBGrid* DBGrTax;
 TWTQuery*  qTaxList;
 TWTDBGrid* DBGrTaxLines;
 TWTQuery*  qTaxLines;
 TDateTime mmgg;
// TWTPanel* PTax;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;

 TfTaxPrintPrnt *fRepTaxNLocal;
 TfTaxCorPrintPrnt *fRepTaxCorLocal;

 __fastcall TfTaxListFull(TComponent* AOwner);
 __fastcall ~TfTaxListFull(void);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

void __fastcall TaxDelete(TObject *Sender);
void __fastcall TaxRebuild(TObject *Sender);
void __fastcall TaxFizRebuild(TObject *Sender);
void __fastcall TaxLgtRebuild(TObject *Sender);
void __fastcall ClientTaxPrint(TObject *Sender);
void __fastcall AllTaxPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall AfterCancelRefresh(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall TaxAllList(TObject *Sender);
void __fastcall TaxRealList(TObject *Sender);
void __fastcall ShowData(void);
void __fastcall TaxDeleteAll(TObject *Sender);
void __fastcall TaxToXML(TObject *Sender);
void __fastcall TaxToXMLAll(TObject *Sender);
void __fastcall DrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State);
int BuildXML(int id_tax);
int BuildXML2016(int id_tax);
AnsiString xmlfilename;

void __fastcall PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action);

TButton *BtnPrintAll;
int listMode ;
//void __fastcall ReBuildGrid(void);
};

//Журнал корректировок
class TfTaxCorListFull : public TWTDoc
{
public:

 TWTDBGrid* DBGrTax;
 TWTQuery*  qTaxList;
 TWTDBGrid* DBGrTaxLines;
 TWTQuery*  qTaxLines;
 TDateTime mmgg;
// TWTPanel* PTax;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;

 TfTaxCorPrintPrnt *fRepTaxCorLocal;

 __fastcall  TfTaxCorListFull(TComponent* AOwner);
 __fastcall ~TfTaxCorListFull(void);

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
void __fastcall ShowData(void);
void __fastcall NewCorStrInsert(TDataSet* DataSet);
void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
void __fastcall TaxAllList(TObject *Sender);
void __fastcall TaxRealList(TObject *Sender);

void __fastcall PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action);

void __fastcall TaxCorToXML(TObject *Sender);
void __fastcall TaxCorToXMLAll(TObject *Sender);
void __fastcall TaxToXML(TObject *Sender);
int BuildXML(int id_tax);
int BuildXML2016(int id_tax);
int abonent;
int listMode ;
AnsiString xmlfilename;

TButton *BtnPrintAll;
};


//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
