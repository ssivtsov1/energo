//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "FWorkPlan.h"
#include "ParamsForm.h"
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#include "fPeriodSel.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;
TWTWinDBGrid *WFiderGrid;


__fastcall TfWorkPlan::TfWorkPlan(TComponent* AOwner, int id_fider) : TWTDoc(AOwner)
{

 FiderId =id_fider;
 // получим текущий рабочий период
  ZQWork = new TWTQuery(Application);
  ZQWork->Options<< doQuickOpen;

  ZQWork->RequestLive=false;
  ZQWork->CachedUpdates=false;

  sqlstr="select fun_mmgg() as mmgg ;";
  ZQWork->Sql->Clear();
  ZQWork->Sql->Add(sqlstr);
  try
  {
   ZQWork->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка "+e.Message.SubString(8,200));
   ZQWork->Close();
   delete ZQWork;
   return;
  }
  ZQWork->First();
  mmgg = ZQWork->FieldByName("mmgg")->AsDateTime;

  ZQWork->Close();

  PlanRebuild(this);

  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;

  edFiderName=(TEdit*)(PBtn->Params->AddSimple("Фидер ",150,"")->Control);

  TButton *BtnFiderSel =new TButton(this);
  BtnFiderSel->Caption="Выбор";
  BtnFiderSel->OnClick=sbFiderClick;
  BtnFiderSel->Width=100;
  BtnFiderSel->Top=2;
  BtnFiderSel->Left=2;

  PBtn->Params->AddButton(BtnFiderSel,false)->ID="BtnFiderSel";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";

  if (FiderId!=0)
  {
   sqlstr="select name_eqp::::varchar from eqm_equipment_tbl where id = :id ;";
   ZQWork->Sql->Clear();
   ZQWork->Sql->Add(sqlstr);
   ZQWork->ParamByName("id")->AsInteger = FiderId;

   try
   {
    ZQWork->Open();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("Ошибка "+e.Message.SubString(8,200));
    ZQWork->Close();
    delete ZQWork;
    return;
   }

   ZQWork->First();
   edFiderName->Text = ZQWork->FieldByName("name_eqp")->AsString;

   ZQWork->Close();
  }
  

  TWTPanel* PSeb=MainPanel->InsertPanel(200,true,MainForm->Height/2);
  TWTQuery *Query2 = new  TWTQuery(this);
  Query2->Options << doQuickOpen;
  Query2->Sql->Clear();

  Query2->Sql->Add(" select p.*,i.name as type, eq.name_eqp as fidername    \
     from mnm_plan_works_tbl as p \
     join mni_planworks_tbl as i on (i.id = p.id_type) \
     join eqm_equipment_tbl as eq on (eq.id = p.id_fider) \
      order by mmgg,id_type ;" );

//     where p.mmgg= :mmgg  and p.id_fider = :fider

//   Query2->ParamByName("mmgg")->AsDateTime = mmgg;
//   Query2->ParamByName("fider")->AsInteger = FiderId;

  Query2->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and id_fider = "+IntToStr(FiderId);
  Query2->Filtered=true;
//  qWorkPlan->Refresh();


   Query2->Open();

   DBGrPlan=new TWTDBGrid(PSeb, Query2);

   qWorkPlan = DBGrPlan->Query;

   DBGrPlan->SetReadOnly(false);
   PSeb->Params->AddGrid(DBGrPlan, true)->ID="Plan";
//   DBGrPlan->OnDrawColumnCell=HeadDrawColumnCell;
//   DBGrPlan->BeforeEdit=BefEdit;
   qWorkPlan->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("fidername");
  NList->Add("type");

  qWorkPlan->SetSQLModify("mnm_plan_works_tbl",WList,NList,true,false,false);
  qWorkPlan->AfterInsert=CancelInsert;


//  TWTField *Fieldh;
  Field1 = DBGrPlan->AddColumn("mmgg", "Месяц", "Месяц");
  Field1->SetReadOnly();

  Field2 = DBGrPlan->AddColumn("fidername", "Фидер", "Фидер");
  Field2->SetReadOnly();

  Field3 = DBGrPlan->AddColumn("type", "Работа", "Работа");
  Field3->SetReadOnly();

  Field4 = DBGrPlan->AddColumn("cnt", "Плановый объем", "Плановый объем");
//  Fieldh->OnChange=OnChange;
  Field4->SetWidth(100);

  DBGrPlan->Visible=true;


  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrPlan->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }

   }
  TWTToolButton* btAll=tb->AddButton("dateinterval", "Выбор периода", PeriodSel);

  SetCaption(" План работ ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

 };

/*
 void __fastcall TfWorkPlan::BefEdit(TWTDBGrid *Sender)
{   int cp;
 TWTDBGrid *t=Sender;
 cp =t->DataSource->DataSet->FieldByName("flag_calc")->AsInteger;
 if ( (cp!=0)  )
   {// t->CancelUpdates();


    };
}
*/
/*
void _fastcall  TfWorkPlan::OnChange(TWTField  *Sender)
{

  int cl;
   cl=Sender->Field->DataSet->FieldByName("flag_calc")->AsInteger;
   if (cl!=0)
   {  ShowMessage("Расчетные данные не подлежат редактированию");
      Sender->Field->DataSet->Cancel();
      }
};
*/
/*
void __fastcall TfWorkPlan::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   int cp;


 TDBGrid* t=(TDBGrid*)Sender;
 cp =t->DataSource->DataSet->FieldByName("flag_calc")->AsInteger;
    if ( (cp==1)  )
   {    t->Canvas->Brush->Color=0x00eee000;
        t->Canvas->Font->Size=10;
        t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
   }
   else
   { if ( (cp==2) )
      {
    t->Canvas->Brush->Color=0x00ddff00;
    t->Canvas->FillRect(Rect);
    t->Canvas->Font->Size=8;
     t->Canvas->Font->Style=TFontStyles()<< fsBold;
    t->Canvas->Font->Color=clBlack;
    t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
      }
    };
}
*/

//--------------------------------------------------

void __fastcall TfWorkPlan::PlanRebuild(TObject *Sender)
{
  ZQWork->Sql->Clear();

  ZQWork->Sql->Add (" \
        insert into mnm_plan_works_tbl (id_fider, id_type, mmgg ) \
        select ss.id_fider, ss.id_work, :pmmgg::::date from \
        (select i.id as id_work, eq.id as id_fider from mni_planworks_tbl as i, eqm_equipment_tbl as eq where eq.type_eqp = 15 order by i.id, eq.id) as ss \
        left join mnm_plan_works_tbl as p on (p.id_fider = ss.id_fider and p.id_type = ss.id_work and p.mmgg = :pmmgg::::date ) \
        where p.id is null; ");

    ZQWork->ParamByName("pmmgg")->AsDateTime=mmgg;
    ZQWork->ExecSql();

//   qWorkPlan->Refresh();
};
//--------------------------------------------------



void __fastcall TfWorkPlan::ShowData(void)
{
 MainPanel->ParamByID("Plan")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfWorkPlan::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TfWorkPlan::PeriodSel(TObject *Sender)
{

   TfPeriodSelect* fPeriodSelect;
   Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

   TDateTime ZeroTime;

   fPeriodSelect->FormShow(mmgg,mmgg);

   int rez =fPeriodSelect->ShowModal();

   if (rez == mrCancel)
   {
     delete fPeriodSelect;
     return ;
   };

   if (rez == mrOk)
   {
    mmgg=fPeriodSelect->DateFrom;

    PlanRebuild(NULL);
/*
    qWorkPlan->Close();
    qWorkPlan->ParamByName("mmgg")->AsDateTime = mmgg;
    qWorkPlan->ParamByName("fider")->AsInteger = FiderId;
    qWorkPlan->Open();

    Field1->Column->Title->Caption="Месяц";
    Field2->Column->Title->Caption="Фидер";
    Field3->Column->Title->Caption="Работа";
    Field4->Column->Title->Caption="Плановый объем";
*/
    //qWorkPlan->Filtered=false;
    qWorkPlan->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and id_fider = "+IntToStr(FiderId);

    qWorkPlan->Filtered=true;
    qWorkPlan->Refresh();

    SetCaption(" План работ ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");
    }

};

//---------------------------------------------------------------------------
void __fastcall TfWorkPlan::sbFiderClick(TObject *Sender)
{
  TWTQuery *QueryAdr;
  QueryAdr = new  TWTQuery(this);
  TZDatasetOptions Options;
  Options=QueryAdr->Options;
  Options << doQuickOpen;
  QueryAdr->Options=Options;

  QueryAdr->Sql->Clear();

  QueryAdr->Sql->Add("select eq.id, eq.name_eqp from eqm_equipment_tbl as eq where eq.type_eqp = 15  order by eq.name_eqp; ");

  WFiderGrid = new TWTWinDBGrid(this, QueryAdr,false);
  WFiderGrid->SetCaption("Фидера");

  TWTQuery* Query = WFiderGrid->DBGrid->Query;

  Query->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
  NList->Add("id");

  QueryAdr->SetSQLModify("eqm_equipment_tbl",WList,NList,false,false,false);
  TWTField *Field;

  Field = WFiderGrid->AddColumn("name_eqp", "Наименование", "Наименование");

  WFiderGrid->DBGrid->FieldSource = WFiderGrid->DBGrid->Query->GetTField("id");

  WFiderGrid->DBGrid->StringDest = "-1";
  WFiderGrid->DBGrid->OnAccept=PlaceAccept;
  WFiderGrid->DBGrid->Visible = true;
  WFiderGrid->DBGrid->ReadOnly=true;
  WFiderGrid->ShowAs("Выбор фидера");

}
//---------------------------------------------------------------------------

void __fastcall TfWorkPlan::PlaceAccept (TObject* Sender)
{
   FiderId =WFiderGrid->DBGrid->Query->FieldByName("id")->AsInteger;
   edFiderName->Text =WFiderGrid->DBGrid->Query->FieldByName("name_eqp")->AsString;

/*
   qWorkPlan->Close();
   qWorkPlan->ParamByName("mmgg")->AsDateTime = mmgg;
   qWorkPlan->ParamByName("fider")->AsInteger = FiderId;
   qWorkPlan->Open();

   Field1->Column->Title->Caption="Месяц";
   Field2->Column->Title->Caption="Фидер";
   Field3->Column->Title->Caption="Работа";
   Field4->Column->Title->Caption="Плановый объем";
*/

//   qWorkPlan->Filtered=false;
   qWorkPlan->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"' and id_fider = "+IntToStr(FiderId);

   qWorkPlan->Filtered=true;
   qWorkPlan->Refresh();

}
//==============================================================================

void __fastcall TMainForm::ShowWorkPlan(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild("План работ", Owner)) {
    return;
  }

  TfWorkPlan * fWorkPlan=new TfWorkPlan(this,0);

  fWorkPlan->ShowAs("План работ");

  fWorkPlan->ID="План работ";

  fWorkPlan->ShowData();

}
//--------------------------------------------------------------
