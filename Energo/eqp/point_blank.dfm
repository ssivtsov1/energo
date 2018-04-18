object fPointAct: TfPointAct
  Left = 193
  Top = 291
  Width = 334
  Height = 133
  Caption = 'fPointAct'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dsPlombs: TDataSource
    DataSet = ZQPlombs
    Left = 232
    Top = 10
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
      'select * from'
      '('
      
        'select p.id_point, t.name as type1, p.object_name as object_name' +
        '1, p.plomb_num as plomb_num1, 1 as num1'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 0'
      ') as s1'
      'left join'
      '('
      
        'select p.id_point, t.name as type2, p.object_name as object_name' +
        '2, p.plomb_num as plomb_num2, 2 as num2'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 1'
      ') as s2 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type3, p.object_name as object_name' +
        '3, p.plomb_num as plomb_num3, 3 as num3'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 2'
      ') as s3 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type4, p.object_name as object_name' +
        '4, p.plomb_num as plomb_num4, 4 as num4'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 3'
      ') as s4 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type5, p.object_name as object_name' +
        '5, p.plomb_num as plomb_num5, 5 as num5'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 4'
      ') as s5 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type6, p.object_name as object_name' +
        '6, p.plomb_num as plomb_num6, 6 as num6'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 5'
      ') as s6 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type7, p.object_name as object_name' +
        '7, p.plomb_num as plomb_num7, 7 as num7'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 6'
      ') as s7 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type8, p.object_name as object_name' +
        '8, p.plomb_num as plomb_num8, 8 as num8'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 7'
      ') as s8 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type9, p.object_name as object_name' +
        '9, p.plomb_num as plomb_num9, 9 as num9'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 8'
      ') as s9 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type10, p.object_name as object_nam' +
        'e10, p.plomb_num as plomb_num10, 10 as num10'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 9'
      ') as s10 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type11, p.object_name as object_nam' +
        'e11, p.plomb_num as plomb_num11, 11 as num11'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 10'
      ') as s11 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type12, p.object_name as object_nam' +
        'e12, p.plomb_num as plomb_num12, 12 as num12'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 11'
      ') as s12 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type13, p.object_name as object_nam' +
        'e13, p.plomb_num as plomb_num13, 13 as num13'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 12'
      ') as s13 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type14, p.object_name as object_nam' +
        'e14, p.plomb_num as plomb_num14, 14 as num14'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 13'
      ') as s14 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type15, p.object_name as object_nam' +
        'e15, p.plomb_num as plomb_num15, 15 as num15'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 14'
      ') as s15 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type16, p.object_name as object_nam' +
        'e16, p.plomb_num as plomb_num16, 16 as num16'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 15'
      ') as s16 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type17, p.object_name as object_nam' +
        'e17, p.plomb_num as plomb_num17, 17 as num17'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 16'
      ') as s17 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type18, p.object_name as object_nam' +
        'e18, p.plomb_num as plomb_num18, 18 as num18'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 17'
      ') as s18 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type19, p.object_name as object_nam' +
        'e19, p.plomb_num as plomb_num19, 19 as num19'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 18'
      ') as s19 using (id_point)'
      'left join'
      '('
      
        'select p.id_point, t.name as type20, p.object_name as object_nam' +
        'e20, p.plomb_num as plomb_num20, 20 as num20'
      'from clm_plomb_tbl as p'
      'left join cli_plomb_type_tbl as t on (t.id = p.id_type)'
      'where p.id_point = :point and p.dt_e is null'
      'order by p.object_name,p.plomb_num limit 1 offset 19'
      ') as s20 using (id_point)'
      ''
      ''
      ''
      '')
    RequestLive = False
    Left = 264
    Top = 10
    ParamData = <
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
      
        'select c.name as abon, c.code, eqm.name_eqp, eqa.name_eqp as nam' +
        'e_area, adr.adr, p.power,trim(border.inf) as inf'
      'from'
      'eqm_equipment_tbl as eqm'
      'join eqm_point_tbl as p on (eqm.id = p.code_eqp)'
      'join eqm_eqp_tree_tbl as tt on (tt.code_eqp = eqm.id)'
      'join eqm_tree_tbl as tr on (tr.id = tt.id_tree)'
      'left join eqm_eqp_use_tbl as use on (use.code_eqp = p.code_eqp)'
      
        'left join eqm_borders_tbl as border on (border.code_eqp = tr.cod' +
        'e_eqp)'
      
        'left join clm_client_tbl as c on (c.id = coalesce (use.id_client' +
        ', tr.id_client))'
      
        'left join eqm_compens_station_inst_tbl as a on (eqm.id = a.code_' +
        'eqp )'
      
        'left join eqm_equipment_tbl as eqa on (eqa.id = a.code_eqp_inst ' +
        ')'
      
        'left join adv_address_tbl as adr on (adr.id = CASE WHEN coalesce' +
        '(eqm.id_addres,0) <> 0 THEN  eqm.id_addres ELSE eqa.id_addres EN' +
        'D )'
      'where eqm.id = :point'
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 12
    Top = 14
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsCompI: TDataSource
    DataSet = ZQCompI
    Left = 88
    Top = 14
  end
  object dsMeterA: TDataSource
    DataSet = ZQMeterA
    Left = 148
    Top = 12
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
      
        'select ss.id, ss.num_eqp, ss.type,conversion, ss.accuracy, ss.da' +
        'te_check,ss.ktr '
      ' from ('
      
        'select  eqm.id, eqm.num_eqp, CASE WHEN eq2.type_eqp = 12 THEN eq' +
        '2.id WHEN eq3.type_eqp = 12 THEN eq3.id END as id_point,'
      ' ic.conversion , ic.type,ic.accuracy,c.date_check,'
      
        ' CASE WHEN conversion =1 then amperage_nom/amperage2_nom WHEN co' +
        'nversion =2 then voltage_nom/voltage2_nom END::::int as ktr'
      ' from'
      ' ( select * from eqm_equipment_tbl where type_eqp = 10 ) as eqm'
      '  join eqm_compensator_i_tbl as c on (c.code_eqp = eqm.id )'
      '  join  eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp )'
      '  join eqm_eqp_tree_tbl as tt on (tt.code_eqp=eqm.id )'
      '  join eqm_eqp_tree_tbl as tt2 on (tt2.code_eqp=tt.code_eqp_e )'
      '  join eqm_equipment_tbl as eq2 on (eq2.id =tt.code_eqp_e )'
      '  join eqm_equipment_tbl as eq3 on (eq3.id =tt2.code_eqp_e )'
      ') as ss'
      'where '
      'ss.id_point = :point and conversion <=1;')
    RequestLive = False
    Left = 62
    Top = 14
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object ZQMeterA: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select mp.id_point, mp.id_meter, eqm.num_eqp, im.type, me.kind_e' +
        'nergy,  pr.class||'#39'/'#39'||im.carry::::varchar as class, to_char(m.d' +
        't_control,'#39'mm/yyyy'#39') as dt_control, im.amperage_nom::::varchar, ' +
        'im.voltage_nom::::varchar'
      'from eqm_meter_point_h as mp'
      'join eqm_equipment_tbl as eqm on (eqm.id =mp.id_meter)'
      'join eqm_meter_tbl as m on (m.code_eqp=mp.id_meter )'
      'join eqi_meter_tbl as im on (im.id = m.id_type_eqp)'
      'join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter)'
      'join eqd_meter_zone_tbl as mz on (mz.code_eqp = mp.id_meter)'
      
        'left join (select id_type_eqp , max(cl) as class from eqi_meter_' +
        'prec_tbl group by id_type_eqp) as pr on (pr.id_type_eqp = im.id)'
      
        'where  mp.id_point = :point and mp.dt_e is null and me.kind_ener' +
        'gy = 1'
      ''
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 182
    Top = 12
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object xlReport: TxlReport
    Options = [xroDisplayAlerts, xroAutoSave, xroUseTemp]
    DataSources = <>
    Preview = False
    Params = <>
    Left = 12
    Top = 62
  end
  object ZQCompU: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select ss.id, ss.num_eqp, ss.type,conversion, ss.accuracy, ss.da' +
        'te_check,ss.ktr '
      ' from ('
      
        'select  eqm.id, eqm.num_eqp, CASE WHEN eq2.type_eqp = 12 THEN eq' +
        '2.id WHEN eq3.type_eqp = 12 THEN eq3.id END as id_point,'
      ' ic.conversion , ic.type,ic.accuracy,c.date_check,'
      
        ' CASE WHEN conversion =1 then amperage_nom/amperage2_nom WHEN co' +
        'nversion =2 then voltage_nom/voltage2_nom END::::int as ktr'
      ' from'
      ' ( select * from eqm_equipment_tbl where type_eqp = 10 ) as eqm'
      '  join eqm_compensator_i_tbl as c on (c.code_eqp = eqm.id )'
      '  join  eqi_compensator_i_tbl as ic on (ic.id = c.id_type_eqp )'
      '  join eqm_eqp_tree_tbl as tt on (tt.code_eqp=eqm.id )'
      '  join eqm_eqp_tree_tbl as tt2 on (tt2.code_eqp=tt.code_eqp_e )'
      '  join eqm_equipment_tbl as eq2 on (eq2.id =tt.code_eqp_e )'
      '  join eqm_equipment_tbl as eq3 on (eq3.id =tt2.code_eqp_e )'
      ') as ss'
      'where '
      'ss.id_point = :point and conversion >=2;')
    RequestLive = False
    Left = 60
    Top = 46
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsMeterR: TDataSource
    DataSet = ZQMeterR
    Left = 146
    Top = 42
  end
  object ZQMeterR: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select mp.id_point, mp.id_meter, eqm.num_eqp, im.type, me.kind_e' +
        'nergy,  pr.class||'#39'/'#39'||im.carry::::varchar as class, to_char(m.d' +
        't_control,'#39'mm/yyyy'#39') as dt_control, im.amperage_nom::::varchar, ' +
        'im.voltage_nom::::varchar'
      'from eqm_meter_point_h as mp'
      'join eqm_equipment_tbl as eqm on (eqm.id =mp.id_meter)'
      'join eqm_meter_tbl as m on (m.code_eqp=mp.id_meter )'
      'join eqi_meter_tbl as im on (im.id = m.id_type_eqp)'
      'join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter)'
      'join eqd_meter_zone_tbl as mz on (mz.code_eqp = mp.id_meter)'
      
        'left join (select id_type_eqp , max(cl) as class from eqi_meter_' +
        'prec_tbl group by id_type_eqp) as pr on (pr.id_type_eqp = im.id)'
      
        'where  mp.id_point = :point and mp.dt_e is null and me.kind_ener' +
        'gy = 2'
      ''
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 178
    Top = 42
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
  object dsMeterG: TDataSource
    DataSet = ZQMeterG
    Left = 144
    Top = 74
  end
  object ZQMeterG: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select mp.id_point, mp.id_meter, eqm.num_eqp, im.type, me.kind_e' +
        'nergy,  pr.class||'#39'/'#39'||im.carry::::varchar as class, to_char(m.d' +
        't_control,'#39'mm/yyyy'#39') as dt_control, im.amperage_nom::::varchar, ' +
        'im.voltage_nom::::varchar'
      'from eqm_meter_point_h as mp'
      'join eqm_equipment_tbl as eqm on (eqm.id =mp.id_meter)'
      'join eqm_meter_tbl as m on (m.code_eqp=mp.id_meter )'
      'join eqi_meter_tbl as im on (im.id = m.id_type_eqp)'
      'join eqd_meter_energy_tbl as me on (me.code_eqp = mp.id_meter)'
      'join eqd_meter_zone_tbl as mz on (mz.code_eqp = mp.id_meter)'
      
        'left join (select id_type_eqp , max(cl) as class from eqi_meter_' +
        'prec_tbl group by id_type_eqp) as pr on (pr.id_type_eqp = im.id)'
      
        'where  mp.id_point = :point and mp.dt_e is null and me.kind_ener' +
        'gy = 4'
      ''
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 174
    Top = 74
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'point'
        ParamType = ptUnknown
      end>
  end
end
