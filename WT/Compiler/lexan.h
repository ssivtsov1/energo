#if !defined(__LEXAN_H)
#define __LEXAN_H

#include "boolmatr.h"
#include "ustack.h"
#include "lexem.h"
#include "gener.h"
#include "gramm.h"

class TWTGrammar;
class TWTGenerator;

class TWTAnalizer
{
 public:
  TWTGrammar *Grammar;
  TWTGenerator *Generator;
  TCustomStack<TWTLexema> LS;
  TCharStack RS;
  TMLFormula *FindRule(TCustomStack<TWTLexema> *);
  ~TWTAnalizer()
  {
   delete Generator;
  };
  TWTAnalizer(TWTGrammar *, char *);
  void Init();
  int Analize(TWTLexema);
  void Process();
};

#endif

