//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include "Main.h"
#include "FSebPlan.h"
#include "ParamsForm.h"
#pragma link "xlcClasses"
#pragma link "xlReport"
#pragma link "ZPgSqlQuery"
#pragma link "ZQuery"
#include "fPeriodSel.h"
//---------------------------------------------------------------------------

#pragma package(smart_init)
AnsiString sqlstr;
TWTDBGrid* WAbonGrid;
TWTWinDBGrid *WPrefGrid;

__fastcall TFSebPlan::TFSebPlan(TComponent* AOwner) : TWTDoc(AOwner)
{
 // ������� ������� ������� ������
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;

  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQSeb->Sql->Clear();
  ZQSeb->Sql->Add(sqlstr);
  try
  {
   ZQSeb->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQSeb->Close();
   delete ZQSeb;
   return;
  }
  ZQSeb->First();
  mmgg = ZQSeb->FieldByName("mmgg")->AsDateTime;
  pmmgg=mmgg;
  ZQSeb->Close();

  TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
 // BtnPrint->OnClick=ClientSebPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;


  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption=" ��������������� ";
  BtnRebuild->OnClick=SebRebuild;
  BtnRebuild->Width=100;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;


  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
   PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";




    TWTPanel* PSeb=MainPanel->InsertPanel(200,true,MainForm->Height/2);
   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;
   Query2->Sql->Clear();

   Query2->Sql->Add("\
  select s.*, \
  round((case when demand_calc<>0 then demand/demand_calc::::numeric*100 else 0 end),2) as dev_obl, \
  round((case when demand_plan<>0 then demand/demand_plan::::numeric*100 else 0 end),2) as dev_res, \
  sn.id_group,sn.name as group_name, sn.sort,\
   c.code as codec, c.short_name as short_name,p.name as name_pref \
  from seb_plan  as s \
    join clm_client_tbl as c on (c.id= s.id_client) \
    join aci_pref_tbl as p on (p.id= s.id_pref)  \
    join ( select s.id_client,s.id_section as id_group,s1.name,s1.sort \
           from clm_statecl_tbl  s \
             left join  cla_param_tbl s1  \
              on (s.id_section=s1.id)   \
         where s.id_section<>206 and s.id_section<>207 ) as sn \
         on (sn.id_client=s.id_client)  where id_pref in (10,20)\
          order by mmgg,id_pref,sort,code; " );

   DBGrSeb=new TWTDBGrid(PSeb, Query2);

   qSebList = DBGrSeb->Query;

   DBGrSeb->SetReadOnly(false);
   PSeb->Params->AddGrid(DBGrSeb, true)->ID="Seb";

  qSebList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");
/*
  WList->Add("id_client");
  WList->Add("id_pref");
  WList->Add("mmgg");
  */
  TStringList *NList=new TStringList();
  NList->Add("short_name");
  NList->Add("name_pref");
   NList->Add("codec");
   NList->Add("group_name");
    NList->Add("sort");\
  NList->Add("dev_obl");
  NList->Add("dev_res");\

     NList->Add("id_group");

  if (Date()<StrToDate("05.08.2006"))

   qSebList->SetSQLModify("seb_plan",WList,NList,true,true,true);
  else
   qSebList->SetSQLModify("seb_plan",WList,NList,true,false,false);
  //qSebList->AfterInsert=CancelInsert;



  TWTField *Fieldh;

  Fieldh = DBGrSeb->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("group_name", "������", "");
  Fieldh->SetWidth(150);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("codec", " ������� ����", "������� ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("short_name", "������� ", "�������");
    Fieldh->SetWidth(200);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("Name_pref", "���", "���");
  Fieldh->SetWidth(20);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("demand", "����������", "");
  Fieldh->SetWidth(80);
  if (Date()>StrToDate("05.09.2006"))
   Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("demand_calc", "���� ���������", "");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("dev_obl", "% ����� ���.", "");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();


  Fieldh = DBGrSeb->AddColumn("demand_plan", "���� ���", "");
 // ((TDBGrid*) (DBGrSeb))->Columns[8]//.Color=0x00caffff;
  DBGrSeb->Columns->Items[8]->Color=0x00caffff;
  Fieldh->SetWidth(80);


  Fieldh = DBGrSeb->AddColumn("dev_res", "% ����� ���.", "");
  Fieldh->SetWidth(80);
  Fieldh->SetReadOnly();


  DBGrSeb->Visible=true;


  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrSeb->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }
   
   }
  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);


 
   qSebList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qSebList->Filtered=true;
   qSebList->Refresh();

   SetCaption("������������ ����������� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

 // Application->CreateForm(__classid(TfRepSebN), &fRepSebN);
 };

//---------------------------------------------------------------------------

void __fastcall TFSebPlan::ClientSebPrint(TObject *Sender)
{

};

//--------------------------------------------------

void __fastcall TFSebPlan::SebRebuild(TObject *Sender)
{

TWTQuery *QuerZap=new TWTQuery(this);
  QuerZap->Sql->Add ("select seb_plan_full(:pmmgg) ");
   QuerZap->ParamByName("pmmgg")->AsDateTime=pmmgg;
    QuerZap->ExecSql();
    QuerZap->Sql->Clear();
    QuerZap->Sql->Add ("select seb_plan_rep(:pmmgg) ");
   QuerZap->ParamByName("pmmgg")->AsDateTime=pmmgg;
    QuerZap->ExecSql();

   delete QuerZap;
   qSebList->Refresh();
 };
//--------------------------------------------------

//--------------------------------------------------
void __fastcall TFSebPlan::AllSebPrint(TObject *Sender)
{
};

//---------------------------------------------------------------------------

void __fastcall TFSebPlan::ShowData(void)
{
 MainPanel->ParamByID("Seb")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TFSebPlan::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TFSebPlan::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

    if (qSebList->FieldByName("mmgg")->AsDateTime != ZeroTime)
        fPeriodSelect->FormShow(qSebList->FieldByName("mmgg")->AsDateTime,qSebList->FieldByName("mmgg")->AsDateTime);
    else
        fPeriodSelect->FormShow(mmgg,mmgg);


    int rez =fPeriodSelect->ShowModal();

    if (rez == mrCancel)
     {
      delete fPeriodSelect;
      return ;
     };

//   delete DBGrSeb;
//   qSebList->Close();
//   qSebList->Open();
/*
   if (rez == mrOk)
   {
     qSebList->ParamByName("startdt")->AsDateTime=fPeriodSelect->DateFrom;
     qSebList->ParamByName("stopdt")->AsDateTime=fPeriodSelect->DateTo;
     qSebList->ParamByName("all")->AsInteger=0;

     SetCaption("��������� ��������� ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     qSebList->ParamByName("all")->AsInteger=1;
     SetCaption("��������� ��������� ");
   }


   try
   {
    qSebList->Open();
   }
   catch(...)
   {
    delete fPeriodSelect;
    return;
   }
*/  pmmgg=fPeriodSelect->DateFrom;
   SebRebuild(Sender);
   if (rez == mrOk)
   {
     qSebList->Filtered=false;
     qSebList->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qSebList->Filtered=true;
     qSebList->Refresh();

     SetCaption("����������� � ������������ ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     //qSebList->Filtered=false;
     qSebList->DefaultFilter="";
     qSebList->Refresh();
     qSebLines->Refresh();
     SetCaption("����������� � ������������ ");
   }

//    delete fPeriodSelect;
//    ReBuildGrid();
};




// $$$$$$$$$$$$$$$$$$$$$$$$$$$$$4
__fastcall TFSebNKRE4::TFSebNKRE4(TComponent* AOwner) : TWTDoc(AOwner)
{
 // ������� ������� ������� ������
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;

  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;

  AnsiString sqlstr="select fun_mmgg() as mmgg ;";
  ZQSeb->Sql->Clear();
  ZQSeb->Sql->Add(sqlstr);
  try
  {
   ZQSeb->Open();
  }
  catch(EDatabaseError &e)
  {
   ShowMessage("������ "+e.Message.SubString(8,200));
   ZQSeb->Close();
   delete ZQSeb;
   return;
  }
  ZQSeb->First();
  mmgg = ZQSeb->FieldByName("mmgg")->AsDateTime;

  ZQSeb->Close();


  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


//  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
//  PBtn->RealHeight=25;
//  PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
//  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
//   PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";

    TWTPanel* PSeb=MainPanel->InsertPanel(200,true,MainForm->Height/2);
   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;
   Query2->Sql->Clear();

   Query2->Sql->Add(" select s.*,p.full_name,p.flag_calc    \
     from sebd_nkre4  as s, sebi_nkre4 as p  where p.id=s.id_nkre4   \
      order by mmgg,code_nkre4; " );

   DBGrSeb=new TWTDBGrid(PSeb, Query2);

   qSebList = DBGrSeb->Query;

   DBGrSeb->SetReadOnly(false);
   PSeb->Params->AddGrid(DBGrSeb, true)->ID="Seb";
   DBGrSeb->OnDrawColumnCell=HeadDrawColumnCell;
     DBGrSeb->BeforeEdit=BefEdit;
  qSebList->Open();

  TStringList *WList=new TStringList();
  WList->Add("code_nkre4");
  WList->Add("id_nkre4");
  WList->Add("mmgg");

  TStringList *NList=new TStringList();
  NList->Add("full_name");
  NList->Add("flag_calc");
  //NList->Add("name_pref");
  // NList->Add("codec");

  qSebList->SetSQLModify("sebd_nkre4",WList,NList,true,false,false);
  qSebList->AfterInsert=CancelInsert;



  TWTField *Fieldh;
  Fieldh = DBGrSeb->AddColumn("mmgg", "�����", "�����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("full_name", "�����������", "�����������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("code_nkre4", "��� ������", "��� ������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("demand", "�������� ������", "�������� ������");
  Fieldh->OnChange=OnChange;
  Fieldh->SetWidth(100);


  Fieldh = DBGrSeb->AddColumn("Summa", "�����", "");
  Fieldh->OnChange=OnChange;
  Fieldh->SetWidth(100);


  DBGrSeb->Visible=true;


  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrSeb->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }

   }
  TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);

    qSebList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",mmgg)+"'";
   qSebList->Filtered=true;
   qSebList->Refresh();

   SetCaption("���������� �  4 ���� ("+ FormatDateTime("mmmm yyyy",mmgg)+ ")");

 };


 void __fastcall TFSebNKRE4::BefEdit(TWTDBGrid *Sender)
{   int cp;
 TWTDBGrid *t=Sender;
 cp =t->DataSource->DataSet->FieldByName("flag_calc")->AsInteger;
 if ( (cp!=0)  )
   {// t->CancelUpdates();


    };
}

void _fastcall  TFSebNKRE4::OnChange(TWTField  *Sender)
{

  int cl;
   cl=Sender->Field->DataSet->FieldByName("flag_calc")->AsInteger;
   if (cl!=0)
   {  ShowMessage("��������� ������ �� �������� ��������������");
      Sender->Field->DataSet->Cancel();
      }
};

void __fastcall TFSebNKRE4::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
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


//--------------------------------------------------

void __fastcall TFSebNKRE4::SebRebuild(TObject *Sender)
{
  TWTQuery *QuerZap=new TWTQuery(this);
  QuerZap->Sql->Add (" \
  insert into sebd_nkre4 (mmgg,id_nkre4,code_nkre4) \
  select :pmmgg as mmgg,id as id_nkre4,code as code_nkre4 \
    from ( select * from sebi_nkre4 where flag_hand=1)  as a  \
         left join                                            \
         (select mmgg, id_nkre4 ,code_nkre4 from sebd_nkre4 where mmgg=:pmmgg) as b \
          on (b.mmgg=:pmmgg and a.id=b.id_nkre4)                             \
         where b.id_nkre4 is null ");

    QuerZap->ParamByName("pmmgg")->AsDateTime=mmgg;
    QuerZap->ExecSql();

   delete QuerZap;
   qSebList->Refresh();
};
//--------------------------------------------------



void __fastcall TFSebNKRE4::ShowData(void)
{
 MainPanel->ParamByID("Seb")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TFSebNKRE4::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TFSebNKRE4::PeriodSel(TObject *Sender)
{

    TfPeriodSelect* fPeriodSelect;
    Application->CreateForm(__classid(TfPeriodSelect), &fPeriodSelect);

    TDateTime ZeroTime;

    if (qSebList->FieldByName("mmgg")->AsDateTime != ZeroTime)
        fPeriodSelect->FormShow(qSebList->FieldByName("mmgg")->AsDateTime,qSebList->FieldByName("mmgg")->AsDateTime);
    else
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
     SebRebuild(NULL);

     qSebList->Filtered=false;
     qSebList->DefaultFilter="mmgg >= '" +FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateFrom)+"' and mmgg <= '"
     + FormatDateTime("yyyy-mm-dd",fPeriodSelect->DateTo)+ "'";
     qSebList->Filtered=true;
     qSebList->Refresh();

     SetCaption("����������� � ������������ ("+ FormatDateTime("dd.mm.yy ",fPeriodSelect->DateFrom)
     +" - "+FormatDateTime("dd.mm.yy ",fPeriodSelect->DateTo)+ ")");
    }
   else
   {
     //qSebList->Filtered=false;
     qSebList->DefaultFilter="";
     qSebList->Refresh();
     qSebLines->Refresh();

     SetCaption("����������� � ������������ ");
   }

//    delete fPeriodSelect;
//    ReBuildGrid();
};





void __fastcall TMainForm::ShowSebList(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������ ������", Owner)) {
    return;
  }
  TFSebPlan * FSebPlan=new TFSebPlan(this);

  FSebPlan->ShowAs("������������ ���");

  FSebPlan->ID="������������ ���";

  FSebPlan->ShowData();
}
void __fastcall TMainForm::ShowNKRE4(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������ ������", Owner)) {
    return;
  }
  TFSebNKRE4 * FSebNKRE4=new TFSebNKRE4(this);

  FSebNKRE4->ShowAs("������������ 4  ����");

  FSebNKRE4->ID="������������ 4  ���� ";

  FSebNKRE4->ShowData();
}

//----------------------------------------------------------------------


__fastcall TFSebiNKRE4::TFSebiNKRE4(TComponent* AOwner) : TWTDoc(AOwner)
{
 // ������� ������� ������� ������
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;

  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;

   ZQSeb->Close();


  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;


    TWTPanel* PSeb=MainPanel->InsertPanel(200,true,MainForm->Height/2);
   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;
   Query2->Sql->Clear();

   Query2->Sql->Add(" select s.*   \
     from sebi_nkre4  as s  \
      order by group_code,code; " );

   DBGrSeb=new TWTDBGrid(PSeb, Query2);

   qSebList = DBGrSeb->Query;

   DBGrSeb->SetReadOnly(false);
   PSeb->Params->AddGrid(DBGrSeb, true)->ID="Seb";

  qSebList->Open();

  TStringList *WList=new TStringList();
  WList->Add("id");

  TStringList *NList=new TStringList();
 // NList->Add("full_name");


  qSebList->SetSQLModify("sebi_nkre4",WList,NList,true,false,false);
  qSebList->AfterInsert=CancelInsert;



  TWTField *Fieldh;

  //Fieldh = DBGrSeb->AddColumn("code", "��� ������", "��� ������");
  //Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("code", "��� ������", "��� ������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("name", "������ � ������", "�����������");
  Fieldh->SetWidth(350);

  Fieldh = DBGrSeb->AddColumn("flag_hand", "����", "����");
  Fieldh->AddFixedVariable("1", "+");
  Fieldh->AddFixedVariable("0"," ");
  Fieldh->SetDefValue("0");                                                  
   Fieldh->SetWidth(60);
  Fieldh = DBGrSeb->AddColumn("flag_calc", "�������", "������");

   Fieldh->SetWidth(60);
  DBGrSeb->Visible=true;

  Fieldh = DBGrSeb->AddColumn("full_name", "�������� ��� �����", "�������� ��� �����");
   Fieldh->SetWidth(350);
  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();
     DBGrSeb->OnDrawColumnCell=HeadDrawColumnCell;
  TWTToolBar* tb=DBGrSeb->ToolBar;
  TWTToolButton* btn;
  for (int i=0;i<=tb->ButtonCount-1;i++)
   {
    btn=(TWTToolButton*)(tb->Buttons[i]);
    if ( btn->ID=="NewRecord")
       {
         tb->Buttons[i]->OnClick=NULL;
       }

   }
   qSebList->Refresh();

   SetCaption("������ ������  4 ���� ");

 };


//--------------------------------------------------



void __fastcall TFSebiNKRE4::ShowData(void)
{
 MainPanel->ParamByID("Seb")->Control->SetFocus();
};

//----------------------------------------------------------------------
void __fastcall TFSebiNKRE4::CancelInsert(TDataSet* DataSet)
{
 DataSet->Cancel();
}

void __fastcall TMainForm::ShowiNKRE4(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������ ������ 4 ����", Owner)) {
    return;
  }
  TFSebiNKRE4 * FSebiNKRE4=new TFSebiNKRE4(this);

  FSebiNKRE4->ShowAs("������ ������ 4  ����");

  FSebiNKRE4->ID="������  ������ 4  ���� ";

  FSebiNKRE4->ShowData();
}

 void __fastcall TFSebiNKRE4::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   int cp,cph;
  TDBGrid* t=(TDBGrid*)Sender;
  cp =t->DataSource->DataSet->FieldByName("flag_calc")->AsInteger;
  cph =t->DataSource->DataSet->FieldByName("flag_hand")->AsInteger;
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
      else
      {  if ( (cp==0) && (cph==1) )
         { t->Canvas->Brush->Color=0x00ccffff;
           t->Canvas->FillRect(Rect);
           t->Canvas->Font->Color=0x00800000;
           t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
         };
      };
    };
}

__fastcall TFSebState::TFSebState(TComponent* AOwner) : TWTDoc(AOwner)
{
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;
  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;

 /* TButton *BtnPrint=new TButton(this);
  BtnPrint->Caption="������";
  BtnPrint->OnClick=SebPrint;
  BtnPrint->Width=100;
  BtnPrint->Top=2;
  BtnPrint->Left=2;
  */

  TButton *BtnRebuild=new TButton(this);
  BtnRebuild->Caption="���������� ������ ";
  BtnRebuild->OnClick=SebRebuild;
  BtnRebuild->Width=180;
  BtnRebuild->Top=2;
  BtnRebuild->Left=400;

  TButton *BtnEmp=new TButton(this);
  BtnEmp->Caption="";
  BtnEmp->Width=100;
  BtnEmp->Top=2;
  BtnEmp->Left=1000;
  TWTPanel* PBtn=MainPanel->InsertPanel(550,25);
  PBtn->RealHeight=25;
 // PBtn->Params->AddButton(BtnPrint,false)->ID="BtnPrn";
  PBtn->Params->AddButton(BtnRebuild,false)->ID="BtnRebuild";
  PBtn->Params->AddButton(BtnEmp,false)->ID="BtnEmp";

   TWTPanel* PSeb=MainPanel->InsertPanel(200,true,MainForm->Height/2);
   TWTQuery *Query2 = new  TWTQuery(this);
   Query2->Options << doQuickOpen;
   Query2->Sql->Clear();

   Query2->Sql->Add(" \
    select c.id,c.code,c.short_name,s.dt_action,s.dt_warning,s.action,s.comment \
    from clm_client_tbl c \
     inner join \
      ( select s.id_client,s.action,s.dt_action,s.dt_warning,s.comment  \
           from clm_switching_tbl s \
        where s.dt_action=( select max(i.dt_action) from clm_switching_tbl i \
                           where i.id_client=s.id_client) \
                           and s.id=( select max(i.id) from clm_switching_tbl i \
                           where i.id_client=s.id_client) \
        ) as s on (c.id=s.id_client)  order by c.code  \
     " );

   DBGrSeb=new TWTDBGrid(PSeb, Query2);
   qSebList = DBGrSeb->Query;
   DBGrSeb->SetReadOnly(false);
   PSeb->Params->AddGrid(DBGrSeb, true)->ID="Seb";
   qSebList->Open();
  TStringList *WList=new TStringList();
  WList->Add("id");
  TStringList *NList=new TStringList();
  NList->Add("short_name");
  qSebList->SetSQLModify("clm_swithing_tbl",WList,NList,false,false,false);
  TWTField *Fieldh;

  Fieldh = DBGrSeb->AddColumn("code", " ������� ����", "������� ����");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("short_name", "������� ", "�������");
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("dt_action", "����", "����");
  Fieldh->SetWidth(100);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("action", "���������", "");
  Fieldh->AddFixedVariable("1", "��������");
  Fieldh->AddFixedVariable("2", "������������");
  Fieldh->AddFixedVariable("3", "���������");
  Fieldh->AddFixedVariable("4", "��������");


  Fieldh->SetWidth(90);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("dt_warning", "������������ �� ", "��");
  Fieldh->SetWidth(120);
  Fieldh->SetReadOnly();

  Fieldh = DBGrSeb->AddColumn("comment", "�����������", "");
  Fieldh->SetWidth(300);
  Fieldh->SetReadOnly();

  DBGrSeb->Visible=true;
    DBGrSeb->OnDrawColumnCell=HeadDrawColumnCell;
  StatusBar = new TStatusBar(this);
  StatusBar->Parent = this;
  StatusBar->SimplePanel=false;
  TStatusPanel* SP=StatusBar->Panels->Add();

  TWTToolBar* tb=DBGrSeb->ToolBar;
  TWTToolButton* btn;
 // TWTToolButton* btAll=tb->AddButton("dateinterval", "����� �������", PeriodSel);

//   qSebList->DefaultFilter="mmgg = '" +FormatDateTime("yyyy-mm-dd",date())+"'";
 //  qSebList->Filtered=true;
   qSebList->Refresh();

   SetCaption("��������� ��������� ("+ FormatDateTime("dd mm yyyy",Date())+ ")");

 // Application->CreateForm(__classid(TfRepSebN), &fRepSebN);
 };

//---------------------------------------------------------------------------

void __fastcall TFSebState::HeadDrawColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   int cp,cph,act;
  TDBGrid* t=(TDBGrid*)Sender;
  TDateTime tdt;
  cp =t->DataSource->DataSet->FieldByName("dt_action")->AsDateTime;
  cph =t->DataSource->DataSet->FieldByName("dt_warning")->AsDateTime;
  act=t->DataSource->DataSet->FieldByName("action")->AsInteger;
  if (act<3)
  {
  if (  cph<=Date() && cph!=tdt)
   {  //  t->Canvas->Brush->Color=0x0000ffd0;
   t->Canvas->Brush->Color=0x00caffff;
        t->Canvas->Font->Size=8;
        //t->Canvas->Font->Style=TFontStyles()<< fsBold;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->FillRect(Rect);
       // t->Canvas->CanvasOrientation=coRightToLeft;
        t->Canvas->Font->Color=clBlack;
        t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
   };
 };
}

void __fastcall TFSebState::SebPrint(TObject *Sender)
{/*

  xlReport->XLSTemplate = "XL\\abon_switch.xls";
  xlReport->Params->Clear();
  Param=xlReport->Params->Add();
  Param->Name="lres";
  Param=xlReport->Params->Add();
  Param->Name="lnow";

  xlReport->ParamByName["lnow"]->Value = FormatDateTime("dd.mm.yy hh:nn",Now());
  xlReport->ParamByName["lres"]->Value = ResName;

   xlReport->Report();
   ZQXLReps->Close();

//  int id_tax=qSebList->FieldByName("id_doc")->AsInteger;
//  fRepSebN->ShowSebNal(id_tax);
   */
};

//--------------------------------------------------

void __fastcall TFSebState::SebRebuild(TObject *Sender)
{

  if (MessageDlg(" �������� ����������� ������ ?", mtConfirmation, TMsgDlgButtons() << mbYes << mbNo, 0) != mrYes)
  {
   return;
  }
  TWTQuery * ZQSeb = new TWTQuery(Application);
  ZQSeb->Options<< doQuickOpen;
  ZQSeb->RequestLive=false;
  ZQSeb->CachedUpdates=false;
//  ZQSeb->Transaction->AutoCommit=false;
   AnsiString sqlstr="select calc_action() ;";
   ZQSeb->Sql->Clear();
   ZQSeb->Sql->Add(sqlstr);

   try
   {
    ZQSeb->ExecSql();
   }
   catch(EDatabaseError &e)
   {
    ShowMessage("������ "+e.Message.SubString(8,200));
//    ZQSeb->Transaction->Rollback();
    ZQSeb->Close();
//    ZQSeb->Transaction->AutoCommit=true;
    delete ZQSeb;
    return;
   }


   qSebList->Refresh();
  // qSebLines->Refresh();
};

void __fastcall TFSebState::ShowData(void)
{
 MainPanel->ParamByID("Seb")->Control->SetFocus();
};

void __fastcall TMainForm::ShowSwitch(TObject *Sender)
{
  TWinControl *Owner = NULL;
  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild("������ ������ 4 ����", Owner)) {
    return;
  }
  TFSebState * FSebState=new TFSebState(this);

  FSebState->ShowAs("�������� � ����������� ���������");

  FSebState->ID="������  ������ 4  ���� ";

  FSebState->ShowData();
}

