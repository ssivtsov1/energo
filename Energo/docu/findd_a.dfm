object FindAdv: TFindAdv
  Left = 277
  Top = 142
  Width = 487
  Height = 526
  Caption = 'Расширенный поиск'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 109
    Top = 2
    Width = 129
    Height = 20
    GroupIndex = 1
    Down = True
    Caption = 'Шаблоны'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 242
    Top = 2
    Width = 129
    Height = 20
    GroupIndex = 1
    Caption = 'Документы'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 26
    Width = 385
    Height = 145
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Имя и Рег. номер'
      object Label2: TLabel
        Left = 8
        Top = 39
        Width = 50
        Height = 13
        Caption = 'Название'
      end
      object TextFind: TEdit
        Left = 88
        Top = 32
        Width = 265
        Height = 21
        TabOrder = 0
      end
      object CheckBox1: TCheckBox
        Left = 41
        Top = 8
        Width = 121
        Height = 17
        Caption = 'По наименованию'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBox1Click
      end
      object CheckBox2: TCheckBox
        Left = 188
        Top = 8
        Width = 189
        Height = 17
        Caption = 'По регистрационному номеру'
        TabOrder = 2
        OnClick = CheckBox2Click
      end
      object CheckBox3: TCheckBox
        Left = 88
        Top = 56
        Width = 57
        Height = 17
        Caption = 'Точно'
        TabOrder = 3
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Дата'
      ImageIndex = 1
      object Label3: TLabel
        Left = 16
        Top = 0
        Width = 152
        Height = 13
        Caption = 'Наити документы созданные '
      end
      object Label4: TLabel
        Left = 164
        Top = 45
        Width = 6
        Height = 13
        Caption = 'и'
      end
      object Label5: TLabel
        Left = 188
        Top = 71
        Width = 44
        Height = 13
        Caption = 'месяцев'
      end
      object Label6: TLabel
        Left = 189
        Top = 96
        Width = 24
        Height = 13
        Caption = 'дней'
      end
      object RadioButton1: TRadioButton
        Left = 16
        Top = 45
        Width = 65
        Height = 16
        Caption = 'между'
        TabOrder = 1
        OnClick = RadioButton1Click
      end
      object DateTimePicker1: TDateTimePicker
        Left = 76
        Top = 40
        Width = 81
        Height = 20
        CalAlignment = dtaLeft
        Date = 37574.6735034722
        Time = 37574.6735034722
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 0
      end
      object DateTimePicker2: TDateTimePicker
        Left = 180
        Top = 40
        Width = 81
        Height = 20
        CalAlignment = dtaLeft
        Date = 37574.6735034722
        Time = 37574.6735034722
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 2
      end
      object RadioButton2: TRadioButton
        Left = 16
        Top = 71
        Width = 89
        Height = 16
        Caption = 'за последние'
        TabOrder = 3
        OnClick = RadioButton2Click
      end
      object RadioButton4: TRadioButton
        Left = 16
        Top = 96
        Width = 89
        Height = 16
        Caption = 'за последние'
        TabOrder = 4
        OnClick = RadioButton4Click
      end
      object Edit1: TEdit
        Left = 120
        Top = 69
        Width = 49
        Height = 21
        TabOrder = 5
        Text = '0'
      end
      object UpDown1: TUpDown
        Left = 169
        Top = 69
        Width = 12
        Height = 21
        Associate = Edit1
        Min = 0
        Position = 0
        TabOrder = 6
        Wrap = False
      end
      object Edit2: TEdit
        Left = 120
        Top = 93
        Width = 49
        Height = 21
        TabOrder = 7
        Text = '0'
      end
      object UpDown2: TUpDown
        Left = 169
        Top = 93
        Width = 12
        Height = 21
        Associate = Edit2
        Min = 0
        Position = 0
        TabOrder = 8
        Wrap = False
      end
      object RadioButton3: TRadioButton
        Left = 16
        Top = 20
        Width = 57
        Height = 14
        Caption = 'дата'
        Checked = True
        TabOrder = 9
        TabStop = True
        OnClick = RadioButton3Click
      end
      object DateTimePicker3: TDateTimePicker
        Left = 76
        Top = 16
        Width = 80
        Height = 20
        CalAlignment = dtaLeft
        Date = 37574.6735034722
        Time = 37574.6735034722
        DateFormat = dfShort
        DateMode = dmComboBox
        Kind = dtkDate
        ParseInput = False
        TabOrder = 10
      end
    end
  end
  object AddBut: TButton
    Left = 400
    Top = 113
    Width = 75
    Height = 25
    Caption = 'Добавить'
    TabOrder = 1
    OnClick = AddButClick
  end
  object StringGrid1: TStringGrid
    Left = 8
    Top = 177
    Width = 465
    Height = 120
    BorderStyle = bsNone
    Color = clScrollBar
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    ScrollBars = ssVertical
    TabOrder = 2
    ColWidths = (
      193
      205
      64
      107
      360)
  end
  object DelBut: TButton
    Left = 400
    Top = 145
    Width = 75
    Height = 25
    Caption = 'Удалить'
    TabOrder = 3
    OnClick = DelButClick
  end
  object FindBut: TButton
    Left = 246
    Top = 469
    Width = 75
    Height = 25
    Caption = 'Искать'
    TabOrder = 4
    OnClick = FindButClick
  end
  object CloseBut: TButton
    Left = 166
    Top = 469
    Width = 75
    Height = 25
    Caption = 'Закрыть'
    TabOrder = 5
    OnClick = CloseButClick
  end
  object FindResult: TListView
    Left = 2
    Top = 308
    Width = 475
    Height = 156
    Columns = <>
    FlatScrollBars = True
    ShowWorkAreas = True
    SmallImages = Module2DB.Images4doc_s
    TabOrder = 6
    ViewStyle = vsReport
    OnChanging = FindResultChanging
    OnDblClick = FindResultDblClick
  end
end
