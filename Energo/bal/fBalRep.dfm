object fBalansRep: TfBalansRep
  Left = 247
  Top = 197
  Width = 801
  Height = 530
  VertScrollBar.Position = 487
  Caption = 'fBalansRep'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object qrStationBalans: TQuickRep
    Left = -12
    Top = -487
    Width = 898
    Height = 635
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBalRoot
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poLandscape
    Page.PaperSize = A4
    Page.Values = (
      100
      2100
      100
      2970
      100
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 80
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object ColumnHeaderBand1: TQRBand
      Left = 30
      Top = 89
      Width = 838
      Height = 56
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        185.208333333333
        2771.51041666667)
      BandType = rbColumnHeader
      object QRShape2: TQRShape
        Left = 4
        Top = 8
        Width = 174
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          13.2291666666667
          26.4583333333333
          575.46875)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape3: TQRShape
        Left = 176
        Top = 8
        Width = 121
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.6822916666667
          582.083333333333
          26.4583333333333
          400.182291666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape4: TQRShape
        Left = 176
        Top = 32
        Width = 61
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          582.083333333333
          105.833333333333
          201.744791666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape5: TQRShape
        Left = 236
        Top = 32
        Width = 61
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          780.520833333333
          105.833333333333
          201.744791666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape7: TQRShape
        Left = 296
        Top = 8
        Width = 37
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          978.958333333333
          26.4583333333333
          122.369791666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape11: TQRShape
        Left = 416
        Top = 8
        Width = 73
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          1375.83333333333
          26.4583333333333
          241.432291666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape13: TQRShape
        Left = 332
        Top = 8
        Width = 85
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          1098.02083333333
          26.4583333333333
          281.119791666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel12: TQRLabel
        Left = 8
        Top = 22
        Width = 162
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          56.2239583333333
          26.4583333333333
          72.7604166666667
          535.78125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Ввод / фідер'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel14: TQRLabel
        Left = 184
        Top = 36
        Width = 46
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          608.541666666667
          119.0625
          152.135416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'початкові'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel15: TQRLabel
        Left = 248
        Top = 36
        Width = 33
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          820.208333333334
          119.0625
          109.140625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'кінцеві'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel20: TQRLabel
        Left = 424
        Top = 12
        Width = 61
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          1402.29166666667
          39.6875
          201.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корис. відпуск, кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel22: TQRLabel
        Left = 335
        Top = 12
        Width = 78
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          1107.94270833333
          39.6875
          257.96875)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Надходження електроенегії кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel23: TQRLabel
        Left = 204
        Top = 12
        Width = 61
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          674.6875
          39.6875
          201.744791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Показники'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel31: TQRLabel
        Left = 300
        Top = 16
        Width = 29
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          109.140625
          992.1875
          52.9166666666667
          95.9114583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розр. коеф. '
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape1: TQRShape
        Left = 488
        Top = 8
        Width = 130
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.6822916666667
          1613.95833333333
          26.4583333333333
          429.947916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape6: TQRShape
        Left = 488
        Top = 32
        Width = 82
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1613.95833333333
          105.833333333333
          271.197916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape14: TQRShape
        Left = 569
        Top = 32
        Width = 49
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1881.84895833333
          105.833333333333
          162.057291666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel1: TQRLabel
        Left = 497
        Top = 12
        Width = 105
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1643.72395833333
          39.6875
          347.265625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розрах. втрати'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel2: TQRLabel
        Left = 584
        Top = 36
        Width = 10
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1931.45833333333
          119.0625
          33.0729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '%'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel3: TQRLabel
        Left = 513
        Top = 36
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1696.640625
          119.0625
          135.598958333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape8: TQRShape
        Left = 616
        Top = 8
        Width = 135
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.6822916666667
          2037.29166666667
          26.4583333333333
          446.484375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape9: TQRShape
        Left = 616
        Top = 32
        Width = 82
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          2037.29166666667
          105.833333333333
          271.197916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape10: TQRShape
        Left = 697
        Top = 32
        Width = 54
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          2305.18229166667
          105.833333333333
          178.59375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel4: TQRLabel
        Left = 622
        Top = 12
        Width = 117
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2057.13541666667
          39.6875
          386.953125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Фактичні втрати (ТВЕ)'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel5: TQRLabel
        Left = 712
        Top = 36
        Width = 10
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2354.79166666667
          119.0625
          33.0729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '%'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel6: TQRLabel
        Left = 641
        Top = 36
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2119.97395833333
          119.0625
          135.598958333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape12: TQRShape
        Left = 750
        Top = 8
        Width = 83
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          2480.46875
          26.4583333333333
          274.505208333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel21: TQRLabel
        Left = 755
        Top = 12
        Width = 76
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          2497.00520833333
          39.6875
          251.354166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Різниця     факт-розрах, кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object TitleBand1: TQRBand
      Left = 30
      Top = 30
      Width = 838
      Height = 59
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        195.130208333333
        2771.51041666667)
      BandType = rbTitle
      object QRLabel9: TQRLabel
        Left = 295
        Top = 16
        Width = 245
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          975.651041666667
          52.9166666666667
          810.286458333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Баланс електроенергії по'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlStation: TQRLabel
        Left = 291
        Top = 28
        Width = 253
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          962.421875
          92.6041666666667
          836.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Station'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlMMGG: TQRLabel
        Left = 291
        Top = 44
        Width = 253
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          962.421875
          145.520833333333
          836.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'mmgg'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlResName: TQRLabel
        Left = 3
        Top = 1
        Width = 14
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          9.921875
          3.30729166666667
          46.3020833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'RES'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
    end
    object PageFooterBand1: TQRBand
      Left = 30
      Top = 318
      Width = 838
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        66.1458333333333
        2771.51041666667)
      BandType = rbPageFooter
      object QRSysData1: TQRSysData
        Left = 807
        Top = 4
        Width = 23
        Height = 9
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          29.765625
          2668.984375
          13.2291666666667
          76.0677083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        FontSize = -8
      end
    end
    object qrEntryFooter: TQRBand
      Left = 30
      Top = 193
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      BandType = rbGroupFooter
      object QRExpr1: TQRExpr
        Left = 338
        Top = 1
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          3.30729166666667
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(ktr_demand)'
        FontSize = -9
      end
    end
    object SummaryBand1: TQRBand
      Left = 30
      Top = 241
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      BandType = rbGroupFooter
      object QRExpr3: TQRExpr
        Left = 338
        Top = 2
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          6.61458333333333
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(f_ktr_demand)'
        FontSize = -9
      end
      object QRExpr4: TQRExpr
        Left = 422
        Top = 2
        Width = 66
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1395.67708333333
          6.61458333333333
          218.28125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(f_demand)'
        FontSize = -9
      end
      object QRExpr41: TQRExpr
        Left = 498
        Top = 2
        Width = 70
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1647.03125
          6.61458333333333
          231.510416666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(f_losts)'
        FontSize = -9
      end
      object QRExpr42: TQRExpr
        Left = 622
        Top = 2
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2057.13541666667
          6.61458333333333
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(f_real_losts)'
        FontSize = -9
      end
      object QRExpr94: TQRExpr
        Left = 754
        Top = 2
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2493.69791666667
          6.61458333333333
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(f_real_losts)-sum(f_losts)'
        FontSize = -9
      end
    end
    object QRSubDetail1: TQRSubDetail
      Left = 30
      Top = 177
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRSubDetail1BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      Master = qrStationBalans
      DataSet = ZQBalLev1_e
      PrintBefore = False
      PrintIfEmpty = True
      object QRExpr18: TQRExpr
        Left = 16
        Top = 1
        Width = 157
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          52.9166666666667
          3.30729166666667
          519.244791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'name'
        FontSize = 8
      end
      object QRExpr23: TQRExpr
        Left = 179
        Top = 1
        Width = 56
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          592.005208333333
          3.30729166666667
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'b_val'
        FontSize = 8
      end
      object QRExpr60: TQRExpr
        Left = 239
        Top = 1
        Width = 56
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          790.442708333333
          3.30729166666667
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'e_val'
        FontSize = 8
      end
      object QRExpr63: TQRExpr
        Left = 298
        Top = 1
        Width = 34
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          985.572916666667
          3.30729166666667
          112.447916666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'k_tr'
        FontSize = 8
      end
      object QRExpr66: TQRExpr
        Left = 338
        Top = 1
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          3.30729166666667
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        Master = QRSubDetail1
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'ktr_demand'
        FontSize = 8
      end
    end
    object QRSubDetail2: TQRSubDetail
      Left = 30
      Top = 225
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRSubDetail2BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      Master = qrStationBalans
      DataSet = ZQBalLev2
      PrintBefore = False
      PrintIfEmpty = True
      object QRDBText8: TQRExpr
        Left = 16
        Top = 1
        Width = 157
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          52.9166666666667
          3.30729166666667
          519.244791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_name'
        FontSize = -9
      end
      object QRDBText3: TQRExpr
        Left = 338
        Top = 1
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          3.30729166666667
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_ktr_demand'
        FontSize = -9
      end
      object QRDBText4: TQRExpr
        Left = 422
        Top = 1
        Width = 66
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1395.67708333333
          3.30729166666667
          218.28125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_demand'
        FontSize = -9
      end
      object QRDBText5: TQRExpr
        Left = 498
        Top = 1
        Width = 70
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1647.03125
          3.30729166666667
          231.510416666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_losts'
        FontSize = -9
      end
      object QRExpr12: TQRExpr
        Left = 575
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1901.69270833333
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand = 0,0, (f_losts/f_ktr_demand*100))'
        Mask = '0.00'
        FontSize = -9
      end
      object QRDBText6: TQRExpr
        Left = 622
        Top = 1
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2057.13541666667
          3.30729166666667
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts'
        FontSize = -9
      end
      object QRExpr13: TQRExpr
        Left = 703
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2325.02604166667
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand = 0,0, (f_real_losts/f_ktr_demand*100))'
        Mask = '0.00'
        FontSize = -9
      end
      object QRExpr93: TQRExpr
        Left = 754
        Top = 1
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2493.69791666667
          3.30729166666667
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts-f_losts'
        FontSize = -9
      end
    end
    object QRGroup1: TQRGroup
      Left = 30
      Top = 209
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup1BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      Expression = 'gr'
      FooterBand = SummaryBand1
      Master = QRSubDetail2
      ReprintOnNewPage = False
      object QRLabel18: TQRLabel
        Left = 4
        Top = 1
        Width = 34
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          49.609375
          13.2291666666667
          3.30729166666667
          112.447916666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Фидера'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
    end
    object QRGroup2: TQRGroup
      Left = 30
      Top = 161
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      Expression = 'gr2'
      FooterBand = qrEntryFooter
      Master = QRSubDetail1
      ReprintOnNewPage = False
      object QRLabel28: TQRLabel
        Left = 4
        Top = 1
        Width = 32
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          49.609375
          13.2291666666667
          3.30729166666667
          105.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Вводы'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
    end
    object QRStBalSum: TQRBand
      Left = 30
      Top = 271
      Width = 838
      Height = 47
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRStBalSumBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        155.442708333333
        2771.51041666667)
      BandType = rbSummary
      object QRLabel33: TQRLabel
        Left = 228
        Top = 18
        Width = 109
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          754.0625
          59.53125
          360.494791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Баланс шин підстанції кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
      object QRLabel34: TQRLabel
        Left = 319
        Top = 32
        Width = 7
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1055.02604166667
          105.833333333333
          23.1510416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
      object qrBalPS: TQRLabel
        Left = 338
        Top = 18
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          59.53125
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '---'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
      object qrBalPSpr: TQRLabel
        Left = 338
        Top = 32
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          105.833333333333
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '---'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
      object qrlAbonDem: TQRLabel
        Left = 338
        Top = 2
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          6.61458333333333
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '---'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
      object QRLabel7: TQRLabel
        Left = 76
        Top = 2
        Width = 245
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          251.354166666667
          6.61458333333333
          810.286458333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Спожито абонентами безпосередньо з шин підстанції, кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
    end
    object QRMain: TQRBand
      Left = 30
      Top = 145
      Width = 838
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2771.51041666667)
      BandType = rbDetail
      object QRExpr2: TQRExpr
        Left = 16
        Top = 1
        Width = 157
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          52.9166666666667
          3.30729166666667
          519.244791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_name'
        FontSize = -9
      end
      object QRExpr11: TQRExpr
        Left = 338
        Top = 1
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          3.30729166666667
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_ktr_demand'
        FontSize = -9
      end
      object QRExpr68: TQRExpr
        Left = 422
        Top = 1
        Width = 66
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1395.67708333333
          3.30729166666667
          218.28125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_demand'
        FontSize = -9
      end
      object QRExpr69: TQRExpr
        Left = 498
        Top = 1
        Width = 70
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1647.03125
          3.30729166666667
          231.510416666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_losts'
        FontSize = -9
      end
      object QRExpr70: TQRExpr
        Left = 575
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1901.69270833333
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand = 0,0, (f_losts/f_ktr_demand*100))'
        Mask = '0.00'
        FontSize = -9
      end
      object QRExpr71: TQRExpr
        Left = 622
        Top = 1
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2057.13541666667
          3.30729166666667
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts'
        FontSize = -9
      end
      object QRExpr75: TQRExpr
        Left = 703
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2325.02604166667
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand = 0,0, (f_real_losts/f_ktr_demand*100))'
        Mask = '0.00'
        FontSize = -9
      end
      object QRExpr76: TQRExpr
        Left = 754
        Top = 1
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          2493.69791666667
          3.30729166666667
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrStationBalans
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts-f_losts'
        FontSize = -9
      end
    end
    object QRsdMeters: TQRSubDetail
      Left = 30
      Top = 257
      Width = 838
      Height = 14
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        46.3020833333333
        2771.51041666667)
      Master = qrStationBalans
      DataSet = ZQBalMeters
      PrintBefore = False
      PrintIfEmpty = True
      object QRExpr77: TQRExpr
        Left = 24
        Top = 1
        Width = 149
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          79.375
          3.30729166666667
          492.786458333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'm_num_eqp'
        FontSize = -9
      end
      object QRExpr78: TQRExpr
        Left = 179
        Top = 1
        Width = 56
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          592.005208333333
          3.30729166666667
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'm_b_val'
        FontSize = -9
      end
      object QRExpr79: TQRExpr
        Left = 239
        Top = 1
        Width = 56
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          790.442708333333
          3.30729166666667
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'm_e_val'
        FontSize = -9
      end
      object QRExpr80: TQRExpr
        Left = 298
        Top = 1
        Width = 34
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          985.572916666667
          3.30729166666667
          112.447916666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'm_k_tr'
        FontSize = -9
      end
      object QRExpr81: TQRExpr
        Left = 338
        Top = 1
        Width = 78
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1117.86458333333
          3.30729166666667
          257.96875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        Color = clWhite
        Master = QRSubDetail2
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'm_ktr_demand'
        FontSize = -9
      end
    end
  end
  object qrTreeDemand: TQuickRep
    Left = 927
    Top = -485
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQTreeDemand
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      100
      2970
      100
      2100
      50
      50
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand1: TQRBand
      Left = 19
      Top = 117
      Width = 756
      Height = 62
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        164.041666666667
        2000.25)
      BandType = rbColumnHeader
      object QRShape22: TQRShape
        Left = 0
        Top = 0
        Width = 60
        Height = 61
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          161.395833333333
          0
          0
          158.75)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape17: TQRShape
        Left = 419
        Top = 24
        Width = 88
        Height = 38
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          99.21875
          1107.94270833333
          62.8385416666667
          231.510416666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape23: TQRShape
        Left = 419
        Top = 0
        Width = 329
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          1107.94270833333
          0
          869.817708333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape15: TQRShape
        Left = 50
        Top = 0
        Width = 311
        Height = 61
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          161.395833333333
          132.291666666667
          0
          822.854166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel10: TQRLabel
        Left = 55
        Top = 17
        Width = 298
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          55.5625
          145.520833333333
          44.9791666666667
          788.458333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Назва споживача'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel16: TQRLabel
        Left = 480
        Top = 5
        Width = 216
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1270
          13.2291666666667
          572.161458333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск, кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel24: TQRLabel
        Left = 10
        Top = 20
        Width = 36
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          26.4583333333333
          52.9166666666667
          95.9114583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Л/Р'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape24: TQRShape
        Left = 585
        Top = 24
        Width = 81
        Height = 38
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          99.21875
          1547.8125
          62.8385416666667
          214.973958333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape25: TQRShape
        Left = 665
        Top = 24
        Width = 82
        Height = 38
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          99.21875
          1759.47916666667
          62.8385416666667
          218.28125)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel26: TQRLabel
        Left = 670
        Top = 28
        Width = 71
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1772.70833333333
          72.7604166666667
          188.515625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Поточний місяць'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel27: TQRLabel
        Left = 587
        Top = 28
        Width = 76
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1554.42708333333
          72.7604166666667
          201.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Минулий місяць'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape16: TQRShape
        Left = 505
        Top = 24
        Width = 81
        Height = 38
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          99.21875
          1336.14583333333
          62.8385416666667
          214.973958333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel11: TQRLabel
        Left = 508
        Top = 28
        Width = 76
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1342.76041666667
          72.7604166666667
          201.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Позамину- лий місяць'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel13: TQRLabel
        Left = 428
        Top = 28
        Width = 76
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1131.09375
          72.7604166666667
          201.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Цей місяць мин. року'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape19: TQRShape
        Left = 360
        Top = 0
        Width = 60
        Height = 61
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          161.395833333333
          952.5
          0
          158.75)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel8: TQRLabel
        Left = 364
        Top = 12
        Width = 53
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          97.8958333333333
          963.083333333333
          31.75
          140.229166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'потуж- ність'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
    end
    object QRBand2: TQRBand
      Left = 19
      Top = 38
      Width = 756
      Height = 79
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        209.020833333333
        2000.25)
      BandType = rbTitle
      object QRLabel32: TQRLabel
        Left = 146
        Top = 21
        Width = 491
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          386.953125
          56.2239583333333
          1299.765625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск електроенергії'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlStation2: TQRLabel
        Left = 225
        Top = 41
        Width = 316
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          595.3125
          108.479166666667
          836.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Station'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object qrlMMGG2: TQRLabel
        Left = 225
        Top = 59
        Width = 316
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          595.3125
          156.104166666667
          836.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'mmgg'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object qrlResName2: TQRLabel
        Left = 5
        Top = 1
        Width = 18
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          13.2291666666667
          2.64583333333333
          47.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'RES'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
    end
    object QRBand3: TQRBand
      Left = 19
      Top = 433
      Width = 756
      Height = 15
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        39.6875
        2000.25)
      BandType = rbPageFooter
      object QRSysData2: TQRSysData
        Left = 711
        Top = 1
        Width = 33
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1881.1875
          2.64583333333333
          87.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        FontSize = -9
      end
    end
    object QRBand4: TQRBand
      Left = 19
      Top = 400
      Width = 756
      Height = 14
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = 11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        37.0416666666667
        2000.25)
      BandType = rbDetail
      object QRExpr21: TQRExpr
        Left = 65
        Top = 0
        Width = 296
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          171.979166666667
          0
          783.166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'abon_name'
        FontSize = -8
      end
      object QRExpr22: TQRExpr
        Left = 5
        Top = 0
        Width = 44
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          13.2291666666667
          0
          115.755208333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'code'
        FontSize = -8
      end
      object QRExpr17: TQRExpr
        Left = 667
        Top = 0
        Width = 78
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1764.77083333333
          0
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'demand_0'
        FontSize = -8
      end
      object QRExpr14: TQRExpr
        Left = 590
        Top = 0
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1561.04166666667
          0
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'demand_1'
        FontSize = -9
      end
      object QRExpr15: TQRExpr
        Left = 510
        Top = 0
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1349.375
          0
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'demand_2'
        FontSize = -8
      end
      object QRExpr19: TQRExpr
        Left = 430
        Top = 0
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1137.70833333333
          0
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'demand_12'
        FontSize = -8
      end
      object QRExpr8: TQRExpr
        Left = 368
        Top = 0
        Width = 57
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          973.666666666667
          0
          150.8125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'power'
        Mask = '0.00'
        FontSize = -8
      end
    end
    object QRGroup_f110: TQRGroup
      Left = 19
      Top = 179
      Width = 756
      Height = 28
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        74.0833333333333
        2000.25)
      Expression = 'f110'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr20: TQRExpr
        Left = 6
        Top = 1
        Width = 85
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          55.5625
          15.875
          2.64583333333333
          224.895833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 21
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f110_name'
        FontSize = -16
      end
      object QRExpr59: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f110_dem'
        FontSize = -9
      end
    end
    object QRGroup_s110: TQRGroup
      Left = 19
      Top = 207
      Width = 756
      Height = 26
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        68.7916666666667
        2000.25)
      Expression = 's110'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr24: TQRExpr
        Left = 12
        Top = 1
        Width = 88
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          31.75
          2.64583333333333
          232.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 19
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's110_name'
        FontSize = -14
      end
      object QRExpr72: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's110_dem'
        FontSize = -9
      end
    end
    object QRGroup_e110: TQRGroup
      Left = 19
      Top = 233
      Width = 756
      Height = 26
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        68.7916666666667
        2000.25)
      Expression = 'e110'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr25: TQRExpr
        Left = 19
        Top = 1
        Width = 88
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          50.2708333333333
          2.64583333333333
          232.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 19
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e110_name'
        FontSize = -14
      end
      object QRExpr61: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e110_dem'
        FontSize = -9
      end
    end
    object QRGroup_f35: TQRGroup
      Left = 19
      Top = 259
      Width = 756
      Height = 26
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        68.7916666666667
        2000.25)
      Expression = 'f35'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr26: TQRExpr
        Left = 25
        Top = 1
        Width = 66
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          66.1458333333333
          2.64583333333333
          174.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 19
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f35_name'
        FontSize = -14
      end
      object QRExpr62: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f35_dem'
        FontSize = -9
      end
    end
    object QRGroup_s35: TQRGroup
      Left = 19
      Top = 285
      Width = 756
      Height = 22
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        58.2083333333333
        2000.25)
      Expression = 's35'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr27: TQRExpr
        Left = 31
        Top = 1
        Width = 71
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          82.0208333333333
          2.64583333333333
          187.854166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 17
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's35_name'
        FontSize = -13
      end
      object QRExpr73: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's35_dem'
        FontSize = -9
      end
    end
    object QRGroup_e35: TQRGroup
      Left = 19
      Top = 307
      Width = 756
      Height = 22
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        58.2083333333333
        2000.25)
      Expression = 'e35'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr28: TQRExpr
        Left = 38
        Top = 1
        Width = 63
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          100.541666666667
          2.64583333333333
          166.6875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e35_name'
        FontSize = -12
      end
      object QRExpr64: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e35_dem'
        FontSize = -9
      end
    end
    object QRGroup_f10: TQRGroup
      Left = 19
      Top = 329
      Width = 756
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        2000.25)
      Expression = 'f10'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr29: TQRExpr
        Left = 44
        Top = 1
        Width = 52
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          116.416666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f10_name'
        FontSize = -11
      end
      object QRExpr65: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f10_dem'
        FontSize = -9
      end
    end
    object QRGroup_s10: TQRGroup
      Left = 19
      Top = 349
      Width = 756
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        2000.25)
      Expression = 's10'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr30: TQRExpr
        Left = 50
        Top = 1
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          132.291666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_name'
        FontSize = -9
      end
      object QRExpr74: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_dem'
        FontSize = -9
      end
    end
    object QRGroup_e10: TQRGroup
      Left = 19
      Top = 366
      Width = 756
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        2000.25)
      Expression = 'e10'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr31: TQRExpr
        Left = 56
        Top = 1
        Width = 52
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          148.166666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e10_name'
        FontSize = -9
      end
      object QRExpr67: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e10_dem'
        FontSize = -9
      end
    end
    object QRGroup_f04: TQRGroup
      Left = 19
      Top = 383
      Width = 756
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup_BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        2000.25)
      Expression = 'f04'
      Master = qrTreeDemand
      ReprintOnNewPage = False
      object QRExpr16: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f04_dem'
        FontSize = -9
      end
      object QRExpr32: TQRExpr
        Left = 62
        Top = 1
        Width = 49
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          164.041666666667
          2.64583333333333
          129.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f04_name'
        FontSize = -9
      end
    end
    object SummaryBand2: TQRBand
      Left = 19
      Top = 414
      Width = 756
      Height = 19
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        50.2708333333333
        2000.25)
      BandType = rbSummary
      object QRShape26: TQRShape
        Left = 0
        Top = 0
        Width = 753
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          0
          0
          1992.3125)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRExpr9: TQRExpr
        Left = 368
        Top = 1
        Width = 57
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          973.666666666667
          2.64583333333333
          150.8125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(power)'
        Mask = '0.00'
        FontSize = -8
      end
      object QRExpr10: TQRExpr
        Left = 430
        Top = 1
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1137.70833333333
          2.64583333333333
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(demand_12)'
        FontSize = -8
      end
      object QRExpr82: TQRExpr
        Left = 510
        Top = 1
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1349.375
          2.64583333333333
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(demand_2)'
        FontSize = -8
      end
      object QRExpr83: TQRExpr
        Left = 590
        Top = 1
        Width = 75
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1561.04166666667
          2.64583333333333
          198.4375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(demand_1)'
        FontSize = -9
      end
      object QRExpr84: TQRExpr
        Left = 667
        Top = 1
        Width = 78
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1764.77083333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'sum(demand_0)'
        FontSize = -8
      end
      object QRLabel29: TQRLabel
        Left = 8
        Top = 0
        Width = 46
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          21.1666666666667
          0
          121.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Всього'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
  end
  object qrTreeLosts: TQuickRep
    Left = 23
    Top = 19
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQTreeLosts
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      100
      2970
      100
      2100
      100
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand5: TQRBand
      Left = 38
      Top = 103
      Width = 718
      Height = 24
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        63.5
        1899.70833333333)
      BandType = rbColumnHeader
      object QRShape20: TQRShape
        Left = 192
        Top = 1
        Width = 328
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          508
          2.64583333333333
          867.833333333334)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel42: TQRLabel
        Left = 226
        Top = 5
        Width = 256
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          597.958333333333
          13.2291666666667
          677.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Назва устаткування'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape32: TQRShape
        Left = 519
        Top = 1
        Width = 192
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          1373.1875
          2.64583333333333
          508)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel48: TQRLabel
        Left = 535
        Top = 4
        Width = 165
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          1415.52083333333
          10.5833333333333
          436.5625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розрахункові втрати кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape18: TQRShape
        Left = 5
        Top = 1
        Width = 188
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          60.8541666666667
          13.2291666666667
          2.64583333333333
          497.416666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel43: TQRLabel
        Left = 15
        Top = 5
        Width = 158
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          39.6875
          13.2291666666667
          418.041666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Назва об'#39'єкту'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
    end
    object QRBand7: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 65
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        171.979166666667
        1899.70833333333)
      BandType = rbTitle
      object QRLabel53: TQRLabel
        Left = 130
        Top = 21
        Width = 451
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          343.958333333333
          55.5625
          1193.27083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розрахункові втрати електроенергії по'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlStation3: TQRLabel
        Left = 194
        Top = 36
        Width = 316
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          513.291666666667
          95.25
          836.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Station'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlMMGG3: TQRLabel
        Left = 194
        Top = 50
        Width = 316
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          513.291666666667
          132.291666666667
          836.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'mmgg'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlResName3: TQRLabel
        Left = 4
        Top = 0
        Width = 18
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          10.5833333333333
          0
          47.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'RES'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -9
      end
    end
    object QRBand8: TQRBand
      Left = 38
      Top = 333
      Width = 718
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1899.70833333333)
      BandType = rbPageFooter
      object QRSysData3: TQRSysData
        Left = 984
        Top = 20
        Width = 8
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          2603.5
          52.9166666666667
          21.1666666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        FontSize = 10
      end
      object QRSysData4: TQRSysData
        Left = 654
        Top = 2
        Width = 46
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1730.375
          5.29166666666667
          121.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        Color = clWhite
        Data = qrsPageNumber
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        FontSize = 10
      end
    end
    object QRBand9: TQRBand
      Left = 38
      Top = 320
      Width = 718
      Height = 13
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        34.3958333333333
        1899.70833333333)
      BandType = rbDetail
      object QRExpr33: TQRExpr
        Left = 191
        Top = 0
        Width = 326
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          505.354166666667
          0
          862.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'name_eqp'
        FontSize = -8
      end
      object QRExpr38: TQRExpr
        Left = 559
        Top = 0
        Width = 142
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1479.02083333333
          0
          375.708333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'lst'
        FontSize = -8
      end
    end
    object QRGroup2_f110: TQRGroup
      Left = 38
      Top = 127
      Width = 718
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1899.70833333333)
      Expression = 'f110_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr34: TQRExpr
        Left = 561
        Top = 1
        Width = 139
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1484.3125
          2.64583333333333
          367.770833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f110_lost'
        FontSize = -9
      end
      object QRExpr5: TQRExpr
        Left = 5
        Top = 1
        Width = 62
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          13.2291666666667
          2.64583333333333
          164.041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f110_name'
        FontSize = -12
      end
    end
    object QRGroup2_s110: TQRGroup
      Left = 38
      Top = 147
      Width = 718
      Height = 19
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        50.2708333333333
        1899.70833333333)
      Expression = 's110_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr35: TQRExpr
        Left = 561
        Top = 1
        Width = 139
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1484.3125
          2.64583333333333
          367.770833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's110_lost'
        FontSize = -9
      end
      object QRExpr6: TQRExpr
        Left = 10
        Top = 1
        Width = 71
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          2.64583333333333
          187.854166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's110_name'
        FontSize = -12
      end
    end
    object QRGroup2_e110: TQRGroup
      Left = 38
      Top = 166
      Width = 718
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1899.70833333333)
      Expression = 'e110_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr36: TQRExpr
        Left = 561
        Top = 1
        Width = 139
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1484.3125
          2.64583333333333
          367.770833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e110_lost'
        FontSize = -9
      end
      object QRExpr7: TQRExpr
        Left = 15
        Top = 1
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          39.6875
          2.64583333333333
          185.208333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e110_name'
        FontSize = -12
      end
    end
    object QRGroup2_f35: TQRGroup
      Left = 38
      Top = 186
      Width = 718
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        1899.70833333333)
      Expression = 'f35_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr37: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f35_lost'
        FontSize = -9
      end
      object QRExpr43: TQRExpr
        Left = 20
        Top = 1
        Width = 52
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          52.9166666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f35_name'
        FontSize = -11
      end
    end
    object QRGroup2_s35: TQRGroup
      Left = 38
      Top = 203
      Width = 718
      Height = 20
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1899.70833333333)
      Expression = 's35_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr39: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's35_lost'
        FontSize = -9
      end
      object QRExpr44: TQRExpr
        Left = 25
        Top = 1
        Width = 61
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          66.1458333333333
          2.64583333333333
          161.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 15
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's35_name'
        FontSize = -11
      end
    end
    object QRGroup2_e35: TQRGroup
      Left = 38
      Top = 223
      Width = 718
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        1899.70833333333)
      Expression = 'e35_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr40: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e35_lost'
        FontSize = -9
      end
      object QRExpr45: TQRExpr
        Left = 30
        Top = 1
        Width = 55
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          79.375
          2.64583333333333
          145.520833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e35_name'
        FontSize = -10
      end
    end
    object QRGroup2_f10: TQRGroup
      Left = 38
      Top = 240
      Width = 718
      Height = 18
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        47.625
        1899.70833333333)
      Expression = 'f10_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr56: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f10_lost'
        FontSize = -9
      end
      object QRExpr47: TQRExpr
        Left = 35
        Top = 1
        Width = 52
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          92.6041666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f10_name'
        FontSize = -10
      end
    end
    object QRGroup2_s10: TQRGroup
      Left = 38
      Top = 272
      Width = 718
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_s10BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        44.9791666666667
        1899.70833333333)
      Expression = 's10_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr57: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_lost'
        FontSize = -9
      end
      object QRExpr48: TQRExpr
        Left = 40
        Top = 1
        Width = 52
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          105.833333333333
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_name'
        FontSize = -9
      end
      object QRExpr_datb: TQRExpr
        Left = 409
        Top = 1
        Width = 66
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1082.14583333333
          2.64583333333333
          174.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_dat_b'
        FontSize = -9
      end
      object QRExpr_date: TQRExpr
        Left = 481
        Top = 1
        Width = 66
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1272.64583333333
          2.64583333333333
          174.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 's10_dat_e'
        FontSize = -9
      end
    end
    object QRGroup2_e10: TQRGroup
      Left = 38
      Top = 289
      Width = 718
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        42.3333333333333
        1899.70833333333)
      Expression = 'e10_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr58: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e10_lost'
        FontSize = -9
      end
      object QRExpr49: TQRExpr
        Left = 45
        Top = 1
        Width = 52
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          119.0625
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'e10_name'
        FontSize = -9
      end
    end
    object QRGroup2_f04: TQRGroup
      Left = 38
      Top = 305
      Width = 718
      Height = 15
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = True
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2_f110BeforePrint
      Color = clInfoBk
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        39.6875
        1899.70833333333)
      Expression = 'f04_key'
      Master = qrTreeLosts
      ReprintOnNewPage = False
      object QRExpr52: TQRExpr
        Left = 748
        Top = 15
        Width = 88
        Height = 17
        Enabled = False
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1979.08333333333
          39.6875
          232.833333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_losts'
        FontSize = 10
      end
      object QRExpr53: TQRExpr
        Left = 849
        Top = 15
        Width = 51
        Height = 17
        Enabled = False
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          2246.3125
          39.6875
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand = 0,0, (f_losts/f_ktr_demand*100))'
        FontSize = 10
      end
      object QRExpr54: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f04_lost'
        FontSize = -9
      end
      object QRExpr46: TQRExpr
        Left = 50
        Top = 1
        Width = 49
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          132.291666666667
          2.64583333333333
          129.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'f04_name'
        FontSize = -9
      end
    end
    object ChildBand1: TQRChildBand
      Left = 38
      Top = 258
      Width = 718
      Height = 14
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRF10ChildBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        37.0416666666667
        1899.70833333333)
      ParentBand = QRGroup2_f10
      object QRLabel17: TQRLabel
        Left = 40
        Top = 1
        Width = 127
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          105.833333333333
          2.64583333333333
          336.020833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Коефіцієнт донарахування втрат у лініях 0.4 кВ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRExpr50: TQRExpr
        Left = 252
        Top = 1
        Width = 23
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          666.75
          2.64583333333333
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial Narrow'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f10_coef'
        FontSize = -8
      end
      object QRExpr51: TQRExpr
        Left = 559
        Top = 1
        Width = 141
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1479.02083333333
          2.64583333333333
          373.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f10_lost-fact_losts'
        FontSize = -8
      end
      object QRLabel19: TQRLabel
        Left = 504
        Top = 1
        Width = 50
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1333.5
          2.64583333333333
          132.291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Донараховано'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRExpr55: TQRExpr
        Left = 408
        Top = 1
        Width = 27
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          1079.5
          2.64583333333333
          71.4375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial Narrow'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'demand04'
        FontSize = -8
      end
      object QRLabel25: TQRLabel
        Left = 320
        Top = 1
        Width = 52
        Height = 12
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          31.75
          846.666666666667
          2.64583333333333
          137.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Споживання 0.4 кВ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
  end
  object qrSummBal: TQuickRep
    Left = 898
    Top = 148
    Width = 635
    Height = 898
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQSummBal
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE')
    Functions.DATA = (
      '0'
      '0'
      #39#39)
    Options = [FirstPageHeader, LastPageFooter]
    Page.Columns = 1
    Page.Orientation = poPortrait
    Page.PaperSize = A4
    Page.Values = (
      100
      2970
      100
      2100
      100
      100
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = False
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = True
    SnapToGrid = True
    Units = MM
    Zoom = 80
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand6: TQRBand
      Left = 30
      Top = 81
      Width = 575
      Height = 56
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        185.208333333333
        1901.69270833333)
      BandType = rbColumnHeader
      object QRShape34: TQRShape
        Left = 128
        Top = 4
        Width = 104
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          423.333333333333
          13.2291666666667
          343.958333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape36: TQRShape
        Left = 16
        Top = 4
        Width = 116
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          52.9166666666667
          13.2291666666667
          383.645833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel38: TQRLabel
        Left = 148
        Top = 8
        Width = 60
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          489.479166666667
          26.4583333333333
          198.4375)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск, кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel40: TQRLabel
        Left = 39
        Top = 8
        Width = 78
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          128.984375
          26.4583333333333
          257.96875)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Надходження електроенергії кВтг'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape37: TQRShape
        Left = 228
        Top = 4
        Width = 130
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.6822916666667
          754.0625
          13.2291666666667
          429.947916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape38: TQRShape
        Left = 228
        Top = 28
        Width = 82
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          754.0625
          92.6041666666667
          271.197916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape39: TQRShape
        Left = 309
        Top = 28
        Width = 49
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1021.953125
          92.6041666666667
          162.057291666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel45: TQRLabel
        Left = 237
        Top = 8
        Width = 105
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          783.828125
          26.4583333333333
          347.265625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розрахункові втрати'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel46: TQRLabel
        Left = 324
        Top = 32
        Width = 10
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1071.5625
          105.833333333333
          33.0729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '%'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel47: TQRLabel
        Left = 253
        Top = 32
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          836.744791666667
          105.833333333333
          135.598958333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape40: TQRShape
        Left = 356
        Top = 4
        Width = 130
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.6822916666667
          1177.39583333333
          13.2291666666667
          429.947916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape41: TQRShape
        Left = 356
        Top = 28
        Width = 82
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1177.39583333333
          92.6041666666667
          271.197916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape42: TQRShape
        Left = 437
        Top = 28
        Width = 49
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          1445.28645833333
          92.6041666666667
          162.057291666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel49: TQRLabel
        Left = 362
        Top = 8
        Width = 117
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1197.23958333333
          26.4583333333333
          386.953125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Фактичні втрати (ТВЕ)'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel50: TQRLabel
        Left = 452
        Top = 32
        Width = 10
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1494.89583333333
          105.833333333333
          33.0729166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '%'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel51: TQRLabel
        Left = 381
        Top = 32
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1260.078125
          105.833333333333
          135.598958333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape21: TQRShape
        Left = 483
        Top = 4
        Width = 82
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          1597.421875
          13.2291666666667
          271.197916666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel35: TQRLabel
        Left = 487
        Top = 8
        Width = 76
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          135.598958333333
          1610.65104166667
          26.4583333333333
          251.354166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Різниця     факт-розрах, кВтг'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRBand10: TQRBand
      Left = 30
      Top = 30
      Width = 575
      Height = 51
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        168.671875
        1901.69270833333)
      BandType = rbTitle
      object QRLabel52: TQRLabel
        Left = 79
        Top = 4
        Width = 421
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          261.276041666667
          13.2291666666667
          1392.36979166667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Звіт про сукупні фактичні й нормативні втрати  в розподільчій ме' +
          'режі'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlResName4: TQRLabel
        Left = 91
        Top = 20
        Width = 401
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          300.963541666667
          66.1458333333333
          1326.22395833333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'RES'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object qrlMMGG4: TQRLabel
        Left = 163
        Top = 36
        Width = 253
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          539.088541666667
          119.0625
          836.744791666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'mmgg'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
    end
    object QRBand11: TQRBand
      Left = 30
      Top = 153
      Width = 575
      Height = 17
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        56.2239583333333
        1901.69270833333)
      BandType = rbPageFooter
    end
    object QRBand12: TQRBand
      Left = 30
      Top = 137
      Width = 575
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        52.9166666666667
        1901.69270833333)
      BandType = rbDetail
      object QRExpr89: TQRExpr
        Left = 21
        Top = 1
        Width = 108
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          69.453125
          3.30729166666667
          357.1875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_ktr_demand1'
        FontSize = -10
      end
      object QRExpr90: TQRExpr
        Left = 138
        Top = 1
        Width = 86
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          456.40625
          3.30729166666667
          284.427083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_demand1'
        FontSize = -10
      end
      object QRExpr91: TQRExpr
        Left = 230
        Top = 1
        Width = 70
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          760.677083333333
          3.30729166666667
          231.510416666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_losts1'
        FontSize = -10
      end
      object QRExpr92: TQRExpr
        Left = 358
        Top = 1
        Width = 74
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1184.01041666667
          3.30729166666667
          244.739583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts1'
        FontSize = -10
      end
      object QRExpr96: TQRExpr
        Left = 311
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1028.56770833333
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand1 = 0,0, (f_losts1/f_ktr_demand1*100))'
        FontSize = -10
      end
      object QRExpr97: TQRExpr
        Left = 439
        Top = 1
        Width = 41
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1451.90104166667
          3.30729166666667
          135.598958333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(f_ktr_demand1 = 0,0, (f_real_losts1/f_ktr_demand1*100))'
        FontSize = -10
      end
      object QRExpr87: TQRExpr
        Left = 487
        Top = 1
        Width = 73
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.9947916666667
          1610.65104166667
          3.30729166666667
          241.432291666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        Master = qrSummBal
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'f_real_losts1-f_losts1'
        FontSize = -10
      end
    end
  end
  object ZQPrepare: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      ''
      ' ')
    RequestLive = False
    Left = 551
    Top = 2
  end
  object ZQTreeDemand: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <
      item
        DataType = ftUnknown
        Name = 'lev1'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev2'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev3'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev4'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev5'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev6'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev7'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev8'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev9'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev10'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'order_val'
        ParamType = ptUnknown
      end>
    Sql.Strings = (
      'select * from ('
      'select'
      '%lev1'
      '%lev2'
      '%lev3'
      '%lev4'
      '%lev5'
      '%lev6'
      '%lev7'
      '%lev8'
      '%lev9'
      '%lev10'
      
        'bigsel2.abon_name,bigsel2.code,bigsel2.power,bigsel2.demand_0, b' +
        'igsel2.demand_1,bigsel2.demand_2,bigsel2.demand_12'
      ' from'
      '('
      'select'
      
        's1.code_eqp as gr_1,s1.type_eqp as type1,s1.id_voltage as volt1,' +
        's1.name as name1,s1.demand as dem1,s1.ktr_demand as ktr_dem1,'
      
        's2.code_eqp as gr_2,s2.type_eqp as type2,s2.id_voltage as volt2,' +
        's2.name as name2,s2.demand as dem2,s2.ktr_demand as ktr_dem2,'
      
        's3.code_eqp as gr_3,s3.type_eqp as type3,s3.id_voltage as volt3,' +
        's3.name as name3,s3.demand as dem3,s3.ktr_demand as ktr_dem3,'
      
        's4.code_eqp as gr_4,s4.type_eqp as type4,s4.id_voltage as volt4,' +
        's4.name as name4,s4.demand as dem4,s4.ktr_demand as ktr_dem4,'
      
        's5.code_eqp as gr_5,s5.type_eqp as type5,s5.id_voltage as volt5,' +
        's5.name as name5,s5.demand as dem5,s5.ktr_demand as ktr_dem5,'
      
        's6.code_eqp as gr_6,s6.type_eqp as type6,s6.id_voltage as volt6,' +
        's6.name as name6,s6.demand as dem6,s6.ktr_demand as ktr_dem6,'
      
        's7.code_eqp as gr_7,s7.type_eqp as type7,s7.id_voltage as volt7,' +
        's7.name as name7,s7.demand as dem7,s7.ktr_demand as ktr_dem7,'
      
        's8.code_eqp as gr_8,s8.type_eqp as type8,s8.id_voltage as volt8,' +
        's8.name as name8,s8.demand as dem8,s8.ktr_demand as ktr_dem8,'
      
        's9.code_eqp as gr_9,s9.type_eqp as type9,s9.id_voltage as volt9,' +
        's9.name as name9,s9.demand as dem9,s9.ktr_demand as ktr_dem9,'
      
        's10.code_eqp as gr_10,s10.type_eqp as type10,s10.id_voltage as v' +
        'olt10,s10.name as name10,s10.demand as dem10,s10.ktr_demand as k' +
        'tr_dem10'
      
        'from (bal_grp_tree_tmp  left join bal_demand_tmp using (mmgg,id_' +
        'point)) as s1'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s2 o' +
        'n (s2.id_p_eqp=s1.code_eqp or s2.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s3 o' +
        'n (s3.id_p_eqp=s2.code_eqp or s3.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s4 o' +
        'n (s4.id_p_eqp=s3.code_eqp or s4.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s5 o' +
        'n (s5.id_p_eqp=s4.code_eqp or s5.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s6 o' +
        'n (s6.id_p_eqp=s5.code_eqp or s6.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s7 o' +
        'n (s7.id_p_eqp=s6.code_eqp or s7.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s8 o' +
        'n (s8.id_p_eqp=s7.code_eqp or s8.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s9 o' +
        'n (s9.id_p_eqp=s8.code_eqp or s9.code_eqp is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,ktr_demand from bal_grp_tree_tmp left join bal_demand_t' +
        'mp using (mmgg,id_point) where type_eqp<>12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null) as s10 ' +
        'on (s10.id_p_eqp=s9.code_eqp or s10.code_eqp is null)'
      'where s1.code_eqp=:code_eqp and s1.mmgg= :mmgg'
      
        'order by gr_1 desc,gr_2 desc,gr_3 desc,gr_4 desc,gr_5 desc,gr_6 ' +
        'desc,gr_7 desc,gr_8 desc,gr_9 desc,gr_10 desc'
      ') as bigsel'
      'join'
      '('
      
        'select p.id_p_eqp,clm.short_name as abon_name,clm.code,sum(p.dem' +
        'and)::::numeric as demand_0,sum(p1.demand)::::numeric as demand_' +
        '1,'
      
        'sum(p2.demand)::::numeric as demand_2,sum(p12.demand)::::numeric' +
        ' as demand_12, sum(mp.power)::::numeric as power'
      'from bal_grp_tree_tmp as p'
      'join clm_client_tbl as clm on (p.id_client = clm.id)'
      
        'left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::' +
        'date-'#39'1 month'#39'::::interval and type_eqp=12 and id_bal = :res ord' +
        'er by id_point) as p1 on (p1.id_point=p.id_point )'
      
        'left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::' +
        'date-'#39'2 month'#39'::::interval and type_eqp=12 and id_bal = :res ord' +
        'er by id_point) as p2 on (p2.id_point=p.id_point )'
      
        'left join (select * from bal_grp_tree_tbl where mmgg = :mmgg::::' +
        'date-'#39'12 month'#39'::::interval and type_eqp=12 and id_bal = :res or' +
        'der by id_point) as p12 on (p12.id_point=p.id_point )'
      'left join eqm_point_tbl as mp on (mp.code_eqp = p.id_point)'
      'where p.type_eqp=12 and p.mmgg = :mmgg and clm.book = -1'
      'group by p.id_p_eqp,clm.short_name,clm.code'
      'union'
      
        'select f0.id_p_eqp, f0.abon_name,f0.code,demand_0, demand_1, dem' +
        'and_2,demand_12, 0 as power  from'
      
        '(select '#39'Бытовые потребители ('#39'||text(coalesce(sum(cc.fiz_count)' +
        ',0))||'#39')'#39'::::varchar as abon_name,0 as code,sum(p.demand)::::int' +
        ' as demand_0,p.id_p_eqp'
      ' from bal_grp_tree_tmp as p'
      
        ' left join bal_acc_tmp as cc on (p.code_eqp = cc.code_eqp and p.' +
        'mmgg = cc.mmgg)'
      ' where p.type_eqp=12 and p.mmgg = :mmgg and p.code_eqp < 0'
      ' group by p.id_p_eqp order by id_p_eqp'
      ') as f0'
      'left join'
      '(select sum(p.demand)::::int as demand_1,p.id_p_eqp'
      ' from bal_grp_tree_tbl as p'
      
        ' where p.type_eqp=12 and p.mmgg+'#39'1 month'#39'::::interval = :mmgg an' +
        'd p.code_eqp < 0'
      ' and id_bal = :res '
      ' group by p.id_p_eqp order by id_p_eqp'
      ') as f1 using (id_p_eqp)'
      'left join'
      '(select sum(p.demand)::::int as demand_2,p.id_p_eqp'
      ' from bal_grp_tree_tbl as p'
      
        ' where p.type_eqp=12 and p.mmgg+'#39'2 month'#39'::::interval = :mmgg an' +
        'd p.code_eqp < 0'
      ' and id_bal = :res '
      ' group by p.id_p_eqp order by id_p_eqp'
      ') as f2 using (id_p_eqp)'
      'left join'
      '(select sum(p.demand)::::int as demand_12,p.id_p_eqp'
      ' from bal_grp_tree_tbl as p'
      
        ' where p.type_eqp=12 and p.mmgg+'#39'12 month'#39'::::interval = :mmgg a' +
        'nd p.code_eqp < 0'
      ' and id_bal = :res '
      ' group by p.id_p_eqp order by id_p_eqp'
      ')  as f12 using (id_p_eqp)'
      ') as bigsel2'
      ''
      'on ('
      
        'bigsel2.id_p_eqp=coalesce(bigsel.gr_10,   bigsel.gr_9,   bigsel.' +
        'gr_8,  bigsel.gr_7,  bigsel.gr_6,'
      
        '      bigsel.gr_5,   bigsel.gr_4,   bigsel.gr_3,  bigsel.gr_2,  ' +
        'bigsel.gr_1))'
      ') as ssss'
      'order by'
      '%order_val'
      ''
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 673
    Top = 3
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'mmgg'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'code_eqp'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'res'
        ParamType = ptUnknown
      end>
  end
  object ZQTreeLosts: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <
      item
        DataType = ftUnknown
        Name = 'lev1'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev2'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev3'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev4'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev5'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev6'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev7'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev8'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev9'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'lev10'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'order_val'
        ParamType = ptUnknown
      end>
    Sql.Strings = (
      
        'select info.*, coalesce(ff10.losts_coef,0) as f10_coef, ff10.fac' +
        't_losts, ff10.demand04 from ('
      'select'
      '%lev1'
      '%lev2'
      '%lev3'
      '%lev4'
      '%lev5'
      '%lev6'
      '%lev7'
      '%lev8'
      '%lev9'
      '%lev10'
      
        'eq.name_eqp,acc.code_eqp,acc.losts*cal_minutes_fun(bigsel.dat_b,' +
        ' bigsel.dat_e)/cal_minutes_fun( :dt_b, :dt_e) as lst ,acc.losts ' +
        'as lst_old, bigsel.dat_b, bigsel.dat_e'
      ' from'
      '('
      'select'
      
        's1.code_eqp as gr_1,s1.type_eqp as type1,s1.id_voltage as volt1,' +
        's1.name as name1,s1.losts as lost1,s1.dat_b as dat_b1,s1.dat_e a' +
        's dat_e1,(text(s1.code_eqp)||text(extract ('#39'epoch'#39' from s1.dat_b' +
        ')::::int))::::varchar as key1,'
      
        's2.code_eqp as gr_2,s2.type_eqp as type2,s2.id_voltage as volt2,' +
        's2.name as name2,s2.losts as lost2,s2.dat_b as dat_b2,s2.dat_e a' +
        's dat_e2,(text(s2.code_eqp)||text(extract ('#39'epoch'#39' from s2.dat_b' +
        ')::::int))::::varchar as key2,'
      
        's3.code_eqp as gr_3,s3.type_eqp as type3,s3.id_voltage as volt3,' +
        's3.name as name3,s3.losts as lost3,s3.dat_b as dat_b3,s3.dat_e a' +
        's dat_e3,(text(s3.code_eqp)||text(extract ('#39'epoch'#39' from s3.dat_b' +
        ')::::int))::::varchar as key3,'
      
        's4.code_eqp as gr_4,s4.type_eqp as type4,s4.id_voltage as volt4,' +
        's4.name as name4,s4.losts as lost4,s4.dat_b as dat_b4,s4.dat_e a' +
        's dat_e4,(text(s4.code_eqp)||text(extract ('#39'epoch'#39' from s4.dat_b' +
        ')::::int))::::varchar as key4,'
      
        's5.code_eqp as gr_5,s5.type_eqp as type5,s5.id_voltage as volt5,' +
        's5.name as name5,s5.losts as lost5,s5.dat_b as dat_b5,s5.dat_e a' +
        's dat_e5,(text(s5.code_eqp)||text(extract ('#39'epoch'#39' from s5.dat_b' +
        ')::::int))::::varchar as key5,'
      
        's6.code_eqp as gr_6,s6.type_eqp as type6,s6.id_voltage as volt6,' +
        's6.name as name6,s6.losts as lost6,s6.dat_b as dat_b6,s6.dat_e a' +
        's dat_e6,(text(s6.code_eqp)||text(extract ('#39'epoch'#39' from s6.dat_b' +
        ')::::int))::::varchar as key6,'
      
        's7.code_eqp as gr_7,s7.type_eqp as type7,s7.id_voltage as volt7,' +
        's7.name as name7,s7.losts as lost7,s7.dat_b as dat_b7,s7.dat_e a' +
        's dat_e7,(text(s7.code_eqp)||text(extract ('#39'epoch'#39' from s7.dat_b' +
        ')::::int))::::varchar as key7,'
      
        's8.code_eqp as gr_8,s8.type_eqp as type8,s8.id_voltage as volt8,' +
        's8.name as name8,s8.losts as lost8,s8.dat_b as dat_b8,s8.dat_e a' +
        's dat_e8,(text(s8.code_eqp)||text(extract ('#39'epoch'#39' from s8.dat_b' +
        ')::::int))::::varchar as key8,'
      
        's9.code_eqp as gr_9,s9.type_eqp as type9,s9.id_voltage as volt9,' +
        's9.name as name9,s9.losts as lost9,s9.dat_b as dat_b9,s9.dat_e a' +
        's dat_e9,(text(s9.code_eqp)||text(extract ('#39'epoch'#39' from s9.dat_b' +
        ')::::int))::::varchar as key9,'
      
        's10.code_eqp as gr_10,s10.type_eqp as type10,s10.id_voltage as v' +
        'olt10,s10.name as name10,s10.losts as lost10,s10.dat_b as dat_b1' +
        '0,s10.dat_e as dat_e10,(text(s1.code_eqp)||text(extract ('#39'epoch'#39 +
        ' from s1.dat_b)::::int)) as key10,'
      
        'coalesce(s10.dat_b,s9.dat_b,s8.dat_b,s7.dat_b,s6.dat_b,s5.dat_b,' +
        's4.dat_b,s3.dat_b,s2.dat_b,s1.dat_b) as dat_b,'
      
        'coalesce(s10.dat_e,s9.dat_e,s8.dat_e,s7.dat_e,s6.dat_e,s5.dat_e,' +
        's4.dat_e,s3.dat_e,s2.dat_e,s1.dat_e) as dat_e'
      'from bal_grp_tree_conn_tmp as s1'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s2 on (s2.id_p_eqp=s1.code_eqp or s2.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s1.dat_b::::abstime,s1.dat_e::::abst' +
        'ime),tinterval(s2.dat_b::::abstime,s2.dat_e::::abstime)) or s2.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s3 on (s3.id_p_eqp=s2.code_eqp or s3.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s2.dat_b::::abstime,s2.dat_e::::abst' +
        'ime),tinterval(s3.dat_b::::abstime,s3.dat_e::::abstime)) or s3.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s4 on (s4.id_p_eqp=s3.code_eqp or s4.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s3.dat_b::::abstime,s3.dat_e::::abst' +
        'ime),tinterval(s4.dat_b::::abstime,s4.dat_e::::abstime)) or s4.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s5 on (s5.id_p_eqp=s4.code_eqp or s5.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s4.dat_b::::abstime,s4.dat_e::::abst' +
        'ime),tinterval(s5.dat_b::::abstime,s5.dat_e::::abstime)) or s5.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s6 on (s6.id_p_eqp=s5.code_eqp or s6.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s5.dat_b::::abstime,s5.dat_e::::abst' +
        'ime),tinterval(s6.dat_b::::abstime,s6.dat_e::::abstime)) or s6.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s7 on (s7.id_p_eqp=s6.code_eqp or s7.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s6.dat_b::::abstime,s6.dat_e::::abst' +
        'ime),tinterval(s7.dat_b::::abstime,s7.dat_e::::abstime)) or s7.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s8 on (s8.id_p_eqp=s7.code_eqp or s8.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s7.dat_b::::abstime,s7.dat_e::::abst' +
        'ime),tinterval(s8.dat_b::::abstime,s8.dat_e::::abstime)) or s8.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s9 on (s9.id_p_eqp=s8.code_eqp or s9.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s8.dat_b::::abstime,s8.dat_e::::abst' +
        'ime),tinterval(s9.dat_b::::abstime,s9.dat_e::::abstime)) or s9.d' +
        'at_b is null)'
      'left join'
      
        '(select code_eqp,id_p_eqp,type_eqp,id_voltage,name,id_point,dema' +
        'nd,losts,dat_b,dat_e from bal_grp_tree_conn_tmp where type_eqp<>' +
        '12 and mmgg = :mmgg'
      'union'
      
        'select null, null ,null ,null ,null,null,null,null,null,null) as' +
        ' s10 on (s10.id_p_eqp=s9.code_eqp or s10.code_eqp is null)'
      
        'and ( tintervalov(tinterval(s9.dat_b::::abstime,s9.dat_e::::abst' +
        'ime),tinterval(s10.dat_b::::abstime,s10.dat_e::::abstime)) or s1' +
        '0.dat_b is null)'
      'where s1.code_eqp=:code_eqp and s1.mmgg = :mmgg'
      
        'order by gr_1 desc,gr_2 desc,gr_3 desc,gr_4 desc,gr_5 desc,gr_6 ' +
        'desc,gr_7 desc,gr_8 desc,gr_9 desc,gr_10 desc'
      ') as bigsel'
      'join'
      'eqm_compens_station_inst_tbl as cs on (cs.code_eqp_inst ='
      
        'coalesce(bigsel.gr_10, bigsel.gr_9, bigsel.gr_8, bigsel.gr_7, bi' +
        'gsel.gr_6,'
      
        ' bigsel.gr_5, bigsel.gr_4, bigsel.gr_3, bigsel.gr_2, bigsel.gr_1' +
        '))'
      
        'join bal_acc_tmp as acc on (acc.code_eqp = cs.code_eqp and acc.m' +
        'mgg = :mmgg)'
      'join eqm_equipment_tbl as eq on (eq.id=cs.code_eqp )'
      
        'join eqi_device_kinds_tbl as dk on (dk.id= eq.type_eqp and dk.ca' +
        'lc_lost=1)'
      ') as info'
      
        'left join bal_grp_tree_conn_tmp as ff10 on (info.f10=ff10.code_e' +
        'qp and ff10.mmgg = :mmgg)'
      ''
      'order by'
      '%order_val'
      ''
      ''
      ''
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 611
    Top = 3
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'dt_b'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dt_e'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftDateTime
        Name = 'mmgg'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'code_eqp'
        ParamType = ptInput
      end>
  end
  object ZQFiderBal: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        ' select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eq' +
        'p,'
      ' bd.ktr_demand as f_ktr_demand,'
      ' gt.demand as f_demand,gt.losts as f_losts,'
      ' bd.ktr_demand-gt.demand as f_real_losts'
      ' from'
      
        '  ( select id_point, code_eqp, name , coalesce(sum(demand),0):::' +
        ':int as demand, coalesce(sum(losts),0)::::int as losts'
      
        ' from bal_grp_tree_conn_tmp where type_eqp=15 and mmgg = :dat gr' +
        'oup by id_point,code_eqp, name order by id_point) as gt'
      ' left join bal_demand_tmp as bd'
      ' on (bd.id_point=gt.id_point and bd.mmgg=:dat )'
      ' where ((gt.code_eqp = :station) or ( :station is NULL))'
      ' order by f_name;'
      ''
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 31
    Top = 335
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftDateTime
        Name = 'dat'
        ParamType = ptInput
      end
      item
        DataType = ftInteger
        Name = 'station'
        ParamType = ptInput
      end>
  end
  object ZQSummBal: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select coalesce(sum(bd.ktr_demand),0)::::int as f_ktr_demand1,'
      
        'coalesce(sum(bd.ktr_demand),0)::::int-sum(f_demand1)::::int as f' +
        '_real_losts1,'
      
        'sum(f_demand1)::::int as f_demand1, sum(f_losts1)::::int as f_lo' +
        'sts1'
      
        'from ( select id_point, coalesce(sum(demand),0)::::int as f_dema' +
        'nd1, coalesce(sum(losts),0)::::int as f_losts1'
      
        ' from bal_grp_tree_conn_tmp where type_eqp=15 and id_voltage = 3' +
        ' and mmgg = :dat group by id_point order by id_point) as gt'
      'left join bal_demand_tmp as bd'
      'on (bd.id_point=gt.id_point )'
      'where bd.mmgg=:dat;'
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 737
    Top = 3
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftDateTime
        Name = 'dat'
        ParamType = ptInput
      end>
  end
  object QRExcelFilter1: TQRExcelFilter
    Left = 417
    Top = 6
  end
  object QRRTFFilter1: TQRRTFFilter
    Left = 389
    Top = 6
  end
  object ZQBalLev1_e: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'station=station'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsBalRoot
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select 1 as gr2, (gt.name||coalesce('#39'(№ '#39'||bd.num_eqp||'#39' )'#39','#39#39'))' +
        '::::varchar as name,'
      
        'gt.code_eqp ,bd.b_val as b_val,bd.e_val as e_val,bd.k_tr as k_tr' +
        ','
      'bd.met_demand as met_demand,'
      'bd.ktr_demand as ktr_demand,bd.num_eqp as num_eqp,'
      'gt.demand as demand,gt.losts as losts,'
      'gt.id_p_eqp as station'
      'from bal_grp_tree_tmp as gt'
      
        'left join bal_meter_demand_tmp as bd on (bd.id_point=gt.id_point' +
        ' and bd.mmgg=gt.mmgg)'
      'where gt.id_p_eqp = :station and gt.type_eqp= 3'
      'and gt.mmgg = :dat'
      'order by gt.name;'
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 30
    Top = 372
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'station'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end>
  end
  object ZQBalLev2: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'station=station'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsBalRoot
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select 1 as gr,bdf.id_point, gtf.name as f_name, gtf.code_eqp as' +
        ' f_code_eqp,'
      'bdf.ktr_demand as f_ktr_demand,'
      'gtf.demand as f_demand,gtf.losts as f_losts,'
      'bdf.ktr_demand-gtf.demand as f_real_losts,'
      'gte.id_p_eqp as station'
      'from bal_grp_tree_tmp as gte'
      'left join'
      
        '  ( select id_point, code_eqp, id_p_eqp, name , coalesce(sum(dem' +
        'and),0)::::int as demand, coalesce(sum(losts),0)::::int as losts'
      
        ' from bal_grp_tree_conn_tmp where type_eqp=15 and mmgg = :dat gr' +
        'oup by id_point,code_eqp,id_p_eqp, name order by id_point) as gt' +
        'f'
      'on (gtf.id_p_eqp=gte.code_eqp)'
      'left join bal_demand_tmp as bdf'
      'on (bdf.id_point=gtf.id_point )'
      'where gte.id_p_eqp = :station'
      'and gte.type_eqp=3'
      'and gte.mmgg = :dat'
      'order by gtf.name;'
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 30
    Top = 408
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'station'
        ParamType = ptUnknown
      end>
  end
  object ZQBalRoot: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select code_eqp as station from bal_grp_tree_tmp as gt'
      'where gt.code_eqp = :station'
      'and gt.mmgg = :dat;')
    RequestLive = False
    Left = 32
    Top = 444
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'station'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end>
  end
  object dsBalRoot: TDataSource
    DataSet = ZQBalRoot
    Left = 76
    Top = 428
  end
  object ZQBalLev1_f: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'station=station'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsBalRoot
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select 1 as gr,bd.id_point,gt.name as f_name, gt.code_eqp as f_c' +
        'ode_eqp,'
      'bd.ktr_demand as f_ktr_demand,'
      'gt.demand as f_demand,gt.losts as f_losts,'
      'bd.ktr_demand-gt.demand as f_real_losts,'
      'gt.id_p_eqp as station'
      'from'
      
        '  ( select id_point, code_eqp, name , id_p_eqp, coalesce(sum(dem' +
        'and),0)::::int as demand, coalesce(sum(losts),0)::::int as losts'
      
        ' from bal_grp_tree_conn_tmp where type_eqp=15 and mmgg = :dat gr' +
        'oup by id_point,code_eqp, name, id_p_eqp order by id_point) as g' +
        't'
      'left join bal_demand_tmp as bd'
      'on (bd.id_point=gt.id_point and bd.mmgg= :dat)'
      'where gt.id_p_eqp = :station'
      'order by gt.name;'
      ''
      ''
      ''
      ' ')
    RequestLive = False
    Left = 78
    Top = 372
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'station'
        ParamType = ptUnknown
      end>
  end
  object xlReportFiders: TxlReport
    Options = [xroDisplayAlerts, xroAutoSave, xroUseTemp, xroAutoOpen]
    DataSources = <>
    Preview = False
    Params = <>
    OnBeforeWorkbookSave = xlReportFidersBeforeWorkbookSave
    Left = 16
    Top = 12
  end
  object ZQBalMeters: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'id_point=id_point'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsMetersSrc
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select id_point, bdf.b_val as m_b_val, bdf.e_val as m_e_val,bdf.' +
        'k_tr as m_k_tr,'
      'bdf.met_demand as m_met_demand, bdf.ktr_demand as m_ktr_demand,'
      '('#39'Учет № '#39'||bdf.num_eqp)::::varchar as m_num_eqp'
      'from  bal_meter_demand_tmp as bdf'
      'where bdf.mmgg = :dat'
      'order by bdf.num_eqp;'
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 74
    Top = 336
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end>
  end
  object dsMetersSrc: TDataSource
    Left = 120
    Top = 372
  end
  object ZQFiderBalXL: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select * from ('
      
        ' select bd.id_point, gt.name as f_name, gt.code_eqp as f_code_eq' +
        'p,'
      ' bd.ktr_demand as f_ktr_demand,'
      ' gt.demand as f_demand,gt.losts as f_losts,'
      ' bd.ktr_demand-gt.demand as f_real_losts'
      ' from bal_grp_tree_tmp as gt left join bal_demand_tmp as bd'
      ' on (bd.id_point=gt.id_point and bd.mmgg=gt.mmgg)'
      
        ' where ((gt.code_eqp = :station) or ( :station is NULL))  and gt' +
        '.mmgg = :dat and gt.type_eqp= 15'
      ' union'
      
        ' select 0, '#39'- С шин ПС 110/35/10'#39'::::varchar,0,sum(gt3.demand),s' +
        'um(gt3.demand),0,0'
      ' from bal_grp_tree_tmp as gt'
      
        ' left join bal_grp_tree_tmp as gt2 on (gt2.id_p_eqp = gt.code_eq' +
        'p)'
      
        ' left join bal_grp_tree_tmp as gt3 on (gt3.id_p_eqp = gt2.code_e' +
        'qp)'
      ' where'
      ' gt.type_eqp=8 and gt.id_voltage <3 and gt.mmgg = :dat'
      ' and gt2.type_eqp=3 and gt2.mmgg = :dat'
      ' and gt3.type_eqp=12 and gt3.mmgg = :dat'
      ' order by f_name'
      ' )as s;'
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 119
    Top = 335
    ParamData = <
      item
        DataType = ftInteger
        Name = 'station'
        ParamType = ptInput
      end
      item
        DataType = ftDateTime
        Name = 'dat'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end>
  end
  object ZQPSMeters: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select b.code_eqp as link, bdf.id_point, bdf.b_val as b_val, bdf' +
        '.e_val as e_val,bdf.k_tr as k_tr,'
      'bdf.met_demand as m_met_demand, bdf.ktr_demand as ktr_demand,'
      '('#39'№ '#39'||bdf.num_eqp)::::varchar as num_eqp'
      'from  bal_meter_demand_tmp as bdf'
      
        'join eqm_compens_station_inst_tbl as csi on (csi.code_eqp = bdf.' +
        'id_point)'
      'join bal_grp_tree_tmp as b on (b.code_eqp = csi.code_eqp_inst)'
      'where bdf.mmgg = :mmgg and b.type_eqp = 8 and b.mmgg = :mmgg'
      'order by link, bdf.num_eqp;'
      ''
      ''
      ''
      ' ')
    RequestLive = False
    Left = 287
    Top = 383
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end>
  end
  object ZQPSDemand: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'id_point=id_point'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsPSBal
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select CASE WHEN gr.type_eqp = 15 and gr.id_voltage in (4,42) TH' +
        'EN gr.id_p_eqp ELSE p.id_p_eqp END as link ,'
      
        'p.code_eqp, p.name, clm.short_name as abon_name,clm.code,sum(p.d' +
        'emand)::::numeric as demand,dat_ind'
      'from'
      'bal_grp_tree_conn_tmp as p'
      'join clm_client_tbl as clm on (p.id_client = clm.id)'
      
        'join bal_grp_tree_tmp as gr on (p.id_p_eqp = gr.code_eqp and gr.' +
        'mmgg= :mmgg)'
      
        'left join (select max(dat_e) as dat_ind, id_client from acm_bill' +
        '_tbl where  mmgg= :mmgg and id_pref = 10 and idk_doc = 200 group' +
        ' by id_client )as b on'
      '(b.id_client = clm.id)'
      'where p.type_eqp=12 and p.mmgg = :mmgg and clm.book = -1'
      
        'group by p.id_p_eqp,p.code_eqp, p.name, clm.short_name,clm.code,' +
        'dat_ind, gr.type_eqp, gr.id_voltage, gr.id_p_eqp'
      'union'
      ' select id_p_eqp, id_p_eqp,'
      '  '#39#39' ,abon_name, code, demand,NULL from'
      
        '(select '#39'Бытовые потребители ('#39'||text(coalesce(sum(cc.fiz_count)' +
        ',0))||'#39')'#39'::::varchar as abon_name,0 as code,sum(p.demand)::::int' +
        ' as demand,'
      
        ' CASE WHEN gr.type_eqp = 15 and gr.id_voltage in (4,42) THEN gr.' +
        'id_p_eqp ELSE p.id_p_eqp END as id_p_eqp'
      ' from bal_grp_tree_tmp as p'
      
        ' join bal_grp_tree_tmp as gr on (p.id_p_eqp = gr.code_eqp and gr' +
        '.mmgg= :mmgg)'
      
        ' left join bal_acc_tmp as cc on (p.code_eqp = cc.code_eqp and p.' +
        'mmgg = cc.mmgg)'
      ' where p.type_eqp=12 and p.mmgg = :mmgg and p.code_eqp < 0'
      
        ' group by CASE WHEN gr.type_eqp = 15 and gr.id_voltage in (4,42)' +
        ' THEN gr.id_p_eqp ELSE p.id_p_eqp END'
      ') as f0'
      'order by link, code, name  ;'
      ''
      '')
    RequestLive = False
    Left = 250
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end>
  end
  object ZQPSBal: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select b.code_eqp as link , b.name, coalesce(b.demand,0) as dema' +
        'nd ,sdem.ktr_demand , gr2.name as fider_name, cp.represent_name'
      'from'
      'bal_grp_tree_tmp as b'
      
        'left join bal_grp_tree_tmp as gr2 on (b.id_p_eqp = gr2.code_eqp ' +
        'and gr2.mmgg= :mmgg)'
      
        'left join bal_grp_tree_tmp as gr3 on (gr2.id_p_eqp = gr3.code_eq' +
        'p and gr3.mmgg= :mmgg)'
      
        'left join bal_grp_tree_tmp as gr4 on (gr3.id_p_eqp = gr4.code_eq' +
        'p and gr4.mmgg= :mmgg)'
      'left join'
      '(select b2.code_eqp, sum(bd.ktr_demand) as ktr_demand'
      ' from bal_demand_tmp as bd'
      
        ' join eqm_compens_station_inst_tbl as csi on (csi.code_eqp = bd.' +
        'id_point)'
      
        ' join bal_grp_tree_tmp as b2 on (b2.code_eqp = csi.code_eqp_inst' +
        ')'
      ' where bd.mmgg = :mmgg and b2.type_eqp = 8 and b2.mmgg = :mmgg'
      ' group by b2.code_eqp order by b2.code_eqp'
      ') as sdem on (sdem.code_eqp = b.code_eqp)'
      ' left join eqm_fider_tbl as ff on (ff.code_eqp = gr2.code_eqp)'
      ' left join clm_position_tbl as cp on (cp.id = ff.id_position)'
      'where  b.type_eqp = 8 and b.mmgg =:mmgg'
      
        'and ( :obj = b.code_eqp or :obj = gr2.code_eqp or :obj = gr3.cod' +
        'e_eqp or :obj = gr4.code_eqp or (:obj is null ) )'
      'and b.id_voltage >= 3'
      'order by name  ;'
      ''
      ''
      ''
      ''
      ''
      '')
    RequestLive = False
    Left = 207
    Top = 383
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'obj'
        ParamType = ptUnknown
      end>
  end
  object dsPSBal: TDataSource
    DataSet = ZQPSBal
    Left = 208
    Top = 412
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
    Left = 48
    Top = 13
  end
  object DSRep: TDataSource
    DataSet = ZQXLRepsSum
    Left = 110
    Top = 11
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
    Left = 80
    Top = 13
  end
  object ZQDemandNew: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkFields = 'key = key'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsDemandNewSum
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 48
    Top = 45
  end
  object ZQDemandNewSum: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 80
    Top = 45
  end
  object dsDemandNewSum: TDataSource
    DataSet = ZQDemandNewSum
    Left = 110
    Top = 43
  end
  object ZQMidPointBal: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select p.code_eqp as link, d.ktr_demand, acc.demand,acc.demand04' +
        ',acc.fiz_count,acc.fiz_power ,'
      
        'eq.name_eqp as fider_name, eqm.name_eqp as name, cp.represent_na' +
        'me'
      'from bal_eqp_tmp as p'
      
        'join bal_acc_tmp as acc on (acc.code_eqp = p.code_eqp and acc.mm' +
        'gg=:mmgg)'
      'join eqm_equipment_tbl as eqm on (eqm.id = p.code_eqp)'
      
        'left join bal_demand_tmp as d on (d.id_point = p.code_eqp and d.' +
        'mmgg=:mmgg)'
      
        'left join bal_grp_tree_tmp as g on (p.code_eqp = g.id_point and ' +
        'g.mmgg=:mmgg)'
      
        'left join eqm_compens_station_inst_tbl as inst on (inst.code_eqp' +
        ' = p.code_eqp)'
      
        'left join eqm_equipment_tbl as eq on (eq.id = inst.code_eqp_inst' +
        ')'
      'left join eqm_fider_tbl as ff on (ff.code_eqp = eq.id)'
      'left join clm_position_tbl as cp on (cp.id = ff.id_position)'
      
        'where p.type_eqp =12 and p.mmgg=:mmgg and p.id_client = syi_resi' +
        'd_fun()'
      'and g.id_point is null and (coalesce(eq.type_eqp,15)=15)'
      'and (eq.id = :grp or :grp is null)'
      'order by name  ;'
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 367
    Top = 383
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'grp'
        ParamType = ptUnknown
      end>
  end
  object ZQMidPointDemand: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkFields = 'id_point=id_point'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsMidPointBal
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select ss.*, ps.name_eqp as name_fps from'
      '('
      
        'select md.id_midpoint as link, md.id_grp, eq.name_eqp as point_n' +
        'ame ,md.demand, clm.short_name as abon_name,clm.code,dat_ind'
      'from'
      'bal_midpoint_demand_tmp as md'
      'join clm_client_tbl as clm on (md.id_client = clm.id)'
      'left join eqm_equipment_tbl as eq on (eq.id = md.id_point)'
      
        'left join (select max(dat_e) as dat_ind, id_client from acm_bill' +
        '_tbl where  mmgg= :mmgg and id_pref in (10,11) and idk_doc = 200' +
        ' group by id_client )as b on'
      '(b.id_client = clm.id)'
      'union'
      
        'select id_midpoint, id_grp, '#39#39', demand,abon_name, code, NULL fro' +
        'm'
      
        '(select md2.id_midpoint, md2.id_grp, '#39'Бытовые потребители ('#39'||te' +
        'xt(coalesce(sum(cc.fiz_count),0))||'#39')'#39'::::varchar as abon_name,0' +
        ' as code,sum(md2.demand)::::int as demand'
      ' from bal_midpoint_demand_tmp as md2'
      
        ' left join bal_acc_tmp as cc on (md2.id_point = cc.code_eqp and ' +
        'cc.mmgg = :mmgg)'
      ' where   md2.id_point < 0'
      ' group by id_midpoint, id_grp'
      ') as f0'
      ')  as ss'
      'left join eqm_equipment_tbl as ps on (ps.id = ss.id_grp)'
      'order by link, ps.name_eqp,code;'
      ' '
      ' ')
    RequestLive = False
    Left = 410
    Top = 384
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end>
  end
  object ZQMidPointMeters: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select bdf.id_point as link, bdf.b_val as b_val, bdf.e_val as e_' +
        'val,bdf.k_tr as k_tr,'
      'bdf.met_demand as m_met_demand, bdf.ktr_demand as ktr_demand,'
      '('#39'№ '#39'||bdf.num_eqp)::::varchar as num_eqp'
      'from  bal_meter_demand_tmp as bdf'
      'where bdf.mmgg = :mmgg'
      'order by link, bdf.num_eqp;'
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 447
    Top = 383
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end>
  end
  object dsMidPointBal: TDataSource
    DataSet = ZQMidPointBal
    Left = 368
    Top = 412
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
    Left = 16
    Top = 45
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
    Left = 152
    Top = 45
  end
  object ZQXLReps4: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doQuickOpen]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    RequestLive = False
    Left = 184
    Top = 45
  end
end
