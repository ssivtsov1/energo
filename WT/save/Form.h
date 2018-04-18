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
// Форма для библиотреки WinTools TEXHO+
//----------------------------------------------------------------------------
class TWTForm : public TForm {
private:
  // Списки активных / неактивных по умолчанию пунктов меню
  // (заполняются один раз при создании главной формы)
  static TList *ActivateItem;
  static TList *DeactivateItem;

  // Восстановление меню по умолчанию
  void RestoreMenuDefault();

protected:

  // Обработчики событии
  void virtual __fastcall FOnActivate(TObject *Sender);
  void virtual __fastcall FOnShow(TObject *Sender);
  void virtual __fastcall FOnDeactivate(TObject *Sender);
  void virtual __fastcall FOnClose(TObject *Sender, TCloseAction &Action);
  virtual void __fastcall FOnResize(TObject *Sender);

public:
  TCustomImageList *ImageList1;
  // Переменные опеределяемые в главной форме пакета
  // Указатель на главну форму пакета (на самом деле она TWTMainForm)
  static TWTForm *MainForm;
  static TDataSource *FilterSource;
  static TTable *FilterTable;
  static bool RefreshFlag;
  static int DialogCount;
  static TMemIniFile* IniFile;

  // Указатель на главное меню пакета
  static TMainMenu *MainMenu;
  // Указатель на меню пользователя для окна (может быть NULL)
  static TMenuItem *UserMenuItem;
  // Рабочий период
  static TDateTime MMGG;
  // Указатели на базы ядра пакета
  static TWTSetupQuery *BaseSetup;
  static TWTSetupQuery *BaseFilter;
  //Панель батонов
  static TWTCoolBar *MainCoolBar;
  // Пункты главного меню
  static TMenuItem *InDocMenuItem;      // указатель на меню исходных документов
  static TMenuItem *OutDocMenuItem;     // указатель на меню выходных документов
  static TMenuItem *ServiseMenuItem;
  static TMenuItem *HelpMenuItem;
  static TMenuItem *WindowMenuItem;     // Список окон
  static TMenuItem *QuitMenuItem;
  static TMenuItem *ReportMenuItem;     // указатель на меню выходных отчетов
  static TMenuItem *FilterMenuItem;
  static TMenuItem *TableMenuItem;

  // Подменю HelpMenuItem
  static TMenuItem *HelpItem;           // Помощь
  static TMenuItem *AboutItem;          // О программе
   
  // Строка состояни
  static TStatusBar *StatusBar;

  // Параметры ядра
  static TWTSetupQuery *SetupQuery;
  // Количество пунктов в главном меню
  static int MainMenuCount;

public:

  TToolButton* _fastcall AddButton(AnsiString Path,AnsiString BHint,TNotifyEvent EventOnClick,int Num);
  _fastcall TWTForm(TComponent *owner);
  _fastcall virtual ~TWTForm();
  TWinControl *FindToolBar(int Tag);

  bool ButtonStates[100];

  // Вызывается при активизации окна
  void __fastcall virtual OnActivate(TObject *Sender) {};
  // Вызывается при отображении окна
  void __fastcall virtual OnShow(TObject *Sender) {};
  // Вызывается при деативизации окна
  void __fastcall virtual OnDeactivate(TObject *Sender) {};
  // Вызывается при закрытии формы
  void __fastcall virtual OnClose(TObject *Sender, TCloseAction &Action) {};
  // Вызывается при изменении размера
  void __fastcall virtual OnResize(TObject *Sender) {};
  // Построить списки активных/неактивных меню
  void __fastcall BuildActivateItem(TMenuItem *MenuItem);
  // Активизация/деактивизация пунктов меню
  void virtual __fastcall InitMenu() {};

  // Активизация/деактивизация меню
  void __fastcall MainMenuEnabled(bool Enabled = true);

  // Закрытие формы (использовать delete нельзя - не происходит проверка возможности закрытия формы)
  void virtual __fastcall Close(TObject *Sender = NULL);

  // Отобразить всплывающее меню окна (из меню)
  void __fastcall ShowPopup(TObject *Sender);
};
//----------------------------------------------------------------------------
// MDI окно
//----------------------------------------------------------------------------
class TWTMDIWindow : public TWTForm {
protected:
  // Установка в true запрещает переходить к другим окнам приложения
  bool NoDeactivate;

  // Указатель на пункт меню в списке меню окон
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
  // NoDeactivate == true - приводит к запрету активизации всех окон открытых ранее
  // доступно главное окно приложения и меню
  // NoDeactivate == false - разрешает
  void SetNoDeactivate(bool NoDeactivate);
  void virtual __fastcall ActivateMenu(TObject *Sender);
  void virtual __fastcall OnClose(TObject *Sender, TCloseAction &Action);
  // Отбражает текущую форму и ожидает ее закрытия (ModalResult != 0)
  // возвращает *ModalResult
  // Если *ModalResult = -1 - окно закрыто без выбора
  // После выбора форму необходимо закрыть Close()
  int _fastcall ShowModal();

  // Заголовок окна
  void SetCaption(AnsiString Name);
  void __fastcall ShowAs(AnsiString ID);

};
//----------------------------------------------------------------------------

#endif
