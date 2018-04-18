object fPrintBank: TfPrintBank
  Left = 121
  Top = 138
  Width = 845
  Height = 622
  VertScrollBar.Position = 30
  Caption = 'fPrintBank'
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
  object PrintPay: TQuickRep
    Left = -8
    Top = -18
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = PrintPayBeforePrint
    DataSet = ZQPay
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 10
    Font.Name = 'Arial'
    Font.Style = []
    Functions.Strings = (
      'PAGENUMBER'
      'COLUMNNUMBER'
      'REPORTTITLE'
      'QRSTRINGSBAND1'
      'ALL_VAL'
      'ALL_TAX'
      'ALL_PAY'
      'SSIGNP')
    Functions.DATA = (
      '0'
      '0'
      #39#39
      #39#39
      '0'
      '0'
      '0'
      'ZQPay->FieldByName("sign_pay")->AsInteger')
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
    object TitleBand1: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 159
      Frame.Color = clWhite
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
        420.6875
        1899.70833333333)
      BandType = rbTitle
      object QRLabel1: TQRLabel
        Left = 191
        Top = 40
        Width = 162
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          505.354166666667
          105.833333333333
          428.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Банківська виписка '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object lBillNo: TQRLabel
        Left = 419
        Top = 42
        Width = 78
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          1108.60416666667
          111.125
          206.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lBillNo'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object lResName: TQRLabel
        Left = 4
        Top = 4
        Width = 673
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          10.5833333333333
          10.5833333333333
          1780.64583333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'lResName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 12
      end
      object lResAddr: TQRLabel
        Left = 6
        Top = 25
        Width = 671
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.2708333333333
          15.875
          66.1458333333333
          1775.35416666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'lResAddr'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object lData: TQRLabel
        Left = 557
        Top = 42
        Width = 100
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          1473.72916666667
          111.125
          264.583333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lData'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object QRLabel3: TQRLabel
        Left = 505
        Top = 42
        Width = 46
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          1336.14583333333
          111.125
          121.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'За'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object QRShape2: TQRShape
        Left = 5
        Top = 108
        Width = 58
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          13.2291666666667
          285.75
          153.458333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape11: TQRShape
        Left = 62
        Top = 108
        Width = 67
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          164.041666666667
          285.75
          177.270833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel8: TQRLabel
        Left = 66
        Top = 117
        Width = 55
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          79.375
          174.625
          309.5625
          145.520833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата плат.'
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
      object QRShape10: TQRShape
        Left = 128
        Top = 108
        Width = 75
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          338.666666666667
          285.75
          198.4375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel7: TQRLabel
        Left = 130
        Top = 113
        Width = 61
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          343.958333333333
          298.979166666667
          161.395833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Лицевой'
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
      object QRShape1: TQRShape
        Left = 488
        Top = 108
        Width = 69
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          1291.16666666667
          285.75
          182.5625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel13: TQRLabel
        Left = 495
        Top = 113
        Width = 58
        Height = 33
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          87.3125
          1309.6875
          298.979166666667
          153.458333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Без ПДВ'
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
      object QRShape8: TQRShape
        Left = 556
        Top = 108
        Width = 43
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          1471.08333333333
          285.75
          113.770833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel2: TQRLabel
        Left = 562
        Top = 110
        Width = 35
        Height = 39
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          103.1875
          1486.95833333333
          291.041666666667
          92.6041666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ'
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
      object QRShape7: TQRShape
        Left = 599
        Top = 108
        Width = 74
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          1584.85416666667
          285.75
          195.791666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel31: TQRLabel
        Left = 613
        Top = 116
        Width = 54
        Height = 31
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.0208333333333
          1621.89583333333
          306.916666666667
          142.875)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума'
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
      object QRShape3: TQRShape
        Left = 674
        Top = 108
        Width = 43
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          1783.29166666667
          285.75
          113.770833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel23: TQRLabel
        Left = 677
        Top = 118
        Width = 40
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1791.22916666667
          312.208333333333
          105.833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тип'
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
      object QRShape9: TQRShape
        Left = 202
        Top = 108
        Width = 287
        Height = 43
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          113.770833333333
          534.458333333333
          285.75
          759.354166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel6: TQRLabel
        Left = 214
        Top = 115
        Width = 267
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          566.208333333333
          304.270833333333
          706.4375)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Абонент'
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
      object QRLabel12: TQRLabel
        Left = 8
        Top = 113
        Width = 49
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          21.1666666666667
          298.979166666667
          129.645833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '№ плат.'
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
      object QRLabel9: TQRLabel
        Left = 361
        Top = 40
        Width = 40
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          955.145833333334
          105.833333333333
          105.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '№'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 16
      end
      object QRLabel4: TQRLabel
        Left = 19
        Top = 66
        Width = 42
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          50.2708333333333
          174.625
          111.125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'р/р'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object lAccount: TQRLabel
        Left = 75
        Top = 68
        Width = 220
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          198.4375
          179.916666666667
          582.083333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAccount'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
    end
    object DetailBand1: TQRBand
      Left = 38
      Top = 227
      Width = 718
      Height = 28
      Frame.Color = clBlack
      Frame.DrawTop = True
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      Frame.Style = psDot
      AlignToBottom = False
      BeforePrint = DetailBand1BeforePrint
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
        74.0833333333333
        1899.70833333333)
      BandType = rbDetail
      object DBTNum: TQRDBText
        Left = 4
        Top = 4
        Width = 53
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          10.5833333333333
          10.5833333333333
          140.229166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'reg_num'
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
      object pay: TQRDBText
        Left = 616
        Top = 3
        Width = 59
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1629.83333333333
          7.9375
          156.104166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'pay'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object val: TQRDBText
        Left = 502
        Top = 3
        Width = 59
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1328.20833333333
          7.9375
          156.104166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object tax: TQRDBText
        Left = 568
        Top = 3
        Width = 31
        Height = 26
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          68.7916666666667
          1502.83333333333
          7.9375
          82.0208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'tax'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object nam_eqp: TQRDBText
        Left = 65
        Top = 3
        Width = 58
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          171.979166666667
          7.9375
          153.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'reg_date'
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
      object QRDBText9: TQRDBText
        Left = 132
        Top = 3
        Width = 61
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          349.25
          7.9375
          161.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'cod'
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
      object QRDBText10: TQRDBText
        Left = 203
        Top = 5
        Width = 290
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          537.104166666667
          13.2291666666667
          767.291666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Color = clWhite
        DataSet = ZQPay
        DataField = 'nam'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 8
      end
      object QRDBText1: TQRDBText
        Left = 682
        Top = 3
        Width = 31
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1804.45833333333
          7.9375
          82.0208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQPay
        DataField = 'pref'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object QRGroup1: TQRGroup
      Left = 38
      Top = 197
      Width = 718
      Height = 30
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
      LinkBand = DetailBand1
      Size.Values = (
        79.375
        1899.70833333333)
      Expression = 'sign_pay'
      FooterBand = QRBand44
      Master = PrintPay
      ReprintOnNewPage = False
      object QRExpr1: TQRExpr
        Left = 8
        Top = 4
        Width = 279
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          21.1666666666667
          10.5833333333333
          738.1875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(sign_pay > 0, '#39'Поступление'#39' ,'#39'Видаток'#39')'
        FontSize = -11
      end
    end
    object QRBand44: TQRBand
      Left = 38
      Top = 255
      Width = 718
      Height = 28
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand44BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        74.0833333333333
        1899.70833333333)
      BandType = rbGroupFooter
      object QRLabel10: TQRLabel
        Left = 364
        Top = 4
        Width = 63
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          963.083333333333
          10.5833333333333
          166.6875)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lTax: TQRLabel
        Left = 560
        Top = 6
        Width = 57
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1481.66666666667
          15.875
          150.8125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lTax'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lVal: TQRLabel
        Left = 462
        Top = 6
        Width = 93
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1222.375
          15.875
          246.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lVal'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lPay: TQRLabel
        Left = 622
        Top = 6
        Width = 89
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1645.70833333333
          15.875
          235.479166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lPay'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
    end
    object QRBand1: TQRBand
      Left = 38
      Top = 283
      Width = 718
      Height = 42
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
        111.125
        1899.70833333333)
      BandType = rbSummary
      object QRLabel5: TQRLabel
        Left = 9
        Top = 14
        Width = 301
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          23.8125
          37.0416666666667
          796.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
    end
  end
  object lBank: TQRLabel
    Left = 189
    Top = 126
    Width = 518
    Height = 20
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Size.Values = (
      52.9166666666667
      500.0625
      333.375
      1370.54166666667)
    Alignment = taLeftJustify
    AlignToBand = False
    AutoSize = False
    AutoStretch = False
    Caption = 'lBank'
    Color = clWhite
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
    WordWrap = True
    FontSize = 12
  end
  object QRLabel17: TQRLabel
    Left = 49
    Top = 124
    Width = 42
    Height = 20
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Size.Values = (
      52.9166666666667
      129.645833333333
      328.083333333333
      111.125)
    Alignment = taLeftJustify
    AlignToBand = False
    AutoSize = False
    AutoStretch = False
    Caption = 'Банк'
    Color = clWhite
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
    WordWrap = True
    FontSize = 12
  end
  object lMFO: TQRLabel
    Left = 105
    Top = 126
    Width = 78
    Height = 20
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    Size.Values = (
      52.9166666666667
      277.8125
      333.375
      206.375)
    Alignment = taLeftJustify
    AlignToBand = False
    AutoSize = False
    AutoStretch = False
    Caption = 'lMFO'
    Color = clWhite
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
    WordWrap = True
    FontSize = 12
  end
  object PrintBill: TQRCompositeReport
    OnAddReports = PrintBillAddReports
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
    ReportTitle = 'Рахунок'
    Left = 692
    Top = 354
  end
  object ZQHead: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select h.reg_num,h.reg_date,h.mfo_self as mfo,h.account_self as ' +
        'account,'
      'res.name as resname,raddr.full_adr as resaddr,b.name as bank'
      'from acm_headpay_tbl as h ,'
      
        'clm_client_tbl as res left join clm_statecl_tbl as respar on (re' +
        'spar.id_client = res.id)'
      
        'left join adv_address_tbl as raddr on (raddr.id = res.id_addres)' +
        ',cmi_bank_tbl b'
      'where (h.id = :doc) and (h.mfo_self=b.id)'
      
        'and (res.id in (select value_ident::::int from syi_sysvars_tbl w' +
        'here ident='#39'id_res'#39') );'
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 48
    Top = 62
    ParamData = <
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end
      item
        DataType = ftUnknown
        Name = ':'
        ParamType = ptUnknown
      end>
  end
  object ZQPay: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkFields = 'id_point=id_point'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsDemand
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    DataSource = dsDemand
    Sql.Strings = (
      
        'Select h.id, p.reg_num,p.reg_date ,  p.id_client,   c.code as co' +
        'd,'
      '   c.short_name as nam,p.id_pref,pr.name as pref,p.sign_pay,'
      
        '  cast(p.value as numeric(14,2)) as val,p.value_tax as tax,p.val' +
        'ue_pay as pay'
      'from acm_headpay_tbl as h'
      ' left outer join acm_pay_tbl as p on h.id=p.id_headpay,'
      ' clm_client_tbl as c, aci_pref_tbl as pr'
      'where  h.id=:doc  and   p.id_client=c.id  and p.id_pref=pr.id'
      'order by sign_pay;')
    RequestLive = False
    Left = 12
    Top = 213
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end>
  end
  object dsDemand: TDataSource
    AutoEdit = False
    Left = 646
    Top = 373
  end
end
