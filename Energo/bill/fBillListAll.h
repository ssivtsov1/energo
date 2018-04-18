//---------------------------------------------------------------------------

#ifndef fBillListAllH
#define fBillListAllH


#include "ParamsForm.h"
class TfBillListFull : public TWTDoc
{
public:

 TWTDBGrid* DBGrBill;
 TWTQuery*  qBillList;

 TDateTime mmgg;
// TWTPanel* PTax;

 TZPgSqlQuery *ParentDataSet;

 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfBillListFull(TComponent* AOwner);
// void __fastcall FormCreate(TObject *Sender);
// void __fastcall FormClose(TObject *Sender, bool &CanClose);
// void __fastcall ShowData(int compid);

//void __fastcall TaxDelete(TObject *Sender);
//void __fastcall TaxRebuild(TObject *Sender);
void __fastcall ClientBillPrint(TObject *Sender);
//void __fastcall AllTaxPrint(TObject *Sender);
void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
void __fastcall ShowData(void);
//void __fastcall TaxDeleteAll(TObject *Sender);
//void __fastcall ReBuildGrid(void);
};


//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
