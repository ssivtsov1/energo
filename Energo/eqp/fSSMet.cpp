//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "fSSMet.h"
#include "ParamsForm.h"
#include "fPeriodSel.h"
#include "IcXMLParser.hpp"
#include "SysUser.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
#pragma link "IcXMLParser"

AnsiString sqlstr;
TWTDBGrid* WAbonGrid;
TWTWinDBGrid *WPrefGrid;

__fastcall TfSSMetList::~TfSSMetList(void)
{
};
//------------------------------------------------------------
__fastcall TfSSMetList::TfSSMetList(TComponent* AOwner) : TWTDoc(AOwner)
{

  bool read_only =false;
/*
  Name = "MetListFull";

  if(CheckLevelStrong("Журнал налоговых накладных-редактирование")!=0)
  {
    read_only=false;
  }
*/

 // получим иекущий рабочий период
  TWTQuery * ZQMet = new TWTQuery(Application);
  ZQMet->Options<< doQuickOpen;

  ZQMet->RequestLive=false;
  ZQMet->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQMet->Sql->Clear();
  ZQMet->Sql->Add(sqlstr);

  try
  {
   ZQMet->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("Ошибка "+e.Message.SubString(8,200));
   ZQMet->Close();
   delete ZQMet;
   return;
  }
  ZQMet->First();
  mmgg = ZQMet->FieldByName("mmgg")->AsDateTime;

  ZQMet->Close();
/*
  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="Печать";
  BtnPrint->OnClick=ClientMetPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;

  BtnPrintAll=new TButton(this);
  BtnPrintAll->Caption="Печать все";
  BtnPrintAll->OnClick=AllMetPrint;
  BtnPrintAll->Width=100;
  BtnPrintAll->Top=2;
  BtnPrintAll->Left=200;

  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption=" Переформировать ";
  BtnRebuild->OnClick=MetRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;
  BtnRebuild->Enabled= !read_only;

  TButton *BtnDel=new TButton(this);
  BtnDel->Caption=" Удалить ";
  BtnDel->OnClick=MetDelete;
  BtnDel->Width=100;
  BtnDel->Top=2;
  BtnDel->Left=600;
  BtnDel->Enabled= !read_only;

  TButton *BtnDelAll=new TButton(this);
  BtnDelAll->Caption=" Удалить месяц ";
  BtnDelAll->OnClick=MetDeleteAll;
  BtnDelAll->Width=100;
  BtnDelAll->Top=2;
  BtnDelAll->Left=800;
  BtnDelAll->Enabled= !read_only;

  TButton *BtnRebuildFiz=new TButton(this);
  BtnRebuildFiz->Caption=" Переформировать население";
  BtnRebuildFiz->OnClick=MetFizRebuild;
  BtnRebuildFiz->Width=160;
  BtnRebuildFiz->Top=2;
  BtnRebuildFiz->Left=1000;
  BtnRebuildFiz->Enabled= !read_only;

  TButton *BtnRebuildLgt=new TButton(this);
  BtnRebuildLgt->Caption=" Переформировать льготы";
  BtnRebuildLgt->OnClick=MetLgtRebuild;
  BtnRebuildLgt->Width=160;
  BtnRebuildLgt->Top=2;
  BtnRebuildLgt->Left=1200;
  BtnRebuildLgt->Enabled= !read_only;

  TButton *BtnXML=new TButton(this);
  BtnXML->Caption=" в XML";
  BtnXML->OnClick=MetToXML;
  BtnXML->Width=100;
  BtnXML->Top=2;
  BtnXML->Left=1400;
  BtnXML->Enabled=true;

  TButton *BtnXMLAll=new TButton(this);
  BtnXMLAll->Caption=" в XML все";
  BtnXMLAll->OnClick=MetToXMLAll;
  BtnXMLAll->Width=100;
  BtnXMLAll->Top=2;
  BtnXMLAll->Left=1600;
  BtnXMLAll->Enabled=true;

  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1400;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnPrintAll,false)->ID="BtnPrnAll";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
  PBtn->Params->AddButton(BtnDel,false)->ID="BtnDel";
  PBtn->Params->AddButton(BtnDelAll,false)->ID="BtnDelAll";
  PBtn->Params->AddButton(BtnRebuildFiz,false)->ID="BtnRebuildFiz";
  PBtn->Params->AddButton(BtnRebuildLgt,false)->ID="BtnRebuildLgt";
  PBtn->Params->AddButton(BtnXML,false)->ID="BtnXML";
  PBtn->Params->AddButton(BtnXMLAll,false)->ID="BtnXMLAll";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";
  */

    TWTPanel* PMet=MainPanel->InsertPanel(200,true,MainForm->Height/2);
//  TWTPanel* PMet=MainPanel->InsertPanel(200,200);
 /*
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PMet->Params->AddText("Налоговые накладные",18,F,Classes::taCenter,false);
   */

   TWTQuery *Query2 = new  TWTQuery(this);


   Query2->Sql->Clear();
   Query2->Sql->Add(" select m.id as link , m.z_num, m.met_type, m.dt_control, m.zav_sk, im.type ,im.id as id_type, im.carry, i.* \
        from ss_met as m \
        left join eqi_meter_tbl as im on (im.id = m.met_type) \
        left join ( \
            select distinct m.id_type_eqp, eq.num_eqp, c.code, c.short_name as name, eq.dt_install, \
                   trim(regexp_replace(trim(eq.num_eqp),'(\\\\.|,|-|_)$',''))::::varchar as num_trim \
            from eqm_tree_tbl as tr \
            join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree) \
            join eqm_equipment_tbl as eq on (ttr.code_eqp = eq.id) \
            join eqm_meter_tbl as m on (ttr.code_eqp = m.code_eqp) \
            left join  eqm_eqp_use_tbl as use on (use.code_eqp = m.code_eqp) \
            left join clm_client_tbl as c on (c.id = coalesce (use.id_client, tr.id_client)) \
        ) as i on (i.num_trim = m.z_num and m.met_type = i.id_type_eqp ) \
        order by z_num; " );

   DBGrMet=new TWTDBGrid(PMet, Query2);

   qMetList = DBGrMet->Query;

   DBGrMet->SetReadOnly(false);
   PMet->Params->AddGrid(DBGrMet, true)->ID="Met";

  if(read_only)
  {
     DBGrMet->SetReadOnly(true);
  }

  qMetList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();

  qMetList->SetSQLModify("ss_met",WList,NList,false,false,false);

  TWTField *Fieldh;

  Fieldh = DBGrMet->AddColumn("z_num", "№ учета", "№ учета");
  Fieldh->SetWidth(100);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("type", "Тип", "Тип");
  Fieldh->SetWidth(100);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("carry", "Разр.", "Разрядность");
  Fieldh->SetWidth(50);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("id_type", "Код типа", "Код типа");
  Fieldh->SetWidth(50);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("dt_control", "Дата поверки", "Дата поверки");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("code", "Код абон.", "Код абон.");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("name", "Абонент", "Абонент");
  Fieldh->SetWidth(200);
  Fieldh->SetReadOnly();

  Fieldh = DBGrMet->AddColumn("dt_install", "Дата установки", "Дата установки");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();


  DBGrMet->Visible=true;

//----------------------------------------------------------------------------

  TWTPanel* PMetLines=MainPanel->InsertPanel(200,true,200);
//  TWTPanel* PMet=MainPanel->InsertPanel(200,200);
 /*
    TFont *F;
    F=new TFont();
    F ->Size=10;
    F->Style=F->Style << fsBold;
    F->Color=clBlue;
    PMet->Params->AddText("Налоговые накладные",18,F,Classes::taCenter,false);
   */

   TWTQuery *Query3 = new  TWTQuery(this);
   Query3->Options << doQuickOpen;

   Query3->Sql->Clear();
   Query3->Sql->Add("select p.id, p.z_num, p.dt_pokaz,p.val_pokaz, ke.name as energy, kz.name as zone, p.state_met as link  \
         from ss_pok as p \
           join eqk_energy_tbl as ke on (ke.id = p.kind_energy ) \
           join eqk_zone_tbl as kz on (kz.id = p.id_zone ); " );

   DBGrMetLines=new TWTDBGrid(PMetLines, Query3);

   qMetLines = DBGrMetLines->Query;

   DBGrMetLines->SetReadOnly(false);
   PMetLines->Params->AddGrid(DBGrMetLines, true)->ID="MetLines";

   if(read_only)
   {
     DBGrMetLines->SetReadOnly(true);
   }

  qMetLines->Open();

  WList=new TStringList();
  WList->Add("id");

  NList=new TStringList();


  qMetLines->SetSQLModify("ss_pok",WList,NList,false,false,false);
  qMetLines->AfterInsert=CancelInsert;

  qMetLines->IndexFieldNames = "z_num";
  qMetLines->LinkFields = "link = link";
  qMetLines->MasterSource = DBGrMet->DataSource;

 // TWTField *Fieldh;
  Fieldh = DBGrMetLines->AddColumn("energy", "Вид енергии", "");
  Fieldh->SetReadOnly();

  Fieldh = DBGrMetLines->AddColumn("zone", "Зона", "");
  Fieldh->SetReadOnly();

  Fieldh = DBGrMetLines->AddColumn("val_pokaz", "Показания", "");
  Fieldh->SetReadOnly();

  Fieldh = DBGrMetLines->AddColumn("dt_pokaz", "Дата показаний", "");
  Fieldh->SetReadOnly();

  DBGrMetLines->Visible=true;


//----------------------------------------------------------------------------
 // SetCaption("Налоговые накладные ");
//  DocMet->ShowAs("CliMet");
//  MainPanel->ParamByID("Met")->Control->SetFocus();

  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrMet->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
//    if ( btn->ID=="Full")
//       tb->Buttons[i]->OnClick=EqpAccept;
    if ( btn->ID=="NewRecord")
       {
//       if (IsInsert)
//         tb->Buttons[i]->OnClick=NewEqp;
//       else
         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
     {
//        OldDelEqp=tb->Buttons[i]->OnClick;
//        tb->Buttons[i]->OnClick=MetDelete;
       tb->Buttons[i]->OnClick=NULL;
     }
   }
  //TWTToolButton* btAll=tb->AddButton("equal", "Выбор периода", PeriodSel);
//  TWTToolButton* btAll=tb->AddButton("dateinterval", "Выбор периода", PeriodSel);


  tb=DBGrMetLines->ToolBar;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }
    if ( btn->ID=="DelRecord")
       {
//        tb->Buttons[i]->OnClick=MetDelete;
         tb->Buttons[i]->OnClick=NULL;
       }
   }
/*
   qMetList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qMetList->Filtered=true;
   qMetList->Refresh();
*/
   SetCaption("Счетчики доступные для установки");


 };

//---------------------------------------------------------------------------

void __fastcall TfSSMetList::ShowData(void)
{
 MainPanel->ParamByID("Met")->Control->SetFocus();
 MainPanel->ParamByID("MetLines")->Control->SetFocus();
 MainPanel->ParamByID("Met")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TfSSMetList::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}

//----------------------------------------------------------------------
void __fastcall TfSSMetList::PostError(TDataSet *DataSet,
      EDatabaseError *E, TDataAction &Action)
{
    ShowMessage("Ошибка "+E->Message.SubString(8,200));
    Action = daAbort;
}

//----------------------------------------------------------------------

void __fastcall TMainForm::ShowSSMet(TObject *Sender)
{
  TWinControl *Owner = NULL;

  // Если такое окно есть - активизируем и выходим
  if (((TMainForm*)(Application->MainForm))->ShowMDIChild("Счетчики доступные для установки", Owner)) {
    return;
  }

  TfSSMetList * fSSMetList=new TfSSMetList(Application);

  fSSMetList->ShowAs("Счетчики доступные для установки");

  fSSMetList->ID="Счетчики доступные для установки";

  fSSMetList->ShowData();

}
//----------------------------------------------------------

