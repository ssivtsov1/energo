object MailToConfig: TMailToConfig
  Left = 225
  Top = 103
  Width = 318
  Height = 244
  Caption = 'Почтовые программы'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 310
    Height = 217
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 159
      Height = 13
      Caption = 'Выберите почтовую программу'
    end
    object btCancel: TBitBtn
      Left = 216
      Top = 184
      Width = 75
      Height = 25
      TabOrder = 0
      OnClick = btCancelClick
      Kind = bkCancel
    end
    object btOk: TBitBtn
      Left = 136
      Top = 184
      Width = 75
      Height = 25
      TabOrder = 1
      OnClick = btOkClick
      Kind = bkOK
    end
    object lbMails: TListBox
      Left = 16
      Top = 24
      Width = 273
      Height = 121
      ItemHeight = 13
      TabOrder = 2
      OnClick = lbMailsClick
    end
    object edCommand: TEdit
      Left = 16
      Top = 152
      Width = 273
      Height = 21
      TabOrder = 3
    end
  end
end
