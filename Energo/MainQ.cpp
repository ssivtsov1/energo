//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

//#define Lite
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
_fastcall TMainForm::TMainForm(TComponent *owner) : TWTMainForm(owner) {
   TMenuItem* OPL;
   OPL=new TMenuItem(this);
   OPL->Caption="111";
  // ������ ��� ������������
  IDUser = IniFile->ReadString("IDUser", "Name", "User");
  // ��������� ������ ����
  // ������
  ClientMenuItem->Add(CreateMenuItem("������ ... ", true));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("������", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("��������", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("����������", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("�����", true, DoNot));
    // ���������
  InDocMenuItem->Add(CreateMenuItem("��������� ...", true));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("������", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("������", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("�������", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("��������", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("�������", true, DoNot));
  InDocMenuItem->Add(CreateMenuItem("����� ...", true, DoNot));

  // ����������� ����������
  NormMenuItem->Add(CreateMenuItem("���", true, DoNot));
  NormMenuItem->Add(CreateMenuItem("���� ������ ...", true));
    NormMenuItem->Items[1]->Add(CreateMenuItem("�������� �������������� ", true,DoNot));
    NormMenuItem->Items[1]->Add(CreateMenuItem("���������� ��������������", true,DoNot));
    NormMenuItem->Add(CreateMenuItem("������", true));




  // �����������
  ServiseMenuItem->Add(CreateMenuItem("������������ ...", true));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("�������� ...", true));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("��������", true, EqmMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("���� ���������", true, EqiAMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("������ ����������", true, EqiVoltageBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("��������� ����", true, EqiZoneBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("���� �������", true, EqiEnergyBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("?������ ��������", true, DoNot));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("������ �����������", true, EqiHookupBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("��������", true, EqiPhaseBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("������� �����", true, EqiKindCountBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("����� �����������", true, EqiSchemainsBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("���� ���������", true, EqiMeterBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("����� ...", true));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("����� ���������", true, EqmLineABtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("����� ���������", true, EqmLineCBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("?���� �����", true, DoNot));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("������ �������", true, EqiCableBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("�������", true, EqiCordeBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("�����", true, EqiPillarBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("��������", true, EqiPendantBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("����� ����������", true, EqiEarthBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("���������", true, EqiMatBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("�������������� ...", true));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("�������������� �������", true, EqmCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("���� ��������������� �������", true, EqiCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("�������������� �������������", true, EqmCompIBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("���� ������������� �������������", true, EqiCompIBtn));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" -2-� ����������", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" -3-� ����������", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("� ������������ ��������", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateSeparator());
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("�������������� ����", true, DoNot));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("������������ ...", true));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("������������", true, EqmJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("���� �������������", true, EqiJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("������������", true, EqiSyncBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("�������������� ...", true));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("��������������", true, EqmFuseBtn));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("���� ���������������", true, EqiFuseBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("�������������� ������������ ...", true));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("�������������� ������������", true, EqmSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("���� ��������������� ������������", true, EqiSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("������ ��������������� ������������", true, EqiSwitchsGrBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("���������������� ����������", true, EqmCompStBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("��������", true, EqmLandingBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("����� ���������", true, EqmConnectBtn));
  ServiseMenuItem->Add(CreateMenuItem("����� ...", true));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("������ �������", true, AdmAddressBtn));
    ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("�������", true, AdiDomainBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("������", true, AdiRegionBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("���.������", true, AdiTownBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("�����", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("�����", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("������� ������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("���� �������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("������ �������", true, DoNot));
   ServiseMenuItem->Add(CreateMenuItem("���� �������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("������ ...", true));
    ServiseMenuItem->Items[11]->Add(CreateMenuItem("������", true, DoNot));
    ServiseMenuItem->Items[11]->Add(CreateMenuItem("������ �����������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("����������� �����", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("���� ��������", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("���� ��������� ����������", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
   ServiseMenuItem->Add(CreateMenuItem("���������", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("���� ", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("����������� ����", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("������ ...", true));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("������", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("������ ��������", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("��������������� ������", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("���.������ �������", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("����������� ����", true, DoNot));

    // �������� ���������
  OutDocMenuItem->Add(CreateMenuItem("�������� ������ �� ...", true));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" �� �������", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" �� ������ ", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" �� �������", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" ���������", true, DoNot));
  OutDocMenuItem->Add(CreateMenuItem("���������� � ������ �� ...", true));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" ����������� ����������", true, DoNot));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" ������� ", true, DoNot));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" ������", true, DoNot));
 OutDocMenuItem->Add(CreateMenuItem("���������� �� ...", true));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("����������� ...", true));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" �� ������ ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" ���������", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("��������� ...", true));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" �� ������ ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" ���������", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("��������...", true));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" �� ������ ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" ���������", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("�������...", true));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" �� ������ ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" �� �������", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" ���������", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("������� ...", true));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("���� ", true, DoNot));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("������ ", true, DoNot));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("������ ", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("������...", true));
       OutDocMenuItem->Items[4]->Add(CreateMenuItem("�������������� ", true, DoNot));
       OutDocMenuItem->Items[4]->Add(CreateMenuItem("������ ", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("������������...", true));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("������/��������� ", true, DoNot));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("����������", true, DoNot));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("������ ������", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("�������� ������ ...", true));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("������ ������ ", true, DoNot));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("������ ������� � ��������", true, DoNot));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("���", true, DoNot));
   OutDocMenuItem->Add(CreateMenuItem("��������������� ...", true));
       OutDocMenuItem->Items[7]->Add(CreateMenuItem("��������� ������� ", true, DoNot));
   OutDocMenuItem->Add(CreateMenuItem("�������", true, DoNot));

      // ���������

 ToolsMenuItem->Add(CreateMenuItem("��������� ����������", true, DoNot));
 ToolsMenuItem->Add(CreateMenuItem("����������� ��� ...", true));
   ToolsMenuItem->Items[1]->Add(CreateMenuItem("����� ", true, DoNot));
   ToolsMenuItem->Items[1]->Add(CreateMenuItem("�������", true, DoNot));
 ToolsMenuItem->Add(CreateMenuItem("����", true));
 ToolsMenuItem->Add(CreateMenuItem("������������ ...", true));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("������", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("����� �������", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("������", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("���������� ...", true));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("������� ������ ", true, DoNot));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("������", true, DoNot));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("�����", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("������� ����", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("������� �� �������", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("����������� ������������", true, DoNot));
  HelpMenuItem->Add(CreateSeparator());
  HelpMenuItem->Add(CreateMenuItem("� ���������", true, DoNot));


  // ��������� ������ (����� ��� ���������� ����� � ������)
  QueryTmp = new  TWTQuery(this);


  Options = Options<<foExit>>foHelp;

  TWTToolBar *ToolBar = new TWTToolBar(this);
  ToolBar->Parent = this;
  ToolBar->ID = "������� ������";

  // ��������� ������ � ������� ������

  ToolBar->AddButton("CardClient", "�������� �������", DoNot);
  ToolBar->AddButton("|", NULL, NULL);
  ToolBar->AddButton("AdiAddress", "������", AdiTownBtn);

  ToolBar->AddButton("AUTO", "������������", ShowEqpTree);
  ToolBar->AddButton("AUTO", "���", ShowLog);
  ToolBar->AddButton("AUTO", "�����", EqmTreesBtn);

  MainCoolBar->AddToolBar(ToolBar);
  OnShowActiveWindows=ShowActiveWindows;

}

_fastcall TMainForm::~TMainForm(){
}

 void __fastcall TMainForm::ShowActiveWindows(TStringList* WindowsIDs){
 /*if (WindowsIDs->IndexOf("SPR_ART")!=-1) SprArt(NULL);
  //if (WindowsIDs->IndexOf("SprKass")!=-1) SprKass(NULL);
  //if (WindowsIDs->IndexOf("SprPodr")!=-1) SprPodr(NULL);
  AnsiString aa=StartupIniFile->ReadString("Data","ActiveWindow","");
  ShowMDIChild(aa);*/
}
//-----------------------------------------------
 void _fastcall TMainForm::DoNot(TObject *Sender)
{
 ShowMessage(" ����� ���� �� ��������! ");
}

