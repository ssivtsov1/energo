object fPlombNew: TfPlombNew
  Left = 668
  Top = 170
  BorderStyle = bsDialog
  Caption = 'Новая пломба'
  ClientHeight = 351
  ClientWidth = 362
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label8: TLabel
    Left = 18
    Top = 232
    Width = 87
    Height = 13
    Caption = 'Срок требований'
  end
  object SpeedButton3: TSpeedButton
    Left = 118
    Top = 246
    Width = 23
    Height = 22
    Caption = 'Х'
  end
  object Panel1: TPanel
    Left = 0
    Top = 310
    Width = 362
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btOk: TBitBtn
      Left = 197
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 0
      OnClick = btOkClick
      Kind = bkOK
    end
    object btCancel: TBitBtn
      Left = 279
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 1
      OnClick = btCancelClick
      Kind = bkCancel
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 310
    Align = alClient
    TabOrder = 1
    object bEqpTypeSel: TSpeedButton
      Left = 326
      Top = 24
      Width = 23
      Height = 22
      Hint = 'Открыть справочник'
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555555555555555555555555555555555555555555555555555555555555
        555555555555555555555555555555555555555FFFFFFFFFF555550000000000
        55555577777777775F55500B8B8B8B8B05555775F555555575F550F0B8B8B8B8
        B05557F75F555555575F50BF0B8B8B8B8B0557F575FFFFFFFF7F50FBF0000000
        000557F557777777777550BFBFBFBFB0555557F555555557F55550FBFBFBFBF0
        555557F555555FF7555550BFBFBF00055555575F555577755555550BFBF05555
        55555575FFF75555555555700007555555555557777555555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = bEqpTypeSelClick
    end
    object Label1: TLabel
      Left = 18
      Top = 10
      Width = 60
      Height = 13
      Caption = 'Точка учета'
    end
    object Label2: TLabel
      Left = 18
      Top = 68
      Width = 62
      Height = 13
      Caption = 'Тип пломбы'
    end
    object Label3: TLabel
      Left = 18
      Top = 148
      Width = 81
      Height = 13
      Caption = 'Дата установки'
    end
    object Label4: TLabel
      Left = 114
      Top = 148
      Width = 55
      Height = 13
      Caption = 'Установил'
    end
    object Label5: TLabel
      Left = 18
      Top = 186
      Width = 119
      Height = 13
      Caption = 'Установившая сторона'
    end
    object sbDateClear: TSpeedButton
      Left = 88
      Top = 238
      Width = 23
      Height = 22
      Caption = 'Х'
      OnClick = sbDateClearClick
    end
    object Label10: TLabel
      Left = 18
      Top = 266
      Width = 63
      Height = 13
      Caption = 'Примечание'
    end
    object Label11: TLabel
      Left = 228
      Top = 70
      Width = 77
      Height = 13
      Caption = 'Номер пломбы'
    end
    object Label12: TLabel
      Left = 18
      Top = 110
      Width = 87
      Height = 13
      Caption = 'Место установки'
    end
    object Label13: TLabel
      Left = 18
      Top = 224
      Width = 64
      Height = 13
      Caption = 'Дата снятия'
    end
    object Label14: TLabel
      Left = 114
      Top = 224
      Width = 25
      Height = 13
      Caption = 'Снял'
    end
    object lcPoint: TRxLookupEdit
      Left = 18
      Top = 24
      Width = 305
      Height = 21
      LookupDisplay = 'name_eqp'
      LookupField = 'id'
      LookupSource = dsPoint
      DirectInput = False
      TabOrder = 0
      OnCloseUp = lcPointCloseUp
    end
    object lAddr: TStaticText
      Left = 18
      Top = 48
      Width = 331
      Height = 17
      AutoSize = False
      BorderStyle = sbsSunken
      TabOrder = 1
    end
    object lcType: TRxLookupEdit
      Left = 18
      Top = 84
      Width = 197
      Height = 21
      DropDownCount = 11
      LookupDisplay = 'name'
      LookupField = 'id'
      LookupSource = dsType
      TabOrder = 2
    end
    object edDateB: TMaskEdit
      Left = 18
      Top = 162
      Width = 83
      Height = 21
      EditMask = '90.90.0000'
      MaxLength = 10
      TabOrder = 5
      Text = '  .  .    '
      OnClick = edDateBClick
    end
    object lcPosition: TRxLookupEdit
      Left = 114
      Top = 162
      Width = 237
      Height = 21
      LookupDisplay = 'represent_name'
      LookupField = 'id'
      LookupSource = dsPosition
      TabOrder = 6
    end
    object edPlombOwner: TComboBox
      Left = 18
      Top = 200
      Width = 331
      Height = 21
      DropDownCount = 6
      ItemHeight = 13
      TabOrder = 7
      Items.Strings = (
        'РЕМ'
        'ЦЕК'
        'ЦСМ'
        'ПАТ Дніпрообленерго'
        'Завод-виробник лічильника'
        'Інша сторона')
    end
    object edComment: TEdit
      Left = 18
      Top = 280
      Width = 331
      Height = 21
      TabOrder = 10
    end
    object edNumber: TEdit
      Left = 228
      Top = 84
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object edLocation: TComboBox
      Left = 18
      Top = 124
      Width = 333
      Height = 21
      DropDownCount = 9
      ItemHeight = 13
      TabOrder = 4
      Items.Strings = (
        'клемна кришка лічильника'
        'кожух лічильника'
        'клемна кришка і кожух лічильника'
        'пристрій захисного відключення'
        'захисний пристрій трансформаторів струму'
        'трансформатори струму'
        'двері шафи обліку'
        'верхня панель шафи обліку'
        'бокова панель шафи обліку'
        'лівий гвинт затискної кришки лічильника'
        'правий гвинт затискної кришки лічильника')
    end
    object edDateE: TMaskEdit
      Left = 18
      Top = 238
      Width = 71
      Height = 21
      EditMask = '90.90.0000'
      MaxLength = 10
      TabOrder = 8
      Text = '  .  .    '
      OnClick = edDateEClick
    end
    object lcPosition_off: TRxLookupEdit
      Left = 114
      Top = 238
      Width = 237
      Height = 21
      LookupDisplay = 'represent_name'
      LookupField = 'id'
      LookupSource = dsPosition_off
      TabOrder = 9
    end
  end
  object ZQPoint: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select distinct p.id, (p.name_eqp||coalesce('#39' ('#39'||m.num_eqp||'#39')'#39 +
        ','#39#39'))::::varchar as name_eqp, adr.adr::::varchar'
      ' from eqm_tree_tbl as tr'
      'join eqm_eqp_tree_tbl as ttr on (tr.id = ttr.id_tree)'
      'join eqm_equipment_tbl as p on (ttr.code_eqp = p.id )'
      
        'join (select * from eqm_meter_point_h where coalesce(dt_e,now())' +
        ' >= now() order by id_point) as pm on (pm.id_point = p.id )'
      'join eqm_equipment_tbl as m on (m.id = pm.id_meter )'
      'left join adv_address_tbl as adr on (adr.id = p.id_addres )'
      
        'left join    ( select u1.code_eqp,u1.id_client  from eqm_eqp_use' +
        '_h as u1  where dt_e is null ) as use on (use.code_eqp = p.id)'
      
        ' where coalesce (use.id_client, tr.id_client) = :client and  p.t' +
        'ype_eqp = 12'
      ' order by name_eqp;'
      ' '
      ' ')
    RequestLive = True
    Left = 239
    Top = 5
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object dsPoint: TDataSource
    DataSet = ZQPoint
    Left = 270
    Top = 6
  end
  object ZQPosition: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select id,represent_name from clm_position_tbl where id_client =' +
        ' syi_resid_fun() order by represent_name;')
    RequestLive = True
    Left = 255
    Top = 149
  end
  object dsPosition: TDataSource
    DataSet = ZQPosition
    Left = 286
    Top = 150
  end
  object ZQType: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select * from cli_plomb_type_tbl order by ident')
    RequestLive = True
    Left = 125
    Top = 67
  end
  object dsType: TDataSource
    DataSet = ZQType
    Left = 156
    Top = 68
  end
  object ZQPosition_off: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select id,represent_name from clm_position_tbl where id_client =' +
        ' syi_resid_fun() order by represent_name;')
    RequestLive = True
    Left = 257
    Top = 223
  end
  object dsPosition_off: TDataSource
    DataSet = ZQPosition_off
    Left = 288
    Top = 224
  end
end
