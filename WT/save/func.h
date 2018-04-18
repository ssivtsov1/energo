//----------------------------------------------------------------------------
// Функции библиотеки
//----------------------------------------------------------------------------
#ifndef FunctionH
#define FunctionH
#include <vcl\Dialogs.hpp>
#include <inifiles.hpp>
#include <registry.hpp>
#include <fcntl.h>
#include<io.h>                            

#include "Query.h"
//----------------------------------------------------------------------------
// delete устаналивающий указатель в NULL
//----------------------------------------------------------------------------
#define DEL(x) {x != NULL ? delete x : ShowMessage("Ошибка программиста! Попытка удаления пустого указателя."); x = 0;}
//----------------------------------------------------------------------------
//class TWTValue;

//возвращает список SQL запросов для создания копии таблицы (запроса) Source
void __fastcall GetCreateSQL(TDBDataSet* Source, AnsiString TableName,TStringList *SQLList);

//возвращает SQL строку для создания копии таблицы (запроса) связанного с Source
//и заполняет ее данными непосредственно отображаемыми в Source
AnsiString __fastcall GetCreateSQL(TDBGrid* Source, AnsiString TableName);

//Проверяет есть ли у класса Class предок с именем ClassName
bool CheckParent(TClass Class,AnsiString ClassName);
bool CheckParent(TObject *Class,AnsiString ClassName);

// Записывает строку в файл диагностики
// если файл не открыт возвращает 0
// Вызов без параметров проверяет размер файла и если он больше 500кб
// переименовывает его (для ограничения на размер файла)
int SaveMessage(AnsiString Str = "", AnsiString Str1 = "", AnsiString Str2 = "", AnsiString Str3 = "",
    AnsiString Str4 = "", AnsiString Str5 = "", AnsiString Str6 = "", AnsiString Str7 = "");


TField* AddSimpleField(TDataSet* DataSet,AnsiString FName);

void Delay(int Value);
//Удаление лишних полей из ini-файла
void UpdateIniFile(TMemIniFile* IniFile);
//Сохранение параметров шрифта в ini файл
Boolean FontToIni(TFont* Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident);
//Чтение параметров шрифта из ini файла
Boolean IniToFont(TFont* &Font,TMemIniFile* IniFile,AnsiString Section,AnsiString Ident);
// Создание элемента меню
TMenuItem *CreateMenuItem(char *caption, bool enabled = true,
    TNotifyEvent click = NULL, char *ID = "", char *ShortCut = "");
// Создание разделительной строки в меню
TMenuItem *CreateSeparator();
// Удаление подпунктов меню
void ClearMenuItem(TMenuItem *MenuItem);
// Создать всплывающее меню окна
TPopupMenu* CreatePopup(TWinControl* owner, TMenuItem **Items, int Items_Size,
    AnsiString Name); //"PopupMenu");
//Дублирование полей
TField* DuplicateField(TField* Source,TDataSet* DataSet);

// Вывод сообщения
void Message(TStringList *mes);
void Message(AnsiString *mes);
void Message(AnsiString mes);
void Message(int mes);

// Тестовая функция (выводит наименование класса пославшего сообщение)
void _fastcall ClassName(TObject *Sender);

//---------------------------------------------------------------------
// Возвращает размер строки в пикселах
// type
//   0 - Width
//   1 - Height
// При ошибке возвращает -1
//---------------------------------------------------------------------
int StringSize(AnsiString String, TFont *Font, int type = 0);

//---------------------------------------------------------------------
// Функции работы с датами
//---------------------------------------------------------------------
TDateTime _fastcall BOM(TDateTime Date);
TDateTime _fastcall EOM(TDateTime Date);
TDateTime _fastcall BOY(TDateTime Date);
TDateTime _fastcall EOY(TDateTime Date);

// Преобразование строки в дату с проверкой на корректность
// Mes - сообщение о ошибке
//  "" - Сообщение не выводится (возвращает -1)
//  NULL - "Некорректная дата: ..."
//  "..." - сообщение пользователя
TDateTime _fastcall StrToDate(AnsiString DateTime, AnsiString Mes);

// Перевод года с формате YY с учетом 2000
TDateTime _fastcall SetCentury(TDateTime *DateTime);
TDateTime _fastcall SetCentury(TDateTime DateTime);
TDateTime _fastcall SetCentury(AnsiString DateTime);
void _fastcall SetCentury(TField* Sender);
//---------------------------------------------------------------------
// Дата, строка, число, логическое значение в формате для SQL запроса
//---------------------------------------------------------------------
AnsiString ToStrSQL(TDateTime Date);
AnsiString ToStrSQL(AnsiString Str);
AnsiString ToStrSQL(float Float);
AnsiString ToStrSQL(double Float);
AnsiString ToStrSQL(int Float);
AnsiString ToStrSQL(unsigned int Float);
AnsiString ToStrSQL(bool Bool);
AnsiString ToStrSQL(TWTField *Field);

//----------------------------------------------------------------------------
// Преобразование строки/символа в boolean по первому символу ("T", "t", не 0 - 1)
//----------------------------------------------------------------------------
int atob(char Ch);
int atob(char *Str);
int atob(AnsiString Str);

//----------------------------------------------------------------------------
// Возвращает строку дополненную спереди / сзади символами Chr до
// указанного размера. Если строка больше чем указанный размер
// возвращает исходную строку (не обрезает).
// Если символ Chr не указан дополняет пробелами.
AnsiString PadL(AnsiString Str, int Length, char Chr = ' ');
// Дополняет строку нулями спереди
AnsiString PadL0(AnsiString Str, int Length);
// Возвращает целое дополненное спереди символами Chr
AnsiString PadL(int Num, int Length, char Chr = ' ');
// Возвращает целое дополненное спереди нулями
AnsiString PadL0(int Num, int Length);
AnsiString PadL0(long int Num, int Length);
AnsiString PadL0(double Num, int Length);
AnsiString PadR(AnsiString Str, int Length, char Chr = ' ');

// Округление
// ndec - количество знаков после запятой
double Round(double value, int ndec = 2);

//----------------------------------------------------------------------------
// Запрос даты
// При вводе возвращает true, при отказе false
// Str - строка сообщения
// DateTime - значение по умолчанию (при вводе содержит введенную дату)
// При нажатии Esc возвращает false
//----------------------------------------------------------------------------
bool GetDate(AnsiString Str, TDateTime* DateTime);

// Создание каталога по полному пути
int MkDirPath(AnsiString Path);

//Организация меню с вопросом "Да" / "Нет"
int Ask(AnsiString Label);


//функции для применения во встроенном интерпретаторе

/*TWTValue *Array(int X,int Y);
TWTValue *CopyArray(TWTValue *Dest,TWTValue *Src);
TWTValue *ArrayOfStr(int X,int Y);
TWTValue *ArrayOfNum(int X,int Y);
TWTValue *AADD(TWTValue *Src,Variant& Elem);  //Добавляет новый элемент в конец массива
TWTValue *ACLONE(TWTValue* Src);       //Дублирует вложенный или многомерный массив
TWTValue* ACOPY(TWTValue* Src,TWTValue* Dest);        //Копирует элементы одного массива в другой
TWTValue *ADEL(TWTValue* Src,int Index);         //Удаляет элемент массива
TWTValue *AFILL(TWTValue* Src,Variant& Value);        //Заполняет массив заданным значением
TWTValue* AINS(TWTValue* Src,int Index,Variant& Elem);         //Заносит элемент со значением NIL в массив
int ASCAN(TWTValue* Src,Variant& Elem);        //Просматривает массив на совпадение с заданным значением
TWTValue *ASIZE(TWTValue* Src,int X,int Y);        //Увеличивает или уменьшает размер массива
TWTValue* ASORT(TWTValue* Src);        //Сортирует массив
int AT(AnsiString Src,AnsiString SubStr);          //Возвращает позицию первого вхождения подстроки
Variant ATAIL(TWTValue* Src);        //Возвращает элемент массива с наибольшим номером
AnsiString CDOW(AnsiString Date);         //Преобразует значение даты в символьное название дня недели
AnsiString CHR(int Value);          //Преобразует код ASCII в его символьное значение
AnsiString CMONTH(AnsiString Date);       //Преобразует дату в символьное название месяца
int DAY(AnsiString Date);          //Возвращает номер дня в виде числа
int DOW(AnsiString Date);          //Преобразует значение даты в числовое значение дня недели
AnsiString DTOS(AnsiString Date);         //Преобразует значение даты в строку символов формата ггггммдд
int ISALPHA(AnsiString Value);      //Определяет, является ли самый левый символ в строке буквой
int ISDIGIT(AnsiString Value);      //Определяет, является ли первый символ в строке цифрой
int ISLOWER(AnsiString Value);      //Определяет, является ли первый символ строчной буквой
int ISUPPER(AnsiString Value);      //Определяет, является ли первый символ заглавной буквой
AnsiString LEFT(AnsiString Src,int Size);         //Определяет подстроку, начиная с первого символа в строке
AnsiString LTRIM(AnsiString Src);        //Удаляет начальные пробелы из символьной строки
int MONTH(AnsiString Date);        //Определяет по значению даты номер месяца
int RAT(AnsiString Src,AnsiString SubStr);          //Возвращает позицию первого вхождения подстроки
AnsiString RIGHT(AnsiString Src,int Size);        //Возвращает подстроку, начиная с самого правого символа
AnsiString RTRIM(AnsiString Src);        //Удаляет конечные пробелы из символьной строки.
AnsiString SPACE(int Number);        //Возвращает строку пробелов
AnsiString STRTRAN(AnsiString Src,AnsiString Find,AnsiString Replace);      //Ищет и заменяет символы в символьной строке или memo-поле
int YEAR(AnsiString Date);         //Преобразует значение даты в номер года в числовом виде
AnsiString ALLTRIM(AnsiString Src);       //Удаляет ведущие и замыкающие пробелы в строке символов
AnsiString SUBSTR(AnsiString Src,int Start,int End);       //Выделяет подстроку из символьной строки
int Ask(AnsiString Label);             //Организация меню с вопросом "Да" / "Нет"
TWTValue *ArrayOfUnique(int X,int Y);         //Получение массива из уникальных элементов
TWTValue *DelimLine(AnsiString Src,AnsiString Delims);       //Разбиение строки на массив подстрок заданной длины
  */
#endif

