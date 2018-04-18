object Kateg: TKateg
  Left = 226
  Top = 178
  Width = 696
  Height = 480
  Caption = 'Справочник категорий льгот'
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
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 225
    Top = 33
    Width = 3
    Height = 420
    Cursor = crHSplit
  end
  object Tree: TTreeView
    Left = 0
    Top = 33
    Width = 225
    Height = 420
    Align = alLeft
    Indent = 19
    TabOrder = 0
    OnChange = TreeChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 688
    Height = 33
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 128
      Top = 5
      Width = 113
      Height = 23
      Caption = 'Новая категория'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 8
      Top = 5
      Width = 113
      Height = 23
      Caption = 'Новый бюджет'
      Flat = True
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 248
      Top = 5
      Width = 113
      Height = 23
      Caption = 'Удалить'
      Flat = True
      OnClick = SpeedButton3Click
    end
  end
  object Panel2: TPanel
    Left = 228
    Top = 33
    Width = 460
    Height = 420
    Align = alClient
    TabOrder = 2
    object New_b: TPanel
      Left = 297
      Top = 273
      Width = 144
      Height = 128
      TabOrder = 0
      object Label2: TLabel
        Left = 8
        Top = 8
        Width = 192
        Height = 16
        Caption = 'Создание бюджетной группы'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label3: TLabel
        Left = 8
        Top = 40
        Width = 76
        Height = 13
        Caption = 'Наименование'
      end
      object SpeedButton5: TSpeedButton
        Left = 8
        Top = 64
        Width = 97
        Height = 22
        Caption = 'Сохранить'
        Flat = True
      end
      object Edit1: TEdit
        Left = 96
        Top = 32
        Width = 185
        Height = 21
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object New_k: TPanel
      Left = 16
      Top = 40
      Width = 425
      Height = 361
      TabOrder = 1
      object Label4: TLabel
        Left = 8
        Top = 8
        Width = 119
        Height = 16
        Caption = 'Свойства обьекта'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label5: TLabel
        Left = 43
        Top = 31
        Width = 76
        Height = 13
        Caption = 'Наименование'
      end
      object Label1: TLabel
        Left = 8
        Top = 59
        Width = 111
        Height = 13
        Caption = 'Процент возмещения'
      end
      object SpeedButton6: TSpeedButton
        Left = 16
        Top = 88
        Width = 105
        Height = 22
        Caption = 'Сохранить'
        Flat = True
        OnClick = SpeedButton6Click
      end
      object Label6: TLabel
        Left = 272
        Top = 32
        Width = 44
        Height = 13
        Caption = 'Порядок'
      end
      object Edit2: TEdit
        Left = 124
        Top = 27
        Width = 121
        Height = 21
        TabOrder = 0
      end
      object DBGrid1: TDBGrid
        Left = 1
        Top = 200
        Width = 423
        Height = 160
        Align = alBottom
        DataSource = Data_s
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'tarif'
            Width = 121
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'max'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'one'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'min'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'dt'
            Visible = True
          end>
      end
      object Edit3: TEdit
        Left = 124
        Top = 55
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object DBNavigator1: TDBNavigator
        Left = 8
        Top = 168
        Width = 120
        Height = 25
        DataSource = Data_s
        VisibleButtons = [nbInsert, nbDelete, nbPost]
        Flat = True
        TabOrder = 3
      end
      object Edit4: TEdit
        Left = 320
        Top = 25
        Width = 41
        Height = 21
        TabOrder = 4
      end
    end
  end
  object Data_s: TDataSource
    DataSet = Data
    Left = 404
    Top = 193
  end
  object Tarifs_s: TDataSource
    DataSet = Tarifs
    Left = 628
    Top = 129
  end
  object ZPgSqlDatabase1: TZPgSqlDatabase
    Host = '10.71.1.10'
    Port = '5432'
    Database = 'energo5'
    Encoding = etKoi8u
    Login = 'yura'
    LoginPrompt = False
    Connected = True
    Left = 476
    Top = 89
  end
  object ZPgSqlTransact1: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = ZPgSqlDatabase1
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 476
    Top = 137
  end
  object Tarifs: TZPgSqlTable
    Database = ZPgSqlDatabase1
    Transaction = ZPgSqlTransact1
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    TableName = 'aci_tarif_tbl'
    Active = True
    Left = 628
    Top = 81
  end
  object Data: TZPgSqlQuery
    Database = ZPgSqlDatabase1
    Transaction = ZPgSqlTransact1
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loLinkRequery, loAlwaysResync]
    Constraints = <>
    IndexFieldNames = 'id_k'
    AfterInsert = DataAfterInsert
    AfterPost = DataAfterPost
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select * from cld_kateg_tbl where id_k=4')
    RequestLive = True
    Active = True
    Left = 404
    Top = 145
    object Dataid_t: TIntegerField
      FieldName = 'id_t'
    end
    object Dataid_k: TIntegerField
      FieldName = 'id_k'
    end
    object Datadt: TDateField
      FieldName = 'dt'
    end
    object Datamin: TIntegerField
      FieldName = 'min'
    end
    object Dataone: TIntegerField
      FieldName = 'one'
    end
    object Datamax: TIntegerField
      FieldName = 'max'
    end
    object Datatarif: TStringField
      FieldKind = fkLookup
      FieldName = 'tarif'
      LookupDataSet = Tarifs
      LookupKeyFields = 'id'
      LookupResultField = 'name'
      KeyFields = 'id_t'
      Size = 30
      Lookup = True
    end
  end
end
