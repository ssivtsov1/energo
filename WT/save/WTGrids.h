//---------------------------------------------------------------------------
#ifndef WTGridsH
#define WTGridsH

#include <grids.hpp>
#include <QRPrntr.hpp>
#include "include\ZEOS\ZPgSqlCon.hpp"
#include "include\ZEOS\ZPgSqlTr.hpp"
#include "include\ZEOS\ZPgSqlQuery.hpp"
#include "include\\pascal.h"
#include "include\\exec.h"
//---------------------------------------------------------------------------
const MaxX=1000;
const MaxY=1000;

#define gsNormal 0
#define gsMouseDrag 1
#define gsEdit 2
#define gsColResizing 3
#define gsRowResizing 4
#define gsSelecting 5
#define gsDragCol 6
#define gsDragRow 7
#define gsSelCopy 8
#define gsSelMove 9
#define gsEditCancel 10
#define gsPagePressed 11
#define gsPrepare 12
#define gsSelRepaint 13

#define gmCalculated 0  //стандартный режим с вычислением формул
#define gmConstructor 1  //формулы не вычисляются, а отображаются

#define SB_SIZE 8


enum TBoundType {boLeft,boTop,boRight,boBottom,boInt,boError};
enum TVAlignment {taTopJustify, taBottomJustify, taCenter};
enum TDirection {scdLeft,scdTop,scdRight,scdBottom};
typedef Set<TDirection,scdLeft,scdBottom> TScrollDirection;


class TWTCell;

class TWTGridColumn;
class TWTGridRow;
class TWTScrollBar;
class TWTCellGrid;
class TWTGridGroupList;
class TWTGridGroup;

struct TPos {
  TPos(Smallint x,Smallint y) {
    X=x;
    Y=y;
  }
  TPos() {}
  Smallint X;
  Smallint Y;
};


class TWTGridAdapter: public TObject {
public:
  int CalcX;
  int CalcY;
  void* Data[100];

__published:
  AnsiString __fastcall Sum(int L,int T,int R,int B);
  AnsiString __fastcall Mul(int L,int T,int R,int B);
  AnsiString __fastcall Max(int L,int T,int R,int B);
  AnsiString __fastcall Cell(int L,int T);
  int __fastcall Next();
  AnsiString __fastcall Field(AnsiString FieldName);
  int __fastcall First();
protected:
  TWTCellGrid* FCellGrid;
  int DecCount;

public:
  virtual __fastcall TWTGridAdapter(TWTCellGrid* CellGrid);
  __fastcall ~TWTGridAdapter();
   void __fastcall AddDeclaration(AnsiString Name,int Offset,AnsiString Type,void* Value);
  void __fastcall RemoveDeclaration(AnsiString Name);
  //Запись в таблицу указателей VM указателю на функцию класса предварительно описанную
  //  и считанную из файла *.chf
  void __fastcall AddFunction(AnsiString Name,AnsiString Type,void* Pointer);
  void __fastcall AddGridDec(AnsiString Name,AnsiString Type,void* Value);
  void __fastcall ClearGridDec();

};

class TWTCellsCompiler: public TStringList {
protected:
  TWTExec* FExec;
  int Size;
  int DataSize;
  void *Code;
public:
  virtual __fastcall TWTCellsCompiler(TWTExec* Exec);
  __fastcall ~TWTCellsCompiler();
  int __fastcall Compile();
  int __fastcall Run();
  void __fastcall SaveToFile(FILE* File);
  void __fastcall LoadFromFile(FILE* File);
  virtual void __fastcall Clear(void);
  void __fastcall CopyFrom(TWTCellsCompiler *Source);
  AnsiString ResAsString;
  float ResAsFloat;
  int ResAsInt;
  int Error;
};

class TWTPrintSettings: public TObject {
public:
  virtual __fastcall TWTPrintSettings();
  __fastcall ~TWTPrintSettings();
  void __fastcall SaveToFile(FILE* File);
  void __fastcall LoadFromFile(FILE* File);
  int HDupCount;
  int VDupCount;
  int DupSpacing;
  int Copies;
  int TopMargin;
  int LeftMargin;
  int RightMargin;
  int BottomMargin;
};


class TWTCellGrid: public TDrawGrid {
friend class TWTCell;
friend class TWTGridAdapter;

private:
  int XFactor; //размер точки в милиметрах
  int YFactor; //--"--
  int StartCol;  //начало текущей печатаемой страницы
  int StartRow;  //--"--
  TRect RepaintRegion;
  TQRPrinter* FPrinter;
  Smallint FMode;

  /* */
    TWTVMachine* FVM;
  TWTTPC *TPComp;
  /**/


  TWTExec* FExec;

  TTimer *Timer; //скролинг
  TScrollDirection ScrollTo;
  HRGN OldRgn;
  TRect ClipRgn;
  bool AutoClip;
  Smallint ResCol;
  Smallint ResRow;
  Smallint FTopCell;
  Smallint FLeftCell;
  __property Smallint TopCell = {read=FTopCell, write=FSetTopCell, default=0};
  __property Smallint LeftCell = {read=FLeftCell, write=FSetLeftCell, default=0};
  TPen *DefLine;
  TFont *DefFont;
  virtual void __fastcall Paint();
  void __fastcall PaintRegion(TRect Rect,bool DrawData,bool DrawSel);
  Smallint __fastcall RightCell();
  Smallint __fastcall BottomCell();
  TPanel *FPanel;
  TPanel *SPanel;
  Smallint FStay;
  TMemo *CellEdit;
  TWTScrollBar *VertScrollBar;
  TWTScrollBar *HorScrollBar;
  bool FShowGroups;
  virtual void __fastcall WndProc(Messages::TMessage &Message);
  bool __fastcall MoveToSel(bool Align=false);
  void __fastcall DrawEditor();
  void __fastcall DrawHeaders();
  void __fastcall CellEditExit(TObject *Sender);
  void __fastcall CellEditKeyDown(TObject *Sender,Word &Key,TShiftState State);
  void __fastcall DrawButton(TRect Rect,AnsiString Text,bool Down=false);
  void __fastcall SetClipRgn(TRect Rect,TCanvas* DestCanvas=NULL);
  void __fastcall UnsetClipRgn();
  TPos __fastcall GetCellDim(int X,int Y);
  TRect __fastcall GetNewSelection(TRect Rect);
  void __fastcall DrawCellFill(int X,int Y,int Left,int Top,TCanvas* DestCanvas=NULL);
  void __fastcall RedrawSel(TRect OS,TRect NS);
  void __fastcall OnScrollTime(TObject *Sender);
  void __fastcall FSetMode(Smallint Value);
  void __fastcall FSetTopCell(Smallint Value);
  void __fastcall FSetLeftCell(Smallint Value);
  void __fastcall OnVertScroll(System::TObject* Sender, TScrollCode ScrollCode, int &ScrollPos);
  void __fastcall OnHorScroll(System::TObject* Sender, TScrollCode ScrollCode, int &ScrollPos);
  void __fastcall OnVertChange(System::TObject* Sender);
  void __fastcall OnHorChange(System::TObject* Sender);
  void __fastcall SetShowGroups(bool Value);
public:
  __property bool ShowGroups = {read=FShowGroups, write=SetShowGroups, default=true};
  __property Smallint Mode = {read=FMode, write=FSetMode, default=0};
  __property TWTExec* Exec = {read=FExec};
  __property TQRPrinter* Printer = {read=FPrinter, default=NULL};
//
 __property TWTVMachine* VM = {read=FVM, nodefault};

  void __fastcall PrintPrepare();
  TWTGridGroupList* Groups;
  AnsiString GridName;
  TWTGridAdapter* Adapter;
  TWTPrintSettings *PrintSettings;
  TZDataset *DataSet;
  TFont *HeadersFont;
  TRect Selection;
  Smallint XSize;
  Smallint YSize;
  Smallint FixedTop;
  Smallint FixedLeft;
  Smallint GroupWidth;
  TWTCell *Cells[MaxX][MaxY];
  TWTGridColumn *Columns[MaxX];
  TWTGridRow *Rows[MaxY];
  void __fastcall NextRow();
  void __fastcall PrevRow();
  void __fastcall NextCol();
  void __fastcall PrevCol();
  virtual __fastcall TWTCellGrid(TComponent *AOwner,Smallint X,Smallint Y,TWTExec* Exec=NULL);
  __fastcall ~TWTCellGrid();
  DYNAMIC void __fastcall KeyPress(char &Key);
  DYNAMIC void __fastcall KeyDown(Word &Key,TShiftState Shift);
  DYNAMIC void __fastcall KeyUp(Word &Key,TShiftState Shift);
  void __fastcall FFKeyPress(TObject* Sender, char &Key);
  void __fastcall FFKeyDown(TObject* Sender, Word &Key,TShiftState Shift);
  void __fastcall FFMouseDown(TObject *Sender);
  TPos __fastcall GetClickedCell(Word XPos,Word YPos);
  TPos __fastcall GetCellPos(Smallint XCell,Smallint YCell); //позиция ячейки относительно TopCell и LeftCell
  TPos __fastcall AbsCellPos(Smallint XCell,Smallint YCell); //позиция ячейки относительно StartCol и StartRow
  void __fastcall SelCellsDraw(TBrush *Fill,TPen *LBound,TPen *TBound,TPen *RBound,TPen *BBound,TPen *IBound);
  void __fastcall JoinCells(TRect Rect);
  void __fastcall JoinCells();
  void __fastcall CancelJoin(TRect Rect);
  void __fastcall CancelJoin();
  void __fastcall SetImages(AnsiString FileName,TRect Rect);
  void __fastcall SetImages(AnsiString FileName);
  void __fastcall CancelImages(TRect Rect);
  void __fastcall CancelImages();
  void __fastcall Select(TRect Rect);
  void __fastcall SetVAlign(TVAlignment Align);
  void __fastcall SetHAlign(TAlignment Align);
  void __fastcall SetFont(TFont *NewFont);
  void __fastcall ReplaceSel(TPos ToPos,bool Copy=false);
  bool __fastcall SaveToFile(AnsiString FileName);
  bool __fastcall LoadFromFile(AnsiString FileName);
  void __fastcall SaveToFile(FILE* f);
  void __fastcall LoadFromFile(FILE* f);
  void __fastcall Create(Smallint X,Smallint Y);
  AnsiString Text;

  TWTCellsCompiler* OnFirstDupPrint;
  TWTCellsCompiler* OnLastDupPrint;
  TWTCellsCompiler* OnNextDupPrint;
  TWTCellsCompiler* OnPagePrint;
};

class TWTScrollBar: public TScrollBar {
protected:
  virtual void __fastcall WndProc(Messages::TMessage &Message);

public:
  virtual __fastcall TWTScrollBar(TComponent *AOwner);
};

class TWTCell: public TObject {
friend class TWTCellGrid;
private:
  Graphics::TBitmap *Image;
  TEdit* Edit;
  TWTCellsCompiler *Compiler;
  bool IsFormula;
  TWTCellGrid *ParentGrid;
public:
  __property bool Formula = {read=IsFormula, default=NULL};
  __property TWTCellsCompiler *CellsCompiler  = {read=Compiler, default=NULL};
  int OverCol;
  int OverRow;
  TPos ParentCell;
  TPen *TopLine;
  TPen *LeftLine;
  TPen *BottomLine;
  TPen *RightLine;
  TBrush *Filling;
  TStringList *Text;
  TVAlignment VAlign;
  TAlignment HAlign;
  TFont *Font;
  float TextInterval;
  virtual __fastcall TWTCell(TWTCellGrid *Grid,Smallint X,Smallint Y);
  __fastcall ~TWTCell();
  void __fastcall SaveToFile(FILE* File);
  void __fastcall LoadFromFile(FILE* File);
};

class TWTGridColumn: public TObject {
protected:
public:
  Smallint Width;
  AnsiString Title;
  TWTCell **Cells;
  virtual __fastcall TWTGridColumn(TWTCellGrid* Grid, Smallint ColNum);
  void __fastcall SaveToFile(FILE* File);
  void __fastcall LoadFromFile(FILE* File);
};

class TWTGridRow: public TObject {
friend class TWTGridGroupList;
protected:
  TWTGridGroup* FGroup;
public:
  __property TWTGridGroup* Group = {read=FGroup, nodefault};
  Smallint Height;
  AnsiString Title;
  virtual __fastcall TWTGridRow(TWTCellGrid* Grid, Smallint RowNum);
  void __fastcall SaveToFile(FILE* File);
  void __fastcall LoadFromFile(FILE* File);
};


class TWTGridGroupList;

class TWTGridGroup: public TObject {
friend class TWTGridRow;
friend class TWTGridGroupList;
protected:
  int FType;
  void __fastcall SetType(int Value);
  void __fastcall SetRowCount(int Value);
  void __fastcall RefreshGroups();
//  void __fastcall SetStartRow(int Value);
  TWTGridGroupList* FGroups;
  int FLevel;
  TWTGridGroupList* FParentGroups;
  int FRowCount;
//  int FStartRow;
public:
  __property int Type = {read=FType, write=SetType};
  __property TWTGridGroupList* Groups = {read=FGroups, nodefault};
  __property int RowCount = {read=FRowCount, write=SetRowCount};
//  __property int StartRow = {read=FStartRow, SetStartRow};
  __property int Level = {read=FLevel, nodefault};
  __property TWTGridGroupList* ParentGroups = {read=FParentGroups, nodefault};
  AnsiString Name;

  TWTCellsCompiler* OnPrint;
  virtual __fastcall TWTGridGroup(TWTGridGroupList* Parent);
  __fastcall ~TWTGridGroup();
};

class TWTGridGroupList: public TList {
protected:
  TWTCellGrid* FCellGrid;
  TWTGridGroup* FParentGroup;
  void __fastcall SetCellGrid(TWTCellGrid* Value);
public:
  void __fastcall AddGroup(AnsiString GroupName,int RowCount);
  void __fastcall RemoveGroup(AnsiString GroupName);
  void __fastcall RemoveGroup(int Index);
  int __fastcall GroupByRow(int Row);
  __property TWTCellGrid* CellGrid = {read=FCellGrid, write=SetCellGrid};
  __property TWTGridGroup* ParentGroup = {read=FParentGroup, nodefault};
  TWTGridGroup* __fastcall Get(int Index);
  virtual __fastcall TWTGridGroupList(TWTGridGroup *Group);
  __fastcall ~TWTGridGroupList();
};

#endif
