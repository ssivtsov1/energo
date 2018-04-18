//---------------------------------------------------------------------------

#ifndef fDetH
#define fDetH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "ZPgSqlQuery.hpp"
#include "ZQuery.hpp"

//---------------------------------------------------------------------------
class TfEqpDet : public TForm
{
__published:	// IDE-managed Components
private:	// User declarations
public:		// User declarations
        int usr_id;
        AnsiString name_table_ind;     //имя таблици справочника
        AnsiString name_table;         //имя таблици
        int TypeId;    //тпп конкретного оборудования
        int eqp_type;  //код типа обьекта
        int eqp_id;    //Код обьекта
        int mode;
        bool fReadOnly;      // Режим только для чтения
        bool IsModified;     //Данные были изменены
        bool CangeLogEnabled; //Записывать изменения в протокол замены
        bool is_res; //это оборудование РЕСа
        int abonent_id;
        AnsiString sqlstr;
        TZPgSqlQuery *ZEqpQuery;

        __fastcall TfEqpDet(TComponent* Owner);
        bool GetTableNames(TObject *Sender);
        virtual bool SaveNewData(int id) = 0;
        virtual bool SaveData(void) = 0;
        virtual bool CheckData(void){return true;};
//        void __fastcall edDataChange(TObject *Sender);
};
//---------------------------------------------------------------------------
//extern PACKAGE TfEqpDet *fEqpDet;
//---------------------------------------------------------------------------
#endif
