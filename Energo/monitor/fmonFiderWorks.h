//---------------------------------------------------------------------------

#ifndef fMonWorksH
#define fMonWorksH


#include "ParamsForm.h"
class TfMonitorFiderWorks : public TWTDoc
{
public:

 TWTDBGrid* DBGrDoc;
 TWTQuery*  qDocList;
 TDateTime mmgg;
 int id_fider;
 AnsiString fidername;

 TZPgSqlQuery *ParentDataSet;
 TZPgSqlQuery *ZEqpQuery;

 __fastcall TfMonitorFiderWorks(TComponent* AOwner, int id =0);

 void __fastcall ShowData(void);
 void __fastcall NewDocInsert(TDataSet* DataSet);
 void _fastcall  WorkNewGr(TWTDBGrid *Sender) ;
 void __fastcall WorkNew(TObject* Sender) ;
 void __fastcall SwitchEdit (TObject* Sender) ;
 void __fastcall CancelInsert(TDataSet* DataSet);
 void __fastcall PeriodSel(TObject *Sender);
 void __fastcall PrintList(TObject *Sender);
 TDateTime DateFrom;
 TDateTime DateTo;
};

//---------------------------------------------------------------------------
//extern PACKAGE TWTWinDBGrid *WMeterGrid;
#endif
