#if !defined(__BOOLMATR_H)

#define __BOOLMATR_H

#define MAX_MATRIX_SIZE 110

struct Matrica
{
 char Data[MAX_MATRIX_SIZE][MAX_MATRIX_SIZE];
};

class TWTMatrix
{
 public:
  int  Size;
  Matrica *Data;
  void Single();
  void Clear();
  void SetData(char,char,char);
  void Umn(TWTMatrix *,TWTMatrix *);
  void Plus(TWTMatrix *,TWTMatrix *);
  void Eq(TWTMatrix *);
  char GetData(char,char);
  TWTMatrix(int size);
  ~TWTMatrix() 
  {
   delete Data;
  };
  void T(TWTMatrix *);
};

#endif