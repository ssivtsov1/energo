object fPrintBill: TfPrintBill
  Left = 268
  Top = 114
  Width = 1061
  Height = 897
  Caption = 'fPrintBill'
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
  object PrintBill_p1: TQuickRep
    Left = 8
    Top = 16
    Width = 952
    Height = 1347
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    BeforePrint = PrintBill_p1BeforePrint
    DataSet = ZQBillDemand
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = 11
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
      50
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
    Zoom = 120
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object TitleBand1: TQRBand
      Left = 45
      Top = 45
      Width = 861
      Height = 308
      Frame.Color = clWhite
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = TitleBand1BeforePrint
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
        679.097222222222
        1898.38541666667)
      BandType = rbTitle
      object lResName: TQRLabel
        Left = 140
        Top = 4
        Width = 593
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          308.680555555556
          8.81944444444444
          1307.48263888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'lResName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -11
      end
      object QRLabel7: TQRLabel
        Left = 140
        Top = 42
        Width = 46
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          92.6041666666667
          101.423611111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Адреса :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lResBank: TQRLabel
        Left = 140
        Top = 130
        Width = 717
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          286.631944444444
          1580.88541666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResBank'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel9: TQRLabel
        Left = 140
        Top = 256
        Width = 42
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          564.444444444444
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Адреса:'
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
      object lAbonName: TQRLabel
        Left = 140
        Top = 218
        Width = 699
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          308.680555555556
          480.659722222222
          1541.19791666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'lAbonName'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 16
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -12
      end
      object lAbonAddr: TQRLabel
        Left = 187
        Top = 256
        Width = 670
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          412.309027777778
          564.444444444444
          1477.25694444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonAddr'
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
      object lResAddr: TQRLabel
        Left = 192
        Top = 42
        Width = 665
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          423.333333333333
          92.6041666666667
          1466.23263888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 'lResAddr'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lTax_num: TQRLabel
        Left = 346
        Top = 184
        Width = 58
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          762.881944444444
          405.694444444444
          127.881944444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lTax_num'
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
      object lLicens_num: TQRLabel
        Left = 310
        Top = 168
        Width = 77
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          683.506944444444
          370.416666666667
          169.774305555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lLicens_num'
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
      object QRLabel33: TQRLabel
        Left = 140
        Top = 76
        Width = 81
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          167.569444444444
          178.59375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код ЄДРПОУ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object QRLabel46: TQRLabel
        Left = 140
        Top = 184
        Width = 201
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          405.694444444444
          443.177083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Індивідуальний податковий номер'
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
      object QRLabel47: TQRLabel
        Left = 140
        Top = 168
        Width = 165
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          370.416666666667
          363.802083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Свідоцтво платника ПДВ № '
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
      object QRLabel56: TQRLabel
        Left = 140
        Top = 200
        Width = 205
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          440.972222222222
          451.996527777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'система оподаткування - загальна'
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
      object lResMFO: TQRLabel
        Left = 140
        Top = 146
        Width = 453
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          308.680555555556
          321.909722222222
          998.802083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResMFO'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object lFormPay: TQRLabel
        Left = 142
        Top = 98
        Width = 381
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          313.090277777778
          216.076388888889
          840.052083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Поточний рахунок із спеціальним  режимом використання'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object lResAcc: TQRLabel
        Left = 140
        Top = 114
        Width = 381
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          308.680555555556
          251.354166666667
          840.052083333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResAcc'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 9
      end
      object lResKode: TQRLabel
        Left = 226
        Top = 76
        Width = 307
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          498.298611111111
          167.569444444444
          676.892361111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResKode'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object QRLabel11: TQRLabel
        Left = 140
        Top = 58
        Width = 22
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          127.881944444444
          48.5069444444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object QRLabel110: TQRLabel
        Left = 140
        Top = 272
        Width = 22
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          599.722222222222
          48.5069444444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object QRLabel111: TQRLabel
        Left = 140
        Top = 287
        Width = 85
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          308.680555555556
          632.795138888889
          187.413194444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Код ЄДРПОУ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lResPhone: TQRLabel
        Left = 166
        Top = 58
        Width = 307
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          366.006944444444
          127.881944444444
          676.892361111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lResPhone'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lAbonPhone: TQRLabel
        Left = 170
        Top = 272
        Width = 307
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          374.826388888889
          599.722222222222
          676.892361111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonPhone'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lAbonKode: TQRLabel
        Left = 226
        Top = 287
        Width = 307
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          498.298611111111
          632.795138888889
          676.892361111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAbonKode'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 12
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -9
      end
      object lResCaption: TQRLabel
        Left = 8
        Top = 4
        Width = 113
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.7118055555556
          17.6388888888889
          8.81944444444444
          249.149305555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Постачальник :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lAbonCaption: TQRLabel
        Left = 9
        Top = 218
        Width = 112
        Height = 24
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          52.9166666666667
          19.84375
          480.659722222222
          246.944444444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Споживач :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -11
      end
      object lCod: TQRLabel
        Left = 824
        Top = 4
        Width = 32
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1816.80555555556
          8.81944444444444
          70.5555555555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lCod'
        Color = clWhite
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRShape76: TQRShape
        Left = 140
        Top = 162
        Width = 717
        Height = 2
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          4.40972222222222
          308.680555555556
          357.1875
          1580.88541666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape77: TQRShape
        Left = 140
        Top = 96
        Width = 717
        Height = 2
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          4.40972222222222
          308.680555555556
          211.666666666667
          1580.88541666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRImage1: TQRImage
        Left = 8
        Top = 40
        Width = 125
        Height = 145
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          319.704861111111
          17.6388888888889
          88.1944444444444
          275.607638888889)
        AutoSize = True
        Picture.Data = {
          0A544A504547496D6167651C1D0000FFD8FFE000104A46494600010101006000
          600000FFE1005A4578696600004D4D002A000000080005030100050000000100
          00004A0303000100000001000000005110000100000001010000005111000400
          00000100000EC3511200040000000100000EC300000000000186A00000B18FFF
          DB00430002010102010102020202020202020305030303030306040403050706
          07070706070708090B0908080A0807070A0D0A0A0B0C0C0C0C07090E0F0D0C0E
          0B0C0C0CFFDB004301020202030303060303060C0807080C0C0C0C0C0C0C0C0C
          0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C
          0C0C0C0C0C0C0C0C0CFFC00011080078006F03012200021101031101FFC4001F
          0000010501010101010100000000000000000102030405060708090A0BFFC400
          B5100002010303020403050504040000017D0102030004110512213141061351
          6107227114328191A1082342B1C11552D1F02433627282090A161718191A2526
          2728292A3435363738393A434445464748494A535455565758595A6364656667
          68696A737475767778797A838485868788898A92939495969798999AA2A3A4A5
          A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DA
          E1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101
          010101010000000000000102030405060708090A0BFFC400B511000201020404
          0304070504040001027700010203110405213106124151076171132232810814
          4291A1B1C109233352F0156272D10A162434E125F11718191A262728292A3536
          3738393A434445464748494A535455565758595A636465666768696A73747576
          7778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2
          B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7
          E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00FDFCA28A2800
          A28A2800A28AF08FDB77F6F5F0BFEC67E135FB505D6BC59A8A1FECDD16190092
          4EC2594F263881E338258F0A0E091D185C2D6C4D55468479A4F64BFAFC4E6C66
          328E168BAF88928C56EDFF005F81E8FF001AFE3DF843F676F073EBBE32D72CF4
          3D3C1D919949692E5F19D9146B9791B1CE14138C9E809AC0F84FFB406B5F1AAD
          63D4B47F00EBFA5F87EE30D6DA86BF345A7B5DA67FD6240A6494291CA9754DC3
          0475AF02FD92BF638F13FC71F1A5AFC65F8FC5B54F124D89B40F0ECE9B6D7438
          B3B919A13C07E856339DBC33EE93EE7D01F163F68AB8F8333C975AB780FC6975
          E1D83719B58D321B7BE8ED957932490C7319C47804EE11B60632076F4F1183A1
          4A5F56A3FBCA9D5DED1BF68ECE4FCFAF45D4F2F0D8EC4558FD6ABFEEA97456BC
          9AEF3DD457974DDCBA1E983A734573BF0B7E2DF86BE3678420D7BC27AD58EBBA
          4DC1DAB716AFB82B0C65194E19186465580619E457455E34E12849C66ACD7467
          B74EA46715383BA7B35B30A28A2A4A0A28A2800A28A2800A2B88F8B5FB49F807
          E04C1BBC5DE2ED0B41761B960B9BA5FB448319CAC433237E0A7A8AE6BC77FB69
          7833C17FB315C7C56FB45D4DE1B92167D33CDB77B69B56724AC491A48038F318
          705947CB97FBA335D54F0388A8A2E106D49D93B3B36FA27DCE5A98EC35372539
          A4E29B6AEAE92DDB5BD8E6FF00E0A01FB75693FB187C35F32316FA878CB58465
          D1F4E72769C70D3CB8E44699E9905CFCA08E597C37FE09C7FB0EEADF103C53FF
          000BDBE3119B59F146B922DFE8D677CB936E0FDDBA9508C06C6DF2900DB1A853
          8CED09E2FF00B22FC3BBCFDB6BE37F8ABE3F7C60990F823C205EF2749F9B599E
          242E96A8A7FE58C298661FC44A83B8BB9AF5697FE0BEFE1D495962F871AD346A
          4842DAA44A48ED91E59C7D326BEE5E558AC361E580CB21CF55A5ED669AD2FAA8
          26DAF9DB7EBD97E7D1CE3098AC4C332CD67C94937EC60D3D6DA3A92493D7F96F
          B74EEFF4128AFCF9FF0087FCE83FF44DF58FFC1B47FF00C6E8FF0087FCE83FF4
          4DF58FFC1B47FF00C6EBC0FF0054737FF9F2FEF8FF0099F47FEBA64BFF003FD7
          DD2FF2373F6C4F84DE24FD80FE2537C70F8476FB7C377D320F19786932B67302
          C7FD2028FBAA4B632A331BB0600AB3A8FAE3E01FC75F0FFED21F0B34BF17786A
          E4CFA6EA49CA3E04D6B28FBF0C8013B5D4F0467D08C8209F8C754FF82EA7C3FF
          001468171A76ADF0EBC457567A840D6F796D24D6F2C32A3AED742091B9482472
          0645785FEC2FFB71781FF649F8DBE226D3F50F15C3F0E3C4770CDFD957DA7A4B
          25881CC522BA4CDBA45CEC6F906F4192772A8AF6AB6418FC5609FD669355A9EC
          F7E78FF2BB5F55D1F55A1E0D0E23CBB098F5F55AD1742A7C4AF6E497F32BDBDD
          97DA4B67AF73F5D28AF17F851FF050EF833F1966860D1BC79A34779336C4B5D4
          59B4F999BFBAAB304DC7FDDCE6BD9D5C3A865219586411DEBE231185AD425C95
          A0E2FB34D7E67DF61F1743111E7A13525DD34D7E02D1451581D015F9A1FB4A7E
          DEBF14FF006C7F8E179F0C7E04ADF5AE916F23C126A1A7B88EE6FD55B63CED71
          9C416E091B4A952460963B820FD28D4ECBFB4B4DB8B7DDB3ED11347BB19DB904
          671F8D7C51FF00045AF82D27C20F0F7C54B3D5AD56DFC4DA6F897FB16F72BF30
          4B78832E33CEC6695D81C61860F3C57D2645530F87A35F1B560A73872F2C5ED7
          936AED75B69F7FCCF97E20A789C4D7A180A5370854E6E79477B4526A29F4BEBF
          77C9F9C7C30FF82126B1ACEAB6BAA7C42F1FDBB4924C27BFB3D3ADA4B992E413
          96537323290C7905BCB6FC7AD79D7EDDBF13EFBF6DDFDAD3C37F06BE1EA429E1
          7F0C5CAE89A64307CB6CF322ED9EE3038F2A28D195719C244C47DFC57DD5FF00
          052DFDA79BF65EFD97356D42C67F27C45AF9FEC7D20A9F9A29A456DD30F4F2E3
          0EC0F4DC101EB5F3B7FC10D3F65F5D27C2FABFC56D52DD4DC6AA5F4AD1770CEC
          811BF7F28FF7A451183D4794FD9ABE93039B6265859E758F7CCE178D25649733
          DDA4BB2FC13EC7CB63F27C247170C8B2E8F2AA969D595DB7CB1D936DBDDFE2D3
          B6A7D87E09FD967C1BE0FF00D9EB4DF86526936FA9785ECADA3827B6B84F96F9
          D5848D2C807567906F3DB27D8567DB7EC2DF066D1630BF0BFC0C7CBC637E8F0B
          E71EBB94E7F1CE6B27E157ED21AE78E7F6D5F8A5F0DEEED7498F43F03D9E9D71
          633C3148B772B5C5BC52B8958B9420339036A2E06339EB527EC29FB466B9FB4F
          7C21D4BC41AFDAE95677967AF5E69689A7C5247118A12A1490EEE771DC72738F
          615F1F5638FA51955736BE193B49EBED17327EAD6E7DB51965F5A50A4A9A7F14
          55E2B4F66F95AD7A27B17354FD9CFE036877AD6F7DE03F8476770A0168A7D174
          E8DD41E46414079AE9348F817F0D755D3A29EC7C1BE07B9B46188E4B7D26D5E3
          201C705531C10471E95F14FED01F0BE7F8AFFF00052EF881636FF0C343F8A0F6
          FE1FD3A7369A96B274B5B20238D7CC571F789DD82B8F7ED5F6A7ECD3E081F0E7
          E08683A3FF00C22D63E0A6B4494B68B677A6F21B06799E460B29FBFB8B16CFAB
          11DABA330A33A1429D4F6D294A4A2ED75A5D5FF99CBEF8A5E66196D6857AF529
          AA318C62E4AE93D795DBF9547EE936BB6E5AFF00867AF00FFD08FE0FFF00C135
          B7FF00115E59FB67FEC9BA5F8B7F674F100F04784FC1D65E2AD362FED0D3B3E1
          BB1BA172F1659A1D92C4CB991372A9C0C332F38CE7CDBC75FF00052DF127847E
          34FC48F02DAE8DE1DD53C47A6F8874AF0FF83B4F532C535FB5D094CD2DC1DEDB
          A38B6479645400C8A0FDE047D65F0E9BC44DE06D2CF8B17475F121B75FED11A4
          F99F62137F1795E67CFB7FDEE6B2A94F1B80953C4547D9A4DDEEACA5B76D6CFC
          EE8D29D5C0E630A986A4BF9A2DA56B3BB8EFD1DD36BADACFAA3F3EFF00E09DBF
          05FE0DFEDF1F05351B4F17782F47B7F1CF86A7F2AF6EB49CE96D730C9B8C3702
          2B72916787423615CC6091F30AFA43E0DFECA1E2DFD8E75E8FFE109F166ADE2E
          F00C8C12EBC2FAE4C1EE6C133FEB2C67002865FF009E2CAAAE01F9B760D7C91F
          106F5BFE09AFFF0005595D621CD9F827C6F20B8B907E5856CEEE4C4E33D3F737
          0A6400745441C06AFD44570EA1948656190477AF6788B155E9CA352949CA8565
          CCA2F54BBA57D9A7DAD63C4E18C2D0A90953AB051C450972CA51D1BB7C3276DD
          497F35EF6678E7ED29FB4649FB2DF8AFC2BAD6B6CB2780BC497CBA2EA3330DAF
          A1DCBAB343739C730B6D6590311B70ACBDD5BD901DC322BE3AFF0082DFF89ED7
          46FD8E2DEC6658DEEB58D7ED61B7046590A24B2338FA04DB9FF6F1DEBEA3F83F
          0DDDB7C25F0BC7A83335F47A45A2DC96EA6410A06CF4FE2CD78389C2C56028E2
          52B393945F9A56B3FC5A7E88FA1C2E3272CC6BE11BBA8A84979397326BF04D7A
          BF23A2AC5D13C03A7F87BC65ADEB967179379E215B7FB705E1669215645908FE
          F942A84FF7624F4ADAACFF0016789AD3C15E15D4B59D42410D8E93692DEDCC84
          E02471A1763F82835E641CBE18F5D3D75FF33D6972FC52E9AFA7F48FCB7FF82B
          678F352FDA57F6DEF0E7C2DD0DFCE5D0DADF4A86319DA6FAF191A463DB014C2A
          4F6D8F5FA71F0A3E1BE9FF0007BE19E83E16D253669FE1FB18AC61E305C2285D
          C7FDA620B13DC926BF317FE092DE19BCFDA4BF6F4F127C48D6A312BE92975AD4
          8492CA97976EC88A3D823CC467A6C18E831F4A7ED37F183E214FF1AF59B5F0BE
          ADE36B1D274C64B458F49BFF000E8B7322A02E7174E6656DCC410F83C0C0C62B
          EEF3EC2B6E8E4F4A4A2A8C2F26DD9733DFFCD7AB3F3BE1DC5A51AF9DD58B93AD
          36A292BBE58E8BFC9FA22CF88FE197C6BF849FB6F7C4CF881E08F04E81E28D1B
          C696DA75B42D7DAD4766C82DED618D8EDEBF7D58723A0CD4BFF04891AE7863E1
          CFC42F08788ACAD6CF58F0BF8B6E12EC412F98BE74A88EE01048C0230304F15E
          6BA67C50F8CDAD4F1C567E22F8A97724B2794890DFF84A4677CE36801B939E31
          D735EFB65ADFC40FD9F3E0F49AF78A2EBE29F8FAF2FAD897D3F4ED3346BABAF0
          F9E4EE658C42D3B720108D228C11D30C78F1CAA7D5BEAD374DCA4A114E2DF33E
          45657BE9B69D3E6EC8F4302E9FD67EB50555462E726A4972AE77776B6BF159FD
          AB792BB29FED33FB1E7C31F137C59B6F1A789BC49E2EF0DEB9E2EBAB4F0F4126
          97ABB59ADDCE576C3080AA4E5B67738C8AF68F833F096C7E087C3EB3F0E69B7D
          AC6A56966F23A4FAA5D9BABA72EE5CEE90804E0B607A00057E3B7ED4FF00F050
          7F1D7C6DF15E870CDAD4B7367E0BD546A7A64D3E8B1699742E508DAD34292CAB
          B9082000DDCFAE2BED4FD837F6DEF127ED01BECF54D73C7DE2FD7350896DA6FE
          C4F0B5859E93E1B2C32677B997EFBA76DDC301810B9E4EF9A70EE634B0109D6A
          978ADD6B656D15B4D34EF6EC73E51C4D9657CC6A53A14ED27B3D2EEFACBAEBAF
          6BF7665FC5AFF8278F8F7C55F187E2FF00C40D0E3874BF1836B9A5EB3E05BF8E
          F915A4F284A9751BF3F22B2B21C38C3145078DD5F6D7C3EBFD6354F02E9171E2
          1B08B4BD7A6B48DB50B48A5134705C6D1E62ABAF0CBBB383E98AF91FE39FFC34
          37C1FF0012982D7E2078BB5ED266C183518347F0CDBC6C4F3E5B09FCB6DE307A
          0C11C8F41C3FFC2E9FDA13FE86EF197FE01F843FF8ED73E230B5F1D461CF5A95
          A2959DE49A49256D56DA5EDDDB7D4EAC2E2B0F97D69FB3A156F26DB568B4DB93
          95F47BFBD6BA7B24BA1D7FFC171BE09278DBF66FD2FC65045BAFBC17A80595C0
          FF00974B92B1BE7E9288319E065BD6BD73FE0995F1C5FE3CFEC6DE14BFB990CB
          A9E8B19D0EF98BEF6325BE15598F76688C4E73DDCF5EA59E07F0F6B9FB4C7EC5
          7E28F0EF8B2E752BCD6B59B4BDD35A6BF3A7F9E1D933137FA11300DACC840FBD
          C0CFA9F83FFE09A5FB6B5BFEC8FF00047E2E7F6A2F9925BA5B5DE8D68E0A8B8D
          41C4917944FB854623A848643CE2BA28E0EA633289E0A3EF54A1515ADD54DDAC
          BCAF7671E231B4F039DD3C74FDDA788A6F9AFA59C15EEFCD2B23D73F6E4BC93F
          6D6FF8290F80FE10E9EC6EB40F07BACFAD6D0C630CDB66B9DDDB885238C1ECF2
          32E7922BF4500DA302BE3DFF00824D7ECBBAA7813C1BAB7C54F19F9D71E37F89
          4C6F0BCEA04D05A3BF9B96E061A6722461D3688C6010457D855E371057A6A74F
          0341DE14572DFBC9EB27F37F91EE70E61EA3854C7E215A75DF359EEA295A09FA
          2D7D5857CF9FF054CF1F37C3EFD857C753444F9FA9DBC5A546338C8B899237FF
          00C86D27D6BE83AF8CFF00E0B9FABCDA6FEC73A5431EDD9A878A6D6DE5CE7EE8
          B7BA938E7FBD1AF5CFF5AE6C828AAB995083DB997E0EE75712577472BC4545BF
          24BF156FD4E1FF00E08D971A3FC05FD8EFC79F123C40DF61D3EE35811DC5C85D
          C7ECD6F1C6AAD81C90249E518EBC1C039E7EC0BAFD967E13F8B6E64D567F871F
          0F3529B53637725DC9E1FB399EE9A43BCC85CC64B1627258939CE6BE41F81BF0
          5F5FF8B5FF00043E6D07C291ACDAD6B62EEF16052564BA10EAAECF1291D5DD20
          DA0743900F5CD3BFE08FFF00B757F69E9B17C1BF1A5C35AEB5A38687C3F35CFC
          8D3C499DD64D9E4491E0EC07AA82BC141BBE8F37C1D7C44F158FC3CDF342A38C
          A29EBCAAC93F959FCBD0F98C971D87C353C1E5D8982E4A94E328C9A56E7776E3
          EAEEBF2EA7D9BE0EFD9C7E1EFC3AD763D53C3FE03F06685A9C2ACB1DE69FA25B
          5ACE8186080E881802383CF35C57C74FD83BC07F1D2FE6D4A55D6FC33AF4D96F
          ED4D035192C66DC7AB1404C4CC7BB3216393CD7B4515F1F4F1D88854F6B19BE6
          EF77F77A791F6D5301869D3F632A6B97B597DFEBE7B9F861FF000501FD9C97F6
          5EFDA2EEFC363C5179E2D926B38AFE5BCBC88A5C23485B11C87736F60AAA7771
          90C3818AFB6FFE09D1FF0004F5F02F8FFF00671F0AF8BF57D7FC5DE20875989A
          E5B495D564B3D32D66595D1C08E12ACCC1D18125F071D074AABF003F677D3FF6
          E1FDA47F68BF1C6BB1B4BA3DFCB73E0DD1A761B8232A2C46E13FDA8E38A02BFF
          005D4E6BBEFF0082346AFA868DF017C57E03D657C9D63E1FF89EEB4E9A0C9FDC
          AB6188FF00BFC27FCABF45CEB38AF2CB3D8D39B55297273B5657E68F4B6D6765
          A1F996439250866DEDE74D3A557DA7227776E592B5EFBF32BB573E98BBF825E0
          FD43C01FF08ADC786743B8F0D9C13A6CD66925B31073B8A10416CF3B8F39E739
          AE47FE1863E0D7FD12FF0002FF00E09E0FFE26BD5AA3BDBD874DB39AE2E268ED
          EDEDD0C92CB230548D40C9662780001924F4AFCE29E2F110D2136AFD9BDCFD3A
          A60F0F3D6A422EDDD27A1C9E89E14F03FECC7F0F3549B4DD3743F06F86ACBCCD
          4EFF00ECB6EB6D6E84228795828009DA8A33D4ED03D2BF2C7F673B0F03FED2FF
          00B7AE83A649A7DD5BFC3CD435FBFD434CD3E755F33549F6CB7264B803FE59E6
          38E3DBD02EC4E4F9AE7DB7E2F7C45F117FC15ABE3CFF00C2BAF045C5D697F077
          C3370936BBACAA63FB45958E181C60E71FBA8CF520C8C30005F29D43C03A5FC0
          9FF82D07877C33E1BB7167A3E8DABE936969013BBCB8E4B0B72FCF724C8EC4F5
          2CC49C924D7E8192E0E586A75E35A6FDBCA9CA56BFC292B2BFF79DEFE4BCD9F9
          CE7D8E8E26AE1E5460BEAF1AB185EDA4DB77765FC8B97D1BEE91FACCAA1142A8
          0AAA30001D2968A2BF373F500AF8EFFE0B85E1D7D6BF630B6B95DDB747F11DA5
          DBE31D0C53C3CFE330E9DF1EF5F62578AFFC1457E1CB7C53FD8A7E216971C2F3
          5C43A59D4614452CECF6CEB700281C927CAC6075CE2BD5C8F10A8E6146A3D949
          5FD2F6678FC418775F2DAF496EE12B7ADAEBF1391FF82416A91EA1FB00F82E14
          FBD6336A103F3DCDF4F27F2715E69FF0524FF8264CDF13B5293E257C2F88E9FE
          36B37FB5DF58DABF9275374F984F0918D97208078C6F3CE43F2D85FF00041AF8
          CB0EA9F0DFC61E039E6FF4CD26F5758B5466197826558E40A3AE11E3527DE61E
          B5FA015EBE658AC4E579DD6AB49D9F3376E8D4B5B3EEB53C5CA70785CDF21A14
          AB2BAE54AFD538FBB74FA34D7F9E87C13FB05FFC15B21F115CC1E03F8C328D17
          C4B6B27D8E0D6AE13C88AE9D4EDF2EE9703C998118DC40527AED3F7BEC8F8EFF
          001107C2EF81FE2AF1347BA67D1F49B8BC8163F99A69163631AAFA966DA07B91
          5E23FB72FF00C131FC27FB5C5BDC6B5A7B43E19F1D2A7C9A9471FEE6FC8180B7
          283EF70301C7CC38FBC06DAF8B7C37FB42FC5CFF008278EA56BF0EFE2BF87EFB
          C45E0586EEDE7B6B69A76F2F6DBCF1CC8D6774010D1868D0985B2A47CA426E6A
          EC596E073492C465DEECEF79526ED7EFC8F6F97E5B1C6F35C7E511786CCEF2A7
          6B46B257B76E75ABBF9F5F3D59FA3DFB197C0CFF008673FD9A7C2BE169142EA3
          6B682E3536CEE692F262649893DF0EC5413D945717E09F01AFC19FF828878A2E
          2DA3F274AF8B5E1C8F53241C29D434F95629571EA62B9593DC990FD7B4FD9B7F
          6C4F007ED59A0ADDF8475C867BC58C4973A5DC1115FD9F63BE2CE700F1B97721
          3D18D77DAC7852CB5DD6749D42E23DD75A24EF716AE0E0A33C4F1303EAA5643C
          7A853D857CDD5C457A55EB2C526A534D493D1DDBBAFF00C99267D451C3E1EAE1
          E8BC2B4E34DA716B5564B95FFE4ADA3427B88ED607965758E38D4B3BB1DAAA07
          2493D80AF807E39FC63F17FF00C150BE29DEFC2CF857752693F0C749976F88FC
          4FB498AFF07EEA9046E8C91F24608326371C20E3DC3F682D13C55FB6A6A971E0
          1F0CDFDD7867E1AC12183C4FE2488627D6B1912585903C327F0C929F933941BF
          6BA37B57C21F83DE1CF811E01B1F0CF8574BB7D2747D3D711C518CB48DFC523B
          1E5DDBA966249AEAC1D6A597C3DBB4A559FC2B750FEF3EF2ECBA6EF5B23971B4
          6B6633FABA6E3417C4D68E7FDD5D547F9A5D765A5D947F67FF00807E1DFD9ABE
          1769DE13F0C5AFD9F4FB05CBC8F8335E4A7EFCD2B00373B1EA7A0000000000FC
          E7F8BD09D5FF00E0BBF68B6FB64DBAF692C79E9E5E9D6C5FF2DA7F2AFD4CAFCD
          7FD92B407FDA13FE0B1DE3FF0019C6AD2697E0FBBBE904E3EE3B2A9B0847FC09
          77B8F68FF0AF438731124F198BAAEFFBA95DBEAE4D5BEF6797C51878B581C1D1
          56FDEC1A4BA4629DFEE47E94514515F227DA05367823BA81E2951648E452AE8C
          372B03C10477069D45007E46FC62F849E2DFF824CFED9161E36D06CEE2F3C0F7
          578FF629865A2B8B493FD6D84CDFC32AAE7696FBDB11C648655FD33F80BFB4F7
          823F694F0A5AEABE13D7AC6FFCF8D5E5B2332ADE59B119292C59DCAC39F638C8
          24735D8789FC2DA678DB41BAD2B58D3ECB55D32F53CBB8B4BB81668675F46460
          411F515F35F8D7FE08F1F03FC5BABB5F5AE8BABF87A666DE574AD4A48E30DEAA
          B26F0BEB85C01E95F558ACDB09995287D7F9A3562ADCF14A4A4BFBC9B5AF9A67
          C860F26C6657567FD9DCB3A3377E49371717D795A4D5BC9A3EA3AC5F883F0DF4
          1F8AFE17B8D17C49A3E9FADE95743125B5E42248CFA119E8C3B11823B1AF05F0
          AFFC12B3E1AF87E1861BCD53E206BD6B0956FB3DFF00896E1626703058AC3E5F
          273CE31F80AF7AF00FC39D07E1678763D27C39A45868BA746C5FC8B48446ACE7
          EF3B639673D4B36493C926BC2AD1A149A961EA36D75E5E5FC799BBFC8FA1A12C
          4554E389A718A6B6E6E6F935CA95BE67C2DF1FBFE08A4FA2EBABE25F827E28BB
          F0DEA96AFE741A75EDDC89E437FD3BDDA6658CE3380FB892797515CD683FF050
          8FDA17F62CBB8F4BF8D1E05BCF11E8B1B8846A72C621908271F2DDC41A098E32
          76B0DC78CB0CE6BF4A299716F1DE40F14D1A4B1480ABA3AEE5607A820F5AF669
          F1354A9054731A6AB456CDE925E925AFDF73C2A9C2B4E95475B2CA92A127BA8E
          B07EB07A7DD63E68F827FF000563F823F13EC2DEDDB5EFF8436E951516CB5AB7
          FB2A44071812AEE8768EDF3838C703B7D0DE16F1BE8BE39D3D6EF44D5F4BD62D
          5C6E59AC6E92E2361EA190915E57F12BFE09DFF057E2C49249AB7C3DD062B894
          EE69F4E46D3A466FEF13014DC7FDECE6BCBEF3FE08B1F07D6F7ED5A5DE78E3C3
          F748418A6D3F57559203DF6B491B9E464739EB58D48E4F575A72A94DF669497D
          E9A7F81D14A79DD1D2A429D45DD4A507F73525F8A3E9AF8A2BE2293E1F6AD1F8
          4D74FF00F84926B768B4F7BE95A3B78656F9448E5558ED4CEEC004B6DC719C8F
          39FD89BF63CD27F638F858FA3DADCB6ABAEEAD28BBD6B5575C3DF4F8C0033922
          34C90A093F7989E58D72BE18FF008269787BC35047137C48F8D77D146FBC24DE
          2F9635C7F771122719C9E39E4F35EE7F0FFE1DE93F0C3C391E97A35BC905AC67
          7334B3C97134CD8037C92C8CCF231000DCCC4F02B8EB56A74A84B0F87A8E4A4D
          37EEDAF6DAEEF7D3A2B6FF0023B6851A95ABC71389A4A328A697BD7B5F7B2B25
          AD95DDF6D3B9B7451457967AC145145001451450014514500145145001451450
          014514500145145007FFD9}
      end
    end
    object ColumnHeaderBand1: TQRBand
      Left = 45
      Top = 497
      Width = 861
      Height = 58
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
        127.881944444444
        1898.38541666667)
      BandType = rbColumnHeader
      object QRShape1: TQRShape
        Left = 84
        Top = 2
        Width = 73
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          185.208333333333
          5.29166666666667
          161.395833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape2: TQRShape
        Left = 6
        Top = 2
        Width = 78
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          13.2291666666667
          5.29166666666667
          171.979166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape3: TQRShape
        Left = 156
        Top = 2
        Width = 181
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          55.5625
          343.958333333333
          5.29166666666667
          399.520833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape4: TQRShape
        Left = 156
        Top = 26
        Width = 91
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          343.958333333333
          58.2083333333333
          201.083333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape5: TQRShape
        Left = 246
        Top = 26
        Width = 91
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          542.395833333333
          58.2083333333333
          201.083333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape6: TQRShape
        Left = 336
        Top = 2
        Width = 73
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          740.833333333333
          5.29166666666667
          161.395833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape7: TQRShape
        Left = 409
        Top = 2
        Width = 55
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          902.229166666667
          5.29166666666667
          121.708333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape8: TQRShape
        Left = 618
        Top = 2
        Width = 163
        Height = 25
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          55.5625
          1362.60416666667
          5.29166666666667
          359.833333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape9: TQRShape
        Left = 618
        Top = 26
        Width = 91
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          1362.60416666667
          58.2083333333333
          201.083333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape10: TQRShape
        Left = 708
        Top = 26
        Width = 73
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          1561.04166666667
          58.2083333333333
          161.395833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape11: TQRShape
        Left = 780
        Top = 2
        Width = 79
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          1719.79166666667
          5.29166666666667
          174.625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape12: TQRShape
        Left = 462
        Top = 2
        Width = 79
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          1018.64583333333
          5.29166666666667
          174.625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape13: TQRShape
        Left = 540
        Top = 2
        Width = 79
        Height = 54
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          119.0625
          1190.625
          5.29166666666667
          174.625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel12: TQRLabel
        Left = 12
        Top = 4
        Width = 67
        Height = 49
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.038194444444
          26.4583333333333
          8.81944444444444
          147.725694444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зав. номер лічильн.'
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
      object QRLabel13: TQRLabel
        Left = 90
        Top = 20
        Width = 61
        Height = 26
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          58.2083333333333
          198.4375
          44.9791666666667
          134.9375)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зона'
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
      object QRLabel14: TQRLabel
        Left = 167
        Top = 31
        Width = 62
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          368.211805555556
          68.3506944444444
          136.701388888889)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Попередні'
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
      object QRLabel15: TQRLabel
        Left = 262
        Top = 31
        Width = 48
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          577.673611111111
          68.3506944444444
          105.833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Поточні'
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
      object QRLabel16: TQRLabel
        Left = 340
        Top = 4
        Width = 69
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          110.243055555556
          749.652777777778
          8.81944444444444
          152.135416666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата зняття показань'
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
      object QRLabel17: TQRLabel
        Left = 631
        Top = 5
        Width = 133
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1391.70833333333
          10.5833333333333
          293.6875)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Втрати, '
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
      object QRLabel18: TQRLabel
        Left = 726
        Top = 31
        Width = 25
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1600.72916666667
          68.3506944444444
          55.1215277777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'РЕМ'
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
      object QRLabel19: TQRLabel
        Left = 629
        Top = 31
        Width = 70
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1386.85763888889
          68.3506944444444
          154.340277777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'оплачувані'
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
      object QRLabel20: TQRLabel
        Left = 792
        Top = 4
        Width = 61
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          111.125
          1746.25
          7.9375
          134.9375)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корис. відпуск, '
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
      object QRLabel21: TQRLabel
        Left = 463
        Top = 4
        Width = 77
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          111.125
          1021.29166666667
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Спожив.по лічильнику'
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
      object QRLabel22: TQRLabel
        Left = 545
        Top = 4
        Width = 73
        Height = 50
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          111.125
          1201.20833333333
          7.9375
          161.395833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Спожив. по т.обліку'
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
      object QRLabel23: TQRLabel
        Left = 198
        Top = 5
        Width = 91
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          436.5625
          10.5833333333333
          201.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Показання'
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
      object QRLabel31: TQRLabel
        Left = 412
        Top = 10
        Width = 46
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          908.402777777778
          22.0486111111111
          101.423611111111)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Розрах коеф.'
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
    object DetailBand1: TQRBand
      Left = 45
      Top = 641
      Width = 861
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
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
        35.2777777777778
        1898.38541666667)
      BandType = rbDetail
      object QRLEnergy: TQRLabel
        Left = 66
        Top = 1
        Width = 74
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          145.520833333333
          2.20486111111111
          163.159722222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Вид энергии'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object GroupGround: TQRGroup
      Left = 45
      Top = 555
      Width = 861
      Height = 54
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Enabled = False
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ForceNewColumn = False
      ForceNewPage = False
      ParentFont = False
      Size.Values = (
        119.0625
        1898.38541666667)
      Expression = 'groundid'
      Master = PrintBill_p1
      ReprintOnNewPage = False
      object DBTGround: TQRDBText
        Left = 144
        Top = 6
        Width = 86
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          317.5
          13.2291666666667
          189.618055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'groundname'
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
      object DBTGroundAddr: TQRDBText
        Left = 348
        Top = 6
        Width = 78
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          767.291666666667
          13.2291666666667
          171.979166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'groundaddr'
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
      object QRLabel10: TQRLabel
        Left = 18
        Top = 6
        Width = 90
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          39.6875
          13.2291666666667
          198.4375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Майданчик'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel44: TQRLabel
        Left = 12
        Top = 31
        Width = 112
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          26.4583333333333
          68.3506944444444
          246.944444444444)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Група тарифа :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object QRDBText11: TQRDBText
        Left = 132
        Top = 31
        Width = 56
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          291.041666666667
          68.3506944444444
          123.472222222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'tgrname'
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
      object QRLabel45: TQRLabel
        Left = 336
        Top = 31
        Width = 54
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          740.833333333333
          68.3506944444444
          119.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тариф :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 9
      end
      object QRDBText12: TQRDBText
        Left = 396
        Top = 31
        Width = 56
        Height = 19
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          41.8923611111111
          873.125
          68.3506944444444
          123.472222222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'tarname'
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
    object ChildBand_Abon: TQRChildBand
      Left = 45
      Top = 625
      Width = 861
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = ChildBand_AbonBeforePrint
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
        35.2777777777778
        1898.38541666667)
      ParentBand = QRGroup2
      object QRLabel32: TQRLabel
        Left = 66
        Top = 1
        Width = 133
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          145.520833333333
          2.20486111111111
          293.246527777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Облік належить'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText13: TQRDBText
        Left = 210
        Top = 1
        Width = 64
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          463.020833333333
          2.20486111111111
          141.111111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'ownername'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRGroup2: TQRGroup
      Left = 45
      Top = 609
      Width = 861
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRGroup2BeforePrint
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
        35.2777777777778
        1898.38541666667)
      Expression = 'id_point'
      Master = PrintBill_p1
      ReprintOnNewPage = False
      object QRLFlag: TQRLabel
        Left = 12
        Top = -10
        Width = 24
        Height = 30
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          66.1458333333333
          26.4583333333333
          -22.0486111111111
          52.9166666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = ' - '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 16
      end
      object QRLabel43: TQRLabel
        Left = 34
        Top = 1
        Width = 74
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          74.9652777777778
          2.20486111111111
          163.159722222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Точка обліку'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText14: TQRDBText
        Left = 112
        Top = 1
        Width = 48
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          246.944444444444
          2.20486111111111
          105.833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'fullname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object lAreaLabel: TQRLabel
        Left = 286
        Top = 1
        Width = 64
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          630.590277777778
          2.20486111111111
          141.111111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Майданчик'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText15: TQRDBText
        Left = 354
        Top = 1
        Width = 71
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          780.520833333333
          2.20486111111111
          156.545138888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'groundname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText10: TQRDBText
        Left = 515
        Top = 1
        Width = 38
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          1135.50347222222
          2.20486111111111
          83.7847222222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillDemand
        DataField = 'pointaddr'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRShape35: TQRShape
        Left = 4
        Top = 0
        Width = 850
        Height = 2
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          4.40972222222222
          8.81944444444444
          0
          1874.13194444444)
        Shape = qrsHorLine
        VertAdjust = 0
      end
    end
    object QRSDMeter: TQRSubDetail
      Left = 45
      Top = 657
      Width = 861
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRSDMeterBeforePrint
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
        35.2777777777778
        1898.38541666667)
      Master = PrintBill_p1
      DataSet = ZQBillMeter
      PrintBefore = False
      PrintIfEmpty = True
      object DBTNum: TQRDBText
        Left = 18
        Top = 1
        Width = 65
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          39.6875
          2.20486111111111
          143.315972222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'num_eqp'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object DBTZone: TQRDBText
        Left = 91
        Top = 1
        Width = 78
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          200.642361111111
          2.20486111111111
          171.979166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'name_zone'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object DBTVal_b: TQRDBText
        Left = 174
        Top = 1
        Width = 75
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          383.645833333333
          2.20486111111111
          165.364583333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'b_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object DBTVal_e: TQRDBText
        Left = 252
        Top = 1
        Width = 93
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          555.625
          2.20486111111111
          205.052083333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'e_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object DBTDate: TQRDBText
        Left = 342
        Top = 1
        Width = 79
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          754.0625
          2.20486111111111
          174.184027777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'dat_e'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object DBTKtr: TQRDBText
        Left = 423
        Top = 1
        Width = 44
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          932.65625
          2.20486111111111
          97.0138888888889)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'k_tr'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object DBTKtrDemand: TQRDBText
        Left = 468
        Top = 1
        Width = 77
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1031.875
          2.20486111111111
          169.774305555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'ktr_demand'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText29: TQRDBText
        Left = 560
        Top = 1
        Width = 299
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          30.8680555555556
          1234.72222222222
          2.20486111111111
          659.253472222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillMeter
        DataField = 'comment'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRSDPoint: TQRSubDetail
      Left = 45
      Top = 673
      Width = 861
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRSDPointBeforePrint
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
        35.2777777777778
        1898.38541666667)
      Master = PrintBill_p1
      DataSet = ZQBillPoint
      PrintBefore = False
      PrintIfEmpty = True
      object QRDBText9: TQRDBText
        Left = 91
        Top = 1
        Width = 78
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          201.083333333333
          2.64583333333333
          171.979166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillPoint
        DataField = 'name_zone'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object DBTFactDemand: TQRDBText
        Left = 546
        Top = 1
        Width = 72
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1203.85416666667
          2.20486111111111
          158.75)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillPoint
        DataField = 'demand'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRExpr1: TQRExpr
        Left = 623
        Top = 1
        Width = 82
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1373.62847222222
          2.20486111111111
          180.798611111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(losts >= 0, losts, 0)'
        FontSize = 8
      end
      object QRExpr2: TQRExpr
        Left = 708
        Top = 1
        Width = 77
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1561.04166666667
          2.20486111111111
          169.774305555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Color = clWhite
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'IF(losts < 0, (-1)*losts, 0)'
        FontSize = 8
      end
      object DBTSunVal: TQRDBText
        Left = 786
        Top = 1
        Width = 70
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1733.02083333333
          2.20486111111111
          154.340277777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillPoint
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object SummaryBand2: TQRBand
      Left = 45
      Top = 689
      Width = 861
      Height = 47
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = SummaryBand2BeforePrint
      Color = clWhite
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        103.628472222222
        1898.38541666667)
      BandType = rbSummary
      object lSumDemand: TQRLabel
        Left = 546
        Top = 5
        Width = 72
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1203.85416666667
          11.0243055555556
          158.75)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSumDemand'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object lSumLosts1: TQRLabel
        Left = 623
        Top = 5
        Width = 82
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1373.62847222222
          11.0243055555556
          180.798611111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSumLosts1'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object lSumLosts2: TQRLabel
        Left = 708
        Top = 5
        Width = 77
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1561.04166666667
          11.0243055555556
          169.774305555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSumLosts2'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object lSumTovar: TQRLabel
        Left = 786
        Top = 5
        Width = 70
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1733.02083333333
          11.0243055555556
          154.340277777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSumTovar'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRShape36: TQRShape
        Left = 4
        Top = 1
        Width = 850
        Height = 2
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          4.40972222222222
          8.81944444444444
          2.20486111111111
          1874.13194444444)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRLabel74: TQRLabel
        Left = 16
        Top = 4
        Width = 43
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.4826388888889
          35.2777777777778
          8.81944444444444
          94.8090277777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Всього'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel156: TQRLabel
        Left = 544
        Top = 25
        Width = 224
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1199.44444444444
          55.1215277777778
          493.888888888889)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '% до попереднього місяця :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object lPercent: TQRLabel
        Left = 785
        Top = 25
        Width = 73
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1730.81597222222
          55.1215277777778
          160.954861111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lPercent'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object TitleChild1: TQRChildBand
      Left = 45
      Top = 353
      Width = 861
      Height = 85
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
        187.413194444444
        1898.38541666667)
      ParentBand = TitleBand1
      object QRShape23: TQRShape
        Left = 128
        Top = 1
        Width = 579
        Height = 82
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          180.798611111111
          282.222222222222
          2.20486111111111
          1276.61458333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel1: TQRLabel
        Left = 252
        Top = 6
        Width = 98
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          555.625
          13.2291666666667
          216.076388888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Рахунок №'
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
      object QRLabel2: TQRLabel
        Left = 483
        Top = 6
        Width = 36
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1064.94791666667
          13.2291666666667
          79.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'від'
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
      object QRLKindEnergy: TQRLabel
        Left = 152
        Top = 26
        Width = 529
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.7118055555556
          335.138888888889
          57.3263888888889
          1166.37152777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'За активну електроенергію'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 12
      end
      object lBillNo: TQRLabel
        Left = 352
        Top = 6
        Width = 122
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          776.111111111111
          13.2291666666667
          268.993055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lBillNo'
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
      object lBillDate: TQRLabel
        Left = 526
        Top = 6
        Width = 61
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1159.75694444444
          13.2291666666667
          134.496527777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lBillDate'
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
      object lContract: TQRLabel
        Left = 132
        Top = 62
        Width = 571
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          291.041666666667
          136.701388888889
          1258.97569444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lContract'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object lAvans: TQRLabel
        Left = 156
        Top = 46
        Width = 385
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          343.958333333333
          101.423611111111
          848.871527777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Оплата вартості очікуваного споживання електроенергії в місяці '
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
      object lAvansMonth: TQRLabel
        Left = 544
        Top = 46
        Width = 137
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          33.0729166666667
          1199.44444444444
          101.423611111111
          302.065972222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lAvansMonth'
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
    end
    object TitleChild2: TQRChildBand
      Left = 45
      Top = 438
      Width = 861
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
      LinkBand = TitleChild1
      Size.Values = (
        130.086805555556
        1898.38541666667)
      ParentBand = TitleChild1
      object QRShape59: TQRShape
        Left = 146
        Top = 1
        Width = 539
        Height = 56
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          123.472222222222
          321.909722222222
          2.20486111111111
          1188.42013888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel6: TQRLabel
        Left = 252
        Top = 6
        Width = 98
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          555.625
          13.2291666666667
          216.076388888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Рахунок №'
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
      object QRLabel8: TQRLabel
        Left = 483
        Top = 6
        Width = 36
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1064.94791666667
          13.2291666666667
          79.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'від'
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
      object QRLActType: TQRLabel
        Left = 152
        Top = 26
        Width = 529
        Height = 23
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          50.7118055555556
          335.138888888889
          57.3263888888889
          1166.37152777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'За споживання  електричної енергії понад договірну величину'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -15
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 11
      end
      object lBillNo2: TQRLabel
        Left = 352
        Top = 6
        Width = 122
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          776.111111111111
          13.2291666666667
          268.993055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lBillNo'
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
      object lBillDate2: TQRLabel
        Left = 526
        Top = 6
        Width = 61
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1159.75694444444
          13.2291666666667
          134.496527777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'lBillDate'
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
  end
  object PrintBill_p2a: TQuickRep
    Left = 944
    Top = -16
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSumm
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand1: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 57
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
        150.8125
        1899.70833333333)
      BandType = rbTitle
      object QRShape15: TQRShape
        Left = 6
        Top = 25
        Width = 210
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          15.875
          66.1458333333333
          555.625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape16: TQRShape
        Left = 215
        Top = 25
        Width = 96
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          568.854166666667
          66.1458333333333
          254)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape17: TQRShape
        Left = 309
        Top = 25
        Width = 71
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          817.5625
          66.1458333333333
          187.854166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape18: TQRShape
        Left = 531
        Top = 25
        Width = 89
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1404.9375
          66.1458333333333
          235.479166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape19: TQRShape
        Left = 619
        Top = 25
        Width = 87
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1637.77083333333
          66.1458333333333
          230.1875)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel25: TQRLabel
        Left = 12
        Top = 27
        Width = 196
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          31.75
          71.4375
          518.583333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тарифна група'
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
      object QRLabel26: TQRLabel
        Left = 218
        Top = 27
        Width = 90
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          576.791666666667
          71.4375
          238.125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата встанов. тарифа'
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
      object QRLabel27: TQRLabel
        Left = 312
        Top = 27
        Width = 64
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          825.5
          71.4375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф, грн/кВтг'
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
      object QRLabel28: TQRLabel
        Left = 535
        Top = 27
        Width = 79
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1415.52083333333
          71.4375
          209.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск, кВтг'
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
      object QRLabel29: TQRLabel
        Left = 627
        Top = 27
        Width = 76
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1658.9375
          71.4375
          201.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума нарах. грн.'
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
      object QRLabel30: TQRLabel
        Left = 282
        Top = 6
        Width = 117
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          746.125
          15.875
          309.5625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Всього по тарифах '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRShape14: TQRShape
        Left = 377
        Top = 25
        Width = 91
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          997.479166666667
          66.1458333333333
          240.770833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel41: TQRLabel
        Left = 392
        Top = 27
        Width = 64
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1037.16666666667
          71.4375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зона'
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
      object QRShape21: TQRShape
        Left = 467
        Top = 25
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1235.60416666667
          66.1458333333333
          171.979166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel42: TQRLabel
        Left = 471
        Top = 27
        Width = 57
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1246.1875
          71.4375
          150.8125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Зонний коеф.'
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
      object QRShape22: TQRShape
        Left = 6
        Top = 0
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          15.875
          0
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
    end
    object QRBand2: TQRBand
      Left = 38
      Top = 113
      Width = 718
      Height = 15
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand2BeforePrint
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
        39.6875
        1899.70833333333)
      BandType = rbDetail
      object QRDBText2: TQRDBText
        Left = 619
        Top = 1
        Width = 86
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1637.77083333333
          2.64583333333333
          227.541666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText3: TQRDBText
        Left = 531
        Top = 1
        Width = 85
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1404.9375
          2.64583333333333
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText7: TQRDBText
        Left = 471
        Top = 1
        Width = 57
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1246.1875
          2.64583333333333
          150.8125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'koef'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText6: TQRDBText
        Left = 15
        Top = 1
        Width = 197
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          39.6875
          2.64583333333333
          521.229166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'tarname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText4: TQRDBText
        Left = 311
        Top = 1
        Width = 65
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          822.854166666667
          2.64583333333333
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Mask = '0.0000'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText5: TQRDBText
        Left = 218
        Top = 1
        Width = 90
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          576.791666666667
          2.64583333333333
          238.125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'dat_tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText8: TQRDBText
        Left = 385
        Top = 1
        Width = 60
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          1018.64583333333
          2.64583333333333
          158.75)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'zonename'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object SummaryBand1: TQRBand
      Left = 38
      Top = 128
      Width = 718
      Height = 281
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
        743.479166666667
        1899.70833333333)
      BandType = rbSummary
      object QRShape20: TQRShape
        Left = 10
        Top = 3
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDS: TQRLabel
        Left = 495
        Top = 44
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          116.416666666667
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lNDS: TQRLabel
        Left = 495
        Top = 26
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          68.7916666666667
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lSum: TQRLabel
        Left = 496
        Top = 8
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          21.1666666666667
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel34: TQRLabel
        Left = 395
        Top = 44
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          116.416666666667
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'З ПДВ:'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel35: TQRLabel
        Left = 435
        Top = 26
        Width = 45
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1150.9375
          68.7916666666667
          119.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel36: TQRLabel
        Left = 423
        Top = 8
        Width = 57
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1119.1875
          21.1666666666667
          150.8125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel37: TQRLabel
        Left = 471
        Top = 256
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          677.333333333333
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel39: TQRLabel
        Left = 10
        Top = 155
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          410.104166666667
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel40: TQRLabel
        Left = 154
        Top = 168
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          444.5
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel112: TQRLabel
        Left = 158
        Top = 236
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          624.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel113: TQRLabel
        Left = 90
        Top = 187
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          494.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel24: TQRLabel
        Left = 162
        Top = 208
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          550.333333333333
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel123: TQRLabel
        Left = 90
        Top = 223
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          590.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel38: TQRLabel
        Left = 378
        Top = 139
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          367.770833333333
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel62: TQRLabel
        Left = 534
        Top = 160
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          423.333333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel125: TQRLabel
        Left = 538
        Top = 236
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          624.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel126: TQRLabel
        Left = 470
        Top = 187
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          494.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel127: TQRLabel
        Left = 470
        Top = 223
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          590.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel124: TQRLabel
        Left = 542
        Top = 208
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          550.333333333333
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object qrlPosada: TQRLabel
        Left = 95
        Top = 144
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          381
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName: TQRLabel
        Left = 95
        Top = 180
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          476.25
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExec: TQRLabel
        Left = 45
        Top = 262
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          119.0625
          693.208333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExecLabel: TQRLabel
        Left = 10
        Top = 261
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          26.4583333333333
          690.5625
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlWarning1: TQRLabel
        Left = 10
        Top = 110
        Width = 695
        Height = 31
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.0208333333333
          26.4583333333333
          291.041666666667
          1838.85416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'У разі несплати рахунка протягом банківських днів будуть вжиті з' +
          'аходи щодо припинення електропостачання вашого підприємства відп' +
          'овідно з п. 7.5 (3) правил користування електричною енергією.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel241: TQRLabel
        Left = 10
        Top = 78
        Width = 42
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          206.375
          111.125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Увага!'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel249: TQRLabel
        Left = 394
        Top = 66
        Width = 86
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1042.45833333333
          174.625
          227.541666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сплачено :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object LOpl: TQRLabel
        Left = 495
        Top = 66
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          174.625
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'LOpl'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel252: TQRLabel
        Left = 395
        Top = 84
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          222.25
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До сплати:'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object LItog: TQRLabel
        Left = 495
        Top = 84
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          222.25
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'LItog'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRGroup1: TQRGroup
      Left = 38
      Top = 95
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      Expression = 'tgr_id'
      Master = PrintBill_p2a
      ReprintOnNewPage = False
      object QRDBText1: TQRDBText
        Left = 10
        Top = 1
        Width = 35
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          26.4583333333333
          2.64583333333333
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'tgrname'
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
    end
  end
  object PrintBill_p2r: TQuickRep
    Left = 1746
    Top = -60
    Width = 952
    Height = 1347
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSummR
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
    SnapToGrid = True
    Units = MM
    Zoom = 120
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand3: TQRBand
      Left = 45
      Top = 45
      Width = 861
      Height = 82
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
        180.798611111111
        1898.38541666667)
      BandType = rbTitle
      object QRShape58: TQRShape
        Left = 233
        Top = 28
        Width = 58
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          513.291666666667
          60.8541666666667
          127)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape24: TQRShape
        Left = 7
        Top = 28
        Width = 181
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          15.875
          60.8541666666667
          399.520833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape25: TQRShape
        Left = 290
        Top = 28
        Width = 46
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          640.291666666667
          60.8541666666667
          100.541666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape26: TQRShape
        Left = 451
        Top = 28
        Width = 67
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          994.392361111111
          61.7361111111111
          147.725694444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape27: TQRShape
        Left = 515
        Top = 28
        Width = 67
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          1135.50347222222
          61.7361111111111
          147.725694444444)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape28: TQRShape
        Left = 775
        Top = 28
        Width = 73
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          1709.20833333333
          60.8541666666667
          161.395833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel3: TQRLabel
        Left = 11
        Top = 37
        Width = 173
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          23.8125
          82.0208333333333
          381)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Точка обліку'
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
      object QRLabel49: TQRLabel
        Left = 298
        Top = 36
        Width = 34
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          656.166666666667
          79.375
          74.0833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'tg fi'
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
      object QRLabel50: TQRLabel
        Left = 465
        Top = 36
        Width = 38
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          1025.26041666667
          79.375
          83.7847222222222)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'K fi'
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
      object QRLabel51: TQRLabel
        Left = 516
        Top = 30
        Width = 61
        Height = 49
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.038194444444
          1137.70833333333
          66.1458333333333
          134.496527777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'обсяги перетік., кВАрг'
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
      object QRLabel52: TQRLabel
        Left = 780
        Top = 30
        Width = 66
        Height = 48
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          105.833333333333
          1719.79166666667
          66.1458333333333
          145.520833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума нарах. грн.'
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
      object QRLabel53: TQRLabel
        Left = 380
        Top = 5
        Width = 80
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          837.847222222222
          11.0243055555556
          176.388888888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Розрахунок'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRShape29: TQRShape
        Left = 638
        Top = 28
        Width = 60
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          1406.70138888889
          61.7361111111111
          132.291666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel54: TQRLabel
        Left = 641
        Top = 36
        Width = 52
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          1413.31597222222
          79.375
          114.652777777778)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'П2'
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
      object QRShape30: TQRShape
        Left = 697
        Top = 28
        Width = 32
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          1536.78819444444
          61.7361111111111
          70.5555555555556)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel55: TQRLabel
        Left = 701
        Top = 36
        Width = 22
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          1545.60763888889
          79.375
          48.5069444444444)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'П3'
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
      object QRShape31: TQRShape
        Left = 7
        Top = 0
        Width = 841
        Height = 6
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          15.875
          0
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape33: TQRShape
        Left = 578
        Top = 28
        Width = 62
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.857638888889
          1274.40972222222
          61.7361111111111
          136.701388888889)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel70: TQRLabel
        Left = 580
        Top = 36
        Width = 53
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.9652777777778
          1278.81944444444
          79.375
          116.857638888889)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'П1'
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
      object QRShape34: TQRShape
        Left = 185
        Top = 28
        Width = 52
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          407.458333333333
          60.8541666666667
          113.770833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel71: TQRLabel
        Left = 238
        Top = 36
        Width = 46
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          523.875
          79.375
          100.541666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'D  (ЕЕРП)'
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
      object QRShape37: TQRShape
        Left = 391
        Top = 28
        Width = 61
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          862.541666666667
          60.8541666666667
          134.9375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape38: TQRShape
        Left = 335
        Top = 28
        Width = 56
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          738.1875
          60.8541666666667
          124.354166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel68: TQRLabel
        Left = 346
        Top = 36
        Width = 34
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          762
          79.375
          74.0833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'WP'
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
      object QRLabel69: TQRLabel
        Left = 406
        Top = 36
        Width = 34
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          894.291666666667
          79.375
          74.0833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'WQ'
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
      object QRShape39: TQRShape
        Left = 727
        Top = 28
        Width = 49
        Height = 53
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          116.416666666667
          1603.375
          60.8541666666667
          108.479166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel58: TQRLabel
        Left = 733
        Top = 36
        Width = 38
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1616.60416666667
          79.375
          84.6666666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'K кор.'
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
      object QRLabel99: TQRLabel
        Left = 187
        Top = 36
        Width = 46
        Height = 34
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          412.75
          79.375
          100.541666666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Вид енергії'
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
    object QRBand4: TQRBand
      Left = 45
      Top = 145
      Width = 861
      Height = 16
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
        35.2777777777778
        1898.38541666667)
      BandType = rbDetail
      object QRDBText16: TQRDBText
        Left = 779
        Top = 1
        Width = 71
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1717.58680555556
          2.20486111111111
          156.545138888889)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText17: TQRDBText
        Left = 519
        Top = 1
        Width = 60
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1144.32291666667
          2.20486111111111
          132.291666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText18: TQRDBText
        Left = 581
        Top = 1
        Width = 59
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1281.02430555556
          2.20486111111111
          130.086805555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'p1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText19: TQRDBText
        Left = 10
        Top = 1
        Width = 174
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          22.0486111111111
          2.20486111111111
          383.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'fullname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText20: TQRDBText
        Left = 338
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
          745.243055555556
          2.20486111111111
          114.652777777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'wp'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText22: TQRDBText
        Left = 455
        Top = 1
        Width = 59
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1003.21180555556
          2.20486111111111
          130.086805555556)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'k_fi'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText23: TQRDBText
        Left = 646
        Top = 1
        Width = 53
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1424.34027777778
          2.20486111111111
          116.857638888889)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'p2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText24: TQRDBText
        Left = 705
        Top = 1
        Width = 24
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1554.42708333333
          2.20486111111111
          52.9166666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'p3'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText25: TQRDBText
        Left = 391
        Top = 1
        Width = 60
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          862.100694444444
          2.20486111111111
          132.291666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'wq'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText26: TQRDBText
        Left = 293
        Top = 1
        Width = 43
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          646.024305555556
          2.20486111111111
          94.8090277777778)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'tg_fi'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText27: TQRDBText
        Left = 235
        Top = 1
        Width = 57
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          518.142361111111
          2.20486111111111
          125.677083333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'd'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText30: TQRDBText
        Left = 731
        Top = 1
        Width = 46
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1611.75347222222
          2.20486111111111
          101.423611111111)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'k_corr'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText50: TQRDBText
        Left = 187
        Top = 1
        Width = 47
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          412.309027777778
          2.20486111111111
          103.628472222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'energy'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object QRGroup3: TQRGroup
      Left = 45
      Top = 127
      Width = 861
      Height = 18
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
        39.6875
        1898.38541666667)
      Expression = 'id_sumtariff'
      Master = PrintBill_p2r
      ReprintOnNewPage = False
      object QRDBText21: TQRDBText
        Left = 337
        Top = 1
        Width = 92
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          743.038194444444
          2.20486111111111
          202.847222222222)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'dat_tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRLabel72: TQRLabel
        Left = 26
        Top = 1
        Width = 50
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          57.3263888888889
          2.20486111111111
          110.243055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тариф'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRDBText28: TQRDBText
        Left = 78
        Top = 1
        Width = 92
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          171.979166666667
          2.20486111111111
          202.847222222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummR
        DataField = 'value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
      object QRLabel73: TQRLabel
        Left = 193
        Top = 1
        Width = 136
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          425.538194444444
          2.20486111111111
          299.861111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'дата встановлення'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 8
      end
    end
    object QRBand5: TQRBand
      Left = 45
      Top = 161
      Width = 861
      Height = 304
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
        670.277777777778
        1898.38541666667)
      BandType = rbSummary
      object QRShape32: TQRShape
        Left = 12
        Top = 4
        Width = 841
        Height = 6
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDSR: TQRLabel
        Left = 594
        Top = 53
        Width = 253
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          116.416666666667
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lNDSR: TQRLabel
        Left = 594
        Top = 31
        Width = 253
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          68.7916666666667
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object lSumR: TQRLabel
        Left = 595
        Top = 10
        Width = 252
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          21.1666666666667
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel59: TQRLabel
        Left = 474
        Top = 53
        Width = 102
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          116.416666666667
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel60: TQRLabel
        Left = 518
        Top = 31
        Width = 58
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1143
          68.7916666666667
          127)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel61: TQRLabel
        Left = 504
        Top = 10
        Width = 72
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1111.25
          21.1666666666667
          158.75)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object QRLabel57: TQRLabel
        Left = 565
        Top = 251
        Width = 276
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1245.74652777778
          553.420138888889
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel63: TQRLabel
        Left = 12
        Top = 130
        Width = 284
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          26.4583333333333
          286.631944444444
          626.180555555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel64: TQRLabel
        Left = 185
        Top = 146
        Width = 34
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          407.899305555556
          321.909722222222
          74.9652777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel65: TQRLabel
        Left = 194
        Top = 184
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          427.743055555556
          405.694444444444
          35.2777777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel66: TQRLabel
        Left = 190
        Top = 227
        Width = 28
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          418.923611111111
          500.503472222222
          61.7361111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel67: TQRLabel
        Left = 108
        Top = 168
        Width = 188
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          48.5069444444444
          238.125
          370.416666666667
          414.513888888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel128: TQRLabel
        Left = 108
        Top = 212
        Width = 188
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          238.125
          467.430555555556
          414.513888888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel129: TQRLabel
        Left = 454
        Top = 130
        Width = 300
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1001.00694444444
          286.631944444444
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel130: TQRLabel
        Left = 641
        Top = 146
        Width = 34
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1413.31597222222
          321.909722222222
          74.9652777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel131: TQRLabel
        Left = 650
        Top = 184
        Width = 16
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1433.15972222222
          405.694444444444
          35.2777777777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel132: TQRLabel
        Left = 646
        Top = 227
        Width = 28
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          1424.34027777778
          500.503472222222
          61.7361111111111)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel133: TQRLabel
        Left = 564
        Top = 168
        Width = 188
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1243.54166666667
          370.416666666667
          414.513888888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel134: TQRLabel
        Left = 564
        Top = 212
        Width = 188
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          1243.54166666667
          467.430555555556
          414.513888888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName2: TQRLabel
        Left = 114
        Top = 160
        Width = 170
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          251.354166666667
          352.777777777778
          374.826388888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada2: TQRLabel
        Left = 114
        Top = 117
        Width = 170
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          251.354166666667
          257.96875
          374.826388888889)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel2: TQRLabel
        Left = 108
        Top = 239
        Width = 20
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          238.125
          526.961805555556
          44.0972222222222)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec2: TQRLabel
        Left = 131
        Top = 239
        Width = 97
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          35.2777777777778
          288.836805555556
          526.961805555556
          213.871527777778)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
      object QRLabel248: TQRLabel
        Left = 12
        Top = 55
        Width = 50
        Height = 20
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.0972222222222
          26.4583333333333
          121.267361111111
          110.243055555556)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Увага!'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
      object qrlWarning2: TQRLabel
        Left = 12
        Top = 74
        Width = 834
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          81.5798611111111
          26.4583333333333
          163.159722222222
          1838.85416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'У разі несплати рахунка протягом банківських днів будуть вжиті з' +
          'аходи щодо припинення електропостачання вашого підприємства відп' +
          'овідно з п. 7.5 (3) правил користування електричною енергією.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
    end
  end
  object PrintBill_p2av: TQuickRep
    Left = 2684
    Top = -8
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSumm
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand6: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 35
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
        92.6041666666667
        1899.70833333333)
      BandType = rbTitle
      object QRShape40: TQRShape
        Left = 6
        Top = 1
        Width = 256
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          15.875
          2.64583333333333
          677.333333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape41: TQRShape
        Left = 259
        Top = 1
        Width = 119
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          685.270833333333
          2.64583333333333
          314.854166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape42: TQRShape
        Left = 377
        Top = 1
        Width = 71
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          997.479166666667
          2.64583333333333
          187.854166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape43: TQRShape
        Left = 445
        Top = 1
        Width = 137
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1177.39583333333
          2.64583333333333
          362.479166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape44: TQRShape
        Left = 581
        Top = 1
        Width = 125
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1537.22916666667
          2.64583333333333
          330.729166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel75: TQRLabel
        Left = 40
        Top = 3
        Width = 196
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          105.833333333333
          7.9375
          518.583333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тарифна група'
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
      object QRLabel76: TQRLabel
        Left = 262
        Top = 3
        Width = 112
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          693.208333333333
          7.9375
          296.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата встановлення тарифа'
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
      object QRLabel77: TQRLabel
        Left = 380
        Top = 3
        Width = 64
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1005.41666666667
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф, грн/кВт'
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
      object QRLabel78: TQRLabel
        Left = 449
        Top = 3
        Width = 125
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1187.97916666667
          7.9375
          330.729166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Очікувані обсяги споживання, кВтг'
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
      object QRLabel79: TQRLabel
        Left = 611
        Top = 3
        Width = 76
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1616.60416666667
          7.9375
          201.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума нарах. грн.'
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
    object QRBand7: TQRBand
      Left = 38
      Top = 91
      Width = 718
      Height = 15
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand2BeforePrint
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
        39.6875
        1899.70833333333)
      BandType = rbDetail
      object QRDBText31: TQRDBText
        Left = 589
        Top = 1
        Width = 112
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1558.39583333333
          2.64583333333333
          296.333333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText32: TQRDBText
        Left = 457
        Top = 1
        Width = 119
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1209.14583333333
          2.64583333333333
          314.854166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText34: TQRDBText
        Left = 15
        Top = 1
        Width = 239
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          39.6875
          2.64583333333333
          632.354166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'tarname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText35: TQRDBText
        Left = 381
        Top = 1
        Width = 63
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1008.0625
          2.64583333333333
          166.6875)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.0000'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText36: TQRDBText
        Left = 269
        Top = 1
        Width = 103
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          711.729166666667
          2.64583333333333
          272.520833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'dat_tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRBand8: TQRBand
      Left = 38
      Top = 106
      Width = 718
      Height = 201
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
        531.8125
        1899.70833333333)
      BandType = rbSummary
      object QRShape48: TQRShape
        Left = 10
        Top = 3
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDSAv: TQRLabel
        Left = 495
        Top = 48
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          127
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDSAv: TQRLabel
        Left = 495
        Top = 30
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          79.375
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lSumAv: TQRLabel
        Left = 496
        Top = 12
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          31.75
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel86: TQRLabel
        Left = 395
        Top = 48
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          127
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel87: TQRLabel
        Left = 444
        Top = 30
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1174.75
          79.375
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel88: TQRLabel
        Left = 429
        Top = 12
        Width = 51
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1135.0625
          31.75
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel89: TQRLabel
        Left = 471
        Top = 176
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          465.666666666667
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel90: TQRLabel
        Left = 10
        Top = 75
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          198.4375
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel91: TQRLabel
        Left = 154
        Top = 88
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          232.833333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel92: TQRLabel
        Left = 162
        Top = 120
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          317.5
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel93: TQRLabel
        Left = 158
        Top = 156
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          412.75
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel94: TQRLabel
        Left = 90
        Top = 107
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          283.104166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel135: TQRLabel
        Left = 90
        Top = 143
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel136: TQRLabel
        Left = 378
        Top = 75
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          198.4375
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel137: TQRLabel
        Left = 534
        Top = 88
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          232.833333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel138: TQRLabel
        Left = 542
        Top = 120
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          317.5
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel139: TQRLabel
        Left = 538
        Top = 156
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          412.75
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel140: TQRLabel
        Left = 470
        Top = 107
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          283.104166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel141: TQRLabel
        Left = 470
        Top = 143
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName3: TQRLabel
        Left = 95
        Top = 100
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          264.583333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada3: TQRLabel
        Left = 95
        Top = 64
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          169.333333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel3: TQRLabel
        Left = 90
        Top = 166
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          439.208333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec3: TQRLabel
        Left = 109
        Top = 166
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          439.208333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
    end
    object QRGroup4: TQRGroup
      Left = 38
      Top = 73
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      Expression = 'tgr_id'
      Master = PrintBill_p2av
      ReprintOnNewPage = False
      object QRDBText38: TQRDBText
        Left = 10
        Top = 1
        Width = 35
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          26.4583333333333
          2.64583333333333
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm
        DataField = 'tgrname'
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
    end
  end
  object PrintBill_p2cor: TQuickRep
    Left = 3339
    Top = 12
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSummCor
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand9: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 35
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
        92.6041666666667
        1899.70833333333)
      BandType = rbTitle
      object QRShape45: TQRShape
        Left = 6
        Top = 1
        Width = 300
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          15.875
          2.64583333333333
          793.75)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape46: TQRShape
        Left = 303
        Top = 1
        Width = 100
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          801.6875
          2.64583333333333
          264.583333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape47: TQRShape
        Left = 401
        Top = 1
        Width = 99
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1060.97916666667
          2.64583333333333
          261.9375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape49: TQRShape
        Left = 499
        Top = 1
        Width = 101
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1320.27083333333
          2.64583333333333
          267.229166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape50: TQRShape
        Left = 599
        Top = 1
        Width = 107
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1584.85416666667
          2.64583333333333
          283.104166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel80: TQRLabel
        Left = 56
        Top = 7
        Width = 196
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          148.166666666667
          18.5208333333333
          518.583333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тарифна група/ точка обліку'
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
      object QRLabel81: TQRLabel
        Left = 306
        Top = 4
        Width = 90
        Height = 27
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          71.4375
          809.625
          10.5833333333333
          238.125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Початкова дата'
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
      object QRLabel82: TQRLabel
        Left = 408
        Top = 4
        Width = 88
        Height = 27
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          71.4375
          1079.5
          10.5833333333333
          232.833333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Кінцева дата'
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
      object QRLabel83: TQRLabel
        Left = 511
        Top = 3
        Width = 79
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1352.02083333333
          7.9375
          209.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск,'
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
      object QRLabel84: TQRLabel
        Left = 615
        Top = 3
        Width = 76
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1627.1875
          7.9375
          201.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума нарах. грн.'
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
    object QRBand10: TQRBand
      Left = 38
      Top = 91
      Width = 718
      Height = 15
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      BeforePrint = QRBand2BeforePrint
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
        39.6875
        1899.70833333333)
      BandType = rbDetail
      object QRDBText33: TQRDBText
        Left = 603
        Top = 1
        Width = 101
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1595.4375
          2.64583333333333
          267.229166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText37: TQRDBText
        Left = 503
        Top = 1
        Width = 93
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1330.85416666667
          2.64583333333333
          246.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText40: TQRDBText
        Left = 175
        Top = 1
        Width = 125
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          463.020833333333
          2.64583333333333
          330.729166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'tarname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText41: TQRDBText
        Left = 311
        Top = 1
        Width = 89
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          822.854166666667
          2.64583333333333
          235.479166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'dt_begin'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText42: TQRDBText
        Left = 10
        Top = 1
        Width = 162
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          26.4583333333333
          2.64583333333333
          428.625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'name_eqp'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText43: TQRDBText
        Left = 409
        Top = 1
        Width = 91
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1082.14583333333
          2.64583333333333
          240.770833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'dt_end'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRBand11: TQRBand
      Left = 38
      Top = 106
      Width = 718
      Height = 235
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
        621.770833333333
        1899.70833333333)
      BandType = rbSummary
      object QRShape54: TQRShape
        Left = 10
        Top = 3
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDSCor: TQRLabel
        Left = 495
        Top = 48
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          127
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDSCor: TQRLabel
        Left = 495
        Top = 30
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          79.375
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lSumCor: TQRLabel
        Left = 496
        Top = 12
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          31.75
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel100: TQRLabel
        Left = 395
        Top = 48
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          127
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel101: TQRLabel
        Left = 444
        Top = 30
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1174.75
          79.375
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel102: TQRLabel
        Left = 429
        Top = 12
        Width = 51
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1135.0625
          31.75
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel103: TQRLabel
        Left = 471
        Top = 212
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          560.916666666667
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel104: TQRLabel
        Left = 10
        Top = 111
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          293.6875
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel105: TQRLabel
        Left = 154
        Top = 124
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          328.083333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel106: TQRLabel
        Left = 162
        Top = 156
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          412.75
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel107: TQRLabel
        Left = 158
        Top = 192
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          508
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel108: TQRLabel
        Left = 90
        Top = 143
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel142: TQRLabel
        Left = 90
        Top = 179
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          473.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel143: TQRLabel
        Left = 378
        Top = 111
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          293.6875
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel144: TQRLabel
        Left = 534
        Top = 124
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          328.083333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel145: TQRLabel
        Left = 542
        Top = 156
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          412.75
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel146: TQRLabel
        Left = 538
        Top = 192
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          508
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel147: TQRLabel
        Left = 470
        Top = 143
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel148: TQRLabel
        Left = 470
        Top = 179
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          473.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName4: TQRLabel
        Left = 95
        Top = 136
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          359.833333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada4: TQRLabel
        Left = 95
        Top = 100
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          264.583333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel4: TQRLabel
        Left = 90
        Top = 202
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          534.458333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec4: TQRLabel
        Left = 109
        Top = 202
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          534.458333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
      object qrlWarning3: TQRLabel
        Left = 10
        Top = 66
        Width = 695
        Height = 31
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          82.0208333333333
          26.4583333333333
          174.625
          1838.85416666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = True
        Caption = 
          'У разі несплати рахунка протягом банківських днів будуть вжиті з' +
          'аходи щодо припинення електропостачання вашого підприємства відп' +
          'овідно з п. 7.5 (3) правил користування електричною енергією.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial Narrow'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 10
      end
      object QRLabel250: TQRLabel
        Left = 10
        Top = 46
        Width = 42
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          121.708333333333
          111.125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Увага!'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 10
      end
    end
    object QRGroup5: TQRGroup
      Left = 38
      Top = 73
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      Expression = 'tgr_id'
      Master = PrintBill_p2cor
      ReprintOnNewPage = False
      object QRDBText44: TQRDBText
        Left = 10
        Top = 1
        Width = 35
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          26.4583333333333
          2.64583333333333
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'tgrname'
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
    end
  end
  object PrintBill_p2tmp: TQuickRep
    Left = 4147
    Top = 13
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSummCor
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand12: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 35
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
        92.6041666666667
        1899.70833333333)
      BandType = rbTitle
      object QRShape57: TQRShape
        Left = 215
        Top = 1
        Width = 133
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          568.854166666667
          2.64583333333333
          351.895833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape51: TQRShape
        Left = 6
        Top = 1
        Width = 210
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          15.875
          2.64583333333333
          555.625)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape52: TQRShape
        Left = 347
        Top = 1
        Width = 96
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          918.104166666667
          2.64583333333333
          254)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape53: TQRShape
        Left = 441
        Top = 1
        Width = 71
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1166.8125
          2.64583333333333
          187.854166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape55: TQRShape
        Left = 511
        Top = 1
        Width = 97
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1352.02083333333
          2.64583333333333
          256.645833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape56: TQRShape
        Left = 607
        Top = 1
        Width = 99
        Height = 32
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          84.6666666666667
          1606.02083333333
          2.64583333333333
          261.9375)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel85: TQRLabel
        Left = 12
        Top = 3
        Width = 196
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          31.75
          7.9375
          518.583333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Точка обліку'
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
      object QRLabel95: TQRLabel
        Left = 350
        Top = 3
        Width = 90
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          926.041666666667
          7.9375
          238.125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Дата встанов. тарифа'
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
      object QRLabel96: TQRLabel
        Left = 444
        Top = 3
        Width = 64
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1174.75
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф, грн/кВт'
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
      object QRLabel97: TQRLabel
        Left = 519
        Top = 3
        Width = 79
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1373.1875
          7.9375
          209.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Корисний відпуск, кВтг'
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
      object QRLabel98: TQRLabel
        Left = 619
        Top = 3
        Width = 76
        Height = 28
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          74.0833333333333
          1637.77083333333
          7.9375
          201.083333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума нарах. грн.'
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
      object QRLabel109: TQRLabel
        Left = 234
        Top = 7
        Width = 90
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          58.2083333333333
          619.125
          18.5208333333333
          238.125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф'
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
    object QRBand13: TQRBand
      Left = 38
      Top = 91
      Width = 718
      Height = 15
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
        39.6875
        1899.70833333333)
      BandType = rbDetail
      object QRDBText39: TQRDBText
        Left = 611
        Top = 1
        Width = 93
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1616.60416666667
          2.64583333333333
          246.0625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'sum_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText45: TQRDBText
        Left = 519
        Top = 1
        Width = 89
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1373.1875
          2.64583333333333
          235.479166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'demand_val'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText47: TQRDBText
        Left = 219
        Top = 1
        Width = 125
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          579.4375
          2.64583333333333
          330.729166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'tarname'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText48: TQRDBText
        Left = 447
        Top = 1
        Width = 65
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1182.6875
          2.64583333333333
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.0000'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText49: TQRDBText
        Left = 354
        Top = 1
        Width = 90
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          936.625
          2.64583333333333
          238.125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'dat_tariff'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object QRDBText46: TQRDBText
        Left = 10
        Top = 1
        Width = 202
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          26.4583333333333
          2.64583333333333
          534.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'name_eqp'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRBand14: TQRBand
      Left = 38
      Top = 106
      Width = 718
      Height = 204
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
        539.75
        1899.70833333333)
      BandType = rbSummary
      object QRShape60: TQRShape
        Left = 10
        Top = 3
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDSTmp: TQRLabel
        Left = 495
        Top = 48
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          127
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDSTmp: TQRLabel
        Left = 495
        Top = 30
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          79.375
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lSumTmp: TQRLabel
        Left = 496
        Top = 12
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          31.75
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel114: TQRLabel
        Left = 395
        Top = 48
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          127
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel115: TQRLabel
        Left = 444
        Top = 30
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1174.75
          79.375
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel116: TQRLabel
        Left = 429
        Top = 12
        Width = 51
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1135.0625
          31.75
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel117: TQRLabel
        Left = 471
        Top = 176
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          465.666666666667
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel118: TQRLabel
        Left = 10
        Top = 75
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          198.4375
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel119: TQRLabel
        Left = 154
        Top = 88
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          232.833333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel120: TQRLabel
        Left = 162
        Top = 120
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          317.5
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel121: TQRLabel
        Left = 158
        Top = 156
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          412.75
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel122: TQRLabel
        Left = 90
        Top = 107
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          283.104166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel149: TQRLabel
        Left = 90
        Top = 143
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel150: TQRLabel
        Left = 378
        Top = 75
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          198.4375
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel151: TQRLabel
        Left = 534
        Top = 88
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          232.833333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel152: TQRLabel
        Left = 542
        Top = 120
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          317.5
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel153: TQRLabel
        Left = 538
        Top = 156
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          412.75
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel154: TQRLabel
        Left = 470
        Top = 107
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          283.104166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel155: TQRLabel
        Left = 470
        Top = 143
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          378.354166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName5: TQRLabel
        Left = 95
        Top = 100
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          264.583333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada5: TQRLabel
        Left = 95
        Top = 64
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          169.333333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel5: TQRLabel
        Left = 90
        Top = 166
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          439.208333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec5: TQRLabel
        Left = 109
        Top = 166
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          439.208333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
    end
    object QRGroup6: TQRGroup
      Left = 38
      Top = 73
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      Expression = 'tgr_id'
      Master = PrintBill_p2tmp
      ReprintOnNewPage = False
      object QRDBText51: TQRDBText
        Left = 10
        Top = 1
        Width = 35
        Height = 16
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          42.3333333333333
          26.4583333333333
          2.64583333333333
          92.6041666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSummCor
        DataField = 'tgrname'
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
    end
  end
  object PrintBill_p2krd: TQuickRep
    Left = 4951
    Top = 14
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSummCor
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand15: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 281
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
        743.479166666667
        1899.70833333333)
      BandType = rbSummary
      object QRShape62: TQRShape
        Left = 154
        Top = 10
        Width = 385
        Height = 125
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          330.729166666667
          407.458333333333
          26.4583333333333
          1018.64583333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape66: TQRShape
        Left = 154
        Top = 30
        Width = 384
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          79.375
          1016)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape65: TQRShape
        Left = 154
        Top = 54
        Width = 384
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          142.875
          1016)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape64: TQRShape
        Left = 154
        Top = 78
        Width = 384
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          206.375
          1016)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape63: TQRShape
        Left = 154
        Top = 102
        Width = 384
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          269.875
          1016)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDS2krd: TQRLabel
        Left = 295
        Top = 112
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          780.520833333333
          296.333333333333
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lNDS2krd: TQRLabel
        Left = 295
        Top = 90
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          780.520833333333
          238.125
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lSum2krd: TQRLabel
        Left = 296
        Top = 64
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          783.166666666667
          169.333333333333
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel162: TQRLabel
        Left = 170
        Top = 112
        Width = 110
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          449.791666666667
          296.333333333333
          291.041666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього до сплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel163: TQRLabel
        Left = 244
        Top = 90
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          645.583333333333
          238.125
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel164: TQRLabel
        Left = 190
        Top = 64
        Width = 90
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          502.708333333333
          169.333333333333
          238.125)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума без ПДВ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel186: TQRLabel
        Left = 471
        Top = 256
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          677.333333333333
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel187: TQRLabel
        Left = 10
        Top = 155
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          410.104166666667
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel188: TQRLabel
        Left = 154
        Top = 168
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          444.5
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel189: TQRLabel
        Left = 162
        Top = 200
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          529.166666666667
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel190: TQRLabel
        Left = 158
        Top = 236
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          624.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel191: TQRLabel
        Left = 90
        Top = 187
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          494.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel192: TQRLabel
        Left = 90
        Top = 223
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          590.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel193: TQRLabel
        Left = 378
        Top = 155
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          410.104166666667
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel194: TQRLabel
        Left = 534
        Top = 168
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          444.5
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel195: TQRLabel
        Left = 542
        Top = 200
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          529.166666666667
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel196: TQRLabel
        Left = 538
        Top = 236
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          624.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel197: TQRLabel
        Left = 470
        Top = 187
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          494.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel198: TQRLabel
        Left = 470
        Top = 223
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          590.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName6: TQRLabel
        Left = 95
        Top = 180
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          476.25
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada6: TQRLabel
        Left = 95
        Top = 144
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          381
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel165: TQRLabel
        Left = 170
        Top = 16
        Width = 110
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          449.791666666667
          42.3333333333333
          291.041666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Обсяг перевищення'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lDemand2krd: TQRLabel
        Left = 296
        Top = 16
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          783.166666666667
          42.3333333333333
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lDemand2krd'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRLabel167: TQRLabel
        Left = 244
        Top = 38
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          645.583333333333
          100.541666666667
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object lTariff2krd: TQRLabel
        Left = 295
        Top = 38
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          780.520833333333
          100.541666666667
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lTariff2krd'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 14
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -11
      end
      object QRShape61: TQRShape
        Left = 6
        Top = 0
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          15.875
          0
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object QRShape67: TQRShape
        Left = 288
        Top = 10
        Width = 2
        Height = 122
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          322.791666666667
          762
          26.4583333333333
          5.29166666666667)
        Shape = qrsVertLine
        VertAdjust = 0
      end
      object qrlPhoneExecLabel6: TQRLabel
        Left = 92
        Top = 250
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          243.416666666667
          661.458333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec6: TQRLabel
        Left = 111
        Top = 250
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          293.6875
          661.458333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
    end
  end
  object PrintBill_p2krp: TQuickRep
    Left = 5767
    Top = 14
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSumm2krp
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand16: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 79
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
        209.020833333333
        1899.70833333333)
      BandType = rbTitle
      object QRShape75: TQRShape
        Left = 506
        Top = 1
        Width = 88
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          1338.79166666667
          2.64583333333333
          232.833333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape68: TQRShape
        Left = 190
        Top = 1
        Width = 85
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          502.708333333333
          2.64583333333333
          224.895833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape69: TQRShape
        Left = 6
        Top = 1
        Width = 185
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          15.875
          2.64583333333333
          489.479166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape70: TQRShape
        Left = 274
        Top = 1
        Width = 77
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          724.958333333333
          2.64583333333333
          203.729166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape71: TQRShape
        Left = 349
        Top = 1
        Width = 79
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          923.395833333333
          2.64583333333333
          209.020833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape72: TQRShape
        Left = 427
        Top = 1
        Width = 80
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          1129.77083333333
          2.64583333333333
          211.666666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel159: TQRLabel
        Left = 12
        Top = 7
        Width = 175
        Height = 26
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          68.7916666666667
          31.75
          18.5208333333333
          463.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Майданчик'
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
      object QRLabel160: TQRLabel
        Left = 354
        Top = 3
        Width = 69
        Height = 62
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          164.041666666667
          936.625
          7.9375
          182.5625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Фактично зафіксована потужність, кВт'
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
      object QRLabel161: TQRLabel
        Left = 280
        Top = 3
        Width = 64
        Height = 62
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          164.041666666667
          740.833333333333
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Гранична величина потужності, кВт'
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
      object QRLabel166: TQRLabel
        Left = 431
        Top = 3
        Width = 72
        Height = 70
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          185.208333333333
          1140.35416666667
          7.9375
          190.5)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Перевищення граничної величини потужності, кВт'
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
      object QRLabel168: TQRLabel
        Left = 510
        Top = 3
        Width = 81
        Height = 70
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          185.208333333333
          1349.375
          7.9375
          214.3125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф за перевищення граничної величини потужності, грн'
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
      object QRLabel169: TQRLabel
        Left = 194
        Top = 7
        Width = 77
        Height = 22
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          58.2083333333333
          513.291666666667
          18.5208333333333
          203.729166666667)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Період доби'
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
      object QRShape73: TQRShape
        Left = 593
        Top = 1
        Width = 118
        Height = 75
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          198.4375
          1568.97916666667
          2.64583333333333
          312.208333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel204: TQRLabel
        Left = 598
        Top = 3
        Width = 109
        Height = 66
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          174.625
          1582.20833333333
          7.9375
          288.395833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Плата за перевищення договірної величини потужності,  грн'
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
    object QRBand17: TQRBand
      Left = 38
      Top = 117
      Width = 718
      Height = 15
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
        39.6875
        1899.70833333333)
      BandType = rbDetail
      object QRDBText52: TQRDBText
        Left = 598
        Top = 1
        Width = 110
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1582.20833333333
          2.64583333333333
          291.041666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'sum_value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText53: TQRDBText
        Left = 434
        Top = 1
        Width = 70
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1148.29166666667
          2.64583333333333
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'power_ower'
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
      object QRDBText54: TQRDBText
        Left = 191
        Top = 1
        Width = 80
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          505.354166666667
          2.64583333333333
          211.666666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'period_str'
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
      object QRDBText55: TQRDBText
        Left = 514
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
          1359.95833333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'tarif'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.0000'
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = 7
      end
      object QRDBText56: TQRDBText
        Left = 354
        Top = 1
        Width = 74
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          936.625
          2.64583333333333
          195.791666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'power_fact'
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
      object QRDBText57: TQRDBText
        Left = 10
        Top = 1
        Width = 177
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          26.4583333333333
          2.64583333333333
          468.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'area'
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
      object QRDBText59: TQRDBText
        Left = 282
        Top = 1
        Width = 65
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          746.125
          2.64583333333333
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2krp
        DataField = 'power_limit'
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
    object QRBand18: TQRBand
      Left = 38
      Top = 132
      Width = 718
      Height = 190
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
        502.708333333333
        1899.70833333333)
      BandType = rbSummary
      object QRShape74: TQRShape
        Left = 10
        Top = 3
        Width = 701
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          26.4583333333333
          7.9375
          1854.72916666667)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSum2krp2: TQRLabel
        Left = 495
        Top = 16
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          42.3333333333333
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ISum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel173: TQRLabel
        Left = 374
        Top = 16
        Width = 106
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          989.541666666667
          42.3333333333333
          280.458333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього до сплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel176: TQRLabel
        Left = 471
        Top = 160
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          423.333333333333
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel177: TQRLabel
        Left = 10
        Top = 59
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          156.104166666667
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel178: TQRLabel
        Left = 154
        Top = 72
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          190.5
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel179: TQRLabel
        Left = 162
        Top = 104
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          275.166666666667
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel180: TQRLabel
        Left = 158
        Top = 140
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          370.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel181: TQRLabel
        Left = 90
        Top = 91
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          240.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel182: TQRLabel
        Left = 90
        Top = 127
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          336.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel183: TQRLabel
        Left = 378
        Top = 59
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          156.104166666667
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав : __________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel184: TQRLabel
        Left = 534
        Top = 72
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          190.5
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel185: TQRLabel
        Left = 542
        Top = 104
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          275.166666666667
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel199: TQRLabel
        Left = 538
        Top = 140
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          370.416666666667
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel200: TQRLabel
        Left = 470
        Top = 91
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          240.770833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel201: TQRLabel
        Left = 470
        Top = 127
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          336.020833333333
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName7: TQRLabel
        Left = 95
        Top = 84
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          222.25
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada7: TQRLabel
        Left = 95
        Top = 48
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          127
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel7: TQRLabel
        Left = 90
        Top = 156
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          412.75
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec7: TQRLabel
        Left = 109
        Top = 156
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          412.75
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
      object QRLabel158: TQRLabel
        Left = 2
        Top = 174
        Width = 422
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          5.29166666666667
          460.375
          1116.54166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 
          'Телефон кол-центру: 0-800-210310, адреса веб-сайту: http://chern' +
          'igivoblenergo.com.ua, E-mail: call-center@energy.cn.ua'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
  end
  object PrintBill_p2kr2013: TQuickRep
    Left = 6573
    Top = 32
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSumm2kr_area_2013
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand21: TQRBand
      Left = 38
      Top = 163
      Width = 718
      Height = 230
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
        608.541666666667
        1899.70833333333)
      BandType = rbSummary
      object QRShape83: TQRShape
        Left = 5
        Top = 3
        Width = 705
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          13.2291666666667
          7.9375
          1865.3125)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDS_2kr: TQRLabel
        Left = 495
        Top = 72
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          190.5
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDS_2kr: TQRLabel
        Left = 495
        Top = 54
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          142.875
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lSum_2kr: TQRLabel
        Left = 496
        Top = 36
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1312.33333333333
          95.25
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel174: TQRLabel
        Left = 395
        Top = 72
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          190.5
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel175: TQRLabel
        Left = 444
        Top = 54
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1174.75
          142.875
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel202: TQRLabel
        Left = 429
        Top = 36
        Width = 51
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1135.0625
          95.25
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel203: TQRLabel
        Left = 471
        Top = 200
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          529.166666666667
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel205: TQRLabel
        Left = 10
        Top = 99
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          261.9375
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel206: TQRLabel
        Left = 154
        Top = 112
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          296.333333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel207: TQRLabel
        Left = 162
        Top = 144
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          381
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel208: TQRLabel
        Left = 158
        Top = 180
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          476.25
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel209: TQRLabel
        Left = 90
        Top = 131
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          346.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel210: TQRLabel
        Left = 90
        Top = 167
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          441.854166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel211: TQRLabel
        Left = 378
        Top = 99
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          261.9375
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel212: TQRLabel
        Left = 534
        Top = 112
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          296.333333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel213: TQRLabel
        Left = 542
        Top = 144
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          381
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel214: TQRLabel
        Left = 538
        Top = 180
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          476.25
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel215: TQRLabel
        Left = 470
        Top = 131
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          346.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel216: TQRLabel
        Left = 470
        Top = 167
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          441.854166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName8: TQRLabel
        Left = 95
        Top = 124
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          328.083333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada8: TQRLabel
        Left = 95
        Top = 88
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          232.833333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel8: TQRLabel
        Left = 90
        Top = 190
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          502.708333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec8: TQRLabel
        Left = 109
        Top = 190
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          502.708333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
      object QRLabel4: TQRLabel
        Left = 11
        Top = 8
        Width = 315
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          29.1041666666667
          21.1666666666667
          833.4375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Загальний обсяг перевищення договірної величини споживання'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRExpr3: TQRExpr
        Left = 434
        Top = 8
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1148.29166666667
          21.1666666666667
          185.208333333333)
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
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'SUM(power_bill)'
        FontSize = -10
      end
      object QRLabel48: TQRLabel
        Left = 11
        Top = 20
        Width = 78
        Height = 14
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          37.0416666666667
          29.1041666666667
          52.9166666666667
          206.375)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = ' електроенрегії'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel157: TQRLabel
        Left = 2
        Top = 214
        Width = 422
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          5.29166666666667
          566.208333333333
          1116.54166666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 
          'Телефон кол-центру: 0-800-210310, адреса веб-сайту: http://chern' +
          'igivoblenergo.com.ua, E-mail: call-center@energy.cn.ua'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
    end
    object QRBand22: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 91
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
        240.770833333333
        1899.70833333333)
      BandType = rbTitle
      object QRShape84: TQRShape
        Left = 506
        Top = 1
        Width = 88
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1338.79166666667
          2.64583333333333
          232.833333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape86: TQRShape
        Left = 6
        Top = 1
        Width = 272
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          15.875
          2.64583333333333
          719.666666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape87: TQRShape
        Left = 274
        Top = 1
        Width = 77
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          724.958333333333
          2.64583333333333
          203.729166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape88: TQRShape
        Left = 349
        Top = 1
        Width = 79
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          923.395833333333
          2.64583333333333
          209.020833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape89: TQRShape
        Left = 427
        Top = 1
        Width = 80
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1129.77083333333
          2.64583333333333
          211.666666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel221: TQRLabel
        Left = 60
        Top = 39
        Width = 175
        Height = 26
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          68.7916666666667
          158.75
          103.1875
          463.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Назва площадки/ точка обліку'
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
      object QRLabel222: TQRLabel
        Left = 354
        Top = 3
        Width = 69
        Height = 78
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          206.375
          936.625
          7.9375
          182.5625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Фактичне споживання електроенергії, кВтг'
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
      object QRLabel223: TQRLabel
        Left = 280
        Top = 3
        Width = 64
        Height = 78
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          206.375
          740.833333333333
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Договірна величина споживання електроенергії, кВтг'
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
      object QRLabel224: TQRLabel
        Left = 431
        Top = 3
        Width = 72
        Height = 86
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          227.541666666667
          1140.35416666667
          7.9375
          190.5)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Перевищення договірної величини споживання електро- енергії, кВт' +
          'г'
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
      object QRLabel225: TQRLabel
        Left = 510
        Top = 39
        Width = 81
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.479166666667
          1349.375
          103.1875
          214.3125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф, грн/кВтг'
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
      object QRShape90: TQRShape
        Left = 593
        Top = 1
        Width = 118
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1568.97916666667
          2.64583333333333
          312.208333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel227: TQRLabel
        Left = 598
        Top = 39
        Width = 109
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          97.8958333333333
          1582.20833333333
          103.1875
          288.395833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума, грн'
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
    object QRSubDetail1: TQRSubDetail
      Left = 38
      Top = 147
      Width = 718
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
        42.3333333333333
        1899.70833333333)
      Master = PrintBill_p2kr2013
      DataSet = ZQBillSumm2kr_point_2013
      PrintBefore = False
      PrintIfEmpty = True
      object QRDBText58: TQRDBText
        Left = 29
        Top = 1
        Width = 241
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          76.7291666666667
          2.64583333333333
          637.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_point_2013
        DataField = 'name_eqp'
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
      object QRDBText60: TQRDBText
        Left = 354
        Top = 1
        Width = 74
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          936.625
          2.64583333333333
          195.791666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_point_2013
        DataField = 'demand'
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
    object QRBand19: TQRBand
      Left = 38
      Top = 129
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      BandType = rbDetail
      object QRDBText65: TQRDBText
        Left = 598
        Top = 1
        Width = 110
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1582.20833333333
          2.64583333333333
          291.041666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'sum_value'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.00'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText66: TQRDBText
        Left = 434
        Top = 1
        Width = 70
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          1148.29166666667
          2.64583333333333
          185.208333333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'power_bill'
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
      object QRDBText68: TQRDBText
        Left = 514
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
          1359.95833333333
          2.64583333333333
          206.375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'tarif'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Arial'
        Font.Style = []
        Mask = '0.0000'
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = 7
      end
      object QRDBText69: TQRDBText
        Left = 354
        Top = 1
        Width = 74
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          936.625
          2.64583333333333
          195.791666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'power_fact'
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
      object QRDBText70: TQRDBText
        Left = 10
        Top = 1
        Width = 260
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          26.4583333333333
          2.64583333333333
          687.916666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'area'
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
      object QRDBText71: TQRDBText
        Left = 282
        Top = 1
        Width = 65
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          746.125
          2.64583333333333
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'power_limit'
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
      object QRShape78: TQRShape
        Left = 5
        Top = 0
        Width = 705
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.64583333333333
          13.2291666666667
          0
          1865.3125)
        Shape = qrsHorLine
        VertAdjust = 0
      end
    end
  end
  object PrintBill_p2kr2013_sum: TQuickRep
    Left = 7397
    Top = 34
    Width = 794
    Height = 1123
    Frame.Color = clBlack
    Frame.DrawTop = False
    Frame.DrawBottom = False
    Frame.DrawLeft = False
    Frame.DrawRight = False
    DataSet = ZQBillSumm2kr_area_2013
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
    SnapToGrid = True
    Units = MM
    Zoom = 100
    PrevFormStyle = fsNormal
    PreviewInitialState = wsNormal
    object QRBand20: TQRBand
      Left = 38
      Top = 163
      Width = 718
      Height = 234
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
        619.125
        1899.70833333333)
      BandType = rbSummary
      object QRShape79: TQRShape
        Left = 5
        Top = 3
        Width = 705
        Height = 5
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          13.2291666666667
          13.2291666666667
          7.9375
          1865.3125)
        Shape = qrsHorLine
        VertAdjust = 0
      end
      object lSumAndNDS_2kr_sum: TQRLabel
        Left = 495
        Top = 72
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          190.5
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLSumAndNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDS_2kr_sum: TQRLabel
        Left = 495
        Top = 54
        Width = 211
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          142.875
          558.270833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'QRLNDS'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lSum_2kr_sum: TQRLabel
        Left = 495
        Top = 36
        Width = 210
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1309.6875
          95.25
          555.625)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'lSum'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel170: TQRLabel
        Left = 395
        Top = 72
        Width = 85
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1045.10416666667
          190.5
          224.895833333333)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'До оплати :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object lNDS_2kr_sum_label: TQRLabel
        Left = 444
        Top = 54
        Width = 36
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1174.75
          142.875
          95.25)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'ПДВ :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel172: TQRLabel
        Left = 429
        Top = 36
        Width = 51
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1135.0625
          95.25
          134.9375)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Всього :'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel217: TQRLabel
        Left = 471
        Top = 200
        Width = 230
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1246.1875
          529.166666666667
          608.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = '"____"______________________20_____р.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel218: TQRLabel
        Left = 10
        Top = 99
        Width = 237
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          26.4583333333333
          261.9375
          627.0625)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок склав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel219: TQRLabel
        Left = 154
        Top = 112
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          407.458333333333
          296.333333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel220: TQRLabel
        Left = 162
        Top = 144
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          428.625
          381
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel226: TQRLabel
        Left = 158
        Top = 180
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          418.041666666667
          476.25
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel228: TQRLabel
        Left = 90
        Top = 131
        Width = 157
        Height = 18
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          47.625
          238.125
          346.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel229: TQRLabel
        Left = 90
        Top = 167
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          238.125
          441.854166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel230: TQRLabel
        Left = 378
        Top = 99
        Width = 250
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1000.125
          261.9375
          661.458333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Рахунок отримав  :__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRLabel231: TQRLabel
        Left = 534
        Top = 112
        Width = 28
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1412.875
          296.333333333333
          74.0833333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Посада '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel232: TQRLabel
        Left = 542
        Top = 144
        Width = 13
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1434.04166666667
          381
          34.3958333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'ПІБ'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -7
      end
      object QRLabel233: TQRLabel
        Left = 538
        Top = 180
        Width = 23
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          1423.45833333333
          476.25
          60.8541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'підпис'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 9
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -7
      end
      object QRLabel234: TQRLabel
        Left = 470
        Top = 131
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          346.604166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRLabel235: TQRLabel
        Left = 470
        Top = 167
        Width = 157
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1243.54166666667
          441.854166666667
          415.395833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '__________________________'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object qrlUserName9: TQRLabel
        Left = 95
        Top = 124
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          328.083333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPosada9: TQRLabel
        Left = 95
        Top = 88
        Width = 142
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          251.354166666667
          232.833333333333
          375.708333333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                               '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object qrlPhoneExecLabel9: TQRLabel
        Left = 90
        Top = 190
        Width = 17
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          238.125
          502.708333333333
          44.9791666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Тел.'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -8
      end
      object qrlPhoneExec9: TQRLabel
        Left = 109
        Top = 190
        Width = 81
        Height = 13
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          34.3958333333333
          288.395833333333
          502.708333333333
          214.3125)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = '                                        '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -8
      end
      object QRLabel240: TQRLabel
        Left = 11
        Top = 8
        Width = 86
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          29.1041666666667
          21.1666666666667
          227.541666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = True
        AutoStretch = False
        Caption = 'Загальний обсяг '
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = True
        WordWrap = True
        FontSize = -10
      end
      object QRExpr4: TQRExpr
        Left = 278
        Top = 8
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          735.541666666667
          21.1666666666667
          185.208333333333)
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
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'SUM(power_limit)'
        FontSize = -10
      end
      object QRExpr5: TQRExpr
        Left = 358
        Top = 8
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          947.208333333333
          21.1666666666667
          185.208333333333)
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
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'SUM(power_fact)'
        FontSize = -10
      end
      object lSum_2kr_sum2: TQRLabel
        Left = 599
        Top = 8
        Width = 107
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1584.85416666667
          21.1666666666667
          283.104166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'sum_value'
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = 13
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        Transparent = False
        WordWrap = True
        FontSize = -10
      end
      object QRExpr6: TQRExpr
        Left = 434
        Top = 8
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1148.29166666667
          21.1666666666667
          185.208333333333)
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
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'SUM(power_fact)-SUM(power_limit)'
        FontSize = -10
      end
      object QRExpr7: TQRExpr
        Left = 514
        Top = 8
        Width = 70
        Height = 17
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          44.9791666666667
          1359.95833333333
          21.1666666666667
          185.208333333333)
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
        ParentFont = False
        ResetAfterPrint = False
        Transparent = False
        WordWrap = True
        Expression = 'MAX(tarif)'
        FontSize = -10
      end
    end
    object QRBand23: TQRBand
      Left = 38
      Top = 38
      Width = 718
      Height = 91
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
        240.770833333333
        1899.70833333333)
      BandType = rbTitle
      object QRShape80: TQRShape
        Left = 506
        Top = 1
        Width = 88
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1338.79166666667
          2.64583333333333
          232.833333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape81: TQRShape
        Left = 6
        Top = 1
        Width = 272
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          15.875
          2.64583333333333
          719.666666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape82: TQRShape
        Left = 274
        Top = 1
        Width = 77
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          724.958333333333
          2.64583333333333
          203.729166666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape85: TQRShape
        Left = 349
        Top = 1
        Width = 79
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          923.395833333333
          2.64583333333333
          209.020833333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRShape91: TQRShape
        Left = 427
        Top = 1
        Width = 80
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1129.77083333333
          2.64583333333333
          211.666666666667)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel242: TQRLabel
        Left = 60
        Top = 39
        Width = 175
        Height = 26
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          68.7916666666667
          158.75
          103.1875
          463.020833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Назва площадки/ точка обліку'
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
      object QRLabel243: TQRLabel
        Left = 354
        Top = 3
        Width = 69
        Height = 78
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          206.375
          936.625
          7.9375
          182.5625)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Фактичне споживання електроенергії, кВтг'
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
      object QRLabel244: TQRLabel
        Left = 280
        Top = 3
        Width = 64
        Height = 78
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          206.375
          740.833333333333
          7.9375
          169.333333333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Договірна величина споживання електроенергії, кВтг'
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
      object QRLabel245: TQRLabel
        Left = 431
        Top = 3
        Width = 72
        Height = 86
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          227.541666666667
          1140.35416666667
          7.9375
          190.5)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 
          'Перевищення договірної величини споживання електро- енергії, кВт' +
          'г'
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
      object QRLabel246: TQRLabel
        Left = 510
        Top = 39
        Width = 81
        Height = 41
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          108.479166666667
          1349.375
          103.1875
          214.3125)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Тариф, грн/кВтг'
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
      object QRShape92: TQRShape
        Left = 593
        Top = 1
        Width = 118
        Height = 90
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          238.125
          1568.97916666667
          2.64583333333333
          312.208333333333)
        Shape = qrsRectangle
        VertAdjust = 0
      end
      object QRLabel247: TQRLabel
        Left = 598
        Top = 39
        Width = 109
        Height = 37
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          97.8958333333333
          1582.20833333333
          103.1875
          288.395833333333)
        Alignment = taCenter
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Caption = 'Сума, грн'
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
    object QRSubDetail2: TQRSubDetail
      Left = 38
      Top = 147
      Width = 718
      Height = 16
      Frame.Color = clBlack
      Frame.DrawTop = False
      Frame.DrawBottom = False
      Frame.DrawLeft = False
      Frame.DrawRight = False
      AlignToBottom = False
      Color = clWhite
      Enabled = False
      ForceNewColumn = False
      ForceNewPage = False
      Size.Values = (
        42.3333333333333
        1899.70833333333)
      Master = PrintBill_p2kr2013_sum
      DataSet = ZQBillSumm2kr_point_2013
      PrintBefore = False
      PrintIfEmpty = True
      object QRDBText61: TQRDBText
        Left = 29
        Top = 1
        Width = 241
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          76.7291666666667
          2.64583333333333
          637.645833333333)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_point_2013
        DataField = 'name_eqp'
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
      object QRDBText62: TQRDBText
        Left = 354
        Top = 1
        Width = 74
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          936.625
          2.64583333333333
          195.791666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_point_2013
        DataField = 'demand'
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
    object QRBand24: TQRBand
      Left = 38
      Top = 129
      Width = 718
      Height = 18
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
        47.625
        1899.70833333333)
      BandType = rbDetail
      object QRDBText72: TQRDBText
        Left = 354
        Top = 1
        Width = 74
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          936.625
          2.64583333333333
          195.791666666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'power_fact'
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
      object QRDBText73: TQRDBText
        Left = 10
        Top = 1
        Width = 260
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          26.4583333333333
          2.64583333333333
          687.916666666667)
        Alignment = taLeftJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'area'
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
      object QRDBText74: TQRDBText
        Left = 282
        Top = 1
        Width = 65
        Height = 15
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          39.6875
          746.125
          2.64583333333333
          171.979166666667)
        Alignment = taRightJustify
        AlignToBand = False
        AutoSize = False
        AutoStretch = False
        Color = clWhite
        DataSet = ZQBillSumm2kr_area_2013
        DataField = 'power_limit'
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
      object QRShape93: TQRShape
        Left = 5
        Top = 0
        Width = 705
        Height = 1
        Frame.Color = clBlack
        Frame.DrawTop = False
        Frame.DrawBottom = False
        Frame.DrawLeft = False
        Frame.DrawRight = False
        Size.Values = (
          2.64583333333333
          13.2291666666667
          0
          1865.3125)
        Shape = qrsHorLine
        VertAdjust = 0
      end
    end
  end
  object ZQBillDemand: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select distinct pb.id_point, pb.id_p_point, pb.id_client, pb.lev' +
        'el, pb.num_order, cm.short_name as ownername,'
      
        'ba.name_eqp_inst as groundname,ba.code_eqp_inst as groundid,ba.f' +
        'ull_adr as pointaddr,en.kind_energy,'
      'pb.num_order::::varchar||'#39' '#39'||ba.name_eqp::::varchar as fullname'
      'from'
      ' clm_client_tbl as cm,'
      ' acd_point_branch_tbl as pb'
      
        ' join eqt_bill_addr_tbl as ba on ((pb.id_point=ba.code_eqp)and (' +
        'pb.id_doc=ba.id_doc))'
      
        ' left join (select distinct id_point,kind_energy from acd_pwr_de' +
        'mand_tbl where id_doc=:doc ) as en on (en.id_point=pb.id_point)'
      
        'where (pb.id_doc = :doc) and (cm.id=pb.id_client) and coalesce(p' +
        'b.num_order,0) <>-1'
      'order by  pb.num_order,en.kind_energy;'
      ''
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ''
      ''
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 461
    Top = 125
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
  object ZQBillSumm: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select sum( bs.demand_val::::numeric ) as demand_val, sum(bs.sum' +
        '_val)as sum_val ,'
      'tar.name as tarname,tgr.name as tgrname,bs.id_zone,'
      'td.value, td.dt_begin as dat_tariff, tgr.id as tgr_id,'
      
        'CASE WHEN bs.id_zone <> 0 THEN zk.name  ELSE  '#39'-'#39' END as zonenam' +
        'e,'
      'zd.koef'
      'from acd_billsum_tbl as bs'
      'left join aci_tarif_tbl as tar on (bs.id_tariff=tar.id)'
      
        'left join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif' +
        ')'
      'left join acd_tarif_tbl as td on (bs.id_sumtariff= td.id)'
      'left join acd_zone_tbl as zd on (bs.id_zonekoef=zd.id)'
      'left join eqk_zone_tbl as zk on (bs.id_zone=zk.id)'
      'where (bs.id_doc = :doc) '
      
        'group by tar.name ,tgr.name ,bs.id_zone, td.value,td.dt_begin ,t' +
        'gr.id , zk.name ,zd.koef'
      'order by tgr.id, tar.name, zk.name;'
      ''
      ''
      ' '
      ''
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
    Left = 565
    Top = 180
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
    Left = 602
    Top = 145
  end
  object ZQBill: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'select b.reg_num, b.dat_e,b.reg_date,b.mfo_self,b.account_self,b' +
        '.id_pref,bank.name as bankname, b.demand_val,'
      
        'b.value, b.value_tax,abon.name as abonname, abon.id as abonid, a' +
        'bon.code, res.name as resname,'
      
        'addr.full_adr as abonaddr, abonpar.doc_num, abonpar.doc_dat, abo' +
        'npar.doc_num_tend, abonpar.doc_dat_tend, abonpar.day_pay_bill, r' +
        'espar.okpo_num,abonpar.okpo_num as abon_okpo_num,'
      'abonpar.phone as abonphone,respar.phone as resphone,'
      
        'raddr.full_adr as resaddr,respar.tax_num,respar.licens_num, dci.' +
        'ident,users.represent_name, ip.name as posname,users.phone as us' +
        'rphone,'
      
        'b.id_ind,b.mmgg,b.mmgg_bill, (select sum(b2.demand_val) from acm' +
        '_bill_tbl as b2 where b.id_client = b2.id_client and b.id_pref =' +
        ' b2.id_pref and b2.mmgg = b.mmgg - '#39'1 month'#39'::::interval) as las' +
        't_demand'
      
        'from acm_bill_tbl as b left join cmi_bank_tbl as bank on (bank.i' +
        'd = b.mfo_self)'
      'left join clm_position_tbl as users on (users.id = b.id_person)'
      'left join cli_position_tbl as ip  on (ip.id = users.id_position)'
      'left join dci_document_tbl as dci on (b.idk_doc = dci.id),'
      
        'clm_client_tbl as res left join clm_statecl_tbl as respar on (re' +
        'spar.id_client = res.id)'
      
        'left join adv_address_tbl as raddr on (raddr.id = res.id_addres)' +
        ','
      
        'clm_client_tbl as abon left join adv_address_tbl as addr on (add' +
        'r.id = abon.id_addres)'
      
        'left join clm_statecl_h as abonpar on (abonpar.id_client = abon.' +
        'id)'
      'where (b.id_doc = :doc) and (b.id_client = abon.id)'
      'and (res.id = syi_resid_fun() )'
      
        'and abonpar.mmgg_b = (select max(mmgg_b) from clm_statecl_h as a' +
        'bonpar2 where abonpar2.id_client = abonpar.id_client and abonpar' +
        '2.mmgg_b <= coalesce(b.dat_e, b.reg_date));'
      ''
      ' ')
    RequestLive = False
    Left = 566
    Top = 143
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
  object ZQBillPoint: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkFields = 'id_point=id_point,kind_energy=kind_energy'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsDemand
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'Select pd.id_point, pd.id_zone, pd.fact_demand as demand, pd.fac' +
        't_losts as losts,'
      
        '(pd.fact_demand+ pd.fact_losts) as sum_val,pd.kind_energy,zz.nam' +
        'e as name_zone'
      
        'from acd_pwr_demand_tbl as pd left join eqk_zone_tbl as zz on (z' +
        'z.id=pd.id_zone),'
      'acd_point_branch_tbl as pb'
      'where'
      
        ' pb.id_doc = pd.id_doc and pb.id_point =pd.id_point and pb.id_cl' +
        'ient = :client and'
      ' pd.id_doc= :doc'
      ' union'
      
        'Select pd.id_point, pd.id_zone, pd.sum_demand as demand, pd.sum_' +
        'losts as losts,'
      
        '(pd.sum_demand+ pd.sum_losts) as sum_val,pd.kind_energy,zz.name ' +
        'as name_zone'
      
        'from acd_pwr_demand_tbl as pd left join eqk_zone_tbl as zz on (z' +
        'z.id=pd.id_zone),'
      'acd_point_branch_tbl as pb'
      'where'
      
        ' pb.id_doc = pd.id_doc and pb.id_point =pd.id_point and pb.id_cl' +
        'ient <> :client and'
      ' pd.id_doc= :doc'
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
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 692
    Top = 32
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'client'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end>
  end
  object ZQBillMeter: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkFields = 'id_point=id_point, kind_energy=kind_energy'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsDemand
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      
        'Select met.id_point, met.id_meter, met.id_zone, met.num_eqp, met' +
        '.k_tr, met.dat_e,'
      
        'met.b_val, met.e_val, met.ktr_demand,met.kind_energy,zz.name as ' +
        'name_zone,'
      
        'met.calc_demand_cnt,met.comment_cnt,met.calc_demand_w,met.commen' +
        't_w,'
      
        'coalesce(rtrim(met.comment_cnt),'#39#39')||'#39' '#39'||coalesce(rtrim(met.com' +
        'ment_w),'#39#39') as comment'
      
        'from acd_met_kndzn_tbl as met left join eqk_zone_tbl as zz on (z' +
        'z.id=met.id_zone)'
      'where'
      ' met.id_doc= :doc'
      'order by met.num_eqp;'
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 568
    Top = 48
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end>
  end
  object dsDemand: TDataSource
    AutoEdit = False
    DataSet = ZQBillDemand
    Left = 568
    Top = 105
  end
  object ZQPrepare: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select eqc_bill_addr_fun( :doc, :dat);'
      ''
      ' ')
    RequestLive = False
    Left = 800
    Top = 34
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'dat'
        ParamType = ptUnknown
      end>
  end
  object ZQBillSummR: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select eq.name_eqp, pb.num_order, pb.num_order::::varchar||'#39' '#39'||' +
        'eq.name_eqp::::varchar as fullname,'
      'bs.demand_val, bs.sum_val,p1,p2,p3,tg_fi,k_fi,d,wp,wq,bs.k_corr,'
      'bs.id_sumtariff,td.value, td.dt_begin as dat_tariff,'
      
        'CASE WHEN kind_energy = 2 THEN '#39'РЕ'#39' WHEN kind_energy = 4 THEN '#39'Г' +
        'Е'#39' END as energy'
      
        'from acd_billsum_tbl as bs join eqm_equipment_h as eq on (eq.id ' +
        '= bs.id_point)'
      'join acd_tarif_tbl as td on (bs.id_sumtariff= td.id)'
      
        'join acd_point_branch_tbl as pb on ((pb.id_point=bs.id_point)and' +
        ' (pb.id_doc=bs.id_doc))'
      ''
      
        'where (bs.id_doc = :doc) and (eq.dt_b = (select max(dt_b) from e' +
        'qm_equipment_h where id = eq.id ))'
      'order by td.dt_begin, pb.num_order'
      ''
      ''
      ' '
      ''
      ''
      ' '
      ' '
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ' '
      ' ')
    RequestLive = False
    Left = 499
    Top = 124
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
  object ZQBillSummCor: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      
        'select eq.name_eqp,tar.name as tarname,tgr.name as tgrname,tgr.i' +
        'd as tgr_id,'
      
        'td.value, td.dt_begin as dat_tariff,bs.demand_val, bs.sum_val,bs' +
        '.dt_begin, bs.dt_end'
      'from acd_billsum_tbl as bs'
      'left join eqm_equipment_tbl as eq on (eq.id = bs.id_point)'
      'left join aci_tarif_tbl as tar on (bs.id_tariff=tar.id)'
      'left join acd_tarif_tbl as td on (bs.id_sumtariff= td.id)'
      
        'left join eqi_grouptarif_tbl as tgr on (tgr.id=tar.id_grouptarif' +
        ')'
      'where (bs.id_doc = :doc)'
      'order by tgr.id, tar.name;'
      ''
      ''
      ' '
      ''
      ''
      ' '
      ' '
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 463
    Top = 156
    ParamData = <
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
  object ZQBillSumm2krp: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select coalesce(a.name_eqp, '#39' - '#39') as area,'
      
        'bs.id_area,bs.night_day,bs.power_limit,bs.power_fact,bs.power_ow' +
        'er,bs.tarif,bs.sum_value,'
      
        'case when bs.night_day = 1 then '#39'Ранковий макс.'#39' when bs.night_d' +
        'ay = 2 then '#39'Вечірній макс.'#39' end as period_str'
      'from acd_pwr_limit_over_tbl as bs'
      'left join'
      '(select eq.id, eq.name_eqp from eqm_equipment_h as eq'
      
        '  join (select id, max(dt_b) as dt from eqm_equipment_h  where d' +
        't_b <= :mmgg and coalesce(dt_e, :mmgg) >= :mmgg  and type_eqp = ' +
        '11 group by id) as eq2'
      '  on (eq.id = eq2.id and eq2.dt = eq.dt_b)'
      ')as a on (bs.id_area = a.id)'
      'where (bs.id_doc = :doc)'
      'order by area, period_str;'
      ''
      ''
      ' '
      ''
      ''
      ' '
      ' '
      ''
      ' '
      ' '
      ' '
      ' '
      ' '
      ''
      ' '
      ''
      ' '
      ' ')
    RequestLive = False
    Left = 515
    Top = 156
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
  object ZQBillSumm2kr_area_2013: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    Sql.Strings = (
      'select a.name_eqp||coalesce('#39'   /'#39'||adr.adr||'#39'/'#39','#39#39') as area,'
      
        'bs.id_area,bs.power_limit,bs.power_fact,bs.power_ower,bs.power_b' +
        'ill,bs.tarif,bs.sum_value'
      'from acd_pwr_limit_over_tbl as bs'
      'left join'
      
        '(select eq.id, eq.name_eqp,eq.id_addres from eqm_equipment_h as ' +
        'eq'
      
        '  join (select id, max(dt_b) as dt from eqm_equipment_h  where d' +
        't_b <= :mmgg and coalesce(dt_e, :mmgg) >= :mmgg  and type_eqp = ' +
        '11 group by id) as eq2'
      '  on (eq.id = eq2.id and eq2.dt = eq.dt_b)'
      ')as a on (bs.id_area = a.id)'
      'left join adv_address_tbl as adr on (adr.id = a.id_addres)'
      'where (bs.id_doc = :doc)'
      'order by area ;')
    RequestLive = False
    Left = 483
    Top = 196
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = 'doc'
        ParamType = ptInput
      end>
  end
  object dsBillSumm2kr_area_2013: TDataSource
    AutoEdit = False
    DataSet = ZQBillSumm2kr_area_2013
    Left = 534
    Top = 201
  end
  object ZQBillSumm2kr_point_2013: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs]
    LinkFields = 'id_area=id_area'
    LinkOptions = [loAlwaysResync]
    MasterSource = dsBillSumm2kr_area_2013
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select bs.id_area, bs.id_point, bs.demand, p.name_eqp'
      'from acd_pwr_limit_pnt_tbl as bs'
      'join'
      '(select eq.id, eq.name_eqp from eqm_equipment_h as eq'
      
        '  join (select id, max(dt_b) as dt from eqm_equipment_h  where d' +
        't_b <= :mmgg and coalesce(dt_e, :mmgg) >= :mmgg  and type_eqp = ' +
        '12 group by id) as eq2'
      '  on (eq.id = eq2.id and eq2.dt = eq.dt_b)'
      ')as p on (bs.id_point = p.id)'
      'where (bs.id_doc = :doc)'
      'order by bs.id_area,p.name_eqp;')
    RequestLive = False
    Left = 366
    Top = 152
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'mmgg'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end>
  end
  object ZQBillItog: TZPgSqlQuery
    CachedUpdates = False
    ShowRecordTypes = [ztModified, ztInserted, ztUnmodified]
    Options = [doHourGlass, doAutoFillDefs, doQuickOpen, doUseRowId]
    LinkOptions = [loAlwaysResync]
    Constraints = <>
    ExtraOptions = [poTextAsMemo, poOidAsBlob]
    Macros = <>
    MacroCheck = False
    Sql.Strings = (
      'select coalesce(s.e_val+e_valtax,0.00) as sal,'
      'coalesce(p.pay,0.00) as spay,coalesce(b.bill,0.00) as sbill,'
      'bl.value+bl.value_tax as billsumm'
      'from acm_bill_tbl bl '
      
        'left join acm_saldo_tbl s on s.id_client=bl.id_client and s.id_p' +
        'ref=bl.id_pref and s.mmgg=bl.mmgg -interval '#39'1 month'#39
      
        'left join (select b.id_client,b.id_pref,b.mmgg,sum(b.value+b.val' +
        'ue_tax) as bill from acm_bill_tbl b where b.id_doc<:doc'
      ' group by b.id_client,b.id_pref,b.mmgg ) b'
      
        '   on b.id_client=bl.id_client and b.id_pref=bl.id_pref and b.mm' +
        'gg=bl.mmgg'
      
        '  left join (select b.id_client,b.id_pref,b.mmgg,sum(b.value_pay' +
        ') as pay from acm_pay_tbl b where b.id_doc<:doc'
      ' group by b.id_client,b.id_pref,b.mmgg ) p'
      
        '   on p.id_client=bl.id_client and p.id_pref=bl.id_pref and p.mm' +
        'gg=bl.mmgg'
      '   where  bl.id_doc=:doc'
      ''
      ''
      ' '
      ''
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
    Left = 397
    Top = 192
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'doc'
        ParamType = ptUnknown
      end>
  end
end
