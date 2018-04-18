#ifndef ListH
#define ListH

#include "vcl\Classes.hpp"
//#include <vcl\Dialogs.hpp>

#include "Func.h"
//----------------------------------------------------------------------------
// Список ссылок освобождающий память при удалении списка
// Использовать только для не VCL объектов !!!!
//----------------------------------------------------------------------------
class TWTList: public TList {
public:
  _fastcall virtual TWTList();
  _fastcall virtual ~TWTList();
};
//----------------------------------------------------------------------------
#endif
