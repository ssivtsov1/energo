//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "WTGrids.h"
#include "WinGrid.h"

//---------------------------------------------------------------------------
#pragma package(smart_init)

#include <direct.h>

AnsiString __fastcall SetAppPath(){
  AnsiString Drive=Application->ExeName.SubString(1,1).UpperCase();
  int IntDrive=Drive[1]-char('A')+1;
  _chdrive(IntDrive);
  AnsiString Path=Application->ExeName.SubString(1,Application->ExeName.LastDelimiter("\\")-1);
  chdir(Path.c_str());
  return Path;
}

bool CompareFonts(TFont *Font1,TFont *Font2) {
  if ((Font1->Charset==Font2->Charset) &&
      (Font1->Color==Font2->Color) &&
      (Font1->Height==Font2->Height) &&
      (Font1->Name==Font2->Name) &&
      (Font1->Pitch==Font2->Pitch) &&
      (Font1->Size==Font2->Size) &&
      (Font1->Style==Font2->Style)) return 1;
  return 0;
}

AnsiString __fastcall ReadString(FILE *File){
  char a[255];
  fgets(a,255,File);
  AnsiString A=a;
  return A.SubString(1,A.Length()-1);
}

void __fastcall PenToFile(TPen *Pen,FILE *File){
  TColor Color=Pen->Color;
  TPenMode Mode=Pen->Mode;
  TPenStyle Style=Pen->Style;
  int Width=Pen->Width;
  fwrite(&Width,sizeof(int),1,File);
  if (Width==0) return;
  fwrite(&Color,sizeof(TColor),1,File);
  fwrite(&Mode,sizeof(TPenMode),1,File);
  fwrite(&Style,sizeof(TPenStyle),1,File);
}

void __fastcall PenFromFile(TPen *Pen,FILE *File){
  TColor Color;
  TPenMode Mode;
  TPenStyle Style;
  int Width;
  fread(&Width,sizeof(int),1,File);
  if (!Width) return;
  fread(&Color,sizeof(TColor),1,File);
  fread(&Mode,sizeof(TPenMode),1,File);
  fread(&Style,sizeof(TPenStyle),1,File);
  Pen->Color=Color;
  Pen->Mode=Mode;
  Pen->Style=Style;
  Pen->Width=Width;
}

void __fastcall BrushToFile(TBrush *Brush,FILE *File){
  TColor Color=Brush->Color;
  TBrushStyle Style=Brush->Style;
  fwrite(&Color,sizeof(TColor),1,File);
  fwrite(&Style,sizeof(TBrushStyle),1,File);
}

void __fastcall BrushFromFile(TBrush *Brush,FILE *File){
  TColor Color;
  TBrushStyle Style;
  fread(&Color,sizeof(TColor),1,File);
  fread(&Style,sizeof(TBrushStyle),1,File);
  Brush->Color=Color;
  Brush->Style=Style;
}

void __fastcall FontToFile(TFont *Font,FILE *File){
  TFontCharset Charset=Font->Charset;
  TColor Color=Font->Color;
  int Height=Font->Height;
  fwrite(&Charset,sizeof(TFontCharset),1,File);
  fwrite(&Color,sizeof(TColor),1,File);
  fwrite(&Height,sizeof(int),1,File);

  fputs(Font->Name.c_str(),File);
  fputc('\n',File);

  TFontPitch Pitch=Font->Pitch;
  int Size=Font->Size;
  fwrite(&Pitch,sizeof(TFontPitch),1,File);
  fwrite(&Size,sizeof(int),1,File);

  fputc(Font->Style.Contains(fsBold),File);
  fputc(Font->Style.Contains(fsItalic),File);
  fputc(Font->Style.Contains(fsUnderline),File);
  fputc(Font->Style.Contains(fsStrikeOut),File);
}

void __fastcall FontFromFile(TFont *Font,FILE *File){
  TFontCharset Charset;
  TColor Color;
  int Height;
  fread(&Charset,sizeof(TFontCharset),1,File);
  fread(&Color,sizeof(TColor),1,File);
  fread(&Height,sizeof(int),1,File);
  Font->Charset=Charset;
  Font->Color=Color;
  Font->Height=Height;

  Font->Name=ReadString(File);

  TFontPitch Pitch;
  int Size;
  fread(&Pitch,sizeof(TFontPitch),1,File);
  fread(&Size,sizeof(int),1,File);
  Font->Pitch=Pitch;
  Font->Size=Size;

  if (fgetc(File)) Font->Style=Font->Style << fsBold;
  else Font->Style=Font->Style >> fsBold;
  if (fgetc(File)) Font->Style=Font->Style << fsItalic;
  else Font->Style=Font->Style >> fsItalic;
  if (fgetc(File)) Font->Style=Font->Style << fsUnderline;
  else Font->Style=Font->Style >> fsUnderline;
  if (fgetc(File)) Font->Style=Font->Style << fsStrikeOut;
  else Font->Style=Font->Style >> fsStrikeOut;
}

void ChangeCursor(TCursor Cursor){
  SetCursor(Screen->Cursors[Cursor]);
}

__fastcall TWTCellGrid::TWTCellGrid(TComponent *AOwner,Smallint X,Smallint Y,TWTExec* CExec) : TDrawGrid(AOwner){

  //инициализируем интерпретатор
/*  FTPComp=new TWTTPC();

  FVM=new TWTVMachine(NULL);*/

  if (CExec==NULL) FExec=new TWTExec();
  else FExec=CExec;

  Adapter=new TWTGridAdapter(this);

  OnFirstDupPrint=new TWTCellsCompiler(Exec);
  OnLastDupPrint=new TWTCellsCompiler(Exec);
  OnNextDupPrint=new TWTCellsCompiler(Exec);
  OnPagePrint=new TWTCellsCompiler(Exec);

  OnNextDupPrint->Add("0;");
  OnFirstDupPrint->Add("1;");

  PrintSettings=new TWTPrintSettings();

  ScrollBars=ssNone;
  FPrinter=NULL;

  DataSet=NULL;
  Timer=new TTimer(this);
  Timer->Interval=100;
  Timer->OnTimer=OnScrollTime;
  ScrollTo.Clear();
  OldRgn=NULL;
  AutoClip=true;
  FixedTop=20;
  FixedLeft=80;
  Cursor=crHandPoint;
  Width=300;
  Height=300;
  XSize=X;
  YSize=Y;
  GroupWidth=50;

  DefFont=new TFont();

  HeadersFont=new TFont();
  HeadersFont->Style=HeadersFont->Style << fsBold;

  CellEdit=new TMemo(this);
  CellEdit->BorderStyle=Forms::bsNone;
  CellEdit->OnExit=CellEditExit;
  CellEdit->OnKeyDown=CellEditKeyDown;

  Color=clWhite;
  FStay=0;

  for (Smallint x=0;x<MaxX;x++) {
    Columns[x]=NULL;
    for (Smallint y=0;y<MaxY;y++) {
      Rows[y]=NULL;
      Cells[x][y]=NULL;
    }
  }

  for ( Smallint x=0;x<X;x++) {
    Columns[x]=new TWTGridColumn(this,x);
    for (Smallint y=0;y<Y;y++) {
      new TWTCell(this,x,y);
      Cells[x][y]->Text->Add("10");
    }
  }
  for (Smallint y=0;y<Y;y++) {
    Rows[y]=new TWTGridRow(this,y);
  }

  Select(TRect(0,0,0,0));
  DefLine=new TPen();
  DefLine->Color=clSilver;

  ControlStyle.Clear();
  ControlStyle=ControlStyle << csCaptureMouse << csOpaque << csDoubleClicks << csFramed << csClickEvents << csSetCaption;
  OnClick=FFMouseDown;
  OnKeyPress=FFKeyPress;
  OnKeyDown=FFKeyDown;
  TabStop=true;

  TPanel *P=new TPanel(this);
  P->Align=alRight;
  P->Caption="";
  P->Width=16;
  P->BevelInner=bvNone;
  P->BevelOuter=bvNone;
  P->Parent=this;

  VertScrollBar=new TWTScrollBar(this);
  VertScrollBar->Kind=sbVertical;
  VertScrollBar->Align=alClient;
  VertScrollBar->Position=0;
  VertScrollBar->OnChange=OnVertChange;
  VertScrollBar->OnScroll=OnVertScroll;
  VertScrollBar->Min=0;
  VertScrollBar->Max=Y-1;
  VertScrollBar->Parent=P;
//  VertScrollBar->ControlStyle=VertScrollBar->ControlStyle >> csReflector;

  P=new TPanel(this);
  P->Align=alBottom;
  P->Caption="";
  P->Height=16;
  P->BevelInner=bvNone;
  P->BevelOuter=bvNone;
  P->Parent=this;

  SPanel=new TPanel(this);
  SPanel->Align=alRight;
  SPanel->Width=16;
  SPanel->Caption="";
  SPanel->BevelInner=bvNone;
  SPanel->BevelOuter=bvNone;
  SPanel->Parent=P;

  HorScrollBar=new TWTScrollBar(this);
  HorScrollBar->Kind=sbHorizontal;
  HorScrollBar->Align=alClient;
  HorScrollBar->Position=0;
  HorScrollBar->OnChange=OnHorChange;
  HorScrollBar->OnScroll=OnHorScroll;
  HorScrollBar->Min=0;
  HorScrollBar->Max=X-1;
  HorScrollBar->Parent=P;


  Mode=gmCalculated;
  TopCell=0;
  LeftCell=0;

  XFactor=25.4/72;
  YFactor=XFactor;
  Groups=new TWTGridGroupList(NULL);
  Groups->CellGrid=this;
  Groups->AddGroup("main",YSize);

  FShowGroups=true;

//  XFactor=0.1;
//  YFactor=XFactor;
}

__fastcall TWTCellGrid::~TWTCellGrid(){
  delete OnFirstDupPrint;
  delete OnLastDupPrint;
  delete OnNextDupPrint;
  delete OnPagePrint;
  delete PrintSettings;
  delete DefLine;
  delete DefFont;
  delete Adapter;
  delete Groups;

  delete Exec;

}

  /*
void __fastcall TWTGridAdapter::RemoveDeclaration(AnsiString Name){
  FCellGrid->TPComp->Analizer->Generator->ExtVarsList->DelVar(Name);
}
void __fastcall TWTGridAdapter::AddDeclaration(AnsiString Name,int Offset,AnsiString Type,void* Value){
  FCellGrid->TPComp->Analizer->Generator->AddExternalVar(Name,Offset,Type);
  int Val=*(int*)(Value);
  ((void**)FCellGrid->VM->FTable[0])[Offset]=(void*)Val;
}
void __fastcall TWTGridAdapter::AddFunction(AnsiString Name,AnsiString Type,void* Pointer){
  TWTType* FType=FCellGrid->TPComp->Analizer->Generator->TypesList->TypeByName(Type);
  TWTValue* FValue=NULL;
  if (FCellGrid->VM->FTable[FType->FTable]==NULL) FCellGrid->VM->FTable[FType->FTable]=calloc(100,4);
  if (FType!=NULL) FValue=FType->Funcs->VarByName(Name);
  if (FValue!=NULL) ((void**)FCellGrid->VM->FTable[FType->FTable])[FValue->Offset]=Pointer;
}
    */
void __fastcall TWTCellGrid::FFKeyDown(TObject* Sender, Word &Key,TShiftState Shift){
}


void __fastcall TWTCellGrid::FFKeyPress(TObject* Sender, char &Key){
  switch (Key) {
  case 0: {
      break;
    }
  }
}

void __fastcall TWTCellGrid::KeyPress(char &Key) {
}

void __fastcall TWTCellGrid::KeyDown(Word &Key,TShiftState Shift){
  TRect OldSelection=Selection;
  bool Flag=false;
  bool AllF=false;
  switch (Key) {
    //PgUp
    case 33:{
      //просто
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        int OldY=Selection.Top-TopCell;
        if (OldY<0) OldY=0;
        int OldTop=TopCell;
        while (BottomCell()!=OldTop-1 && TopCell!=0) {
          Flag=true;
          TopCell--;
        }
        if (Flag) {
          Select(TRect(Selection.Left,TopCell+OldY,Selection.Left,TopCell+OldY));
          Paint();
        } else {
          Select(TRect(Selection.Left,TopCell,Selection.Left,TopCell));
          RedrawSel(OldSelection,Selection);
        }
      }
      //с Shift
      if (Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        if (Selection.Top==Selection.Bottom) return;
//        int OldY=Selection.Top-TopCell;
        int OldTop=TopCell;

        if (Selection.Top<TopCell) {
          while (BottomCell()!=OldTop-1 && TopCell!=0 && Selection.Top<TopCell) {
            TopCell--;
          }
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,OldSelection.Bottom-OldTop+TopCell));
          Paint();
        } else {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,OldSelection.Top));
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift и Ctrl
      if (Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        if (Selection.Top==Selection.Bottom) return;
        if (Selection.Top<TopCell) {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,TopCell));
          Paint();
        } else {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,OldSelection.Top));
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Ctrl
      if (!Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,TopCell,Selection.Left,TopCell));
        RedrawSel(OldSelection,Selection);
      }
      Flag=false;
      break;
    }
    //PgDown
    case 34:{
      //просто
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        int BC=BottomCell();
        int OldY=Selection.Bottom-TopCell;
        int OldBottom=BC;
        while (TopCell!=OldBottom+1 && BottomCell()+1!=YSize) {
          Flag=true;
          TopCell++;
        }
        BC=BottomCell();
        if (Flag) {
          Select(TRect(Selection.Left,TopCell+OldY,Selection.Left,TopCell+OldY));
          Paint();
        } else {
          Select(TRect(Selection.Left,BC,Selection.Left,BC));
          RedrawSel(OldSelection,Selection);
        }
      }
      //с Shift
      if (Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        int BC=BottomCell();
        int OldY=Selection.Bottom-TopCell;
        int OldBottom=BC;
        while (TopCell!=OldBottom+1 && BottomCell()+1!=YSize) {
          Flag=true;
          TopCell++;
        }
        BC=BottomCell();
        if (Flag) {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,TopCell+OldY));
          Paint();
        } else {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,BC));
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift и Ctrl
      if (Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,BottomCell()));
        RedrawSel(OldSelection,Selection);
      }
      //c Ctrl
      if (!Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,BottomCell(),Selection.Left,BottomCell()));
        RedrawSel(OldSelection,Selection);
      }
      Flag=false;
      break;
    }
    //End
    case 35: {
      //ѕросто
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        Select(TRect(XSize-1,Selection.Top,XSize-1,Selection.Top));
        if (RightCell()!=XSize-1) {
          LeftCell=XSize-1;
          while (RightCell()==XSize-1) LeftCell--;
          LeftCell++;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift
      if (Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,OldSelection.Top,XSize-1,Selection.Bottom));
        if (RightCell()!=XSize) {
          LeftCell=XSize-1;
          while (RightCell()==XSize-1) LeftCell--;
          LeftCell++;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift и Ctrl
      if (Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,YSize-1));
        if (BottomCell()!=YSize-1) {
          TopCell=YSize-1;
          while (BottomCell()==YSize-1) TopCell--;
          TopCell++;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Ctrl
      if (!Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,YSize-1,Selection.Left,YSize-1));
        if (BottomCell()!=YSize-1) {
          TopCell=YSize-1;
          while (BottomCell()==YSize-1) TopCell--;
          TopCell++;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      Flag=false;
      break;
    }
    //Home
    case 36: {
      //просто
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        Select(TRect(0,Selection.Top,0,Selection.Top));
        if (LeftCell!=0) {
          LeftCell=0;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift
      if (Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) {
        if (Selection.Left==Selection.Right) return;
        if (Selection.Left<LeftCell) {
          LeftCell=Selection.Left;
          Select(TRect(OldSelection.Left,OldSelection.Top,OldSelection.Left,OldSelection.Bottom));
          Paint();
        } else {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Left,OldSelection.Bottom));
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Shift и Ctrl
      if (Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        if (Selection.Top==Selection.Bottom) return;
        if (Selection.Top<TopCell) {
          TopCell=Selection.Top;
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,OldSelection.Top));
          Paint();
        } else {
          Select(TRect(Selection.Left,OldSelection.Top,Selection.Right,OldSelection.Top));
          RedrawSel(OldSelection,Selection);
        }
      }
      //c Ctrl
      if (!Shift.Contains(ssShift) && Shift.Contains(ssCtrl)) {
        Select(TRect(Selection.Left,0,Selection.Left,0));
        if (TopCell!=0) {
          TopCell=0;
          Paint();
        } else {
          RedrawSel(OldSelection,Selection);
        }
      }
      Flag=false;
      break;
    }
    //Left
    case 37: {
      if (Shift.Contains(ssShift)) {
        if (Cells[Selection.Right][Selection.Top]->ParentCell.X>Selection.Left) {
          Selection.Right=Cells[Selection.Right][Selection.Top]->ParentCell.X-1;
          Flag=true;
          if (Selection.Right<LeftCell) {
            LeftCell=Selection.Right;
            Paint();
            AllF=true;
          }
        }
      }
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) PrevCol();
      if (Shift.Contains(ssCtrl)) {
        Flag=false;
        if (LeftCell) {
          LeftCell--;
          Flag=true;
        }
        if (Flag) Paint();
      }
      break;
    }
    //up
    case 38: {
      if (Shift.Contains(ssShift)) {
        if (Cells[Selection.Right][Selection.Bottom]->ParentCell.Y>Selection.Top) {
          Selection.Bottom=Cells[Selection.Right][Selection.Bottom]->ParentCell.Y-1;
          Flag=true;
          if (Selection.Bottom<TopCell) {
            TopCell=Selection.Bottom;
            Paint();
            AllF=true;
          }
        }
      }
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) PrevRow();
      if (Shift.Contains(ssCtrl)) {
        Flag=false;
        if (TopCell) {
          TopCell--;
          Flag=true;
        }
        if (Flag) Paint();
      }
      break;
    }
    //right
    case 39: {
      if (Shift.Contains(ssShift)) {
        if (Selection.Right<XSize-1) {
          Selection.Right+=1;
          Select(Selection);
          Flag=true;
          AllF=MoveToSel();
        }
      }
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) NextCol();
      if (Shift.Contains(ssCtrl)) {
        Flag=false;
        if (RightCell()!=XSize-1) {
          LeftCell++;
          Flag=true;
        }
        if (Flag) Paint();
      }
      break;
    }
    //down
    case 40: {
      if (Shift.Contains(ssShift)) {
        if (Selection.Bottom<YSize-1) {
          Selection.Bottom+=1;
          Select(Selection);
          Flag=true;
          AllF=MoveToSel();
        }
      }
      if (!Shift.Contains(ssShift) && !Shift.Contains(ssCtrl)) NextRow();
      if (Shift.Contains(ssCtrl)) {
        Flag=false;
        if (BottomCell()!=YSize-1) {
          TopCell++;
          Flag=true;
        }
        if (Flag) Paint();
      }
      break;
    }
    case 13: {
      if (Shift.Contains(ssShift)) {
        JoinCells();
      } else {
        DrawEditor();
        FStay=gsEdit;
      }
      break;
    }
    case 46: {
      if (FStay==gsNormal) {
        for (int x=Selection.Left;x<=Selection.Right;x++) {
          for (int y=Selection.Top;y<=Selection.Bottom;y++) {
            if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y) {
              if (Cells[x][y]->Image) {
                delete Cells[x][y]->Image;
                Cells[x][y]->Image=NULL;
              }
              if (Cells[x][y]->IsFormula) {
                Cells[x][y]->IsFormula=false;
                Cells[x][y]->Compiler->Clear();
              }
              Cells[x][y]->Text->Clear();
            }
          }
        }
        PaintRegion(Selection,true,true);
      }
      break;
    }
    case 27: {
      if (Shift.Contains(ssShift)) {
        CancelJoin();
      }
      break;
    }
  }
  if (Flag) {
    if (!AllF) RedrawSel(OldSelection,Selection);
  }
}

void __fastcall TWTCellGrid::DrawEditor(){
  PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
  Select(TRect(Selection.Left,Selection.Top,Selection.Left,Selection.Top));
  MoveToSel();
  TPos Pos=GetCellPos(Selection.Left,Selection.Top);
  Pos.X+=FixedLeft;
  Pos.Y+=FixedTop;
  TPos RDim=GetCellDim(Selection.Left,Selection.Top);
  CellEdit->Left=Pos.X+3;
  CellEdit->Top=Pos.Y+3;
  CellEdit->Width=RDim.X-3;
  CellEdit->Height=RDim.Y-3;
  CellEdit->Parent=this;
  CellEdit->Color=Cells[Selection.Left][Selection.Top]->Filling->Color;
  CellEdit->Font->Assign(Cells[Selection.Left][Selection.Top]->Font);
  if (Cells[Selection.Left][Selection.Top]->IsFormula) {
    CellEdit->Lines->Assign(Cells[Selection.Left][Selection.Top]->Compiler);
    CellEdit->Lines->Insert(0,"#"+CellEdit->Lines->Strings[0]);
    CellEdit->Lines->Delete(1);
  } else CellEdit->Lines->Assign(Cells[Selection.Left][Selection.Top]->Text);
  CellEdit->SetFocus();
  CellEdit->Alignment=Cells[Selection.Left][Selection.Top]->HAlign;
  CellEdit->SelectAll();
  CellEdit->SelLength--;
  CellEdit->SelLength--;
}

TPos __fastcall TWTCellGrid::GetCellPos(Smallint XCell,Smallint YCell){
  TPos Pos;
  Pos.X=0;
  Pos.Y=0;
  if (XCell>LeftCell) {
    for (Smallint x=LeftCell;x<XCell;x++) {
      Pos.X+=Columns[x]->Width;
    }
  } else {
    for (Smallint x=XCell;x<LeftCell;x++) {
      Pos.X-=Columns[x]->Width;
    }
  }
  if (YCell>TopCell) {
    for (Smallint x=TopCell;x<YCell;x++) {
      Pos.Y+=Rows[x]->Height;
    }
  } else {
    for (Smallint x=YCell;x<TopCell;x++) {
      Pos.Y-=Rows[x]->Height;
    }
  }
  return Pos;
}

TPos __fastcall TWTCellGrid::AbsCellPos(Smallint XCell,Smallint YCell){
  TPos Pos;
  Pos.X=0;
  Pos.Y=0;
  if (XCell>StartCol) {
    for (Smallint x=StartCol;x<XCell;x++) {
      Pos.X+=Columns[x]->Width;
    }
  } else {
    for (Smallint x=XCell;x<StartCol;x++) {
      Pos.X-=Columns[x]->Width;
    }
  }
  if (YCell>StartRow) {
    for (Smallint x=StartRow;x<YCell;x++) {
      Pos.Y+=Rows[x]->Height;
    }
  } else {
    for (Smallint x=YCell;x<StartRow;x++) {
      Pos.Y-=Rows[x]->Height;
    }
  }
  return Pos;

}

void __fastcall TWTCellGrid::CellEditExit(TObject *Sender){
  if (FStay==gsEditCancel) {
    FStay=gsNormal;
    return;
  }
  SetFocus();
  bool Flag=true;
//  if (Cells[Selection.Left][Selection.Top]->CodeData) delete Cells[Selection.Left][Selection.Top]->CodeData;
  Cells[Selection.Left][Selection.Top]->Compiler->Clear();
  if (CellEdit->Lines->Strings[0].Length()) {
    if (CellEdit->Lines->Strings[0][1]=='#') {
      AnsiString Dest=CellEdit->Lines->Strings[0].SubString(2,CellEdit->Lines->Strings[0].Length()-1);
      CellEdit->Lines->Insert(0,Dest);
      CellEdit->Lines->Delete(1);
      Cells[Selection.Left][Selection.Top]->Compiler->Assign(CellEdit->Lines);
      Cells[Selection.Left][Selection.Top]->Compiler->Compile();
//      void *Point;
//      int AllSize,CSize;
//      Point=TPComp->Analizer->Generator->GetCodeData(AllSize,CSize);
//      Cells[Selection.Left][Selection.Top]->AllSize=AllSize;
//      Cells[Selection.Left][Selection.Top]->CSize=CSize;
//      Cells[Selection.Left][Selection.Top]->CodeData=Point;
      Cells[Selection.Left][Selection.Top]->IsFormula=true;
      if (Mode==gmConstructor) Cells[Selection.Left][Selection.Top]->Text->Assign(CellEdit->Lines);
      Flag=false;
    }
  }
  if (Flag) {
//    Cells[Selection.Left][Selection.Top]->CodeData=NULL;
    Cells[Selection.Left][Selection.Top]->IsFormula=false;
    Cells[Selection.Left][Selection.Top]->Text->Assign(CellEdit->Lines);
    //провер€ем привело ли изменение текущей €чейки к изменению еще какой-либо св€занной с ней формулой
    if (Mode==gmCalculated) {
      int Right=RightCell();
      if (RightCell()<XSize) Right++;
      int Bottom=BottomCell();
      if (BottomCell()<YSize) Bottom++;
      for (int x=0;x<Right;x++) {
        for (int y=0;y<Bottom;y++) {
          if (Cells[x][y]->IsFormula) {
            if (!Cells[x][y]->Compiler->Error) {
//              VM->Init(Cells[x][y]->CodeData,(char*)Cells[x][y]->CodeData+Cells[x][y]->CSize);
              Adapter->CalcX=x;
              Adapter->CalcY=y;
//              VM->Run();
              Cells[x][y]->Compiler->Run();
              if (Cells[x][y]->Text->Count) {
                if (Cells[x][y]->Compiler->ResAsString!=Cells[x][y]->Text->Strings[0]) {
                  PaintRegion(TRect(x,y,x,y),true,false);
                }
              }
            }
          }
        }
      }
    }
  }
  CellEdit->Parent=NULL;
  FStay=gsNormal;
  PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
  if (Sender) PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,true);
}

void __fastcall TWTCellGrid::CellEditKeyDown(TObject *Sender,Word &Key,TShiftState State){
  switch (Key) {
 /*   case 37: {
      SetFocus();
      PrevCol();
      break;
    }
    case 38: {
      SetFocus();
      PrevRow();
      break;
    }
    case 39: {
      SetFocus();
      NextCol();
      break;
    }
    case 40: {
      SetFocus();
      NextRow();
      break;
    } */
    case 13: {
      if (State.Contains(ssShift)) {
        State.Clear();
//        SetFocus();
      }
      else SetFocus();
      break;
    }
    case 27: {
      FStay=gsEditCancel;
      SetFocus();
      CellEdit->Parent=NULL;
      FStay=gsNormal;
      PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
      if (Sender) PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,true);
      break;
    }
  }
}



void __fastcall TWTCellGrid::KeyUp(Word &Key,TShiftState Shift){
}


void __fastcall TWTCellGrid::WndProc(Messages::TMessage &Message){
  TCustomControl::WndProc(Message);
  if (Message.Msg==WM_KEYDOWN) {
    if (Message.WParam==13) {
//      KeyDown(Message.WParam,TShiftState());
    }
  } else {
    if (Message.Msg==WM_RBUTTONUP) {
      if (FStay==gsSelMove) {
        ChangeCursor(crMultiDrag);
        FStay=gsSelCopy;
      } else {
        if (FStay==gsSelCopy) {
          ChangeCursor(crDrag);
          FStay=gsSelMove;
        }
      }
    }

    int LeftC;
    int RightC;
    if (ShowGroups) {
      LeftC=GroupWidth;
      RightC=GroupWidth+30;
    }
    else {
      LeftC=0;
      RightC=30;
    }

    if (Message.Msg==WM_LBUTTONDOWN) {
      if (Cursor==crDrag) {
        FStay=gsSelMove;
      }
      if (Cursor==crHandPoint) {
        if (Message.LParamHi<FixedTop && Message.LParamLo>FixedLeft) {
          FStay=gsDragCol;
          PaintRegion(Selection,true,false);
          Select(TRect(ResCol,0,ResCol,YSize-1));
          PaintRegion(Selection,false,true);
        }
        if (Message.LParamLo<FixedLeft && Message.LParamHi>FixedTop) {
          FStay=gsDragRow;
          PaintRegion(Selection,true,false);
          if (!ShowGroups) Select(TRect(0,ResRow,XSize-1,ResRow));
          else if (Message.LParamLo<LeftC) {
            //Select(TRect(0,Groups->Get(Rows[ResRow]->Group)->StartRow,XSize-1,Groups->Get(Rows[ResRow]->Group)->StartRow+Groups->Get(Rows[ResRow]->Group)->RowCount-1));
          } else {
            //Select(TRect(0,ResRow,XSize-1,ResRow));
          }
          PaintRegion(Selection,false,true);
        }
        if (Message.LParamHi<FixedTop && Message.LParamLo<FixedLeft) {
          PaintRegion(Selection,true,false);
          Select(TRect(0,0,XSize-1,YSize-1));
          PaintRegion(Selection,false,true);
        }
      }
      if (Cursor==crHSplit || Cursor==crVSplit) {
        if (Cursor==crHSplit) FStay=gsColResizing;
        else FStay=gsRowResizing;
      } if (Cursor==crCross) {
        FStay=gsSelecting;
        TPos Pos=GetClickedCell(Message.LParamLo,Message.LParamHi);
        if (Pos.X!=-1 && Pos.Y!=-1) {
          PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
          if (FStay==gsEdit) CellEditExit(NULL);
          Select(TRect(Pos.X,Pos.Y,Pos.X,Pos.Y));
          if (!Focused()) SetFocus();
          PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),false,true);
        }
      }
    }
    if (Message.Msg==WM_LBUTTONUP) {
      if (FStay==gsSelCopy) {
        ReplaceSel(GetClickedCell(Message.LParamLo,Message.LParamHi),true);
      }
      if (FStay==gsSelMove) {
        ReplaceSel(GetClickedCell(Message.LParamLo,Message.LParamHi));
      }
      FStay=gsNormal;
    }
    if (Message.Msg==WM_MOUSEMOVE) {
     Smallint Flag=true;

     if (Message.WParam!=MK_LBUTTON) {

      int Cr=Cursor;

      TPos Pos=GetCellPos(Selection.Left,Selection.Top);
      Pos.X+=FixedLeft;
      Pos.Y+=FixedTop;
      if (Message.LParamHi>Pos.Y && Message.LParamHi<Pos.Y+15 && Message.LParamLo>Pos.X && Message.LParamLo<Pos.X+15) {
        if (Cursor!=crDrag) Cr=crDrag;
      } else Cr=crCross;

      if (Message.LParamHi<FixedTop) {
        /*if (Message.LParamLo>FixedLeft)*/ Cr=crHandPoint;
//        else Cr=crCross;
        Smallint Xc=Message.LParamLo;
        Smallint XX=FixedLeft;
        ResCol=GetClickedCell(Message.LParamLo,0).X;
        for (Smallint x=LeftCell;x<XSize && XX<ClientRect.Right-16;x++) {
          XX+=Columns[x]->Width;
          if (Xc>XX-5 && Xc<XX+5) {
               Cr=crHSplit;
               Flag=false;
               ResCol=x;
               break;
          }
          else {
           /*if (Message.LParamLo>FixedLeft)*/ Cr=crHandPoint;
          // else Cr=crCross;
          }
        }
      }

      if (Message.LParamLo<RightC && Message.LParamLo>0) {
        /*if (Message.LParamHi>FixedTop || Message.LParamLo<LeftC)*/ Cr=crHandPoint;
//        else Cr=crCross;
        Smallint Yc=Message.LParamHi;
        Smallint YY=FixedTop;
        ResRow=GetClickedCell(0,Message.LParamHi).Y;
        if (Message.LParamLo>LeftC) {
          for (Smallint y=TopCell;y<YSize && YY<ClientRect.Bottom-16;y++) {
            YY+=Rows[y]->Height;
            if (Yc>YY-5 && Yc<YY+5) {
                 Cr=crVSplit;
                 Flag=false;
                 ResRow=y;
                 break;
            }
            else {
              /*if (Message.LParamHi>FixedTop)*/ Cr=crHandPoint;
//              else Cr=crCross;
            }
          }
        }
      }
      if (Cursor!=Cr) Cursor=Cr;
     }

     bool PaintFlag=false;
     Flag=false;
     TRect OS,NS;

     if (Message.WParam==MK_LBUTTON) {
       if (FStay==gsColResizing) {
         Smallint Old=Columns[ResCol]->Width;
         Columns[ResCol]->Width=Message.LParamLo-GetCellPos(ResCol,0).X-FixedLeft;
         if (Columns[ResCol]->Width<10) Columns[ResCol]->Width=10;
         if (Old!=Columns[ResCol]->Width) {
           PaintRegion(TRect(ResCol,TopCell,RightCell()+1,BottomCell()+1),true,true);
           DrawHeaders();
         }
       }
       if (FStay==gsRowResizing) {
         Smallint Old=Rows[ResRow]->Height;
         Rows[ResRow]->Height=Message.LParamHi-GetCellPos(0,ResRow).Y-FixedTop;
         if (Rows[ResRow]->Height<10) Rows[ResRow]->Height=10;
         if (Old!=Rows[ResRow]->Height) {
           PaintRegion(TRect(LeftCell,ResRow,RightCell()+1,BottomCell()+1),true,true);
           DrawHeaders();
         }
       }
       if (FStay==gsSelMove || FStay==gsSelCopy) {
         if (Message.LParamLo>ClientRect.Right-16-50) {
            ScrollTo=ScrollTo << scdRight;
         } else ScrollTo=ScrollTo >> scdRight;
         if (Message.LParamHi>ClientRect.Bottom-16-50) {
           ScrollTo=ScrollTo << scdBottom;
         } else ScrollTo=ScrollTo >> scdBottom;
         if (Message.LParamLo<50) {
           ScrollTo=ScrollTo << scdLeft;
         } else ScrollTo=ScrollTo >> scdLeft;
         if (Message.LParamHi<50) {
           ScrollTo=ScrollTo << scdTop;
         } else ScrollTo=ScrollTo >> scdTop;
       }

       TRect OldSelection;
       if (FStay==gsSelecting || FStay==gsEdit) {
         OldSelection=Selection;
         if (FStay==gsSelecting) {
           if ((Message.LParamLo>ClientRect.Right-16-50 || Message.LParamLo>(GetCellPos(RightCell(),0).X+FixedLeft+Columns[RightCell()]->Width)) && RightCell()<Selection.Right) {
             LeftCell+=1;
             Flag=true;
             Selection.Right=RightCell();
           }
           if (Message.LParamHi>ClientRect.Bottom-16-50 && BottomCell()<Selection.Bottom) {
             TopCell+=1;
             Flag=true;
             Selection.Bottom=BottomCell();
           }
           if (Message.LParamLo<50 && Selection.Left<LeftCell) {
             LeftCell-=1;
             Flag=true;
             Selection.Right=LeftCell;
           }
           if (Message.LParamHi<50 && Selection.Top<TopCell) {
             TopCell-=1;
             Flag=true;
             Selection.Bottom=TopCell;
           }
           Select(Selection);
           TPos Pos=GetClickedCell(Message.LParamLo,Message.LParamHi);
           if (Pos.X<Selection.Left) Pos.X=Selection.Right;
           if (Pos.Y<Selection.Top) Pos.Y=Selection.Top;
           if (((Pos.X!=Selection.Right && Pos.X>=Selection.Left) || (Pos.Y!=Selection.Bottom && Pos.Y>=Selection.Top)) && (Message.LParamLo<ClientRect.Right-16)) {
             if (!Flag) {
               if (Pos.X>=Selection.Left) { Selection.Right=Pos.X; PaintFlag=true; }
               if (Pos.Y>=Selection.Top) { Selection.Bottom=Pos.Y; PaintFlag=true; }
               Select(Selection);
             }
           }
           if (Flag) Paint();
           else if (PaintFlag) {
             RedrawSel(OldSelection,Selection);
           }
         }
       }
     }
    }
    if (Message.Msg==WM_SETFOCUS) {
    }
    if (Message.Msg==WM_KILLFOCUS) {
    }
  }
}

void __fastcall TWTCellGrid::OnScrollTime(TObject *Sender){
  bool Flag=false;
  if (ScrollTo.Contains(scdLeft) && LeftCell>0) {
    LeftCell-=1;
    Flag=true;
  }
  if (ScrollTo.Contains(scdTop) && TopCell>0) {
    TopCell-=1;
    Flag=true;
  }
  if (ScrollTo.Contains(scdRight) && RightCell()<XSize-1) {
    LeftCell+=1;
    Flag=true;
  }
  if (ScrollTo.Contains(scdBottom) && BottomCell()<YSize-1) {
    TopCell+=1;
    Flag=true;
  }
  if (Flag)
    Paint();
}

void __fastcall TWTCellGrid::FFMouseDown(TObject *Sender){
}

TPos __fastcall TWTCellGrid::GetClickedCell(Word XPos,Word YPos){
  TPos Pos;
  if (XPos>32000) XPos=0;
  if (YPos>32000) YPos=0;
  Smallint XX=FixedLeft;
  Smallint X=LeftCell;
  while (XX<XPos && X<XSize) {
    XX+=Columns[X]->Width;
    X++;
  }
  Pos.X=X-1;
  if (Pos.X<LeftCell) Pos.X=-1;
  XX=FixedTop;
  X=TopCell;
  while (XX<YPos && X<YSize) {
    XX+=Rows[X]->Height;
    X++;
  }
  Pos.Y=X-1;
  if (Pos.Y<TopCell) Pos.Y=-1;
  if (Pos.X>=0 && Pos.Y>=0) Pos=Cells[Pos.X][Pos.Y]->ParentCell;
  return Pos;
}

void __fastcall TWTCellGrid::Paint(){
  PaintRegion(TRect(0,0,XSize-1,YSize-1),true,true);
  DrawHeaders();
}

void __fastcall TWTCellGrid::PaintRegion(TRect Region,bool DrawData,bool DrawSel){
  if (AutoClip) SetClipRgn(TRect(FixedLeft,FixedTop,ClientRect.Right-16,ClientRect.Bottom-16));
  else {
    if (ClipRgn.Top>ClientRect.Bottom-16) return;
    if (ClipRgn.Bottom<FixedTop) return;
    if (ClipRgn.Left>ClientRect.Right-16) return;
    if (ClipRgn.Right<FixedLeft) return;

    if (ClipRgn.Left<FixedLeft) ClipRgn.Left=FixedLeft;
    if (ClipRgn.Top<FixedTop) ClipRgn.Top=FixedTop;
    if (ClipRgn.Right>=ClientRect.Right-16) ClipRgn.Right=ClientRect.Right-16;
    if (ClipRgn.Bottom>=ClientRect.Bottom-16)
      ClipRgn.Bottom=ClientRect.Bottom-16;
    SetClipRgn(ClipRgn);
  }
  TCustomControl::Paint();
  if (Region.Left<LeftCell) Region.Left=LeftCell;
  Smallint XX=0,X=Region.Left,YY,Y;
  for (Smallint i=LeftCell;i<Region.Left;i++) XX+=Columns[i]->Width;
  XX+=FixedLeft;
  TRect Sel;
  Sel.Top=-5;
  Sel.Left=-5;
  Sel.Right=-5;
  Sel.Bottom=-5;
  while ((XX<ClientRect.Right-16) && (X<XSize) && (X<Region.Right+1)) {
    YY=0;
    for (Smallint i=TopCell;i<Region.Top;i++) YY+=Rows[i]->Height;
    YY+=FixedTop;
    if (Region.Top<TopCell) Region.Top=TopCell;
    Y=Region.Top;
    while ((YY<ClientRect.Bottom-16) && (Y<YSize) && (Y<Region.Bottom+1)) {
     if (DrawData) {
        RepaintRegion=Region;
        DrawCellFill(X,Y,FixedLeft,FixedTop);
     }
     TPos Dim;
     Dim.X=Columns[X]->Width;
     Dim.Y=Rows[Y]->Height;
     if (X==XSize-1) {
       Canvas->Brush->Color=Color;
       Canvas->FillRect(TRect(XX+Dim.X+Cells[X][Y]->RightLine->Width/2+1,YY,ClientRect.Right-16,YY+Dim.Y+5));
     }
     YY+=Rows[Y]->Height;
     Y++;
    }
    if (Y==YSize) {
     if (DrawData) {
      Canvas->Brush->Color=Color;
      Canvas->FillRect(TRect(XX,YY+Cells[X][Y-1]->BottomLine->Width/2+1,XX+Columns[X]->Width+5,ClientRect.Bottom-16));

      if (Cells[X][Y-1]->BottomLine->Width==0) Canvas->Pen->Assign(DefLine);
        else Canvas->Pen->Assign(Cells[X][Y-1]->BottomLine);
      Canvas->MoveTo(XX,YY);
      Canvas->LineTo(XX+Columns[X]->Width,YY);
     }
    }

    XX+=Columns[X]->Width;
    X++;
  }

  TPos PosLT=GetCellPos(Selection.Left,Selection.Top);
  TPos PosRB=GetCellPos(Selection.Right,Selection.Bottom);
  PosLT.X+=FixedLeft;
  PosLT.Y+=FixedTop;
  PosRB.X+=FixedLeft;
  PosRB.Y+=FixedTop;
  Sel.Left=PosLT.X;
  Sel.Top=PosLT.Y;
  Sel.Right=PosRB.X+Columns[Selection.Right]->Width;
  Sel.Bottom=PosRB.Y+Rows[Selection.Bottom]->Height;


  if (DrawSel) {

    Canvas->Pen->Width=4;
    Canvas->Pen->Color=clBlue;
    Canvas->MoveTo(Sel.Left+2,Sel.Top+2);
    Canvas->LineTo(Sel.Right-1,Sel.Top+2);
    Canvas->MoveTo(Sel.Right-1,Sel.Top+2);
    Canvas->LineTo(Sel.Right-1,Sel.Bottom-1);
    Canvas->MoveTo(Sel.Right-1,Sel.Bottom-1);
    Canvas->LineTo(Sel.Left+2,Sel.Bottom-1);
    Canvas->MoveTo(Sel.Left+2,Sel.Bottom-1);
    Canvas->LineTo(Sel.Left+2,Sel.Top+2);
    Canvas->Brush->Color=Color;
    Canvas->Pen->Color=clBlack;
    Canvas->Pen->Width=1;
    Canvas->Rectangle(Sel.Left,Sel.Top,Sel.Left+SB_SIZE,Sel.Top+SB_SIZE);
  }
  DrawHeaders();
  if (AutoClip) SetClipRgn(TRect(0,0,ClientRect.Right-16,ClientRect.Bottom-16));
}


void __fastcall TWTCellGrid::RedrawSel(TRect OS,TRect NS){
  AutoClip=false;
  bool Flag=true;

  int OldStay=FStay;
  FStay=gsSelRepaint;

  //ѕерерисовываем верх
  if (OS.Top==NS.Top) {
    if (NS.Left>=OS.Left && NS.Left<=OS.Right) {
      int LO=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
      int LN=GetCellPos(NS.Left,NS.Top).X+FixedLeft;
      int T=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
      SetClipRgn(TRect(LO,T,LN+1,T+4));
      PaintRegion(TRect(OS.Left,OS.Top,NS.Left-1,OS.Top),true,false);
      Flag=false;
    }
    if (NS.Right>=OS.Left && NS.Right<=OS.Right) {
      int RO=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
      int RN=GetCellPos(NS.Right,NS.Top).X+Columns[NS.Right]->Width+FixedLeft;
      int T=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
      SetClipRgn(TRect(RN,T,RO+1,T+4));
      PaintRegion(TRect(NS.Right+1,OS.Top,OS.Right,OS.Top),true,false);
      Flag=false;
    }
  }
  if (Flag) {
    int LO=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
    int RO=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
    int T=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
    SetClipRgn(TRect(LO,T,RO+1,T+4));
    PaintRegion(TRect(OS.Left,OS.Top,OS.Right,OS.Top),true,false);
  }

  //ѕерерисовываем низ
  Flag=true;
  if (OS.Bottom==NS.Bottom) {
    if (NS.Left>=OS.Left && NS.Left<=OS.Right) {
      int LO=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
      int LN=GetCellPos(NS.Left,NS.Top).X+FixedLeft;
      int B=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
      SetClipRgn(TRect(LO,B-3,LN+1,B+1));
      PaintRegion(TRect(OS.Left,OS.Bottom,NS.Left-1,OS.Bottom),true,false);
      Flag=false;
    }
    if (NS.Right>=OS.Left && NS.Right<=OS.Right) {
      int RO=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
      int RN=GetCellPos(NS.Right,NS.Top).X+Columns[NS.Right]->Width+FixedLeft;
      int B=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
      SetClipRgn(TRect(RN,B-3,RO+1,B+1));
      PaintRegion(TRect(NS.Right+1,OS.Bottom,OS.Right,OS.Bottom),true,false);
      Flag=false;
    }
  }
  if (Flag) {
    int LO=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
    int RO=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
    int B=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
    SetClipRgn(TRect(LO,B-3,RO+1,B+1));
    PaintRegion(TRect(OS.Left,OS.Bottom,OS.Right,OS.Bottom),true,false);
  }

  //ѕерерисовываем лево
  Flag=true;
  if (OS.Left==NS.Left) {
    if (NS.Top>=OS.Top && NS.Top<=OS.Bottom) {
      int TO=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
      int TN=GetCellPos(NS.Left,NS.Top).Y+FixedTop;
      int L=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
      SetClipRgn(TRect(L,TO,L+4,TN+1));
      PaintRegion(TRect(OS.Left,OS.Top,OS.Left,NS.Top-1),true,false);
      Flag=false;
    }
    if (NS.Bottom>=OS.Top && NS.Bottom<=OS.Bottom) {
      int BO=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
      int BN=GetCellPos(NS.Left,NS.Bottom).Y+Rows[NS.Bottom]->Height+FixedTop;
      int L=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
      SetClipRgn(TRect(L,BN,L+4,BO+1));
      PaintRegion(TRect(OS.Left,NS.Bottom+1,OS.Left,OS.Bottom),true,false);
      Flag=false;
    }
  }
  if (Flag) {
    int TO=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
    int BO=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
    int L=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
    SetClipRgn(TRect(L,TO,L+4,BO+1));
    PaintRegion(TRect(OS.Left,OS.Top,OS.Left,OS.Bottom),true,false);
  }

  //ѕерерисовываем право
  Flag=true;
  if (OS.Right==NS.Right) {
    if (NS.Top>=OS.Top && NS.Top<=OS.Bottom) {
      int TO=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
      int TN=GetCellPos(NS.Left,NS.Top).Y+FixedTop;
      int R=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
      SetClipRgn(TRect(R-3,TO,R+1,TN+1));
      PaintRegion(TRect(OS.Right,OS.Top,OS.Right,NS.Top-1),true,false);
      Flag=false;
    }
    if (NS.Bottom>=OS.Top && NS.Bottom<=OS.Bottom) {
      int BO=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
      int BN=GetCellPos(NS.Left,NS.Bottom).Y+Rows[NS.Bottom]->Height+FixedTop;
      int R=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
      SetClipRgn(TRect(R-3,BN,R+1,BO+1));
      PaintRegion(TRect(OS.Right,NS.Bottom+1,OS.Right,OS.Bottom),true,false);
      Flag=false;
    }
  }
  if (Flag) {
    int TO=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
    int BO=GetCellPos(OS.Left,OS.Bottom).Y+Rows[OS.Bottom]->Height+FixedTop;
    int R=GetCellPos(OS.Right,OS.Top).X+Columns[OS.Right]->Width+FixedLeft;
    SetClipRgn(TRect(R-3,TO,R+1,BO+1));
    PaintRegion(TRect(OS.Right,OS.Top,OS.Right,OS.Bottom),true,false);
  }

  if (OS.Top!=NS.Top || OS.Left!=NS.Left) {
    int LO=GetCellPos(OS.Left,OS.Top).X+FixedLeft;
    int TO=GetCellPos(OS.Left,OS.Top).Y+FixedTop;
    SetClipRgn(TRect(LO,TO,LO+SB_SIZE,TO+SB_SIZE));
    PaintRegion(TRect(OS.Left,OS.Top,OS.Left,OS.Top),true,false);
  }
  FStay=OldStay;
  AutoClip=true;
  PaintRegion(NS,false,true);
}


void __fastcall TWTCellGrid::DrawCellFill(int X,int Y,int Left,int Top,TCanvas* DestCanvas){

  int PX,PY;
  bool Flag=true;
  TPos PCell=Cells[X][Y]->ParentCell;
  if (DestCanvas==NULL) DestCanvas=Canvas;

  if ((Cells[X][Y]->ParentCell.X==X && Cells[X][Y]->ParentCell.Y==Y)) {
    PX=X;
    PY=Y;
  } else {
    //прорисовка родительской €чейки в случае если она не должна отображатьс€ на экране
    int FLCell=RepaintRegion.Left;
    int FTCell=RepaintRegion.Top;
    Flag=false;
    if (RepaintRegion.Left<PCell.X) FLCell=PCell.X;
    if (RepaintRegion.Top<PCell.Y) FTCell=PCell.Y;
    if (X==FLCell && Y==FTCell) {
      PX=PCell.X;
      PY=PCell.Y;
      Flag=true;
    }
  }

  TPos RDim;
  int XX,YY;
  TPos PCellPos;

  //заполнение
  if (Flag){
//   if ((FStay!=gsPrepare) || (FStay==gsPrepare && Cells[X][Y]->ParentCell.X==X && Cells[X][Y]->ParentCell.Y==Y)) {
    RDim=GetCellDim(PX,PY);

    if (FStay!=gsPrepare) {
      PCellPos=GetCellPos(PX,PY);
      XX=PCellPos.X+Left;
      YY=PCellPos.Y+Top;
    } else {
      PCellPos=AbsCellPos(PX,PY);
      XX=PCellPos.X+Left;
      YY=PCellPos.Y+Top;
    }

    TRect OldClip=ClipRgn;
    TRect NewClip=TRect(XX,YY,XX+RDim.X+1,YY+RDim.Y+1);

    TRect BoundRect;
    if (FStay!=gsPrepare) {
      BoundRect.Top=FixedTop;
      BoundRect.Left=FixedLeft;
      BoundRect.Right=ClientRect.Right-16;
      BoundRect.Bottom=ClientRect.Bottom-16;
    } else {
      BoundRect.Left=Left;
      BoundRect.Top=Top;
      BoundRect.Right=AbsCellPos(RepaintRegion.Right,RepaintRegion.Top).X+Columns[RepaintRegion.Right]->Width+Left;
      BoundRect.Bottom=AbsCellPos(RepaintRegion.Right,RepaintRegion.Bottom).Y+Rows[RepaintRegion.Bottom]->Height+Top;
    }

//    if (FStay!=gsPrepare) {
      if (NewClip.Top>BoundRect.Bottom) return;
      if (NewClip.Bottom<BoundRect.Top) return;
      if (NewClip.Left>BoundRect.Right) return;
      if (NewClip.Right<BoundRect.Left) return;

      if (NewClip.Left<BoundRect.Left) NewClip.Left=BoundRect.Left;
      if (NewClip.Top<BoundRect.Top) NewClip.Top=BoundRect.Top;
      if (NewClip.Right>=BoundRect.Right) NewClip.Right=BoundRect.Right;
      if (NewClip.Bottom>=BoundRect.Bottom) NewClip.Bottom=BoundRect.Bottom;
//    }


    if (FStay!=gsSelRepaint) SetClipRgn(NewClip,DestCanvas);

    DestCanvas->Pen->Width=0;
    DestCanvas->Brush->Assign(Cells[PX][PY]->Filling);
    DestCanvas->FillRect(TRect(XX,YY,XX+RDim.X+1,YY+RDim.Y+1));

    int TopPos=0;
    int LeftPos=0;
    if (Cells[PX][PY]->Image){
      if (Cells[PX][PY]->HAlign==taRightJustify) LeftPos=RDim.X-Cells[PX][PY]->Image->Width;
      if (Cells[PX][PY]->HAlign==Classes::taCenter) LeftPos=(RDim.X-Cells[PX][PY]->Image->Width)/2;
      if (Cells[PX][PY]->VAlign==taBottomJustify) TopPos=RDim.Y-Cells[PX][PY]->Image->Height;
      if (Cells[PX][PY]->VAlign==Classes::taCenter) TopPos=(RDim.Y-Cells[PX][PY]->Image->Height)/2;

      DestCanvas->Draw(XX+LeftPos,YY+TopPos,Cells[PX][PY]->Image);
    }

    //ѕрорисовка текста
    if (Cells[PX][PY]->IsFormula && (Mode==gmCalculated || FStay==gsPrepare)) {
      if (!Cells[PX][PY]->Compiler->Error) {
//          VM->Init(Cells[PX][PY]->CodeData,(char*)Cells[PX][PY]->CodeData+Cells[PX][PY]->CSize);
          Adapter->CalcX=X;
          Adapter->CalcY=Y;
//          VM->Run();
          Cells[PX][PY]->Compiler->Run();
          Cells[PX][PY]->Text->Clear();
          Cells[PX][PY]->Text->Add(Cells[PX][PY]->Compiler->ResAsString);
      }
      if (Cells[PX][PY]->Compiler->Error) {
        Cells[PX][PY]->Text->Clear();
        Cells[PX][PY]->Text->Add("#Error "+IntToStr(Cells[PX][PY]->Compiler->Error));
      }
    } else {
      if (Cells[PX][PY]->IsFormula && Mode==gmConstructor && FStay!=gsPrepare) Cells[PX][PY]->Text->Assign(Cells[PX][PY]->Compiler);
    }
    for (int x=0;x<Cells[PX][PY]->Text->Count;x++) {
      if (Cells[PX][PY]->Text->Strings[x].Length()!=0) {
        DestCanvas->Font->Assign(Cells[PX][PY]->Font);

        int TextH=DestCanvas->TextHeight(Cells[PX][PY]->Text->Strings[x]);
        int TextW=DestCanvas->TextWidth(Cells[PX][PY]->Text->Strings[x]);
        int TextTop;
        int TextLeft;

        if (Cells[PX][PY]->VAlign==taTopJustify) TextTop=YY+TextH*(Cells[PX][PY]->TextInterval-1)+3;
        if (Cells[PX][PY]->VAlign==Classes::taCenter) TextTop=YY+(RDim.Y-TextH*Cells[PX][PY]->TextInterval*Cells[PX][PY]->Text->Count+TextH*(Cells[PX][PY]->TextInterval-1))/2;
        if (Cells[PX][PY]->VAlign==taBottomJustify) TextTop=YY+RDim.Y-TextH*Cells[PX][PY]->TextInterval*Cells[PX][PY]->Text->Count;

        if (Cells[PX][PY]->HAlign==taLeftJustify) TextLeft=XX+3;
        if (Cells[PX][PY]->HAlign==Classes::taCenter) TextLeft=XX+(RDim.X-TextW)/2;
        if (Cells[PX][PY]->HAlign==taRightJustify) TextLeft=XX+RDim.X-TextW-3;

        SetBkMode(DestCanvas->Handle,TRANSPARENT);
        DestCanvas->TextOut(/*TRect(XX,TextTop+TextH*Cells[X][Y]->TextInterval*x,XX+RDim.X,YY+RDim.Y),*/TextLeft,TextTop+TextH*Cells[PX][PY]->TextInterval*x,Cells[PX][PY]->Text->Strings[x]);
      }
    }
    if (FStay!=gsSelRepaint) SetClipRgn(OldClip,DestCanvas);
  }

  if (FStay!=gsPrepare) {
    PCellPos=GetCellPos(X,Y);
    XX=PCellPos.X+Left;
    YY=PCellPos.Y+Top;
  } else {
    PCellPos=AbsCellPos(X,Y);
    XX=PCellPos.X+Left;
    YY=PCellPos.Y+Top;
  }

  RDim=GetCellDim(X,Y);
  TPos Dim;
  Dim.X=Columns[X]->Width;
  Dim.Y=Rows[Y]->Height;
  PCell=Cells[X][Y]->ParentCell;

  DestCanvas->MoveTo(XX,YY);

  if (PCell.Y==Y && (Cells[X][Y]->TopLine->Width || FStay!=gsPrepare)) {
    if (Cells[X][Y]->TopLine->Width==0) DestCanvas->Pen->Assign(DefLine);
      else DestCanvas->Pen->Assign(Cells[X][Y]->TopLine);
    DestCanvas->LineTo(XX+Dim.X,YY);
  } else {
    DestCanvas->MoveTo(XX+Dim.X,YY);
  }

/*  if (X==XSize-1) {
    DestCanvas->Brush->Color=Color;
    DestCanvas->FillRect(TRect(XX+Dim.X+Cells[X][Y]->RightLine->Width/2+1,YY,ClientRect.Right-16,YY+Dim.Y+5));
  }    */

  if (PCell.X+Cells[PCell.X][PCell.Y]->OverCol-1==X && (Cells[X][Y]->RightLine->Width || FStay!=gsPrepare)) {
    if (Cells[X][Y]->RightLine->Width==0) DestCanvas->Pen->Assign(DefLine);
      else DestCanvas->Pen->Assign(Cells[X][Y]->RightLine);
    DestCanvas->LineTo(XX+Dim.X,YY+Dim.Y);
  } else {
    DestCanvas->MoveTo(XX+Dim.X,YY+Dim.Y);
  }

  if (PCell.Y+Cells[PCell.X][PCell.Y]->OverRow-1==Y && (Cells[X][Y]->BottomLine->Width || FStay!=gsPrepare)) {
    if (Cells[X][Y]->BottomLine->Width==0) DestCanvas->Pen->Assign(DefLine);
      else DestCanvas->Pen->Assign(Cells[X][Y]->BottomLine);
    DestCanvas->LineTo(XX,YY+Dim.Y);
  } else {
    DestCanvas->MoveTo(XX,YY+Dim.Y);
  }

  if (PCell.X==X && (Cells[X][Y]->LeftLine->Width || FStay!=gsPrepare)) {
    if (Cells[X][Y]->LeftLine->Width==0) DestCanvas->Pen->Assign(DefLine);
      else DestCanvas->Pen->Assign(Cells[X][Y]->LeftLine);
    DestCanvas->LineTo(XX,YY);
  } else {
    DestCanvas->MoveTo(XX,YY);
  }

//============================
}


void __fastcall TWTCellGrid::NextRow() {
  if (Selection.Bottom!=YSize-1) {
    PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
    Selection.Left;
    Selection.Right=Selection.Left;
    Selection.Top=Selection.Bottom+1;
    Selection.Bottom=Selection.Top;
    Select(Selection);
    if (!MoveToSel()) PaintRegion(Selection,false,true);
  } else {
    if ((Selection.Left!=Selection.Right) || (Selection.Top!=Selection.Bottom)) {
      PaintRegion(Selection,true,false);
      Select(TRect(Selection.Left,Selection.Bottom,Selection.Left,Selection.Bottom));
      if (!MoveToSel()) PaintRegion(Selection,false,true);
    }
  }
}

void __fastcall TWTCellGrid::PrevRow(){
  if (Selection.Top!=0) {
    PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
    Selection.Left;
    Selection.Right=Selection.Left;
    Selection.Bottom=Selection.Top-1;
    Selection.Top=Selection.Bottom;
    Select(Selection);
    if (!MoveToSel()) PaintRegion(Selection,false,true);
  } else {
    if ((Selection.Left!=Selection.Right) || (Selection.Top!=Selection.Bottom)) {
      PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
      Select(TRect(Selection.Left,Selection.Top,Selection.Left,Selection.Top));
      if (!MoveToSel()) PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),false,true);
    }
  }
}

void __fastcall TWTCellGrid::NextCol(){
  if (Selection.Right!=XSize-1) {
    PaintRegion(Selection,true,false);
    Selection.Top;
    Selection.Bottom=Selection.Top;
    Selection.Left=Selection.Right+1;
    Selection.Right=Selection.Left;
    Select(Selection);
    if (!MoveToSel()) PaintRegion(Selection,false,true);
  } else {
    if ((Selection.Left!=Selection.Right) || (Selection.Top!=Selection.Bottom)) {
      PaintRegion(Selection,true,false);
      Select(TRect(Selection.Right,Selection.Top,Selection.Right,Selection.Top));
      if (!MoveToSel()) PaintRegion(Selection,false,true);
    }
  }
}

void __fastcall TWTCellGrid::PrevCol(){
  if (Selection.Left!=0) {
    PaintRegion(TRect(Selection.Left,Selection.Top,Selection.Right,Selection.Bottom),true,false);
    Selection.Top;
    Selection.Bottom=Selection.Top;
    Selection.Right=Selection.Left-1;
    Selection.Left=Selection.Right;
    Select(Selection);
    if (!MoveToSel()) PaintRegion(Selection,false,true);
  } else {
    if ((Selection.Left!=Selection.Right) || (Selection.Top!=Selection.Bottom)) {
      PaintRegion(Selection,true,false);
      Select(TRect(Selection.Left,Selection.Top,Selection.Left,Selection.Top));
      if (!MoveToSel()) PaintRegion(Selection,false,true);
    }
  }
}


Smallint __fastcall TWTCellGrid::RightCell(){
  Smallint X=LeftCell;
  Smallint XX=FixedLeft;
  while ((XX<=ClientRect.Right-16) && (X<XSize)) {
    XX+=Columns[X]->Width;
    X++;
  }
  if ((X==XSize) && (XX<=ClientRect.Right-16)) return XSize-1;
  X-=2;
  return X;
}

Smallint __fastcall TWTCellGrid::BottomCell(){
  Smallint X=TopCell;
  Smallint XX=FixedTop;
  while ((XX<=ClientRect.Bottom-16) && (X<YSize)) {
    XX+=Rows[X]->Height;
    X++;
  }
  if ((X==YSize) && (XX<=ClientRect.Bottom-16)) return YSize-1;
  X-=2;
  return X;
}


void __fastcall TWTCellGrid::SelCellsDraw(TBrush *Fill,TPen *LBound,TPen *TBound,TPen *RBound,TPen *BBound,TPen *IBound){
  for (Smallint x=Selection.Left;x<=Selection.Right;x++) {
    for (Smallint y=Selection.Top;y<=Selection.Bottom;y++) {
      if (Fill) Cells[x][y]->Filling->Assign(Fill);
      if (LBound) {
        if (x==Selection.Left) Cells[x][y]->LeftLine->Assign(LBound);
      }
      if (TBound) {
        if (y==Selection.Top) Cells[x][y]->TopLine->Assign(TBound);
      }
      if (RBound) {
        if (x==Selection.Right) Cells[x][y]->RightLine->Assign(RBound);
      }
      if (BBound) {
        if (y==Selection.Bottom) Cells[x][y]->BottomLine->Assign(BBound);
      }
      if (IBound) {
        if (x!=Selection.Left) Cells[x][y]->LeftLine->Assign(IBound);
        if (y!=Selection.Top) Cells[x][y]->TopLine->Assign(IBound);
        if (x!=Selection.Right) Cells[x][y]->RightLine->Assign(IBound);
        if (y!=Selection.Bottom) Cells[x][y]->BottomLine->Assign(IBound);
      }
    }
  }
  Refresh();
}

bool __fastcall TWTCellGrid::MoveToSel(bool Align){
  //возвращаем истину если позиционирование окна было изменено
  bool Flag=false;
  if (Selection.Left<LeftCell) {
    LeftCell=Selection.Left;
    Flag=true;
  }
  if (Selection.Top<TopCell) {
    TopCell=Selection.Top;
    Flag=true;
  }
  if (Selection.Right>RightCell()) {
    while (RightCell()<Selection.Right)
      LeftCell++;
    Flag=true;
  }
  if (Selection.Bottom>BottomCell()) {
    while (BottomCell()<Selection.Bottom) TopCell++;
    Flag=true;
  }
  if (Flag) Paint();
  return Flag;
}

void __fastcall TWTCellGrid::DrawHeaders(){
 bool Down=false;
 SetClipRgn(TRect(0,0,ClientRect.Right-16,ClientRect.Bottom-16));
 Canvas->Font->Assign(HeadersFont);
 DrawButton(TRect(0,0,FixedLeft+1,FixedTop+1),"");
 if (FStay!=gsRowResizing){
  Smallint X=LeftCell;
  Smallint XX=FixedLeft;
  while (X<XSize && XX<=ClientRect.Right-16) {
    if (X>=Selection.Left && X<=Selection.Right) Down=true;
    DrawButton(TRect(XX,0,XX+Columns[X]->Width+1,FixedTop+1),Columns[X]->Title,Down);
    Down=false;
    XX+=Columns[X]->Width;
    X++;
  }
  if (X==XSize) {
    Canvas->Brush->Color=clWhite;
    Canvas->FillRect(TRect(XX+1,0,ClientRect.Right-16,FixedTop));
  }
 }
 if (FStay!=gsColResizing){
  Smallint Y=TopCell;
  Smallint YY=FixedTop;
  while (Y<YSize && YY<=ClientRect.Bottom-16) {
    if (Y>=Selection.Top && Y<=Selection.Bottom) Down=true;
    /*if (ShowGroups) {
      DrawButton(TRect(GroupWidth,YY+1,FixedLeft-1,YY+Rows[Y]->Height),Rows[Y]->Title,Down);
      Down=false;
      int NextG;
      if (Y!=YSize-1) {
        NextG=Rows[Y+1]->Group;
      } else {
        NextG=-1;
      }
      Canvas->Brush->Color=clBtnFace;
      Canvas->FillRect(TRect(0,YY+1,GroupWidth,YY+Rows[Y]->Height+1));
      Canvas->Pen->Width=1;
      Canvas->Pen->Color=clBlack;
      if (Rows[Y]->Group!=NextG) {
        Canvas->MoveTo(0,YY+Rows[Y]->Height);
        Canvas->LineTo(GroupWidth,YY+Rows[Y]->Height);
      }
      if (Y==Groups->Get(Rows[Y]->Group)->StartRow+int(Groups->Get(Rows[Y]->Group)->RowCount/2)) {
        Canvas->TextRect(TRect(1,YY+1,
                         GroupWidth-1,YY+Rows[Y]->Height-1),
                         2,
                         YY+(Rows[Y]->Height-Canvas->TextHeight(Groups->Get(Rows[Y]->Group)->Name))/2,
                         Groups->Get(Rows[Y]->Group)->Name);
      }
    } else {*/
      DrawButton(TRect(0,YY,FixedLeft+1,YY+Rows[Y]->Height+1),Rows[Y]->Title,Down);
      Down=false;
//    }
    YY+=Rows[Y]->Height;
    Y++;
  }
  if (Y==YSize) {
    Canvas->Brush->Color=clWhite;
    Canvas->FillRect(TRect(0,YY+1,FixedLeft,ClientRect.Bottom-16));
  }
 }
}

void __fastcall TWTCellGrid::SetShowGroups(bool Value){
  FShowGroups=Value;
  if (Value) FixedLeft=GroupWidth+30;
  else FixedLeft=30;
  Paint();
}


void __fastcall TWTCellGrid::DrawButton(TRect Rect,AnsiString Text,bool Down){
  Canvas->Pen->Width=1;
  Canvas->Pen->Color=clBlack;
  Canvas->Brush->Color=clBtnFace;
  if (!Down) {
/*    Canvas->MoveTo(Rect.Left,Rect.Bottom);
    Canvas->LineTo(Rect.Right,Rect.Bottom);
    Canvas->LineTo(Rect.Right,Rect.Top);
    Canvas->Pen->Color=clDkGray;
    Canvas->MoveTo(Rect.Left,Rect.Bottom-1);
    Canvas->LineTo(Rect.Right-1,Rect.Bottom-1);
    Canvas->LineTo(Rect.Right-1,Rect.Top);
    Canvas->Pen->Color=clWhite;
    Canvas->LineTo(Rect.Left,Rect.Top);
    Canvas->LineTo(Rect.Left,Rect.Bottom-1);
    Canvas->FillRect(TRect(Rect.Left+1,Rect.Top+1,Rect.Right-1,Rect.Bottom-1));*/
    Canvas->Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
    Canvas->Pen->Color=clWhite;
    Canvas->MoveTo(Rect.Left+1,Rect.Bottom-2);
    Canvas->LineTo(Rect.Left+1,Rect.Top+1);
    Canvas->LineTo(Rect.Right-1,Rect.Top+1);
/*    Canvas->Pen->Color=clDkGray;
    Canvas->MoveTo(Rect.Left,Rect.Bottom-1);
    Canvas->LineTo(Rect.Right-1,Rect.Bottom-1);
    Canvas->LineTo(Rect.Right-1,Rect.Top);
    Canvas->Pen->Color=clWhite;
    Canvas->LineTo(Rect.Left,Rect.Top);
    Canvas->LineTo(Rect.Left,Rect.Bottom-1);
    Canvas->FillRect(TRect(Rect.Left+1,Rect.Top+1,Rect.Right-1,Rect.Bottom-1));*/
  } else {
    Canvas->Brush->Color=clBtnShadow;
    Canvas->Rectangle(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
    Canvas->Pen->Color=clWhite;
    Canvas->MoveTo(Rect.Left+1,Rect.Bottom-1);
/*    Canvas->Pen->Color=clGray;
    Canvas->FillRect(TRect(Rect.Left,Rect.Top,Rect.Right+1,Rect.Bottom+1));*/
  }

  Canvas->TextRect(TRect(Rect.Left+2,Rect.Top+2,
                         Rect.Right-1,Rect.Bottom-1),
                         Rect.Left+(Rect.Right-Rect.Left-Canvas->TextWidth(Text))/2,
                         Rect.Top+(Rect.Bottom-Rect.Top-Canvas->TextHeight(Text))/2,
                         Text);
}

void __fastcall TWTCellGrid::SetClipRgn(TRect Rect,TCanvas* DestCanvas){
//  UnsetClipRgn();
  if (DestCanvas==NULL) DestCanvas=Canvas;
  if (OldRgn) DeleteObject(OldRgn);
  OldRgn=CreateRectRgn(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom);
//  int RV=GetClipRgn(Canvas->Handle,Rgn);
  SelectClipRgn(DestCanvas->Handle,OldRgn);
//  if (RV!=-1) DeleteObject(Rgn);
  ClipRgn=Rect;
}

void __fastcall TWTCellGrid::UnsetClipRgn(){
  SelectClipRgn(Canvas->Handle,NULL);
}


TPos __fastcall TWTCellGrid::GetCellDim(int X,int Y){
  TPos Pos;
  Pos.X=0;
  Pos.Y=0;
  for (int x=X;x<X+Cells[X][Y]->OverCol;x++)
    Pos.X+=Columns[x]->Width;
  for (int y=Y;y<Y+Cells[X][Y]->OverRow;y++)
    Pos.Y+=Rows[y]->Height;
  return Pos;
}


void __fastcall TWTCellGrid::JoinCells(TRect Rect){
  if (Groups->GroupByRow(Rect.Top)!=Groups->GroupByRow(Rect.Bottom)) return;
  Cells[Rect.Left][Rect.Top]->OverCol=Rect.Right-Rect.Left+1;
  Cells[Rect.Left][Rect.Top]->OverRow=Rect.Bottom-Rect.Top+1;
  for (int x=Rect.Left;x<=Rect.Right;x++) {
    for (int y=Rect.Top;y<=Rect.Bottom;y++) {
      if (!(x==Rect.Left && y==Rect.Top)) {
        Cells[x][y]->ParentCell.X=Rect.Left;
        Cells[x][y]->ParentCell.Y=Rect.Top;
      }
    }
  }
  Select(Rect);
  PaintRegion(Selection,true,true);
}

void __fastcall TWTCellGrid::JoinCells(){
  JoinCells(Selection);
}

void __fastcall TWTCellGrid::CancelJoin(TRect Rect){
  for (int x=Rect.Left;x<=Rect.Right;x++) {
    for (int y=Rect.Top;y<=Rect.Bottom;y++) {
      Cells[x][y]->OverCol=1;
      Cells[x][y]->OverRow=1;
      Cells[x][y]->ParentCell.X=x;
      Cells[x][y]->ParentCell.Y=y;
    }
  }
  PaintRegion(Rect,true,true);
}

void __fastcall TWTCellGrid::CancelJoin() {
  CancelJoin(Selection);
}

void __fastcall TWTCellGrid::SetImages(AnsiString FileName,TRect Rect){
  for (int x=Rect.Left;x<=Rect.Right;x++) {
    for (int y=Rect.Top;y<=Rect.Bottom;y++) {
      if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y){
        if (!Cells[x][y]->Image) Cells[x][y]->Image=new Graphics::TBitmap();
        Cells[x][y]->Image->LoadFromFile(FileName);
      }
    }
  }
  PaintRegion(Rect,true,true);
  SetAppPath();
}

void __fastcall TWTCellGrid::SetImages(AnsiString FileName){
  SetImages(FileName,Selection);
}

void __fastcall TWTCellGrid::CancelImages(TRect Rect){
  for (int x=Rect.Left;x<=Rect.Right;x++) {
    for (int y=Rect.Top;y<=Rect.Bottom;y++) {
      if (Cells[x][y]->Image) delete Cells[x][y]->Image;
      Cells[x][y]->Image=NULL;
    }
  }
  PaintRegion(Rect,true,true);
}

void __fastcall TWTCellGrid::CancelImages(){
  CancelImages(Selection);
}

void __fastcall TWTCellGrid::Select(TRect Rect){
  Selection=GetNewSelection(Rect);
}

TRect __fastcall TWTCellGrid::GetNewSelection(TRect Rect){
  for (int x=Rect.Left;x<=Rect.Right;x++) {
    for (int y=Rect.Top;y<=Rect.Bottom;y++) {
      if (Rect.Left>Cells[x][y]->ParentCell.X) Rect.Left=Cells[x][y]->ParentCell.X;
      if (Rect.Right<Cells[x][y]->ParentCell.X+Cells[Cells[x][y]->ParentCell.X][Cells[x][y]->ParentCell.Y]->OverCol-1) Rect.Right=Cells[x][y]->ParentCell.X+Cells[Cells[x][y]->ParentCell.X][Cells[x][y]->ParentCell.Y]->OverCol-1;
      if (Rect.Top>Cells[x][y]->ParentCell.Y) Rect.Top=Cells[x][y]->ParentCell.Y;
      if (Rect.Bottom<Cells[x][y]->ParentCell.Y+Cells[Cells[x][y]->ParentCell.X][Cells[x][y]->ParentCell.Y]->OverRow-1) Rect.Bottom=Cells[x][y]->ParentCell.Y+Cells[Cells[x][y]->ParentCell.X][Cells[x][y]->ParentCell.Y]->OverRow-1;
    }
  }
  return Rect;
}

void __fastcall TWTCellGrid::SetVAlign(TVAlignment Align){
  TVAlignment OldA;
  for (int x=Selection.Left;x<=Selection.Right;x++) {
    for (int y=Selection.Top;y<=Selection.Bottom;y++) {
      if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y) {
        OldA=Cells[x][y]->VAlign;
        Cells[x][y]->VAlign=Align;
        if (OldA!=Align) PaintRegion(TRect(x,y,x,y),true,false);
      }
    }
  }
  PaintRegion(Selection,false,true);
}

void __fastcall TWTCellGrid::SetHAlign(TAlignment Align){
  TAlignment OldA;
  for (int x=Selection.Left;x<=Selection.Right;x++) {
    for (int y=Selection.Top;y<=Selection.Bottom;y++) {
      if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y) {
        OldA=Cells[x][y]->HAlign;
        Cells[x][y]->HAlign=Align;
        if (OldA!=Align) PaintRegion(TRect(x,y,x,y),true,false);
      }
    }
  }
  PaintRegion(Selection,false,true);
}

void __fastcall TWTCellGrid::SetFont(TFont *NewFont){
  for (int x=Selection.Left;x<=Selection.Right;x++) {
    for (int y=Selection.Top;y<=Selection.Bottom;y++) {
      if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y) {
        Cells[x][y]->Font->Assign(NewFont);
      }
    }
  }
  PaintRegion(Selection,true,true);
}

void __fastcall TWTCellGrid::ReplaceSel(TPos ToPos,bool Copy){
  if (ToPos.X<0 || ToPos.Y<0) return;
  if (ToPos.X==Selection.Left && ToPos.Y==Selection.Top) return;

  TWTCellGrid* TempGrid=new TWTCellGrid(Application,Selection.Right-Selection.Left+1,Selection.Bottom-Selection.Top+1);

  for (int x=Selection.Left;x<=Selection.Right;x++) {
    for (int y=Selection.Top;y<=Selection.Bottom;y++) {
      if (!Cells[x][y]->IsFormula) {
        TempGrid->Cells[x-Selection.Left][y-Selection.Top]->Text->Assign(Cells[x][y]->Text);
        if (!Copy) Cells[x][y]->Text->Clear();
      } else {
        TempGrid->Cells[x-Selection.Left][y-Selection.Top]->Compiler->Assign(Cells[x][y]->Compiler);
        TempGrid->Cells[x-Selection.Left][y-Selection.Top]->Compiler->CopyFrom(Cells[x][y]->Compiler);
        TempGrid->Cells[x-Selection.Left][y-Selection.Top]->IsFormula=true;
        if (Mode==gmConstructor) TempGrid->Cells[x-Selection.Left][y-Selection.Top]->Text->Assign(Cells[x][y]->Compiler);
        if (!Copy) {
          Cells[x][y]->Text->Clear();
          Cells[x][y]->Compiler->Clear();
          Cells[x][y]->IsFormula=false;
        }
      }
    }
  }

  for (Smallint x=Selection.Left;(x<=Selection.Right) && (x-Selection.Left+ToPos.X<XSize);x++) {
    for (int y=Selection.Top;(y<=Selection.Bottom) && (y-Selection.Top+ToPos.Y<YSize);y++) {
      if (Cells[x][y]->ParentCell.X!=x || Cells[x][y]->ParentCell.Y!=y) break;
      if (Cells[x][y]->ParentCell.X==x && Cells[x][y]->ParentCell.Y==y && Cells[x-Selection.Left+ToPos.X][y-Selection.Top+ToPos.Y]->ParentCell.X==x-Selection.Left+ToPos.X && Cells[x-Selection.Left+ToPos.X][y-Selection.Top+ToPos.Y]->ParentCell.Y==y-Selection.Top+ToPos.Y) {
        TWTCell *Cell=Cells[x-Selection.Left+ToPos.X][y-Selection.Top+ToPos.Y];
        int xx=x-Selection.Left;
        int yy=y-Selection.Top;
        if (Cell->IsFormula) {
          Cell->Compiler->Clear();
          Cell->IsFormula=false;
        }
        if (!TempGrid->Cells[xx][yy]->IsFormula) {
          Cell->Text->Assign(TempGrid->Cells[xx][yy]->Text);
        } else {
          Cell->Text->Clear();
          Cell->Compiler->Assign(TempGrid->Cells[xx][yy]->Compiler);
          Cell->Compiler->CopyFrom(TempGrid->Cells[xx][yy]->Compiler);
          Cell->IsFormula=true;
          if (Mode==gmConstructor) Cell->Text->Assign(TempGrid->Cells[xx][yy]->Compiler);
        }
      }
    }
  }
  int BR,RR;
  if (Selection.Right-Selection.Left+1+ToPos.X<XSize) RR=Selection.Right-Selection.Left+ToPos.X;
  else RR=XSize-1;
  if (Selection.Bottom-Selection.Top+1+ToPos.Y<YSize) BR=Selection.Bottom-Selection.Top+ToPos.Y;
  else BR=YSize-1;

  TRect OS=Selection;
  if (!Copy) PaintRegion(Selection,true,false);
  PaintRegion(TRect(ToPos.X,ToPos.Y,RR,BR),true,false);
  Select(TRect(ToPos.X,ToPos.Y,RR,BR));
  if (Copy) RedrawSel(OS,Selection);
  else PaintRegion(Selection,false,true);
  MoveToSel();

  delete TempGrid;
}

void __fastcall TWTCellGrid::LoadFromFile(FILE *f){
  Smallint M;
  GridName=ReadString(f);
  fread(&XSize,sizeof(Smallint),1,f);
  fread(&YSize,sizeof(Smallint),1,f);

  Create(XSize,YSize);

  fread(&M,sizeof(Smallint),1,f);
  FontFromFile(DefFont,f);
  OnFirstDupPrint->LoadFromFile(f);
  OnLastDupPrint->LoadFromFile(f);
  OnNextDupPrint->LoadFromFile(f);
  OnPagePrint->LoadFromFile(f);
  PrintSettings->LoadFromFile(f);

  int Left;
  int Top;
  int Right;
  int Bottom;

  fread(&Left,sizeof(int),1,f);
  fread(&Top,sizeof(int),1,f);
  fread(&Right,sizeof(int),1,f);
  fread(&Bottom,sizeof(int),1,f);

  Selection.Left=Left;
  Selection.Top=Top;
  Selection.Right=Right;
  Selection.Bottom=Bottom;

  for (Smallint x=0;x<XSize;x++) {
    Columns[x]->LoadFromFile(f);
  }

  for (Smallint y=0;y<YSize;y++) {
    Rows[y]->LoadFromFile(f);
  }

  for (Smallint  x=0;x<XSize;x++) {
    for (Smallint y=0;y<YSize;y++) {
      Cells[x][y]->LoadFromFile(f);
    }
  }

  Mode=M;
  Paint();
}

void __fastcall TWTCellGrid::Create(Smallint X,Smallint Y){
  Canvas->Pen->Width=0;
  Canvas->Brush->Color=Color;
  Canvas->FillRect(TRect(FixedLeft,FixedTop,ClientRect.Right-16,ClientRect.Bottom-16));
  HorScrollBar->Position=0;
  VertScrollBar->Position=0;
  HorScrollBar->Max=X-1;
  VertScrollBar->Max=Y-1;
  for (Smallint x=0;x<XSize;x++) {
    delete Columns[x];
    Columns[x]=NULL;
    for (Smallint y=0;y<YSize;y++) {
      delete Rows[y];
      Rows[y]=NULL;
      delete Cells[x][y];
      Cells[x][y]=NULL;
    }
  }
  XSize=X;
  YSize=Y;
  for (Smallint  x=0;x<XSize;x++) {
    Columns[x]=new TWTGridColumn(this,x);
    for (Smallint y=0;y<YSize;y++) {
      new TWTCell(this,x,y);
    }
  }

  Selection=TRect(0,0,0,0);

  for (Smallint y=0;y<YSize;y++) {
    Rows[y]=new TWTGridRow(this,y);
  }

  Paint();
}


bool __fastcall TWTCellGrid::SaveToFile(AnsiString FileName){
  FILE *f=fopen(FileName.c_str(),"wb");
  if (f==NULL) return false;
  fputs("Cells Grid File. Version 1.01. (c)TEXNO+ ltd",f);
  fputc(0,f);
  SaveToFile(f);
  fclose(f);
  SetAppPath();
  return true;
}

bool __fastcall TWTCellGrid::LoadFromFile(AnsiString FileName){
  FILE *f=fopen(FileName.c_str(),"rb");
  if (f==NULL) return false;
  fseek(f,45,SEEK_CUR);
  LoadFromFile(f);
  fclose(f);
  SetAppPath();
  return true;
}

void __fastcall TWTCellGrid::SaveToFile(FILE* f){
  fputs(GridName.c_str(),f);
  fputc('\n',f);
  fwrite(&XSize,sizeof(Smallint),1,f);
  fwrite(&YSize,sizeof(Smallint),1,f);
  fwrite(&FMode,sizeof(Smallint),1,f);
  FontToFile(DefFont,f);
  OnFirstDupPrint->SaveToFile(f);
  OnLastDupPrint->SaveToFile(f);
  OnNextDupPrint->SaveToFile(f);
  OnPagePrint->SaveToFile(f);
  PrintSettings->SaveToFile(f);

  int Left=Selection.Left;
  int Top=Selection.Top;
  int Right=Selection.Right;
  int Bottom=Selection.Bottom;

  fwrite(&Left,sizeof(int),1,f);
  fwrite(&Top,sizeof(int),1,f);
  fwrite(&Right,sizeof(int),1,f);
  fwrite(&Bottom,sizeof(int),1,f);

  for (Smallint x=0;x<XSize;x++) {
    Columns[x]->SaveToFile(f);
  }

  for (Smallint y=0;y<YSize;y++) {
    Rows[y]->SaveToFile(f);
  }

  for (Smallint x=0;x<XSize;x++) {
    for (Smallint y=0;y<YSize;y++) {
      Cells[x][y]->SaveToFile(f);
    }
  }
}

void __fastcall TWTCellGrid::FSetMode(Smallint Value){
  if (Value==FMode) return;
  FMode=Value;
  if (Value>1) FMode==gmCalculated;
  if (FMode==gmConstructor) {
    for (int x=0;x<XSize;x++) {
      for (int y=0;y<YSize;y++) {
        if (Cells[x][y]->IsFormula) Cells[x][y]->Text->Assign(Cells[x][y]->Compiler);
      }
    }
    Paint();
  }
  if (FMode==gmCalculated) {
    Paint();
  }
}

void __fastcall TWTCellGrid::OnVertChange(System::TObject* Sender){
  if (FStay==gsPagePressed) return;
  TopCell=VertScrollBar->Position;
  Paint();
}

void __fastcall TWTCellGrid::OnHorChange(System::TObject* Sender){
  if (FStay==gsPagePressed) return;
  LeftCell=HorScrollBar->Position;
  Paint();
}


void __fastcall TWTCellGrid::OnVertScroll(System::TObject* Sender, TScrollCode ScrollCode, int &ScrollPos){
  if (FStay==gsPagePressed) return;
  int OldTop=TopCell-1;
  if (ScrollCode==scPageUp) {
    while ((BottomCell()!=OldTop || BottomCell()==YSize-1) && TopCell) TopCell--;
    ScrollPos=TopCell;
    TopCell=OldTop;
  }
  int OldBottom=BottomCell()+1;
  if (ScrollCode==scPageDown) {
    while (TopCell!=OldBottom) TopCell++;
    ScrollPos=TopCell;
    TopCell=OldTop;
  }
}

void __fastcall TWTCellGrid::OnHorScroll(System::TObject* Sender, TScrollCode ScrollCode, int &ScrollPos){
  if (FStay==gsPagePressed) return;
  int OldLeft=LeftCell-1;
  if (ScrollCode==scPageUp) {
    while ((RightCell()!=OldLeft || RightCell()==XSize-1) && LeftCell) LeftCell--;
    ScrollPos=LeftCell;
    LeftCell=OldLeft;
  }
  int OldRight=RightCell()+1;
  if (ScrollCode==scPageDown) {
    while (LeftCell!=OldRight) LeftCell++;
    ScrollPos=LeftCell;
    LeftCell=OldLeft;
  }
}

void __fastcall TWTCellGrid::FSetTopCell(Smallint Value){
  int OldStay=FStay;
  FTopCell=Value;
  FStay=gsPagePressed;
  VertScrollBar->Position=Value;
  FStay=OldStay;
}

void __fastcall TWTCellGrid::FSetLeftCell(Smallint Value){
  int OldStay=FStay;
  FLeftCell=Value;
  FStay=gsPagePressed;
  HorScrollBar->Position=Value;
  FStay=OldStay;
}

void __fastcall TWTCellGrid::PrintPrepare(){
  if (FStay!=gsNormal) return;
  int Error=OnNextDupPrint->Compile();
  Error=OnFirstDupPrint->Compile();

  FStay=gsPrepare;
  if (FPrinter) delete FPrinter;
  FPrinter=new TQRPrinter(NULL);
  FPrinter->XFactor=XFactor;
  FPrinter->YFactor=YFactor;
  FPrinter->BeginDoc();

  int EfWidth=(FPrinter->PaperWidth*FPrinter->XFactor-PrintSettings->LeftMargin-PrintSettings->RightMargin-PrintSettings->DupSpacing*(PrintSettings->HDupCount-1))/PrintSettings->HDupCount;
  int EfHeight=(FPrinter->PaperLength*FPrinter->YFactor-PrintSettings->TopMargin-PrintSettings->BottomMargin-PrintSettings->DupSpacing*(PrintSettings->VDupCount-1))/PrintSettings->VDupCount;
  for (int x=0;x<XSize;x++) if (Columns[x]->Width>EfWidth) return;
  for (Smallint  x=0;x<YSize;x++) if (Rows[x]->Height>EfHeight) return;
  int X=0,XX=0,Y=0,YY=0;

  bool EndLine=false;
  bool EndDoc=false;

  StartCol=0;
  StartRow=0;

  while (true) {
    if (!OnFirstDupPrint->Error) {
      OnFirstDupPrint->Run();
      if (!OnFirstDupPrint->ResAsInt) return;
    }
    SetClipRgn(TRect(0,0,FPrinter->PaperWidth*FPrinter->XFactor,FPrinter->PaperLength*FPrinter->YFactor),FPrinter->Canvas);
    XX=0;
    while ((XX+Columns[X]->Width)<EfWidth) {
      XX+=Columns[X]->Width;
      X++;
      if (X==XSize) {
        EndLine=true;
        break;
      }
    }
    X--;
    YY=0;
    while ((YY+Rows[Y]->Height)<EfHeight) {
      YY+=Rows[Y]->Height;
      Y++;
      if (Y==YSize) {
        EndDoc=true;
        break;
      }
    }
    Y--;

    bool PageStop=false;
    int PageCount=0;

    while (!PageStop) {
      for (int xi=0;xi<PrintSettings->HDupCount;xi++) {
        if (PageStop) break;
        for (int yi=0;yi<PrintSettings->VDupCount;yi++) {
          if ((xi || yi || PageCount) && !OnNextDupPrint->Error) {
            OnNextDupPrint->Run();
            if (!OnNextDupPrint->ResAsInt) {
              PageStop=true;
              break;
            }
          }
          if (!xi && !yi) {
            if (!OnNextDupPrint->Error) FPrinter->NewPage();
            else {
              PageStop=true;
              break;
            }
          }
          PageCount++;
          int Top=PrintSettings->TopMargin+yi*EfHeight+yi*PrintSettings->DupSpacing;
          int Left=PrintSettings->LeftMargin+xi*EfWidth+xi*PrintSettings->DupSpacing;
          RepaintRegion=TRect(StartCol,StartRow,X,Y);
          for (int x=StartCol;x<=X;x++) {
            for (int y=StartRow;y<=Y;y++) {
              DrawCellFill(x,y,Left,Top,FPrinter->Canvas);
            }
          }
        }
      }
    }

    if (EndLine && !EndDoc) {
      StartCol=0;
      X=0;
      EndLine=false;
      StartRow=Y+1;
      Y++;
    } else {
      if (EndLine && EndDoc) break;
      StartCol=X+1;
      X++;
      Y=StartRow;
      EndDoc=false;
    }
  }

/*  int X=0;
  int Y=0;
  int XX=0;
  int YY=0;
  int CurGroup=0;
  int CurPageHeader;
  bool StartPage=true;

  while (!EndHorLine) {
    XX=0;
    while ((XX+Columns[X]->Width)<EfWidth) {
      XX+=Columns[X]->Width;
      X++;
      if (X==XSize) {
        EndLine=true;
        break;
      }
    }
    X--;
    YY=0;

    while (!EndVerLine) {

      if (Groups->Get(CurGroup)->Type==gtPageHeader) CurPageHeader=CurGroup;
      if (Groups->Get(CurGroup)->Type==gtData || Groups->Get(CurGroup)->Type==gtFooter) {
        if (StartPage==NULL)
      }

      CurGroup++;

    }

  }*/



  FPrinter->EndDoc();
  FStay=gsNormal;
}

//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================

__fastcall TWTCell::TWTCell(TWTCellGrid *Grid,Smallint X,Smallint Y) : TObject(){

  ParentGrid=Grid;

//  Error=0;
  IsFormula=false;
 // CodeData=NULL;
//  Formula=new TStringList();
//  AllSize=0;
//  CSize=0;
  Compiler=new TWTCellsCompiler(Grid->Exec);
  Image=NULL;

  TextInterval=1;

  Text=new TStringList();
  Font=new TFont();
  Font->Assign(Grid->DefFont);

  ParentCell.X=X;
  ParentCell.Y=Y;
  ParentCell=TPos(X,Y);
  OverCol=1;
  OverRow=1;

  if ((!X) || (Grid->Cells[X-1][Y]==NULL)) {
    LeftLine=new TPen();
    LeftLine->Width=0;
  } else LeftLine=Grid->Cells[X-1][Y]->RightLine;

  if ((!Y) || (Grid->Cells[X][Y-1]==NULL)) {
    TopLine=new TPen();
    TopLine->Width=0;
  } else TopLine=Grid->Cells[X][Y-1]->BottomLine;

  if (Grid->Cells[X+1][Y]==NULL) {
    RightLine=new TPen();
    RightLine->Width=0;
  } else RightLine=Grid->Cells[X+1][Y]->LeftLine;

  if (Grid->Cells[X][Y+1]==NULL) {
    BottomLine=new TPen();
    BottomLine->Width=0;
  } else BottomLine=Grid->Cells[X][Y+1]->TopLine;

  Grid->Cells[X][Y]=this;
  Filling=new TBrush();
}

__fastcall TWTCell::~TWTCell(){
  delete Text;
  delete Font;
//  if (CodeData) delete CodeData;
//  delete Formula;
  delete Compiler;
  if (Image) delete Image;
}


void __fastcall TWTCell::SaveToFile(FILE* File){
  fputc(IsFormula,File);
  if (!IsFormula) {
    int LinesCount=Text->Count;
    fwrite(&LinesCount,4,1,File);
    for (int x=0;x<Text->Count;x++) {
      fputs(Text->Strings[x].c_str(),File);
      fputc('\n',File);
    }
  } else {
/*    int LinesCount=Formula->Count;
    fwrite(&LinesCount,4,1,File);
    for (int x=0;x<Formula->Count;x++) {
      fputs(Formula->Strings[x].c_str(),File);
      fputc('\n',File);
    }
    fwrite(&CSize,4,1,File);
    fwrite(&AllSize,4,1,File);
    fwrite(CodeData,CSize,1,File);*/
    Compiler->SaveToFile(File);
  }
  if (Image) {
    TMemoryStream *Stream=new TMemoryStream();
    Image->SaveToStream(Stream);
    int ImageSize=Stream->Size;
    fwrite(&ImageSize,4,1,File);
//    void *Buf=calloc(ImageSize,1);
//    Steram->Position=0;
//    Stream->Read(Stream->Memory,ImageSize);
    fwrite(Stream->Memory,ImageSize,1,File);
    delete Stream;
  } else {
    int ImageSize=0;
    fwrite(&ImageSize,4,1,File);
  }
//  fwrite(&Error,4,1,File);
  fwrite(&OverCol,4,1,File);
  fwrite(&OverRow,4,1,File);
  fwrite(&ParentCell.X,sizeof(Smallint),1,File);
  fwrite(&ParentCell.Y,sizeof(Smallint),1,File);
  fwrite(&TextInterval,sizeof(float),1,File);
  fwrite(&HAlign,sizeof(TAlignment),1,File);
  fwrite(&VAlign,sizeof(TVAlignment),1,File);

  if (!CompareFonts(ParentGrid->DefFont,Font)) {
    fputc(1,File);
    FontToFile(Font,File);
  }
  else {
    fputc(0,File);
  }
  PenToFile(LeftLine,File);
  PenToFile(TopLine,File);
  PenToFile(RightLine,File);
  PenToFile(BottomLine,File);
  BrushToFile(Filling,File);
}

void __fastcall TWTCell::LoadFromFile(FILE* File){
  Text->Clear();
//  Compiler->Clear();
//  if (CodeData) delete CodeData;
//  CodeData=NULL;

  IsFormula=fgetc(File);
  if (!IsFormula) {
    int LinesCount;
    fread(&LinesCount,4,1,File);
    for (int x=0;x<LinesCount;x++) {
      Text->Add(ReadString(File));
    }
  } else {
/*    int LinesCount;
    fread(&LinesCount,4,1,File);
    for (int x=0;x<LinesCount;x++) {
      Compiler->Add(ReadString(File));
    }
    fread(&CSize,4,1,File);
    fread(&AllSize,4,1,File);
    CodeData=calloc(AllSize+100,1);
    fread(CodeData,CSize,1,File);*/
    Compiler->LoadFromFile(File);
  }
  int ImageSize;
  fread(&ImageSize,4,1,File);
  if (ImageSize) {
    TMemoryStream *Stream=new TMemoryStream();
    void *Buf=calloc(ImageSize,1);
    fread(Buf,ImageSize,1,File);
    Stream->Write(Buf,ImageSize);
    Stream->Position=0;
    Image=new Graphics::TBitmap();
    Image->LoadFromStream(Stream);
    delete Buf;
    delete Stream;
  }
//  fread(&Error,4,1,File);
  fread(&OverCol,4,1,File);
  fread(&OverRow,4,1,File);
  fread(&ParentCell.X,sizeof(Smallint),1,File);
  fread(&ParentCell.Y,sizeof(Smallint),1,File);
  fread(&TextInterval,sizeof(float),1,File);
  fread(&HAlign,sizeof(TAlignment),1,File);
  fread(&VAlign,sizeof(TVAlignment),1,File);

  if (fgetc(File)) FontFromFile(Font,File);
  PenFromFile(LeftLine,File);
  PenFromFile(TopLine,File);
  PenFromFile(RightLine,File);
  PenFromFile(BottomLine,File);
  BrushFromFile(Filling,File);
}


__fastcall TWTGridColumn::TWTGridColumn(TWTCellGrid* Grid, Smallint ColNum): TObject(){
  Cells=Grid->Cells[ColNum];
  Width=50;
  Title=IntToStr(ColNum);
}

void __fastcall TWTGridColumn::SaveToFile(FILE* File){
  fputs(Title.c_str(),File);
  fputc('\n',File);
  fwrite(&Width,4,1,File);
}

void __fastcall TWTGridColumn::LoadFromFile(FILE* File){
  Title=ReadString(File);
  fread(&Width,4,1,File);
}


__fastcall TWTGridRow::TWTGridRow(TWTCellGrid* Grid, Smallint RowNum): TObject(){
  Height=20;
  Title=IntToStr(RowNum);
  FGroup=0;
}

void __fastcall TWTGridRow::SaveToFile(FILE* File){
  fputs(Title.c_str(),File);
  fputc('\n',File);
  fwrite(&Height,4,1,File);
}

void __fastcall TWTGridRow::LoadFromFile(FILE* File){
  Title=ReadString(File);
  fread(&Height,4,1,File);
}

__fastcall TWTScrollBar::TWTScrollBar(TComponent *AOwner) : TScrollBar(AOwner){
}

void __fastcall TWTScrollBar::WndProc(Messages::TMessage &Message){
  TWinControl::WndProc(Message);
  if (Message.Msg==WM_SETFOCUS) {
    Parent->Parent->SetFocus();
//    return;
  }
}

//--------------------------------------------------------------------------------------

__fastcall TWTCellsCompiler::TWTCellsCompiler(TWTExec* Exec) : TStringList() {
  FExec=Exec;
  Code=NULL;
  Size=0;
  ResAsString="";
  Error=0;
}

__fastcall TWTCellsCompiler::~TWTCellsCompiler(){
  if (Code) delete Code;
}

int __fastcall TWTCellsCompiler::Compile(){
  Error=FExec->Compile(this);
  if (Error) return Error;
  if (Code) delete Code;
  Code=FExec->GetCode(Size);
  DataSize=FExec->GetDataSize();
  return Error;
}

int __fastcall TWTCellsCompiler::Run(){
  if (Code==NULL) return 888;
  try {
    FExec->Execute(Code,Size);
    ResAsString=FExec->VM->ResAsString;
    ResAsFloat=FExec->VM->ResAsFloat;
    ResAsInt=FExec->VM->ResAsInt;
  } catch (...) {
    return 999;
  }
  return 0;
}

void __fastcall TWTCellsCompiler::SaveToFile(FILE* File){
  int LinesCount=Count;
  fwrite(&LinesCount,4,1,File);
  for (int x=0;x<LinesCount;x++) {
    fputs(Strings[x].c_str(),File);
    fputc('\n',File);
  }
  fwrite(&Size,4,1,File);
  fwrite(&DataSize,4,1,File);
  fwrite(Code,Size,1,File);
  fwrite(&Error,4,1,File);
}

void __fastcall TWTCellsCompiler::LoadFromFile(FILE* File){
  int LinesCount;
  if (Code) delete Code;
  Clear();
  fread(&LinesCount,4,1,File);
  for (int x=0;x<LinesCount;x++) {
    Add(ReadString(File));
  }
  fread(&Size,4,1,File);
  fread(&DataSize,4,1,File);
  Code=calloc(Size+DataSize,1);
  fread(Code,Size,1,File);
  fread(&Error,4,1,File);
  if (LinesCount) Compile();
}

//void __fastcall TWTCellsCompiler::Clear(void){
void __fastcall TWTCellsCompiler::Clear(){
  int i =1;
  if (Code) delete Code;
  TStringList::Clear();
  Error=0;
  DataSize=0;
  Size=0;
}

void __fastcall TWTCellsCompiler::CopyFrom(TWTCellsCompiler *Source){
  if (Code) delete Code;
  Code=NULL;
  if (Source->Code) {
    Code=calloc(Source->Size+Source->DataSize,1);
    Size=Source->Size;
    DataSize=Source->DataSize;
    Error=Source->Error;
    memcpy(Code,Source->Code,Source->Size);
  } else {
    DataSize=0;
    Size=0;
    Error=0;
  }
}


//==============================================================================

__fastcall TWTPrintSettings::TWTPrintSettings(){
  HDupCount=1;
  VDupCount=1;
  DupSpacing=0;
  Copies=1;
  TopMargin=50;
  LeftMargin=50;
  RightMargin=50;
  BottomMargin=50;
}

__fastcall TWTPrintSettings::~TWTPrintSettings(){
}

void __fastcall TWTPrintSettings::LoadFromFile(FILE* File){
  fread(&HDupCount,4,1,File);
  fread(&VDupCount,4,1,File);
  fread(&DupSpacing,4,1,File);
  fread(&Copies,4,1,File);
  fread(&TopMargin,4,1,File);
  fread(&LeftMargin,4,1,File);
  fread(&RightMargin,4,1,File);
  fread(&BottomMargin,4,1,File);
}

void __fastcall TWTPrintSettings::SaveToFile(FILE* File){
  fwrite(&HDupCount,4,1,File);
  fwrite(&VDupCount,4,1,File);
  fwrite(&DupSpacing,4,1,File);
  fwrite(&Copies,4,1,File);
  fwrite(&TopMargin,4,1,File);
  fwrite(&LeftMargin,4,1,File);
  fwrite(&RightMargin,4,1,File);
  fwrite(&BottomMargin,4,1,File);
}


//=============================================================================
//=============================================================================
//=============================================================================


__fastcall TWTGridAdapter::TWTGridAdapter(TWTCellGrid* CellGrid){
  FCellGrid=CellGrid;
  CalcX=0;
  CalcY=0;
  DecCount=0;

//  CellGrid->TPComp->Analizer->Generator->AddExternalVar("Grid",98,"TGrid");

  void *p=this;
  CellGrid->Exec->AddDeclaration("Grid","TGrid",&p,98);
  CellGrid->Exec->Compiler->Analizer->Generator->ThisVar="Grid";

  CellGrid->Exec->AddFunction("Sum","TGrid",MethodAddress("Sum"));
  CellGrid->Exec->AddFunction("Mul","TGrid",MethodAddress("Mul"));
  CellGrid->Exec->AddFunction("Max","TGrid",MethodAddress("Max"));
  CellGrid->Exec->AddFunction("Next","TGrid",MethodAddress("Next"));
  CellGrid->Exec->AddFunction("Field","TGrid",MethodAddress("Field"));
  CellGrid->Exec->AddFunction("First","TGrid",MethodAddress("First"));
  CellGrid->Exec->AddFunction("Cell","TGrid",MethodAddress("Cell"));



//  CellGrid->VM->FTable[0]=calloc(100,4);
/*  ((void**)CellGrid->VM->FTable[0])[99]=MethodAddress("Sum");
  ((void**)CellGrid->VM->FTable[0])[98]=this;
  ((void**)CellGrid->VM->FTable[0])[97]=MethodAddress("Mul");
  ((void**)CellGrid->VM->FTable[0])[96]=MethodAddress("Max");
  ((void**)CellGrid->VM->FTable[0])[95]=MethodAddress("Next");
  ((void**)CellGrid->VM->FTable[0])[94]=MethodAddress("Field");
  ((void**)CellGrid->VM->FTable[0])[93]=MethodAddress("First");
  ((void**)CellGrid->VM->FTable[0])[92]=MethodAddress("Cell");*/
}

__fastcall TWTGridAdapter::~TWTGridAdapter(){
}

AnsiString __fastcall TWTGridAdapter::Sum(int L,int T,int R,int B){
  float Result=0;
  for (int x=L;x<=R;x++) {
    for (int y=T;y<=B;y++) {
      for (int z=0;z<FCellGrid->Cells[x][y]->Text->Count;z++) Result+=StrToFloat(FCellGrid->Cells[x][y]->Text->Strings[z]);
    }
  }
  return FloatToStr(Result);
}

AnsiString __fastcall TWTGridAdapter::Mul(int L,int T,int R,int B){
  float Result=1;
  for (int x=L;x<=R;x++) {
    for (int y=T;y<=B;y++) {
      for (int z=0;z<FCellGrid->Cells[x][y]->Text->Count;z++) Result*=StrToFloat(FCellGrid->Cells[x][y]->Text->Strings[z]);
    }
  }
  return FloatToStr(Result);
}

AnsiString __fastcall TWTGridAdapter::Max(int L,int T,int R,int B){
  float Result=StrToFloat(FCellGrid->Cells[L][T]->Text->Strings[0]);
  for (int x=L;x<=R;x++) {
    for (int y=T;y<=B;y++) {
      for (int z=0;z<FCellGrid->Cells[x][y]->Text->Count;z++)
         if (Result<StrToFloat(FCellGrid->Cells[x][y]->Text->Strings[z])) Result=StrToFloat(FCellGrid->Cells[x][y]->Text->Strings[z]);
    }
  }
  return FloatToStr(Result);
}

int __fastcall TWTGridAdapter::Next(){
  if (FCellGrid->DataSet)
    if (FCellGrid->DataSet->Active) {
      FCellGrid->DataSet->Next();
      if (FCellGrid->DataSet->Eof) return 0;
      return 1;
    }
  return 0;
}

AnsiString __fastcall TWTGridAdapter::Cell(int L,int T){
  if (L>=0 && L<FCellGrid->XSize && T>=0 && T<FCellGrid->YSize) {
    if (FCellGrid->Cells[L][T]->Formula) {
      FCellGrid->Cells[L][T]->CellsCompiler->Run();
      return FCellGrid->Cells[L][T]->CellsCompiler->ResAsString;
    } else if (FCellGrid->Cells[L][T]->Text->Count) return FCellGrid->Cells[L][T]->Text->Strings[0];
  }
  return "";
}


AnsiString __fastcall TWTGridAdapter::Field(AnsiString FieldName){
  if (FCellGrid->DataSet)
    if (FCellGrid->DataSet->Active)
      if (FCellGrid->DataSet->Fields->FieldByName(FieldName))
        return FCellGrid->DataSet->Fields->FieldByName(FieldName)->AsString;
  return "";
}

int __fastcall TWTGridAdapter::First(){
  if (FCellGrid->DataSet)
    if (FCellGrid->DataSet->Active) {
      FCellGrid->DataSet->First();
      if (FCellGrid->DataSet->Eof) return 0;
      return 1;
    }
  return 0;
}

void __fastcall TWTGridAdapter::AddGridDec(AnsiString Name,AnsiString Type,void* Value){
  if (DecCount==100) return;
  TWTValue* V=new TWTValue(Name,DecCount*4+12,Type); //12 - смещение Data относительно указател€ класса
  TWTType *T=FCellGrid->Exec->Compiler->Analizer->Generator->TypesList->TypeByName("TGrid");
  T->AddField(V);
  int Val=*(int*)(Value);
  Data[DecCount]=(void*)Val;
  DecCount++;
}

void __fastcall TWTGridAdapter::ClearGridDec(){
  for (int x=0;x<DecCount;x++) {
    FCellGrid->Exec->Compiler->Analizer->Generator->ExtVarsList->DelVar(x*4+12);
  }
  DecCount=0;
}

//==============================================================================
//==============================================================================
//==============================================================================
//==============================================================================


__fastcall TWTGridGroup::TWTGridGroup(TWTGridGroupList* Parent) :TObject(){
  OnPrint=new TWTCellsCompiler(Parent->CellGrid->Exec);
//  FStartRow=0;
  RowCount=0;
  FLevel=0;
  FParentGroups=Parent;
  FGroups=new TWTGridGroupList(this);
}

__fastcall TWTGridGroup::~TWTGridGroup(){
  delete OnPrint;
}

void __fastcall TWTGridGroup::SetType(int Value){
  FType=Value;
}

void __fastcall TWTGridGroup::SetRowCount(int Value){
  if (!ParentGroups->CellGrid) return;
  if (Value>=ParentGroups->CellGrid->YSize) return;
  if (Value==RowCount) return;
  if (!Groups) {
/*    for (int x=StartRow;x<SetRow;x++) {
      ParentGroups->CellGrid->Rows[x]->FGroup=this;
    }*/
  }
  if (Value>RowCount) {


  } else {
  }

}

/*void __fastcall TWTGridGroup::SetStartRow(int Value){
} */

void __fastcall RefreshGroups(){
}

void __fastcall TWTGridGroupList::AddGroup(AnsiString GroupName,int RowCount){
/*  for (int x=0;x<Count;x++){
    if (GroupName==Get(x)->Name) return;
  }
  int TopG=0;
  TWTGridGroup* GG;
  if (Count) {
    GG=Get(Count-1);
    if (RowCount>=GG->RowCount) return;
    TopG=GG->StartRow+GG->RowCount-RowCount;
    for (int x=0;x<CellGrid->XSize;x++){
      if (CellGrid->Cells[x][TopG]->ParentCell.Y!=TopG) return;
    }
    GG->RowCount-=RowCount;
  }
  GG=new TWTGridGroup(this);
  GG->FStartRow=TopG;
  GG->RowCount=RowCount;
  GG->Name=GroupName;
  for (int x=GG->StartRow;x<(RowCount+GG->StartRow);x++){
    CellGrid->Rows[x]->FGroup=Count;
  }
  Add(GG);
  CellGrid->Repaint();
}

void __fastcall TWTGridGroupList::RemoveGroup(AnsiString GroupName){
  for (int x=0;x<Count;x++){
    if (Get(x)->Name==GroupName) {
      RemoveGroup(x);
      return;
    }
  }*/
}

void __fastcall TWTGridGroupList::RemoveGroup(int Index){
/*  if (Index==0) return;
  if (Index<0 || Index>(Count-1) || Count==1) return;
  int Div=Get(Index)->RowCount;
  for (int x=Get(Index)->StartRow;x<CellGrid->YSize;x++) {
    CellGrid->Rows[x]->FGroup--;
  }
  Get(Index-1)->RowCount+=Div;
  delete Get(Index);
  Delete(Index);
  CellGrid->Repaint();*/
}


TWTGridGroup* __fastcall TWTGridGroupList::Get(int Index){
  if (Index>(Count-1) || Index<0) return NULL;
  return (TWTGridGroup*)Items[Index];
}

__fastcall TWTGridGroupList::TWTGridGroupList(TWTGridGroup* Group){
  if (Group!=NULL) FCellGrid=Group->ParentGroups->CellGrid;
  FParentGroup=Group;
}

__fastcall TWTGridGroupList::~TWTGridGroupList(){
  for (int x=0;x<Count;x++){
    delete Get(x);
  }
}

void __fastcall TWTGridGroupList::SetCellGrid(TWTCellGrid* Value){
  FCellGrid=Value;
}


int __fastcall TWTGridGroupList::GroupByRow(int Row){
 for (int x=0;x<Count;x++){
   // if (Row>=Get(x)->StartRow && Row<(Get(x)->StartRow+Get(x)->RowCount))
    return x;
  }
  return 1;
}

