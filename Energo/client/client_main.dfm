object Client: TClient
  Left = 35
  Top = 87
  Width = 773
  Height = 504
  Caption = '�������� �������'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 157
    Width = 765
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    MinSize = 3
    OnMoved = Splitter1Moved
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 160
    Width = 765
    Height = 317
    Align = alBottom
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 116
    Width = 765
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 1
    object PropBut: TSpeedButton
      Left = 430
      Top = 8
      Width = 145
      Height = 23
      Caption = '������� �� �������'
      Flat = True
      OnClick = PropButClick
    end
    object SpeedButton1: TSpeedButton
      Left = 344
      Top = 8
      Width = 25
      Height = 22
      Caption = '�'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Symbol'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 368
      Top = 8
      Width = 23
      Height = 22
      Caption = '�'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Symbol'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object Bevel1: TBevel
      Left = 329
      Top = 2
      Width = 2
      Height = 37
      Shape = bsLeftLine
      Style = bsRaised
    end
    object SpeedButton9: TSpeedButton
      Tag = 7
      Left = 216
      Top = 9
      Width = 105
      Height = 26
      Caption = '��������� ���'
      Flat = True
      Glyph.Data = {
        9E020000424D9E0200000000000036000000280000000E0000000E0000000100
        18000000000068020000C40E0000C40E00000000000000000000BFBFBF000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000087800087800000000000000000000000000000000000
        00C0C7C0C0C7C000000000878000000000000000000087800087800000000000
        00000000000000000000000000C0C7C0C0C7C000000000878000000000000000
        00008780008780000000000000000000000000000000000000C0C7C0C0C7C000
        0000008780000000000000000000878000878000000000000000000000000000
        0000000000000000000000000000008780000000000000000000878000878000
        8780008780008780008780008780008780008780008780008780008780000000
        0000000000008780008780000000000000000000000000000000000000000000
        0000000087800087800000000000000000008780000000C0C7C0C0C7C0C0C7C0
        C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087800000000000000000008780
        000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087
        800000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7
        C0C0C7C0C0C7C00000000087800000000000000000008780000000C0C7C0C0C7
        C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000000000878000000000000000
        00008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000
        00000000000000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0
        C7C0C0C7C0C0C7C0C0C7C0000000C0C7C0000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000}
      OnClick = SaveClick
    end
    object Button1: TButton
      Left = 10
      Top = 8
      Width = 63
      Height = 25
      Caption = '��������'
      TabOrder = 1
      OnClick = Button1Click
    end
    object MaskEdit1: TMaskEdit
      Left = 392
      Top = 8
      Width = 25
      Height = 21
      EditMask = '!99;0;_'
      MaxLength = 2
      TabOrder = 3
      Text = '02'
    end
    object Button2: TButton
      Left = 78
      Top = 8
      Width = 63
      Height = 25
      Caption = '�������'
      TabOrder = 2
      OnClick = Button2Click
    end
    object DBNavigator1: TDBNavigator
      Left = 584
      Top = 8
      Width = 135
      Height = 25
      DataSource = Data
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbInsert]
      TabOrder = 0
      BeforeAction = DBNavigator1BeforeAction
      OnClick = DBNavigator1Click
    end
    object Kateg: TButton
      Left = 146
      Top = 8
      Width = 63
      Height = 25
      Caption = '���������'
      TabOrder = 4
      OnClick = KategClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 765
    Height = 116
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 2
    object Label1: TLabel
      Left = 27
      Top = 8
      Width = 144
      Height = 13
      Caption = '����������� �������������'
    end
    object Bevel2: TBevel
      Left = 2
      Top = 2
      Width = 761
      Height = 29
      Align = alTop
      Shape = bsBottomLine
      Style = bsRaised
    end
    object Label2: TLabel
      Left = 52
      Top = 35
      Width = 120
      Height = 13
      Caption = '������������ �������'
    end
    object Label3: TLabel
      Left = 9
      Top = 58
      Width = 163
      Height = 13
      Caption = '������� ������������ �������'
    end
    object SpeedButton3: TSpeedButton
      Tag = 1
      Left = 680
      Top = 4
      Width = 23
      Height = 22
      Flat = True
      Glyph.Data = {
        9E020000424D9E0200000000000036000000280000000E0000000E0000000100
        18000000000068020000C40E0000C40E00000000000000000000BFBFBF000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000087800087800000000000000000000000000000000000
        00C0C7C0C0C7C000000000878000000000000000000087800087800000000000
        00000000000000000000000000C0C7C0C0C7C000000000878000000000000000
        00008780008780000000000000000000000000000000000000C0C7C0C0C7C000
        0000008780000000000000000000878000878000000000000000000000000000
        0000000000000000000000000000008780000000000000000000878000878000
        8780008780008780008780008780008780008780008780008780008780000000
        0000000000008780008780000000000000000000000000000000000000000000
        0000000087800087800000000000000000008780000000C0C7C0C0C7C0C0C7C0
        C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087800000000000000000008780
        000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087
        800000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7
        C0C0C7C0C0C7C00000000087800000000000000000008780000000C0C7C0C0C7
        C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000000000878000000000000000
        00008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000
        00000000000000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0
        C7C0C0C7C0C0C7C0C0C7C0000000C0C7C0000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000}
      OnClick = SaveClick
    end
    object SpeedButton4: TSpeedButton
      Tag = 2
      Left = 680
      Top = 33
      Width = 23
      Height = 22
      Flat = True
      Glyph.Data = {
        9E020000424D9E0200000000000036000000280000000E0000000E0000000100
        18000000000068020000C40E0000C40E00000000000000000000BFBFBF000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000087800087800000000000000000000000000000000000
        00C0C7C0C0C7C000000000878000000000000000000087800087800000000000
        00000000000000000000000000C0C7C0C0C7C000000000878000000000000000
        00008780008780000000000000000000000000000000000000C0C7C0C0C7C000
        0000008780000000000000000000878000878000000000000000000000000000
        0000000000000000000000000000008780000000000000000000878000878000
        8780008780008780008780008780008780008780008780008780008780000000
        0000000000008780008780000000000000000000000000000000000000000000
        0000000087800087800000000000000000008780000000C0C7C0C0C7C0C0C7C0
        C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087800000000000000000008780
        000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087
        800000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7
        C0C0C7C0C0C7C00000000087800000000000000000008780000000C0C7C0C0C7
        C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000000000878000000000000000
        00008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000
        00000000000000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0
        C7C0C0C7C0C0C7C0C0C7C0000000C0C7C0000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000}
      OnClick = SaveClick
    end
    object SpeedButton5: TSpeedButton
      Tag = 3
      Left = 680
      Top = 55
      Width = 23
      Height = 22
      Flat = True
      Glyph.Data = {
        9E020000424D9E0200000000000036000000280000000E0000000E0000000100
        18000000000068020000C40E0000C40E00000000000000000000BFBFBF000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000087800087800000000000000000000000000000000000
        00C0C7C0C0C7C000000000878000000000000000000087800087800000000000
        00000000000000000000000000C0C7C0C0C7C000000000878000000000000000
        00008780008780000000000000000000000000000000000000C0C7C0C0C7C000
        0000008780000000000000000000878000878000000000000000000000000000
        0000000000000000000000000000008780000000000000000000878000878000
        8780008780008780008780008780008780008780008780008780008780000000
        0000000000008780008780000000000000000000000000000000000000000000
        0000000087800087800000000000000000008780000000C0C7C0C0C7C0C0C7C0
        C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087800000000000000000008780
        000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C00000000087
        800000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7
        C0C0C7C0C0C7C00000000087800000000000000000008780000000C0C7C0C0C7
        C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000000000878000000000000000
        00008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C0C0C7C000
        00000000000000000000000000008780000000C0C7C0C0C7C0C0C7C0C0C7C0C0
        C7C0C0C7C0C0C7C0C0C7C0000000C0C7C0000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000}
      OnClick = SaveClick
    end
    object Name: TEdit
      Left = 179
      Top = 34
      Width = 494
      Height = 21
      TabOrder = 1
    end
    object ShortName: TEdit
      Left = 179
      Top = 56
      Width = 494
      Height = 21
      TabOrder = 2
    end
    object Department: TComboBox
      Left = 179
      Top = 5
      Width = 492
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object Data: TDataSource
    Left = 730
    Top = 226
  end
end
