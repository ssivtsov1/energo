object FShowSys: TFShowSys
  Left = 65
  Top = 114
  BorderStyle = bsDialog
  Caption = 'Настройка рабочего периода'
  ClientHeight = 80
  ClientWidth = 826
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 6
    Top = 24
    Width = 176
    Height = 16
    Caption = 'Рабочий период  закрытия'
  end
  object Label2: TLabel
    Left = 518
    Top = 26
    Width = 161
    Height = 16
    Caption = 'Рабочий период  данных'
  end
  object EdMMGG: TMaskEdit
    Left = 204
    Top = 22
    Width = 75
    Height = 24
    EditMask = '!99/99/9900;1;_'
    MaxLength = 10
    ReadOnly = True
    TabOrder = 0
    Text = '  .  .    '
  end
  object ChNext: TCheckBox
    Left = 312
    Top = 24
    Width = 191
    Height = 17
    Caption = 'Работать в след.месяце '
    TabOrder = 1
    OnClick = ChNextClick
  end
  object BtnSave: TBitBtn
    Left = 366
    Top = 48
    Width = 105
    Height = 25
    Caption = '&Применить'
    TabOrder = 2
    OnClick = BtnSaveClick
    Kind = bkYes
  end
  object EdMMGGN: TMaskEdit
    Left = 698
    Top = 20
    Width = 75
    Height = 24
    EditMask = '!99/99/9900;1;_'
    MaxLength = 10
    ReadOnly = True
    TabOrder = 3
    Text = '  .  .    '
  end
end
