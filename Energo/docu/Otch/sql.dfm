object Generator: TGenerator
  Left = 62
  Top = 89
  Width = 903
  Height = 568
  Caption = 'Визуальный построитель SQL-запросов'
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
    Left = 514
    Top = 237
    Width = 121
    Height = 22
    Caption = 'Добавить'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 266
    Top = 237
    Width = 121
    Height = 22
    Caption = 'Удалить'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 390
    Top = 237
    Width = 121
    Height = 22
    Caption = 'Изменить'
    Flat = True
    OnClick = SpeedButton3Click
  end
  object SpeedButton4: TSpeedButton
    Left = 382
    Top = 283
    Width = 137
    Height = 22
    Caption = 'Генерировать'
    Flat = True
    OnClick = SpeedButton4Click
  end
  object Label2: TLabel
    Left = 3
    Top = 296
    Width = 75
    Height = 13
    Caption = 'Текст запроса'
  end
  object Grid: TStringGrid
    Left = 0
    Top = 41
    Width = 895
    Height = 153
    Align = alTop
    ColCount = 10
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
    OnDblClick = GridDblClick
    ColWidths = (
      116
      60
      121
      69
      118
      51
      120
      49
      95
      64)
  end
  object ComboBox1: TComboBox
    Tag = 3
    Left = 492
    Top = 196
    Width = 54
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnChange = ComboBox1Change
    Items.Strings = (
      ''
      '='
      '>'
      '>='
      '<'
      '<='
      '<>')
  end
  object Edit5: TEdit
    Tag = 6
    Left = 809
    Top = 196
    Width = 64
    Height = 21
    TabOrder = 2
    OnChange = Ch
  end
  object CheckBox1: TCheckBox
    Left = 54
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 232
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object CheckBox3: TCheckBox
    Left = 510
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 5
    OnClick = CheckBox1Click
  end
  object CheckBox4: TCheckBox
    Left = 423
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object CheckBox5: TCheckBox
    Left = 594
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object CheckBox6: TCheckBox
    Left = 834
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 8
    OnClick = CheckBox1Click
  end
  object Memo1: TMemo
    Left = 0
    Top = 318
    Width = 895
    Height = 49
    Align = alBottom
    TabOrder = 9
  end
  object CheckBox7: TCheckBox
    Left = 758
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 10
    OnClick = CheckBox1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 895
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 11
    object Label1: TLabel
      Left = 290
      Top = 18
      Width = 145
      Height = 13
      Caption = 'Наименование базы данных'
    end
    object ComboDB: TComboBox
      Left = 439
      Top = 11
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboDBChange
    end
  end
  object ComboBox3: TComboBox
    Tag = 3
    Left = 120
    Top = 196
    Width = 58
    Height = 21
    ItemHeight = 13
    TabOrder = 12
    OnChange = ComboBox3Change
    Items.Strings = (
      ''
      'max'
      'min'
      'count')
  end
  object CheckBox8: TCheckBox
    Left = 139
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 13
    OnClick = CheckBox1Click
  end
  object Edit6: TEdit
    Tag = 8
    Left = 304
    Top = 196
    Width = 66
    Height = 21
    TabOrder = 14
    OnChange = Ch
  end
  object CheckBox9: TCheckBox
    Left = 330
    Top = 218
    Width = 14
    Height = 17
    TabOrder = 15
    OnClick = CheckBox1Click
  end
  object ComboBox4: TComboBox
    Tag = 3
    Left = 667
    Top = 196
    Width = 51
    Height = 21
    ItemHeight = 13
    TabOrder = 16
    OnChange = ComboBox4Change
    Items.Strings = (
      ''
      'max'
      'min'
      'count')
  end
  object CheckBox10: TCheckBox
    Left = 684
    Top = 218
    Width = 15
    Height = 17
    TabOrder = 17
    OnClick = CheckBox1Click
  end
  object ListTB: TComboBox
    Left = 0
    Top = 196
    Width = 120
    Height = 21
    ItemHeight = 13
    TabOrder = 18
    OnChange = ListTBChange
  end
  object ListF: TComboBox
    Left = 181
    Top = 196
    Width = 122
    Height = 21
    ItemHeight = 13
    TabOrder = 19
    OnChange = ListFChange
  end
  object ListF1: TComboBox
    Left = 371
    Top = 196
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 20
    OnChange = ListF1Change
  end
  object ListTM: TComboBox
    Left = 548
    Top = 196
    Width = 119
    Height = 21
    ItemHeight = 13
    TabOrder = 21
    OnChange = ListTMChange
  end
  object ListFM: TComboBox
    Left = 719
    Top = 196
    Width = 90
    Height = 21
    ItemHeight = 13
    TabOrder = 22
    OnChange = ListFMChange
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 392
    Width = 895
    Height = 149
    Align = alBottom
    TabOrder = 23
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object Panel2: TPanel
    Left = 0
    Top = 367
    Width = 895
    Height = 25
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 24
    object SpeedButton5: TSpeedButton
      Left = 78
      Top = 2
      Width = 136
      Height = 22
      Caption = 'Тест отчета'
      Flat = True
      OnClick = SpeedButton5Click
    end
    object Label3: TLabel
      Left = 5
      Top = 9
      Width = 29
      Height = 13
      Caption = 'Отчет'
    end
    object SpeedButton6: TSpeedButton
      Left = 678
      Top = 2
      Width = 129
      Height = 22
      Caption = 'Добавить на форму'
      Flat = True
      OnClick = SpeedButton6Click
    end
    object Label4: TLabel
      Left = 249
      Top = 6
      Width = 58
      Height = 13
      Caption = 'Имя отчета'
    end
    object Edit1: TEdit
      Left = 312
      Top = 3
      Width = 361
      Height = 21
      TabOrder = 0
    end
  end
  object DB: TZPgSqlDatabase
    Port = '5432'
    Encoding = etKoi8u
    LoginPrompt = False
    Connected = False
    Left = 832
    Top = 248
  end
  object T: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = DB
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 832
    Top = 288
  end
  object Query: TZPgSqlQuery
    Database = DB
    Transaction = T
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 832
    Top = 328
  end
  object Query1: TZPgSqlQuery
    Database = DB2Connect
    Transaction = T1
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 72
    Top = 320
  end
  object DB2Connect: TZPgSqlDatabase
    Port = '5432'
    Encoding = etKoi8u
    LoginPrompt = False
    Connected = False
    Left = 8
    Top = 320
  end
  object T1: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = DB2Connect
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 40
    Top = 320
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 104
    Top = 320
  end
end
