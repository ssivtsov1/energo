object fBorderDet: TfBorderDet
  Left = 143
  Top = 167
  Width = 555
  Height = 246
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
    Width = 547
    Height = 219
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvNone
    BorderStyle = bsSingle
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 42
      Height = 13
      Caption = '�������'
    end
    object Label3: TLabel
      Left = 248
      Top = 8
      Width = 59
      Height = 13
      Caption = '����������'
    end
    object Label2: TLabel
      Left = 24
      Top = 120
      Width = 366
      Height = 13
      Caption = '�������� ������� �� ���� ������������� ���������� ��������������'
    end
    object Label4: TLabel
      Left = 24
      Top = 54
      Width = 184
      Height = 13
      Caption = '��������-��������� �����������: '
    end
    object bDocSel: TSpeedButton
      Left = 480
      Top = 76
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
      OnClick = sbCliDocClick
    end
    object Label14: TLabel
      Left = 208
      Top = 52
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
    object edClientA: TEdit
      Left = 16
      Top = 24
      Width = 217
      Height = 21
      AutoSelect = False
      ReadOnly = True
      TabOrder = 0
      Text = ' '
    end
    object edClientB: TEdit
      Left = 248
      Top = 24
      Width = 225
      Height = 21
      AutoSelect = False
      ReadOnly = True
      TabOrder = 1
      Text = ' '
      OnChange = edClientAChange
    end
    object mInf: TMemo
      Left = 24
      Top = 136
      Width = 457
      Height = 65
      TabOrder = 2
      OnChange = edDataChange
    end
    object edDoc: TEdit
      Left = 24
      Top = 76
      Width = 449
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
  end
end
