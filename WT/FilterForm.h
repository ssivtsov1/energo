//---------------------------------------------------------------------------
#ifndef FilterFormH
#define FilterFormH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <Buttons.hpp>
#include <Grids.hpp>

//#include "Form.h"
#include "DBGrid.h"
//---------------------------------------------------------------------------
class TWTSearchParams;

class TWTFilterForm : public TWTMDIWindow {
private:
   TWTDBGrid *DBGrid;
   AnsiString CurrentFilter;
   void __fastcall LoadFilter(AnsiString LoadName);
   void __fastcall Initialize();
   bool Filter;
public:
   TWTSearchParams *SearchParams;

   TPanel *Panel1;
   TPanel *Panel2;
   TPanel *Panel3;
   TPanel *Panel4;
   TPanel *Panel5;
   TListBox *LBSource;
   TStringGrid *SGDest;

   TSpeedButton *SBOk;
   TSpeedButton* SBAdd;
   TSpeedButton* SBRem;
   TSpeedButton* SBEqual;
   TSpeedButton* SBGreatEqual;
   TSpeedButton* SBLessEqual;
   TSpeedButton* SBGreat;
   TSpeedButton* SBLess;
   TSpeedButton* SBNotEqual;
   TRadioGroup *RGroup;
   TCheckBox *CBox1;
   TCheckBox *CBox2;
   TMemo *Memo1;
   TTrackBar* TrackBar1;

public:
    __fastcall TWTFilterForm(TWinControl *Owner,AnsiString LoadName);
    __fastcall TWTFilterForm(TWinControl *Owner);
    __fastcall ~TWTFilterForm();
    void __fastcall AddLine(TObject *Sender);
    void __fastcall RemoveLine(TObject *Sender);
    void __fastcall ApplyFilter(TObject *Sender);

    void __fastcall FindRecord(TObject *Sender);
    // удалить шаблон
    void __fastcall DeleteFilter(TObject *Sender);
    //Обработчик выбора фильтра из меню
//    void __fastcall EventOnChoose(TObject *Sender);
    //Очистить поле фильтра
    void __fastcall ClearFilter(TObject *Sender);
    //Применить фильтр без закрытия окна фильтра
    void __fastcall SimpleApply(TObject *Sender);
    //Сохранить фильтр в шаблон
    void __fastcall SaveFilter(TObject *Sender);
    void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);

    void _fastcall FOnKeyPress(TObject *Sender, char &Key);
    void _fastcall FOnDblClick(TObject *Sender);
};
//---------------------------------------------------------------------------
#endif
