object fbalConnSwitchEdit: TfbalConnSwitchEdit
  Left = 261
  Top = 108
  BorderStyle = bsDialog
  Caption = '������������'
  ClientHeight = 471
  ClientWidth = 634
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
  object Panel1: TPanel
    Left = 0
    Top = 430
    Width = 634
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btOk: TBitBtn
      Left = 468
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      TabOrder = 0
      OnClick = btOkClick
      Kind = bkOK
    end
    object btCancel: TBitBtn
      Left = 548
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '�������'
      TabOrder = 1
      OnClick = btCancelClick
      Kind = bkCancel
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 634
    Height = 145
    Align = alTop
    TabOrder = 1
    object Label3: TLabel
      Left = 12
      Top = 10
      Width = 140
      Height = 13
      Caption = '���� ������ ������������'
    end
    object Label1: TLabel
      Left = 12
      Top = 34
      Width = 135
      Height = 13
      Caption = '���� ����� ������������'
    end
    object Label8: TLabel
      Left = 12
      Top = 64
      Width = 111
      Height = 13
      Caption = '���������� � ������'
    end
    object sbFider: TSpeedButton
      Left = 420
      Top = 60
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
      OnClick = sbFiderClick
    end
    object Label2: TLabel
      Left = 12
      Top = 80
      Width = 63
      Height = 13
      Caption = '����������'
    end
    object edDataEClear: TSpeedButton
      Left = 268
      Top = 32
      Width = 23
      Height = 22
      Caption = '�'
      OnClick = edDataEClearClick
    end
    object edDataB: TMaskEdit
      Left = 168
      Top = 8
      Width = 97
      Height = 21
      EditMask = '90.90.0000 00:00;1;_'
      MaxLength = 16
      TabOrder = 0
      Text = '  .  .       :  '
    end
    object edDataE: TMaskEdit
      Left = 168
      Top = 32
      Width = 97
      Height = 21
      EditMask = '90.90.0000 00:00;1;_'
      MaxLength = 16
      TabOrder = 1
      Text = '  .  .       :  '
    end
    object edFiderName: TEdit
      Left = 168
      Top = 60
      Width = 245
      Height = 21
      TabOrder = 2
    end
    object mComment: TMemo
      Left = 8
      Top = 96
      Width = 617
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
  end
  object pFiders: TPanel
    Left = 0
    Top = 145
    Width = 634
    Height = 285
    Align = alClient
    TabOrder = 2
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 632
      Height = 24
      Align = alTop
      Caption = '������������� ��'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object Panel4: TPanel
      Left = 1
      Top = 25
      Width = 632
      Height = 32
      Align = alTop
      TabOrder = 1
      object Label4: TLabel
        Left = 12
        Top = 8
        Width = 81
        Height = 13
        Caption = '����� (������)'
      end
      object sbFider2: TSpeedButton
        Left = 420
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
        OnClick = sbFiderClick
      end
      object sbFider2Cl: TSpeedButton
        Left = 444
        Top = 4
        Width = 23
        Height = 22
        Caption = '�'
        OnClick = sbFider2ClClick
      end
      object edFiderName2: TEdit
        Left = 168
        Top = 4
        Width = 245
        Height = 21
        TabOrder = 0
      end
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 57
      Width = 632
      Height = 227
      Align = alClient
      DataSource = dsSelect
      TabOrder = 2
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
          Title.Caption = '�������'
          Width = 51
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'name_eqp'
          ReadOnly = True
          Title.Caption = '���'
          Width = 265
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
      'select s.* , f.name_eqp, b.id_p_eqp'
      'from bal_selstation_tmp  as s'
      'join eqm_equipment_tbl as f on (s.id_st = f.id )'
      
        'left join bal_grp_tree_tbl as b on (b.code_eqp = s.id_st and b.m' +
        'mgg = (select max(mmgg) from bal_grp_tree_tbl) )'
      'order by name_eqp'
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = True
    Left = 575
    Top = 7
  end
  object dsSelect: TDataSource
    DataSet = ZQSelect
    Left = 576
    Top = 36
  end
  object ZUpdateSql1: TZUpdateSql
    ModifySql.Strings = (
      'update bal_selstation_tmp'
      'set selected = :selected '
      'where id_st = :id_st;')
    Left = 544
    Top = 8
  end
end