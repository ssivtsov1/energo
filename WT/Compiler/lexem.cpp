#include "lexem.h"

TWTLexema::TWTLexema(TDictUnit * DU, char * V,int R,int S)
{
 Row=R;
 Simb=S;
 Item=DU;
 strcpy(Value,V);
}

