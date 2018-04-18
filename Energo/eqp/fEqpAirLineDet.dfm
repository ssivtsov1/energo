object fALineDet: TfALineDet
  Left = 144
  Top = 125
  Width = 518
  Height = 191
  ActiveControl = edCordeName
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
    Width = 510
    Height = 164
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 64
      Height = 13
      Caption = 'Тип провода'
    end
    object bEqpTypeSel: TSpeedButton
      Left = 224
      Top = 24
      Width = 23
      Height = 22
      Hint = 'Открыть справочник проводов'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = bEqpTypeSelClick
    end
    object Label2: TLabel
      Left = 272
      Top = 8
      Width = 94
      Height = 13
      Caption = 'Протяженность, м'
    end
    object bPillarSel: TSpeedButton
      Left = 224
      Top = 58
      Width = 23
      Height = 22
      Hint = 'Открыть справочник опор'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = bPillarSelClick
    end
    object Label3: TLabel
      Left = 16
      Top = 44
      Width = 54
      Height = 13
      Caption = 'Тип опоры'
    end
    object Label4: TLabel
      Left = 272
      Top = 44
      Width = 20
      Height = 13
      Caption = 'Шаг'
    end
    object Label5: TLabel
      Left = 16
      Top = 80
      Width = 111
      Height = 13
      Caption = 'Расстояние подвески'
    end
    object bPendantSel: TSpeedButton
      Left = 224
      Top = 94
      Width = 23
      Height = 22
      Hint = 'Открыть справочник подвески'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = bPendantSelClick
    end
    object Label6: TLabel
      Left = 272
      Top = 80
      Width = 116
      Height = 13
      Caption = 'Тип петли заземления'
    end
    object bEarthSel: TSpeedButton
      Left = 480
      Top = 94
      Width = 23
      Height = 22
      Hint = 'Открыть справочник петель заземления'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = bEarthSelClick
    end
    object Label14: TLabel
      Left = 84
      Top = 8
      Width = 5
      Height = 16
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label7: TLabel
      Left = 370
      Top = 8
      Width = 5
      Height = 16
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 16
      Top = 118
      Width = 109
      Height = 13
      Caption = 'Уровень напряжения'
    end
    object lClassVal: TLabel
      Left = 64
      Top = 136
      Width = 3
      Height = 13
      Alignment = taCenter
      Caption = '-'
    end
    object sbClassSel: TSpeedButton
      Left = 144
      Top = 132
      Width = 23
      Height = 22
      Hint = 'Открыть справочник'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = sbClassSelClick
    end
    object Label9: TLabel
      Left = 128
      Top = 120
      Width = 5
      Height = 16
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object edCordeName: TEdit
      Left = 16
      Top = 21
      Width = 201
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edLength: TEdit
      Left = 272
      Top = 21
      Width = 121
      Height = 21
      TabOrder = 1
      OnChange = edDataChange
    end
    object edPillarName: TEdit
      Left = 16
      Top = 58
      Width = 201
      Height = 21
      ReadOnly = True
      TabOrder = 2
    end
    object edStep: TEdit
      Left = 272
      Top = 58
      Width = 121
      Height = 21
      TabOrder = 3
      OnClick = edDataChange
    end
    object edPendantName: TEdit
      Left = 16
      Top = 94
      Width = 201
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
    object edEarthName: TEdit
      Left = 272
      Top = 94
      Width = 201
      Height = 21
      ReadOnly = True
      TabOrder = 5
    end
    object edClassId: TEdit
      Left = 16
      Top = 132
      Width = 41
      Height = 21
      ReadOnly = True
      TabOrder = 6
    end
  end
end
