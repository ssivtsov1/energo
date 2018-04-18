//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
#ifndef AboutH
#define AboutH
//----------------------------------------------------------------------------
#include <vcl\ExtCtrls.hpp>
#include <vcl\Controls.hpp>
#include <vcl\Forms.hpp>
#include <vcl\Graphics.hpp>
#include <vcl\Classes.hpp>
#include <vcl\Windows.hpp>
#include <vcl\System.hpp>

#include "Func.h"
#include "Form.h"
//----------------------------------------------------------------------------
class TWTAboutBox : public TWTForm {
public:
	TPanel *Panel;
	TButton *OKButton;
	TImage *ProgramIcon;
	TLabel *ProductName;
	TLabel *Version;
	TLabel *Copyright;
	TLabel *Comments;

private:

public:
	virtual _fastcall TWTAboutBox(TWinControl *owner);
	virtual _fastcall ~TWTAboutBox();
};
//----------------------------------------------------------------------------
#endif
