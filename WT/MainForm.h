//----------------------------------------------------------------------------
#ifndef MainFormH
#define MainFormH
//----------------------------------------------------------------------------
#include <vcl\ComCtrls.hpp>
#include <vcl\Buttons.hpp>
#include "include\ZEOS\ZConnect.hpp"
#include "include\ZEOS\ZPgSqlCon.hpp"
#include "include\ZEOS\ZPgSqlQuery.hpp"
#include "include\ZEOS\ZPgSqlTr.hpp"
#include "Func.h"
#include "Form.h"
#include "About.h"
#include "SetQuery.h"
#include "ReportView.h"

//#include "ScriptForm.h"
//----------------------------------------------------------------------------

//typedef TWTValue* __fastcall (__closure *TWTFuncEvent)(AnsiString FuncName,int ParamCount,TWTValue *Param[100]);
//typedef TWTValue* __fastcall (__closure *TWTMultiVarsEvent)(TStringList *MultiVars);

typedef void __fastcall (__closure *TWTShowWindowsEvent)(TStringList* SL);

/*class TWTScriptForm;
class TWTTPC;      */

class TWTValue;

enum TWTMainFormOption { foHelp, foScriptEditor, foExit };
typedef Set<TWTMainFormOption, foHelp, foExit>  TWTMainFormOptions;


class TWTRegistry;
class TWTWinDBGrid;

class TWTMainForm : public TWTForm {
private:
  TWTToolButton* ExitButton;
  TWTToolButton* ScriptButton;
  TWTToolButton* HelpButton;

  TWTMainFormOptions FOptions;
  TStringList *StartScript;
  TStringList *CloseScript;
  TWTToolBar *MainToolBar;
//  TToolBar *SecondToolBar;
//  TToolBar *ThirdToolBar;
  void __fastcall SavePropertyToIni();
  void __fastcall RestorePropertyFromIni();
  void __fastcall ShowHint(TObject *Sender);
  void virtual __fastcall OnClose(TObject *Sender);
  void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);
  void __fastcall FOnActiveFormChange(TObject *Sender);
  void __fastcall FOnEditMenuItemClick(TObject *Sender);
//  TWTValue* __fastcall FindRegValue(TStringList *MultiVars);
 // int __fastcall SetRegValue(TStringList *MultiVars,TWTValue *Value);

  void __fastcall FBeforePost();
  void __fastcall SayCompError(int ErrorNum);

  void __fastcall SetOptions(TWTMainFormOptions Value);

  void __fastcall OnShowMainForm(TObject *Sender);

public:
  TZPgSqlDatabase *InterDatabase;
  TZPgSqlTransact *InterTransaction;
  TWTToolBar *WindowToolBar;
  __property TWTMainFormOptions Options = {read=FOptions, write=SetOptions};

  TWTShowWindowsEvent OnShowActiveWindows;
  TMemIniFile* GlobalIniFile;
  TMemIniFile* IniFile;
  TMemIniFile* StartupIniFile;
  TWTRegistry *Registry;
  //TZPgSqlDatabase *Database;
  //TZPgSqlDatabase *Transaction;
 // TWTTPC *TPComp;
  Variant Value,Result;
//  TWTScriptForm *ScriptForm;
  TWTReportView* PreviewForm;
//  TWTValue* __fastcall MakeFunction(AnsiString FuncName,int ParamCount,TWTValue *Param[100]);
//  TWTValue* __fastcall MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100]);
//  int __fastcall CheckParams(TStringList *MultiVars,int ParamCount,TWTValueStack *Params);

  // Получение полного имени таблицы
  // Если таблица отсутствует - создается
  //---------------------------------------------------------------------
  // AbsentAct
  //   0 - Сформировать строку, проверить наличие таблицы, если отсутствует создать
  //   1 - Сформировать строку и проверить наличие таблицы
  //   2 - Сформировать строку
  // При возникновении ошибки возвращает ""
  //---------------------------------------------------------------------
  AnsiString __fastcall CreateFullTableName(AnsiString Name, TDateTime *DatePar = NULL,
      AnsiString Str1 = "", AnsiString Str2 = "", AnsiString Str3 = "",
      int AbsentAct = 0);

  // Проверка наличия таблицы без создания
  AnsiString __fastcall IsFullTableName(AnsiString Name, TDateTime *DatePar = NULL,
      AnsiString Str1 = "", AnsiString Str2 = "", AnsiString Str3 = "") {
      return CreateFullTableName(Name, DatePar, Str1, Str2, Str3, 1);
  }

  // Формирование полного имени таблицы
  AnsiString __fastcall FullTableName(AnsiString Name, TDateTime *DatePar = NULL,
      AnsiString Str1 = "", AnsiString Str2 = "", AnsiString Str3 = "") {
      return CreateFullTableName(Name, DatePar, Str1, Str2, Str3, 2);
  }

  void __fastcall Status(AnsiString Text = NULL);
  void _fastcall OnToolButton1Click(TObject* Sender);
  virtual _fastcall TWTMainForm(TComponent *owner);
  virtual _fastcall ~TWTMainForm();
  void virtual __fastcall InitMenu();
  void _fastcall LoadReport(TObject* Sender);
  void _fastcall LoadFilter(TObject* Sender);
  void _fastcall ReportClick(TObject* Sender);
  void _fastcall FilterClick(TObject* Sender);
  void _fastcall ReportWizardClick(TObject* Sender);
  void _fastcall TableMenuClick(TObject* Sender);

  // Вызывается при изменениях в активных/неактивных окнах
  void virtual __fastcall OnActiveMainFormChange() {};

  // Активизирует MDIChild окно с заголовком Name (при Enabled == false не активизирует)
  // При отсутствии возвращет 0 иначе 1
  // Окно ищется в меню WindowMenuItem
  int __fastcall ShowMDIChild(AnsiString Name,TComponent *Owner=NULL);

  // функции вызываемые из меню
  void _fastcall CascadeMenu(TObject *Sender);
  void _fastcall TileMenu(TObject *Sender);
  void _fastcall CloseCurrMenu(TObject *Sender);
  void _fastcall CloseAllMenu(TObject *Sender);
  void _fastcall MinimizeCurrMenu(TObject *Sender);
  void _fastcall MinimizeAllMenu(TObject *Sender);
  void _fastcall NormalAllMenu(TObject *Sender);
  void _fastcall HelpMenu(TObject *Sender);
  void _fastcall AboutMenu(TObject *Sender);
  void _fastcall CloseMainForm(TObject *Sender);
  void _fastcall RunScriptEditor(TObject *Sender);

  //Работа с транслятором
//  TWTFunc* __fastcall RegisterFunc(AnsiString Name,TWTFuncEvent Event);

  //Работа с программным реестром
  TWTWinDBGrid* __fastcall ShowBrowse(AnsiString ID);
};
//----------------------------------------------------------------------------
//программный реестр

#define riBrowse 1

class TWTRegItem: public TObject {
public:
  int ItemType;
  AnsiString ID;
  virtual TWTValue* __fastcall FindParamValue(TStringList *MultiVars);
  virtual int __fastcall SetParamValue(TStringList *MultiVars,TWTValue *Value);
  virtual int __fastcall MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100],TWTValue *ReturnValue);
};

class TWTRegCol: public TObject {
public:
  __fastcall ~TWTRegCol();
  AnsiString Name;
  AnsiString Label;
  AnsiString FullLabel;

  bool IsUnique;
  AnsiString UniqueError;
  AnsiString TableName;
  bool IsRange;
  Variant MinValue;
  Variant MaxValue;
  AnsiString RangeError;
  bool IsFixedVariables;
  TWTFixedVariables* FixedVariables;
  bool IsValue;
  Variant Value;
  bool IsRequired;
  AnsiString RequiredError;
  bool IsFill;
  char FillChar;
  int FillSize;
  TTEventField OnHelp;

  int SetUnique(AnsiString TableName,AnsiString ErrorString);
  int SetRange(Variant& Min,Variant& Max,AnsiString ErrorString = NULL);
  int AddFixedVariable(AnsiString DBValue,AnsiString RealValue);
  int SetDefValue(Variant& Value);
  int SetRequired(AnsiString ErrorString);
  int SetFill(int FillSize,char FillChar);
  void SetOnHelp(TTEventField FOnHelp = NULL);
};

class TWTRegColsList: public TList {
public:
  __fastcall ~TWTRegColsList();
  TWTRegCol* Get(int Index) {return (TWTRegCol*)Items[Index];};
  void AddCol(TWTRegCol* RC) {Add(RC);};
};

class TWTRegField: public TObject {
public:
  AnsiString FName;
  AnsiString KeyField;
  AnsiString LookupTableName;
  AnsiString LookupFName;
  //AnsiString LookupKeyFields;
};

class TWTRegFieldsList: public TList {
public:
  __fastcall ~TWTRegFieldsList(){
    for (int x=0;x<Count;x++) delete (TWTRegField*)Items[x];
  };
  TWTRegField* Get(int Index) {return (TWTRegField*)Items[Index];};
  void AddField(TWTRegField* RF) {Add(RF);};
};

class TWTBrowseRegItem: public TWTRegItem {
public:
  __fastcall TWTBrowseRegItem(AnsiString ItemID);
  __fastcall TWTBrowseRegItem(AnsiString ItemID,AnsiString TableName);
  __fastcall ~TWTBrowseRegItem();
  virtual TWTValue* __fastcall FindParamValue(TStringList *MultiVars);
  virtual int __fastcall SetParamValue(TStringList *MultiVars,TWTValue *Value);
  virtual int __fastcall MakeRegFunction(TStringList *MultiVars,int ParamCount,TWTValue *Param[100],TWTValue *ReturnValue);
  AnsiString Caption;
  AnsiString TableName;
  TStringList *SQL;
  TWTRegColsList *ColsInfo;
  TWTRegFieldsList *FieldsInfo;
  TList *Browses;
  TWTRegCol* AddColumn(AnsiString Name, AnsiString Label, AnsiString FullLabel = NULL);
  TWTRegField *AddLookupField(AnsiString FName, AnsiString KeyField, AnsiString LookupTableName,AnsiString LookupFName);
};

class TWTRegistry: public TList {
public:
  __fastcall ~TWTRegistry();
  TWTRegItem* Get(int Index) {return (TWTRegItem*)Items[Index];};
  int AddItem(TWTRegItem* RI);
  TWTRegItem* ItemByID(AnsiString ID);
  int GetType(int Index) {return ((TWTRegItem*)Items[Index])->ItemType;};
};

#endif
