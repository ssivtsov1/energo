object fFiderDet: TfFiderDet
  Left = 213
  Top = 343
  Width = 541
  Height = 288
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
    Width = 533
    Height = 261
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 0
    object Label3: TLabel
      Left = 14
      Top = 12
      Width = 109
      Height = 13
      Caption = '������� ����������'
    end
    object Label15: TLabel
      Left = 128
      Top = 12
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
      Top = 32
      Width = 3
      Height = 13
      Alignment = taCenter
      Caption = '-'
    end
    object sbClassSel: TSpeedButton
      Left = 148
      Top = 26
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
    object lLengthCaption: TLabel
      Left = 8
      Top = 238
      Width = 149
      Height = 13
      Caption = '��������� ����� ������ (�)'
      Visible = False
    end
    object lLength: TLabel
      Left = 164
      Top = 238
      Width = 43
      Height = 13
      Caption = 'lLength'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object Label2: TLabel
      Left = 198
      Top = 12
      Width = 58
      Height = 13
      Caption = '���������:'
    end
    object sbPosition: TSpeedButton
      Left = 456
      Top = 26
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
      OnClick = sbPositionClick
    end
    object spPositionClear: TSpeedButton
      Left = 481
      Top = 26
      Width = 23
      Height = 22
      Hint = '������� ��� �������'
      Caption = 'X'
      ParentShowHint = False
      ShowHint = True
      OnClick = spPositionClearClick
    end
    object Label9: TLabel
      Left = 12
      Top = 56
      Width = 113
      Height = 13
      Caption = '���������� 110-35 ��'
    end
    object sbPS: TSpeedButton
      Left = 400
      Top = 52
      Width = 23
      Height = 22
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
        7777000000000007777700333333333077770B033333333307770FB033333333
        30770BFB0333333333070FBFB000000000000BFBFBFBFB0777770FBFBFBFBF07
        77770BFB00000007777770007777777700077777777777777007777777770777
        0707777777777000777777777777777777777777777777777777}
      OnClick = sbPSClick
    end
    object sbPSCl: TSpeedButton
      Left = 424
      Top = 52
      Width = 23
      Height = 22
      Caption = '�'
      OnClick = sbPSClClick
    end
    object edClassId: TEdit
      Left = 12
      Top = 26
      Width = 41
      Height = 21
      ReadOnly = True
      TabOrder = 0
    end
    object EdPosition: TEdit
      Left = 196
      Top = 26
      Width = 261
      Height = 21
      TabOrder = 1
    end
    object GroupBox1: TGroupBox
      Left = 8
      Top = 82
      Width = 516
      Height = 153
      Anchors = [akLeft, akTop, akRight]
      Caption = ' ������ ������ � ������ 0.4 �� '
      TabOrder = 2
      object Label4: TLabel
        Left = 6
        Top = 20
        Width = 204
        Height = 13
        Caption = '����������� ������ (������ ��������)'
      end
      object Bevel1: TBevel
        Left = 8
        Top = 40
        Width = 500
        Height = 4
        Anchors = [akLeft, akTop, akRight]
        Shape = bsBottomLine
      end
      object Label1: TLabel
        Left = 8
        Top = 50
        Width = 126
        Height = 13
        Caption = '���������� ����� 0.4 ��'
      end
      object Label5: TLabel
        Left = 8
        Top = 76
        Width = 172
        Height = 13
        Caption = '��������� ����� ����� 0.4 ��, �'
      end
      object Label6: TLabel
        Left = 8
        Top = 100
        Width = 180
        Height = 13
        Caption = '����� ���������� �����������, �'
      end
      object Label7: TLabel
        Left = 280
        Top = 100
        Width = 136
        Height = 13
        Caption = '2 � 3 -������ �����������'
      end
      object Label8: TLabel
        Left = 8
        Top = 128
        Width = 243
        Height = 13
        Caption = '������� ������� �������� �������� F ���, ��2'
      end
      object sbWorks: TSpeedButton
        Left = 398
        Top = 50
        Width = 111
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '������ �����'
        Glyph.Data = {
          62050000424D62050000000000003604000028000000110000000F0000000100
          0800000000002C01000000000000000000000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFF070707070707070707070707FF00
          0000FFFF00FB000000000000000000000007FF000000FFFFFF0000A4F2F2F2F2
          F2F2F2F20007FF000000FFFF00FB00A4F2F2F2F2F2F2F2F20007FF000000FFFF
          FF0000A4F2F2F2F2F2F2F2F20007FF000000FFFF00FB00A4F2F2F2F2F2F2F2F2
          0007FF000000FFFFFF0000A4F2F2F2F2F2F2F2F20007FF000000FFFF00FB00A4
          F2F2F2F2F2F2F2F20007FF000000FFFFFF0000A4F2000000000000F20007FF00
          0000FFFF00FB00A4F200FFFFFFFF00F20007FF000000FFFFFF0000A4F2000000
          000000F20007FF000000FFFF00FB00A4F2F2F2F2F2F2F2F20007FF000000FFFF
          FF000000000000000000000000FFFF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFF000000}
        OnClick = sbWorksClick
      end
      object sbPlanWorks: TSpeedButton
        Left = 282
        Top = 50
        Width = 111
        Height = 21
        Anchors = [akTop, akRight]
        Caption = '���� �����'
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          0800000000000001000000000000000000000001000000010000000000006CAC
          FF00FFFFFE00FFFEFD00FEFDFC00FCFCFC00FEFCFA00FAFAFA00FEFCF900FDFB
          F800FDFBF600FCFAF500F5F5F500FCF9F400FFF9F300FBF8F300FBF7F200FAF7
          F100F9F6F000F2F1F0009FBFF000FAF6EF00F9F6EF00F9F2EF00F9F5EE00FAF5
          ED00EDEDED00F8F4EC00F8F4EB00F0EFEB00F8F3EA00EAEAEA00FDF2E900EFEC
          E900F8F2E800F8F2E700EEECE700F7F1E600E6E6E6003371E600F6F0E500EDEA
          E400E4E4E400F6F0E300F6EFE200F6EFE100EDE9E100E8E5E100E1E1E100F5EE
          E000F4EDDF00E4E2DF00ECE6DE00E3E1DE00F4ECDD00F7E5DD00E2E1DD00DDDD
          DD00F4EBDC00F4EBDB00F3EADB00F9E8DA00F3EAD900F3E9D800E3DED800D8D8
          D800F3E9D7007692D600F2E8D500F2E7D400D7D5D300F2E6D200F2E6D100D1D1
          D100FCE6CF00F1E5CF00CECECE00F1E5CD00CCCCCD00F0E3CA00F3E2C900E4D0
          C800FFFAC700EEE0C500FFF2C000EDDEBF00ECDBBB00FFEDBA00E8D6B800FFCB
          B800FFE7B500FBD6B400FFCBB300FDE5B200FFCDAF00EBCAAF00FFE1AE00DBC5
          AD00F1D9AB00FFCEAB00FFDDAA00EBD7A800FFCEA800FFD9A600FFD6A300F6D4
          A200D7BD9F00FFD29E00FFD09D00F3CC9C00DDC99C00FFCE9B00FFCD9A00E5C0
          9A00FFCC9900EBBA9500F9C69400F3C19400FFCA9300EFBD9300CBA59300D0A9
          9200C59E9100FFC88E00E2AA8C00E9B68B00FEC68A00FFC98600D0B18600D6A0
          8600DCA98500C6A58500FFC584002F4D8300787B8100CB9A8000C3967C00FFC1
          7900A97E7900FCBD7400E5B87400D58E7300DDA97100B68A7100DF9770007070
          7000FFB86E00A97B6D00FFBD6C00E89F6A006A6A6A00A16E6800BD806700F4AC
          6600D3866400FFBA6300D996620096636200FFB461002C426100C9856000EEAA
          5E00FCB35D00FFB85C00E79B5C00F4A15A00B1795A00AA7356005C585600FFB5
          5400A5705300D88D5100FAB6500083505000FFB44F0092634E00FFB34D009F6A
          4C00FFB44900FFB04900C5734600A0654600FFB04300AF6C4200E86E4000EF97
          3F00FFAE3C009E593B00D8843900FFAA3400FF6E2D00BD642D00FFA82C00FDA6
          2900E8872700FF742600FFA62500D56E2500F56E2200FFA42100FE792000FF7D
          1D0096491C00AE4D1B00FFA21A00FF801A00F47B1900F6951800E17B1800CD55
          1800FF851500FFA01300EC831300FF881100F4871100FF8B0F00EE870F00FE9C
          0D00FF8D0C00FF8F0B00F28C0B00EA7B0B00D66D0A00FF900900FF920700FF9B
          0600FF950500FB950300FF9A0200FF970200FF99000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000000000000000000000000000FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF91919191919191919191919191FFFFADADADAD
          ADADAD939393ADADADADFFFFAF2525252323232323232323208AFF919D020202
          0202232320202020208AADAD970302134E4E4E4E4E4E2323238AAF2593060202
          0202030323232323208A9D028FFFFF134E4E4E4E4E463B48208A97038FFFFFFF
          FFFFFF0303038543208A930688FFFFFFFFFFFF03040343430E8A8FFF81020202
          0202020507050403208A8FFF8282828282827A7A7A7A7A7A7A8A88FFFFFFFFFF
          FF03040343430E8A91FF810202020202020507050403208A91FF828282828282
          7A7A7A7A7A7A7A8AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = sbPlanWorksClick
      end
      object edLostsCoef: TEdit
        Left = 224
        Top = 18
        Width = 129
        Height = 21
        TabOrder = 0
      end
      object edL04_count: TEdit
        Left = 144
        Top = 48
        Width = 97
        Height = 21
        TabOrder = 1
      end
      object edL04_length: TEdit
        Left = 192
        Top = 72
        Width = 80
        Height = 21
        TabOrder = 2
      end
      object edL04f1_length: TEdit
        Left = 192
        Top = 96
        Width = 80
        Height = 21
        TabOrder = 3
      end
      object edL04f3_length: TEdit
        Left = 424
        Top = 96
        Width = 80
        Height = 21
        TabOrder = 4
      end
      object edFgcp: TEdit
        Left = 272
        Top = 124
        Width = 97
        Height = 21
        TabOrder = 5
      end
    end
    object cbBalansOnly: TCheckBox
      Left = 256
      Top = 238
      Width = 265
      Height = 17
      Caption = '������������ ������ � ���������� �������'
      TabOrder = 3
    end
    object edPSName: TEdit
      Left = 148
      Top = 52
      Width = 245
      Height = 21
      TabOrder = 4
    end
  end
end