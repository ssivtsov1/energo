object fMonitorFiderWorkEdit: TfMonitorFiderWorkEdit
  Left = 260
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Работа'
  ClientHeight = 296
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
    Top = 255
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
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = btOkClick
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333333333333330000333333333333333333333333F33333333333
        00003333344333333333333333388F3333333333000033334224333333333333
        338338F3333333330000333422224333333333333833338F3333333300003342
        222224333333333383333338F3333333000034222A22224333333338F338F333
        8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
        33333338F83338F338F33333000033A33333A222433333338333338F338F3333
        0000333333333A222433333333333338F338F33300003333333333A222433333
        333333338F338F33000033333333333A222433333333333338F338F300003333
        33333333A222433333333333338F338F00003333333333333A22433333333333
        3338F38F000033333333333333A223333333333333338F830000333333333333
        333A333333333333333338330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object btCancel: TBitBtn
      Left = 548
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
    Width = 634
    Height = 255
    Align = alClient
    TabOrder = 1
    object Label3: TLabel
      Left = 10
      Top = 14
      Width = 66
      Height = 13
      Caption = 'Дата работы'
    end
    object Label8: TLabel
      Left = 12
      Top = 40
      Width = 35
      Height = 13
      Caption = 'Фидер'
    end
    object sbFider: TSpeedButton
      Left = 376
      Top = 36
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
      Top = 192
      Width = 63
      Height = 13
      Caption = 'Примечание'
    end
    object Label4: TLabel
      Left = 12
      Top = 92
      Width = 59
      Height = 13
      Caption = 'Вид работы'
    end
    object Label5: TLabel
      Left = 12
      Top = 118
      Width = 39
      Height = 13
      Caption = 'Обекты'
    end
    object Label1: TLabel
      Left = 12
      Top = 144
      Width = 67
      Height = 13
      Caption = 'Объем работ'
    end
    object Label6: TLabel
      Left = 12
      Top = 66
      Width = 42
      Height = 13
      Caption = 'Абонент'
    end
    object sbAbon: TSpeedButton
      Left = 376
      Top = 62
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
      OnClick = sbAbonClick
    end
    object SpeedButton1: TSpeedButton
      Left = 402
      Top = 62
      Width = 23
      Height = 22
      Caption = 'Х'
      OnClick = SpeedButton1Click
    end
    object Label7: TLabel
      Left = 12
      Top = 170
      Width = 67
      Height = 13
      Caption = 'Исполнитель'
    end
    object sbInspector: TSpeedButton
      Left = 342
      Top = 164
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
      OnClick = sbInspectorClick
    end
    object sbInspectorCl: TSpeedButton
      Left = 366
      Top = 164
      Width = 23
      Height = 22
      Caption = 'Х'
      OnClick = sbInspectorClClick
    end
    object edData: TMaskEdit
      Left = 90
      Top = 10
      Width = 97
      Height = 21
      EditMask = '90.90.0000;1;_'
      MaxLength = 10
      TabOrder = 0
      Text = '  .  .    '
    end
    object edFiderName: TEdit
      Left = 90
      Top = 36
      Width = 287
      Height = 21
      TabOrder = 1
    end
    object mComment: TMemo
      Left = 6
      Top = 208
      Width = 617
      Height = 41
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
    end
    object lcWork: TRxLookupEdit
      Left = 90
      Top = 88
      Width = 535
      Height = 21
      DropDownCount = 15
      LookupDisplay = 'name'
      LookupField = 'id'
      LookupSource = dsWorkType
      TabOrder = 4
    end
    object edObject: TEdit
      Left = 90
      Top = 114
      Width = 535
      Height = 21
      TabOrder = 5
    end
    object edCnt: TRxCalcEdit
      Left = 90
      Top = 140
      Width = 121
      Height = 21
      DecimalPlaces = 3
      DisplayFormat = ',0.###'
      NumGlyphs = 2
      TabOrder = 6
    end
    object edAbonCode: TEdit
      Left = 90
      Top = 62
      Width = 52
      Height = 21
      TabOrder = 2
      OnKeyPress = edAbonCodeKeyPress
    end
    object edAbonName: TEdit
      Left = 142
      Top = 62
      Width = 235
      Height = 21
      TabOrder = 3
    end
    object edInspector: TEdit
      Left = 90
      Top = 164
      Width = 245
      Height = 21
      TabOrder = 7
    end
  end
  object ZQWorkType: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select id, id_grp, name from mni_works_tbl order by id;')
    RequestLive = True
    Left = 541
    Top = 15
  end
  object dsWorkType: TDataSource
    DataSet = ZQWorkType
    Left = 570
    Top = 16
  end
end
