object SetFieldName: TSetFieldName
  Left = 376
  Top = 248
  Width = 273
  Height = 243
  Caption = 'Задайте значение параметра'
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
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 137
    Height = 13
    Caption = 'Наименование параметра:'
  end
  object Label2: TLabel
    Left = 152
    Top = 5
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object SpeedButton1: TSpeedButton
    Left = 72
    Top = 184
    Width = 121
    Height = 25
    Caption = 'Принять'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object ListView1: TListView
    Left = 0
    Top = 22
    Width = 265
    Height = 158
    Columns = <>
    TabOrder = 0
    OnChange = ListView1Change
  end
end
