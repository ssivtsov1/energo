object Form1: TForm1
  Left = 192
  Top = 107
  Width = 696
  Height = 480
  Caption = 'Выбор данных для отчета'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 161
    Top = 0
    Width = 3
    Height = 453
    Cursor = crHSplit
  end
  object Splitter2: TSplitter
    Left = 237
    Top = 0
    Width = 3
    Height = 453
    Cursor = crHSplit
  end
  object ListDB: TListBox
    Left = 0
    Top = 0
    Width = 161
    Height = 453
    Hint = 'Базы Данных'
    Align = alLeft
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = ListDBClick
  end
  object ListTB: TListBox
    Left = 164
    Top = 0
    Width = 73
    Height = 453
    Hint = 'Список таблиц'
    Align = alLeft
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ListTBClick
  end
  object ListF: TListBox
    Left = 240
    Top = 0
    Width = 448
    Height = 453
    Align = alClient
    ItemHeight = 13
    TabOrder = 2
  end
  object DB: TZPgSqlDatabase
    Host = '10.71.1.10'
    Port = '5432'
    Database = 'yoshi'
    Encoding = etNone
    Login = 'yoshi'
    LoginPrompt = False
    Connected = True
    Left = 608
    Top = 8
  end
  object Transact: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = DB
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 608
    Top = 40
  end
  object Query: TZPgSqlQuery
    Database = DB
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 608
    Top = 72
  end
  object DB2Connect: TZPgSqlDatabase
    Host = '10.71.1.10'
    Port = '5432'
    Encoding = etKoi8u
    Login = 'yoshi'
    LoginPrompt = False
    Connected = False
    Left = 568
    Top = 8
  end
  object T: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = DB2Connect
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 568
    Top = 40
  end
  object Query1: TZPgSqlQuery
    Database = DB2Connect
    Transaction = T
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 568
    Top = 72
  end
  object Query2: TZPgSqlQuery
    Database = DB2Connect
    Transaction = T
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 536
    Top = 72
  end
end
