object FOpenMonth: TFOpenMonth
  Left = 296
  Top = 180
  Width = 514
  Height = 307
  Caption = 'ќткрытие мес€ца'
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 12
    Width = 358
    Height = 26
    Alignment = taCenter
    Caption = '¬ведите код на открытие мес€ца'
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label2: TLabel
    Left = 30
    Top = 108
    Width = 426
    Height = 19
    Alignment = taCenter
    Caption = 'ѕричина открыти€, с чьего разрешени€ и кто открывает : '
    Color = clSilver
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object EdMMGG: TEdit
    Left = 388
    Top = 0
    Width = 121
    Height = 21
    TabOrder = 4
    Visible = False
  end
  object EdHash: TMaskEdit
    Left = 136
    Top = 54
    Width = 147
    Height = 39
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -27
    Font.Name = 'Times'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = ' '
  end
  object BitBtn1: TBitBtn
    Left = 112
    Top = 196
    Width = 75
    Height = 25
    TabOrder = 1
    OnClick = BitBtn1Click
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 194
    Width = 79
    Height = 25
    Caption = '&ќтмена'
    TabOrder = 2
    OnClick = BitBtn2Click
    Kind = bkNo
  end
  object EdMemo: TMemo
    Left = 10
    Top = 132
    Width = 455
    Height = 49
    Color = clAqua
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Times'
    Font.Style = []
    Lines.Strings = (
      '')
    MaxLength = 255
    OEMConvert = True
    ParentFont = False
    TabOrder = 3
  end
end
