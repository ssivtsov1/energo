object fReports: TfReports
  Left = 248
  Top = 174
  Width = 731
  Height = 739
  Caption = 'Отчеты'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 715
    Height = 701
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object pButtons: TPanel
      Left = 2
      Top = 662
      Width = 711
      Height = 37
      Align = alBottom
      TabOrder = 0
      object Label5: TLabel
        Left = 4
        Top = 4
        Width = 453
        Height = 26
        Caption = 
          'В EXCEL  включить '#39'Сервис\Макрос\Безопастность...'#39', закладка '#39'На' +
          'дежные источники'#39', '#13#10'флажок “Доверять доступ к Visual Basic Proj' +
          'ect”.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object btGo: TBitBtn
        Tag = 1
        Left = 544
        Top = 8
        Width = 91
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Сформировать'
        Enabled = False
        TabOrder = 0
        OnClick = btGoClick
      end
      object btPrint: TBitBtn
        Left = 637
        Top = 8
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'Печать'
        Enabled = False
        TabOrder = 1
        OnClick = btGoClick
      end
      object btFile: TBitBtn
        Tag = 1
        Left = 465
        Top = 8
        Width = 74
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'В файл'
        Enabled = False
        TabOrder = 2
        OnClick = btFileClick
      end
    end
    object pReps: TPanel
      Left = 2
      Top = 2
      Width = 223
      Height = 660
      Align = alLeft
      TabOrder = 1
      object tReps: TTreeView
        Left = 1
        Top = 1
        Width = 221
        Height = 658
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnChanging = tRepsChanging
      end
    end
    object Panel2: TPanel
      Left = 225
      Top = 2
      Width = 488
      Height = 660
      Align = alClient
      TabOrder = 2
      object pPeriod: TPanel
        Left = 1
        Top = 65
        Width = 486
        Height = 68
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 68
          Top = 16
          Width = 58
          Height = 13
          Caption = 'За период :'
        end
        object Label2: TLabel
          Left = 252
          Top = 44
          Width = 3
          Height = 13
          Caption = '-'
        end
        object sbDec: TSpeedButton
          Left = 136
          Top = 12
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = sbDecClick
        end
        object sbInc: TSpeedButton
          Left = 340
          Top = 12
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = sbIncClick
        end
        object dtBegin: TDateTimePicker
          Left = 136
          Top = 40
          Width = 105
          Height = 21
          CalAlignment = dtaLeft
          Date = 37747
          Time = 37747
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 0
        end
        object dtEnd: TDateTimePicker
          Left = 268
          Top = 40
          Width = 97
          Height = 21
          CalAlignment = dtaLeft
          Date = 37761
          Time = 37761
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 1
        end
        object edMonth: TEdit
          Left = 164
          Top = 12
          Width = 173
          Height = 21
          ReadOnly = True
          TabOrder = 2
          Text = 'edMonth'
        end
      end
      object pCaption: TPanel
        Left = 1
        Top = 1
        Width = 486
        Height = 64
        Align = alTop
        TabOrder = 1
        object lFullName: TLabel
          Left = 8
          Top = 8
          Width = 481
          Height = 49
          Alignment = taCenter
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lFullName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          WordWrap = True
        end
      end
      object pDate: TPanel
        Left = 1
        Top = 201
        Width = 486
        Height = 44
        Align = alTop
        TabOrder = 2
        object Label3: TLabel
          Left = 68
          Top = 16
          Width = 39
          Height = 13
          Caption = 'На дату'
        end
        object dtRDate: TDateTimePicker
          Left = 136
          Top = 12
          Width = 186
          Height = 21
          CalAlignment = dtaLeft
          Date = 37921.4065846065
          Time = 37921.4065846065
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 0
        end
      end
      object pAbon: TPanel
        Left = 1
        Top = 445
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 3
        object Label4: TLabel
          Left = 70
          Top = 16
          Width = 42
          Height = 13
          Caption = 'Абонент'
        end
        object sbAbon: TSpeedButton
          Left = 372
          Top = 12
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
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = SpeedButton1Click
        end
        object edAbonName: TEdit
          Left = 172
          Top = 12
          Width = 193
          Height = 21
          TabOrder = 0
        end
        object edAbonCode: TEdit
          Left = 120
          Top = 12
          Width = 52
          Height = 21
          TabOrder = 1
          OnKeyPress = edAbonCodeKeyPress
        end
      end
      object pKindEn: TPanel
        Left = 1
        Top = 485
        Width = 486
        Height = 32
        Align = alTop
        TabOrder = 4
        object Label6: TLabel
          Left = 68
          Top = 8
          Width = 63
          Height = 13
          Caption = 'Вид энергии'
        end
        object cbKindEnergy: TComboBox
          Left = 140
          Top = 4
          Width = 277
          Height = 21
          DropDownCount = 9
          ItemHeight = 13
          TabOrder = 0
          Text = 'cbKindEnergy'
          Items.Strings = (
            'Активна енергія'
            'Реактивна енергія'
            'Перевищення ліміта (2КР потужність)'
            'Перевищення ліміта (2КР споживання з ПДВ)'
            'Перевищення ліміта (2КР споживання 2014)'
            'Пеня'
            'Інфляція'
            'Передача електроенергії'
            'Інформаційні послуги'
            'АЕ для пофидерного')
        end
      end
      object pValue: TPanel
        Left = 1
        Top = 517
        Width = 486
        Height = 36
        Align = alTop
        TabOrder = 5
        object Label7: TLabel
          Left = 68
          Top = 8
          Width = 52
          Height = 13
          Caption = 'Сумма  >='
        end
        object edValue: TEdit
          Left = 140
          Top = 4
          Width = 121
          Height = 21
          TabOrder = 0
          Text = 'edValue'
        end
      end
      object pFiders: TPanel
        Left = 1
        Top = 285
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 6
        object Label8: TLabel
          Left = 68
          Top = 16
          Width = 35
          Height = 13
          Caption = 'Фидер'
        end
        object sbFider: TSpeedButton
          Left = 372
          Top = 12
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
        object sbFiderCl: TSpeedButton
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = sbFiderClClick
        end
        object edFiderName: TEdit
          Left = 120
          Top = 12
          Width = 245
          Height = 21
          TabOrder = 0
        end
      end
      object pUrFiz: TPanel
        Left = 1
        Top = 585
        Width = 486
        Height = 32
        Align = alTop
        TabOrder = 7
        object cbFiz: TCheckBox
          Left = 236
          Top = 8
          Width = 97
          Height = 17
          Caption = 'Население'
          TabOrder = 0
        end
        object cbUr: TCheckBox
          Left = 68
          Top = 8
          Width = 129
          Height = 17
          Caption = 'Юридические лица'
          TabOrder = 1
        end
      end
      object pKey: TPanel
        Left = 1
        Top = 617
        Width = 486
        Height = 34
        Align = alTop
        TabOrder = 8
        object cbNoKey: TCheckBox
          Left = 68
          Top = 8
          Width = 129
          Height = 17
          Caption = 'Без ключевых'
          TabOrder = 0
        end
      end
      object pPS: TPanel
        Left = 1
        Top = 245
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 9
        object Label9: TLabel
          Left = 52
          Top = 16
          Width = 61
          Height = 13
          Caption = 'Подстанция'
        end
        object sbPS: TSpeedButton
          Left = 372
          Top = 12
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
          OnClick = sbPSClick
        end
        object sbPSCl: TSpeedButton
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = sbPSClClick
        end
        object edPSName: TEdit
          Left = 120
          Top = 12
          Width = 245
          Height = 21
          TabOrder = 0
        end
      end
      object pTarif: TPanel
        Left = 1
        Top = 325
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 10
        object Label10: TLabel
          Left = 68
          Top = 16
          Width = 33
          Height = 13
          Caption = 'Тариф'
        end
        object sbTarif: TSpeedButton
          Left = 372
          Top = 12
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
          OnClick = sbTarifClick
        end
        object sbTarifCl: TSpeedButton
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = sbTarifClClick
        end
        object edTarifName: TEdit
          Left = 120
          Top = 12
          Width = 245
          Height = 21
          TabOrder = 0
        end
      end
      object pInspector: TPanel
        Left = 1
        Top = 405
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 11
        object Label11: TLabel
          Left = 60
          Top = 16
          Width = 53
          Height = 13
          Caption = 'Сотрудник'
        end
        object sbInspector: TSpeedButton
          Left = 372
          Top = 12
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
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = sbInspectorClClick
        end
        object edInspector: TEdit
          Left = 120
          Top = 12
          Width = 245
          Height = 21
          TabOrder = 0
        end
      end
      object pPeriod_2: TPanel
        Left = 1
        Top = 133
        Width = 486
        Height = 68
        Align = alTop
        TabOrder = 12
        object Label12: TLabel
          Left = 50
          Top = 16
          Width = 81
          Height = 13
          Caption = 'Второй период :'
        end
        object Label13: TLabel
          Left = 252
          Top = 44
          Width = 3
          Height = 13
          Caption = '-'
        end
        object sbDec_2: TSpeedButton
          Left = 136
          Top = 12
          Width = 23
          Height = 22
          Caption = '<'
          OnClick = sbDec_2Click
        end
        object sbInc_2: TSpeedButton
          Left = 340
          Top = 12
          Width = 23
          Height = 22
          Caption = '>'
          OnClick = sbInc_2Click
        end
        object dtBegin_2: TDateTimePicker
          Left = 136
          Top = 40
          Width = 105
          Height = 21
          CalAlignment = dtaLeft
          Date = 37747
          Time = 37747
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 0
        end
        object dtEnd_2: TDateTimePicker
          Left = 268
          Top = 40
          Width = 97
          Height = 21
          CalAlignment = dtaLeft
          Date = 37761
          Time = 37761
          DateFormat = dfShort
          DateMode = dmComboBox
          Kind = dtkDate
          ParseInput = False
          TabOrder = 1
        end
        object edMonth_2: TEdit
          Left = 164
          Top = 12
          Width = 173
          Height = 21
          ReadOnly = True
          TabOrder = 2
          Text = 'edMonth'
        end
      end
      object pAll: TPanel
        Left = 1
        Top = 651
        Width = 486
        Height = 34
        Align = alTop
        TabOrder = 13
        object cbAll: TCheckBox
          Left = 68
          Top = 8
          Width = 129
          Height = 17
          Caption = 'Полный список'
          TabOrder = 0
        end
      end
      object pLostNolost: TPanel
        Left = 1
        Top = 553
        Width = 486
        Height = 32
        Align = alTop
        TabOrder = 14
        object cbLNLAll: TCheckBox
          Left = 236
          Top = 8
          Width = 101
          Height = 17
          Caption = 'Все абоненты'
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = cbLNLAllClick
        end
        object cbLNLNasNP: TCheckBox
          Left = 68
          Top = 8
          Width = 153
          Height = 17
          Caption = 'Население и нас. пункты'
          TabOrder = 1
          OnClick = cbLNLNasNPClick
        end
      end
      object pExecutor: TPanel
        Left = 1
        Top = 365
        Width = 486
        Height = 40
        Align = alTop
        TabOrder = 15
        object Label14: TLabel
          Left = 12
          Top = 16
          Width = 102
          Height = 13
          Caption = 'Техник по расчетам'
        end
        object sbExecutor: TSpeedButton
          Left = 372
          Top = 12
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
          OnClick = sbExecutorClick
        end
        object sbExecutorCl: TSpeedButton
          Left = 396
          Top = 12
          Width = 23
          Height = 22
          Caption = 'Х'
          OnClick = sbExecutorClClick
        end
        object edExecutor: TEdit
          Left = 120
          Top = 12
          Width = 245
          Height = 21
          TabOrder = 0
        end
      end
    end
  end
  object xlReport: TxlReport
    Options = [xroDisplayAlerts, xroAutoSave, xroUseTemp]
    DataSources = <>
    Preview = False
    Params = <>
    OnBeforeWorkbookSave = xlReportBeforeWorkbookSave
    Left = 208
    Top = 12
  end
  object ZQXLReps: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 248
    Top = 13
  end
  object ZQXLRepsSum: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 280
    Top = 13
  end
  object DSRep: TDataSource
    DataSet = ZQXLRepsSum
    Left = 318
    Top = 11
  end
  object ZQXLReps2: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 248
    Top = 41
  end
  object ZQXLRepsSum2: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 280
    Top = 41
  end
  object DSRep2: TDataSource
    DataSet = ZQXLRepsSum2
    Left = 318
    Top = 43
  end
  object ZQXLReps3: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 248
    Top = 73
  end
  object ZQXLRepsSum3: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 280
    Top = 73
  end
  object DSRep3: TDataSource
    DataSet = ZQXLRepsSum3
    Left = 318
    Top = 75
  end
end
