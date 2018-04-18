object fGroundDet: TfGroundDet
  Left = 183
  Top = 225
  Width = 520
  Height = 226
  Align = alClient
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 512
    Height = 199
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 6
      Width = 121
      Height = 13
      Caption = 'Разреш. мощность, кВт'
    end
    object Label4: TLabel
      Left = 16
      Top = 44
      Width = 117
      Height = 13
      Caption = 'Рабочих часов в месяц'
    end
    object edPower: TEdit
      Left = 16
      Top = 20
      Width = 121
      Height = 21
      Hint = 'Дозволена потужність'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = edDataChange
    end
    object edWorkTime: TEdit
      Left = 16
      Top = 58
      Width = 121
      Height = 21
      TabOrder = 1
      OnChange = edDataChange
    end
    object btEquipment: TBitBtn
      Left = 16
      Top = 90
      Width = 141
      Height = 25
      Caption = 'Оборудование'
      TabOrder = 2
      OnClick = btEquipmentClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00700000000000
        00007088FFFFFFFFFFF07088F000000F00F07088FFFFFFFFFFF07088F00000FF
        FFF07088FFFFFFFFFFF07088CCCCCCCCCCC070AACFFFFFCCCCC07088CCCCCCCC
        CCC07088FFFFFFFFFFF07088F0000F00FFF07088FFFFFFFFFFF07088FFFFFFFF
        FFF0700000000000000070CCCCCCCCCCCCC07000000000000000}
    end
  end
end
