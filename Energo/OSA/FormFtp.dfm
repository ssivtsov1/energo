object ftpForm: TftpForm
  Left = 540
  Top = 235
  BorderStyle = bsDialog
  Caption = '���������� ������������'
  ClientHeight = 618
  ClientWidth = 614
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  PrintScale = poNone
  Scaled = False
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object LHost: TLabel
    Left = 16
    Top = 88
    Width = 68
    Height = 24
    Caption = '������'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 120
    Width = 135
    Height = 24
    Caption = '���� � ������:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 528
    Top = 120
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
    OnClick = SpeedButton1Click
  end
  object Lab2: TLabel
    Left = 72
    Top = 8
    Width = 441
    Height = 19
    Caption = '����� ��������� ������������ ������������ ������������� '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Lab4: TLabel
    Left = 72
    Top = 24
    Width = 443
    Height = 19
    Caption = '���������� ��� ���������� � ������� ��������� ����� ����'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 360
    Top = 88
    Width = 53
    Height = 24
    Caption = '����  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 88
    Top = 368
    Width = 250
    Height = 13
    Caption = '���  �������������  ftp (������������ � ������('
    Visible = False
  end
  object SpeedButton2: TSpeedButton
    Left = 48
    Top = 368
    Width = 23
    Height = 22
    Glyph.Data = {
      96010000424D9601000000000000760000002800000018000000180000000100
      0400000000002001000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777777777777777777777777777777777777777777777777777777777777777
      777777777777777777777777777777777007777777777777777777770FF07777
      77777777777777770FF077777777777777707770FF0777777777777777700770
      FF077777777777777770F00FF0777777777777777770FFFFF077777777777777
      7770FFFFF0000777777777777770FFFFFFF07777777777777770FFFFFF077777
      777777777770FFFFF0777777777777777770FFFF07777777777777777770FFF0
      77777777777777777770FF0777777777777777777770F0777777777777777777
      7770077777777777777777777777777777777777777777777777777777777777
      7777777777777777777777777777777777777777777777777777}
    OnClick = SpeedButton2Click
    OnDblClick = SpeedButton2DblClick
  end
  object BOutSpr: TButton
    Left = 96
    Top = 184
    Width = 417
    Height = 25
    Caption = '�������� ������������'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    OnClick = BOutSprClick
  end
  object BInSpr: TButton
    Left = 96
    Top = 152
    Width = 417
    Height = 25
    Caption = '�������� ������������'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BInSprClick
  end
  object EdHost: TEdit
    Left = 96
    Top = 88
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EdPath: TEdit
    Left = 160
    Top = 120
    Width = 353
    Height = 21
    TabOrder = 2
    Text = 'D:\LoadAskue'
  end
  object EdAlias: TEdit
    Left = 432
    Top = 88
    Width = 81
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
  end
  object BSaveDMP: TButton
    Left = 96
    Top = 48
    Width = 417
    Height = 25
    Caption = '��������� ��������� �����'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = DumpClick
  end
  object MemState: TMemo
    Left = 16
    Top = 400
    Width = 537
    Height = 217
    Lines.Strings = (
      '')
    TabOrder = 12
  end
  object BAskue: TButton
    Left = 96
    Top = 224
    Width = 417
    Height = 25
    Caption = '�������� ��������� �����'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    OnClick = LoadAckue
  end
  object btLoadL04: TButton
    Left = 96
    Top = 264
    Width = 417
    Height = 25
    Caption = '�������� ����������� ����� 0,4 ��'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = btLoadL04Click
  end
  object btLoadFiz: TButton
    Left = 96
    Top = 292
    Width = 417
    Height = 25
    Caption = '�������� ������ ������  (���������������)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    OnClick = btLoadFizClick
  end
  object btFiderFiz: TButton
    Left = 96
    Top = 332
    Width = 417
    Height = 25
    Caption = '�������� ����������� ������  (��� �����������)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    OnClick = btFiderFizClick
  end
  object EdPwd: TEdit
    Left = 432
    Top = 368
    Width = 81
    Height = 21
    PasswordChar = '*'
    TabOrder = 11
    Visible = False
    OnExit = EdPwdExit
  end
  object EdUser: TEdit
    Left = 344
    Top = 368
    Width = 65
    Height = 21
    TabOrder = 10
    Visible = False
    OnExit = EdUserExit
  end
  object MyFtp: TNMFTP
    Host = '10.71.1.94'
    Port = 21
    ReportLevel = 0
    UserID = 'spr'
    Password = 'spr1973'
    Vendor = 2411
    ParseList = True
    ProxyPort = 0
    Passive = True
    FirewallType = FTUser
    FWAuthenticate = False
    Left = 8
    Top = 160
  end
  object SaveDialog: TSaveDialog
    InitialDir = 'c:\Temp'
    Left = 40
    Top = 168
  end
  object OpenDialog1: TOpenDialog
    Left = 80
    Top = 160
  end
end
