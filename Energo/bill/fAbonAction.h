//---------------------------------------------------------------------------

#ifndef fAbonActH
#define fAbonActH


#include "ParamsForm.h"
class TfAbonAction : public TWTDoc
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

 __fastcall TfAbonAction(TComponent* AOwner,TDataSet* ZQAbonList);


void __fastcall ShowData(void);
void __fastcall NewDocInsert(TDataSet* DataSet);
void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
//void __fastcall NewStrInsert(TDataSet* DataSet);
//int abonent;
};

//------------------------------------------------------------
class TfAbonActionAll : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
 TDateTime mmgg;


 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 TWTQuery * ZQuery;

 __fastcall TfAbonActionAll(TComponent* AOwner);


void __fastcall PeriodSel(TObject *Sender);

void __fastcall ShowData(void);
void __fastcall NewDocInsert(TDataSet* DataSet);
void __fastcall ValidateDate(TField* Sender, const AnsiString Text);
void __fastcall ValidateAbonCode(TField* Sender);
void __fastcall RebuildOpl(TObject *Sender);
//void __fastcall NewStrInsert(TDataSet* DataSet);
//int abonent;
};


//---------------------------------------------------------------------------

#endif
