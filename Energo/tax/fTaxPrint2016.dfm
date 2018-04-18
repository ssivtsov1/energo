object fRepTaxN2016: TfRepTaxN2016
  Left = 155
  Top = 145
  Width = 1088
  Height = 765
  HorzScrollBar.Position = 58
  VertScrollBar.Position = 418
  Caption = 'fRepTaxN2016'
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object PrintTax: TQuickRep
    Left = -20
    Top = -412
    Width = 1111
    Height = 1572
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = PrintTaxBeforePrint
    DataSet = ZQTaxSumm
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
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
      70
      2100
      100
      0
      0)
    PrinterSettings.Copies = 1
    PrinterSettings.OutputBin = Auto
    PrinterSettings.Duplex = False
    PrinterSettings.FirstPage = 0
    PrinterSettings.LastPage = 0
    PrinterSettings.UseStandardprinter = True
    PrinterSettings.UseCustomBinCode = False
    PrinterSettings.CustomBinCode = 0
    PrinterSettings.ExtendedDuplex = 0
    PrinterSettings.UseCustomPaperCode = False
    PrinterSettings.CustomPaperCode = 0
    PrinterSettings.PrintMetaFile = False
    PrintIfEmpty = True
    ShowProgress = False
    SnapToGrid = True
    Units = MM
    Zoom = 140
    PrevFormStyle = fsNormal
    PreviewInitialState = wsMaximized
    object QRBand1: TQRBand
      Left = 53
      Top = 37
      Width = 1058
      Height = 691
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand1BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        1305.90773809524
        1999.49404761905)
      BandType = rbTitle
      object QRShape95: TQRShape
        Left = 933
        Top = 590
        Width = 59
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1763.25892857143
          1115.02976190476
          111.502976190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape127: TQRShape
        Left = 47
        Top = 372
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          703.035714285714
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape124: TQRShape
        Left = 47
        Top = 392
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          740.833333333333
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape102: TQRShape
        Left = 47
        Top = 412
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          778.630952380952
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape66: TQRShape
        Left = 47
        Top = 432
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          816.428571428571
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape63: TQRShape
        Left = 47
        Top = 452
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          854.22619047619
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape60: TQRShape
        Left = 47
        Top = 472
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          892.02380952381
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape57: TQRShape
        Left = 47
        Top = 492
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          929.821428571429
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape53: TQRShape
        Left = 47
        Top = 512
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          967.619047619048
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape43: TQRShape
        Left = 47
        Top = 532
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          1005.41666666667
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape34: TQRShape
        Left = 47
        Top = 552
        Width = 781
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          88.8244047619048
          1043.21428571429
          1475.99702380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel17: TQRLabel
        Left = 56
        Top = 554
        Width = 456
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          1046.99404761905
          861.785714285714)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дані щодо зворотної (заставної) тари'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape119: TQRShape
        Left = 517
        Top = 184
        Width = 477
        Height = 159
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          300.491071428571
          977.068452380952
          347.738095238095
          901.473214285714)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape118: TQRShape
        Left = 1
        Top = 184
        Width = 477
        Height = 159
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          300.491071428571
          1.88988095238095
          347.738095238095
          901.473214285714)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape99: TQRShape
        Left = 346
        Top = 4
        Width = 41
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          653.89880952381
          7.55952380952381
          77.485119047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape2: TQRShape
        Left = 3
        Top = 52
        Width = 343
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          77.485119047619
          5.66964285714286
          98.2738095238095
          648.229166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel2: TQRLabel
        Left = 9
        Top = 56
        Width = 329
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          17.0089285714286
          105.833333333333
          621.770833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Не підлягає наданню отримувачу (покупцю) з причини   '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRMemo1: TQRMemo
        Left = 656
        Top = 21
        Width = 342
        Height = 96
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          181.428571428571
          1239.7619047619
          39.6875
          646.339285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        Lines.Strings = (
          'ЗАТВЕРДЖЕНО'
          'Наказ Міністерства фінансів України '
          '31.12.2015  № 1307'
          '(у редакції наказу Міністерства фінансів України '
          '23 лютого 2017 року №  276)')
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRLabel4: TQRLabel
        Left = 116
        Top = 122
        Width = 278
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          219.22619047619
          230.565476190476
          525.386904761905)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПОДАТКОВА НАКЛАДНА'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object QRLabel5: TQRLabel
        Left = 463
        Top = 152
        Width = 85
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          875.014880952381
          287.261904761905
          160.639880952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Дата складання'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel8: TQRLabel
        Left = 680
        Top = 152
        Width = 108
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1285.11904761905
          287.261904761905
          204.107142857143)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Порядковий номер'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel9: TQRLabel
        Left = 10
        Top = 194
        Width = 167
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          18.8988095238095
          366.636904761905
          315.610119047619)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = ' Постачальник (продавець)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel10: TQRLabel
        Left = 528
        Top = 195
        Width = 139
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          997.857142857143
          368.526785714286
          262.693452380952)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Отримувач (покупець)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape5: TQRShape
        Left = 9
        Top = 215
        Width = 435
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          102.053571428571
          17.0089285714286
          406.324404761905
          822.098214285714)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape6: TQRShape
        Left = 527
        Top = 215
        Width = 457
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          102.053571428571
          995.967261904762
          406.324404761905
          863.675595238095)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape7: TQRShape
        Left = 8
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          15.1190476190476
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape8: TQRShape
        Left = 33
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          62.3660714285714
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape9: TQRShape
        Left = 58
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          109.613095238095
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape10: TQRShape
        Left = 85
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          160.639880952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape11: TQRShape
        Left = 110
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          207.886904761905
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape12: TQRShape
        Left = 136
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          257.02380952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape13: TQRShape
        Left = 162
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          306.160714285714
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape14: TQRShape
        Left = 187
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          353.407738095238
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape15: TQRShape
        Left = 213
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          402.544642857143
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape16: TQRShape
        Left = 239
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          451.681547619048
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape17: TQRShape
        Left = 264
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          498.928571428571
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape18: TQRShape
        Left = 290
        Top = 291
        Width = 30
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          548.065476190476
          549.955357142857
          56.6964285714286)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape19: TQRShape
        Left = 527
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          995.967261904762
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape20: TQRShape
        Left = 552
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1043.21428571429
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape21: TQRShape
        Left = 578
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1092.35119047619
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape22: TQRShape
        Left = 604
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1141.4880952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape23: TQRShape
        Left = 629
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1188.73511904762
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape24: TQRShape
        Left = 655
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1237.87202380952
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape25: TQRShape
        Left = 681
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1287.00892857143
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape26: TQRShape
        Left = 706
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1334.25595238095
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape27: TQRShape
        Left = 732
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1383.39285714286
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape28: TQRShape
        Left = 758
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1432.52976190476
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape29: TQRShape
        Left = 783
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1479.77678571429
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape30: TQRShape
        Left = 808
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1527.02380952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel11: TQRLabel
        Left = 66
        Top = 318
        Width = 178
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          124.732142857143
          600.982142857143
          336.39880952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(індивідуальний податковий номер )'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel12: TQRLabel
        Left = 596
        Top = 319
        Width = 178
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1126.36904761905
          602.872023809524
          336.39880952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(індивідуальний податковий номер )'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRShape33: TQRShape
        Left = 3
        Top = 590
        Width = 34
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          5.66964285714286
          1115.02976190476
          64.2559523809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape35: TQRShape
        Left = 36
        Top = 590
        Width = 197
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          68.0357142857143
          1115.02976190476
          372.306547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape36: TQRShape
        Left = 425
        Top = 590
        Width = 120
        Height = 42
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          803.199404761905
          1115.02976190476
          226.785714285714)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape37: TQRShape
        Left = 541
        Top = 590
        Width = 63
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1022.4255952381
          1115.02976190476
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape38: TQRShape
        Left = 603
        Top = 590
        Width = 114
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1139.59821428571
          1115.02976190476
          215.446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape41: TQRShape
        Left = 715
        Top = 590
        Width = 47
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1351.26488095238
          1115.02976190476
          88.8244047619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape42: TQRShape
        Left = 761
        Top = 590
        Width = 50
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1438.1994047619
          1115.02976190476
          94.4940476190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape44: TQRShape
        Left = 810
        Top = 590
        Width = 124
        Height = 101
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          190.877976190476
          1530.80357142857
          1115.02976190476
          234.345238095238)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel23: TQRLabel
        Left = 6
        Top = 617
        Width = 27
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          69.9255952380952
          11.3392857142857
          1166.05654761905
          51.0267857142857)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '№ з/п'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel25: TQRLabel
        Left = 39
        Top = 627
        Width = 190
        Height = 42
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          73.7053571428571
          1184.95535714286
          359.077380952381)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Номенклатура товарів/послуг продавця'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel26: TQRLabel
        Left = 439
        Top = 597
        Width = 86
        Height = 31
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          58.5863095238095
          829.657738095238
          1128.25892857143
          162.529761904762)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Одиниця виміру товару/послуги'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel27: TQRLabel
        Left = 549
        Top = 608
        Width = 52
        Height = 58
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          109.613095238095
          1037.54464285714
          1149.04761904762
          98.2738095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Кількість (об'#39'єм, обсяг)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel28: TQRLabel
        Left = 611
        Top = 594
        Width = 101
        Height = 94
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          177.64880952381
          1154.71726190476
          1122.58928571429
          190.877976190476)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Ціна постачання одиниці товару/ послуги без урахування податку н' +
          'а додану вартість'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel35: TQRLabel
        Left = 814
        Top = 600
        Width = 116
        Height = 81
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          153.080357142857
          1538.3630952381
          1133.92857142857
          219.22619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Обсяги постачання (база оподаткування) без урахування податку на' +
          '  додану вартість'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object lResName: TQRLabel
        Left = 13
        Top = 216
        Width = 427
        Height = 49
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          92.6041666666667
          24.5684523809524
          408.214285714286
          806.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object lAbonName: TQRLabel
        Left = 530
        Top = 216
        Width = 450
        Height = 49
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          92.6041666666667
          1001.6369047619
          408.214285714286
          850.446428571429)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel77: TQRLabel
        Left = 12
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          22.6785714285714
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel78: TQRLabel
        Left = 36
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          68.0357142857143
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel79: TQRLabel
        Left = 62
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          117.172619047619
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel80: TQRLabel
        Left = 87
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          164.419642857143
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel81: TQRLabel
        Left = 114
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          215.446428571429
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel82: TQRLabel
        Left = 141
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          266.473214285714
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel83: TQRLabel
        Left = 166
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          313.720238095238
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel84: TQRLabel
        Left = 190
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          359.077380952381
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel85: TQRLabel
        Left = 216
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          408.214285714286
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel86: TQRLabel
        Left = 241
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          455.46130952381
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel87: TQRLabel
        Left = 268
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          506.488095238095
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel88: TQRLabel
        Left = 295
        Top = 295
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          557.514880952381
          557.514880952381
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel89: TQRLabel
        Left = 531
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1003.52678571429
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel90: TQRLabel
        Left = 555
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1048.88392857143
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel91: TQRLabel
        Left = 581
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1098.02083333333
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel92: TQRLabel
        Left = 608
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1149.04761904762
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel93: TQRLabel
        Left = 633
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1196.29464285714
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel94: TQRLabel
        Left = 658
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1243.54166666667
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel95: TQRLabel
        Left = 685
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1294.56845238095
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel96: TQRLabel
        Left = 709
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1339.9255952381
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel97: TQRLabel
        Left = 735
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1389.0625
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel98: TQRLabel
        Left = 762
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1440.08928571429
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel99: TQRLabel
        Left = 787
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1487.33630952381
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel100: TQRLabel
        Left = 812
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1534.58333333333
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lCode: TQRLabel
        Left = 660
        Top = 2
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          24.5684523809524
          1247.32142857143
          3.77976190476191
          52.9166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lCode'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -6
      end
      object QRLabel116: TQRLabel
        Left = 41
        Top = 269
        Width = 397
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          77.485119047619
          508.377976190476
          750.282738095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          '(найменування; прізвище, ім'#39'я, по батькові - для фізичної особи-' +
          'підприємця)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRShape193: TQRShape
        Left = 346
        Top = 72
        Width = 21
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          653.89880952381
          136.071428571429
          39.6875)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape194: TQRShape
        Left = 346
        Top = 52
        Width = 41
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          653.89880952381
          98.2738095238095
          77.485119047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape195: TQRShape
        Left = 366
        Top = 72
        Width = 21
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          691.696428571429
          136.071428571429
          39.6875)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape196: TQRShape
        Left = 398
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          752.172619047619
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape197: TQRShape
        Left = 424
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          801.309523809524
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape198: TQRShape
        Left = 450
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          850.446428571429
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape199: TQRShape
        Left = 475
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          897.693452380952
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape200: TQRShape
        Left = 501
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          946.830357142857
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape201: TQRShape
        Left = 527
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          995.967261904762
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape202: TQRShape
        Left = 552
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1043.21428571429
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape203: TQRShape
        Left = 578
        Top = 125
        Width = 30
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1092.35119047619
          236.235119047619
          56.6964285714286)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object lTaxDate1: TQRLabel
        Left = 402
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          759.732142857143
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate2: TQRLabel
        Left = 429
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          810.758928571429
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate3: TQRLabel
        Left = 454
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          858.005952380952
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate4: TQRLabel
        Left = 478
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          903.363095238095
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate5: TQRLabel
        Left = 504
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          952.5
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate6: TQRLabel
        Left = 529
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          999.747023809524
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate7: TQRLabel
        Left = 556
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1050.77380952381
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxDate8: TQRLabel
        Left = 583
        Top = 129
        Width = 20
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1101.8005952381
          243.794642857143
          37.797619047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape204: TQRShape
        Left = 627
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1184.95535714286
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape205: TQRShape
        Left = 653
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1234.09226190476
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape206: TQRShape
        Left = 678
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1281.33928571429
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape207: TQRShape
        Left = 704
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1330.47619047619
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape208: TQRShape
        Left = 730
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1379.6130952381
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape209: TQRShape
        Left = 755
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1426.86011904762
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape210: TQRShape
        Left = 780
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1474.10714285714
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object lTaxNum1: TQRLabel
        Left = 630
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1190.625
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum2: TQRLabel
        Left = 657
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1241.65178571429
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum3: TQRLabel
        Left = 681
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1287.00892857143
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum4: TQRLabel
        Left = 707
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1336.14583333333
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum5: TQRLabel
        Left = 734
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1387.17261904762
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum6: TQRLabel
        Left = 759
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1434.41964285714
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum7: TQRLabel
        Left = 784
        Top = 129
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1481.66666666667
          243.794642857143
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape211: TQRShape
        Left = 332
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          627.440476190476
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape212: TQRShape
        Left = 358
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          676.577380952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape213: TQRShape
        Left = 383
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          723.824404761905
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape214: TQRShape
        Left = 408
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          771.071428571429
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object lTaxNum8: TQRLabel
        Left = 335
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          633.110119047619
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum9: TQRLabel
        Left = 362
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          684.136904761905
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum10: TQRLabel
        Left = 387
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          731.383928571429
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lTaxNum11: TQRLabel
        Left = 412
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          778.630952380952
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel117: TQRLabel
        Left = 547
        Top = 269
        Width = 425
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          1033.76488095238
          508.377976190476
          803.199404761905)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          '(найменування; прізвище, ім'#39'я, по батькові - для фізичної особи-' +
          'підприємця)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel139: TQRLabel
        Left = 810
        Top = 128
        Width = 6
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.577380952381
          1530.80357142857
          241.904761904762
          11.3392857142857)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '/'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object lNoGive: TQRLabel
        Left = 361
        Top = 54
        Width = 8
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          682.247023809524
          102.053571428571
          15.1190476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Х'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lNoGive1: TQRLabel
        Left = 353
        Top = 74
        Width = 8
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          667.127976190476
          139.85119047619
          15.1190476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '0'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lNoGive2: TQRLabel
        Left = 373
        Top = 74
        Width = 8
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          704.925595238095
          139.85119047619
          15.1190476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel70: TQRLabel
        Left = 352
        Top = 319
        Width = 63
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          665.238095238095
          602.872023809524
          119.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(номер філії)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel47: TQRLabel
        Left = 830
        Top = 151
        Width = 13
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1568.60119047619
          285.372023809524
          24.5684523809524)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(1)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRShape67: TQRShape
        Left = 232
        Top = 612
        Width = 87
        Height = 79
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          149.300595238095
          438.452380952381
          1156.60714285714
          164.419642857143)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel71: TQRLabel
        Left = 234
        Top = 627
        Width = 84
        Height = 57
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          107.723214285714
          442.232142857143
          1184.95535714286
          158.75)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'товару згідно з УКТ ЗЕД'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRShape68: TQRShape
        Left = 822
        Top = 125
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1553.48214285714
          236.235119047619
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel121: TQRLabel
        Left = 9
        Top = 74
        Width = 225
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          17.0089285714286
          139.85119047619
          425.223214285714)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(зазначається відповідний тип причини)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape77: TQRShape
        Left = 3
        Top = 4
        Width = 343
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          5.66964285714286
          7.55952380952381
          648.229166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel136: TQRLabel
        Left = 8
        Top = 8
        Width = 310
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          15.1190476190476
          15.1190476190476
          585.863095238095)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зведена податкова накладна'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape114: TQRShape
        Left = 425
        Top = 631
        Width = 75
        Height = 60
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.392857142857
          803.199404761905
          1192.51488095238
          141.741071428571)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape115: TQRShape
        Left = 498
        Top = 631
        Width = 44
        Height = 60
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.392857142857
          941.160714285714
          1192.51488095238
          83.1547619047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel146: TQRLabel
        Left = 427
        Top = 637
        Width = 69
        Height = 51
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          96.3839285714286
          806.979166666667
          1203.85416666667
          130.401785714286)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'умовне позначення (українське)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel147: TQRLabel
        Left = 503
        Top = 641
        Width = 37
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          950.610119047619
          1211.41369047619
          69.9255952380952)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'код'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel148: TQRLabel
        Left = 8
        Top = 36
        Width = 257
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          15.1190476190476
          68.0357142857143
          485.699404761905)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зведена податкова накладна'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape116: TQRShape
        Left = 3
        Top = 28
        Width = 343
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          5.66964285714286
          52.9166666666667
          648.229166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape117: TQRShape
        Left = 346
        Top = 28
        Width = 41
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          653.89880952381
          52.9166666666667
          77.485119047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel149: TQRLabel
        Left = 8
        Top = 32
        Width = 310
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          15.1190476190476
          60.4761904761905
          585.863095238095)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Складена на операції, звільнені від оподаткування'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel3: TQRLabel
        Left = 414
        Top = 315
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          782.410714285714
          595.3125
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRShape120: TQRShape
        Left = 856
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1617.7380952381
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape121: TQRShape
        Left = 882
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1666.875
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape122: TQRShape
        Left = 907
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1714.12202380952
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel137: TQRLabel
        Left = 876
        Top = 319
        Width = 63
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1655.53571428571
          602.872023809524
          119.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(номер філії)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel150: TQRLabel
        Left = 938
        Top = 315
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1772.70833333333
          595.3125
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRShape123: TQRShape
        Left = 932
        Top = 291
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1761.36904761905
          549.955357142857
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel6: TQRLabel
        Left = 765
        Top = 606
        Width = 41
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1445.75892857143
          1145.26785714286
          77.485119047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код пільги'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel7: TQRLabel
        Left = 719
        Top = 606
        Width = 41
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1358.8244047619
          1145.26785714286
          77.485119047619)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код ставки'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape3: TQRShape
        Left = 3
        Top = 552
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          1043.21428571429
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel15: TQRLabel
        Left = 8
        Top = 553
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1045.10416666667
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Х'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape31: TQRShape
        Left = 3
        Top = 572
        Width = 989
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          1081.0119047619
          1869.09226190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel16: TQRLabel
        Left = 8
        Top = 574
        Width = 72
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1084.79166666667
          136.071428571429)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розділ Б'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape39: TQRShape
        Left = 827
        Top = 552
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          1043.21428571429
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape40: TQRShape
        Left = 3
        Top = 532
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          1005.41666666667
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel18: TQRLabel
        Left = 8
        Top = 533
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1007.30654761905
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'IХ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel20: TQRLabel
        Left = 56
        Top = 534
        Width = 632
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          1009.19642857143
          1194.40476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Усього обсяги операцій, звільнених від оподаткування (код ставки' +
          ' 903)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape46: TQRShape
        Left = 827
        Top = 532
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          1005.41666666667
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape51: TQRShape
        Left = 3
        Top = 512
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          967.619047619048
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel21: TQRLabel
        Left = 8
        Top = 513
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          969.508928571429
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'VII'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel22: TQRLabel
        Left = 56
        Top = 514
        Width = 628
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          971.39880952381
          1186.84523809524)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Усього обсяги постачання на митній території України за ставкою ' +
          '0% (код ставки 902)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape54: TQRShape
        Left = 827
        Top = 512
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          967.619047619048
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape56: TQRShape
        Left = 3
        Top = 492
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          929.821428571429
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel24: TQRLabel
        Left = 8
        Top = 493
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          931.71130952381
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'VII'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel29: TQRLabel
        Left = 56
        Top = 494
        Width = 660
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          933.60119047619
          1247.32142857143)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Усього обсяги постачання при експорті товарів за ставкою 0% (код' +
          ' ставки 901)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape58: TQRShape
        Left = 827
        Top = 492
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          929.821428571429
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape59: TQRShape
        Left = 3
        Top = 472
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          892.02380952381
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel30: TQRLabel
        Left = 8
        Top = 473
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          893.91369047619
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'VI'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel31: TQRLabel
        Left = 56
        Top = 474
        Width = 644
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          895.803571428571
          1217.08333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Усього обсяги постачання за ставкою 7% (код ставки 7)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape61: TQRShape
        Left = 827
        Top = 472
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          892.02380952381
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape62: TQRShape
        Left = 3
        Top = 452
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          854.22619047619
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel32: TQRLabel
        Left = 8
        Top = 453
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          856.116071428571
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'V'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel34: TQRLabel
        Left = 56
        Top = 454
        Width = 640
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          858.005952380952
          1209.52380952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Усього обсяги постачання за основною ставкою (код ставки 20)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape64: TQRShape
        Left = 827
        Top = 452
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          854.22619047619
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape65: TQRShape
        Left = 3
        Top = 432
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          816.428571428571
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel36: TQRLabel
        Left = 8
        Top = 433
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          818.318452380952
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'IV'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel37: TQRLabel
        Left = 56
        Top = 434
        Width = 632
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          820.208333333333
          1194.40476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'загальна сума податку на додану вартість за  ставкою 7%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape70: TQRShape
        Left = 827
        Top = 432
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          816.428571428571
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape101: TQRShape
        Left = 3
        Top = 412
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          778.630952380952
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel38: TQRLabel
        Left = 8
        Top = 413
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          780.520833333333
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'III'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel39: TQRLabel
        Left = 56
        Top = 414
        Width = 620
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          782.410714285714
          1171.72619047619)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'загальна сума податку на додану вартість за основною ставкою'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape103: TQRShape
        Left = 827
        Top = 412
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          778.630952380952
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape111: TQRShape
        Left = 3
        Top = 392
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          740.833333333333
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel40: TQRLabel
        Left = 8
        Top = 393
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          742.723214285714
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'II'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel41: TQRLabel
        Left = 56
        Top = 394
        Width = 592
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          744.613095238095
          1118.80952380952)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Загальна сума податку на додану вартість, у тому числі:'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape125: TQRShape
        Left = 827
        Top = 392
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          740.833333333333
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape126: TQRShape
        Left = 3
        Top = 372
        Width = 45
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          703.035714285714
          85.0446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel42: TQRLabel
        Left = 8
        Top = 373
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          704.925595238095
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'I'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel43: TQRLabel
        Left = 56
        Top = 374
        Width = 752
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          105.833333333333
          706.815476190476
          1421.19047619048)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Загальна сума коштів, що підлягають сплаті з урахуванням податку' +
          ' на додану вартість          '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape128: TQRShape
        Left = 827
        Top = 372
        Width = 165
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1562.93154761905
          703.035714285714
          311.830357142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape129: TQRShape
        Left = 3
        Top = 352
        Width = 989
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          665.238095238095
          1869.09226190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel44: TQRLabel
        Left = 8
        Top = 354
        Width = 72
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          669.017857142857
          136.071428571429)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розділ А'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object qrlNDS: TQRLabel
        Left = 879
        Top = 414
        Width = 108
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          1661.20535714286
          782.410714285714
          204.107142857143)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'qrlNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object qrlSum: TQRLabel
        Left = 879
        Top = 374
        Width = 109
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          1661.20535714286
          706.815476190476
          205.997023809524)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'qrlSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object qrlValue: TQRLabel
        Left = 879
        Top = 454
        Width = 108
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          1661.20535714286
          858.005952380952
          204.107142857143)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'qrlValue'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel45: TQRLabel
        Left = 803
        Top = 615
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1517.5744047619
          1162.27678571429
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '4'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRLFbnFil1: TQRLabel
        Left = 859
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1623.40773809524
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLFbnFil2: TQRLabel
        Left = 886
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1674.43452380952
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLFbnFil3: TQRLabel
        Left = 911
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1721.68154761905
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLFbnFil4: TQRLabel
        Left = 936
        Top = 295
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1768.92857142857
          557.514880952381
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLabel77'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel48: TQRLabel
        Left = 361
        Top = 10
        Width = 8
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          682.247023809524
          18.8988095238095
          15.1190476190476)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Х'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object qrlNDS2: TQRLabel
        Left = 879
        Top = 394
        Width = 108
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          1661.20535714286
          744.613095238095
          204.107142857143)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'qrlNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel50: TQRLabel
        Left = 311
        Top = 594
        Width = 37
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          32.1279761904762
          587.752976190476
          1122.58928571429
          69.9255952380952)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRShape86: TQRShape
        Left = 318
        Top = 612
        Width = 42
        Height = 79
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          149.300595238095
          600.982142857143
          1156.60714285714
          79.375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel51: TQRLabel
        Left = 319
        Top = 613
        Width = 39
        Height = 76
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          143.630952380952
          602.872023809524
          1158.49702380952
          73.7053571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ознака імпор- товано- го то- вару'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel52: TQRLabel
        Left = 350
        Top = 667
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          661.458333333333
          1260.5505952381
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '3'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRShape91: TQRShape
        Left = 358
        Top = 612
        Width = 68
        Height = 79
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          149.300595238095
          676.577380952381
          1156.60714285714
          128.511904761905)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel55: TQRLabel
        Left = 362
        Top = 627
        Width = 60
        Height = 57
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          107.723214285714
          684.136904761905
          1184.95535714286
          113.392857142857)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'послуги згідно з ДКПП'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel56: TQRLabel
        Left = 935
        Top = 597
        Width = 54
        Height = 84
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          158.75
          1767.03869047619
          1128.25892857143
          102.053571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код виду діяльності сільського- сподарсько- го товаро- виробника'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
    end
    object QRBand2: TQRBand
      Left = 53
      Top = 821
      Width = 1058
      Height = 309
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AfterPrint = QRBand2AfterPrint
      AlignToBottom = False
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        583.973214285714
        1999.49404761905)
      BandType = rbSummary
      object QRMemo2: TQRMemo
        Left = 16
        Top = 144
        Width = 987
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          56.6964285714286
          30.2380952380952
          272.142857142857
          1865.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        Lines.Strings = (
          
            'У порядковому номері після символу "/" зазначається код 2 - у ра' +
            'зі здійснення операцій з постачання власновироблених товарів, от' +
            'риманих за результатами видів діяльності, визначених в пункті 16' +
            ' 1 .3 статті 16 1  Закону '
          
            'України  "Про державну підтримку сільського господарства України' +
            '", або код 5 - у разі складання податкової накладної оператором ' +
            'інвестору за багатосторонньою угодою про розподіл продукції.')
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRLabel62: TQRLabel
        Left = 4
        Top = 8
        Width = 984
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          7.55952380952381
          15.1190476190476
          1859.64285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'Суми податку на додану вартість, нараховані (сплачені) у зв'#39'язку' +
          ' з постачанням товарів/послуг, зазначених у цій накладній, визна' +
          'чені правильно, відповідають сумі податкових зобов'#39'язань продавц' +
          'я.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel63: TQRLabel
        Left = 51
        Top = 48
        Width = 221
        Height = 38
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Frame.Style = psClear
        Size.Values = (
          71.8154761904762
          96.3839285714286
          90.7142857142857
          417.66369047619)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Посадова (уповноважена) особа/фізична особа '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel64: TQRLabel
        Left = 453
        Top = 89
        Width = 127
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          856.116071428571
          168.199404761905
          240.014880952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(ініціали та прізвище) '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel66: TQRLabel
        Left = 43
        Top = 253
        Width = 965
        Height = 31
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          58.5863095238095
          81.264880952381
          478.139880952381
          1823.73511904762)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          '(у разі відсутності пільги у довідниках податкових пільг зазнача' +
          'ються відповідні пункти (підпункти), статті, підрозділи, розділи' +
          ' Податкового кодексу України та/або міжнародного договору, якими' +
          ' передбачено звільнення від оподаткування)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRLabel76: TQRLabel
        Left = 316
        Top = 69
        Width = 380
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          597.202380952381
          130.401785714286
          718.154761904762)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '  '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape89: TQRShape
        Left = 4
        Top = 131
        Width = 91
        Height = 11
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          20.7886904761905
          7.55952380952381
          247.574404761905
          171.979166666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRLabel33: TQRLabel
        Left = 16
        Top = 231
        Width = 984
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          30.2380952380952
          436.5625
          1859.64285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = '           '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel49: TQRLabel
        Left = 6
        Top = 226
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          11.3392857142857
          427.113095238095
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '4'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel115: TQRLabel
        Left = 16
        Top = 181
        Width = 984
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          30.2380952380952
          342.068452380952
          1859.64285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'У випадку постачання товару, ввезеного на митну територію Україн' +
          'и, у графі 3.2 проставляється позначка "Х" '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel132: TQRLabel
        Left = 6
        Top = 144
        Width = 7
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          11.3392857142857
          272.142857142857
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel133: TQRLabel
        Left = 6
        Top = 177
        Width = 7
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          11.3392857142857
          334.508928571429
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel19: TQRLabel
        Left = 51
        Top = 84
        Width = 221
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Frame.Style = psClear
        Size.Values = (
          41.577380952381
          96.3839285714286
          158.75
          417.66369047619)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '(законний представник)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape45: TQRShape
        Left = 710
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1341.81547619048
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape73: TQRShape
        Left = 736
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1390.95238095238
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape74: TQRShape
        Left = 761
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1438.1994047619
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape75: TQRShape
        Left = 787
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1487.33630952381
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape76: TQRShape
        Left = 813
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1536.47321428571
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape78: TQRShape
        Left = 838
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1583.72023809524
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape79: TQRShape
        Left = 864
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1632.85714285714
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape81: TQRShape
        Left = 890
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1681.99404761905
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape82: TQRShape
        Left = 915
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1729.24107142857
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape83: TQRShape
        Left = 940
        Top = 67
        Width = 27
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.2470238095238
          1776.4880952381
          126.622023809524
          51.0267857142857)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLINN10: TQRLabel
        Left = 713
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1347.48511904762
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN10'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN9: TQRLabel
        Left = 740
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1398.5119047619
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN9'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN8: TQRLabel
        Left = 765
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1445.75892857143
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN8'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN7: TQRLabel
        Left = 790
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1493.00595238095
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN7'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN6: TQRLabel
        Left = 817
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1544.03273809524
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN6'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN5: TQRLabel
        Left = 841
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1589.38988095238
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN5'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN4: TQRLabel
        Left = 867
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1638.52678571429
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN4'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN3: TQRLabel
        Left = 894
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1689.55357142857
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN3'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN2: TQRLabel
        Left = 919
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1736.8005952381
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLINN1: TQRLabel
        Left = 944
        Top = 71
        Width = 18
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1784.04761904762
          134.181547619048
          34.0178571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLINN1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel57: TQRLabel
        Left = 693
        Top = 93
        Width = 291
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          1309.6875
          175.758928571429
          549.955357142857)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          '(реєстраційний номер облікової картки платника податків або сері' +
          'я та номер паспорта   )'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel59: TQRLabel
        Left = 6
        Top = 281
        Width = 7
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          11.3392857142857
          531.056547619048
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '5'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel60: TQRLabel
        Left = 16
        Top = 285
        Width = 984
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          30.2380952380952
          538.616071428571
          1859.64285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          ' Серію та номер паспорта зазначають фізичні особи, які мають від' +
          'мітку у паспорті про право здійснювати будь-які платежі за серіє' +
          'ю та номером  паспорта.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel46: TQRLabel
        Left = 902
        Top = 107
        Width = 7
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          1704.67261904762
          202.217261904762
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '5'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 5
      end
      object QRLabel68: TQRLabel
        Left = 6
        Top = 201
        Width = 7
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.2380952380952
          11.3392857142857
          379.866071428571
          13.2291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '3'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRLabel69: TQRLabel
        Left = 16
        Top = 205
        Width = 984
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          30.2380952380952
          387.425595238095
          1859.64285714286)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          ' Зазначається у разі постачання/придбання товарів/послуг філією ' +
          '(структурним підрозділом) товарів/послуг, яка фактично є від іме' +
          'ні головного підприємства - платника податку стороною договору.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
    end
    object ChildBand1: TQRChildBand
      Left = 53
      Top = 728
      Width = 1058
      Height = 21
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
        1999.49404761905)
      ParentBand = QRBand1
      object QRShape180: TQRShape
        Left = 3
        Top = 0
        Width = 34
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          0
          64.2559523809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape185: TQRShape
        Left = 36
        Top = 0
        Width = 197
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          68.0357142857143
          0
          372.306547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape183: TQRShape
        Left = 498
        Top = 0
        Width = 46
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          941.160714285714
          0
          86.9345238095238)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape181: TQRShape
        Left = 603
        Top = 0
        Width = 114
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1139.59821428571
          0
          215.446428571429)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape182: TQRShape
        Left = 541
        Top = 0
        Width = 63
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1022.4255952381
          0
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape165: TQRShape
        Left = 715
        Top = 0
        Width = 47
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1351.26488095238
          0
          88.8244047619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape166: TQRShape
        Left = 761
        Top = 0
        Width = 50
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1438.1994047619
          0
          94.4940476190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape168: TQRShape
        Left = 810
        Top = 0
        Width = 124
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1530.80357142857
          0
          234.345238095238)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel67: TQRLabel
        Left = 104
        Top = 1
        Width = 54
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          196.547619047619
          1.88988095238095
          102.053571428571)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel104: TQRLabel
        Left = 502
        Top = 1
        Width = 35
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          948.720238095238
          1.88988095238095
          66.1458333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '5'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel105: TQRLabel
        Left = 547
        Top = 1
        Width = 51
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1033.76488095238
          1.88988095238095
          96.3839285714286)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '6'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel106: TQRLabel
        Left = 628
        Top = 1
        Width = 66
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1186.84523809524
          1.88988095238095
          124.732142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '7'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel107: TQRLabel
        Left = 725
        Top = 1
        Width = 31
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1370.16369047619
          1.88988095238095
          58.5863095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '8'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel108: TQRLabel
        Left = 769
        Top = 1
        Width = 31
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1453.31845238095
          1.88988095238095
          58.5863095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '9'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel109: TQRLabel
        Left = 838
        Top = 1
        Width = 66
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1583.72023809524
          1.88988095238095
          124.732142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '10'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel111: TQRLabel
        Left = 8
        Top = 1
        Width = 25
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1.88988095238095
          47.2470238095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape69: TQRShape
        Left = 232
        Top = 0
        Width = 87
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          438.452380952381
          0
          164.419642857143)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel72: TQRLabel
        Left = 259
        Top = 1
        Width = 34
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          489.479166666667
          1.88988095238095
          64.2559523809524)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '3.1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape1: TQRShape
        Left = 425
        Top = 0
        Width = 75
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          803.199404761905
          0
          141.741071428571)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel1: TQRLabel
        Left = 445
        Top = 1
        Width = 36
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          840.997023809524
          1.88988095238095
          68.0357142857143)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '4'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape87: TQRShape
        Left = 318
        Top = 0
        Width = 42
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          600.982142857143
          0
          79.375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel53: TQRLabel
        Left = 323
        Top = 1
        Width = 34
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          610.431547619048
          1.88988095238095
          64.2559523809524)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '3.2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape92: TQRShape
        Left = 359
        Top = 0
        Width = 67
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          678.467261904762
          0
          126.622023809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel54: TQRLabel
        Left = 375
        Top = 1
        Width = 34
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          708.705357142857
          1.88988095238095
          64.2559523809524)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '3.3'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape96: TQRShape
        Left = 933
        Top = 0
        Width = 59
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1763.25892857143
          0
          111.502976190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel61: TQRLabel
        Left = 945
        Top = 1
        Width = 31
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1785.9375
          1.88988095238095
          58.5863095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '11'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
    end
    object bSimple: TQRBand
      Left = 53
      Top = 749
      Width = 1058
      Height = 21
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = bSimpleBeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        39.6875
        1999.49404761905)
      BandType = rbDetail
      object QRShape85: TQRShape
        Left = 3
        Top = 0
        Width = 34
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          5.66964285714286
          0
          64.2559523809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape84: TQRShape
        Left = 809
        Top = 0
        Width = 125
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1528.91369047619
          0
          236.235119047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape134: TQRShape
        Left = 36
        Top = 0
        Width = 197
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          68.0357142857143
          0
          372.306547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape135: TQRShape
        Left = 425
        Top = 0
        Width = 76
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          803.199404761905
          0
          143.630952380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape144: TQRShape
        Left = 541
        Top = 0
        Width = 64
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1022.4255952381
          0
          120.952380952381)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape145: TQRShape
        Left = 603
        Top = 0
        Width = 113
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1139.59821428571
          0
          213.556547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape156: TQRShape
        Left = 715
        Top = 0
        Width = 47
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1351.26488095238
          0
          88.8244047619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape186: TQRShape
        Left = 761
        Top = 0
        Width = 50
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1438.1994047619
          0
          94.4940476190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText12: TQRDBText
        Left = 39
        Top = 1
        Width = 190
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.9077380952381
          73.7053571428571
          1.88988095238095
          359.077380952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'text'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRDBText13: TQRDBText
        Left = 545
        Top = 1
        Width = 55
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1029.98511904762
          1.88988095238095
          103.943452380952)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText14: TQRDBText
        Left = 604
        Top = 1
        Width = 108
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1141.4880952381
          1.88988095238095
          204.107142857143)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText16: TQRDBText
        Left = 823
        Top = 1
        Width = 107
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1555.37202380952
          1.88988095238095
          202.217261904762)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'sum_val7'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.00;-#0.00;#'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText20: TQRDBText
        Left = 429
        Top = 1
        Width = 67
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          810.758928571429
          1.88988095238095
          126.622023809524)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'unit'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object l_1: TQRLabel
        Left = 8
        Top = 1
        Width = 25
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1.88988095238095
          47.2470238095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRShape71: TQRShape
        Left = 232
        Top = 0
        Width = 87
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          438.452380952381
          0
          164.419642857143)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape4: TQRShape
        Left = 498
        Top = 0
        Width = 44
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          941.160714285714
          0
          83.1547619047619)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText4: TQRDBText
        Left = 500
        Top = 1
        Width = 41
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          944.940476190476
          1.88988095238095
          77.485119047619)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'unit_kod'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRDBText21: TQRDBText
        Left = 236
        Top = 1
        Width = 81
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          446.011904761905
          1.88988095238095
          153.080357142857)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'uktzed'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 5
      end
      object QRLabel13: TQRLabel
        Left = 725
        Top = 1
        Width = 31
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1370.16369047619
          1.88988095238095
          58.5863095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '20'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape88: TQRShape
        Left = 318
        Top = 0
        Width = 42
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          600.982142857143
          0
          79.375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape93: TQRShape
        Left = 359
        Top = 0
        Width = 67
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          678.467261904762
          0
          126.622023809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText2: TQRDBText
        Left = 361
        Top = 1
        Width = 61
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          682.247023809524
          1.88988095238095
          115.282738095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'uktzed2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 5
      end
      object QRShape97: TQRShape
        Left = 933
        Top = 0
        Width = 59
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1763.25892857143
          0
          111.502976190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
    object bLgota: TQRChildBand
      Left = 53
      Top = 770
      Width = 1058
      Height = 51
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = bLgotaBeforePrint
      Color = clWhite
      Enabled = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        96.3839285714286
        1999.49404761905)
      ParentBand = bSimple
      object QRShape47: TQRShape
        Left = 36
        Top = 1
        Width = 197
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          68.0357142857143
          1.88988095238095
          372.306547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape48: TQRShape
        Left = 425
        Top = 1
        Width = 76
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          803.199404761905
          1.88988095238095
          143.630952380952)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape49: TQRShape
        Left = 541
        Top = 0
        Width = 63
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1022.4255952381
          0
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape50: TQRShape
        Left = 603
        Top = 1
        Width = 113
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1139.59821428571
          1.88988095238095
          213.556547619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape52: TQRShape
        Left = 761
        Top = 1
        Width = 50
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1438.1994047619
          1.88988095238095
          94.4940476190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape55: TQRShape
        Left = 810
        Top = 1
        Width = 124
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1530.80357142857
          1.88988095238095
          234.345238095238)
        Shape = qrsRightAndLeft
        VertAdjust = 0
      end
      object QRDBText8: TQRDBText
        Left = 39
        Top = 1
        Width = 190
        Height = 45
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          85.0446428571429
          73.7053571428571
          1.88988095238095
          359.077380952381)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'text'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRDBText9: TQRDBText
        Left = 545
        Top = 1
        Width = 55
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1029.98511904762
          1.88988095238095
          103.943452380952)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText10: TQRDBText
        Left = 604
        Top = 1
        Width = 108
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1141.4880952381
          1.88988095238095
          204.107142857143)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape80: TQRShape
        Left = 2
        Top = 1
        Width = 3
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          3.7797619047619
          1.88988095238095
          5.66964285714286)
        Shape = qrsVertLine
        VertAdjust = 0
      end
      object QRDBText3: TQRDBText
        Left = 823
        Top = 5
        Width = 109
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          43.4672619047619
          1555.37202380952
          9.44940476190476
          205.997023809524)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'sum_val7'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.00;-#0.00;#'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText5: TQRDBText
        Left = 429
        Top = 3
        Width = 67
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          810.758928571429
          5.66964285714286
          126.622023809524)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'unit'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object l_1_1: TQRLabel
        Left = 8
        Top = 1
        Width = 25
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          15.1190476190476
          1.88988095238095
          47.2470238095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRShape72: TQRShape
        Left = 232
        Top = 1
        Width = 87
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          438.452380952381
          1.88988095238095
          164.419642857143)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape104: TQRShape
        Left = 715
        Top = 1
        Width = 47
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1351.26488095238
          1.88988095238095
          88.8244047619048)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape32: TQRShape
        Left = 498
        Top = 1
        Width = 46
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          941.160714285714
          1.88988095238095
          86.9345238095238)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText19: TQRDBText
        Left = 503
        Top = 1
        Width = 38
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          950.610119047619
          1.88988095238095
          71.8154761904762)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'unit_kod'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 6
      end
      object QRDBText22: TQRDBText
        Left = 236
        Top = 5
        Width = 81
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          43.4672619047619
          446.011904761905
          9.44940476190476
          153.080357142857)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'uktzed'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 5
      end
      object QRLabel14: TQRLabel
        Left = 725
        Top = 1
        Width = 31
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.0178571428571
          1370.16369047619
          1.88988095238095
          58.5863095238095)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '20'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRShape90: TQRShape
        Left = 318
        Top = 1
        Width = 42
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          600.982142857143
          1.88988095238095
          79.375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape94: TQRShape
        Left = 359
        Top = 1
        Width = 67
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          678.467261904762
          1.88988095238095
          126.622023809524)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText1: TQRDBText
        Left = 361
        Top = 5
        Width = 61
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          43.4672619047619
          682.247023809524
          9.44940476190476
          115.282738095238)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'uktzed2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -7
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 5
      end
      object QRShape98: TQRShape
        Left = 933
        Top = 1
        Width = 59
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.4940476190476
          1763.25892857143
          1.88988095238095
          111.502976190476)
        Shape = qrsRectangle
        VertAdjust = 0
      end
    end
  end
  object ZQTax: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select t.reg_num,t.reg_date, t.int_num,abon.id as abonid, t.id_p' +
        'ref,'
      
        'CASE WHEN trim(users.represent_name) ~ '#39'^(.+)\\s(.)\\.(.)\\.$'#39' T' +
        'HEN'
      
        'substr(trim(users.represent_name),length(trim(users.represent_na' +
        'me))-3,4)||'#39' '#39'||substr(trim(users.represent_name),0,length(trim(' +
        'users.represent_name))-4) ELSE represent_name END as represent_n' +
        'ame,'
      'users.inn, '
      
        'CASE WHEN coalesce(abon.add_name,'#39#39')='#39#39' THEN abon.name ELSE abon' +
        '.add_name END as abonname,'
      'res.name as resname,'
      
        'CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE C' +
        'ASE WHEN trim(coalesce(abonpar.addr_main,'#39#39'))='#39#39' THEN abonpar.ad' +
        'dr_tax ELSE  abonpar.addr_main||'#39' / \n'#39'||abonpar.addr_tax END EN' +
        'D::::varchar as abonaddr,'
      'abon.name as abonnamesh,t.text as taxtext,'
      'chpar.addr_tax||'#39' / \n'#39'||respar.addr_tax as resaddr,'
      
        'abonpar.doc_num, abonpar.doc_dat,abonpar.tax_num as taxnum_abon,' +
        'abonpar.licens_num as SvidNum_abon,'
      
        'abonpar.flag_taxpay,abon.code, abonpar.id_section, abonpar.filia' +
        'l_num, '
      'respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res,'
      'abonpar.phone as abonphone,respar.phone as resphone,'
      
        't.value_tax,t.value, t.sum_val7,t.sum_val8, getsysvar('#39'tax_1copy' +
        #39') as print_1_copy, t.flag_reg'
      
        'from (select t1.*, td.sum_val7,td.sum_val8,td.text from acm_tax_' +
        'tbl as t1 left join acd_tax_tbl as td on (t1.id_doc = td.id_doc)'
      'where (t1.id_doc = :doc) limit 1) as t'
      'left join clm_position_tbl as users on (users.id = t.id_person),'
      
        'clm_client_tbl as res left join clm_statecl_tbl as respar on (re' +
        'spar.id_client = res.id),'
      
        'clm_client_tbl as abon left join clm_statecl_h as abonpar on (ab' +
        'onpar.id_client = abon.id),'
      
        'clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (c' +
        'hpar.id_client = chnoe.id)'
      'where t.id_client = abon.id'
      
        'and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as a' +
        'bonpar2 where abonpar2.id_client = abonpar.id_client and abonpar' +
        '2.mmgg_b <=t.mmgg  )'
      
        'and (res.id = (select value_ident::::int from syi_sysvars_tbl wh' +
        'ere ident='#39'id_res'#39') )'
      
        'and (chnoe.id = (select value_ident::::int from syi_sysvars_tbl ' +
        'where ident='#39'id_chnoe'#39') );'
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
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
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
    Left = 65532
    Top = 467
    ParamData = <
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
  object ZQTaxSumm: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select ts.dt_bill,ts.text,'
      'ts.demand_val, ts.unit,'
      
        'CASE WHEN t.id_pref <> 20 THEN uktzed END as uktzed, CASE WHEN t' +
        '.id_pref = 20 THEN uktzed END as uktzed2,'
      'unit_kod,'
      'ts.tariff,ts.sum_val7,ts.sum_val8,'
      
        'ts.sum_val9,ts.sum_val10,ts.sum_val7+ts.sum_val8+ts.sum_val9+ts.' +
        'sum_val10 as sum_val'
      
        'from acd_tax_tbl as ts join acm_tax_tbl as t on (t.id_doc = ts.i' +
        'd_doc)'
      'where (ts.id_doc = :doc)'
      ''
      ''
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
    Left = 65535
    Top = 499
    ParamData = <
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
  object crTwoPages: TQRCompositeReport
    OnAddReports = crTwoPagesAddReports
    Options = []
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
    PrinterSettings.Orientation = poPortrait
    PrinterSettings.PaperSize = A4
    Left = 8
    Top = 24
  end
end
