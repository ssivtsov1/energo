object Make_sql: TMake_sql
  Left = 162
  Top = 109
  Width = 698
  Height = 614
  Caption = 'Make_sql'
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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 257
    Top = 0
    Width = 3
    Height = 587
    Cursor = crHSplit
  end
  object SpeedButton1: TSpeedButton
    Left = 96
    Top = 120
    Width = 89
    Height = 22
  end
  object Tree: TTreeView
    Left = 0
    Top = 0
    Width = 257
    Height = 587
    Align = alLeft
    Indent = 19
    TabOrder = 0
    OnChanging = TreeChanging
  end
  object Panel1: TPanel
    Left = 260
    Top = 0
    Width = 430
    Height = 587
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 428
      Height = 29
      Align = alTop
      TabOrder = 0
      object SpeedButton2: TSpeedButton
        Left = 236
        Top = 4
        Width = 113
        Height = 22
        Caption = 'Искать'
        Flat = True
        OnClick = SpeedButton2Click
      end
      object SpeedButton7: TSpeedButton
        Left = 364
        Top = 4
        Width = 53
        Height = 22
        Caption = 'SQL'
        Flat = True
        OnClick = SpeedButton7Click
      end
      object SpeedButton10: TSpeedButton
        Left = 12
        Top = 4
        Width = 84
        Height = 22
        Hint = 'Схема данных'
        Flat = True
        Glyph.Data = {
          26040000424D2604000000000000360000002800000012000000120000000100
          180000000000F0030000C40E0000C40E00000000000000000000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0000000000000000000000000000000000000C0C0C0C0C0C0
          0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          000000FFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0C0C0C00000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFFC0C0
          C0C0C0C0FFFFFF000000C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000FFFFFFFFFFFFFFFFFFFFFFFF00
          0000C0C0C0C0C0C00000C0C0C000000000000000000000000000000000000080
          8080000000000000800000800000800000800000800000800000C0C0C0C0C0C0
          0000C0C0C0000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000808080C0C0C0
          800000800000800000800000800000800000C0C0C0C0C0C00000C0C0C0000000
          FFFFFFC0C0C0C0C0C0FFFFFF000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0000000FFFFFFFFFFFFFFFF
          FFFFFFFF000000808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C00000C0C0C080000080000080000080000080000080000000
          0000000000808080C0C0C0000000000000000000000000000000000000C0C0C0
          0000C0C0C0800000800000800000800000800000800000C0C0C0808080000000
          000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C00000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080000000FFFF
          FFC0C0C0C0C0C0FFFFFF000000C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFFFFFFFFFFFFFFFF
          FFFF000000C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0800000800000800000800000800000800000C0C0C0
          0000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0800000800000800000800000800000800000C0C0C00000C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
          C0C0C0C0C0C0C0C00000}
        ParentShowHint = False
        ShowHint = True
        OnClick = SpeedButton10Click
      end
      object Find: TEdit
        Left = 108
        Top = 4
        Width = 121
        Height = 21
        TabOrder = 0
        OnChange = FindChange
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 30
      Width = 428
      Height = 556
      Align = alClient
      BevelInner = bvLowered
      TabOrder = 1
      object SpeedButton3: TSpeedButton
        Left = 201
        Top = 213
        Width = 23
        Height = 22
        Caption = '>'
        OnClick = SpeedButton3Click
      end
      object SpeedButton5: TSpeedButton
        Left = 201
        Top = 301
        Width = 23
        Height = 22
        Caption = '<'
        OnClick = SpeedButton5Click
      end
      object SpeedButton8: TSpeedButton
        Left = 5
        Top = 56
        Width = 23
        Height = 20
        Caption = '>'
        OnClick = SpeedButton8Click
      end
      object SpeedButton9: TSpeedButton
        Left = 5
        Top = 86
        Width = 23
        Height = 22
        Caption = '<<'
        OnClick = SpeedButton9Click
      end
      object Bevel1: TBevel
        Left = 170
        Top = 395
        Width = 238
        Height = 52
      end
      object Label1: TLabel
        Left = 157
        Top = 3
        Width = 105
        Height = 13
        Caption = 'Выбранные таблицы'
      end
      object Label2: TLabel
        Left = 76
        Top = 137
        Width = 70
        Height = 13
        Caption = 'Список полей'
      end
      object Label3: TLabel
        Left = 282
        Top = 137
        Width = 86
        Height = 13
        Caption = 'Выбранные поля'
      end
      object Label4: TLabel
        Left = 83
        Top = 406
        Width = 82
        Height = 13
        Caption = 'Условия отбора'
      end
      object Label5: TLabel
        Left = 55
        Top = 422
        Width = 111
        Height = 13
        Caption = 'для выбранных полей'
      end
      object SpeedButton4: TSpeedButton
        Left = 248
        Top = 520
        Width = 89
        Height = 22
        Caption = 'Добавить'
        Flat = True
        OnClick = SpeedButton4Click
      end
      object Label6: TLabel
        Left = 32
        Top = 528
        Width = 76
        Height = 13
        Caption = 'Наименование'
      end
      object ListFields: TListBox
        Left = 32
        Top = 152
        Width = 161
        Height = 236
        ItemHeight = 13
        TabOrder = 0
        OnClick = ListFieldsClick
      end
      object ListSel: TCheckListBox
        Left = 233
        Top = 152
        Width = 176
        Height = 236
        ItemHeight = 13
        TabOrder = 1
        OnClick = ListSelClick
      end
      object MiniTree: TTreeView
        Left = 32
        Top = 19
        Width = 377
        Height = 117
        Indent = 19
        TabOrder = 2
        OnChanging = MiniTreeChanging
      end
      object Memo1: TMemo
        Left = 32
        Top = 451
        Width = 377
        Height = 57
        Lines.Strings = (
          'SQL')
        TabOrder = 3
      end
      object Where: TEdit
        Left = 176
        Top = 400
        Width = 177
        Height = 21
        TabOrder = 4
      end
      object CheckBox1: TCheckBox
        Left = 176
        Top = 424
        Width = 105
        Height = 17
        Caption = 'Ключевое поле'
        TabOrder = 5
      end
      object Button1: TButton
        Left = 360
        Top = 400
        Width = 41
        Height = 41
        Caption = 'Ок'
        TabOrder = 6
        OnClick = Button1Click
      end
      object Edit1: TEdit
        Left = 120
        Top = 520
        Width = 121
        Height = 21
        TabOrder = 7
      end
    end
  end
  object Database: TZPgSqlDatabase
    Host = '10.71.1.10'
    Port = '5432'
    Database = 'energo'
    Encoding = etKoi8u
    Login = 'yoshi'
    LoginPrompt = False
    Connected = True
    Left = 632
    Top = 328
  end
  object Transact: TZPgSqlTransact
    Options = [toHourGlass]
    AutoCommit = True
    Database = Database
    AutoRecovery = True
    TransactSafe = True
    TransIsolation = ptDefault
    Left = 632
    Top = 368
  end
  object Query: TZPgSqlQuery
    Database = Database
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'SELECT pg_class_1.relname AS relname_master, pg_class.relname AS' +
        ' relname_child, pg_proc.proname, pg_trigger.tgargs'
      
        'FROM ((pg_trigger INNER JOIN pg_proc ON pg_trigger.tgfoid = pg_p' +
        'roc.oid) INNER JOIN pg_class ON pg_trigger.tgconstrrelid = pg_cl' +
        'ass.oid) INNER JOIN pg_class AS pg_class_1 ON pg_trigger.tgrelid' +
        ' = pg_class_1.oid'
      
        'WHERE pg_proc.proname LIKE '#39'%check%'#39' ORDER BY pg_class_1.relname' +
        ', pg_class.relname')
    RequestLive = False
    Active = True
    Left = 632
    Top = 408
  end
  object Query1: TZPgSqlQuery
    Database = Database
    Transaction = Transact
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 589
    Top = 410
  end
end
