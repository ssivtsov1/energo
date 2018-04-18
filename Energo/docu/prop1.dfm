object Properties: TProperties
  Left = 395
  Top = 178
  AutoScroll = False
  Caption = 'Свойства элемента'
  ClientHeight = 393
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 36
    Top = 16
    Width = 47
    Height = 13
    Caption = 'Элемент:'
  end
  object Label2: TLabel
    Left = 10
    Top = 48
    Width = 77
    Height = 13
    Caption = 'Тип элемента: '
  end
  object Text_type: TLabel
    Left = 88
    Top = 48
    Width = 47
    Height = 13
    Caption = 'Text_type'
  end
  object Label4: TLabel
    Left = 104
    Top = 72
    Width = 100
    Height = 13
    Caption = 'Значение элемента'
  end
  object Text_name: TEdit
    Left = 88
    Top = 8
    Width = 225
    Height = 21
    Enabled = False
    ReadOnly = True
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 1
    Top = 88
    Width = 322
    Height = 277
    Lines.Strings = (
      '')
    TabOrder = 1
  end
  object Button1: TButton
    Left = 128
    Top = 368
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 2
    OnClick = Button1Click
  end
end
