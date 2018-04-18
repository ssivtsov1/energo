object fFiderCheck: TfFiderCheck
  Left = 314
  Top = 213
  BorderStyle = bsDialog
  Caption = 'Выбор фидеров'
  ClientHeight = 475
  ClientWidth = 431
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 434
    Width = 431
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btOk: TBitBtn
      Left = 233
      Top = 8
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Формировать'
      TabOrder = 0
      OnClick = btOkClick
      Kind = bkAll
    end
    object btCancel: TBitBtn
      Left = 345
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 1
      OnClick = btCancelClick
      Kind = bkCancel
    end
    object BitBtn1: TBitBtn
      Left = 9
      Top = 8
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'За год'
      TabOrder = 2
      OnClick = BitBtn1Click
      Kind = bkAll
    end
    object btKey: TBitBtn
      Left = 121
      Top = 8
      Width = 107
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'По структуре'
      TabOrder = 3
      OnClick = btKeyClick
      Kind = bkAll
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 431
    Height = 65
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 167
      Height = 13
      Caption = 'Формировать по фидерам :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbAll: TCheckBox
      Left = 8
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Всем'
      TabOrder = 0
      OnClick = cbAllClick
    end
    object cbSelected: TCheckBox
      Left = 8
      Top = 40
      Width = 97
      Height = 17
      Caption = 'Выбранным'
      TabOrder = 1
      OnClick = cbSelectedClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 65
    Width = 431
    Height = 369
    Align = alClient
    TabOrder = 2
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 429
      Height = 367
      Align = alClient
      DataSource = dsSelect
      PopupMenu = PopupMenu1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = DBGrid1DrawColumnCell
      OnDblClick = DBGrid1DblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'selected'
          ReadOnly = True
          Title.Caption = 'Выбран'
          Width = 46
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'name_eqp'
          ReadOnly = True
          Title.Caption = 'Фидер'
          Width = 258
          Visible = True
        end>
    end
  end
  object ZQSelect: TZPgSqlQuery
    UpdateObject = ZUpdateSql1
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select s.* , f.name_eqp'
      'from bal_selfider_tmp  as s'
      'join eqm_equipment_tbl as f on (s.id_fider = f.id ) '
      'join eqm_fider_tbl as ff on (ff.code_eqp = f.id)'
      'where ff.id_voltage not in (4,42)'
      'order by name_eqp;'
      ' ')
    RequestLive = True
    Left = 215
    Top = 7
  end
  object dsSelect: TDataSource
    DataSet = ZQSelect
    Left = 216
    Top = 36
  end
  object ZUpdateSql1: TZUpdateSql
    ModifySql.Strings = (
      'update bal_selfider_tmp set selected = :selected '
      'where id_fider = :id_fider;')
    Left = 248
    Top = 8
  end
  object PopupMenu1: TPopupMenu
    Left = 168
    Top = 121
    object nAll: TMenuItem
      Caption = 'Выбрать все'
      OnClick = nAllClick
    end
    object nNo: TMenuItem
      Caption = 'Убрать все'
      OnClick = nNoClick
    end
  end
end
