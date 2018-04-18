//---------------------------------------------------------------------------

#ifndef docu_modH
#define docu_modH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZConnect.hpp"
#include "ZPgSqlCon.hpp"
#include "ZPgSqlQuery.hpp"
#include "ZPgSqlTr.hpp"
#include "ZQuery.hpp"
#include "ZTransact.hpp"
#include <Db.hpp>
#include <ImgList.hpp>
#include <Menus.hpp>
//---------------------------------------------------------------------------
class TModule2DB : public TDataModule
{
__published:	// IDE-managed Components
        TZPgSqlDatabase *MainDB;
        TZPgSqlTransact *Trans4MDB;
        TZPgSqlQuery *Query_grp;
        TDataSource *Query_grp4;
        TZPgSqlNotify *Notify;
        TImageList *Images4grp;
        TImageList *Images4doc_s;
        TPopupMenu *Popup4grp;
        TPopupMenu *Popup4doc;
        TMenuItem *N1;
        TMenuItem *N2;
        TMenuItem *N3;
        TMenuItem *N4;
        TMenuItem *N5;
        TMenuItem *N6;
        TZPgSqlTransact *Trans4DDB;
        TZPgSqlQuery *Query_doc;
        TZPgSqlQuery *QueryExec;
        TZPgSqlTransact *Trans4exec;
        TDataSource *Data4exec;
        TPopupMenu *Popup4temp;
        TMenuItem *N7;
        TMenuItem *N8;
        TImageList *ImageFind;
        TMenuItem *N9;
        TMenuItem *N10;
        TMenuItem *N11;
        TMenuItem *N13;
        TMenuItem *N14;
        TMenuItem *N15;
        TMenuItem *N16;
        TMenuItem *N17;
        TMenuItem *N18;
        void __fastcall NotifyNotify(TObject *Sender, AnsiString Event);
        void __fastcall DataModuleCreate(TObject *Sender);
        void __fastcall N5Click(TObject *Sender);
        void __fastcall N1Click(TObject *Sender);
        void __fastcall N2Click(TObject *Sender);
        void __fastcall N3Click(TObject *Sender);
        void __fastcall N7Click(TObject *Sender);
        void __fastcall N8Click(TObject *Sender);
        void __fastcall N11Click(TObject *Sender);
        void __fastcall N13Click(TObject *Sender);
        void __fastcall N14Click(TObject *Sender);
        void __fastcall N15Click(TObject *Sender);
        void __fastcall DataModuleDestroy(TObject *Sender);
        void __fastcall N16Click(TObject *Sender);
        void __fastcall N17Click(TObject *Sender);
        void __fastcall N18Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TModule2DB(TComponent* Owner);
        int id_grp,id_doc,kind_doc,id_elem,num_elem,kind,id_document,view;
        AnsiString name;
        TList *MainList;
};
//---------------------------------------------------------------------------
extern PACKAGE TModule2DB *Module2DB;
//---------------------------------------------------------------------------
#endif
