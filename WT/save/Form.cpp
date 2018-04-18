//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Form.h"

TWTForm *TWTForm::MainForm = NULL;

TMainMenu *TWTForm::MainMenu = NULL;
TMenuItem *TWTForm::UserMenuItem = NULL;

TList *TWTForm::ActivateItem = NULL;
TList *TWTForm::DeactivateItem = NULL;

TDateTime TWTForm::MMGG = BOM(Date());

// ��������� �� ���� ���� ������
TWTSetupQuery *TWTForm::BaseSetup = NULL;
TWTSetupQuery *TWTForm::BaseFilter = NULL;

TMenuItem *TWTForm::InDocMenuItem;      // ��������� �� ���� �������� ����������
TMenuItem *TWTForm::OutDocMenuItem;     // ��������� �� ���� �������� ����������
TMenuItem *TWTForm::ServiseMenuItem;
TMenuItem *TWTForm::HelpMenuItem;
TMenuItem *TWTForm::WindowMenuItem;
TMenuItem *TWTForm::QuitMenuItem;

TMenuItem *TWTForm::ReportMenuItem;     // ��������� �� ���� �������� ����������
TMenuItem *TWTForm::FilterMenuItem;
TMenuItem *TWTForm::TableMenuItem;

TMenuItem *TWTForm::HelpItem;           // ������
TMenuItem *TWTForm::AboutItem;          // � ���������

TWTCoolBar *TWTForm::MainCoolBar;
TDataSource *TWTForm::FilterSource;
TTable *TWTForm::FilterTable;

bool TWTForm::RefreshFlag;

int TWTForm::DialogCount;

// ������ ���������
TStatusBar *TWTForm::StatusBar;

// ��������� ����
TWTSetupQuery *TWTForm::SetupQuery;

int TWTForm::MainMenuCount = 0;
//TMemIniFile* TWTForm::IniFile;


//---------------------------------------------------------------------
// ������� ������ TWTForm
//---------------------------------------------------------------------
TToolButton* _fastcall TWTForm::AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick,int Num)
{
  TToolBar *ToolBar;
  int x=0;
  while ((x<MainCoolBar->Bands->Count) && (MainCoolBar->Bands->Items[x]->Control->Tag!=Num)) x++;
  if (x==MainCoolBar->Bands->Count) return NULL;
  ToolBar=(TToolBar*)MainCoolBar->Bands->Items[x]->Control;
  MainCoolBar->Bands->Items[x]->Width+=24;
  MainCoolBar->Bands->Items[x]->MinWidth+=24;
  ToolBar->Width+=24;

  TToolButton *ToolButton1=new TToolButton(ToolBar);
  if (Path!='|') {
    ToolButton1->Style=tbsButton;
    ToolButton1->Parent=ToolBar;
    ToolButton1->OnClick=EventOnClick;
    ToolButton1->Hint=BHint;
    ToolButton1->ShowHint=true;
    Graphics::TBitmap *Bitmap1=new Graphics::TBitmap();
    Bitmap1->LoadFromResourceName(0,Path);
    ImageList1->Add(Bitmap1,NULL);
//    delete Bitmap1;
    ToolButton1->ImageIndex=ImageList1->Count-1;
  } else {
    ToolButton1->Style=tbsSeparator;
    ToolButton1->Parent=ToolBar;
  }
  return ToolButton1;
}

//---------------------------------------------------------------------
_fastcall TWTForm::TWTForm(TComponent *owner) : TForm(owner, 1) {

  TForm::OnActivate = FOnActivate;
  TForm::OnDeactivate = FOnDeactivate;
  TForm::OnClose = FOnClose;
  TForm::OnResize = FOnResize;
  TForm::OnShow = FOnShow;
  FormStyle = fsNormal;
  // ����������� ���� ���� (�� TForm)
  PopupMenu = NULL;

  // �����������/������������� ������� ����
  InitMenu();
  Visible=false;
}
//---------------------------------------------------------------------
_fastcall TWTForm::~TWTForm() {

//  delete IniFile;
}

//---------------------------------------------------------------------
void _fastcall TWTForm::Close(TObject *Sender) {
  TForm::Close();
}
//---------------------------------------------------------------------
void _fastcall TWTForm::FOnActivate(TObject *Sender) {
  // ������������� �������� ���� �� ���������
  //  RestoreMenuDefault();
  // �����������/������������� ������� ���� ������������
  InitMenu();
  OnActivate(Sender);
  StatusBar->SimpleText = Application->Hint;
}
//---------------------------------------------------------------------
void _fastcall TWTForm::FOnShow(TObject *Sender) {
}

//---------------------------------------------------------------------
void TWTForm::RestoreMenuDefault() {
  // �������� ������ � MDIForm
  if (FormStyle == fsNormal || FormStyle == fsStayOnTop)
    return;
  if (ActivateItem == NULL) {
    // ��������� �������� ���� �� ���������
    ActivateItem = new TList;
    DeactivateItem = new TList;
    BuildActivateItem(MainMenu->Items);
  }
  else {
    int i;
    for (i = 1; i < ActivateItem->Count; i++) {
      if (ActivateItem->Items[i] != NULL)
        ((TMenuItem *)ActivateItem->Items[i])->Enabled = true;
    }
    for (i = 1; i < DeactivateItem->Count; i++) {
      if (DeactivateItem->Items[i] != NULL)
        ((TMenuItem *)DeactivateItem->Items[i])->Enabled = false;
    }
  }
}

//---------------------------------------------------------------------
void _fastcall TWTForm::FOnDeactivate(TObject *Sender) {
  OnDeactivate(Sender);
//  RestoreMenuDefault();
}

//---------------------------------------------------------------------
void _fastcall TWTForm::FOnClose(TObject *Sender, TCloseAction &Action) {
  OnDeactivate(Sender);
  Action = caFree;
  OnClose(Sender, Action);
}

//---------------------------------------------------------------------
void _fastcall TWTForm::FOnResize(TObject *Sender) {
//  if (Active && MainForm->ActiveMDIChild == this)
    OnResize(Sender);
}

//---------------------------------------------------------------------
void _fastcall TWTForm::ShowPopup(TObject *Sender) {
  if (ActiveMDIChild && ActiveMDIChild->PopupMenu) {
     ActiveMDIChild->PopupMenu->Popup(Screen->Width/2, Screen->Height/2);
  }
}
//---------------------------------------------------------------------
void __fastcall TWTForm::BuildActivateItem(TMenuItem *MenuItem) {
  for (int i = 1; i < MenuItem->Count; i++) {
    BuildActivateItem(MenuItem->Items[i]);
  }
  if (MenuItem->Enabled)
    ActivateItem->Add(MenuItem);
  else
    DeactivateItem->Add(MenuItem);
}

//---------------------------------------------------------------------
TWinControl *TWTForm::FindToolBar(int Tag){
  for (int x=0;x<MainForm->MainCoolBar->Bands->Count;x++)
    if (MainForm->MainCoolBar->Bands->Items[x]->Control->Tag==Tag)
      return MainForm->MainCoolBar->Bands->Items[x]->Control;
  return NULL;
}
//---------------------------------------------------------------------
void __fastcall TWTForm::MainMenuEnabled(bool Enabled) {
/*  for (int i = 1; i < MainMenuCount; i++) {
    MainMenu->Items->Items[i]->Enabled = Enabled;
  }
/*  if (!Enabled) {
    for (int x=0;x<((TToolBar*)FindToolBar(0))->ButtonCount;x++) {
      ((TToolBar*)FindToolBar(0))->Buttons[x]->Enabled=false;
    }
    for (int x=0;x<((TToolBar*)FindToolBar(1))->ButtonCount;x++) {
      ((TToolBar*)FindToolBar(1))->Buttons[x]->Enabled=false;
    }
  }
  else {
    for (int x=0;x<((TToolBar*)FindToolBar(0))->ButtonCount;x++) {
      ((TToolBar*)FindToolBar(0))->Buttons[x]->Enabled=ButtonStates[x];
    }
    for (int x=0;x<((TToolBar*)FindToolBar(1))->ButtonCount;x++) {
      ((TToolBar*)FindToolBar(1))->Buttons[x]->Enabled=true;
    }
  }
   FindToolBar(0)->Visible= Enabled;
   FindToolBar(1)->Visible= Enabled;*/

}

#include "mainform.h"
//---------------------------------------------------------------------
// ������� ������ TWTMDIWindow
//---------------------------------------------------------------------
_fastcall TWTMDIWindow::TWTMDIWindow(TComponent *owner) : TWTForm(owner) {

  FID="";

  NoDeactivate = false;
  Caption = "";
  ModalResult = -1;

  // �������� � ���� � ���� ����
  if (MainForm->WindowMenuItem->Count == 7) {
    MainForm->WindowMenuItem->Add(CreateSeparator());
    LockWindowUpdate(Application->MainForm->Handle);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->AddToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);
    LockWindowUpdate(NULL);
  }
  MainForm->WindowMenuItem->Add(WindowMenu = CreateMenuItem("�������� ����", true, ActivateMenu));

  ToolBar=NULL;

  TForm::OnActivate=FormActivate;
  TForm::OnDeactivate=FormDeactivate;
  TForm::OnCreate=FormActivate;
  TForm::OnResize=FormResize;

  RefreshFlag= true;

  // ������� ������ ������
  FCoolBar=new TWTCoolBar(this);
  FCoolBar->EdgeBorders=FCoolBar->EdgeBorders >> ebTop;
  FCoolBar->Parent=this;
}
//---------------------------------------------------------------------
_fastcall TWTMDIWindow::~TWTMDIWindow() {
  //��������� ���������� ���� ��� ������������ ��������������
  if (ID!="") {
    ((TWTMainForm*)MainForm)->StartupIniFile->WriteInteger(ID,"Left",Left);
    ((TWTMainForm*)MainForm)->StartupIniFile->WriteInteger(ID,"Top",Top);
    ((TWTMainForm*)MainForm)->StartupIniFile->WriteInteger(ID,"Width",Width);
    ((TWTMainForm*)MainForm)->StartupIniFile->WriteInteger(ID,"Height",Height);
  }

  // ������������� ����������� ����
  SetNoDeactivate(false);

  // ������� ������ �� ���� �� ���� ����
  // ���� ����
  int i = 7;
  while (i < MainForm->WindowMenuItem->Count &&
    MainForm->WindowMenuItem->Items[i] != WindowMenu) {
    i++;
  }
  if (MainForm->WindowMenuItem->Count && MainForm->WindowMenuItem->Items[i] == WindowMenu)
    MainForm->WindowMenuItem->Delete(i);
  // ���� ���� ������ ��� - ������� �����������
  if (MainForm->WindowMenuItem->Count == 8){
    MainForm->WindowMenuItem->Delete(7);
    ((TWTMainForm*)Application->MainForm)->MainCoolBar->RemoveToolBar(((TWTMainForm*)Application->MainForm)->WindowToolBar);

/*    for (int i=0; i<MainCoolBar->Bands->Count; i++)
      if (MainCoolBar->Bands->Items[i]->Control->Tag != 0)
        MainCoolBar->Bands->Items[i]->Control->Visible= false;*/
  }
}

void __fastcall TWTMDIWindow::FSetID(AnsiString Value){
  FID=Value;
  //��������������� ���������� ����
  if (((TWTMainForm*)MainForm)->StartupIniFile->SectionExists(ID)) {
    Left=((TWTMainForm*)MainForm)->StartupIniFile->ReadInteger(ID,"Left",100);
    Top=((TWTMainForm*)MainForm)->StartupIniFile->ReadInteger(ID,"Top",100);
    Width=((TWTMainForm*)MainForm)->StartupIniFile->ReadInteger(ID,"Width",100);
    Height=((TWTMainForm*)MainForm)->StartupIniFile->ReadInteger(ID,"Height",100);
//    WindowState=((TWTMainForm*)MainForm)->StartupIniFile->ReadInteger("Data","WindowState",wsNormal);
    WindowState=wsNormal;
  } else {
    WindowState=wsNormal;
  }
}

void __fastcall TWTMDIWindow::ShowAs(AnsiString ID){
  WindowState=wsMinimized;
  FormStyle=fsMDIChild;
  this->ID=ID;
//  WindowState=wsNormal;
}

//---------------------------------------------------------------------
void TWTMDIWindow::SetCaption(AnsiString Name) {
  Caption = Name;
  if (WindowMenu)
    WindowMenu->Caption = Caption;
}
//---------------------------------------------------------------------
void TWTMDIWindow::SetNoDeactivate(bool NoDeactivate) {
  TWTMDIWindow::NoDeactivate = NoDeactivate;
  SetEnabledMDI();
}
//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::OnClose(TObject *Sender, TCloseAction &Action) {
  if (!ModalResult) {
    ModalResult = -1;
    Action = caNone;
  }
}
//---------------------------------------------------------------------
void _fastcall TWTMDIWindow::ActivateMenu(TObject *Sender) {
  if (Enabled) Show();
}
//---------------------------------------------------------------------
int _fastcall TWTMDIWindow::ShowModal() {

  WindowMenuItem->Enabled=false;
  ModalResult = 0;

  if (!DialogCount) {
     SetNoDeactivate(true);
     MainForm->MainMenuEnabled(false);
  }

  DialogCount++;
  // ������� �������� �����
  while(!ModalResult) {
    Application->ProcessMessages();
  }
  DialogCount--;

  if (!DialogCount) {
    SetNoDeactivate(false);
    MainForm->MainMenuEnabled(true);
  }

  return ModalResult;
}
//---------------------------------------------------------------------
void TWTMDIWindow::SetEnabledMDI() {
  // ����������/��������� ����������� ����
  bool MDIEnabled = true;
  // � MDIChildren ���� ����������� � ������������������ �����������
  // (������� ���� ������������������ ����������)
  for (int i = 0; i < MainForm->MDIChildCount; i++) {
    if (MDIEnabled) {
      MainForm->MDIChildren[i]->Enabled = true;
      if (((TWTMDIWindow *)MainForm->MDIChildren[i])->NoDeactivate) {
        MDIEnabled = false;
      }
    }
    else {
      MainForm->MDIChildren[i]->Enabled = false;
    }
  }
}
//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::FormDeactivate(TObject *Sender){
/*  TToolBar* TB=(TToolBar*)FindToolBar(0);
  for (int x=0;x<TB->ButtonCount;x++) {
    ButtonStates[x]=TB->Buttons[x]->Enabled;
  } */
}

//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::FormActivate(TObject *Sender){
  if (!RefreshFlag) {
    RefreshFlag= true;
    return;
  }
  FOnActivate();
/*  for (int i=0; i<MainCoolBar->Bands->Count; i++)
    if (MainCoolBar->Bands->Items[i]->Control->Tag != 0 &&
        MainCoolBar->Bands->Items[i]->Control->Tag != 1)
      MainCoolBar->Bands->Items[i]->Control->Visible= false;
      else {
        if (!ModalResult) {
/*          for (int x=0;x<((TToolBar*)FindToolBar(0))->ButtonCount;x++) {
            ((TToolBar*)FindToolBar(0))->Buttons[x]->Enabled=false;
          }
          for (int x=0;x<((TToolBar*)FindToolBar(1))->ButtonCount;x++) {
            ((TToolBar*)FindToolBar(1))->Buttons[x]->Enabled=false;
          }
       //   MainCoolBar->Bands->Items[i]->Control->Visible= false;
        }
      } */


 // if (ToolBar->ButtonCount!=0) ToolBar->Visible=True;
}

//---------------------------------------------------------------------
TToolButton* _fastcall TWTMDIWindow::AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick)
{
//    TCoolBand *CB=FindCoolBand(ToolBar);
  if (!ToolBar) {

    ToolBar=new TToolBar(this);
    ToolBar->Flat=true;
    ToolBar->BorderWidth=1;
    ToolBar->Width=0;
    ToolBar->Height=29;
    ToolBar->Visible=true;
    ToolBar->Align=alLeft;

    ToolBar->Parent=CoolBar;
    CoolBar->Bands->Items[0]->Width = 10;
    CoolBar->Bands->Items[0]->MinWidth = 10;
    CoolBar->Bands->Items[0]->Break = false;
    CoolBar->AutoSize=True;

    ImageList1=new TCustomImageList(this);

    ToolBar->Images=ImageList1;
  }
  TCoolBand* CB=((TCoolBar*)ToolBar->Parent)->Bands->Items[0];
  CB->Width=CB->Width+24;
  CB->MinWidth=CB->MinWidth+24;
  ToolBar->Width=ToolBar->Width+24;
  TToolButton *ToolButton1=new TToolButton(ToolBar);
  if (Path!='|') {
    ToolButton1->Style=tbsButton;
    ToolButton1->OnClick=EventOnClick;
    ToolButton1->Hint=BHint;
    ToolButton1->ShowHint=true;
    Graphics::TBitmap *Bitmap1=new Graphics::TBitmap();
    Bitmap1->LoadFromResourceName(0,Path);
    ImageList1->Add(Bitmap1,NULL);
    delete Bitmap1;
    ToolButton1->ImageIndex=ImageList1->Count-1;
  } else {
    ToolButton1->Style=tbsSeparator;
  }
  ToolBar->Height= 29;
  ToolButton1->Parent=ToolBar;
  return ToolButton1;
}

//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::RefreshToolBar(TObject *Sender){
  RefreshFlag= false;
}

//---------------------------------------------------------------------
TCoolBand *TWTMDIWindow::FindCoolBand(TToolBar *TB){
  int x=0;
  while ((x<MainCoolBar->Bands->Count) && (((TToolBar*)MainCoolBar->Bands->Items[x]->Control)!=TB)) x++;
  if (x==MainCoolBar->Bands->Count) return NULL;
  return MainCoolBar->Bands->Items[x];
}

//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::FOnActivate(){
}
//---------------------------------------------------------------------
void __fastcall TWTMDIWindow::FormResize(TObject* Sender){
/*  if (WindowState==wsMaximized) {
    MainCoolBar->AutoSize=false;
    ToolBar->Parent=MainCoolBar;
    if (MainForm->ActiveMDIChild!=this) ToolBar->Visible=false;
    MainCoolBar->AutoSize=true;
  }*/
}

