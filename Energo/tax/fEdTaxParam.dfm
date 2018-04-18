object fTaxParam: TfTaxParam
  Left = 461
  Top = 356
  BorderStyle = bsDialog
  Caption = 'Нараметры налоговой накладной'
  ClientHeight = 145
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 282
    Height = 145
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 8
      Width = 151
      Height = 13
      Caption = 'Створена Налогова накладна'
    end
    object Label2: TLabel
      Left = 20
      Top = 40
      Width = 34
      Height = 13
      Caption = 'Номер'
    end
    object Label3: TLabel
      Left = 20
      Top = 72
      Width = 26
      Height = 13
      Caption = 'Дата'
    end
    object lRegWarning: TLabel
      Left = 8
      Top = 92
      Width = 265
      Height = 17
      AutoSize = False
      Caption = 'Податкова накладна підлягає реєстрації в ЄДРПН!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
      WordWrap = True
    end
    object btCancel: TBitBtn
      Left = 196
      Top = 112
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkCancel
    end
    object btOk: TBitBtn
      Left = 116
      Top = 112
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
    object edDt: TMaskEdit
      Left = 68
      Top = 66
      Width = 121
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 2
      Text = '  .  .    '
    end
    object edNum: TEdit
      Left = 68
      Top = 36
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
end
