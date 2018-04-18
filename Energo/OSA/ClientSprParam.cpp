//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Main.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------

 // ------------------------------------------------------------------------------
#define WinName "���������� ���������� "
void _fastcall TMainForm::ClmSprParMBtn(TObject *Sender)
 {
  ClmSprParMSpr(NULL);
}

void _fastcall TMainForm::ClmSprParMSpr(TWTField *Sender)
{
 ClmSprParMSel(Sender,NULL,"~g");
}

TWTDBGrid* _fastcall TMainForm::ClmSprParMSel(TWTField *Sender,AnsiString StringSel,AnsiString par) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTDoc *DocClmPar=new TWTDoc(this,"Reports\\ClmPar.dof");

  TWTDBGrid* DBGrGroup=new TWTDBGrid(DocClmPar, "cla_param_tbl");
  TWTPanel* PGroup=DocClmPar->MainPanel->InsertPanel(300,true,100);
  TFont* F=new TFont();
  F->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PGroup->Params->AddText("������ ����������",10,F,Classes::taCenter,true)->ID="NameGr";
  PGroup->Params->AddGrid(DBGrGroup,true)->ID="Group";
   TFilterOptions Opts;
    Opts.Clear();
      DBGrGroup->Table->Filtered=false;
    //Opts=Opts <<foCaseInsensitive;
    //Opts=Opts << foNoPartialCompare ;
    DBGrGroup->Table->FilterOptions=Opts;
  DBGrGroup->Table->Filter="key_name >='"+par+"'";

  DBGrGroup->Table->Filtered=true;
  DBGrGroup->Table->Open();
  DBGrGroup->Table->IndexFieldNames="NAME";
  TDataSource *DataSource=DBGrGroup->DataSource;
    DBGrGroup->OnExit=ExitParamsGrid;
  //DBGrDomain->ReadOnly=true;
  TWTField *Field;
  Field = DBGrGroup->AddColumn("NAME", "������ ����������", "������������ ������");
  Field->SetWidth(100);
  //Field->SetUnique("������ ������������ � �����������","Cla_param_tbl","name");
  Field->SetRequired("������������  ������ ���� ���������");

    Field = DBGrGroup->AddColumn("key_name", "�������", "�������");
    Field->AddFixedVariable("~gr_sect", "������ ����������");
  Field->AddFixedVariable("~gr_ind", "������ ��������������");
  Field->AddFixedVariable("~gr_fld", "�������              ");
  Field->AddFixedVariable("~gr_budjet", "������               ");
  Field->AddFixedVariable("~gr_fbud","������ ����������.   ");
  Field->AddFixedVariable("~gr_act", "��� ������������     ");
  Field->AddFixedVariable("~gr_prop","��� �������������    ");
  Field->AddFixedVariable("~gr_min", "������������         ");
  Field->AddFixedVariable("~gr_tax", "�����               ");
  Field->AddFixedVariable("~gr_kwed","���������� ����     ");
  Field->AddFixedVariable("~gr_",    " ������              ");
  Field->AddFixedVariable("  ",      "                    ");
  Field->SetDefValue(" ");
  Field->SetWidth(80);
  Field->OnChange=OnChangeKey;

  DBGrGroup->AfterInsert=AfterInsGrParam;
  DBGrGroup->AfterScroll=AfterScrollGrParam;

  TWTPanel* PButton=DocClmPar->MainPanel->InsertPanel(300,true,30);

  TSpeedButton* SBNext=new TSpeedButton(PButton);
  SBNext->Flat=true;
  SBNext->Glyph->LoadFromResourceName(0,"Next");
  SBNext->Width=24;
  SBNext->Height=24;
  SBNext->Top=5;
  SBNext->Left=200;
  SBNext->ShowHint=true;
  SBNext->Hint="���������";
  SBNext->OnClick=NextLevel;
  SBNext->Parent=PButton;

  TSpeedButton* SBPrev=new TSpeedButton(PButton);
  SBPrev->Flat=true;
  SBPrev->Glyph->LoadFromResourceName(0,"Prev");
  SBPrev->Width=24;
  SBPrev->Height=24;
  SBPrev->Top=5;
  SBPrev->Left=100;
  SBPrev->ShowHint=true;
  SBPrev->Hint="����������";
  SBPrev->OnClick=PrevLevel;
  SBPrev->Parent=PButton;

  //TWTPanel *DPanel1=GrpDoc->MainPanel->InsertPanel(30,false,40); // (X,bool,Y) X,Y min size panel
  TWTPanel* PButtonD=DocClmPar->MainPanel->InsertPanel(30,false,30);
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PButtonD->Params->AddText("����������",18,F,Classes::taCenter,false);

  TWTPanel* PParam0=DocClmPar->MainPanel->InsertPanel(350,true,100);

  TWTDBGrid* DBGrParam0 = new TWTDBGrid(DocClmPar, "cla_param_tbl");
  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
 // PParam0->Params->AddText("����������",18,F,Classes::taCenter,false);
  PParam0->Params->AddGrid(DBGrParam0, true)->ID="Param0";
  TWTQuery *QuerPar0=new TWTQuery(this);
  DBGrParam0->Table->AddLookupField("Parent","id_parent","cla_param_tbl","name","id");

  DBGrParam0->Table->Open();
  DBGrParam0->Table->Filter="lev=2" ;
  DBGrParam0->Table->Filtered=true;

  //DBGrRegion->ReadOnly=true;
  DBGrParam0->Table->IndexFieldNames = "id_group;id;kod;name";
  DBGrParam0->Table->LinkFields = "id=id_group";
  DBGrParam0->Table->MasterSource = DataSource;
    DBGrParam0->OnExit=ExitParamsGrid;
  TWTField *Fields0;

/*  Fields0 = DBGrParam0->AddColumn("Parent", "������", "������������");
  Fields0->FieldLookUpFilter="id_group";
  Fields0->ExpFieldLookUpFilter=(TWTField*)DBGrGroup->Table->FieldByName("id");
   Fields0->SetOnHelp(ClmSprParSMSpr);
  */
   Fields0 = DBGrParam0->AddColumn("kod", "���", "���");
  Fields0 = DBGrParam0->AddColumn("Name", "������������", "������������");

  DBGrParam0->Table->IndexFieldNames = "kod";
  //Field->SetUnique("������ ������������ � �����������","cla_param_tbl","name");
  //  Field->SetRequired("������������  ������ ���� ���������");
  /*DBGrParam->FieldSource = DBGrParam->Table->GetTField("id");
  DBGrParam->FieldDest = Sender;
    */
     DBGrParam0->AfterInsert=AfterInsSParam;
     DBGrParam0->BeforePost=PostParam;
  TDataSource *DataSource0=DBGrParam0->DataSource;

  TWTPanel* PParam=DocClmPar->MainPanel->InsertPanel(400,false,100);
  TWTDBGrid* DBGrParam = new TWTDBGrid(DocClmPar, "cla_param_tbl");
/*  F ->Size=10;
  F->Style=F->Style << fsBold;
  F->Color=clBlue;
  PParam->Params->AddText("����������",18,F,Classes::taCenter,false);
 */
  PParam->Params->AddGrid(DBGrParam, true)->ID="Param";
  TWTQuery *QuerPar=new TWTQuery(this);
  DBGrParam->Table->AddLookupField("Parent","id_parent","cla_param_tbl","name","id");

  DBGrParam->Table->Open();
  //DBGrRegion->ReadOnly=true;
  DBGrParam->Table->IndexFieldNames = "kod";
  DBGrParam->Table->LinkFields = "id=id_parent";
  DBGrParam->Table->MasterSource = DataSource0;
    DBGrParam->OnExit=ExitParamsGrid;
  TWTField *Fields;

  /*Fields = DBGrParam->AddColumn("Parent", "������", "������������");
  Fields->FieldLookUpFilter="id_group";
  Fields->ExpFieldLookUpFilter=(TWTField*)DBGrGroup->Table->FieldByName("id");
   Fields->SetOnHelp(ClmSprParSMSpr);
  */
   Fields = DBGrParam->AddColumn("kod", "���", "���");
  Fields = DBGrParam->AddColumn("Name", "������������", "������������");

    DBGrParam->Table->IndexFieldNames = "kod";
  //Field->SetUnique("������ ������������ � �����������","cla_param_tbl","name");
  //  Field->SetRequired("������������  ������ ���� ���������");
  DBGrParam->FieldSource = DBGrParam->Table->GetTField("id");
  DBGrParam->FieldDest = Sender;
     DBGrParam->AfterInsert=AfterInsSParam;
     DBGrParam->BeforePost=PostParam;
   DocClmPar->MainPanel->SetVResize(100);
   DocClmPar->ShowAs(WinName);
   DocClmPar->SetCaption("���������� ���������� "); //�� ������ ��������� "["
  // ����������� ��� �������� ������ �� �����. ������ ���� ����� SetCaption
  //DocAdr->ID="AdmAdrM";
  DocClmPar->LoadFromFile(DocClmPar->DocFile);
  DocClmPar->Constructor=true;

  DocClmPar->MainPanel->ParamByID("Param")->Control->SetFocus();
  DocClmPar->MainPanel->ParamByID("Param0")->Control->SetFocus();
  DocClmPar->MainPanel->ParamByID("Group")->Control->SetFocus();

   TWTQuery *ParQuery=new TWTQuery(this);
   int edidPar;
   int edidGroup;

   //int edidStreet;
   TLocateOptions SearchOptions;
   SearchOptions.Clear();

   bool try_field=false;
    if (Sender!=NULL)
    try {
       int val_field= Sender->Field->AsVariant;
       try_field=true;
     } catch (...){};

     if ((Sender!=NULL && try_field)||(DBGrParam->StringDest!=NULL) )
    {  ParQuery->Sql->Clear();
      ParQuery->Sql->Add("Select * from cla_param_tbl where id="+ToStrSQL(Sender->Field->AsString));
      ParQuery->Open();
      edidGroup=ParQuery->FieldByName("id_group")->AsInteger;
      edidPar=ParQuery->FieldByName("id")->AsInteger;
      ParQuery->Sql->Clear();
      ParQuery->Sql->Add("Select * from cla_param_tbl where id="+ToStrSQL(edidGroup));
      ParQuery->Open();

      bool t1=DBGrGroup->DataSource->DataSet->Locate("id",edidGroup ,SearchOptions);
      bool t2=DBGrParam->DataSource->DataSet->Locate("id",edidPar ,SearchOptions);
    }

    //TSplitter* Spp=PP->SetVResize(50);


  return DBGrParam;
};

void _fastcall TMainForm::NextLevel(TObject *Sender) {
  TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent;
  TWTDBGrid *Param0= ((TWTDBGrid *)MPanel->ParamByID("Param0")->Control);
  TWTDBGrid *Param= ((TWTDBGrid *)MPanel->ParamByID("Param")->Control);
  //TWTParamItem  *Lab= ((TWTParamItem *)MPanel->ParamByID("Lab"));
  AnsiString SelectId=Param->Table->FieldByName("id")->AsString;
  AnsiString ParentId=Param->Table->FieldByName("id_parent")->AsString;

  short Napr=0;
  AnsiString fieldp=' ';
  AnsiString razdp='-';
  if (!(SelectId.IsEmpty()))
  {

   //TQuery *NewId;
  int SelectIdI=Param->Table->FieldByName("id")->AsVariant;
  /* AnsiString str="SELECT * From FIELD_PARENT(:pid,:raz,:par,:pres,:pchan);";
   NewId = new TQuery(this);
   NewId->DatabaseName="DatabaseName";
   NewId->SQL->Add(str);
   NewId->ParamByName("pid")->Value=SelectIdI;
   NewId->ParamByName("raz")->Value=razdp;
   NewId->ParamByName("par")->Value=Napr;
   NewId->ParamByName("pres")->Value="";
   NewId->ParamByName("pchan")->Value="";
   NewId->ExecSQL();
   NewId->SQL->Clear();
   str="select * from rr" ;
   NewId->SQL->Add(str);
   NewId->Open();
   AnsiString Pred =NewId->Fields->Fields[0]->AsString;
   if (!(Pred.IsEmpty()))
       Lab->SetValue(Pred);
   else  Lab->SetValue(" ");
    NewId->SQL->Clear();
    str="delete from rr" ;
    NewId->SQL->Add(str);
    NewId->ExecSQL();
   delete NewId;      */
   Param0->Table->Filter="id_parent=" +ParentId;
  Param0->Table->Filtered=true;
}
 else ShowMessage("����� ��� ����������� ���������!");


};

void _fastcall TMainForm::PrevLevel(TObject *Sender) {
 TWTPanel *TDoc;
  TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ( TWTPanel *)TDoc->Parent->Parent;
  TWTDBGrid *Param0= ((TWTDBGrid *)MPanel->ParamByID("Param0")->Control);
  TWTDBGrid *Param= ((TWTDBGrid *)MPanel->ParamByID("Param")->Control);
  //TWTParamItem *Lab= ((TWTParamItem *)MPanel->ParamByID("Lab"));
  bool par=true;
  AnsiString NewParentId=Param0->Table->FieldByName("id_parent")->AsString;
  if (NewParentId.IsEmpty()){ par=false;};
    if(par)
      { TWTQuery *QueryParent=new TWTQuery(this);
        //QueryParent->DatabaseName="DatabaseName";
        QueryParent->Sql->Add("select id_parent,lev from cla_param_tbl where id="+NewParentId);
        QueryParent->Open();
        NewParentId=QueryParent->FieldByName("id_parent")->AsString;
        int lev=QueryParent->FieldByName("lev")->AsInteger;
        /*AnsiString fieldp=" ";
        AnsiString razdp="->";
        short Napr=0;  */
        if (lev>1)//(!(NewParentId.IsEmpty()))
        {
          //TQuery *NewId;
           int NewParentIdI=QueryParent->FieldByName("id_parent")->AsVariant;
          /*AnsiString str="SELECT * from FIELD_PARENT(:pid,:raz,:par,:pres,:pchan)";
          NewId = new TQuery(this);
          NewId->DatabaseName="DatabaseName";
          NewId->SQL->Add(str);
          NewId->ParamByName("pid")->Value=NewParentIdI;
          NewId->ParamByName("raz")->Value=razdp;
          NewId->ParamByName("par")->Value=Napr;
          NewId->ParamByName("pres")->Value="";
          NewId->ParamByName("pchan")->Value="";
          NewId->ExecSQL();
          NewId->SQL->Clear();
          str="select * from rr" ;
          NewId->SQL->Add(str);
          NewId->Open();
          AnsiString Pred =NewId->Fields->Fields[0]->AsString;
          if (!(Pred.IsEmpty()))
             Lab->SetValue(Pred);
          else  Lab->SetValue(" ");
          NewId->SQL->Clear();
          str="delete from rr" ;
          NewId->SQL->Add(str);
          NewId->ExecSQL();
         delete NewId; */
         Param0->Table->Filter="id_parent=" +NewParentId;
         Param0->Table->Filtered=true;
    }
     else
    { Param0->Table->Filter="lev=2" ;
      Param0->Table->Filtered=true;
      //Lab->SetValue("������� �������");
    };

    delete QueryParent;
  }
  else {ShowMessage("����� ���!");};
    //Lab->SetValue("������� �������");
};



void _fastcall TMainForm::OnChangeKey(TWTField *Sender)
{  TBookmark SavePlace;
    AnsiString keys;
    SavePlace= new TBookmark();
     TWTQuery *QuerUpd=new TWTQuery(this);
     int id_rec;
     keys=Sender->Field->AsString;
     if (keys=="~gr_")
      return;
    if (Sender->Field->DataSet->State == dsEdit)
    {   id_rec=Sender->Field->DataSet->FieldByName("id")->AsInteger;
       QuerUpd->Sql->Clear();
       QuerUpd->Sql->Add("Select id from cla_param_tbl  " );
       QuerUpd->Sql->Add(" where key_name=" +ToStrSQL(keys));
       QuerUpd->Open();
       if (QuerUpd->FieldByName("id")->AsInteger!=id_rec)
       {
         ShowMessage("��� ���������� ����� ������ ����������!");
       };
     }
    else
     {
       if (Sender->Field->DataSet->State == dsEdit)
        {  int id_rec=Sender->Field->DataSet->FieldByName("id")->AsInteger;
           QuerUpd->Sql->Clear();
           QuerUpd->Sql->Add("Select id from cla_param_tbl  " );
           QuerUpd->Sql->Add(" where key_name=" +ToStrSQL(keys));
           QuerUpd->Open();
           if (!QuerUpd->Eof)
           {
             ShowMessage("��� ���������� ����� ������ ����������!");
           };
         };
      };
 };


void _fastcall TMainForm::AfterInsGrParam(TWTDBGrid *Sender)
{
   Sender->DataSource->DataSet->FieldByName("id_group")->AsInteger=Sender->DataSource->DataSet->FieldByName("id")->AsInteger;
 if (Sender->DataSource->DataSet->Filter!=NULL)
    { AnsiString filt=Sender->DataSource->DataSet->Filter;
      int p=filt.Pos("=");
      if (p>0)
       { AnsiString fil=filt.SubString(p+1,filt.Length());
         Sender->DataSource->DataSet->FieldByName("key_name")->AsString=fil;
       }
    };
};


void _fastcall TMainForm::AfterScrollGrParam(TWTDBGrid *Sender)
{
   TWTPanel *TDoc= ((TWTDoc*)(Sender->Owner))->MainPanel;

  //TDoc=( TWTPanel *)((TWinControl *)Sender)->Parent;
  TWTPanel *MPanel= ((TWTDoc*)(Sender->Owner))->MainPanel;
  TWTDBGrid *Param0= ((TWTDBGrid *)MPanel->ParamByID("Param0")->Control);
  TWTDBGrid *Param= ((TWTDBGrid *)MPanel->ParamByID("Param")->Control);
    Param0->Table->Filter="lev=2" ;
  Param0->Table->Filtered=true;



};



#undef WinName

#define WinName "���������� ���������� "
void _fastcall TMainForm::ClmSprParSMBtn(TObject *Sender)
 {
  ClmSprParSMSpr(NULL);
}

void _fastcall TMainForm::ClmSprParSMSpr(TWTField *Sender)
{
AnsiString par="~g";

 if (Sender!=NULL)
   {
   if (Sender->ExpFieldLookUpFilter!=NULL )
      {
       AnsiString Proba=((TField*)(Sender->ExpFieldLookUpFilter))->AsString;
       TWTQuery *Quer=new TWTQuery(this);
       Quer->Sql->Add("select key_name from cla_param_tbl where id="+Proba );
       Quer->Open();
       if (!Quer->Eof)
       {
        par=Quer->FieldByName("key_name")->AsString;
       };
      };
    };
 ClmSprParSMSel(Sender,NULL,par);
}

TWTDBGrid* _fastcall TMainForm::ClmSprParSMSel(TWTField *Sender,AnsiString StringSel,AnsiString par) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTQuery *QuerGr= new TWTQuery(this);
  QuerGr->Sql->Clear();
  QuerGr->Sql->Add("select id from cla_param_tbl where key_name="+ToStrSQL(par));
  QuerGr->Open();
  if (QuerGr->Eof)
    { //ShowMessage("�� ��������� ������ � ����������� ����������! �������� ���������� ���������� �������!");
      //return NULL;
    };
  int gr_par=QuerGr->FieldByName("id")->AsInteger;
  AnsiString id_gr_par=IntToStr(gr_par);
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cla_param_tbl",false);
  WGrid->SetCaption(WinName);


  TWTTable* Table = WGrid->DBGrid->Table;
  if (!(par=="~g"))
  Table->DefaultFilter="id_group="+id_gr_par;

  Table->Filtered=true;
  Table->AddLookupField("Parent","id_parent","cla_param_tbl","name","id");
  Table->Open();

  TWTField *Field;
  Field = WGrid->DBGrid->AddColumn("Kod", "���", "���");
  Field->SetWidth(90);

  Field = WGrid->DBGrid->AddColumn("Name", "������������", "������������");
  Field->SetWidth(300);

  Field = WGrid->DBGrid->AddColumn("Parent", "������", "������������");
  Field->FieldLookUpFilter="id_group";
  Field->SetWidth(300);
  Field->ExpFieldLookUpFilter=(TWTField*)QuerGr->FieldByName("id");
  Field->SetOnHelp(ClmSprParSMSpr);
   Field->SetRequired("������������ ������ ���� ���������");


  //Field->SetRequired("������������ ������ ���� ���������");
 if (par=="~gr_kwed" ||par=="~gr_budjet")
  {WGrid->DBGrid->Table->IndexFieldNames = "id";
  WGrid->DBGrid->OnDrawColumnCell=HeadKwedColumnCell;}
 else
 WGrid->DBGrid->Table->IndexFieldNames = "id_group;kod;name";

  WGrid->DBGrid->AfterInsert=AfterInsS2Param;
  WGrid->DBGrid->BeforePost=PostParam;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");

  WGrid->DBGrid->FieldDest = Sender;
  if (par=="~gr_kwed" ||par=="~gr_budjet")
  WGrid->DBGrid->Table->IndexFieldNames = "id";
 else
 WGrid->DBGrid->Table->IndexFieldNames = "id_group;kod;name";

  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs(WinName);
  return  WGrid->DBGrid;
};

void __fastcall TMainForm::HeadKwedColumnCell(TObject *Sender,  const TRect &Rect, int DataCol, TColumn *Column,    TGridDrawState State)
{   int kol,len;
   kol=0;
   AnsiString  sp,sp1;

 TDBGrid* t=(TDBGrid*)Sender;
  sp=t->DataSource->DataSet->FieldByName("kod")->AsString;
  if (sp.Pos(".")!=0)
     { len=sp.Length();
       sp1=sp.SubString(sp.Pos(".")+1,len);
       if (sp1.Pos(".")!=0)          kol=1;
      }
 if (kol)
 {
 t->Canvas->Brush->Color=clInfoBk;
 t->Canvas->FillRect(Rect);
 t->Canvas->Font->Color=clBlack;
 t->Canvas->TextOut(Rect.Left+2,Rect.Top+2,Column->Field->Text);
  };
}

void _fastcall TMainForm::AfterInsSParam(TWTDBGrid *Sender)
{

    Sender->DataSource->DataSet->FieldByName("id_parent")->AsInteger =  Sender->DataSource->DataSet->FieldByName("id_group")->AsInteger;

};

void _fastcall TMainForm::AfterInsS2Param(TWTDBGrid *Sender)
{
 if (!Sender->DataSource->DataSet->Filter.IsEmpty())
    { AnsiString filt=Sender->DataSource->DataSet->Filter;
      int p=filt.Pos("=");
      if (p>0)
       { AnsiString fil=filt.SubString(p+1,filt.Length());
         Sender->DataSource->DataSet->FieldByName("id_group")->AsInteger=StrToInt(fil);
         Sender->DataSource->DataSet->FieldByName("id_parent")->AsInteger=StrToInt(fil);

       }
    }
    else
    {
    Sender->DataSource->DataSet->FieldByName("id_parent")->AsInteger =  Sender->DataSource->DataSet->FieldByName("id_group")->AsInteger;
    };
};

void _fastcall TMainForm::PostParam(TWTDBGrid *Sender)
{
 int lev= 0;
   TWTQuery *QuerLev=new TWTQuery(this);
   QuerLev->Sql->Add("select lev from cla_param_tbl where id="+Sender->DataSource->DataSet->FieldByName("id_parent")->AsString);
   QuerLev->Open();
 if (!QuerLev->Eof)     lev=QuerLev->FieldByName("lev")->AsInteger+1;
 AnsiString nam=LTRIM(Sender->DataSource->DataSet->FieldByName("name")->AsString);
  AnsiString spac="";
 for (int i=0;i<=lev;i++)
 {
  spac=spac+"  ";
 };
 nam=spac+nam;
 Sender->DataSource->DataSet->FieldByName("lev")->AsInteger=lev;
 Sender->DataSource->DataSet->FieldByName("name")->AsString=nam;
};

          /*
void _fastcall TMainForm::AfterInsParam(TWTDBGrid *Sender)
{ Sender->DataSource->DataSet->FieldByName("id_parent")->AsInteger =  Sender->DataSource->DataSet->FieldByName("id_group")->AsInteger
};
            */


#undef WinName



