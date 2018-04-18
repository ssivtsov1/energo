object Grp_add: TGrp_add
  Left = 257
  Top = 199
  Width = 258
  Height = 108
  BorderIcons = []
  Caption = 'Добавить Группу'
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
  object Butaddgrp: TSpeedButton
    Left = 16
    Top = 56
    Width = 89
    Height = 22
    Caption = 'Добавить'
    OnClick = ButaddgrpClick
  end
  object Butcangrp: TSpeedButton
    Left = 144
    Top = 56
    Width = 89
    Height = 22
    Caption = 'Отменить'
    OnClick = ButcangrpClick
  end
  object Label1: TLabel
    Left = 72
    Top = 8
    Width = 115
    Height = 13
    Caption = 'Наименование группы'
  end
  object grp_text: TEdit
    Left = 16
    Top = 24
    Width = 225
    Height = 21
    TabOrder = 0
  end
end
