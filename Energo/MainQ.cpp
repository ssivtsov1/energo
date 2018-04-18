//---------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
#include "Main.h"

//#define Lite
//---------------------------------------------------------------------
// функции класса TMainForm
//---------------------------------------------------------------------
_fastcall TMainForm::TMainForm(TComponent *owner) : TWTMainForm(owner) {
   TMenuItem* OPL;
   OPL=new TMenuItem(this);
   OPL->Caption="111";
  // Читаем имя пользователя
  IDUser = IniFile->ReadString("IDUser", "Name", "User");
  // Добавляем пункты меню
  // Клиент
  ClientMenuItem->Add(CreateMenuItem("Клиент ... ", true));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("Список", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("Карточка", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("Субабонент", true, DoNot));
    ClientMenuItem->Items[0]->Add(CreateMenuItem("Схема", true, DoNot));
    // Документы
  InDocMenuItem->Add(CreateMenuItem("Документы ...", true));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("Журнал", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("Группы", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("Шаблоны", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("Элементы", true, DoNot));
    InDocMenuItem->Items[0]->Add(CreateMenuItem("Форматы", true, DoNot));
  InDocMenuItem->Add(CreateMenuItem("Архив ...", true, DoNot));

  // Нормативная информация
  NormMenuItem->Add(CreateMenuItem("ТРЭ", true, DoNot));
  NormMenuItem->Add(CreateMenuItem("Сбор оплаты ...", true));
    NormMenuItem->Items[1]->Add(CreateMenuItem("Активная электроэнергия ", true,DoNot));
    NormMenuItem->Items[1]->Add(CreateMenuItem("Реактивная электроэнергия", true,DoNot));
    NormMenuItem->Add(CreateMenuItem("Услуги", true));




  // справочники
  ServiseMenuItem->Add(CreateMenuItem("Оборудование ...", true));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Счетчики ...", true));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Счетчики", true, EqmMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Виды счетчиков", true, EqiAMeterBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Классы напряжений", true, EqiVoltageBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Временные зоны", true, EqiZoneBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Виды энергии", true, EqiEnergyBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("?Классы точности", true, DoNot));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Методы подключения", true, EqiHookupBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Фазность", true, EqiPhaseBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Способы учета", true, EqiKindCountBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Схемы подключения", true, EqiSchemainsBtn));
      ServiseMenuItem->Items[2]->Items[0]->Add(CreateMenuItem("Типы счетчиков", true, EqiMeterBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Линии ...", true));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Линии воздушные", true, EqmLineABtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Линии кабельные", true, EqmLineCBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("?Виды линий", true, DoNot));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Кабеля силовые", true, EqiCableBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Провода", true, EqiCordeBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Опоры", true, EqiPillarBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Подвески", true, EqiPendantBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Петли заземления", true, EqiEarthBtn));
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[1]->Add(CreateMenuItem("Материалы", true, EqiMatBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Трансформаторы ...", true));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Трансформаторы силовые", true, EqmCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Виды трансформаторов силовых", true, EqiCompBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateSeparator());
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Трансформаторы измерительные", true, EqmCompIBtn));
      ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Виды трансформатов измерительных", true, EqiCompIBtn));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" -2-х обмоточные", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" -3-х обмоточные", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("С расчепленной обмоткой", true, DoNot));
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateSeparator());
      //ServiseMenuItem->Items[2]->Items[2]->Add(CreateMenuItem("Трансформаторы тока", true, DoNot));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Компенсаторы ...", true));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Компенсаторы", true, EqmJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Виды компенсаторов", true, EqiJackBtn));
    ServiseMenuItem->Items[2]->Items[3]->Add(CreateMenuItem("Синхронность", true, EqiSyncBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Предохранители ...", true));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("Предохранители", true, EqmFuseBtn));
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[4]->Add(CreateMenuItem("Виды предохранителей", true, EqiFuseBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Коммутационное оборудование ...", true));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Коммутационное оборудование", true, EqmSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateSeparator());
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Виды коммутационного оборудования", true, EqiSwitchBtn));
    ServiseMenuItem->Items[2]->Items[5]->Add(CreateMenuItem("Группы коммутационного оборудования", true, EqiSwitchsGrBtn));

    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Трансформаторные подстанции", true, EqmCompStBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Площадки", true, EqmLandingBtn));
    ServiseMenuItem->Items[2]->Add(CreateMenuItem("Точки включения", true, EqmConnectBtn));
  ServiseMenuItem->Add(CreateMenuItem("Адрес ...", true));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("Список адресов", true, AdmAddressBtn));
    ServiseMenuItem->Items[2]->Items[1]->Add(CreateSeparator());
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("Области", true, AdiDomainBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("Районы", true, AdiRegionBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("Нас.Пункты", true, AdiTownBtn));
    ServiseMenuItem->Items[3]->Add(CreateMenuItem("Улицы", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("Банки", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Учетные ставки", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Валюты", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Виды налогов", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Ставки налогов", true, DoNot));
   ServiseMenuItem->Add(CreateMenuItem("Виды санкций", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Тарифы ...", true));
    ServiseMenuItem->Items[11]->Add(CreateMenuItem("Тарифы", true, DoNot));
    ServiseMenuItem->Items[11]->Add(CreateMenuItem("Зонные коефмциенты", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Прейскурант услуг", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Виды расчетов", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Виды расчетных документов", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
   ServiseMenuItem->Add(CreateMenuItem("Должности", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("Ресы ", true, DoNot));
  ServiseMenuItem->Add(CreateMenuItem("Должностные лица", true, DoNot));
  ServiseMenuItem->Add(CreateSeparator());
  ServiseMenuItem->Add(CreateMenuItem("Клиент ...", true));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("Клиент", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("Группы клиентов", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("Регистрационные данные", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("Доп.данные клиента", true, DoNot));
    ServiseMenuItem->Items[21]->Add(CreateMenuItem("Должностные лица", true, DoNot));

    // выходные документы
  OutDocMenuItem->Add(CreateMenuItem("Полезный отпуск ЭЭ ...", true));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" по клиенту", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" по группе ", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" по тарифам", true, DoNot));
    OutDocMenuItem->Items[0]->Add(CreateMenuItem(" пофидерно", true, DoNot));
  OutDocMenuItem->Add(CreateMenuItem("Начисления и оплата ЭЭ ...", true));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" оперативная отчетность", true, DoNot));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" обороты ", true, DoNot));
    OutDocMenuItem->Items[1]->Add(CreateMenuItem(" налоги", true, DoNot));
 OutDocMenuItem->Add(CreateMenuItem("Реактивная ЭЭ ...", true));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("Потребление ...", true));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" по клиенту", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" по группе ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" по тарифам", true, DoNot));
       OutDocMenuItem->Items[2]->Items[0]->Add(CreateMenuItem(" пофидерно", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("Генерация ...", true));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" по клиенту", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" по группе ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" по тарифам", true, DoNot));
       OutDocMenuItem->Items[2]->Items[1]->Add(CreateMenuItem(" пофидерно", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("Надбавка...", true));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" по клиенту", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" по группе ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" по тарифам", true, DoNot));
       OutDocMenuItem->Items[2]->Items[2]->Add(CreateMenuItem(" пофидерно", true, DoNot));
    OutDocMenuItem->Items[2]->Add(CreateMenuItem("Обороты...", true));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" по клиенту", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" по группе ", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" по тарифам", true, DoNot));
       OutDocMenuItem->Items[2]->Items[3]->Add(CreateMenuItem(" пофидерно", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("Санкции ...", true));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("Пеня ", true, DoNot));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("Штрафы ", true, DoNot));
       OutDocMenuItem->Items[3]->Add(CreateMenuItem("Лимиты ", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("Услуги...", true));
       OutDocMenuItem->Items[4]->Add(CreateMenuItem("Предоставление ", true, DoNot));
       OutDocMenuItem->Items[4]->Add(CreateMenuItem("Оплата ", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("Оборудование...", true));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("Замена/Установка ", true, DoNot));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("Отключения", true, DoNot));
       OutDocMenuItem->Items[5]->Add(CreateMenuItem("Режимы работы", true, DoNot));
    OutDocMenuItem->Add(CreateMenuItem("Плановые работы ...", true));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("Замена учетов ", true, DoNot));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("График обходов и проверок", true, DoNot));
       OutDocMenuItem->Items[6]->Add(CreateMenuItem("СМИ", true, DoNot));
   OutDocMenuItem->Add(CreateMenuItem("Прогнозирование ...", true));
       OutDocMenuItem->Items[7]->Add(CreateMenuItem("Установка лимитов ", true, DoNot));
   OutDocMenuItem->Add(CreateMenuItem("Транзит", true, DoNot));

      // Настройки

 ToolsMenuItem->Add(CreateMenuItem("Системные переменные", true, DoNot));
 ToolsMenuItem->Add(CreateMenuItem("Целостность баз ...", true));
   ToolsMenuItem->Items[1]->Add(CreateMenuItem("Общая ", true, DoNot));
   ToolsMenuItem->Items[1]->Add(CreateMenuItem("Таблицы", true, DoNot));
 ToolsMenuItem->Add(CreateMenuItem("Сеть", true));
 ToolsMenuItem->Add(CreateMenuItem("Пользователи ...", true));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("Группы", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("Права доступа", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("Список", true, DoNot));
   ToolsMenuItem->Items[3]->Add(CreateMenuItem("Мониторинг ...", true));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("Текущая работа ", true, DoNot));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("Журнал", true, DoNot));
       ToolsMenuItem->Items[3]->Items[3]->Add(CreateMenuItem("Архив", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("Справка окна", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("Справка по системе", true, DoNot));
  HelpMenuItem->Add(CreateMenuItem("Нормативная документация", true, DoNot));
  HelpMenuItem->Add(CreateSeparator());
  HelpMenuItem->Add(CreateMenuItem("О программе", true, DoNot));


  // Временный запрос (нужен для обновления полей и другое)
  QueryTmp = new  TWTQuery(this);


  Options = Options<<foExit>>foHelp;

  TWTToolBar *ToolBar = new TWTToolBar(this);
  ToolBar->Parent = this;
  ToolBar->ID = "Главная панель";

  // добавляем кнопки в главную панель

  ToolBar->AddButton("CardClient", "Карточка клиента", DoNot);
  ToolBar->AddButton("|", NULL, NULL);
  ToolBar->AddButton("AdiAddress", "Адреса", AdiTownBtn);

  ToolBar->AddButton("AUTO", "Оборудование", ShowEqpTree);
  ToolBar->AddButton("AUTO", "ЛОГ", ShowLog);
  ToolBar->AddButton("AUTO", "Схемы", EqmTreesBtn);

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
 ShowMessage(" Режим пока не работает! ");
}

