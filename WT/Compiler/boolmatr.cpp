#include "boolmatr.h"

void TWTMatrix::Umn(TWTMatrix *Y,TWTMatrix *R)
{
 for(int i=0;i<Size;i++)
 for(int j=0;j<Size;j++)
 {
  R->SetData(i,j,0);
  for(int v=0;v<Size;v++)
  R->SetData(i,j,(GetData(i,v) && Y->GetData(v,j)) || R->GetData(i,j));
 }
}

void TWTMatrix::Plus(TWTMatrix *Y,TWTMatrix *R)
{
 for(int i=0;i<Size;i++)
 for(int j=0;j<Size;j++)
 R->SetData(i,j,GetData(i,j) || Y->GetData(i,j));
}

void TWTMatrix::Eq(TWTMatrix *Y)
{
 Y->Size=Size;
 for(int i=0;i<=Size-1;i++)
 for(int j=0;j<=Size-1;j++)
 Y->SetData(i,j,GetData(i,j));
}

void TWTMatrix::SetData(char x,char y,char d)
{
 Data->Data[x][y]=d;
}

char TWTMatrix::GetData(char x,char y)
{
 return Data->Data[x][y];
}

TWTMatrix::TWTMatrix(int size)
{
 Data=new Matrica;
 Size=size;
 Clear();
}

void TWTMatrix::Clear()
{
 for(int i=0;i<Size;i++)
 for(int j=0;j<Size;j++)
 SetData(i,j,0);
}

void TWTMatrix::Single()
{
 Clear();
 for(int j=0;j<Size;j++)
 SetData(j,j,1);
}

void TWTMatrix::T(TWTMatrix *R)
{
 for(int i=0;i<Size;i++)
 for(int j=0;j<Size;j++)
 R->SetData(j,i,GetData(i,j));
}

