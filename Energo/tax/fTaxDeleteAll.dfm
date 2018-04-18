object fDelTaxAll: TfDelTaxAll
  Left = 268
  Top = 287
  Width = 322
  Height = 179
  Caption = '”даление налоговых накладных'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 314
    Height = 152
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 102
      Height = 13
      Caption = 'ѕериод (мес€ц, год)'
    end
    object Label3: TLabel
      Left = 12
      Top = 4
      Width = 291
      Height = 17
      Caption = '”даление налоговых накладных за мес€ц'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 16
      Top = 64
      Width = 39
      Height = 13
      Caption = 'ƒекада'
    end
    object btCancel: TBitBtn
      Left = 232
      Top = 120
      Width = 75
      Height = 25
      Caption = 'ќтмена'
      TabOrder = 0
      Kind = bkCancel
    end
    object btOk: TBitBtn
      Left = 152
      Top = 120
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
    object dtPeriod: TDateTimePicker
      Left = 16
      Top = 40
      Width = 225
      Height = 21
      CalAlignment = dtaLeft
      Date = 38596.756457963
      Time = 38596.756457963
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
    end
    object cbDecade: TComboBox
      Left = 16
      Top = 80
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Items.Strings = (
        '- все - '
        '1 декада'
        '2 декада'
        '3 декада')
    end
  end
end
