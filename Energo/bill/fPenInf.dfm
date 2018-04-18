object fPenaInflPrint: TfPenaInflPrint
  Left = 654
  Top = 203
  Width = 424
  Height = 255
  Caption = 'Печать претензии'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 408
    Height = 217
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 317
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Caption = 'Сформировать претензию по пене и инфляции?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label2: TLabel
      Left = 12
      Top = 48
      Width = 58
      Height = 13
      Caption = 'За период :'
    end
    object sbDec: TSpeedButton
      Left = 76
      Top = 44
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = sbDecClick
    end
    object sbInc: TSpeedButton
      Left = 262
      Top = 44
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = sbIncClick
    end
    object Label3: TLabel
      Left = 184
      Top = 76
      Width = 3
      Height = 13
      Caption = '-'
    end
    object BitBtn1: TBitBtn
      Left = 160
      Top = 116
      Width = 75
      Height = 25
      Caption = 'Да'
      TabOrder = 0
      OnClick = BitBtn1Click
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 244
      Top = 116
      Width = 75
      Height = 25
      Caption = 'Нет'
      TabOrder = 1
      Kind = bkCancel
    end
    object edMonth: TEdit
      Left = 100
      Top = 44
      Width = 161
      Height = 21
      ReadOnly = True
      TabOrder = 2
      Text = 'edMonth'
    end
    object dtEnd: TDateTimePicker
      Left = 192
      Top = 72
      Width = 93
      Height = 21
      CalAlignment = dtaLeft
      Date = 37761
      Time = 37761
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 3
    end
    object dtBegin: TDateTimePicker
      Left = 76
      Top = 72
      Width = 101
      Height = 21
      CalAlignment = dtaLeft
      Date = 37747
      Time = 37747
      DateFormat = dfShort
      DateMode = dmComboBox
      Kind = dtkDate
      ParseInput = False
      TabOrder = 4
    end
  end
  object ZQXLRepMain: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 300
    Top = 40
  end
  object ZQXLRepPen_a: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select clc.dat_b, clc.dat_e,clc.k_inf*100 as k_inf ,clc.sum_inf,' +
        'clc.ident1,clc.type_p_doc, clc.summ,'
      'clc.dat_e - clc.dat_b+1  as days,'
      
        'case when clc.type_p_doc = '#39'bil'#39' then sv.sumdat else 0 end as su' +
        'm_bill,'
      
        'case when clc.type_p_doc = '#39'pay'#39' then -sv.sumdat else 0 end as s' +
        'um_pay'
      'from acm_bill_tbl as b'
      'join acd_clc_inf as clc on (clc.id_doc = b.id_doc)'
      
        'left join (select id_doc,ident,dat,sum(summ) as sumdat  from acd' +
        '_summ_val where ident1 = '#39'act_ee'#39' and id_client = :client group ' +
        'by id_doc,ident,dat ) as sv'
      
        ' on (sv.id_doc = b.id_doc and clc.type_p_doc = sv.ident and clc.' +
        'dat_b= sv.dat+'#39'1 day'#39'::::interval and sv.ident <> '#39'sb'#39')'
      'where b.id_pref = 901'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39',:dtb::::date) and b.mmgg_b' +
        'ill <= date_trunc('#39'month'#39',:dte::::date)'
      'and clc.ident1 = '#39'act_ee'#39
      'and b.id_client = :client'
      'order by clc.dat_b;'
      ' '
      ' '
      '                                       '
      ' ')
    RequestLive = False
    Left = 4
    Top = 68
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end>
  end
  object ZQXLRepPen_r: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select clc.dat_b, clc.dat_e,clc.k_inf*100 as k_inf,clc.sum_inf,c' +
        'lc.ident1,clc.type_p_doc, clc.summ, '
      'clc.dat_e - clc.dat_b+1  as days,'
      
        'case when clc.type_p_doc = '#39'bil'#39' then sv.sumdat else 0 end as su' +
        'm_bill,'
      
        'case when clc.type_p_doc = '#39'pay'#39' then -sv.sumdat else 0 end as s' +
        'um_pay'
      'from acm_bill_tbl as b'
      'join acd_clc_inf as clc on (clc.id_doc = b.id_doc)'
      
        'left join (select id_doc,ident,dat,sum(summ) as sumdat  from acd' +
        '_summ_val where ident1 = '#39'react_ee'#39' and id_client = :client grou' +
        'p by id_doc,ident,dat ) as sv'
      
        ' on (sv.id_doc = b.id_doc and clc.type_p_doc = sv.ident and clc.' +
        'dat_b= sv.dat+'#39'1 day'#39'::::interval and sv.ident <> '#39'sb'#39')'
      'where b.id_pref = 901'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39',:dtb::::date) and b.mmgg_b' +
        'ill <= date_trunc('#39'month'#39',:dte::::date)'
      'and clc.ident1 = '#39'react_ee'#39
      'and b.id_client = :client'
      'order by clc.dat_b;'
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 36
    Top = 68
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end>
  end
  object ZQXLRepInf_a: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select b.mmgg_bill,'
      
        'date_part('#39'day'#39',(date_trunc('#39'month'#39',b.mmgg_bill)+'#39'1 month - 1 da' +
        'y'#39')) as days,'
      
        'sv.summ as saldo_b, coalesce(clc.sum_infl,0) as sum_infl, td.val' +
        'ue as k_inf'
      'from acm_bill_tbl as b'
      'left join acd_summ_val as sv on (sv.id_doc = b.id_doc)'
      'left join ( select id_doc, sum(sum_inf) as sum_infl'
      
        '   from acd_clc_inf  where ident1 = '#39'act_ee'#39' group by id_doc ) a' +
        's clc'
      'on (clc.id_doc = b.id_doc),'
      'cmd_tax_tbl as td join cmi_tax_tbl as ti on (td.id_tax=ti.id)'
      'where b.id_pref = 902'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39', :dtb::::date) and b.mmgg_' +
        'bill <= date_trunc('#39'month'#39', :dte::::date)'
      'and sv.ident1 = '#39'act_ee'#39
      'and b.id_client = :client'
      'and sv.ident = '#39'sb'#39
      'and ti.ident='#39'inf'#39' '
      'and td.date_inst=(select max(td2.date_inst) from '
      
        '     cmd_tax_tbl as td2 right join cmi_tax_tbl as ti2 on (td2.id' +
        '_tax=ti2.id) '
      '    where td2.date_inst<=b.mmgg_bill and ti2.ident='#39'inf'#39')'
      'order by b.mmgg_bill;'
      ''
      ' ')
    RequestLive = False
    Left = 4
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object ZQXLRepInfDoc_a: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select sv.dat,sv.ident1,sv.ident,sv.summ as sumdoc,b.mmgg_bill,'
      
        'case when sv.ident = '#39'bil'#39' then sv.summ else null end as sum_bil' +
        'l,'
      
        'case when sv.ident = '#39'pay'#39' then -sv.summ else null end as sum_pa' +
        'y,'
      'case when sv.ident = '#39'bil'#39' then sv.dat else null end as dt_bill,'
      'case when sv.ident = '#39'pay'#39' then sv.dat else null end as dt_pay'
      'from acm_bill_tbl as b'
      'join acd_summ_val as sv on (sv.id_doc = b.id_doc)'
      'where b.id_pref = 902'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39', :dtb::::date) and b.mmgg_' +
        'bill <= date_trunc('#39'month'#39', :dte::::date)'
      'and sv.ident1 = '#39'act_ee'#39
      'and b.id_client = :client'
      'and (sv.ident = '#39'bil'#39' or sv.ident = '#39'pay'#39' )'
      'order by b.mmgg_bill,sv.dat;'
      '')
    RequestLive = False
    Left = 36
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object dsRepInf_a: TDataSource
    DataSet = ZQXLRepInf_a
    Left = 52
    Top = 116
  end
  object ZQXLRepInf_r: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select b.mmgg_bill,'
      
        'date_part('#39'day'#39',(date_trunc('#39'month'#39',b.mmgg_bill)+'#39'1 month - 1 da' +
        'y'#39')) as days,'
      
        'sv.summ as saldo_b, coalesce(clc.sum_infl,0) as sum_infl, td.val' +
        'ue as k_inf'
      'from acm_bill_tbl as b'
      'left join acd_summ_val as sv on (sv.id_doc = b.id_doc)'
      'left join ( select id_doc, sum(sum_inf) as sum_infl'
      
        '   from acd_clc_inf  where ident1 = '#39'react_ee'#39' group by id_doc )' +
        ' as clc'
      'on (clc.id_doc = b.id_doc),'
      'cmd_tax_tbl as td join cmi_tax_tbl as ti on (td.id_tax=ti.id)'
      'where b.id_pref = 902'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39', :dtb::::date) and b.mmgg_' +
        'bill <= date_trunc('#39'month'#39', :dte::::date)'
      'and sv.ident1 = '#39'react_ee'#39
      'and b.id_client = :client'
      'and sv.ident = '#39'sb'#39
      'and ti.ident='#39'inf'#39
      'and td.date_inst=(select max(td2.date_inst) from'
      
        '     cmd_tax_tbl as td2 right join cmi_tax_tbl as ti2 on (td2.id' +
        '_tax=ti2.id) '
      '    where td2.date_inst<=b.mmgg_bill and ti2.ident='#39'inf'#39')'
      'order by b.mmgg_bill;'
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 84
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object ZQXLRepInfDoc_r: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select sv.dat,sv.ident1,sv.ident,sv.summ as sumdoc,b.mmgg_bill,'
      
        'case when sv.ident = '#39'bil'#39' then sv.summ else null end as sum_bil' +
        'l,'
      
        'case when sv.ident = '#39'pay'#39' then -sv.summ else null end as sum_pa' +
        'y,'
      'case when sv.ident = '#39'bil'#39' then sv.dat else null end as dt_bill,'
      'case when sv.ident = '#39'pay'#39' then sv.dat else null end as dt_pay'
      'from acm_bill_tbl as b'
      'join acd_summ_val as sv on (sv.id_doc = b.id_doc)'
      'where b.id_pref = 902'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39', :dtb::::date) and b.mmgg_' +
        'bill <= date_trunc('#39'month'#39', :dte::::date)'
      'and sv.ident1 = '#39'react_ee'#39
      'and b.id_client = :client'
      'and (sv.ident = '#39'bil'#39' or sv.ident = '#39'pay'#39' )'
      'order by b.mmgg_bill,sv.dat;'
      ''
      ' ')
    RequestLive = False
    Left = 116
    Top = 104
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object dsRepInf_r: TDataSource
    DataSet = ZQXLRepInf_r
    Left = 132
    Top = 116
  end
  object ZQXLRep3Proc_r: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select b.mmgg_bill,'
      
        'date_part('#39'day'#39',(date_trunc('#39'month'#39',b.mmgg_bill)+'#39'1 month - 1 da' +
        'y'#39')) as days,'
      
        'sv.summ as saldo_b, coalesce(clc.sum_infl,0) as sum_infl, td.val' +
        'ue as k_inf'
      'from acm_bill_tbl as b'
      'left join acd_summ_val as sv on (sv.id_doc = b.id_doc)'
      'left join ( select id_doc, sum(sum_inf) as sum_infl'
      
        '   from acd_clc_inf  where ident1 = '#39'react_ee'#39' group by id_doc )' +
        ' as clc'
      'on (clc.id_doc = b.id_doc),'
      'cmd_tax_tbl as td join cmi_tax_tbl as ti on (td.id_tax=ti.id)'
      'where b.id_pref = 902'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39', :dtb::::date) and b.mmgg_' +
        'bill <= date_trunc('#39'month'#39', :dte::::date)'
      'and sv.ident1 = '#39'react_ee'#39
      'and b.id_client = :client'
      'and sv.ident = '#39'sb'#39
      'and ti.ident='#39'inf'#39
      'and td.date_inst=(select max(td2.date_inst) from'
      
        '     cmd_tax_tbl as td2 right join cmi_tax_tbl as ti2 on (td2.id' +
        '_tax=ti2.id) '
      '    where td2.date_inst<=b.mmgg_bill and ti2.ident='#39'inf'#39')'
      'order by b.mmgg_bill;'
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 84
    Top = 128
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end>
  end
  object ZQXLRep3Proc_a: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select clc.dat_b, clc.dat_e,clc.k_inf*100 as k_inf ,clc.sum_inf,' +
        'clc.ident1,clc.type_p_doc, clc.summ,'
      'clc.dat_e - clc.dat_b+1  as days,'
      
        'case when clc.type_p_doc = '#39'bil'#39' then sv.sumdat else 0 end as su' +
        'm_bill,'
      
        'case when clc.type_p_doc = '#39'pay'#39' then -sv.sumdat else 0 end as s' +
        'um_pay'
      'from acm_bill_tbl as b'
      'join acd_clc_inf as clc on (clc.id_doc = b.id_doc)'
      
        'left join (select id_doc,ident,dat,sum(summ) as sumdat  from acd' +
        '_summ_val where ident1 = '#39'act_ee'#39' and id_client = :client group ' +
        'by id_doc,ident,dat ) as sv'
      
        ' on (sv.id_doc = b.id_doc and clc.type_p_doc = sv.ident and clc.' +
        'dat_b= sv.dat+'#39'1 day'#39'::::interval and sv.ident <> '#39'sb'#39')'
      'where b.id_pref = 903'
      
        'and b.mmgg_bill >= date_trunc('#39'month'#39',:dtb::::date) and b.mmgg_b' +
        'ill <= date_trunc('#39'month'#39',:dte::::date)'
      'and clc.ident1 = '#39'act_ee'#39
      'and b.id_client = :client'
      'order by clc.dat_b;'
      ' ')
    RequestLive = False
    Left = 356
    Top = 176
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dtb'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dte'
        ParamType = ptUnknown
      end>
  end
  object xlReport: TxlReport
    DataSources = <>
    Preview = False
    Params = <>
    Left = 360
    Top = 40
  end
end
