object PrintSald: TPrintSald
  Left = 74
  Top = 146
  Width = 934
  Height = 592
  Caption = 'Контроль'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Query1: TQuery
    DataSource = DataSource2
    SQL.Strings = (
      '    select :DateBeg  as datebeg, :DateEnd  as dateend,'
      
        '       dci_direction_tbl.name as direct,dci_group_tbl.name as gr' +
        'oup_doc,'
      
        '        dcd_document_tbl.id_group,dci_group_tbl.name as group_na' +
        'me,'
      
        '        dcd_document_tbl.id_direction,dci_direction_tbl.name as ' +
        'direct_name,'
      
        '        dcd_document_tbl.num_document,dcd_document_tbl.dt_docume' +
        'nt,dcd_document_tbl.context,'
      
        '        dcd_document_tbl.st_position,stv_persone_tbl0.name as na' +
        'me_persdoc,'
      
        '        stv_persone_tbl1.name_firm as name_firm,stv_persone_tbl1' +
        '.id_firm,'
      
        '        dcd_resolution_tbl.st_position_in,stv_persone_tbl1.name ' +
        'as name_persresolin,stv_persone_tbl1.id_firm,'
      
        '        dcd_resolution_tbl.st_position_out,stv_persone_tbl2.name' +
        ' as name_persresolout,'
      
        '       dcd_resolution_tbl.dt_resolution,dcd_resolution_tbl.num_r' +
        'esolution,dcd_resolution_tbl.txt_resolution,'
      
        '       dcd_resolution_tbl.is_ready,xvar as name_ready,dcd_resolu' +
        'tion_tbl.dt_exc,dck_period_tbl.name as name_period,'
      
        '       dcd_resolution_tbl.idk_resolution,dck_resolution_tbl.name' +
        ' as name_kindresol,'
      '       dcd_resolution_tbl.text_exc'
      
        '       from dcd_document_tbl left join dcd_resolution_tbl on dcd' +
        '_resolution_tbl.id_document=dcd_document_tbl.id,'
      
        '        dci_group_tbl, dci_direction_tbl,dck_resolution_tbl,dck_' +
        'period_tbl,'
      
        '        stv_persone_tbl stv_persone_tbl0, stv_persone_tbl stv_pe' +
        'rsone_tbl1,stv_persone_tbl stv_persone_tbl2,'
      '       retstr(dcd_resolution_tbl.is_ready)'
      '        where dcd_document_tbl.id_group=dci_group_tbl.id and'
      '        dcd_document_tbl.id_direction=dci_direction_tbl.id and'
      '        dcd_document_tbl.st_position=stv_persone_tbl0.id and'
      
        '        dcd_resolution_tbl.st_position_in=stv_persone_tbl1.id an' +
        'd'
      
        '        dcd_resolution_tbl.st_position_out=stv_persone_tbl2.id a' +
        'nd'
      
        '        dcd_resolution_tbl.idk_resolution=dck_resolution_tbl.id ' +
        'and'
      '        dcd_resolution_tbl.idk_period=dck_period_tbl.id and'
      '        dcd_resolution_tbl.dt_exc>= :DateBeg and'
      '        dcd_resolution_tbl.dt_exc<= :DateEnd'
      
        '         order by  id_firm,dcd_document_tbl.id_direction,dcd_doc' +
        'ument_tbl.id_group,num_document,num_resolution'
      ''
      '')
    UpdateMode = upWhereChanged
    Left = 7
    Top = 106
    ParamData = <
      item
        DataType = ftDate
        Name = 'DateBeg'
        ParamType = ptUnknown
        Value = 'Date()-30'
      end
      item
        DataType = ftDate
        Name = 'DateEnd'
        ParamType = ptUnknown
        Value = 'Date()+30'
      end
      item
        DataType = ftDate
        Name = 'DateBeg'
        ParamType = ptUnknown
      end
      item
        DataType = ftDate
        Name = 'DateEnd'
        ParamType = ptUnknown
      end>
  end
  object Database1: TDatabase
    AliasName = 'Docs'
    DatabaseName = 'DatabaseName'
    KeepConnection = False
    LoginPrompt = False
    Params.Strings = (
      'USER NAME=nic'
      'PassWord=123')
    ReadOnly = True
    SessionName = 'Default'
    Left = 3
    Top = 140
  end
  object DataSource1: TDataSource
    DataSet = Query1
    Left = 3
    Top = 170
  end
  object UpdateSQL1: TUpdateSQL
    Left = 1
    Top = 74
  end
  object Table1: TTable
    DatabaseName = 'Docs'
    ReadOnly = True
    TableName = 'DCD_DOCUMENT_TBL'
    Left = 5
  end
  object DataSource2: TDataSource
    AutoEdit = False
    DataSet = Table1
    Left = 3
    Top = 34
  end
end
