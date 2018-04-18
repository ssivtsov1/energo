object Filter: TFilter
  Left = 351
  Top = 217
  Width = 422
  Height = 210
  Caption = 'Фильтр'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = -1
    Width = 40
    Height = 13
    Caption = 'Фильтр'
  end
  object Label2: TLabel
    Left = 9
    Top = 86
    Width = 134
    Height = 13
    Caption = 'Наименование параметра'
  end
  object SpeedButton1: TSpeedButton
    Left = 176
    Top = 103
    Width = 57
    Height = 22
    Caption = ' AND '
    OnClick = Click
  end
  object SpeedButton2: TSpeedButton
    Left = 234
    Top = 103
    Width = 57
    Height = 22
    Caption = ' NOT '
    OnClick = Click
  end
  object SpeedButton3: TSpeedButton
    Left = 350
    Top = 103
    Width = 57
    Height = 22
    Caption = ' XOR '
    OnClick = Click
  end
  object SpeedButton4: TSpeedButton
    Left = 292
    Top = 103
    Width = 57
    Height = 22
    Caption = ' OR '
    OnClick = Click
  end
  object SpeedButton5: TSpeedButton
    Left = 176
    Top = 125
    Width = 39
    Height = 22
    Caption = '='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton6: TSpeedButton
    Left = 215
    Top = 125
    Width = 38
    Height = 22
    Caption = '<>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton7: TSpeedButton
    Left = 253
    Top = 125
    Width = 38
    Height = 22
    Caption = '<'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton8: TSpeedButton
    Left = 292
    Top = 125
    Width = 39
    Height = 22
    Caption = '>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton9: TSpeedButton
    Left = 331
    Top = 125
    Width = 38
    Height = 22
    Caption = '<='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton10: TSpeedButton
    Left = 369
    Top = 125
    Width = 38
    Height = 22
    Caption = '>='
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 22
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = Click
  end
  object SpeedButton11: TSpeedButton
    Left = 176
    Top = 151
    Width = 65
    Height = 25
    Caption = 'Поле'
    OnClick = SpeedButton11Click
  end
  object SpeedButton12: TSpeedButton
    Left = 241
    Top = 151
    Width = 23
    Height = 25
    Caption = '('
    OnClick = Click
  end
  object SpeedButton13: TSpeedButton
    Left = 264
    Top = 151
    Width = 23
    Height = 25
    Caption = ')'
    OnClick = Click
  end
  object Button1: TButton
    Left = 290
    Top = 151
    Width = 58
    Height = 25
    Caption = 'Включить'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 348
    Top = 151
    Width = 59
    Height = 25
    Caption = 'Отменить'
    TabOrder = 1
    OnClick = Button2Click
  end
  object ListParam: TListBox
    Left = 8
    Top = 101
    Width = 161
    Height = 74
    ItemHeight = 13
    Items.Strings = (
      'Наименование'
      'Дата создания')
    TabOrder = 2
  end
  object Memo1: TMemo
    Left = 8
    Top = 13
    Width = 401
    Height = 73
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
