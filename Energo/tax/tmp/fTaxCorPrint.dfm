object fRepTaxCor: TfRepTaxCor
  Left = 106
  Top = 188
  Width = 948
  Height = 620
  VertScrollBar.Position = 31
  Caption = 'fRepTaxCor'
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
    Left = 5
    Top = -10
    Width = 952
    Height = 1347
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
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
    ShowProgress = False
    SnapToGrid = True
    Units = MM
    Zoom = 120
    PrevFormStyle = fsNormal
    PreviewInitialState = wsMaximized
    object QRBand1: TQRBand
      Left = 45
      Top = 45
      Width = 861
      Height = 688
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
        1516.94444444444
        1898.38541666667)
      BandType = rbTitle
      object QRShape187: TQRShape
        Left = 788
        Top = 602
        Width = 66
        Height = 85
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          187.413194444444
          1737.43055555556
          1327.32638888889
          145.520833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape186: TQRShape
        Left = 724
        Top = 602
        Height = 85
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          187.413194444444
          1596.31944444444
          1327.32638888889
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape156: TQRShape
        Left = 661
        Top = 602
        Width = 64
        Height = 85
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          187.413194444444
          1457.41319444444
          1327.32638888889
          141.111111111111)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape155: TQRShape
        Left = 598
        Top = 602
        Height = 85
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          187.413194444444
          1318.50694444444
          1327.32638888889
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape1: TQRShape
        Left = 3
        Top = 3
        Width = 214
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          6.61458333333333
          6.61458333333333
          472.942708333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape2: TQRShape
        Left = 3
        Top = 24
        Width = 214
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          6.61458333333333
          52.9166666666667
          472.942708333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape3: TQRShape
        Left = 216
        Top = 3
        Width = 34
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          476.25
          6.61458333333333
          74.4140625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape4: TQRShape
        Left = 216
        Top = 24
        Width = 34
        Height = 21
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          46.3020833333333
          476.25
          52.9166666666667
          74.4140625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel1: TQRLabel
        Left = 7
        Top = 7
        Width = 176
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          15.4340277777778
          15.4340277777778
          388.055555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ОРИГІНАЛ (видається покупцю)'
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
      object QRLabel2: TQRLabel
        Left = 6
        Top = 26
        Width = 185
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          13.2291666666667
          57.3263888888889
          407.899305555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'КОПІЯ (залишається у продавця)'
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
      object QRMemo1: TQRMemo
        Left = 512
        Top = 3
        Width = 333
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          1128.88888888889
          6.61458333333333
          734.21875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Lines.Strings = (
          'Додаток №2'
          'до податкової накладної'
          'Затверджено наказом ДПА України '
          'від 30 травня 1997 р. № 165'
          '(у редакції наказу ДПА України 08.10.98р. №469,'
          'зі змінами, внесеними наказом ДПА України 30.06.2005 № 244)')
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRLabel3: TQRLabel
        Left = 34
        Top = 47
        Width = 180
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          74.9652777777778
          103.628472222222
          396.875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(Непотрібне виділити поміткою "Х")'
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
      object QRLabel4: TQRLabel
        Left = 293
        Top = 113
        Width = 160
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          646.024305555556
          249.149305555556
          352.777777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'РОЗРАХУНОК №'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object QRLabel6: TQRLabel
        Left = 14
        Top = 220
        Width = 114
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          30.8680555555556
          485.069444444444
          251.354166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Особа (платник податку) - продавець'
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
      object QRLabel7: TQRLabel
        Left = 416
        Top = 220
        Width = 114
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          917.222222222222
          485.069444444444
          251.354166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Особа (платник податку) - покупець'
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
      object QRLabel9: TQRLabel
        Left = 132
        Top = 198
        Width = 59
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          291.041666666667
          436.5625
          130.086805555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Продавець'
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
        Left = 542
        Top = 200
        Width = 52
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1195.03472222222
          440.972222222222
          114.652777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Покупець'
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
        Left = 131
        Top = 216
        Width = 248
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          288.836805555556
          476.25
          546.805555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape6: TQRShape
        Left = 542
        Top = 216
        Width = 248
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          1195.03472222222
          476.25
          546.805555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape7: TQRShape
        Left = 113
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          249.149305555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape8: TQRShape
        Left = 134
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          295.451388888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape9: TQRShape
        Left = 156
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          343.958333333333
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape10: TQRShape
        Left = 179
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          394.670138888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape11: TQRShape
        Left = 200
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          440.972222222222
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape12: TQRShape
        Left = 223
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          491.684027777778
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape13: TQRShape
        Left = 245
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          540.190972222222
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape14: TQRShape
        Left = 266
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          586.493055555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape15: TQRShape
        Left = 289
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          637.204861111111
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape16: TQRShape
        Left = 311
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          685.711805555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape17: TQRShape
        Left = 332
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          732.013888888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape18: TQRShape
        Left = 355
        Top = 268
        Width = 25
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          782.725694444444
          590.902777777778
          55.1215277777778)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape19: TQRShape
        Left = 527
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1161.96180555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape20: TQRShape
        Left = 548
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1208.26388888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape21: TQRShape
        Left = 571
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1258.97569444444
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape22: TQRShape
        Left = 593
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1307.48263888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape23: TQRShape
        Left = 614
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1353.78472222222
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape24: TQRShape
        Left = 637
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1404.49652777778
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape25: TQRShape
        Left = 659
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1453.00347222222
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape26: TQRShape
        Left = 680
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1499.30555555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape27: TQRShape
        Left = 703
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1550.01736111111
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape28: TQRShape
        Left = 725
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1598.52430555556
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape29: TQRShape
        Left = 746
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1644.82638888889
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape30: TQRShape
        Left = 768
        Top = 268
        Width = 23
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          1693.33333333333
          590.902777777778
          50.7118055555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel11: TQRLabel
        Left = 134
        Top = 291
        Width = 238
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          295.451388888889
          641.614583333333
          524.756944444445)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(індивідуальний податковий номер продавця)'
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
      object QRLabel12: TQRLabel
        Left = 562
        Top = 292
        Width = 230
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1239.13194444444
          643.819444444444
          507.118055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(індивідуальний податковий номер покупця)'
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
      object QRLabel13: TQRLabel
        Left = 2
        Top = 316
        Width = 104
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          4.40972222222222
          696.736111111111
          229.305555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Місце знаходження продавця'
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
      object QRLabel14: TQRLabel
        Left = 402
        Top = 316
        Width = 103
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          886.354166666667
          696.736111111111
          227.100694444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Місце знаходження покупця'
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
      object QRLabel15: TQRLabel
        Left = 2
        Top = 347
        Width = 88
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          4.40972222222222
          765.086805555556
          194.027777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Номер телефону'
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
      object QRLabel16: TQRLabel
        Left = 402
        Top = 347
        Width = 88
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          886.354166666667
          765.086805555556
          194.027777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Номер телефону'
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
      object QRLabel17: TQRLabel
        Left = 4
        Top = 368
        Width = 176
        Height = 46
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          101.423611111111
          8.81944444444444
          811.388888888889
          388.055555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Номер свідоцтва про реєстрацію платника податку на додану вартіс' +
          'ть (продавця)'
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
      object QRLabel18: TQRLabel
        Left = 424
        Top = 370
        Width = 178
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.8090277777778
          934.861111111111
          815.798611111111
          392.465277777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Номер свідоцтва про реєстрацію платника податку на додану вартіс' +
          'ть (покупця)'
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
        Left = 196
        Top = 375
        Width = 185
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          77.1701388888889
          432.152777777778
          826.822916666667
          407.899305555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape32: TQRShape
        Left = 606
        Top = 375
        Width = 185
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          77.1701388888889
          1336.14583333333
          826.822916666667
          407.899305555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel19: TQRLabel
        Left = 2
        Top = 425
        Width = 85
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          4.40972222222222
          937.065972222222
          187.413194444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Умова поставки'
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
        Left = 314
        Top = 440
        Width = 199
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          692.326388888889
          970.138888888889
          438.767361111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(форма цивільно-правового договору)'
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
      object QRLabel21: TQRLabel
        Left = 2
        Top = 478
        Width = 166
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          4.40972222222222
          1053.92361111111
          366.006944444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Форма проведених розрахунків'
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
        Left = 238
        Top = 494
        Width = 324
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          524.756944444445
          1089.20138888889
          714.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(бартер, готівка, оплата з розрахункового рахунку, чек, тощо)'
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
      object QRShape33: TQRShape
        Left = 3
        Top = 515
        Width = 44
        Height = 173
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          381.440972222222
          6.61458333333333
          1135.50347222222
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape34: TQRShape
        Left = 46
        Top = 515
        Width = 44
        Height = 173
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          381
          100.541666666667
          1135.0625
          97.8958333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape35: TQRShape
        Left = 88
        Top = 515
        Width = 58
        Height = 173
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          381
          193.145833333333
          1135.0625
          127)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape36: TQRShape
        Left = 144
        Top = 515
        Width = 44
        Height = 173
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          381
          317.5
          1135.0625
          97.8958333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape39: TQRShape
        Left = 407
        Top = 515
        Width = 192
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          897.378472222222
          1135.50347222222
          423.333333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape40: TQRShape
        Left = 407
        Top = 566
        Width = 70
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          266.788194444444
          897.378472222222
          1247.95138888889
          154.340277777778)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape41: TQRShape
        Left = 476
        Top = 566
        Width = 68
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          266.788194444444
          1049.51388888889
          1247.95138888889
          149.930555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape43: TQRShape
        Left = 542
        Top = 566
        Width = 57
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          266.788194444444
          1195.03472222222
          1247.95138888889
          125.677083333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel23: TQRLabel
        Left = 7
        Top = 557
        Width = 34
        Height = 73
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          161.395833333333
          15.875
          1227.66666666667
          74.0833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата кори гуван ня'
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
      object QRLabel24: TQRLabel
        Left = 47
        Top = 556
        Width = 38
        Height = 82
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          179.916666666667
          103.1875
          1225.02083333333
          84.6666666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Причи на кори гуван ня'
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
      object QRLabel25: TQRLabel
        Left = 92
        Top = 522
        Width = 49
        Height = 157
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          346.604166666667
          203.729166666667
          1150.9375
          108.479166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Номен- клатура товарів (послуг) вартість чи кількість яких кори-' +
          ' гується'
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
      object QRLabel26: TQRLabel
        Left = 146
        Top = 545
        Width = 38
        Height = 64
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          140.229166666667
          322.791666666667
          1201.20833333333
          84.6666666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Одини- ця виміру '
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
        Left = 413
        Top = 518
        Width = 176
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          94.8090277777778
          910.607638888889
          1142.11805555556
          388.055555555556)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Підлягають коригуванню обсяги без урахування ПДВ, що оподатковую' +
          'ться за ставками'
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
      object QRLabel30: TQRLabel
        Left = 424
        Top = 594
        Width = 37
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          77.1701388888889
          934.861111111111
          1309.6875
          81.5798611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '  20% (-) (+)'
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
        Left = 546
        Top = 581
        Width = 48
        Height = 70
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          154.340277777778
          1203.85416666667
          1281.02430555556
          105.833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Звільнен ня від ПДВ (ст. 5)   (-)(+)'
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
      object lResName: TQRLabel
        Left = 136
        Top = 218
        Width = 238
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          72.7604166666667
          299.861111111111
          480.659722222222
          524.756944444444)
        Alignment = taCenter
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
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object lResAddr: TQRLabel
        Left = 120
        Top = 316
        Width = 270
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          264.583333333333
          696.736111111111
          595.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResAddr'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lResPhone: TQRLabel
        Left = 120
        Top = 347
        Width = 270
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.4826388888889
          264.583333333333
          765.086805555556
          595.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResPhone'
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
      object lResSvidNum: TQRLabel
        Left = 205
        Top = 383
        Width = 167
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          451.996527777778
          844.461805555556
          368.211805555556)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResSvidNum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object lContract: TQRLabel
        Left = 95
        Top = 425
        Width = 746
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Frame.Style = psDot
        Size.Values = (
          35.2777777777778
          209.461805555556
          937.065972222222
          1644.82638888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lContract'
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
      object lFormPay: TQRLabel
        Left = 180
        Top = 478
        Width = 661
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Frame.Style = psDot
        Size.Values = (
          35.2777777777778
          396.875
          1053.92361111111
          1457.41319444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Оплата на  поточний рахунок із спеціальним режимом використання '
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
      object lAbonAddr: TQRLabel
        Left = 514
        Top = 316
        Width = 280
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          1133.29861111111
          696.736111111111
          617.361111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonAddr'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object lAbonPhone: TQRLabel
        Left = 514
        Top = 347
        Width = 278
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1133.29861111111
          765.086805555556
          612.951388888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonPhone'
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
      object lAbonName: TQRLabel
        Left = 547
        Top = 218
        Width = 239
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          72.7604166666667
          1206.05902777778
          480.659722222222
          526.961805555556)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 8
        Font.Name = 'Arial Narrow'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -6
      end
      object lAbonSvidNum: TQRLabel
        Left = 610
        Top = 383
        Width = 179
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1344.96527777778
          844.461805555556
          394.670138888889)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonSvidNum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRLabel77: TQRLabel
        Left = 116
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          255.763888888889
          599.722222222222
          37.4826388888889)
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
        Left = 137
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          302.065972222222
          599.722222222222
          37.4826388888889)
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
        Left = 160
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          352.777777777778
          599.722222222222
          37.4826388888889)
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
        Left = 181
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          399.079861111111
          599.722222222222
          37.4826388888889)
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
        Left = 204
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          449.791666666667
          599.722222222222
          37.4826388888889)
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
        Left = 227
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          500.503472222222
          599.722222222222
          37.4826388888889)
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
        Left = 248
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          546.805555555556
          599.722222222222
          37.4826388888889)
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
        Left = 269
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          593.107638888889
          599.722222222222
          37.4826388888889)
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
        Left = 292
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          643.819444444444
          599.722222222222
          37.4826388888889)
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
        Left = 313
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          690.121527777778
          599.722222222222
          37.4826388888889)
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
        Left = 336
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          740.833333333333
          599.722222222222
          37.4826388888889)
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
        Left = 359
        Top = 272
        Width = 17
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          791.545138888889
          599.722222222222
          37.4826388888889)
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
      object lCorNum: TQRLabel
        Left = 456
        Top = 113
        Width = 221
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Frame.Style = psDot
        Size.Values = (
          52.9166666666667
          1005.41666666667
          249.149305555556
          487.274305555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lCorNum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object QRLabel89: TQRLabel
        Left = 530
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1168.57638888889
          599.722222222222
          35.2777777777778)
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
        Left = 551
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1214.87847222222
          599.722222222222
          35.2777777777778)
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
        Left = 574
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1265.59027777778
          599.722222222222
          35.2777777777778)
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
        Left = 596
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1314.09722222222
          599.722222222222
          35.2777777777778)
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
        Left = 618
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1362.60416666667
          599.722222222222
          35.2777777777778)
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
        Left = 640
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1411.11111111111
          599.722222222222
          35.2777777777778)
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
        Left = 662
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1459.61805555556
          599.722222222222
          35.2777777777778)
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
        Left = 683
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1505.92013888889
          599.722222222222
          35.2777777777778)
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
        Left = 706
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1556.63194444444
          599.722222222222
          35.2777777777778)
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
        Left = 728
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1605.13888888889
          599.722222222222
          35.2777777777778)
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
        Left = 750
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1653.64583333333
          599.722222222222
          35.2777777777778)
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
        Left = 772
        Top = 272
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1702.15277777778
          599.722222222222
          35.2777777777778)
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
      object QRLabel31: TQRLabel
        Left = 492
        Top = 594
        Width = 37
        Height = 35
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          77.1701388888889
          1084.79166666667
          1309.6875
          81.5798611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '   0% (-) (+)'
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
      object QRShape37: TQRShape
        Left = 187
        Top = 566
        Width = 56
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          267.229166666667
          412.75
          1248.83333333333
          124.354166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape38: TQRShape
        Left = 242
        Top = 566
        Width = 58
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          267.229166666667
          534.458333333333
          1248.83333333333
          127)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape42: TQRShape
        Left = 299
        Top = 566
        Width = 58
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          266.788194444444
          659.253472222222
          1247.95138888889
          127.881944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape111: TQRShape
        Left = 355
        Top = 566
        Width = 54
        Height = 121
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          266.788194444444
          782.725694444444
          1247.95138888889
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape44: TQRShape
        Left = 187
        Top = 515
        Width = 113
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          412.75
          1135.0625
          248.708333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape134: TQRShape
        Left = 299
        Top = 515
        Width = 110
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          659.253472222222
          1135.50347222222
          242.534722222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape135: TQRShape
        Left = 598
        Top = 515
        Width = 256
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          1318.50694444444
          1135.50347222222
          564.444444444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape144: TQRShape
        Left = 598
        Top = 566
        Width = 128
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          1318.50694444444
          1247.95138888889
          282.222222222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel27: TQRLabel
        Left = 604
        Top = 570
        Width = 118
        Height = 29
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          63.9409722222222
          1331.73611111111
          1256.77083333333
          260.173611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'При від'#39'ємному значенні графи 9'
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
      object QRLabel28: TQRLabel
        Left = 600
        Top = 606
        Width = 60
        Height = 77
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          169.774305555556
          1322.91666666667
          1336.14583333333
          132.291666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Податкове зобов'#39'язання продавця зменшується гр 9 (-) *20%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel32: TQRLabel
        Left = 662
        Top = 606
        Width = 60
        Height = 77
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          169.774305555556
          1459.61805555556
          1336.14583333333
          132.291666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Податковий 1 кредит покупця зменшується гр 9 (-) *20%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRShape145: TQRShape
        Left = 724
        Top = 566
        Width = 130
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          1596.31944444444
          1247.95138888889
          286.631944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel35: TQRLabel
        Left = 732
        Top = 570
        Width = 118
        Height = 29
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          63.9409722222222
          1613.95833333333
          1256.77083333333
          260.173611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'При позитивному значенні графи 9'
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
      object QRLabel116: TQRLabel
        Left = 727
        Top = 606
        Width = 60
        Height = 77
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          169.774305555556
          1602.93402777778
          1336.14583333333
          132.291666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Податкове зобов'#39'язання продавця збільшується гр 9 (+) *20%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel117: TQRLabel
        Left = 791
        Top = 606
        Width = 60
        Height = 77
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          169.774305555556
          1744.04513888889
          1336.14583333333
          132.291666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Податковий 1 кредит покупця збільшується гр 9 (+) *20%'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel118: TQRLabel
        Left = 604
        Top = 527
        Width = 241
        Height = 29
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          63.9409722222222
          1331.73611111111
          1161.96180555556
          531.371527777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Проведення коригування податкового зобов'#39'зання та податкового кр' +
          'едиту'
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
      object QRLabel119: TQRLabel
        Left = 199
        Top = 527
        Width = 92
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          439.208333333333
          1161.52083333333
          203.729166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Коригування кількості'
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
      object QRLabel120: TQRLabel
        Left = 312
        Top = 527
        Width = 86
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          687.916666666667
          1161.96180555556
          189.618055555556)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Коригування вартості'
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
      object QRLabel121: TQRLabel
        Left = 191
        Top = 575
        Width = 49
        Height = 73
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          160.954861111111
          421.128472222222
          1267.79513888889
          108.038194444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'зміна кількості об'#39'єму обсягу  (-) (+)'
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
      object QRLabel122: TQRLabel
        Left = 246
        Top = 575
        Width = 49
        Height = 73
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          161.395833333333
          542.395833333333
          1267.35416666667
          108.479166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ціна поставки товарів (послуг)'
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
      object QRLabel123: TQRLabel
        Left = 308
        Top = 575
        Width = 37
        Height = 49
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.038194444444
          679.097222222222
          1267.79513888889
          81.5798611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зміна ціни   (-) (+)'
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
      object QRLabel124: TQRLabel
        Left = 360
        Top = 570
        Width = 46
        Height = 97
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          213.871527777778
          793.75
          1256.77083333333
          101.423611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'кількість постав ки товарів (послуг)'
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
      object QRLabel52: TQRLabel
        Left = 28
        Top = 137
        Width = 817
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          61.7361111111111
          302.065972222222
          1801.37152777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Коригування кількісних і вартісних показників до податкової накл' +
          'адної'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lTaxInfo: TQRLabel
        Left = 29
        Top = 157
        Width = 817
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          63.5
          346.604166666667
          1801.8125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lTaxInfo'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel5: TQRLabel
        Left = 2
        Top = 457
        Width = 65
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          4.40972222222222
          1007.62152777778
          143.315972222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Дата оплати'
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
      object QRLabel8: TQRLabel
        Left = 94
        Top = 457
        Width = 747
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          207.256944444444
          1007.62152777778
          1647.03125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '      '
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
      object QRLabel53: TQRLabel
        Left = 238
        Top = 254
        Width = 32
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          28.6631944444444
          524.756944444445
          560.034722222222
          70.5555555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(назва)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
      object QRLabel54: TQRLabel
        Left = 650
        Top = 254
        Width = 32
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          28.6631944444444
          1433.15972222222
          560.034722222222
          70.5555555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(назва)'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 6
      end
    end
    object QRBand3: TQRBand
      Left = 45
      Top = 769
      Width = 861
      Height = 18
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand3BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        39.6875
        1898.38541666667)
      BandType = rbDetail
      object QRShape85: TQRShape
        Left = 355
        Top = 0
        Width = 54
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          782.725694444444
          0
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape84: TQRShape
        Left = 408
        Top = 0
        Width = 69
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          899.583333333333
          0
          152.135416666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape83: TQRShape
        Left = 476
        Top = 0
        Width = 68
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1049.51388888889
          0
          149.930555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape82: TQRShape
        Left = 299
        Top = 0
        Width = 57
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          659.253472222222
          0
          125.677083333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape81: TQRShape
        Left = 788
        Top = 0
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1737.43055555556
          0
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape80: TQRShape
        Left = 724
        Top = 0
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1596.31944444444
          0
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape79: TQRShape
        Left = 661
        Top = 0
        Width = 64
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1457.41319444444
          0
          141.111111111111)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape77: TQRShape
        Left = 597
        Top = 0
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1316.30208333333
          0
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape76: TQRShape
        Left = 543
        Top = 0
        Width = 55
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1197.23958333333
          0
          121.267361111111)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape75: TQRShape
        Left = 242
        Top = 0
        Width = 58
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          533.576388888889
          0
          127.881944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape74: TQRShape
        Left = 187
        Top = 0
        Width = 56
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          412.309027777778
          0
          123.472222222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape73: TQRShape
        Left = 144
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          317.5
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRDBText7: TQRDBText
        Left = 245
        Top = 1
        Width = 52
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          540.190972222222
          2.20486111111111
          114.652777777778)
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
        Mask = '#0.0000'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText9: TQRDBText
        Left = 188
        Top = 1
        Width = 53
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          414.513888888889
          2.20486111111111
          116.857638888889)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'cor_demand'
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
      object QRDBText11: TQRDBText
        Left = 548
        Top = 1
        Width = 45
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1208.26388888889
          2.20486111111111
          99.21875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'cor_sum_free'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.00'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText1: TQRDBText
        Left = 412
        Top = 1
        Width = 61
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          908.402777777778
          2.20486111111111
          134.496527777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'cor_sum_20'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.00'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText2: TQRDBText
        Left = 480
        Top = 1
        Width = 60
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1058.33333333333
          2.20486111111111
          132.291666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'cor_sum_0'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.00'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText5: TQRDBText
        Left = 147
        Top = 1
        Width = 37
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          324.114583333333
          2.20486111111111
          81.5798611111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'unit'
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
      object QRShape45: TQRShape
        Left = 3
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          6.61458333333333
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape71: TQRShape
        Left = 45
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          99.21875
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape72: TQRShape
        Left = 87
        Top = 0
        Width = 58
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          191.822916666667
          0
          127.881944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel48: TQRLabel
        Left = 94
        Top = 1
        Width = 38
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          207.256944444444
          2.20486111111111
          83.7847222222222)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'е / ен.'
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
      object QRExpr3: TQRExpr
        Left = 600
        Top = 1
        Width = 57
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1322.91666666667
          2.20486111111111
          125.677083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'IF(cor_tax < 0, cor_tax, 0)'
        Mask = '#0.00'
        FontSize = 7
      end
      object QRExpr1: TQRExpr
        Left = 728
        Top = 1
        Width = 57
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1605.13888888889
          2.20486111111111
          125.677083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'IF(cor_tax > 0, cor_tax, 0)'
        Mask = '#0.00'
        FontSize = 7
      end
      object QRExpr2: TQRExpr
        Left = 664
        Top = 1
        Width = 57
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1464.02777777778
          2.20486111111111
          125.677083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'IF(cor_tax < 0, cor_tax, 0)'
        Mask = '#0.00'
        FontSize = 7
      end
      object QRExpr4: TQRExpr
        Left = 792
        Top = 1
        Width = 57
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1746.25
          2.20486111111111
          125.677083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = True
        WordWrap = True
        Expression = 'IF(cor_tax > 0, cor_tax, 0)'
        Mask = '#0.00'
        FontSize = 7
      end
      object QRDBText3: TQRDBText
        Left = 360
        Top = 1
        Width = 45
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          793.75
          2.20486111111111
          99.21875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'demand'
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
      object QRDBText4: TQRDBText
        Left = 301
        Top = 1
        Width = 52
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          663.663194444444
          2.20486111111111
          114.652777777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQTaxSumm
        DataField = 'cor_tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '#0.0000'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
    end
    object QRBand2: TQRBand
      Left = 45
      Top = 787
      Width = 861
      Height = 268
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
        590.902777777778
        1898.38541666667)
      BandType = rbSummary
      object QRLabel62: TQRLabel
        Left = 3
        Top = 8
        Width = 788
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          72.7604166666667
          6.61458333333333
          17.6388888888889
          1737.43055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'Суми ПДВ, які зкориговані у зв'#39'язку зі зміною кількісних чи варт' +
          'існих показників, що зазначені у цьому розрахунку, визначені пра' +
          'вильно, включені відповідно до податкового зобов'#39'язання з одноча' +
          'ним відображенням  у реєстрі отриманих та виданих'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRLabel63: TQRLabel
        Left = 56
        Top = 69
        Width = 57
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = True
        Frame.DrawBottom = True
        Frame.DrawLeft = True
        Frame.DrawRight = True
        Frame.Style = psDot
        Size.Values = (
          90.3993055555556
          123.472222222222
          152.135416666667
          125.677083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = ' М. П. '
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
        Left = 401
        Top = 88
        Width = 324
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          884.149305555556
          194.027777777778
          714.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(підпис і прізвище особи, яка склала розрахунок коригування)'
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
      object lBottomText: TQRLabel
        Left = 8
        Top = 121
        Width = 788
        Height = 39
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          85.9895833333333
          17.6388888888889
          266.788194444444
          1737.43055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lBottomText'
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
      object QRLabel66: TQRLabel
        Left = 8
        Top = 232
        Width = 788
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          17.6388888888889
          511.527777777778
          1737.43055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          '1  Зменшення чи збільшення податкового кредиту покупця проводить' +
          'ся лише за умови попереднього включення ним у обсяг податкового ' +
          'кредиту раніше здійснених витрат на сплату податку на підставі п' +
          'одаткової накладної'
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
      object QRLabel76: TQRLabel
        Left = 359
        Top = 71
        Width = 395
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = True
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          791.545138888889
          156.545138888889
          870.920138888889)
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
      object QRLabel49: TQRLabel
        Left = 493
        Top = 208
        Width = 240
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1086.99652777778
          458.611111111111
          529.166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '(Дата отримання розрахунку, підпис покупця)'
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
      object QRShape46: TQRShape
        Left = 416
        Top = 200
        Width = 397
        Height = 9
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          19.84375
          917.222222222222
          440.972222222222
          875.329861111111)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRLabel55: TQRLabel
        Left = 4
        Top = 40
        Width = 140
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          8.81944444444444
          88.1944444444445
          308.680555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'податкових накладних'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object QrHeader: TQRBand
      Left = 45
      Top = 733
      Width = 861
      Height = 36
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
        79.375
        1898.38541666667)
      BandType = rbColumnHeader
      object QRShape56: TQRShape
        Left = 3
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          6.61458333333333
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape57: TQRShape
        Left = 45
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          99.21875
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape58: TQRShape
        Left = 87
        Top = 0
        Width = 58
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          191.822916666667
          0
          127.881944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape59: TQRShape
        Left = 144
        Top = 0
        Width = 44
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          317.5
          0
          97.0138888888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape60: TQRShape
        Left = 187
        Top = 0
        Width = 56
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          412.309027777778
          0
          123.472222222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape61: TQRShape
        Left = 242
        Top = 0
        Width = 58
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          533.576388888889
          0
          127.881944444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape62: TQRShape
        Left = 543
        Top = 0
        Width = 55
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1197.23958333333
          0
          121.267361111111)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape63: TQRShape
        Left = 597
        Top = 0
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1316.30208333333
          0
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape64: TQRShape
        Left = 661
        Top = 0
        Width = 64
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1457.41319444444
          0
          141.111111111111)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape65: TQRShape
        Left = 724
        Top = 0
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1596.31944444444
          0
          143.315972222222)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape66: TQRShape
        Left = 788
        Top = 0
        Width = 66
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1737.43055555556
          0
          145.520833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel36: TQRLabel
        Left = 8
        Top = 1
        Width = 32
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          18.1901041666667
          1.65364583333333
          71.1067708333333)
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
      object QRLabel37: TQRLabel
        Left = 51
        Top = 1
        Width = 34
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          112.447916666667
          2.20486111111111
          74.9652777777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel38: TQRLabel
        Left = 94
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          207.256944444444
          2.20486111111111
          94.8090277777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '3'
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
      object QRLabel39: TQRLabel
        Left = 146
        Top = 1
        Width = 38
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          321.909722222222
          2.20486111111111
          83.7847222222222)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel40: TQRLabel
        Left = 196
        Top = 1
        Width = 37
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          432.152777777778
          2.20486111111111
          81.5798611111111)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel41: TQRLabel
        Left = 250
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          551.215277777778
          2.20486111111111
          94.8090277777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel42: TQRLabel
        Left = 552
        Top = 1
        Width = 36
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1217.08333333333
          2.20486111111111
          79.375)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel43: TQRLabel
        Left = 604
        Top = 1
        Width = 49
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1331.73611111111
          2.20486111111111
          108.038194444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '12'
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
      object QRLabel44: TQRLabel
        Left = 674
        Top = 1
        Width = 39
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1486.07638888889
          2.20486111111111
          85.9895833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '13'
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
      object QRLabel45: TQRLabel
        Left = 792
        Top = 1
        Width = 56
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1746.25
          2.20486111111111
          123.472222222222)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '15'
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
      object QRLabel46: TQRLabel
        Left = 732
        Top = 1
        Width = 46
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1613.95833333333
          2.20486111111111
          101.423611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '14'
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
      object QRShape67: TQRShape
        Left = 299
        Top = 0
        Width = 57
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          659.253472222222
          0
          125.677083333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape68: TQRShape
        Left = 476
        Top = 0
        Width = 68
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1049.51388888889
          0
          149.930555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape69: TQRShape
        Left = 408
        Top = 0
        Width = 69
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          899.583333333333
          0
          152.135416666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape70: TQRShape
        Left = 355
        Top = 0
        Width = 54
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          782.725694444444
          0
          119.0625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel33: TQRLabel
        Left = 306
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          674.6875
          2.20486111111111
          94.8090277777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel47: TQRLabel
        Left = 362
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          798.159722222222
          2.20486111111111
          94.8090277777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel50: TQRLabel
        Left = 418
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          921.631944444444
          2.20486111111111
          94.8090277777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRLabel51: TQRLabel
        Left = 490
        Top = 1
        Width = 43
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1080.38194444444
          2.20486111111111
          94.8090277777778)
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
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object lDateStr: TQRLabel
        Left = 0
        Top = 20
        Width = 45
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          0
          44.0972222222222
          99.21875)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lDateStr'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object lReason: TQRLabel
        Left = 49
        Top = 20
        Width = 42
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          108.038194444444
          44.0972222222222
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lDateStr'
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
      
        'select tc.reg_num,tc.reg_date,tc.tax_num as tax_num,tc.tax_date ' +
        'as tax_date,tc.reason,'
      
        'CASE WHEN abonpar.flag_taxpay = 1 THEN abon.name ELSE abon.name ' +
        '|| '#39' (поставка неплатнику податку)'#39' END as abonname,'
      'abon.id as abonid, res.name as resname,'
      
        'CASE WHEN abonpar.addr_main is NULL THEN abonpar.addr_tax ELSE a' +
        'bonpar.addr_main||'#39' / '#39'||abonpar.addr_tax END as abonaddr,'
      'chpar.addr_tax||'#39' / '#39'||respar.addr_tax as resaddr,'
      
        'abonpar.doc_num, abonpar.doc_dat,abonpar.tax_num as taxnum_abon,' +
        'abonpar.licens_num as SvidNum_abon,'
      'respar.tax_num as taxnum_res,respar.licens_num as SvidNum_res,'
      'abonpar.phone as abonphone,'
      
        'respar.phone as resphone, abonpar.flag_taxpay,users.represent_na' +
        'me'
      
        'from acm_taxcorrection_tbl as tc left join acm_tax_tbl as t on (' +
        'tc.id_tax=t.id_doc)'
      
        'left join clm_position_tbl as users on (users.id = tc.id_person)' +
        ','
      
        'clm_client_tbl as res left join clm_statecl_tbl as respar on (re' +
        'spar.id_client = res.id),'
      
        'clm_client_tbl as abon left join clm_statecl_h as abonpar on (ab' +
        'onpar.id_client = abon.id),'
      
        'clm_client_tbl as chnoe left join clm_statecl_tbl as chpar on (c' +
        'hpar.id_client = chnoe.id)'
      'where (tc.id_doc = :doc) and (tc.id_client = abon.id)'
      
        'and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as a' +
        'bonpar2 where abonpar2.id_client = abonpar.id_client and abonpar' +
        '2.mmgg_b <=tc.mmgg  )'
      
        'and (res.id in (select value_ident from syi_sysvars_tbl where id' +
        'ent='#39'id_res'#39') )'
      
        'and (chnoe.id in (select value_ident from syi_sysvars_tbl where ' +
        'ident='#39'id_chnoe'#39') );'
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
      ' ')
    RequestLive = False
    Left = 65532
    Top = 47
    ParamData = <
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
      
        'select ts.unit,ts.tariff,ts.cor_demand,ts.cor_sum_20,ts.cor_sum_' +
        '0,'
      'ts.cor_sum_free,ts.cor_tax,ts.cor_tax_credit,demand,cor_tariff'
      'from acd_taxcorrection_tbl as ts'
      'where (ts.id_doc = :doc)'
      'order by ts.cor_demand;'
      ''
      ''
      ''
      ''
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 65531
    Top = 79
    ParamData = <
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
end
