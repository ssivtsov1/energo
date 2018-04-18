//---------------------------------------------------------------------------

#ifndef fAbonSwH
#define fAbonSwH


#include "ParamsForm.h"
class TfAbonSwitch : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
// TWTDBGrid* DBGrDocLines;
// TWTQuery*  qDocLines;
 TDateTime mmgg;
// TWTPanel* PTax;
 int id_client;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfAbonSwitch(TComponent* AOwner,TDataSet* ZQAbonList);

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
void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
//void __fastcall NewStrInsert(TDataSet* DataSet);
//int abonent;
};

//------------------------------------------------------------
class TfAbonSwitchAll : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
 TDateTime mmgg;
// TWTPanel* PTax;
// int id_client;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 TWTQuery * ZQuery;

 __fastcall TfAbonSwitchAll(TComponent* AOwner);

//void __fastcall TaxDelete(TObject *Sender);
//void __fastcall TaxRebuild(TObject *Sender);
//void __fastcall ClientTaxPrint(TObject *Sender);
//void __fastcall AllTaxPrint(TObject *Sender);
//void __fastcall CancelInsert(TDataSet* DataSet);
void __fastcall PeriodSel(TObject *Sender);
//void __fastcall TaxCorManual(TObject *Sender);
//void __fastcall AbonAccept (TObject* Sender);
//void __fastcall AbonClose(System::TObject* Sender, bool &CanClose);
//void __fastcall PrefAccept (TObject* Sender);

void __fastcall ShowData(void);
void __fastcall NewDocInsert(TDataSet* DataSet);
void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
void __fastcall ValidateAbonCode(TField* Sender);
//void __fastcall NewStrInsert(TDataSet* DataSet);
//int abonent;
};


//---------------------------------------------------------------------------

#endif
