#include <vcl.h>
#pragma hdrstop

#include "Main.h"
#define WinName "Расчетные счета клиента"
TWTDBGrid* _fastcall TMainForm::AccClientSel(int cl,int mfo) {
  // Определяем владельца
  TWinControl *Owner =  this ;

  // Если такое окно есть - активизируем и выходим
  if (ShowMDIChild(WinName, Owner)) {
    return NULL;
  }
  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, "cli_account_tbl",false);
  WGrid->SetCaption(WinName);
  TWTTable* Table = WGrid->DBGrid->Table;
  // Добавляем поля для просмотра и для ограничения на наличие поля в справочнике
  Table->AddLookupField("NAME_BANK", "MFO", "cmi_bank_tbl", "NAME","id");
  Table->SetFilter("id_client= "+IntToStr(cl));

       Table->Filtered=true;

   Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("ACCOUNT", "Счет", "Расчетный счет");
  Field->SetRequired("Расчетный счет должен быть заполнен");

  Field = WGrid->AddColumn("MFO", "MFO", "MFO");
  Field->SetOnHelp(CmiBankSpr);

  Field = WGrid->AddColumn("NAME_BANK", "Банк", "Банк");
  Field->SetOnHelp(CmiBankSpr);

   Field = WGrid->AddColumn("Main", "Главный", "Признак главного счета");
  Field->AddFixedVariable("True", "Основной");
  Field->AddFixedVariable("False","       ");
  Field->SetDefValue("false");

  Field->OnChange=OnChangeAccount;

   WGrid->DBGrid->AfterInsert=AfterInsSelAccount;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("account");
 // WGrid->DBGrid->FieldDest = Sender;
   WGrid->DBGrid->FieldLook=WGrid->DBGrid->Table->GetTField("account");
  WGrid->DBGrid->Visible = true;
   WGrid->ShowAs(WinName);
   return WGrid->DBGrid;
};

void _fastcall TMainForm::AfterInsSelAccount(TWTDBGrid *Sender)
{
 if (Sender->DataSource->DataSet->Filter!=NULL)
    { AnsiString filt=Sender->DataSource->DataSet->Filter;
      int p=filt.Pos("=");
      int pc=filt.Pos("and");
       if (pc==0)
          pc=filt.Length();
      if (p>0)
       { AnsiString cli=filt.SubString(p+1,pc);
         int ee=StrToInt(cli);
        Sender->DataSource->DataSet->FieldByName("id_client")->AsInteger=ee;
       }
    };
};

void _fastcall TMainForm::OnChangeSelAccount(TWTField *Sender)
{ int cli;
 TBookmark SavePlace;
    SavePlace= new TBookmark();
 if (Sender->Field->DataSet->Filter!=NULL)
    { AnsiString filt=Sender->Field->DataSet->Filter;
      int p=filt.Pos("=");
      int pc=filt.Pos("and");
      if (p>0)
       { AnsiString ee=filt.SubString(p+1,pc);
          cli=StrToInt(ee);
        Sender->Field->DataSet->FieldByName("id_client")->AsInteger=cli;
       }
    };
   if (Sender->Field->AsBoolean==true)
  {  TWTQuery *QuerUpd=new TWTQuery(this);
     QuerUpd->Sql->Clear();
     QuerUpd->Sql->Add(" Update cli_account_tbl set main=false where id_client="+cli );
     QuerUpd->ExecSql();
     SavePlace=Sender->Field->DataSet->GetBookmark();
       SavePlace=Sender->Field->DataSet->GetBookmark();
       if (Sender->Field->DataSet->BookmarkValid(SavePlace))
         int rr=0;

       Sender->Field->DataSet->Refresh();
      if (Sender->Field->DataSet->BookmarkValid(SavePlace))
       try {
       // FieldDest->Field->DataSet->Bookmark="SavePlace";
          Sender->Field->DataSet->GotoBookmark(SavePlace);
                Sender->Field->DataSet->FreeBookmark(SavePlace);
           }
       catch (...) {
       ;
       };
  };
};

#undef WinName
