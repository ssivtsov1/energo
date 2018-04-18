object fPointCard: TfPointCard
  Left = 404
  Top = 275
  BorderStyle = bsDialog
  Caption = 'Паспорт точки учета'
  ClientHeight = 572
  ClientWidth = 800
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
    Top = 531
    Width = 800
    Height = 41
    Align = alBottom
    TabOrder = 0
    object Label3: TLabel
      Left = 208
      Top = 10
      Width = 141
      Height = 13
      Caption = 'Дата последних изменений'
    end
    object lLastDate: TLabel
      Left = 360
      Top = 10
      Width = 55
      Height = 13
      Caption = 'lLastDate'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btOk: TBitBtn
      Left = 602
      Top = 8
      Width = 107
      Height = 27
      Anchors = [akRight, akBottom]
      Caption = 'Печать'
      ModalResult = 8
      TabOrder = 0
      OnClick = btOkClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        04000000000080000000CE0E0000D80E00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800000000000
        00080888888888888880088888888888888000000000000000000F8F8F8F8F8F
        8F8008F8F8F8F8F8F9F00F8F8F8F8F8F8F8000000000000000008880FFFFFFFF
        08888880F0000F0F08888880FFFFFFFF08888880F00F000008888880FFFF0FF0
        88888880F08F0F0888888880FFFF008888888880000008888888}
    end
    object btCancel: TBitBtn
      Left = 714
      Top = 8
      Width = 75
      Height = 27
      Anchors = [akRight, akBottom]
      Caption = 'Закрыть'
      TabOrder = 1
      OnClick = btCancelClick
      Kind = bkCancel
    end
    object DateTimePicker: TDateTimePicker
      Left = 8
      Top = 8
      Width = 186
      Height = 21
      CalAlignment = dtaLeft
      Date = 37791
      Time = 37791
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 2
      OnCloseUp = DateTimePickerChange
      OnKeyPress = DateTimePickerKeyPress
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 49
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 71
      Height = 14
      Caption = 'Точка учета :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 304
      Top = 8
      Width = 62
      Height = 14
      Caption = 'Площадка :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lPointName: TLabel
      Left = 88
      Top = 8
      Width = 65
      Height = 13
      Caption = 'lPointName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lAreaName: TLabel
      Left = 376
      Top = 8
      Width = 62
      Height = 13
      Caption = 'lAreaName'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lAddressc: TLabel
      Left = 8
      Top = 24
      Width = 47
      Height = 14
      Caption = 'Адресс :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lAddress: TLabel
      Left = 88
      Top = 24
      Width = 40
      Height = 13
      Caption = 'lAddress'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 49
    Width = 800
    Height = 144
    Align = alTop
    TabOrder = 2
    object Panel6: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 30
      Align = alTop
      BevelInner = bvLowered
      Caption = 'Работы'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object sbWorkList: TSpeedButton
        Left = 32
        Top = 4
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777000000000007777700333333333077770B033333333307770FB033333333
          30770BFB0333333333070FBFB000000000000BFBFBFBFB0777770FBFBFBFBF07
          77770BFB00000007777770007777777700077777777777777007777777770777
          0707777777777000777777777777777777777777777777777777}
        OnClick = sbWorkListClick
      end
      object sbRefresh: TSpeedButton
        Left = 8
        Top = 4
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00778000000000
          00077787777777777707778FFFFF2FFFF707778FFFF22FFFF707778FFF22222F
          F707778FFFF22FF2F707778FFFFF2FF2F707778FF2FFFFF2F707778FF2FF2FFF
          F707778FF2FF22FFF707778FFF22222FF707778FFFFF22FFF707778FFFFF2FF0
          0007778FFFFFFFF8F077778FFFFFFFF807777788888888887777}
        OnClick = sbRefreshClick
      end
    end
    object dgWorks: TDBGrid
      Left = 1
      Top = 31
      Width = 798
      Height = 112
      Align = alClient
      DataSource = dsWorks
      DragCursor = crDefault
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = dgWorksDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'name'
          Title.Caption = 'Вид работы'
          Width = 147
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dt_work'
          Title.Caption = 'Дата работы'
          Width = 79
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'represent_name'
          Title.Caption = 'Исполнитель'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'requirement_text'
          Title.Caption = 'Требование'
          Width = 138
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'requirement_date'
          Title.Caption = 'Срок вып. требования'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'next_work_date'
          Title.Caption = 'Дата след. работы'
          Width = 103
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'comment'
          Title.Caption = 'Прим.'
          Width = 100
          Visible = True
        end>
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 193
    Width = 800
    Height = 200
    Align = alTop
    TabOrder = 3
    object DBGrid3: TDBGrid
      Left = 1
      Top = 112
      Width = 798
      Height = 87
      Align = alBottom
      DataSource = dsCompI
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'conv_name'
          Title.Caption = 'Вид'
          Width = 134
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'type'
          Title.Caption = 'Тип'
          Width = 121
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ktr'
          Title.Caption = 'Коеф. тр.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'num_eqp'
          Title.Caption = 'Заводской №'
          Width = 78
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'accuracy'
          Title.Caption = 'Класс точности'
          Width = 93
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'date_check'
          Title.Caption = 'Дата поверки'
          Width = 77
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'num_meter'
          Title.Caption = '№ счетчика'
          Width = 154
          Visible = True
        end>
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 798
      Height = 111
      Align = alClient
      DataSource = dsMeters
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'type'
          Title.Caption = 'Тип счетчика'
          Width = 109
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'energy'
          Title.Caption = 'Вид енергии'
          Width = 87
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'zone'
          Title.Caption = 'Зона'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'class'
          Title.Caption = 'Класс точности'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'num_eqp'
          Title.Caption = 'Номер '
          Width = 85
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dt_control'
          Title.Caption = 'Дата поверки'
          Width = 95
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'value'
          Title.Caption = 'Показания'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dat_ind'
          Title.Caption = 'Дата показаний'
          Width = 88
          Visible = True
        end>
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 393
    Width = 800
    Height = 138
    Align = alClient
    TabOrder = 4
    object DBGrid5: TDBGrid
      Left = 1
      Top = 31
      Width = 798
      Height = 106
      Align = alClient
      DataSource = dsPlombs
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDblClick = sbPlombsListClick
      Columns = <
        item
          Expanded = False
          FieldName = 'object_name'
          Title.Caption = 'Место установки'
          Width = 109
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'type'
          Title.Caption = 'Тип пломбы'
          Width = 93
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'plomb_num'
          Title.Caption = 'Номер пломбы'
          Width = 86
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'dt_b'
          Title.Caption = 'Дата установки'
          Width = 88
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'represent_name'
          Title.Caption = 'Установил'
          Width = 103
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'plomb_owner'
          Title.Caption = 'Установившая сторона'
          Width = 133
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'comment'
          Title.Caption = 'Прим.'
          Width = 152
          Visible = True
        end>
    end
    object Panel7: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 30
      Align = alTop
      BevelInner = bvLowered
      Caption = 'Пломбы'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object sbPlombsRefresh: TSpeedButton
        Left = 8
        Top = 4
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00778000000000
          00077787777777777707778FFFFF2FFFF707778FFFF22FFFF707778FFF22222F
          F707778FFFF22FF2F707778FFFFF2FF2F707778FF2FFFFF2F707778FF2FF2FFF
          F707778FF2FF22FFF707778FFF22222FF707778FFFFF22FFF707778FFFFF2FF0
          0007778FFFFFFFF8F077778FFFFFFFF807777788888888887777}
        OnClick = sbPlombsRefreshClick
      end
      object sbPlombsList: TSpeedButton
        Left = 32
        Top = 4
        Width = 23
        Height = 22
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777000000000007777700333333333077770B033333333307770FB033333333
          30770BFB0333333333070FBFB000000000000BFBFBFBFB0777770FBFBFBFBF07
          77770BFB00000007777770007777777700077777777777777007777777770777
          0707777777777000777777777777777777777777777777777777}
        OnClick = sbPlombsListClick
      end
    end
  end
  object ZQMeters: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select mp.id_meter, eqm.num_eqp, im.type, e.name as energy, z.na' +
        'me as zone, pr.class::::varchar, m.dt_control,ind.value,dat_ind,'
      
        'date_larger(date_larger(date_larger(eqm.dt_b,m.dt_b),me.dt_b), m' +
        'z.dt_b) as dt_last'
      'from eqm_meter_point_h as mp'
      'join eqm_equipment_h as eqm on (eqm.id =mp.id_meter)'
      'join eqm_meter_h as m on (m.code_eqp=mp.id_meter )'
      'join eqi_meter_tbl as im on (im.id = m.id_type_eqp)'
      'join eqd_meter_energy_h as me on (me.code_eqp = mp.id_meter)'
      'join eqd_meter_zone_h as mz on (mz.code_eqp = mp.id_meter)'
      'join eqk_energy_tbl as e on (e.id = me.kind_energy)'
      'join eqk_zone_tbl as z on (z.id = mz.zone)'
      
        'left join (select id_type_eqp , max(cl) as class from eqi_meter_' +
        'prec_tbl group by id_type_eqp) as pr on (pr.id_type_eqp = im.id)'
      'left join'
      '( select i.* from acd_indication_tbl as i join'
      
        '  (select id_client,id_meter,num_eqp,kind_energy,id_zone,max(dat' +
        '_ind) as dat_ind from acd_indication_tbl where dat_ind<= :dt and' +
        ' id_client = :client'
      
        '   and value is not null group by id_client,id_meter,num_eqp,kin' +
        'd_energy,id_zone order by id_meter) as i2'
      
        '   on (i.id_client = i2.id_client and i.id_meter=i2.id_meter and' +
        ' i.num_eqp=i2.num_eqp and i.kind_energy=i2.kind_energy and i.id_' +
        'zone=i2.id_zone and i.dat_ind = i2.dat_ind)'
      'order by id_meter'
      ')'
      'as ind on (mp.id_meter=ind.id_meter and eqm.num_eqp=ind.num_eqp'
      
        '                                         and me.kind_energy=ind.' +
        'kind_energy and mz.zone=ind.id_zone)'
      ''
      'where eqm.dt_b <= :dt and coalesce(eqm.dt_e,:dt) >=:dt'
      'and m.dt_b <= :dt and coalesce(m.dt_e,:dt) >=:dt'
      'and me.dt_b <= :dt and coalesce(me.dt_e,:dt) >=:dt'
      'and mz.dt_b <= :dt and coalesce(mz.dt_e,:dt) >=:dt'
      'and mp.dt_b <= :dt and coalesce(mp.dt_e,:dt) >=:dt'
      'and mp.id_point = :point'
      '')
    RequestLive = False
    Left = 544
    Top = 520
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsMeters: TDataSource
    DataSet = ZQMeters
    Left = 512
    Top = 520
  end
  object dsCompI: TDataSource
    DataSet = ZQCompI
    Left = 448
    Top = 520
  end
  object ZQCompI: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select ss.id, ss.num_eqp, ss.type,conversion, ss.type, ss.accura' +
        'cy, ss.date_check,ss.ktr, ss.conv_name, sum(eq.num_eqp||'#39','#39')::::' +
        'varchar as num_meter, max(ss.dt_last) as dt_last '
      ' from ('
      
        'select  eqm.id, eqm.num_eqp, CASE WHEN eq2.type_eqp = 1 THEN eq2' +
        '.id WHEN eq3.type_eqp = 1 THEN eq3.id END as id_meter,'
      ' ic.conversion , ic.type,ic.accuracy,c.date_check,'
      
        ' CASE WHEN conversion =1 then amperage_nom/amperage2_nom WHEN co' +
        'nversion =2 then voltage_nom/voltage2_nom END::::int as ktr,'
      
        ' CASE WHEN conversion =1 THEN '#39'Трансформатор струму'#39' WHEN conver' +
        'sion =2 then '#39'Трансформатор напруги'#39' END::::varchar as conv_name' +
        ','
      ' date_larger(eqm.dt_b,c.dt_b) as dt_last'
      ' from'
      
        ' ( select * from eqm_equipment_h where type_eqp = 10 and dt_b <=' +
        ' :dt and coalesce(dt_e,:dt) >=:dt) as eqm'
      
        '  join eqm_compensator_i_h as c on (c.code_eqp = eqm.id and c.dt' +
        '_b <= :dt and coalesce(c.dt_e,:dt) >=:dt)'
      '  join eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp)'
      
        '  left join eqm_eqp_tree_h as tt on (tt.code_eqp_e=eqm.id and tt' +
        '.dt_b <= :dt and coalesce(tt.dt_e,:dt) >=:dt)'
      
        '  left join eqm_eqp_tree_h as tt2 on (tt2.code_eqp_e=tt.code_eqp' +
        ' and tt2.dt_b <= :dt and coalesce(tt2.dt_e,:dt) >=:dt)'
      
        '  left join eqm_equipment_h as eq2 on (eq2.id =tt.code_eqp and e' +
        'q2.dt_b <= :dt and coalesce(eq2.dt_e,:dt) >=:dt )'
      
        '  left join eqm_equipment_h as eq3 on (eq3.id =tt2.code_eqp and ' +
        'eq3.dt_b <= :dt and coalesce(eq3.dt_e,:dt) >=:dt )'
      '  order by conversion'
      ') as ss'
      
        'left join eqm_meter_point_h as mp on (mp.id_meter = ss.id_meter ' +
        'and mp.dt_b <= :dt and coalesce(mp.dt_e,:dt) >=:dt )'
      
        'left join eqm_equipment_h as eq on (eq.id =mp.id_meter and eq.dt' +
        '_b <= :dt and coalesce(eq.dt_e,:dt) >=:dt)'
      'where'
      ' mp.id_point = :point'
      
        'group by ss.id, ss.num_eqp, ss.type,conversion, ss.type, ss.accu' +
        'racy, ss.date_check,ss.ktr, ss.conv_name'
      ' '
      ' ')
    RequestLive = False
    Left = 480
    Top = 520
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object ZQPoint: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select eqm.name_eqp, eqa.name_eqp as name_area, adr.adr,'
      ' date_larger(eqm.dt_b,p.dt_b) as dt_last'
      'from'
      'eqm_equipment_h as eqm'
      
        'join eqm_point_h as p on (eqm.id = p.code_eqp and p.dt_b <= :dt ' +
        'and coalesce(p.dt_e,:dt) >=:dt )'
      
        'left join eqm_compens_station_inst_h as a on (eqm.id = a.code_eq' +
        'p and a.dt_b <= :dt and coalesce(a.dt_e,:dt) >=:dt )'
      
        'left join eqm_equipment_h as eqa on (eqa.id = a.code_eqp_inst an' +
        'd eqa.dt_b <= :dt and coalesce(eqa.dt_e,:dt) >=:dt and eqa.type_' +
        'eqp = 11 )'
      
        'left join adv_address_tbl as adr on (adr.id = CASE WHEN coalesce' +
        '(eqm.id_addres,0) <> 0 THEN  eqm.id_addres ELSE eqa.id_addres EN' +
        'D )'
      'where eqm.dt_b <= :dt and coalesce(eqm.dt_e,:dt) >=:dt'
      'and eqm.id = :point'
      ''
      ''
      ' ')
    RequestLive = False
    Left = 408
    Top = 520
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsWorks: TDataSource
    DataSet = ZQWorks
    Left = 328
    Top = 520
  end
  object ZQWorks: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select wi.name, wi.id as id_w, w.* ,p.represent_name'
      'from clm_works_tbl as w'
      
        'join (select id_client, id_point, id_type, max(dt_work) as dt_wo' +
        'rk from clm_works_tbl where dt_work <= :dt and id_point= :point'
      ' group by id_client, id_point, id_type) as w2'
      
        'on (w.id_client = w2.id_client and w.id_point = w2.id_point and ' +
        'w.id_type = w2.id_type and w.dt_work  = w2.dt_work )'
      'left join clm_position_tbl as p on (p.id = w.id_position)'
      'right join cli_works_tbl as wi'
      'on (wi.id = w.id_type)'
      'order by wi.ident'
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 360
    Top = 520
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsPlombs: TDataSource
    DataSet = ZQPlombs
    Left = 264
    Top = 520
  end
  object ZQPlombs: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select t.name as type, p.* ,cp.represent_name'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'left join clm_position_tbl as cp on (cp.id = p.id_position)'
      
        'where p.id_point = :point and p.dt_b <= :dt and coalesce(p.dt_e,' +
        ' :dt ) >=:dt'
      'order by p.object_name,p.plomb_num'
      ' '
      ' ')
    RequestLive = False
    Left = 296
    Top = 520
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dt'
        ParamType = ptUnknown
      end>
  end
  object xlReport: TxlReport
    Options = [xroDisplayAlerts, xroAutoSave, xroUseTemp]
    DataSources = <>
    Preview = False
    Params = <>
    Left = 760
    Top = 12
  end
end
