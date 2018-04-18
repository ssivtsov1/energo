//----------------------------------------------------------------------------
#ifndef FormH
#define FormH
//----------------------------------------------------------------------------
#include <vcl\Dialogs.hpp>

#include "Func.h"
#include "List.h"
#include "SetQuery.h"
#include "Edit.h"
#include "Common.h"
#include <inifiles.hpp>
#include <registry.hpp>
//----------------------------------------------------------------------------
// ����� ��� ����������� WinTools TEXHO+
//----------------------------------------------------------------------------
class TWTForm : public TForm {
private:
  // ������ �������� / ���������� �� ��������� ������� ����
  // (����������� ���� ��� ��� �������� ������� �����)
  static TList *ActivateItem;
  static TList *DeactivateItem;

  // �������������� ���� �� ���������
  void RestoreMenuDefault();

protected:

  // ����������� �������
  void virtual __fastcall FOnActivate(TObject *Sender);
  void virtual __fastcall FOnShow(TObject *Sender);
  void virtual __fastcall FOnDeactivate(TObject *Sender);
  void virtual __fastcall FOnClose(TObject *Sender, TCloseAction &Action);
  virtual void __fastcall FOnResize(TObject *Sender);

public:
  TCustomImageList *ImageList1;
  // ���������� ������������� � ������� ����� ������
  // ��������� �� ������ ����� ������ (�� ����� ���� ��� TWTMainForm)
  static TWTForm *MainForm;
  static TDataSource *FilterSource;
  static TTable *FilterTable;
  static bool RefreshFlag;
  static int DialogCount;
  static TMemIniFile* IniFile;

  // ��������� �� ������� ���� ������
  static TMainMenu *MainMenu;
  // ��������� �� ���� ������������ ��� ���� (����� ���� NULL)
  static TMenuItem *UserMenuItem;
  // ������� ������
  static TDateTime MMGG;
  // ��������� �� ���� ���� ������
  static TWTSetupQuery *BaseSetup;
  static TWTSetupQuery *BaseFilter;
  //������ �������
  static TWTCoolBar *MainCoolBar;
  // ������ �������� ����
  static TMenuItem *InDocMenuItem;      // ��������� �� ���� �������� ����������
  static TMenuItem *OutDocMenuItem;     // ��������� �� ���� �������� ����������
  static TMenuItem *ServiseMenuItem;
  static TMenuItem *HelpMenuItem;
  static TMenuItem *WindowMenuItem;     // ������ ����
  static TMenuItem *QuitMenuItem;
  static TMenuItem *ReportMenuItem;     // ��������� �� ���� �������� �������
  static TMenuItem *FilterMenuItem;
  static TMenuItem *TableMenuItem;

  // ������� HelpMenuItem
  static TMenuItem *HelpItem;           // ������
  static TMenuItem *AboutItem;          // � ���������
   
  // ������ ��������
  static TStatusBar *StatusBar;

  // ��������� ����
  static TWTSetupQuery *SetupQuery;
  // ���������� ������� � ������� ����
  static int MainMenuCount;

public:

  TToolButton* _fastcall AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick,int Num);
  _fastcall TWTForm(TComponent *owner);
  _fastcall virtual ~TWTForm();
  TWinControl *FindToolBar(int Tag);

  bool ButtonStates[100];

  // ���������� ��� ����������� ����
  void __fastcall virtual OnActivate(TObject *Sender) {};
  // ���������� ��� ����������� ����
  void __fastcall virtual OnShow(TObject *Sender) {};
  // ���������� ��� ������������ ����
  void __fastcall virtual OnDeactivate(TObject *Sender) {};
  // ���������� ��� �������� �����
  void __fastcall virtual OnClose(TObject *Sender, TCloseAction &Action) {};
  // ���������� ��� ��������� �������
  void __fastcall virtual OnResize(TObject *Sender) {};
  // ��������� ������ ��������/���������� ����
  void __fastcall BuildActivateItem(TMenuItem *MenuItem);
  // �����������/������������� ������� ����
  void virtual __fastcall InitMenu() {};

  // �����������/������������� ����
  void __fastcall MainMenuEnabled(bool Enabled = true);

  // �������� ����� (������������ delete ������ - �� ���������� �������� ����������� �������� �����)
  void virtual __fastcall Close(TObject *Sender = NULL);

  // ���������� ����������� ���� ���� (�� ����)
  void __fastcall ShowPopup(TObject *Sender);
};
//----------------------------------------------------------------------------
// MDI ����
//----------------------------------------------------------------------------
class TWTMDIWindow : public TWTForm {
protected:
  // ��������� � true ��������� ���������� � ������ ����� ����������
  bool NoDeactivate;

  // ��������� �� ����� ���� � ������ ���� ����
  TMenuItem *WindowMenu;
  TWTCoolBar* FCoolBar;
  AnsiString FID;
  void __fastcall FSetID(AnsiString Value);

private:
  void SetEnabledMDI();
  TCoolBand *FindCoolBand(TToolBar *TB);

public:
  __property TWTCoolBar* CoolBar = {read=FCoolBar, nodefault};
  __property AnsiString ID = {read=FID, write=FSetID};
  bool FilterFlag;
  TToolBar *ToolBar;
  int ToolTag;
  TDBLookupComboBox *FilterBox;

  TToolButton* _fastcall AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick);
  void __fastcall FormActivate(TObject *Sender);
  void __fastcall FormDeactivate(TObject *Sender);
  void __fastcall RefreshToolBar(TObject *Sender);
  void __fastcall FormResize(TObject *Sender);
  void virtual __fastcall FOnActivate();

  virtual __fastcall TWTMDIWindow(TComponent *owner);
  virtual __fastcall ~TWTMDIWindow();
  // NoDeactivate == true - �������� � ������� ����������� ���� ���� �������� �����
  // �������� ������� ���� ���������� � ����
  // NoDeactivate == false - ���������
  void SetNoDeactivate(bool NoDeactivate);
  void virtual __fastcall ActivateMenu(TObject *Sender);
  void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);
  // ��������� ������� ����� � ������� �� �������� (ModalResult != 0)
  // ���������� *ModalResult
  // ���� *ModalResult = -1 - ���� ������� ��� ������
  // ����� ������ ����� ���������� ������� Close()
  int _fastcall ShowModal();

  // ��������� ����
  void SetCaption(AnsiString Name);
  void __fastcall ShowAs(AnsiString ID);

};
//----------------------------------------------------------------------------

#endif
