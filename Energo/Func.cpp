#include <vcl.h>
#pragma hdrstop

//----------------------------------------------------------------------------
// Функции библиотеки
//----------------------------------------------------------------------------
#include "Func.h"
#include "Edit.h"
#include "Form.h"
#include "Message.h"


//возвращает список SQL запросов для создания копии таблицы (запроса) Source
void  __fastcall GetCreateSQL(TDBDataSet* Source, AnsiString TableName,TStringList *SQLList)
{
}

//возвращает SQL строку для создания копии таблицы (запроса) связанного с Source
//и заполняет ее данными непосредственно отображаемыми в Source
AnsiString __fastcall GetCreateSQL(TDBGrid* Source, AnsiString TableName){
  AnsiString RA=AnsiString("CREATE TABLE")+AnsiString("\"")+TableName+AnsiString("\" (");
  for (int x=0;x<Source->Columns->Count;x++) {
    TField *FD=Source->Columns->Items[x]->Field;
    switch (FD->DataType) {
      case ftString:
      case ftWideString:
      case ftFixedChar:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" char(")+IntToStr(FD->DataSize)+AnsiString(")");
        break;
      case ftSmallint:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" smallint");
        break;
      case ftInteger:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" integer");
        break;
      case ftWord:
      case ftFloat:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" numeric");
        break;
      case ftCurrency:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" money");
        break;
      case ftBCD:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" binary(")+IntToStr(FD->DataSize)+AnsiString(")");
        break;
      case ftDate:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" date");
        break;
      case ftTime:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" time");
        break;
      case ftDateTime:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" timestamp");
        break;
      case ftAutoInc:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" autoinc");
        break;
      case ftMemo:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",1)");
        break;
      case ftFmtMemo:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",3)");
        break;
      case ftBoolean:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" boolean");
        break;
      case ftUnknown:
      case ftBytes:
      case ftVarBytes:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" bytes(")+IntToStr(FD->DataSize)+AnsiString(")");
        break;
      case ftBlob:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",2)");
        break;
      case ftGraphic:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",5)");
        break;
      case ftParadoxOle:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",4)");
        break;
      case ftDBaseOle:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",4)");
        break;
      case ftTypedBinary:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" blob(")+IntToStr(FD->DataSize)+AnsiString(",2)");
        break;
      case ftCursor:
        if (x!=0) RA+=",";
        RA+=FD->FieldName+AnsiString(" binary(")+IntToStr(FD->DataSize)+AnsiString(")");
        break;
    }
  }
/*  if (CheckParent(Source->DataSource->DataSet ,"TTable") || AnsiString(Source->DataSource->DataSet->ClassName())=="TTable") {
    TTable *Table=(TTable*)Source->DataSource->DataSet;
    Table->IndexDefs->Update();
    for (int x=0;x<Table->IndexDefs->Count;x++) {
      if (Table->IndexDefs->Items[x]->Options.Contains(ixPrimary))
        RA+=AnsiString(", primary key (")+Table->IndexDefs->Items[x]->Fields+AnsiString(")");
    }
  }  */

  RA+=")";
  return RA;

}


//Проверяет есть ли у класса Class предок с именем ClassName
bool CheckParent(TClass Class,AnsiString ClassName){
  ShortString SS=TControl::ClassName(TControl::ClassParent(Class));
  if (AnsiString(SS)==ClassName) return true;
  if (AnsiString(SS)=="TObject") return false;
  return CheckParent(TControl::ClassParent(Class),ClassName);
}

//с учетом самого объекта Class
bool CheckParent(TObject *Class,AnsiString ClassName){
  if (AnsiString(Class->ClassName())==ClassName) return true;
  return CheckParent(Class->ClassType(),ClassName);
}

#include <sys/stat.h>
#include <stdio.h>
#include <time.h>

// Записывает строку в файл диагностики
// если файл не открыт возвращает 0
// Вызов без параметров проверяет размер файла и если он больше 500кб
// переименовывает его (для ограничения на размер файла)
int SaveMessage(AnsiString Str, AnsiString Str1, AnsiString Str2, AnsiString Str3, AnsiString Str4, AnsiString Str5, AnsiString Str6, AnsiString Str7) {
char Buf[32];
char Buf1[16];

  if (Str == "") {
    // Ограничиваем размер log-файла
    int fh;
    if((fh = open("WT.log", fmOpenRead, fmShareDenyNone)) != -1) {
      if (filelength(fh) > 500000) {
        close( fh );
        TDateTime Time = Time.CurrentDateTime();
        strcpy(Buf, "WT");
        strcat(Buf, Time.FormatString("yyyymmddhhnn").c_str());
        strcat(Buf, ".log");
        if (rename("WT.log", Buf) == 0) {
          SaveMessage("Log-файл сохранен в файле ", Buf);
          return 1;
        }
        return 0;
      }
      close( fh );
      return 1;
    }
    return 0;
  }

  FILE *stream;

  if ((stream = fopen("WT.log", "a+")) != NULL) {
    // Записывает дату и время
    _strdate(Buf);
    _strtime(Buf1);
    fprintf(stream, "%s %s :: %s", Buf, Buf1, Str.c_str());
    if (Str1 != "")
      fprintf(stream, " %s", Str1.c_str());
    if (Str2 != "")
      fprintf(stream, " %s", Str2.c_str());
    if (Str3 != "")
      fprintf(stream, " %s", Str3.c_str());
    if (Str4 != "")
      fprintf(stream, " %s", Str4.c_str());
    if (Str5 != "")
      fprintf(stream, " %s", Str5.c_str());
    if (Str6 != "")
      fprintf(stream, " %s", Str6.c_str());
    if (Str7 != "")
      fprintf(stream, " %s", Str7.c_str());
    fprintf(stream, "\n");
    fclose(stream);
    return 1;
  }
  return 0;
}


TField* AddSimpleField(TZDataset* DataSet,AnsiString FName){
  TField *FField;
//  Table->TTable::Open();
  switch (DataSet->FieldDefs->Find(FName)->DataType) {
    case ftString:
    case ftWideString:
    case ftFixedChar:
      FField= new TStringField(DataSet);
      FField->Size=DataSet->FieldDefs->Find(FName)->Size;
      break;
    case ftSmallint:
      FField= new TSmallintField(DataSet);
      break;
    case ftInteger:
      FField= new TIntegerField(DataSet);
      break;
    case ftWord:
      FField= new TWordField(DataSet);
      break;
    case ftFloat:
      FField= new TFloatField(DataSet);
      break;
    case ftCurrency:
      FField= new TCurrencyField(DataSet);
      break;
    case ftBCD:
      FField= new TBCDField(DataSet);
      FField->Size=DataSet->FieldDefs->Find(FName)->Size;
      break;
    case ftDate:
      FField= new TDateField(DataSet);
      break;
    case ftTime:
      FField= new TTimeField(DataSet);
      break;
    case ftDateTime:
      FField= new TDateTimeField(DataSet);
      break;
    case ftAutoInc:
      FField= new TAutoIncField(DataSet);
      break;
    case ftMemo:
      FField= new TMemoField(DataSet);
      break;
    case ftFmtMemo:
      FField= new TMemoField(DataSet);
      break;
    case ftBoolean:
      FField= new TBooleanField(DataSet);
      break;
    case ftUnknown:
      break;
    case ftBytes:
      FField= new TBytesField(DataSet);
      break;
    case ftVarBytes:
      FField= new TVarBytesField(DataSet);
      break;
    case ftBlob:
      FField= new TBlobField(DataSet);
      break;
    case ftGraphic:
      FField= new TGraphicField(DataSet);
      break;
    case ftParadoxOle:
      break;
    case ftDBaseOle:
      break;
    case ftTypedBinary:
      break;
    case ftCursor:
      break;
  }
//  FField->Name=FName;
//  Table->TTable::Close();
  return FField;
}


void Delay(int Value) {
  float StartSec, EndSec;
  Word MSec, Sec, Min, Hour;
  TDateTime CurTime;
  CurTime=Now();
  DecodeTime(CurTime,Hour,Min,Sec,MSec);
  StartSec=Hour*3600000+Min*60000+Sec*1000+MSec;
  EndSec=StartSec;
  while ((EndSec-StartSec)<Value) {
    CurTime=Now();
    DecodeTime(CurTime,Hour,Min,Sec,MSec);
    EndSec=Hour*3600000+Min*60000+Sec*1000+MSec;
  }
}

//Дублирование полей
TField* DuplicateField(TField* Source,TZDataset* DataSet){
  TField* Dest;
  switch (Source->DataType) {
    case ftString:
      Dest= new TStringField(DataSet);
      ((TStringField*)Dest)->FixedChar=((TStringField*)Source)->FixedChar;
      ((TStringField*)Dest)->Transliterate=((TStringField*)Source)->Transliterate;
      ((TStringField*)Dest)->Size=((TStringField*)Source)->Size;
      break;
    case ftSmallint:
      Dest= new TSmallintField(DataSet);
      ((TSmallintField*)Dest)->MaxValue=((TSmallintField*)Source)->MaxValue;
      ((TSmallintField*)Dest)->MinValue=((TSmallintField*)Source)->MinValue;
      ((TSmallintField*)Dest)->DisplayFormat=((TSmallintField*)Source)->DisplayFormat;
      ((TSmallintField*)Dest)->EditFormat=((TSmallintField*)Source)->EditFormat;
      break;
    case ftInteger:
      Dest= new TIntegerField(DataSet);
      ((TIntegerField*)Dest)->MaxValue=((TIntegerField*)Source)->MaxValue;
      ((TIntegerField*)Dest)->MinValue=((TIntegerField*)Source)->MinValue;
      ((TIntegerField*)Dest)->DisplayFormat=((TIntegerField*)Source)->DisplayFormat;
      ((TIntegerField*)Dest)->EditFormat=((TIntegerField*)Source)->EditFormat;
      break;
    case ftWord:
      Dest= new TWordField(DataSet);
      ((TWordField*)Dest)->MaxValue=((TWordField*)Source)->MaxValue;
      ((TWordField*)Dest)->MinValue=((TWordField*)Source)->MinValue;
      ((TWordField*)Dest)->DisplayFormat=((TWordField*)Source)->DisplayFormat;
      ((TWordField*)Dest)->EditFormat=((TWordField*)Source)->EditFormat;
      break;
    case ftFloat:
      Dest= new TFloatField(DataSet);
      ((TFloatField*)Dest)->currency=((TFloatField*)Source)->currency;
      ((TFloatField*)Dest)->MaxValue=((TFloatField*)Source)->MaxValue;
      ((TFloatField*)Dest)->MinValue=((TFloatField*)Source)->MinValue;
      ((TFloatField*)Dest)->Precision=((TFloatField*)Source)->Precision;
      ((TFloatField*)Dest)->DisplayFormat=((TFloatField*)Source)->DisplayFormat;
      ((TFloatField*)Dest)->EditFormat=((TFloatField*)Source)->EditFormat;
      break;
    case ftCurrency:
      Dest= new TCurrencyField(DataSet);
      ((TCurrencyField*)Dest)->currency=((TCurrencyField*)Source)->currency;
      ((TCurrencyField*)Dest)->MaxValue=((TCurrencyField*)Source)->MaxValue;
      ((TCurrencyField*)Dest)->MinValue=((TCurrencyField*)Source)->MinValue;
      ((TCurrencyField*)Dest)->Precision=((TCurrencyField*)Source)->Precision;
      ((TCurrencyField*)Dest)->Value=((TCurrencyField*)Source)->Value;
      ((TCurrencyField*)Dest)->DisplayFormat=((TCurrencyField*)Source)->DisplayFormat;
      ((TCurrencyField*)Dest)->EditFormat=((TCurrencyField*)Source)->EditFormat;
      break;
    case ftBCD:
      Dest= new TBCDField(DataSet);
      ((TBCDField*)Dest)->currency=((TBCDField*)Source)->currency;
      ((TBCDField*)Dest)->MaxValue=((TBCDField*)Source)->MaxValue;
      ((TBCDField*)Dest)->MinValue=((TBCDField*)Source)->MinValue;
      ((TBCDField*)Dest)->Precision=((TBCDField*)Source)->Precision;
      ((TBCDField*)Dest)->Value=((TBCDField*)Source)->Value;
      ((TBCDField*)Dest)->DisplayFormat=((TBCDField*)Source)->DisplayFormat;
      ((TBCDField*)Dest)->EditFormat=((TBCDField*)Source)->EditFormat;
      ((TBCDField*)Dest)->Size=((TBCDField*)Source)->Size;
      break;
    case ftDate:
      Dest= new TDateField(DataSet);
      ((TDateField*)Dest)->DisplayFormat=((TDateField*)Source)->DisplayFormat;
      break;
    case ftTime:
      Dest= new TTimeField(DataSet);
      ((TTimeField*)Dest)->DisplayFormat=((TTimeField*)Source)->DisplayFormat;
      break;
    case ftDateTime:
      ((TDateTimeField*)Dest)= new TDateTimeField(DataSet);
      ((TDateTimeField*)Dest)->DisplayFormat=((TDateTimeField*)Source)->DisplayFormat;
      break;
    case ftAutoInc:
      Dest= new TAutoIncField(DataSet);
      ((TAutoIncField*)Dest)->MaxValue=((TAutoIncField*)Source)->MaxValue;
      ((TAutoIncField*)Dest)->MinValue=((TAutoIncField*)Source)->MinValue;
      ((TAutoIncField*)Dest)->DisplayFormat=((TAutoIncField*)Source)->DisplayFormat;
      ((TAutoIncField*)Dest)->EditFormat=((TAutoIncField*)Source)->EditFormat;
      break;
    case ftMemo:
    case ftFmtMemo:
      Dest= new TMemoField(DataSet);
      ((TMemoField*)Dest)->BlobType=((TMemoField*)Source)->BlobType;
      ((TMemoField*)Dest)->Modified=((TMemoField*)Source)->Modified;
      ((TMemoField*)Dest)->Transliterate=((TMemoField*)Source)->Transliterate;
      break;
    case ftBoolean:
      Dest= new TBooleanField(DataSet);
      ((TBooleanField*)Dest)->DisplayValues=((TBooleanField*)Source)->DisplayValues;
      break;
    case ftUnknown:
      return NULL;
    case ftBytes:
      Dest= new TBytesField(DataSet);
      break;
    case ftVarBytes:
      Dest= new TVarBytesField(DataSet);
      break;
    case ftBlob:
      Dest= new TBlobField(DataSet);
      ((TBlobField*)Dest)->BlobType=((TBlobField*)Source)->BlobType;
      ((TBlobField*)Dest)->Modified=((TBlobField*)Source)->Modified;
      ((TBlobField*)Dest)->Transliterate=((TBlobField*)Source)->Transliterate;
      break;
    case ftGraphic:
      Dest= new TGraphicField(DataSet);
      ((TGraphicField*)Dest)->BlobType=((TGraphicField*)Source)->BlobType;
      ((TGraphicField*)Dest)->Modified=((TGraphicField*)Source)->Modified;
      ((TGraphicField*)Dest)->Transliterate=((TGraphicField*)Source)->Transliterate;
      break;
    case ftParadoxOle:
      return NULL;
    case ftDBaseOle:
      return NULL;
    case ftTypedBinary:
      return NULL;
    case ftCursor:
      return NULL;
  }
  Dest->Calculated=Source->Calculated;
  Dest->CustomConstraint=Source->CustomConstraint;
  Dest->DefaultExpression=Source->DefaultExpression;
  Dest->DisplayLabel=Source->DisplayLabel;
  Dest->DisplayWidth=Source->DisplayWidth;
  Dest->EditMask=Source->EditMask;
  Dest->FieldKind=Source->FieldKind;
  Dest->ImportedConstraint=Source->ImportedConstraint;
  Dest->Index=Source->Index;
  Dest->KeyFields=Source->KeyFields;
  Dest->Lookup=Source->Lookup;
  Dest->LookupDataSet=Source->LookupDataSet;
  Dest->LookupKeyFields=Source->LookupKeyFields;
  Dest->LookupResultField=Source->LookupResultField;
  Dest->Origin=Source->Origin;
  Dest->ProviderFlags=Source->ProviderFlags;
  Dest->ReadOnly=Source->ReadOnly;
  Dest->Required=Source->Required;
  Dest->ValidChars=Source->ValidChars;
  Dest->Visible=Source->Visible;
  Dest->FieldName=Source->FieldName;
  Dest->DataSet=DataSet;
  Dest->OnChange=Source->OnChange;
  Dest->OnGetText=Source->OnGetText;
  Dest->OnSetText=Source->OnSetText;
  Dest->OnValidate=Source->OnValidate;
  return Dest;
}
//Удаление лишних полей из ini-файла
void UpdateIniFile(TMemIniFile* IniFile){
  TStringList* AllReports=new TStringList();
  TStringList* AllTables=new TStringList();
  Boolean Is;
  IniFile->ReadSection("ReportsID",AllReports);
  IniFile->ReadSection("Tables",AllTables);
  for (int x=0;x<AllTables->Count;x++) {
    Is=true;
    for (int y=0;y<AllReports->Count;y++) {
      if ((IniFile->ReadString("ReportsID",AllReports->Strings[y],""))==(IniFile->ReadString("Tables",AllTables->Strings[x],""))) Is=false;
    }
    if (Is) IniFile->DeleteKey("Tables",AllTables->Strings[x]);
  }
}
//Сохранение параметров шрифта в ini файл
Boolean FontToIni(TFont* Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident) {
  if (!IniFile->SectionExists(Section)) return false;
  IniFile->WriteString(Section,Ident+".Name",Font->Name);
  IniFile->WriteInteger(Section,Ident+".Charset",Font->Charset);
  IniFile->WriteInteger(Section,Ident+".Size",Font->Size);
  IniFile->WriteInteger(Section,Ident+".Color",Font->Color);
  if (Font->Style.Contains(fsBold)) IniFile->WriteInteger(Section,Ident+".Style.Bold",true);
    else IniFile->WriteInteger(Section,Ident+".Style.Bold",false);
  if (Font->Style.Contains(fsItalic)) IniFile->WriteInteger(Section,Ident+".Style.Italic",true);
    else IniFile->WriteInteger(Section,Ident+".Style.Italic",false);
  if (Font->Style.Contains(fsStrikeOut)) IniFile->WriteInteger(Section,Ident+".Style.StrikeOut",true);
    else IniFile->WriteInteger(Section,Ident+".Style.StrikeOut",false);
  if (Font->Style.Contains(fsUnderline)) IniFile->WriteInteger(Section,Ident+".Style.Underline",true);
    else IniFile->WriteInteger(Section,Ident+".Style.Underline",false);
  return true;
}
                                                             
//Чтение параметров шрифта из ini файла
Boolean IniToFont(TFont* &Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident) {
  if (!IniFile->SectionExists(Section)) return false;
  Font->Name=IniFile->ReadString(Section,Ident+".Name","");
  Font->Charset = IniFile->ReadInteger(Section,Ident+".Charset",0);
  Font->Size=IniFile->ReadInteger(Section,Ident+".Size",0);
  Font->Color=IniFile->ReadInteger(Section,Ident+".Color",0);
  if (IniFile->ReadInteger(Section,Ident+".Style.Bold",false)) Font->Style=Font->Style << fsBold;
    else Font->Style=Font->Style >> fsBold;
  if (IniFile->ReadInteger(Section,Ident+".Style.Italic",false)) Font->Style=Font->Style << fsItalic;
    else Font->Style=Font->Style >> fsItalic;
  if (IniFile->ReadInteger(Section,Ident+".Style.Underline",false)) Font->Style=Font->Style << fsUnderline;
    else Font->Style=Font->Style >> fsUnderline;
  if (IniFile->ReadInteger(Section,Ident+".Style.StrikeOut",false)) Font->Style=Font->Style << fsStrikeOut;
    else Font->Style=Font->Style >> fsStrikeOut;
  return true;
}
//----------------------------------------------------------------------------
// Создание элемента меню
//----------------------------------------------------------------------------
TMenuItem *CreateMenuItem(char *caption, bool enabled,
    TNotifyEvent click, char *ID, char *ShortCut) {
  TMenuItem *tmp = NewItem(caption, 0, false, enabled, click, 0, ID);
  if (ShortCut != "")
    tmp->ShortCut = TextToShortCut(ShortCut);

  return tmp;
}
//----------------------------------------------------------------------------
// Создание разделительной строки в меню
//----------------------------------------------------------------------------
TMenuItem * CreateSeparator() {
  return CreateMenuItem("-");
}
//---------------------------------------------------------------------
// Удаление подпунктов меню
//---------------------------------------------------------------------
void ClearMenuItem(TMenuItem *MenuItem) {
  if (MenuItem != NULL) {
    int i = MenuItem->Count;
    while (i > 0) {
      MenuItem->Delete(--i);
    }
  }
}
//---------------------------------------------------------------------
// Создать всплывающее меню
//---------------------------------------------------------------------
TPopupMenu* CreatePopup(TWinControl* owner, TMenuItem **Items, int Items_Size, AnsiString Name) {
  return NewPopupMenu(owner, "", paRight, true, Items, Items_Size);
}//--------------------
//-------------------------------------------------
// Вывод сообщения
//---------------------------------------------------------------------
void Message(TStringList *mes) {
  if (Application->MainForm) {
    TWTMessage *Mes = new TWTMessage(Application->MainForm);
    for (int i = 0; i < mes->Count; i++)
      Mes->AddLabel(mes->Strings[i]);
    Mes->Show();
    delete Mes;
  }
  else
    ShowMessage(mes->Text);
}
//---------------------------------------------------------------------
void Message(AnsiString *mes) {
  TStringList * Mes = new TStringList();
  Mes->Add(*mes);
  Message(Mes);
  delete Mes;
}
//---------------------------------------------------------------------
void Message(AnsiString mes) {
  TStringList * Mes = new TStringList();
  Mes->Add(mes);
  Message(Mes);
  delete Mes;
}
//---------------------------------------------------------------------
void Message(int mes) {
  TStringList * Mes = new TStringList();
  Mes->Add(IntToStr(mes));
  Message(Mes);
  delete Mes;
}
//---------------------------------------------------------------------
// Временная функция (выводит сообщение)
//---------------------------------------------------------------------
void _fastcall ClassName(TObject *Sender){
  if (Sender != NULL)
    ShowMessage(String(Sender->ClassName()));
  else
    ShowMessage("NULL");
};
//---------------------------------------------------------------------
// Возвращает размер строки в пикселах
// type
//   0 - Width
//   1 - Height
// При ошибке возвращает -1
//---------------------------------------------------------------------
int StringSize(AnsiString String, TFont *Font, int type) {
  int Size = -1;
  TStaticText *Text = new TStaticText(Application);
  Text->Visible = false;
  Text->Parent = TWTForm::MainForm;
  Text->Font->Charset = Font->Charset;
  Text->Font->Color = Font->Color;
  Text->Font->Height = Font->Height;
  Text->Font->Name = Font->Name;
  Text->Font->Pitch = Font->Pitch;
  Text->Font->Size = Font->Size;
  Text->ParentFont = false;
  Text->Caption = String;
  Text->AutoSize = true;

  if (type == 0) {
    Size = Text->Width;
  }
  else if (type == 1) {
    Size = Text->Height;
  }
  delete Text;
  // Для пустой строки размер 4х4
  return Size;
}
//---------------------------------------------------------------------
// Функции работы с датами
//---------------------------------------------------------------------
TDateTime _fastcall BOM(TDateTime Date) {
unsigned short year, month, day;
  Date.DecodeDate(&year, &month, &day);
//  return EncodeDate(year, month, 1);
  // Так будет быстрее
  return Date - day + 1;
}
//---------------------------------------------------------------------
TDateTime _fastcall EOM(TDateTime Date) {
unsigned short year, month, day;
bool err = true;
  Date.DecodeDate(&year, &month, &day);
  // Дней не может быть больше 31
  day = 31;
  while (err) {
    err = false;
    try {
      Date = EncodeDate(year, month, day);
    }
    
    catch(...) {
      err = true;
      day--;
    }
  }
  return Date;
}
//---------------------------------------------------------------------
TDateTime _fastcall BOY(TDateTime Date) {
unsigned short year, month, day;
  Date.DecodeDate(&year, &month, &day);
  return EncodeDate(year, 1, 1);
}
//---------------------------------------------------------------------
TDateTime _fastcall EOY(TDateTime Date) {
unsigned short year, month, day;
  Date.DecodeDate(&year, &month, &day);
  return EncodeDate(year, 12, 31);
}
//---------------------------------------------------------------------
TDateTime _fastcall StrToDate(AnsiString StrDate, AnsiString Mes) {
TDateTime DateTime;
  try {
    DateTime = StrToDate(StrDate);
  }
  catch (Exception &exception) {
    if (Mes == NULL) {
      throw Exception("Некорректная дата: " + StrDate);
    }
    else
    if (Mes.Length() != 0) {
      throw Exception(Mes);
    }
    return -1;
  }
  return DateTime;
}

bool _fastcall ValidStrDate(AnsiString StrDate, AnsiString Mes) {
TDateTime DateTime;
  try {
    DateTime = StrToDate(StrDate);
  }
  catch (Exception &exception) {
    if (Mes == NULL) {
      //throw Exception("Некорректная дата: " + StrDate);
    }
    else
    if (Mes.Length() != 0) {
      throw Exception(Mes);
    }
    return false;
  }
  return true;
}

//---------------------------------------------------------------------
// Перевод года в формате YY с учетом 2000
//---------------------------------------------------------------------
TDateTime _fastcall SetCentury(TDateTime* DateTime) {
Word Year, Month, Day;
TDateTime DT = *DateTime;
 /* // Считаем что дата должна находиться в промежутке 01.01.1938 - 31.12.2037
  if (DT >= StrToDate("01.01.2038") && DT < StrToDate("01.01.2100")) {
    DT.DecodeDate(&Year, &Month, &Day);
    DT = EncodeDate(Word(Year - 100), Month, Day);
  }      */
  *DateTime = DT;
  return DT;
}
//---------------------------------------------------------------------
TDateTime _fastcall SetCentury(TDateTime DateTime) {
  return SetCentury(&DateTime);
}
//---------------------------------------------------------------------
TDateTime _fastcall SetCentury(AnsiString StrDate) {
TDateTime DateTime;
  try {
    DateTime = StrToDate(StrDate);
  }
  catch (Exception &exception) {
    throw Exception("Некорректная дата.");
  }
  return SetCentury(&DateTime);
}
//---------------------------------------------------------------------
void _fastcall SetCentury(TField* Sender) {
TDateTime DateTime = Sender->AsDateTime;
  DateTime = SetCentury(&DateTime);
  // Для предотвращения повторного вызова функции
  if (double(DateTime) != double(Sender->AsDateTime))
    Sender->AsDateTime = DateTime;
}
//---------------------------------------------------------------------
// Возвращает строку дополненную спереди / сзади символами Chr до
// указанного размера. Если строка больше чем указанный размер
// возвращает исходную строку (не обрезает).
//---------------------------------------------------------------------
AnsiString PadL(AnsiString Str, int Length, char Chr) {
int Len = Str.Length();
  if (Length > Len)
    return AnsiString::StringOfChar(Chr, Length - Len) + Str;
  else
    return Str;
}
//---------------------------------------------------------------------
AnsiString PadR(AnsiString Str, int Length, char Chr) {
int Len = Str.Length();
  if (Length > Len)
    return Str + AnsiString::StringOfChar(Chr, Length - Len);
  else
    return Str;
}

//---------------------------------------------------------------------
AnsiString PadL0(AnsiString Str, int Length) {
  return PadL(Str, Length, '0');
};

//---------------------------------------------------------------------
AnsiString PadL(int Num, int Length, char Chr) {
  return PadL(AnsiString(Num), Length, Chr);
};

//---------------------------------------------------------------------
AnsiString PadL0(int Num, int Length) {
  return PadL(AnsiString(Num), Length, '0');
};

//---------------------------------------------------------------------
AnsiString PadL0(long int Num, int Length) {
  return PadL(AnsiString(Num), Length, '0');
};

//---------------------------------------------------------------------
AnsiString PadL0(double Num, int Length) {
  return PadL(AnsiString(Num), Length, '0');
};

/*// Округление
double Round(double value, int ndec) {
  int decimal, sign;
  char *str = fcvt(value, ndec, &decimal, &sign);
  double tmp = (sign == 0 ? 1 : -1) * atof(str);
  // Дурацкий метод приведения числа в божеский вид
  if (ndec > 0) {
    tmp /= pow(10, ndec);
  }
  else if (ndec < 0) {
    tmp *= pow(10, -ndec);
  }
  return tmp;
}   */
// Выделяет из строки поля для SQL запроса
// имя результирующего поля
// SP_PODR.PLU_NAM as NAME -> NAME
// SP_PODR.NAME -> NAME
AnsiString GetNameSQL(AnsiString NameSQL) {
char *RetPos, *BegPos;
  BegPos = NameSQL.c_str();
  RetPos = BegPos + strlen(BegPos);
  while ((RetPos > BegPos) && (*RetPos != ' ') && (*RetPos != '.')) RetPos--;
  if ((*RetPos == ' ') || (*RetPos == '.')) RetPos++;
  return RetPos;
}
//---------------------------------------------------------------------
// Преобразование строки/символа в boolean по первому символу ("T", "t", не 0 - 1)
//---------------------------------------------------------------------
int atob(char Ch) {
  if (isdigit(Ch))
    return (Ch != '0');
  else
    return (Ch == 'T' || Ch == 't');
}
//---------------------------------------------------------------------
int atob(char *Str) {
  if (atof(Str) != 0)
    return 1;
  if (isdigit(Str[0]))
    return (Str[0] != '0');
  else
    return (Str[0] == 'T' || Str[0] == 't');
}
//---------------------------------------------------------------------
int atob(AnsiString Str) {
  return atob(Str.c_str());
};
//---------------------------------------------------------------------

//---------------------------------------------------------------------
// Дата, строка, число, логическое значение в формате для SQL запроса
//---------------------------------------------------------------------
AnsiString ToStrSQL(TDateTime Date) {
  return " '" + StrToDate(Date) + "' ";
}
//---------------------------------------------------------------------
AnsiString ToStrSQL(AnsiString Str) {
  return " '" + Str + "' ";
}
//---------------------------------------------------------------------
AnsiString ToStrSQL(float Value) {
  return ToStrSQL(double(Value));
}
//---------------------------------------------------------------------
AnsiString ToStrSQL(bool Bool) {
  return Bool ? " true " : " false ";
}
//---------------------------------------------------------------------
AnsiString ToStrSQL(double Value) {
AnsiString Str = AnsiString(Value);
int Pos = Str.Pos(",");
  if (Pos) {
    Str.Delete(Pos, 1);
    Str.Insert(".", Pos);
  }
  return Str;
};
//---------------------------------------------------------------------
AnsiString ToStrSQL(int Value) {
  return ToStrSQL(double(Value));
};
//---------------------------------------------------------------------
AnsiString ToStrSQL(unsigned int Float) {
  return ToStrSQL(double(Float));
};
//---------------------------------------------------------------------
AnsiString ToStrSQL(TWTField *Field) {
  switch (Field->Field->DataType) {
    case ftSmallint:
    case ftInteger:
    case ftWord:
    case ftFloat:
    case ftCurrency:
    case ftBCD:
    case ftAutoInc:
      return ToStrSQL(Field->Field->AsFloat);
    case ftDate:
    case ftTime:
    case ftDateTime:
      return ToStrSQL(Field->Field->AsDateTime);
    case ftString:
    case ftMemo:
    case ftFmtMemo:
    case ftBytes:
    case ftVarBytes:
      return ToStrSQL(Field->Field->AsString);
    case ftBoolean:
      return ToStrSQL(Field->Field->AsBoolean);
    case ftUnknown:
    case ftBlob:
    case ftGraphic:
    case ftParadoxOle:
    case ftDBaseOle:
    case ftTypedBinary:
    case ftCursor:
      return "";
  }
  return "";
};
//---------------------------------------------------------------------
// Окно для ввода
//---------------------------------------------------------------------
class TWTWindow : public TWTMDIWindow {
public:
  TLabel *Label;
  TPanel *Panel;
  TWTEditDate *Edit;
  TDateTime *EditDate;
  TBitBtn *ButOK;

public:
  _fastcall virtual TWTWindow(TWinControl *owner, AnsiString Str, TDateTime* DateTime);
  _fastcall virtual ~TWTWindow();

  void _fastcall FKeyPress(TObject *Sender, char &Key);
  void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);
  void _fastcall ButOKClick(TObject *Sender);
};

//---------------------------------------------------------------------
_fastcall TWTWindow::TWTWindow(TWinControl *owner, AnsiString Str, TDateTime* DateTime) : TWTMDIWindow(owner) {

  AutoScroll= false;
  BorderStyle= bsSingle;

  EditDate = DateTime;

  Panel = new TPanel(this);
  Panel->Left= 0;
  Panel->Top= 0;
  Panel->Anchors= Panel->Anchors>> akTop>> akLeft>> akRight>> akBottom;
  Panel->BevelInner=bvLowered;
  Panel->BevelOuter=bvNone;
  Panel->Parent= this;
  Panel->Width= 190;
  Panel->Height= 100;

  Width= Panel->Width+ 6;
  Height= Panel->Height+ 25;

  Label = new TLabel(this);
  Label->Left = 10;
  Label->Top = 15;
  Label->Font->Style=Label->Font->Style << fsBold;
  Label->Width = StringSize(Str, Label->Font);
  Label->Height = StringSize('A', Label->Font, 1);;
  Label->Caption = Str;
  Label->Parent = Panel;

  Edit = new TWTEditDate(this, DateTime);
  Edit->Left = 10 + Label->Width + 5;
  Edit->Top = 13;
  Edit->OnKeyPress = FKeyPress;
  Edit->Parent= Panel;

  /*
  Graphics::TBitmap *BM=new Graphics::TBitmap();
  BM->LoadFromResourceName(0,"Yes");
  */

  ButOK = new TBitBtn(this);
  ButOK->Caption = "OK";
  ButOK->Glyph->LoadFromResourceName(0,"Yes");
  ButOK->Kind = bkCustom;
  ButOK->Left = ClientWidth/2- ButOK->Width/2;
  ButOK->Top = 53;
  ButOK->ParentFont = true;
  ButOK->ModalResult=mrNone;
  ButOK->Parent = Panel;
  ButOK->OnClick = ButOKClick;

  Position = poScreenCenter;
//  FormStyle= fsMDIChild;
//  Edit->SetFocus();

//  SetNoDeactivate(true);
//  MainForm->MainMenuEnabled(false);

}
//----------------------------------------------------------------------------
_fastcall TWTWindow::~TWTWindow() {
}
//----------------------------------------------------------------------------
void _fastcall TWTWindow::ButOKClick(TObject *Sender){
  *EditDate = SetCentury(Edit->Text);
  ModalResult= 1;
}

//----------------------------------------------------------------------------
void _fastcall TWTWindow::FKeyPress(TObject *Sender, char &Key) {
  // По Enter выходим
  if (Key == '\r') {
    // Введенное значение
    *EditDate = SetCentury(Edit->Text);
    ModalResult = 1;
  }
  if (Key == 27) {
    ModalResult = -1;
  }
}

//----------------------------------------------------------------------------
void __fastcall TWTWindow::OnClose(TObject *Sender, TCloseAction &Action) {
  if (!ModalResult) {
    // Форму не закрываем - она модальная
    Action = caNone;
    ModalResult = -1;
    return;
  }
  TWTMDIWindow::OnClose(Sender, Action);
  SetNoDeactivate(false);
  MainForm->MainMenuEnabled(true);
}
//----------------------------------------------------------------------------
// Запрос даты
// При вводе возвращает true, при отказе false
// Str - строка сообщения
// DateTime - значение по умолчанию (при вводе содержит введенную дату)
//----------------------------------------------------------------------------
bool GetDate(AnsiString Str, TDateTime* DateTime) {
  TWTWindow *Win = new TWTWindow(TWTForm::MainForm, Str, DateTime);
  int Ret= Win->TForm::ShowModal();
  delete Win;
//  Win->Close();
  return  Ret != 2;
}
//----------------------------------------------------------------------------
#include <sys/stat.h>
#include <dir.h>
#include <math.h>

// Создание каталога по полному пути
int MkDirPath(AnsiString Path) {
char Buf[1000];
struct stat statbuf;
  for (int i = 0; i < Path.Length(); i++) {
    if (i > 3 && Path[i + 1] == '\\') {
      Buf[i] = '\0';
      // Проверяем наличие директория
      if(stat(Buf, &statbuf) == -1) {
        if (mkdir(Buf) == -1) {
          return -1;
        }
      }
    }
  Buf[i] = Path[i + 1];
  }
  return 0;
}

//---------------------------------------------------------------------
int Ask(AnsiString Label)             //Организация меню с вопросом "Да" / "Нет"
{
  TMsgDlgButtons Buttons;
  Buttons.Clear();
  Buttons=Buttons << mbYes << mbNo;
  if (MessageDlg(Label,mtConfirmation,Buttons,0)==mrYes) return 1;
  else return 0;
}

//---------------------------------------------------------------------
double Round(double value, int ndec) {
  char Buf[128];
  char StrFormat[16];
  double Ret;
  int i = 0, LenInt, LenDec, FC = 0;

  if (ndec <= 0) {
    sprintf(Buf, "%.2lf", value);
  }
  else {
    // Точность на 2 знака больше чем требуется
    sprintf(Buf, "%d", (int)(ndec + 2));
    strcpy(StrFormat, "%.");
    strcat(StrFormat, Buf);
    strcat(StrFormat, "lf");
    sprintf(Buf, StrFormat, value);
  }

  while (Buf[i] != '.' && Buf[i] != '\0') i++;
  if (Buf[i] == '.') {
    LenInt = i;
    while (Buf[i] != '\0') i++;
    LenDec = i - LenInt - 1;
  }
  else
    if (Buf[i] == '\0') {
      LenInt = i;
      LenDec = 0;
  }

  if (ndec == 0) {
    Buf[LenInt] = '\0';
    if (LenDec > 0 && Buf[LenInt + 1] > '4')
      FC = 1;
  }
  else
  if (ndec > 0) {
    if (Buf[LenInt + 1 + ndec] > '4')
      FC = 1;
    for (i = LenInt + LenDec; i < LenInt + ndec; i++) {
      Buf[i] = '0';
    }
    Buf[LenInt + 1 + ndec] = '\0';
  }
  else
  if (ndec < 0) {
    if (Buf[LenInt + ndec] > '4')
      FC = 1;
    for (i = LenInt + ndec; i < LenInt; i++) {
      Buf[i] = '0';
    }
    Buf[LenInt] = '\0';
  }
  Ret = atof(Buf);

  // Округление в большую сторону
  if (FC) {
    double tmp = 1;
    if (ndec > 0) {
      tmp /= pow(10, ndec);
    }
    else if (ndec < 0) {
      tmp *= pow(10, -ndec);
    }

    if (value >= 0) {
      Ret += tmp;
    }
    else {
      Ret -= tmp;
    }
  }

  return Ret;
}

















//функции для применения во встроенном интерпретаторе

/*TWTValue *SimpleVal(Variant& Value) {
  Variant *V=(Variant*)calloc(1,sizeof(Variant));
  V[0]=NULL;
  V[0]=Value;
  return (new TWTValue("",V,1,1));
}

TWTValue *Array(int X,int Y) {
  Variant *V=(Variant*)calloc(X*Y,sizeof(Variant));
  return (new TWTValue("",V,X,Y));
}

TWTValue *ArrayOfStr(int X,int Y)
{
  return AFILL(Array(X,Y),"");
}

TWTValue *ArrayOfNum(int X,int Y)
{
  return AFILL(Array(X,Y),0.0);
}

TWTValue *CopyArray(TWTValue *Dest,TWTValue *Src){
  for (int x=0;x<min(Src->XDim*Src->YDim,Dest->XDim*Dest->YDim);x++) {
    Dest->Value[x]=Src->Value[x];
  }
  return Dest;
}

TWTValue *AADD(TWTValue *Src,Variant& Elem)  //Добавляет новый элемент в конец массива
{
  if (Src->YDim>1) return CopyArray(Array(Src->XDim,Src->YDim),Src);
  TWTValue *V=CopyArray(Array(Src->XDim+1,Src->YDim),Src);
  V->Value[Src->XDim]=Elem;
  return V;
}

TWTValue *ACLONE(TWTValue* Src)       //Дублирует вложенный или многомерный массив
{
  return CopyArray(Array(Src->XDim,Src->YDim),Src);
}

TWTValue* ACOPY(TWTValue* Src,TWTValue* Dest)        //Копирует элементы одного массива в другой
{
  return CopyArray(Dest,Src);
}

TWTValue *ADEL(TWTValue* Src,int Index)         //Удаляет элемент массива
{
  if ((Src->YDim>1) || (Index>=Src->XDim)) return CopyArray(Array(Src->XDim,Src->YDim),Src);
  TWTValue *V=Array(Src->XDim-1,Src->YDim);
  for (int x=Index;x<(Src->XDim-1);x++) V->Value[x]=Src->Value[x+1];
  return V;
}

TWTValue *AFILL(TWTValue* Src,Variant& Value)        //Заполняет массив заданным значением
{
  TWTValue* V=Array(Src->XDim,Src->YDim);
  for (int x=0;x<Src->YDim*Src->XDim;x++) V->Value[x]=Value;
  return V;
}

TWTValue* AINS(TWTValue* Src,int Index,Variant& Elem)         //Заносит элемент со значением NIL в массив
{
  if ((Src->YDim>1) || (Index>=Src->XDim)) return CopyArray(Array(Src->XDim,Src->YDim),Src);
  TWTValue *V=Array(Src->XDim+1,Src->YDim);
  for (int x=Index;x<(Src->XDim+1);x++) V->Value[x+1]=Src->Value[x];
  return V;
}

int ASCAN(TWTValue* Src,Variant& Elem)        //Просматривает массив на совпадение с заданным значением
{
  TWTValue* V=Array(Src->XDim,Src->YDim);
  for (int x=0;x<Src->XDim*Src->YDim;x++) if (Src->Value[x]==Elem) return 1;
  return 0;
}

TWTValue *ASIZE(TWTValue* Src,int X,int Y)        //Увеличивает или уменьшает размер массива
{
  CopyArray(Array(X,Y),Src);
}

TWTValue* ASORT(TWTValue* Src)        //Сортирует массив
{
  TWTValue* V=Array(Src->XDim,Src->YDim);
  Variant VV=Src->Value[0];
  for (int x=0;x<(Src->XDim*Src->YDim);x++)
    for (int y=x;y<(Src->XDim*Src->YDim)
      V
}
*/
/*
Variant ATAIL(TWTValue* Src)        //Возвращает элемент массива с наибольшим номером
{
  return (Src->Value[Src->XDim*Src->YDim-1]);
}
*/
AnsiString CDOW(AnsiString Date)         //Преобразует значение даты в символьное название дня недели
{
  try {
    switch (DayOfWeek(StrToDate(Date))) {
      case 1: return "воскресенье";
      case 2: return "понедельник";
      case 3: return "вторник";
      case 4: return "среда";
      case 5: return "четверг";
      case 6: return "пятница";
      case 7: return "суббота";
    };
  } catch (...) {
    return "";
  }
}

AnsiString CHR(int Value)          //Преобразует код ASCII в его символьное значение
{
  return AnsiString(char(Value));
}

AnsiString CMONTH(AnsiString Date)       //Преобразует дату в символьное название месяца
{
  try {
    unsigned short Year,Month,Day;
    StrToDateTime(Date).DecodeDate(&Year,&Month,&Day);
    switch (Month) {
       case 1: return "январь";
       case 2: return "февраль";
       case 3: return "март";
       case 4: return "апрель";
       case 5: return "май";
       case 6: return "июнь";
       case 7: return "июль";
       case 8: return "август";
       case 9: return "сентябрь";
       case 10: return "октябрь";
       case 11: return "ноябрь";
       case 12: return "декабрь";
    };
  } catch (...) {
    return "";
  }
}

int DAY(AnsiString Date)          //Возвращает номер дня в виде числа
{
  try {
    unsigned short Year,Month,Day;
    StrToDateTime(Date).DecodeDate(&Year,&Month,&Day);
    return Day;
  } catch (...) {
    return 0;
  }
}

int DOW(AnsiString Date)          //Преобразует значение даты в числовое значение дня недели
{
  try {
    int Year,Month,Day;
    return StrToDateTime(Date).DayOfWeek();
  } catch (...) {
    return 0;
  }
}

AnsiString DTOS(AnsiString Date)         //Преобразует значение даты в строку символов формата ггггммдд
{
  try {
    unsigned short Year,Month,Day;
    StrToDateTime(Date).DecodeDate(&Year,&Month,&Day);
    return IntToStr(Year)+IntToStr(Month)+IntToStr(Day);
  } catch (...) {
    return "";
  }
}

int ISALPHA(AnsiString Value)      //Определяет, является ли самый левый символ в строке буквой
{
  if (Value=="") return 0;
  int v=Value[1];
  if (((v>64) && (v<91)) || ((v>96) && (v<123)) || ((v>127) && (v<176)) || ((v>223) && (v<240))) return 1;
  return 0;
}

int ISDIGIT(AnsiString Value)      //Определяет, является ли первый символ в строке цифрой
{
  if (Value=="") return 0;
  int v=Value[1];
  if ((v>47) && (v<58)) return 1;
  return 0;
}

int ISLOWER(AnsiString Value)      //Определяет, является ли первый символ строчной буквой
{
  if (Value=="") return 0;
  int v=Value[1];
  if (((v>96) && (v<123)) || ((v>159) && (v<176)) || ((v>223) && (v<240))) return 1;
  return 0;
}

int ISUPPER(AnsiString Value)      //Определяет, является ли первый символ заглавной буквой
{
  if (Value=="") return 0;
  int v=Value[1];
  if (((v>64) && (v<91)) || ((v>127) && (v<160))) return 1;
  return 0;
}

AnsiString LEFT(AnsiString Src, int Size)         //Определяет подстроку, начиная с первого символа в строке
{
  if (Size>Src.Length()) return Src;
  char *ss=Src.c_str();
  ss[Size]=0;
  return ss;
}

AnsiString LTRIM(AnsiString Src)        //Удаляет начальные пробелы из символьной строки
{
  int x=1;
  if (Src.Length()==0) return "";
  while (Src[x]==32){
    x++;
    if (x==Src.Length()) return "";
  }
  return Src.c_str()+x-1;
}

int MONTH(AnsiString Date)        //Определяет по значению даты номер месяца
{
  try {
    unsigned short Year,Month,Day;
    StrToDateTime(Date).DecodeDate(&Year,&Month,&Day);
    return Month;
  } catch (...) {
    return 0;
  }
}

int AT(AnsiString Src,AnsiString SubStr)          //Возвращает позицию первого вхождения подстроки
{
  char *s=Src.c_str();
  char *ss=strstr(s,SubStr.c_str());
  if (ss==NULL) return 0;
  return ss-s+1;
}

AnsiString RIGHT(AnsiString Src,int Size)        //Возвращает подстроку, начиная с самого правого символа
{
  if (Size>Src.Length()) return Src;
  return Src.c_str()+Src.Length()-Size;
}

int RAT(AnsiString Src,AnsiString SubStr)          //Возвращает позицию первого вхождения подстроки
{
  char *s=Src.c_str();
  char *ss=strstr(s,SubStr.c_str());
  if (ss==NULL) return 0;
  else {
    int x=RAT(RIGHT(Src,Src.Length()-int(ss-s+1)),SubStr);
    if (x>0) return x+int(ss-s+1);
  }
  return ss-s+1;
}

AnsiString RTRIM(AnsiString Src)        //Удаляет конечные пробелы из символьной строки.
{
  int x=Src.Length();
  if (x==0) return "";
  while (Src[x]==32) {
    x--;
    if (x==0) return "";
  }
  return LEFT(Src,x);
}

AnsiString SPACE(int Number)        //Возвращает строку пробелов
{
  AnsiString a="";
  for (int x=0;x<=Number;x++) a+=" ";
  return a;
}

 AnsiString STRTRAN(AnsiString Src,AnsiString Find,AnsiString Replace)      //Ищет и заменяет символы в символьной строке или memo-поле
{
  int x=AT(Src,Find);
  if (x==0) return Src;
  Src=LEFT(Src,x-1)+Replace+STRTRAN(RIGHT(Src,Src.Length()-x-Find.Length()+1),Find,Replace);
  return Src;
}

int YEAR(AnsiString Date)         //Преобразует значение даты в номер года в числовом виде
{
  try {
    unsigned short Year,Month,Day;
    StrToDateTime(Date).DecodeDate(&Year,&Month,&Day);
    return Year;
  } catch (...) {
    return 0;
  }
}

AnsiString ALLTRIM(AnsiString Src)       //Удаляет ведущие и замыкающие пробелы в строке символов
{
  return LTRIM(RTRIM(Src));
}

AnsiString SUBSTR(AnsiString Src,int Start,int End)       //Выделяет подстроку из символьной строки
{
  if (Start>End) return Src;
  return LEFT(RIGHT(Src,Src.Length()-Start),End-Start);
}
/*
int Ask(AnsiString Label)             //Организация меню с вопросом "Да" / "Нет"
{
  TMsgDlgButtons Buttons;
  Buttons.Clear();
  Buttons=Buttons << mbYes << mbNo;
  if (MessageDlg(Label,mtConfirmation,Buttons,0)==mrYes) return 1;
  else return 0;
} */
  /*
TWTValue *ArrayOfUnique(int X,int Y)         //Получение массива из уникальных элементов
{
  TWTValue *V=Array(X,Y);
  for (int x=0;x<X*Y;x++) {
    V->Value[x]=x;
  }
  return V;
}

TWTValue *DelimLine(AnsiString Src,AnsiString Delims)       //Разбиение строки на массив подстрок заданной длины
{
  char *c=Src.c_str();
  TWTValue *V=Array(1,1);
  TWTValue *VV;
  V->Value[0]=AnsiString(strtok(Src.c_str(),Delims.c_str()));
  while (c) {
    c=strtok(0,Delims.c_str());
    VV=AADD(V,AnsiString(c));
    delete V;
    V=VV;
  }
  return V;
}
    */


