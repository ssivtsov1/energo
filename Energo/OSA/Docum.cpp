//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"
//---------------------------------------------------------------------
// ������� ������ TMainForm
//---------------------------------------------------------------------
// Part1 - CldFirmXXX  complicated
// Part2 - StiPositionXXX                  s+g
// Part3 - StiPersonXXX                     s+g
// Part4 - StPositionXXX  complicated
// Part5 - StkPhoneXXX                      s+g
// Part6 - StdPoneXXX  complicated
// Part7 - GroupDocXXX   with tree
// Part8 - DciDirectionXXX                  s+g
// Part9 - DcdReseptionXXX complicated
// Part10 - DckResolutionXXX                s+g
// Part11 - DciTextResolutionXXX - complicated
// Part12 DcdResolutionXXX  - complicated



//---------------------------------------------------  Part2  - StiPositionXXX
#define WinName "���������� ������������ ����������"
void _fastcall TMainForm::StiPositionBtn(TObject *Sender){   // sti_position_tbl
  StiPositionSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::StiPositionSpr(TWTField  *Sender){
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this :
          (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("sti_position_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // !!! ����� ����� ���������� LookUp
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("NAME", "���������", "������������ ���������");  //!!!
//  Field->SetRequired("������������ ��������� ������ ���� ���������"); // ���� ����������� ��� ���������� ����������������

 // WGrid->DBGrid->AfterInsert= AfterInsertStiPosition;
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("StiPosition");
};
#undef WinName

//------------------------------------------- End Part2 - StiPositionXXX

//---------------------------------------------------  Part3 - StiPersonXXX
#define WinName "���������� ������ ����������"
void _fastcall TMainForm::StiPersonBtn(TObject *Sender){     // sti_person_tbl
  StiPersonSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::StiPersonSpr(TWTField  *Sender){
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("sti_person_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // !!! ����� ����� ���������� LookUp
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("LAST_NAME", "�������", "�������");  //!!!
  //Field->SetRequired("������������ ��������� ������ ���� ���������"); // ���� ����������� ��� ���������� ����������������
  Field = WGrid->AddColumn("FIRST_NAME", "���", "���");  //!!!
  Field = WGrid->AddColumn("PATRONYMIC_NAME", "��������", "��������");  //!!!


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("StiPerson");
};
#undef WinName

//------------------------------------------- End Part3 - StiPersonXXX

//---------------------------------------------------  Part4 - StPositionXXX  complicated
#define WinName "������ ����������"
void _fastcall TMainForm::StPositionBtn(TObject *Sender){    // st_position_tbl
  StPositionSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::StPositionSpr(TWTField  *Sender) {
   TWinControl *Owner = Sender == NULL ?
      this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,  CreateFullTableName("st_position_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_FIRM", "ID_Client",    CreateFullTableName("cli_firm_tbl"), "NAME","id"); //!!! ��� lookup �������, ����
  Table->AddLookupField("NAME_POSITION", "ID_POSITION",    CreateFullTableName("sti_position_tbl"), "NAME","id"); //!!! ��� lookup �������, ����
  Table->AddLookupField("NAME_PERSON", "ID_PERSON",    CreateFullTableName("sti_person_tbl"), "LAST_NAME","id"); //!!! ��� lookup �������, ����

  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("NAME_FIRM", "�����", "������������ �����");  //!!!
  Field->SetOnHelp(CliClientMSpr);
//  Field->SetRequired("���������  ������ ���� ���������"); // ���� ����������� ��� ���������� ����������������

  Field = WGrid->AddColumn("NAME_POSITION", "���������", "���������"); // �� NAME_KIND Table->AddLookupField
  Field->SetOnHelp(StiPositionSpr); //!!! ��� ������ ������� ����������� �����������

  Field = WGrid->AddColumn("NAME_PERSON", "����������� ����", "����������� ����"); // �� NAME_KIND Table->AddLookupField
  Field->SetOnHelp(StiPersonSpr); //!!! ��� ������ ������� ����������� �����������


  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("StPosition");


};

#undef WinName
//------------------------------------------- End Part4 - StPositionXXX

//---------------------------------------------------  Part5 - StkPhoneXXX
#define WinName "���� ���������"
void _fastcall TMainForm::StkPhoneBtn(TObject *Sender){      // stk_phone_tbl
  StkPhoneSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::StkPhoneSpr(TWTField  *Sender) {
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("stk_phone_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // !!! ����� ����� ���������� LookUp
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("NAME", "���", "��� ����������� ������");  //!!!
 // Field->SetRequired("������������ ��������� ������ ���� ���������"); //!!!

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("StkPhone");
};
#undef WinName
//------------------------------------------- End Part5 - StkPhoneXXX

//---------------------------------------------------  Part6 - StdPoneXXX  complicated
#define WinName "���������� ���������"
void _fastcall TMainForm::StdPoneBtn(TObject *Sender){       // std_phone_tbl
  StdPoneSpr(NULL);                                      //!!!
};

void _fastcall TMainForm::StdPoneSpr(TWTField  *Sender){
};
#undef WinName
//------------------------------------------- End Part6 - StdPoneXXX

//-------------------------------------------------- Part7 - GroupDocXXX   with tree
  #define WinName "������������ ����������"
void _fastcall TMainForm::DciGroupDocBtn(TObject *Sender) {  // dci_group_tbl //!!!
  DciGroupDocSpr(NULL);                                      //!!!
}

void _fastcall TMainForm::DciGroupDocSpr(TWTField *Sender) { //!!!
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this :
          (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,
       CreateFullTableName("dci_group_tbl"),false); //!!! ������� ����� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������"); //!!!
 // Field->SetRequired("������������  ������ ���� ���������");
  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id"); //!!!
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("DciGroup"); //!!! �������������� ���������� ����� ���� �� energo.ini

};
#undef WinName
//---------------------------------------------------- End Part7 - GroupDocXXX
//---------------------------------------------------- Part8 - DciDirectionXXX
#define WinName "���������� �����������"
void _fastcall TMainForm::DciDirectionBtn(TObject *Sender) { // dci_direction_tbl //!!!
  DciDirectionSpr(NULL);                                       //!!!
}

void _fastcall TMainForm::DciDirectionSpr(TWTField *Sender) {  //!!!
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this, CreateFullTableName("dci_direction_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("NAME", "�����������", "��������,���������,����������");  //!!!
 // Field->SetRequired("����� ���������� ����� ���� ��������");  // !!!

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("DciDirection");

};
#undef WinName
//--------------------------------------------------- end part8 DciDirectionXXX
//---------------------------------------------------  Part9 - DcdReseptionXXX complicated
#define WinName "��������������� ������ ����������"
void _fastcall TMainForm::DcdReseptionBtn(TObject *Sender){  // dcd_reseption_tbl
};

void _fastcall TMainForm::DcdReseptionSpr(TWTField  *Sender){
};
//------------------------------------------- End Part9 - DcdReseptionXXX
//---------------------------------------------------  Part10 - DckResolutionXXX
#define WinName "���������� ����� ���������"
void _fastcall TMainForm::DckResolutionBtn(TObject *Sender){ // dck_resolution_tbl //!!!
  DckResolutionSpr(NULL);                                      //!!!
}

void _fastcall TMainForm::DckResolutionSpr(TWTField *Sender) { //!!!
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ? this :
           (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,
    CreateFullTableName("dck_resolution_tbl"),false); //!!! ������� ����� �������

  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Name", "������������", "������������"); //!!!
 // Field->SetRequired("������������  ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id"); //!!!
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("DckResolution"); //!!! �������������� ���������� ����� ���� �� energo.ini

};
#undef WinName
//---------------------------------------------------  Part11 - DciTextResolutionXXX - complicated
#define WinName "���������� ������� ���������"
void _fastcall TMainForm::DciTextResolutionBtn(TObject *Sender){ // dci_textresolution_tbl
  DciTextResolutionSpr(NULL);                                       //!!!
}

void _fastcall TMainForm::DciTextResolutionSpr(TWTField *Sender) {  //!!!
  // ���������� ���������
  TWinControl *Owner = Sender == NULL ?
      this : (TWinControl *)((TControl *)Sender->Field->DataSet->Owner)->Parent;

  // ���� ����� ���� ���� - ������������ � �������
  if (ShowMDIChild(WinName, Owner)) {
    return;
  }

  TWTWinDBGrid *WGrid = new TWTWinDBGrid(this,
    CreateFullTableName("dci_textresolution_tbl"),false); //!!! �������� �������
  WGrid->SetCaption(WinName);

  TWTTable* Table = WGrid->DBGrid->Table;
  // ��������� ���� ��� ��������� � ��� ����������� �� ������� ���� � �����������
  Table->AddLookupField("NAME_KIND", "IDK_RESOLUTION",
                        CreateFullTableName("dck_resolution_tbl"),
                        "NAME","id"); //!!! ��� lookup �������, ����
  Table->Open();

  TWTField *Field;

  Field = WGrid->AddColumn("Txt", "���������", "���������");  //!!!
//  Field->SetRequired("���������  ������ ���� ���������"); // ���� ����������� ��� ���������� ����������������

  Field = WGrid->AddColumn("NAME_KIND", "��� ���������", "��� ���������"); // �� NAME_KIND Table->AddLookupField
  Field->SetOnHelp(DckResolutionSpr); //!!! ��� ������ ������� ����������� �����������
//  Field->SetRequired("������� ������ ���� ���������");

  WGrid->DBGrid->FieldSource = WGrid->DBGrid->Table->GetTField("id");
  WGrid->DBGrid->FieldDest = Sender;
  WGrid->DBGrid->Visible = true;
  WGrid->ShowAs("DciTextResolution");

};
#undef WinName

//------------------------------------------- End Part11 - DciTextResolutionXXX
//---------------------------------------------------  Part12 DcdResolutionXXX  - complicated
#define WinName "������ ���������"
void _fastcall TMainForm::DcdResolutionBtn(TObject *Sender){ // dcd_resolution_tbl
   DcdResolutionSpr(NULL);                                       //!!!
};

void _fastcall TMainForm::DcdResolutionSpr(TWTField  *Sender) {
};
//------------------------------------------- End Part12 - DcdResolutionXXX

