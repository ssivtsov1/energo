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
        AnsiString name_table_ind;     //��� ������� �����������
        AnsiString name_table;         //��� �������
        int TypeId;    //��� ����������� ������������
        int eqp_type;  //��� ���� �������
        int eqp_id;    //��� �������
        int mode;
        bool fReadOnly;      // ����� ������ ��� ������
        bool IsModified;     //������ ���� ��������
        bool CangeLogEnabled; //���������� ��������� � �������� ������
        bool is_res; //��� ������������ ����
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
