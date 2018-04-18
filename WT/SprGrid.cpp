//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SprGrid.h"
//---------------------------------------------------------------------
// ������� ������ TWTSprDBGrid
//---------------------------------------------------------------------
_fastcall TWTSprDBGrid::TWTSprDBGrid(TWinControl *owner, TTEvent FEnter,bool IsMDI) : TWTWinDBGrid(owner,&TStringList(),IsMDI) {
  AfterClose = NULL;
  TWTWinDBGrid::AfterClose = FAfterClose;
  TWTSprDBGrid::FEnter = FEnter;
  DBGrid->OnDblClick = EnterMenu;
  SetNoDeactivate(true);
  CreateMenu();
  FieldSource = NULL;
  FFieldDest=NULL;
  if (WindowState!=wsMaximized) Width=400;
}

//---------------------------------------------------------------------
_fastcall TWTSprDBGrid::TWTSprDBGrid(TWinControl *owner, TTEvent FEnter, TStringList *SQL,bool IsMDI) : TWTWinDBGrid(owner, SQL,IsMDI) {
  AfterClose = NULL;
  TWTWinDBGrid::AfterClose = FAfterClose;
  TWTSprDBGrid::FEnter = FEnter;
  DBGrid->OnDblClick = EnterMenu;
  SetNoDeactivate(true);
  CreateMenu();
  FieldSource = NULL;
  FFieldDest=NULL;
  if (WindowState!=wsMaximized) Width=400;
}

//---------------------------------------------------------------------
_fastcall TWTSprDBGrid::TWTSprDBGrid(TWinControl *owner, TTEvent FEnter, TWTQuery *query,bool IsMDI) : TWTWinDBGrid(owner, query,IsMDI) {
  AfterClose = NULL;
  TWTWinDBGrid::AfterClose = FAfterClose;
  TWTSprDBGrid::FEnter = FEnter;
  DBGrid->OnDblClick = EnterMenu;
  SetNoDeactivate(true);
  CreateMenu();
  FieldSource = NULL;
  FFieldDest=NULL;
  if (WindowState!=wsMaximized) Width=400;
}

//---------------------------------------------------------------------
_fastcall TWTSprDBGrid::TWTSprDBGrid(TWinControl *owner, AnsiString Name,bool IsMDI) : TWTWinDBGrid(owner, Name,IsMDI) {
  AfterClose = NULL;
  TWTWinDBGrid::AfterClose = FAfterClose;
  TWTSprDBGrid::FEnter = FEnter;
  DBGrid->OnDblClick = EnterMenu;
/*  for (int x=8;x<WindowMenuItem->Count)
    if (WindowMenuItem->Items[x]->Caption==MainForm->ActiveMDIChild->Caption) {
      WindowMenuItem
    }*/

 // SetNoDeactivate(true);
  CreateMenu();
  FieldSource = NULL;
  FFieldDest=NULL;
  if (WindowState!=wsMaximized) Width=400;
}
//---------------------------------------------------------------------
_fastcall TWTSprDBGrid::~TWTSprDBGrid() {
}
//---------------------------------------------------------------------
// ������� ��������� ������� �������
//---------------------------------------------------------------------
void __fastcall TWTSprDBGrid::FAfterClose(TWTWinDBGrid* Sender) {
  if (FEnter) FEnter();
  if (AfterClose) AfterClose();
}
//---------------------------------------------------------------------
void __fastcall TWTSprDBGrid::CreateMenu() {
  // ������� ����������� ���� ��� DBGrid � ����
  TMenuItem * Items[] = {
    CreateMenuItem("����� ������", true, DBGrid->NewRecordMenu),
    CreateMenuItem("������� ������", true, DBGrid->DelRecordMenu),
    CreateSeparator(),
    CreateMenuItem("�����", true, DBGrid->SearchMenu),
    CreateMenuItem("����������", true, DBGrid->ReSearchMenu),
    CreateSeparator(),
    CreateMenuItem("���������� ������", true, DBGrid->SetFilterMenu),
    CreateMenuItem("����� ������", true, DBGrid->RemoveFilterMenu),
    CreateSeparator(),
    CreateMenuItem("����� �� ���� �������",true, DBGrid->SumAllColumn),
    CreateMenuItem("����� �� ���������� �������", true, DBGrid->SumAnyRecord),
    CreateMenuItem("������� ���������", true, DBGrid->ClearSum),
    CreateSeparator(),
    CreateMenuItem("��������� ���������", true, DBGrid->ApplyUpdatesMenu),
    CreateMenuItem("�������� ���������", true, DBGrid->CancelUpdatesMenu),
    CreateMenuItem("������������� ��������", true, DBGrid->WinEditMenu),
    CreateSeparator(),
    CreateMenuItem("�����", true, EnterMenu)
  };

  Items[0]->ShortCut = TextToShortCut("Ins");
  Items[1]->ShortCut = TextToShortCut("Ctrl+Del");
  Items[3]->ShortCut = TextToShortCut("Shift+F6");
  Items[4]->ShortCut = TextToShortCut("F6");
  Items[6]->ShortCut = TextToShortCut("Shift+F7");
  Items[7]->ShortCut = TextToShortCut("Ctrl+F7");
  Items[9]->ShortCut = TextToShortCut("Shift+F5");
  Items[10]->ShortCut = TextToShortCut("Ctrl+F5");
  Items[11]->ShortCut = TextToShortCut("Alt+F5");
  Items[13]->ShortCut = TextToShortCut("Alt+Enter");
  Items[14]->ShortCut = TextToShortCut("Esc");
  Items[15]->ShortCut = TextToShortCut("Ctrl+Enter");
  Items[17]->ShortCut = TextToShortCut("Enter");

  DBGrid->PopupMenu = CreatePopup(this, Items, ARRAYSIZE(Items) - 1, "PopupMenuSprDBGrid");
}
//---------------------------------------------------------------------
void _fastcall TWTSprDBGrid::FOnClose(TObject *Sender, TCloseAction &Action) {
  Action = caFree;
  TWTMDIWindow::OnClose(Sender, Action);
}
//---------------------------------------------------------------------
// ������� ����
//---------------------------------------------------------------------
void _fastcall TWTSprDBGrid::EnterMenu(TObject *Sender) {
  try {
    if (FEnter)
      FEnter();
    if (FieldSource != NULL && FieldDest != NULL) {
      FieldDest->Field->DataSet->Edit();
      FieldDest->Field->AsVariant = FieldSource->Field->AsVariant;
    }
    if (FieldSource != NULL && EditDestKod != NULL) {
      EditDestKod->Text = FieldSource->Field->AsString;
      if (DBGrid->Table)
        EditDestName->Text = DBGrid->Table->Fields->FieldByName("Name")->AsString;
      else
        EditDestName->Text = DBGrid->Query->Fields->FieldByName("Name")->AsString;
    }
  } catch (Exception &e) {
          Application->ShowException(&e);
    };
  Close();
}

TWTField* __fastcall TWTSprDBGrid::GetFieldDest(){
  return FFieldDest;
}

void __fastcall TWTSprDBGrid::SetFieldDest(TWTField* Field){
  if (!DBGrid || !FieldSource) {
    throw Exception("�� ������� ���� �������� ��� DBGrid");
  }
  FFieldDest=Field;
  TLocateOptions Options;
  Options.Clear();
  try {
    if (DBGrid->Table) {
      DBGrid->Table->Locate(FieldSource->Field->FieldName,Field->Field->AsVariant,Options);
    } else {
      DBGrid->Query->Locate(FieldSource->Field->FieldName,Field->Field->AsVariant,Options);
    }
   } catch (...) {
   }
}

//---------------------------------------------------------------------

