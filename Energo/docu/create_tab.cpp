//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "create_tab.h"
#include "doc_tmp.h"
#include "docu_mod.h"
#include "docu.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TCreateTab *CreateTab;
int pressed=0;
TList* TabList;
int panlist[20][2],pancount;
int fordelete[20],delcount;
int defh,defw;

typedef struct AList
{
 TPanel* pan;
 int row;
 int col;
 AnsiString prop;
} TAList;

typedef TAList* PAList;

//---------------------------------------------------------------------------
__fastcall TCreateTab::TCreateTab(TComponent* Owner)
        : TfTWTCompForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TCreateTab::FormClose(TObject *Sender,
      TCloseAction &Action)
{
if (form==1) Main_doc->Enabled=true;
if (form==2) Doc_temp->Enabled=true;
if (pressed==1) {
delete Parent;
}
 TfTWTCompForm::FormClose(Sender,Action);
}
//---------------------------------------------------------------------------
void __fastcall TCreateTab::FormActivate(TObject *Sender)
{
pressed=0;
//Обнуляем список ячеек для обьединения
for (int i=0;i<20;i++) {panlist[0][i]=0;panlist[1][i]=0;fordelete[i]=0;}
pancount=0;delcount=0;
defh=0;defw=0;

        TPanel *panel = new TPanel(CreateTab);
try {
        panel->Parent=CreateTab;
        panel->BevelOuter=bvRaised;
        panel->Align=alClient;
        panel->Name="Parent";
        panel->Caption="";
}
__except(1) {delete panel;}

}
//---------------------------------------------------------------------------
void __fastcall TCreateTab::SpeedButton2Click(TObject *Sender)
{
if (pressed==0) {ShowMessage("Таблица не создана. Создайте таблицу");}
else {//Сохраняем таблицу

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("insert into dci_template_tbl(idk_template,value) values(5,'"+Module2DB->MainDB->Login+"')");
   Module2DB->QueryExec->ExecSql();

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select id from dci_template_tbl where value='"+Module2DB->MainDB->Login+"'");
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;
   int id_parent=0;
   int id_elem=Module2DB->QueryExec->FieldByName("id")->AsInteger;

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("update dci_template_tbl set value=NULL where id="+IntToStr(id_elem));
   Module2DB->QueryExec->ExecSql();

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("insert into dcm_template_tbl(name,idk_template,level,num,id_elem,id) values('"+TableName->Text+"',5,0,1,"+IntToStr(id_elem)+","+IntToStr(id_elem)+")");
   Module2DB->QueryExec->ExecSql();

id_parent=id_elem;
for (int i=1;i<=GetNumRow();i++)
 {
   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("insert into dci_template_tbl(idk_template,value) values(6,'"+Module2DB->MainDB->Login+"')");
   Module2DB->QueryExec->ExecSql();

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("select id from dci_template_tbl where value='"+Module2DB->MainDB->Login+"'");
   Module2DB->QueryExec->ExecSql();
   Module2DB->QueryExec->Active=true;
   id_elem=Module2DB->QueryExec->FieldByName("id")->AsInteger;

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("update dci_template_tbl set value=NULL where id="+IntToStr(id_elem));
   Module2DB->QueryExec->ExecSql();

   Module2DB->QueryExec->Sql->Clear();
   Module2DB->QueryExec->Sql->Add("insert into dcm_template_tbl(name,idk_template,level,num,id_elem,id,id_parent) values('tr',6,1,"+IntToStr(i)+","+IntToStr(id_elem)+","+IntToStr(id_elem)+","+IntToStr(id_parent)+")");
   Module2DB->QueryExec->ExecSql();

 int id_parent1=id_elem;
 for (int j=1;j<=GetNumCol(i);j++)
  {
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("insert into dci_template_tbl(idk_template,value) values(8,'"+Module2DB->MainDB->Login+"')");
    Module2DB->QueryExec->ExecSql();

    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("select id from dci_template_tbl where value='"+Module2DB->MainDB->Login+"'");
    Module2DB->QueryExec->ExecSql();
    Module2DB->QueryExec->Active=true;
    id_elem=Module2DB->QueryExec->FieldByName("id")->AsInteger;

    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("update dci_template_tbl set value=NULL where id="+IntToStr(id_elem));
    Module2DB->QueryExec->ExecSql();

    AnsiString prop=GetProp(i,j);
    Module2DB->QueryExec->Sql->Clear();
    Module2DB->QueryExec->Sql->Add("insert into dcm_template_tbl(name,idk_template,level,num,id_elem,id,id_parent,prop) values('td',8,2,"+IntToStr(j)+","+IntToStr(id_elem)+","+IntToStr(id_elem)+","+IntToStr(id_parent1)+",'"+prop+"')");
    Module2DB->QueryExec->ExecSql();
   }
 }

CreateTab->Close();
Main_doc->Refresh();
}//Сохраняем таблицу

}
//---------------------------------------------------------------------------
AnsiString __fastcall TCreateTab::GetProp(int row,int col)
{
int realrow;
AnsiString prop="";

int arr[30],cnt=0;
for (int i=0;i<30;i++) arr[i]=0;
PAList Struct;

for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 int f=0;
 for (int ii=0;ii<cnt;ii++) if (arr[ii]==Struct->row) f=1;
 if (f==0&&Struct->row!=0) {arr[cnt]=Struct->row;cnt++;}
 if (cnt==row) {realrow=row;break;}
}
cnt=0;

for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 if (Struct->row==realrow) {cnt++;}
 if (cnt==col) {prop=Struct->prop;break;}
}

return prop;
}
//---------------------------------------------------------------------------
void __fastcall TCreateTab::SpeedButton1Click(TObject *Sender)
{
if (pressed==1)
{

 delete Parent;

        TPanel *panel = new TPanel(CreateTab);
try {
        panel->Parent=CreateTab;
        panel->BevelOuter=bvRaised;
        panel->Align=alClient;
        panel->Name="Parent";
        panel->Caption="HoHo";
}
__except(1) {delete panel;}

}//еслт форма не закрывалась, и таблица создавалась, то удаляем старую таблицу
int rows=0,cols=0,f=0;
 try {rows=StrToInt(Rows->Text);f=1;}
 __except(1) {ShowMessage("Неверное значение количества рядов");}

if (f==1) {
try {cols=StrToInt(Cols->Text);f=2;}
__except(1) {ShowMessage("Неверное значение количества колонок");}
 }
 if (rows==0) {f=0;ShowMessage("Количество рядов не может быть равно нулю");}
 if (cols==0) {f=0;ShowMessage("Количество колонок не может быть равно нулю");}
 if (f==2)
 {
 PAList Struct;
 TabList = new TList;

 pressed=1;
 int defheight=Parent->Height/rows;
 int defwidth=Parent->Width/cols;
 defh=defheight;
 defw=defwidth;
 for (int i=0;i<cols;i++)
 for (int j=0;j<rows;j++)
 {
        TPanel *panel = new TPanel(Parent);
        panel->Parent=Parent;
        panel->Height=defheight;
        panel->Width=defwidth;
        panel->Left=i*defwidth;
        panel->Top=j*defheight;
        panel->BevelOuter=bvRaised;
        panel->Caption=IntToStr(j+1)+":"+IntToStr(i+1);
        panel->OnClick=Clk;
  Struct = new TAList;
  Struct->pan=panel;
  Struct->row=j+1;
  Struct->col=i+1;
  TabList->Add(Struct);
  }//for
 JoinBut->Visible=true;
 }//данные коректны, можно создавать таблицу

}
//---------------------------------------------------------------------------
void __fastcall TCreateTab::Clk(TObject *Sender)
{
TPanel* pan=(TPanel*) Sender;
int row=0,col=0;
PAList Struct;
for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 if (Struct->pan==pan) {
 row=Struct->row;col=Struct->col;break;}
}


if (pan->BevelInner==bvLowered)
{
pan->BevelInner=bvNone;
int f=0;
for (int i=0;i<pancount;i++)
{//цикл удаления из массива обьединяемых ячеек необходимой - begin
if (panlist[i][0]==row&&panlist[i][1]==col) {f=1;panlist[i][0]=0;panlist[i][1]=0;}
if (f==1&&(i+1)<pancount) {panlist[i][0]=panlist[i+1][0];panlist[i][1]=panlist[i+1][1];}
if (f==1&&(i+1)==pancount) {panlist[i][0]=0;panlist[i][1]=0;}
}//цикл удаления из массива обьединяемых ячеек необходимой - end
pancount--;
//ShowMessage("Remove");
}//of if
else
{
pan->BevelInner=bvLowered;
panlist[pancount][0]=row;
panlist[pancount][1]=col;
pancount++;
//ShowMessage("Add");
}//of else

}
//---------------------------------------------------------------------------

void __fastcall TCreateTab::JoinButClick(TObject *Sender)
{
int minrow=GetMinRow();
int mincol=GetMinCol(minrow);
int maxrow=GetMaxRow();
int maxcol=GetMaxCol(maxrow);

int f=0;

for (int i=0;i<pancount;i++)
{//цикл удаления из массива обьединяемых ячеек необходимой - begin
if (panlist[i][0]==minrow&&panlist[i][1]==mincol) {f=1;panlist[i][0]=0;panlist[i][1]=0;}
if (f==1&&(i+1)<pancount) {panlist[i][0]=panlist[i+1][0];panlist[i][1]=panlist[i+1][1];}
if (f==1&&(i+1)==pancount) {panlist[i][0]=0;panlist[i][1]=0;}
}//цикл удаления из массива обьединяемых ячеек необходимой - end
pancount--;

PAList Struct;
for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 if (Struct->row==minrow&&Struct->col==mincol)
 {
 Struct->pan->Height+=defh*(maxrow-minrow);
 Struct->pan->Width+=defw*(maxcol-mincol);
 Struct->pan->BevelInner=bvNone;
 AnsiString prop="";
 if ((maxrow-minrow+1)>1) prop+="rowspan="+IntToStr(maxrow-minrow+1)+" ";
 if ((maxcol-mincol+1)>1) prop+="colspan="+IntToStr(maxcol-mincol+1)+" ";
 Struct->prop=prop;
 }
 for (int ii=0;ii<pancount;ii++)
 {
 if (Struct->row==panlist[ii][0]&&Struct->col==panlist[ii][1]) {Struct->pan->Visible=false;
                                                                Struct->row=0;
                                                                Struct->col=0;
                                                                //fordelete[delcount]=i;
                                                                //delcount++;
                                                                }
 }
}

//for (int i=0;i<delcount;i++)
//{TabList->Delete(fordelete[i]);}

for (int i=0;i<20;i++) {panlist[0][i]=0;panlist[1][i]=0;fordelete[i]=0;}
pancount=0;delcount=0;

}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetMinRow()
{
int min=100;
 for (int i=0;i<pancount;i++)
 {
 if (panlist[i][0]<min) min=panlist[i][0];
 }
return min;
}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetMinCol(int minrow)
{
int min=100;
 for (int i=0;i<pancount;i++)
 {
 if (panlist[i][1]<min&&panlist[i][0]==minrow) min=panlist[i][1];
 }
return min;
}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetMaxRow()
{
int max=0;
 for (int i=0;i<pancount;i++)
 {
 if (panlist[i][0]>max) max=panlist[i][0];
 }
return max;
}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetMaxCol(int maxrow)
{
int max=0;
 for (int i=0;i<pancount;i++)
 {
 if (panlist[i][1]>max&&panlist[i][0]==maxrow) max=panlist[i][1];
 }
return max;
}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetNumRow()
{
int arr[30],cnt=0;
for (int i=0;i<30;i++) arr[i]=0;
PAList Struct;

for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 int f=0;
 for (int ii=0;ii<cnt;ii++) if (arr[ii]==Struct->row) f=1;
 if (f==0&&Struct->row!=0) {arr[cnt]=Struct->row;cnt++;}
}

return cnt;
}
//---------------------------------------------------------------------------
int __fastcall TCreateTab::GetNumCol(int row)
{
int arr[30],cnt=0;
for (int i=0;i<30;i++) arr[i]=0;
PAList Struct;

for (int i=0;i<TabList->Count;i++)
{
 Struct = (PAList) TabList->Items[i];
 int f=0;
 for (int ii=0;ii<cnt;ii++) if (arr[ii]==Struct->col) f=1;
 if (f==0&&Struct->row==row) {arr[cnt]=Struct->col;cnt++;}
}

return cnt;
}
//---------------------------------------------------------------------------
