object AddField: TAddField
  Left = 228
  Top = 209
  Width = 559
  Height = 270
  Caption = 'Добавление поля из таблицы'
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
  object SpeedButton1: TSpeedButton
    Left = 271
    Top = 217
    Width = 274
    Height = 23
    Caption = 'Добавить'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 2
    Top = 217
    Width = 269
    Height = 23
    Caption = 'Отменить'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Label1: TLabel
    Left = 3
    Top = 3
    Width = 194
    Height = 13
    Caption = 'Наименование елемента в документе'
  end
  object ListField: TListView
    Left = 0
    Top = 24
    Width = 550
    Height = 161
    Columns = <>
    TabOrder = 0
    OnChange = ListFieldChange
  end
  object Combo: TComboBox
    Left = 1
    Top = 192
    Width = 547
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboChange
  end
  object Edit1: TEdit
    Left = 201
    Top = 0
    Width = 347
    Height = 21
    TabOrder = 2
  end
end
