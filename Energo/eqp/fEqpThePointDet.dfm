object fEqpPointDet: TfEqpPointDet
  Left = 500
  Top = 328
  Width = 713
  Height = 427
  Align = alClient
  Caption = 'fEqpPointDet'
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
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 697
    Height = 389
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = '��������'
      object pMeterMain: TPanel
        Left = 0
        Top = 0
        Width = 689
        Height = 361
        Align = alClient
        Anchors = [akTop, akRight]
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 6
          Width = 121
          Height = 13
          Caption = '������. ��������, ���'
        end
        object Label2: TLabel
          Left = 320
          Top = 6
          Width = 141
          Height = 13
          Caption = '���� ����������� �������'
        end
        object sbAddEnergy: TSpeedButton
          Left = 671
          Top = 20
          Width = 23
          Height = 22
          Hint = '�������� ��� �������'
          Anchors = [akTop, akRight]
          Enabled = False
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            777700000000000000000FFFF8FFFF8FFFF008888888888888800FFF08FFFF8F
            FFF078880088888888800000090FFF8FFFF0099999907000000009999990AAAA
            AAAA00000907700000007FFF00FFFF8FFFF008880888888888800FFFF8FFFF8F
            FFF000000000000000000CCCCCCCCCCCCCC00000000000000000}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbAddEnergyClick
        end
        object sbDelEnergy: TSpeedButton
          Left = 671
          Top = 48
          Width = 23
          Height = 22
          Hint = '������� ��� �������'
          Anchors = [akTop, akRight]
          Enabled = False
          Glyph.Data = {
            F6000000424DF600000000000000760000002800000010000000100000000100
            0400000000008000000000000000000000001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777779077777777790779990777777777777999907777779077779990777779
            0777777999077799077777779990799077777777799999077777777777999077
            7777777779999907777777779990799077777799990777990777799990777779
            9077799907777777790777777777777777777777777777777777}
          ParentShowHint = False
          ShowHint = True
          OnClick = sbDelEnergyClick
        end
        object Label9: TLabel
          Left = 16
          Top = 42
          Width = 33
          Height = 13
          Caption = '�����'
        end
        object lTarifReq: TLabel
          Left = 52
          Top = 44
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
        object sbTarifSel: TSpeedButton
          Left = 250
          Top = 55
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
          OnClick = sbTarifSelClick
        end
        object lPowerReq: TLabel
          Left = 136
          Top = 4
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
          Left = 280
          Top = 112
          Width = 221
          Height = 13
          Caption = '������. ���������� ���������� ��������'
        end
        object Label4: TLabel
          Left = 16
          Top = 76
          Width = 117
          Height = 13
          Caption = '������� ����� � �����'
        end
        object Label5: TLabel
          Left = 16
          Top = 114
          Width = 19
          Height = 13
          Caption = 'Tg f'
        end
        object sbTgSel: TSpeedButton
          Left = 164
          Top = 127
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
          OnClick = sbTgSelClick
        end
        object lWtimeReq: TLabel
          Left = 136
          Top = 76
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
        object lTgReq: TLabel
          Left = 40
          Top = 112
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
        object Label3: TLabel
          Left = 16
          Top = 152
          Width = 219
          Height = 13
          Caption = '������� ���������� (�� ������� �������)'
        end
        object lClassVal: TLabel
          Left = 64
          Top = 172
          Width = 3
          Height = 13
          Alignment = taCenter
          Caption = '-'
        end
        object sbClassSel: TSpeedButton
          Left = 164
          Top = 166
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
        object Label18: TLabel
          Left = 152
          Top = 6
          Width = 154
          Height = 13
          Caption = '�������. ��������� ���/���'
        end
        object sbPassport: TSpeedButton
          Left = 168
          Top = 90
          Width = 105
          Height = 21
          Caption = '�������� ��'
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
          OnClick = sbPassportClick
        end
        object Label20: TLabel
          Left = 308
          Top = 4
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
        object Label21: TLabel
          Left = 16
          Top = 218
          Width = 117
          Height = 13
          Caption = '��������� ����������'
        end
        object edPower: TEdit
          Left = 16
          Top = 20
          Width = 121
          Height = 21
          Hint = '��������� ����������'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnChange = edDataChange
        end
        object dgEnergy: TDBGrid
          Left = 320
          Top = 20
          Width = 344
          Height = 81
          Anchors = [akLeft, akTop, akRight]
          Enabled = False
          TabOrder = 2
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnEnter = dgEnergyEnter
          Columns = <
            item
              Expanded = False
              FieldName = 'name'
              ReadOnly = True
              Title.Caption = '��� �������'
              Width = 111
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'dt_instal'
              ReadOnly = True
              Title.Caption = '����'
              Width = 74
              Visible = True
            end>
        end
        object edTarifName: TEdit
          Left = 16
          Top = 54
          Width = 230
          Height = 21
          ReadOnly = True
          TabOrder = 1
        end
        object cbCounLost: TCheckBox
          Left = 280
          Top = 168
          Width = 105
          Height = 17
          Caption = '������� ������'
          TabOrder = 3
          OnClick = cbCounLostClick
        end
        object edEkvivalent: TEdit
          Left = 280
          Top = 128
          Width = 129
          Height = 21
          TabOrder = 4
          OnChange = edDataChange
        end
        object edWorkTime: TEdit
          Left = 16
          Top = 90
          Width = 117
          Height = 21
          TabOrder = 5
          OnChange = edDataChange
        end
        object edTgName: TEdit
          Left = 16
          Top = 128
          Width = 141
          Height = 21
          TabOrder = 6
        end
        object edClassId: TEdit
          Left = 16
          Top = 166
          Width = 41
          Height = 21
          ReadOnly = True
          TabOrder = 7
        end
        object cbMainLosts: TCheckBox
          Left = 400
          Top = 168
          Width = 173
          Height = 17
          Caption = '�� ������ ������ ��������� '
          TabOrder = 8
          OnClick = cbCounLostClick
        end
        object cbLost_Nolost: TCheckBox
          Left = 196
          Top = 168
          Width = 77
          Height = 17
          Caption = '���������'
          TabOrder = 9
          OnClick = cbCounLostClick
        end
        object cbReserv: TCheckBox
          Left = 18
          Top = 196
          Width = 225
          Height = 17
          Caption = '��������� ���� (1 ����� �����������)'
          TabOrder = 10
          OnClick = cbCounLostClick
        end
        object cbInLost: TCheckBox
          Left = 280
          Top = 196
          Width = 281
          Height = 17
          Caption = '����� ������� �� ������� ���������'
          TabOrder = 11
          OnClick = cbCounLostClick
        end
        object edConnect: TEdit
          Left = 152
          Top = 20
          Width = 121
          Height = 21
          Hint = '�������� ����������'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 12
        end
        object btAktMEM: TBitBtn
          Left = 514
          Top = 112
          Width = 75
          Height = 27
          Caption = '���'
          TabOrder = 13
          OnClick = btAktMEMClick
          Glyph.Data = {
            8A010000424D8A01000000000000760000002800000015000000170000000100
            04000000000014010000CE0E0000D80E00001000000000000000000000000000
            80000080000000808000800000008000800080800000C0C0C000808080000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
            7777777770007777777777777777777770007777777777777777777770007777
            7777777777777777700077777777777777777777700077700000000000777777
            700077077777777707077777700070000000000000707777700070777777BBB7
            7000777770007077777788877070777770007000000000000077077770007077
            777777770707077770007700000000007070077770007770FFFFFFFF07070777
            700077770F00000F00007777700077770FFFFFFFF07777777000777770F00000
            F07777777000777770FFFFFFFF07777770007777770000000007777770007777
            7777777777777777700077777777777777777777700077777777777777777777
            7000777777777777777777777000}
        end
        object cbKVA: TCheckBox
          Left = 288
          Top = 24
          Width = 25
          Height = 17
          Hint = '�������� ���������� � ���'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 14
        end
        object edSafeCategory: TEdit
          Left = 144
          Top = 214
          Width = 49
          Height = 21
          TabOrder = 15
        end
        object cbDisabled: TCheckBox
          Left = 280
          Top = 216
          Width = 281
          Height = 17
          Caption = '�������� ���������'
          TabOrder = 16
          OnClick = cbCounLostClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = '��������������'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 689
        Height = 361
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvLowered
        TabOrder = 0
        object sbSelIndustry: TSpeedButton
          Left = 104
          Top = 214
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
          OnClick = sbSelIndustryClick
        end
        object Label6: TLabel
          Left = 16
          Top = 200
          Width = 81
          Height = 13
          Caption = '��� ����������:'
        end
        object LabKwed: TLabel
          Left = 136
          Top = 212
          Width = 547
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'LabKwed'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -16
          Font.Name = 'Times New Roman'
          Font.Style = []
          ParentFont = False
        end
        object Label8: TLabel
          Left = 16
          Top = 48
          Width = 223
          Height = 13
          Caption = '������� �� ����������� �� �������� �����'
        end
        object Label10: TLabel
          Left = 264
          Top = 8
          Width = 200
          Height = 13
          Caption = '�������� �������������� ���������'
        end
        object Label11: TLabel
          Left = 16
          Top = 88
          Width = 413
          Height = 13
          Caption = 
            '������ � ������� �������� ������������� ��������������� ���� 5% ' +
            '��������'
        end
        object Label12: TLabel
          Left = 264
          Top = 48
          Width = 307
          Height = 13
          Caption = '����������� �� ����. ������ (���/�����/�����) / ���. ���� '
        end
        object Label13: TLabel
          Left = 16
          Top = 8
          Width = 25
          Height = 13
          Caption = '����'
        end
        object sbSelZone: TSpeedButton
          Left = 144
          Top = 22
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
          OnClick = sbSelZoneClick
        end
        object sbDepart: TSpeedButton
          Left = 292
          Top = 142
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
          OnClick = sbDepartClick
        end
        object Label14: TLabel
          Left = 16
          Top = 128
          Width = 79
          Height = 13
          Caption = '������������: '
        end
        object Label15: TLabel
          Left = 542
          Top = 88
          Width = 144
          Height = 13
          Anchors = [akTop, akRight]
          Caption = '���������� �� �� (�����.)  '
        end
        object lUnName: TLabel
          Left = 605
          Top = 112
          Width = 3
          Height = 13
          Alignment = taCenter
          Anchors = [akTop, akRight]
          Caption = '-'
        end
        object sbUnSel: TSpeedButton
          Left = 658
          Top = 106
          Width = 23
          Height = 22
          Hint = '������� ����������'
          Anchors = [akTop, akRight]
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
          OnClick = sbUnSelClick
        end
        object Label16: TLabel
          Left = 328
          Top = 128
          Width = 154
          Height = 13
          Caption = '�������������� ���������: '
        end
        object sbExtra: TSpeedButton
          Left = 634
          Top = 142
          Width = 23
          Height = 22
          Hint = '������� ����������'
          Anchors = [akTop, akRight]
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
          OnClick = sbExtraClick
        end
        object spExtraClean: TSpeedButton
          Left = 659
          Top = 142
          Width = 23
          Height = 22
          Hint = '������� ��� �������'
          Anchors = [akTop, akRight]
          Caption = 'X'
          ParentShowHint = False
          ShowHint = True
          OnClick = spExtraCleanClick
        end
        object Label17: TLabel
          Left = 16
          Top = 164
          Width = 114
          Height = 13
          Caption = '���� �������� ������'
        end
        object Label19: TLabel
          Left = 178
          Top = 164
          Width = 58
          Height = 13
          Caption = '���������:'
        end
        object sbPosition: TSpeedButton
          Left = 634
          Top = 178
          Width = 23
          Height = 22
          Hint = '������� ����������'
          Anchors = [akTop, akRight]
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
          Left = 658
          Top = 178
          Width = 23
          Height = 22
          Hint = '������� ��� �������'
          Anchors = [akTop, akRight]
          Caption = 'X'
          ParentShowHint = False
          ShowHint = True
          OnClick = spPositionClearClick
        end
        object EdKwed: TMaskEdit
          Left = 16
          Top = 214
          Width = 73
          Height = 21
          EditMask = '!99.99.99;1;_'
          MaxLength = 8
          ReadOnly = True
          TabOrder = 0
          Text = '  .  .  '
        end
        object edShare: TEdit
          Left = 16
          Top = 62
          Width = 73
          Height = 21
          TabOrder = 1
          OnChange = edDataChange
        end
        object cbCount_itr: TCheckBox
          Left = 16
          Top = 108
          Width = 37
          Height = 17
          TabOrder = 2
          OnClick = cbCounLostClick
        end
        object edCmp: TEdit
          Left = 264
          Top = 24
          Width = 121
          Height = 21
          TabOrder = 3
          OnChange = edDataChange
        end
        object edItr_comment: TEdit
          Left = 36
          Top = 104
          Width = 503
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 4
          OnChange = edDataChange
        end
        object edLdemand: TEdit
          Left = 264
          Top = 62
          Width = 77
          Height = 21
          TabOrder = 5
          OnChange = edDataChange
        end
        object edPdays: TEdit
          Left = 508
          Top = 62
          Width = 69
          Height = 21
          TabOrder = 6
          OnChange = edDataChange
        end
        object edZone: TEdit
          Left = 16
          Top = 22
          Width = 73
          Height = 21
          ReadOnly = True
          TabOrder = 7
        end
        object cbHlosts: TCheckBox
          Left = 392
          Top = 28
          Width = 181
          Height = 17
          Caption = '��������� ������ ���� ������'
          TabOrder = 8
          OnClick = cbCounLostClick
        end
        object edDepart: TEdit
          Left = 16
          Top = 142
          Width = 273
          Height = 21
          TabOrder = 9
        end
        object edLdemandr: TEdit
          Left = 344
          Top = 62
          Width = 77
          Height = 21
          TabOrder = 10
          OnChange = edDataChange
        end
        object edLdemandg: TEdit
          Left = 424
          Top = 62
          Width = 77
          Height = 21
          TabOrder = 11
          OnChange = edDataChange
        end
        object edUn: TEdit
          Left = 546
          Top = 104
          Width = 45
          Height = 21
          Anchors = [akTop, akRight]
          ReadOnly = True
          TabOrder = 12
        end
        object edExtra: TEdit
          Left = 328
          Top = 142
          Width = 303
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 13
        end
        object edControlDay: TEdit
          Left = 16
          Top = 178
          Width = 77
          Height = 21
          TabOrder = 14
          OnChange = edDataChange
        end
        object EdPosition: TEdit
          Left = 179
          Top = 178
          Width = 453
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 15
        end
      end
    end
  end
end
