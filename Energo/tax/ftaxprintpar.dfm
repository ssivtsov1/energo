object fTaxPrintParams: TfTaxPrintParams
  Left = 324
  Top = 205
  ActiveControl = edStart
  BorderStyle = bsDialog
  Caption = 'Печатать НН'
  ClientHeight = 155
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 250
    Height = 155
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 102
      Height = 13
      Caption = 'Период (месяц, год)'
    end
    object Label2: TLabel
      Left = 16
      Top = 72
      Width = 52
      Height = 13
      Caption = 'Номера с '
    end
    object Label3: TLabel
      Left = 148
      Top = 72
      Width = 12
      Height = 13
      Caption = 'по'
    end
    object btCancel: TBitBtn
      Left = 168
      Top = 126
      Width = 75
      Height = 25
      Caption = 'Отмена'
      TabOrder = 0
      Kind = bkCancel
    end
    object btOk: TBitBtn
      Left = 88
      Top = 126
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
    object edStart: TMaskEdit
      Left = 72
      Top = 68
      Width = 65
      Height = 21
      TabOrder = 2
      OnClick = edStartClick
    end
    object dtPeriod: TDateTimePicker
      Left = 16
      Top = 28
      Width = 225
      Height = 21
      CalAlignment = dtaLeft
      Date = 38596.756457963
      Time = 38596.756457963
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
    end
    object edStop: TEdit
      Left = 176
      Top = 68
      Width = 65
      Height = 21
      TabOrder = 4
    end
    object cbPrintAll: TCheckBox
      Left = 14
      Top = 96
      Width = 225
      Height = 25
      Caption = 'Печатать налоговые н. и корректировки'
      TabOrder = 5
    end
  end
end
