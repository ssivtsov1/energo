//----------------------------------------------------------------------------
// ������ ���������
//----------------------------------------------------------------------------
#ifndef MainH
#define MainH
//----------------------------------------------------------------------------
#include <vcl\Controls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Graphics.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Windows.hpp>
#include <vcl\System.hpp>

#include "Func.h"
#include "MainForm.h"
#include "WinGrid.h"
#include "SprGrid.h"
#include "ParamsForm.h"

//----------------------------------------------------------------------------
class TMainForm : public TWTMainForm {
public:
  bool __fastcall OnParameters(TWTMDIWindow *Sender,TStringList *CaptionsList,bool *CheckedList);
  TWTQuery* SprQuery;
  int CountWindow;
  TWTParamsForm* Form;

  TMenuItem *NewWindow;
  TMenuItem *NewWinDBGrid;
  TMenuItem *MessageItem;

  TMenuItem *Mission;
  TMenuItem *GetDateItem;

  TToolButton* Button1;
  TToolButton* Button2;

private:
  void _fastcall CreateMDIChild(const String name);
  void _fastcall ShowHint(TObject *Sender);

  //���������� ������������� ��� ���. ����
  void __fastcall GuidePodrKas(TWTField* Sender);
  void __fastcall GuidePodrKasTable(TWTField* Sender);
  // ���������� ��. ��������� ��� ���. ���������
  void __fastcall GuideIzm(TWTField* Sender);
  void __fastcall GuideIzmTable(TWTField* Sender);
  // ���������� ����� ������� ��� ���. ���������
  void __fastcall GuideGrp(TWTField* Sender);
  void __fastcall GuideGrpTable(TWTField* Sender);

  // ����� ������ ����
  void __fastcall Sales(AnsiString S);

  //��� �������������� ���� ����������� ��� ������ �� ���������
  void __fastcall ShowActiveWindows(TStringList* WindowsIDs);

  TWTQuery *QueryTmp;
  TWTWinDBGrid *DBGridMission;
  TWTWinDBGrid *DBGridMission1;
  TWTWinDBGrid *DBGridMission2;
  TWTWinDBGrid *DBGridMission3;
  TWTWinDBGrid *DBGridMission4;
  TWTWinDBGrid *DBGridMissionS;

  TWTWinDBGrid *DBGridGuide1;
  TWTSprDBGrid *DBGridGuide2;
  TWTWinDBGrid *DBGridGuide6;
  TWTWinDBGrid *DBGrid;
   
  void _fastcall OnGetText123(TField* Sender, AnsiString
 &Text, bool DisplayText);

public:

  _fastcall virtual TMainForm(TComponent *owner);
  _fastcall ~TMainForm();

  void __fastcall ShowDoc(TObject *Sender);

  AnsiString _fastcall FOnClick(TWTParamItem *Sender);
  // ������� ���������� �� ����
  // ����������� �� �������
  void _fastcall SprArt(TObject *Sender);
  void _fastcall SprKass(TObject *Sender);
  void _fastcall SprPodr(TObject *Sender);
  void _fastcall OnOkClick(TWTParamsForm* Sender,bool &CloseFlag);

  // ����������
  void _fastcall SprTran(TObject *Sender);
  void _fastcall SprTranTable(TObject *Sender);

  // ���������� ����������
  void _fastcall AccTran(TObject *Sender);

  // ����� ����������
  void _fastcall ArhTran(TObject *Sender);
  void _fastcall ArhTranTable(TObject *Sender);

  // ��������� �������� �� ������
  void _fastcall SalesArtP(TObject *Sender);
  // ����������� �� �������
  void _fastcall SprPodrTable(TObject *Sender);
  void _fastcall SprKassTable(TObject *Sender);
  void _fastcall SprArtTable(TObject *Sender);
  void _fastcall SprArtTableF(TWTField *Sender);
  // �������� ����������� (����� ������������ ��� ��������� ����)
  void virtual __fastcall OnActiveMainFormChange() {};

};
//----------------------------------------------------------------------------
#endif
