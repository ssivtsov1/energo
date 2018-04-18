object fChangeDate: TfChangeDate
  Left = 276
  Top = 203
  ActiveControl = edDt_change
  BorderStyle = bsDialog
  Caption = 'Дата замены'
  ClientHeight = 119
  ClientWidth = 216
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
    Width = 216
    Height = 119
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 129
      Height = 13
      Caption = 'Укажите дату изменений'
    end
    object btCancel: TBitBtn
      Left = 128
      Top = 88
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkCancel
    end
    object btOk: TBitBtn
      Left = 48
      Top = 88
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkOK
    end
    object edDt_change: TMaskEdit
      Left = 16
      Top = 38
      Width = 169
      Height = 21
      EditMask = '!99/99/0000;1;_'
      MaxLength = 10
      TabOrder = 2
      Text = '  .  .    '
      OnClick = edDt_changeClick
    end
  end
end
