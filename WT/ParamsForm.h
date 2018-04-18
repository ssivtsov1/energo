//---------------------------------------------------------------------------
#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
class TWTParamsList;
class TWTParamItem;
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Mask.hpp>
#include <db.hpp>
#include <dbctrls.hpp>
#include <dbtables.hpp>
#include "form.h"
#include "wtgrids.h"
#include "dbgrid.h"
//---------------------------------------------------------------------------

#define pkSimple 0
#define pkDate 1
#define pkMask 2
#define pkDb 3
#define pkUnknown 4
#define pkTime 5
#define pkText 6
#define pkGrid 7
#define pkBtn  8

class TWTParamItem;
class TWTPanel;
class TWTParamsForm;

typedef AnsiString __fastcall (__closure *TParamEvent)(TWTParamItem* Sender);
typedef void __fastcall (__closure *TAcceptEvent)(TWTParamsForm* Sender,bool &CloseFlag);

class TWTParamsForm : public TWTMDIWindow
{
private:
  TWTPanel* Panel;
  TSpeedButton* SBOk;
  void __fastcall FOnClick(TObject *Sender);
  void __fastcall FOnShow(TObject *Sender);
  void __fastcall FOnUserKeyPress(TObject* Sender, char &Key);
  void __fastcall FOnUserClose(TObject *Sender, TCloseAction &Action);
public:
  TWTParamsList* Params;
  __fastcall TWTParamsForm(TComponent* Owner,AnsiString Caption);
  __fastcall ~TWTParamsForm();
  TAcceptEvent OnAccept;
};

class TWTParamsList: public TList {
friend class TWTParamsForm;
friend class TWTParamItem;
protected:
  TWTPanel* FParentPanel;
  void __fastcall InsertToPanel(TWTParamItem *Param);
  int LabelLen;
  int CurY;
  int MaxX;
  int CurX;
  TWTParamItem* AddEditParam(AnsiString Label,int EditLen,AnsiString Text,bool Break=true);

public:
  bool AutoBreak;
  __fastcall TWTParamsList(TWTPanel *Panel);
  __fastcall ~TWTParamsList();
  __property TWTPanel* ParentPanel = {read=FParentPanel, nodefault};
  TWTParamItem* Get(int Index) {return (TWTParamItem*)Items[Index];};
  TWTParamItem* AddDb(AnsiString Label,TZDataset* DataSet,AnsiString FieldName,int EditLen,bool Break=true);
  TWTParamItem* AddSimple(AnsiString Label,int EditLen,AnsiString Text,bool Break=true);
  TWTParamItem* AddDate(AnsiString Label,int EditLen,bool Break=true);
  TWTParamItem* AddTime(AnsiString Label,int EditLen,bool Break=true);
  TWTParamItem* AddMask(AnsiString Label,int EditLen,AnsiString Mask,bool Break=true);
  TWTParamItem* AddText(AnsiString Text,int PanelLen,TFont *TextFont, TAlignment TextAlign, bool Break=true);
  TWTParamItem* AddGrid(TWTDBGrid* DBGrid, bool Break=true);
  //TParamItem* AddButton(TWTPanel *Panel,TButton *Button, bool Break=true);
  TWTParamItem* AddButtonParam(TButton *Btn,bool Break=true);
 // TWTParamItem* AddButton(TButton *Btn,bool Break=true);
  TWTParamItem* AddButton(TButton* Button, bool Break=false);
  TFont* LabelFont;
  TFont* DataFont;
  AnsiString ButtonPic;
  int LabelAlign; //0 - по левому краю; 1 -  по правому
  int Dist; //расстояние между параметрами по вертикали
};

class TWTParamItem: public TComponent {
friend class TWTParamsForm;
friend class TWTParamsList;
friend class TWTPanel;
friend class TWTDoc;
protected:
  TPanel* BottomPanel; //Панел лежащий под панелом самого параметра. Формирует горизонтальную линию
  TLabel* Label;
  TButton* TextButton;
  TWinControl* FControl;
//  TDBEdit* DbEdit;
//  TMaskEdit *Edit;
  TSpeedButton* Button;
  TPanel* Panel;
  bool Break;     //переносить параметр на новую строку при отображении
  int Kind;
  TParamEvent Event; //Пользовательский обработчик нажатия на кнопку
  TWTParamsList* FParamsList;

  void __fastcall OnButtonClick(TObject* Sender);
  void __fastcall OnDbEditChange(TObject* Sender);
  void __fastcall OnEditChange(TObject* Sender);
  void __fastcall OnEditKeyPress(TObject* Sender,char& Key);
  void SetValue(AnsiString Text);
  AnsiString GetValue();
  void __fastcall SetID(AnsiString ID);
  AnsiString __fastcall GetID();
  TWTParamsList* GetPList() {return FParamsList;};

  TZDataset* DataSet;
  AnsiString SourceField;
  bool Required;  //обязательное наличие вводимого значения в таблице
                  //только не для Db параметров
public:
  AnsiString TempValue;
  __property AnsiString Value = {read=GetValue, write=SetValue};
  __property TWinControl* Control = {read=FControl, nodefault};
  __property AnsiString ID = {read=GetID, write=SetID};
  __property TWTParamsList* ParamsList = {read=GetPList, nodefault};
  __property int Type = {read=Kind, nodefault};

  __fastcall TWTParamItem(TComponent* Owner);
  __fastcall ~TWTParamItem();
  TSpeedButton *SetButton(TParamEvent OnClick);
  void SetReadOnly(bool Value);
    //установить связывание поля с конкретным столбцом в таблице
    //(используется с Required)
  void SetRequired(TZDataset* DataSet,AnsiString FieldName);
};

//Классы для построения форм типа: значение - true/false, ...


typedef bool __fastcall (__closure *TWTAcceptEvent)(TWTMDIWindow *Sender,TStringList *CaptionsList,bool *CheckedList);

class TWTCheckingForm : public TWTMDIWindow
{
private:
  TPanel* Panel;
  TSpeedButton* SBOk;
  TList *ItemsList;
  void __fastcall FOnClick(TObject *Sender);
  void __fastcall FOnShow(TObject *Sender);
  void __fastcall FOnKeyPress(TObject* Sender, char &Key);
  void __fastcall FOnClose(System::TObject* Sender, TCloseAction &Action);
  int Index;
public:
  bool __fastcall IsCheck(AnsiString Caption);
  int __fastcall AddItem(AnsiString Caption,bool Checked);
  void __fastcall CheckItem(AnsiString Caption);
  void __fastcall UnCheckItem(AnsiString Caption);
  void __fastcall CheckItem(int Index);
  void __fastcall UnCheckItem(int Index);
  void GetAllCaptions(TStringList *CaptionsList);
  TWTAcceptEvent OnAccept;

  __fastcall TWTCheckingForm(TComponent* Owner,AnsiString Caption);
  __fastcall ~TWTCheckingForm();
};

class TWTDoc: public TWTMDIWindow {
protected:
  bool ConstrMode;
  TComboBox *CBox;
  TPopupMenu* NamesMenu;
  TWTPanel *FMainPanel;
  TPanel *ButtonPanel;
  TWTCellGrid *FGrid;
  TList* GridsList;
  int CurrentGrid;
  TPageControl* PageControl;
  TTabSheet* MainTabSheet;
  TTabSheet* GridTabSheet;
  int FGridNum;
  TShape* OldPen;
  TShape* OldFill;
  TWTToolBar* GridToolBar;
  bool FConstructor;

  void __fastcall SetGridNum(int Value);
  TWTCellGrid* __fastcall GetGrid();

  void __fastcall FOnShow(TObject *Sender);
  void __fastcall PrintDoc(TObject* Sender);
  void __fastcall RefreshValues(TObject* Sender);
  void __fastcall RefreshPanelValues(TWTPanel* Panel,bool R);
  void __fastcall ShowNamesList(TObject* Sender);
  void __fastcall AddGridToDoc(TObject* Sender);
  void __fastcall OnNewDoc(TWTParamsForm* Sender,bool &CloseFlag);
  void __fastcall NextGrid(TObject* Sender);
  void __fastcall PrevGrid(TObject* Sender);
  void __fastcall SaveDoc(TObject* Sender);
  void __fastcall DelDoc(TObject* Sender);
  void __fastcall NamesMenuChoose(TObject* Sender);
  void __fastcall LeftAlign(TObject* Sender);
  void __fastcall HCenterAlign(TObject* Sender);
  void __fastcall RightAlign(TObject* Sender);
  void __fastcall TopAlign(TObject* Sender);
  void __fastcall VCenterAlign(TObject* Sender);
  void __fastcall BottomAlign(TObject* Sender);
  void __fastcall FontProps(TObject* Sender);
  void __fastcall ImportDoc(TObject* Sender);
  void __fastcall ExportDoc(TObject* Sender);
  void __fastcall ShowGridToolBar(TObject* Sender);

  void __fastcall BorderAll(TObject* Sender);
  void __fastcall BorderOuter(TObject* Sender);
  void __fastcall BorderInner(TObject* Sender);
  void __fastcall BorderTop(TObject* Sender);
  void __fastcall BorderLeft(TObject* Sender);
  void __fastcall BorderRight(TObject* Sender);
  void __fastcall BorderBottom(TObject* Sender);
  void __fastcall BorderNone(TObject* Sender);
  void __fastcall Filling(TObject* Sender);
  void __fastcall Image(TObject* Sender);
  void __fastcall JoinCells(TObject* Sender);
  void __fastcall CancelJoin(TObject* Sender);
  void __fastcall GridMode(TObject* Sender);
  void __fastcall DrawColorPanel();
  void __fastcall ChooseColor(System::TObject* Sender, TMouseButton Button, Classes::TShiftState Shift, int X, int Y);
  void __fastcall SetConstructor(bool Value);
  void __fastcall OnClose(TObject* Sender, TCloseAction &Action);
public:
  TColor FillingColor;
  TColor PenColor;
  AnsiString DocFile;
  __property TWTPanel* MainPanel = {read = FMainPanel};
  __property TWTCellGrid* Grid = {read = GetGrid};
  __property int GridNum = {read = FGridNum, write = SetGridNum};
  __property bool Constructor = {read = FConstructor, write = SetConstructor};

  virtual __fastcall TWTDoc(TComponent* AOwner,AnsiString FName="");
  virtual __fastcall ~TWTDoc();
  bool __fastcall LoadFromFile(AnsiString FileName);
  bool __fastcall SaveToFile(AnsiString FileName);
};

class TWTPanel: public TPanel {
protected:
  TList* LinePanels;
  TBevelCut SavedBevelInner;
  TBevelCut SavedBevelOuter;
  int SavedHeight;
  int SavedWidth;
  void __fastcall FDoEnter(TObject* Sender);
  void __fastcall FDoExit(TObject* Sender);
  void __fastcall SetAlignByClient(bool Value);
  bool Breaked;
  TWinControl* ActiveControl;
  bool FAlignByClient;
public:
  __property bool AlignByClient = {read = FAlignByClient, write = SetAlignByClient};
  TList* ValuePanels;
  TWTPanel *ParentPanel;
  int RealWidth;
  int RealHeight;
  virtual __fastcall TWTPanel(TComponent* AOwner);
  virtual __fastcall ~TWTPanel();
  void __fastcall AlignSize();
  //если W или H >0 && <1 размеры панели устанавливаются в процентах от парент панели
  TWTPanel* __fastcall InsertPanel(float W,bool Break=false,float H=50);
  TSplitter* __fastcall SetVResize(int MinSize=50);
  TSplitter* __fastcall SetHResize(int MinSize=50);
  TWTParamItem* __fastcall ParamByID(AnsiString ID);
  void __fastcall ParamsByType(int Type,TList* List);
  TWTParamsList* Params;
};


#endif
