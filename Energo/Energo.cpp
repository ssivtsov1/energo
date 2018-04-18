//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
//USERC("tools.rc");
USEUNIT("Main.cpp");
USELIB("Lib\VMachine.lib");
USERES("Energo.res");
USERES("tools.res");
USELIB("lib\wt.lib");
USEUNIT("eqp\EqpList.cpp");
USEFORM("eqp\Log.cpp", fLog);
USEUNIT("eqp\fCable.cpp");
USEFORM("eqp\fChange.cpp", fChangeDate);
USEFORM("eqp\fComp.cpp", fCompSpr);
USEFORM("eqp\fCompI.cpp", fCompISpr);
USEFORM("eqp\fDet.cpp", fEqpDet);
USEFORM("eqp\fEqpAirLineDet.cpp", fALineDet);
USEFORM("eqp\fEqpBase.cpp", fEqpEdit);
USEFORM("eqp\fEqpBorderDet.cpp", fBorderDet);
USEFORM("eqp\fEqpSDet.cpp", fSimpleEqpDet);
USEFORM("eqp\fEqpTheMeterDet.cpp", fEqpMeterDet);
USEUNIT("eqp\fMeter.cpp");
USEFORM("eqp\fStationDet.cpp", fStationDet);
USEFORM("eqp\ftree.cpp", fTreeForm);
USEUNIT("eqp\equipment.cpp");
USEFORM("bill\fBillPrint.cpp", fPrintBill);
USEFORM("eqp\fParamSel.cpp", fSelParam);
USEFORM("eqp\fEqpThePointDet.cpp", fEqpPointDet);
USEUNIT("eqp\AreaList.cpp");
USEFORM("eqp\fFiderDet.cpp", fFiderDet);
USEFORM("balans\fBalRep.cpp", fBalansRep);
USEFORM("tax\fTaxPrint2014.cpp", fRepTaxN2014);
USEUNIT("tax\fTaxList.cpp");
USEFORM("tax\fTaxCorPrint2014.cpp", fRepTaxCor2014);
USEFORM("report\RepSaldo.cpp", PrintSaldo);
USEUNIT("eqp\EqpSpr.cpp");
USEFORM("report\fDemandPrint.cpp", fPrintDemand);
USEFORM("report\fBankPrint.cpp", fPrintBank);
USEUNIT("eqp\AbonConnect.cpp");
USEUNIT("eqp\fHist.cpp");
USEUNIT("eqp\DelEqpList.cpp");
USEFORM("balans\fBal.cpp", fBalans);
USEUNIT("tax\fTaxListAll.cpp");
USEFORM("tax\ftaxprintpar.cpp", fTaxPrintParams);
USEFORM("tax\fPeriodSel.cpp", fPeriodSelect);
USEUNIT("bill\fBillListAll.cpp");
USEFORM("tax\fTaxDeleteAll.cpp", fDelTaxAll);
USEFORM("bill\fLogin.cpp", fUserLogin);
USEUNIT("bill\fDemLimit.cpp");
USEFORM("rep\f2kAct.cpp", fPrint2krAct);
USEUNIT("bill\CliPowerIndic.cpp");
USEFORM("bill\fCalendar.cpp", fCalend);
USEFORM("bill\fPenInf.cpp", fPenaInflPrint);
USEUNIT("bill\fAbonSw.cpp");
USEFORM("rep\fReps.cpp", fReports);
USEFORM("bill\fBillAct.cpp", fPrintBillAkt);
USEUNIT("OSA\Address.cpp");
USEUNIT("OSA\CliDemL.cpp");
USEFORM("OSA\BankScr.cpp", FBankScr);
USEUNIT("OSA\ClientBill.cpp");
USEUNIT("OSA\CLIENTlIST.cpp");
USEUNIT("OSA\ClientSprParam.cpp");
USEUNIT("OSA\CliSald.cpp");
USEFORM("OSA\CliState.cpp", FCliState);
USEUNIT("OSA\Documents.cpp");
USEFORM("OSA\FOpenMonthM.cpp", FOpenMonth);
USEUNIT("OSA\FSebPlan.cpp");
USEFORM("OSA\SysBase.cpp", fBaseLogin);
USEUNIT("OSA\SysRelat.cpp");
USEUNIT("OSA\SysUser.cpp");
USEFORM("OSA\SysUserPwdF.cpp", FUserPwd);
USEFORM("OSA\SysVarM.cpp", FShowSys);
USEFORM("OSA\SysVers.cpp", FShowVers);
USEUNIT("OSA\CommonTable.cpp");
USEUNIT("OSA\BankAccountSel.cpp");
USEUNIT("OSA\BankPScr.cpp");
USEFORM("tax\fEdTaxParam.cpp", fTaxParam);
USEUNIT("OSA\Inspect.cpp");
USEFORM("OSA\RepInspect.cpp", fRepInspect);
USEUNIT("OSA\ResDemL.cpp");
USEFORM("balans\fCheckFider.cpp", fFiderCheck);
USEUNIT("balans\fbalConnSw.cpp");
USEUNIT("eqp\PlombList.cpp");
USEUNIT("eqp\WorkList.cpp");
USEFORM("eqp\point_card.cpp", fPointCard);
USEFORM("balans\fbalConnSwEdit.cpp", fbalConnSwitchEdit);
USEFORM("OSA\FormFtp.cpp", ftpForm);
USEFORM("eqp\PlombInsert.cpp", fPlombNew);
USEFORM("monitor\fmonFiderWorkEdit.cpp", fMonitorFiderWorkEdit);
USEUNIT("monitor\fmonFiderWorks.cpp");
USEUNIT("monitor\FWorkPlan.cpp");
USEFORM("eqp\point_blank.cpp", fPointAct);
USEFORM("OSA\fMailToConfig.cpp", MailToConfig);
USEFORM("eqp\fGroundDet.cpp", fGroundDet);
USEUNIT("eqp\fSSMet.cpp");
USEUNIT("tax\fTaxPrint.cpp");
USEUNIT("tax\fTaxPrint2014.cpp");
USEUNIT("tax\fTaxPrintParent.cpp");
USEUNIT("tax\fTaxCorPrintParent.cpp");
USEUNIT("tax\fTaxCorPrint.cpp");
USEUNIT("tax\fTaxCorPrint2014.cpp");
USEFORM("tax\fTaxCorPrint2014_12.cpp", fRepTaxCor2014_12);
USEFORM("tax\fTaxPrint2014_12.cpp", fRepTaxN2014_12);
USEFORM("tax\fTaxCorPrint2015.cpp", fRepTaxCor2015);
USEFORM("tax\fTaxPrint2015.cpp", fRepTaxN2015);
USEUNIT("OSA\AddrMain.cpp");
USEFORM("tax\fTaxPrint2016.cpp", fRepTaxN2016);
USEFORM("tax\fTaxCorPrint2016.cpp", fRepTaxCor2016);
USEUNIT("Func.cpp");
USEUNIT("bill\fAbonAction.cpp");
//---------------------------------------------------------------------------
#include "Main.h"
#define   Dat DateToStr(Date());

//#include "prop.h"

//TClient_par *Client_par;
//---------------------------------------------------------------------
// Указатель главную форму программы
TMainForm *MainForm;
//---------------------------------------------------------------------

//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
    int  MAIN_RES;
    Application->Initialize();
    Application->Title = "Енергия --- Юридические лица ";
    Application->HelpFile = "E:\\WTools\\Energo\\Energo.hlp";
                 Application->ShowHint = true;
    Application->CreateForm(__classid(TMainForm), &MainForm);
                 Application->CreateForm(__classid(TfPrintBill), &fPrintBill);
                 Application->CreateForm(__classid(TfPrintBillAkt), &fPrintBillAkt);
                 Application->CreateForm(__classid(TfTaxParam), &fTaxParam);
                 Application->CreateForm(__classid(TfPointAct), &fPointAct);
                 Application->CreateForm(__classid(TMailToConfig), &MailToConfig);
                 Application->Run();
  }
  catch (Exception &exception)
  {
     Application->ShowException(&exception);
  }
  return 0;
}
//---------------------------------------------------------------------------


void __fastcall TWTDBGrid::SumFromTo(int From,int To){
  int Temp;
  bool DirFlag=false;
  double Sum=0;
  int RealCount=0;
  if (To< From) {
    DirFlag=true;
    Temp=To;
    To=From;
    From=Temp;
  }

  TWTWaitForm *WF=new TWTWaitForm(this, "Идет подсчет...","Inspect");
  Application->MainForm->Enabled=false;
  WF->Show();
  Visible=false;
  TZDataset* DS;
  if (Table) DS=Table;
  else DS=Query;
  void* BM=DS->GetBookmark();
  if (Flag) DS->Last();

//  for(int x= From;x<= To;x++) {
  while ((DS->RecNo!=To && DirFlag) || (DS->RecNo!=From && !DirFlag)) {
    if (WF->Stop) {
      DS->GotoBookmark(BM);
      Visible=true;
      delete WF;
      Application->MainForm->Enabled=true;
      SetFocus();
      return;
    }
    RealCount++;
    try {
      Sum+= Columns->Items[SelectedIndex]->Field->AsFloat;
    } catch (...) {}
    if (DirFlag) DS->Next();
    else DS->Prior();
    if (DS->Bof) break;
    Application->ProcessMessages();
  }
  Sum+= Columns->Items[SelectedIndex]->Field->AsFloat;
  RealCount++;

  DS->GotoBookmark(BM);
  Visible=true;
  delete WF;
  Application->MainForm->Enabled=true;
  SetFocus();
  Summa+= Sum;
  CntRecord+= RealCount;
  FlSumma= 0;
  AnsiString S;

  TWTParamsForm* PF=new TWTParamsForm(Application,"Результат суммирования");
  PF->Params->AddSimple("Сумма по "+IntToStr(RealCount)+ " записям",100,FloatToStrF(Sum, ffFixed, 12, 2))->SetReadOnly(true);
  PF->Params->AddSimple("Сумма по "+IntToStr(CntRecord)+ " записям (c учетом предыдущего значения)",100,FloatToStrF(Summa, ffFixed, 12, 5))->SetReadOnly(true);

  PF->TForm::ShowModal();
  delete PF;
  if (CheckParent(Parent,"TWTWinDBGrid")) {
    ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[1]->Text="";
    ((TWTWinDBGrid*)Parent)->StatusBar->Panels->Items[2]->Text=Columns->Items[SelectedIndex]->Title->Caption +" (Записей: "+IntToStr(RealCount)+" Сумма: "+FloatToStrF(Sum, ffFixed, 12, 5)+")";
  }
}

//Получает ID из GlobalIniFile, если не существует возвращает ""
AnsiString __fastcall TWTDBGrid::GetID(){
  return ((TWTMainForm*)Application->MainForm)->GlobalIniFile->ReadString("Tables",GetAlias(),"");
}

