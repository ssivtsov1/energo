object fRepInspect: TfRepInspect
  Left = 461
  Top = 429
  Width = 304
  Height = 102
  Caption = 'Печать конторльного обхода'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PrintScale = poNone
  Scaled = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 48
    Top = 24
    Width = 201
    Height = 25
    Caption = 'Вывести оборудование в Excel'
    TabOrder = 0
    OnClick = Button1Click
  end
  object xlReport: TxlReport
    DataSources = <>
    Preview = False
    Params = <>
    Top = 65528
  end
  object ZQXLReps: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 24
    Top = 65533
  end
  object DSRep: TDataSource
    Left = 54
    Top = 65531
  end
end
