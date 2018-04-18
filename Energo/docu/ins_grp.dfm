object Grp_ins: TGrp_ins
  Left = 257
  Top = 287
  Width = 259
  Height = 256
  BorderIcons = []
  Caption = 'Вставить Группу'
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
  object Butinsgrp: TSpeedButton
    Left = 8
    Top = 200
    Width = 89
    Height = 22
    Caption = 'Вставить'
    Flat = True
    OnClick = ButinsgrpClick
  end
  object cancel: TSpeedButton
    Left = 152
    Top = 200
    Width = 89
    Height = 22
    Caption = 'Отменить'
    Flat = True
    OnClick = cancelClick
  end
  object Label1: TLabel
    Left = 72
    Top = 8
    Width = 115
    Height = 13
    Caption = 'Наименование группы'
  end
  object Label2: TLabel
    Left = 72
    Top = 56
    Width = 109
    Height = 13
    Caption = 'Последующая группа'
  end
  object grp_text: TEdit
    Left = 8
    Top = 24
    Width = 234
    Height = 21
    TabOrder = 0
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 80
    Width = 113
    Height = 17
    Caption = 'Все последующие'
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 146
    Top = 80
    Width = 89
    Height = 17
    Caption = 'Выбрать'
    TabOrder = 2
    OnClick = RadioButton2Click
  end
  object NextGrp: TListView
    Left = 8
    Top = 104
    Width = 235
    Height = 89
    Columns = <>
    TabOrder = 3
    ViewStyle = vsList
    OnChanging = NextGrpChanging
  end
end
