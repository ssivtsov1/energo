object fSimpleEqpDet: TfSimpleEqpDet
  Left = 214
  Top = 167
  Width = 385
  Height = 279
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
    Width = 369
    Height = 241
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 93
      Height = 13
      Caption = '��� ������������'
    end
    object bEqpTypeSel: TSpeedButton
      Left = 296
      Top = 24
      Width = 23
      Height = 22
      Hint = '������� ����������'
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
    object lAddData: TLabel
      Left = 16
      Top = 48
      Width = 44
      Height = 13
      Caption = 'lAddData'
    end
    object Label14: TLabel
      Left = 112
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
    object lAddReq: TLabel
      Left = 112
      Top = 46
      Width = 5
      Height = 16
      Caption = '*'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object lVoltage: TLabel
      Left = 16
      Top = 90
      Width = 109
      Height = 13
      Caption = '������� ����������'
    end
    object lVEeq: TLabel
      Left = 128
      Top = 90
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
    object lClassVal: TLabel
      Left = 64
      Top = 109
      Width = 3
      Height = 13
      Alignment = taCenter
      Caption = '-'
    end
    object sbClassSel: TSpeedButton
      Left = 144
      Top = 104
      Width = 23
      Height = 22
      Hint = '������� ����������'
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
    object edTypeName: TEdit
      Left = 16
      Top = 24
      Width = 273
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object edClassId: TEdit
      Left = 16
      Top = 105
      Width = 41
      Height = 21
      ReadOnly = True
      TabOrder = 1
    end
    object edAddData: TMaskEdit
      Left = 16
      Top = 64
      Width = 121
      Height = 21
      TabOrder = 2
      OnChange = edDataChange
    end
  end
end
