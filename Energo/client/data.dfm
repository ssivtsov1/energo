object Base: TBase
  OldCreateOrder = False
  Left = 284
  Top = 157
  Height = 480
  Width = 696
  object DataBase: TZPgSqlDatabase
    Host = '10.71.1.10'
    Port = '5432'
    Database = 'client'
    Encoding = etKoi8u
    Login = 'yoshi'
    LoginPrompt = False
    Connected = True
    Left = 32
    Top = 8
  end
  object Transact: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = DataBase
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 32
    Top = 56
  end
  object Query: TZPgSqlQuery
    Database = DataBase
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 32
    Top = 104
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 32
    Top = 152
  end
  object Query1: TZPgSqlQuery
    Database = DataBase
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 80
    Top = 104
  end
  object Query2: TZPgSqlQuery
    Database = DataBase
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 128
    Top = 104
  end
  object Query3: TZPgSqlQuery
    Database = DataBase
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 176
    Top = 104
  end
end
