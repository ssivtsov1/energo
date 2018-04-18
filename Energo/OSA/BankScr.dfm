object FBankScr: TFBankScr
  Left = 272
  Top = 288
  Width = 810
  Height = 592
  Caption = 'Платежные документы'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Times New Roman'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 17
  object Label15: TLabel
    Left = 588
    Top = 268
    Width = 88
    Height = 17
    Caption = 'Вид платежа :'
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 794
    Height = 367
    ActivePage = TabSheet2
    Align = alClient
    MultiLine = True
    ParentShowHint = False
    ShowHint = True
    TabHeight = 20
    TabOrder = 1
    TabWidth = 100
    object TabSheet2: TTabSheet
      Caption = 'Платежки'
      ImageIndex = 1
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 786
        Height = 337
        Align = alClient
        TabOrder = 0
        object GroupBox1: TGroupBox
          Left = 3
          Top = 40
          Width = 792
          Height = 287
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 0
          object Label2: TLabel
            Left = 10
            Top = 60
            Width = 92
            Height = 17
            Caption = 'Лицевой счет :'
          end
          object LabNClient: TLabel
            Left = 24
            Top = 86
            Width = 561
            Height = 25
            AutoSize = False
            Caption = 'LabNClient'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object Label4: TLabel
            Left = 6
            Top = 162
            Width = 82
            Height = 17
            Alignment = taCenter
            Caption = 'МФО банка :'
            Layout = tlCenter
          end
          object LabNBank: TLabel
            Left = 10
            Top = 218
            Width = 743
            Height = 25
            AutoSize = False
            Caption = 'LabNBank'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object SBtnBank: TSpeedButton
            Left = 206
            Top = 166
            Width = 23
            Height = 22
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777000777777
              7777770555000000000777050055555555077705F000877FF5077055F07F8000
              F507055FF07FFFB8F50705FFF07FBFF8F50705FFF07FFFB8F50705FFF07FBFF8
              F50705FFF07FFFB8F50705FFF07FBFF8F50705FF788FFFB8007705FF87788FF8
              777705F787777888777778787777777777777787777777777777}
            OnClick = SBtnBankClick
          end
          object Label6: TLabel
            Left = 254
            Top = 168
            Width = 75
            Height = 17
            Caption = 'Расч. счет :'
            Layout = tlCenter
          end
          object SBtnAccount: TSpeedButton
            Left = 556
            Top = 168
            Width = 23
            Height = 22
            Hint = 'Справочник банков'
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777000777777
              7777770555000000000777050055555555077705F000877FF5077055F07F8000
              F507055FF07FFFB8F50705FFF07FBFF8F50705FFF07FFFB8F50705FFF07FBFF8
              F50705FFF07FFFB8F50705FFF07FBFF8F50705FF788FFFB8007705FF87788FF8
              777705F787777888777778787777777777777787777777777777}
            ParentShowHint = False
            ShowHint = True
          end
          object Label1: TLabel
            Left = 12
            Top = 18
            Width = 80
            Height = 17
            Caption = '№ платежки:'
          end
          object Label7: TLabel
            Left = 248
            Top = 16
            Width = 34
            Height = 17
            Caption = 'Дата:'
          end
          object Label8: TLabel
            Left = 148
            Top = 212
            Width = 90
            Height = 17
            Caption = 'Дата платежа:'
          end
          object Label9: TLabel
            Left = 10
            Top = 118
            Width = 55
            Height = 17
            Caption = 'Сумма  :'
          end
          object Label10: TLabel
            Left = 156
            Top = 118
            Width = 78
            Height = 17
            Caption = 'В т.ч. НДС :'
          end
          object Label12: TLabel
            Left = 364
            Top = 212
            Width = 88
            Height = 17
            Caption = 'Вид платежа :'
          end
          object Label13: TLabel
            Left = 490
            Top = 114
            Width = 139
            Height = 25
            AutoSize = False
            Caption = 'Период погашения:'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object Label3: TLabel
            Left = 322
            Top = 120
            Width = 64
            Height = 17
            Caption = 'Без НДС :'
          end
          object SBtnClient: TSpeedButton
            Left = 208
            Top = 58
            Width = 23
            Height = 22
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777000777777
              7777770555000000000777050055555555077705F000877FF5077055F07F8000
              F507055FF07FFFB8F50705FFF07FBFF8F50705FFF07FFFB8F50705FFF07FBFF8
              F50705FFF07FFFB8F50705FFF07FBFF8F50705FF788FFFB8007705FF87788FF8
              777705F787777888777778787777777777777787777777777777}
            OnClick = SBtnClientClick
          end
          object Label5: TLabel
            Left = 12
            Top = 250
            Width = 73
            Height = 15
            Caption = 'Комментарий :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object SpeedButton1: TSpeedButton
            Left = 696
            Top = 116
            Width = 23
            Height = 22
            Hint = 'Справочник банков'
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777000777777
              7777770555000000000777050055555555077705F000877FF5077055F07F8000
              F507055FF07FFFB8F50705FFF07FBFF8F50705FFF07FFFB8F50705FFF07FBFF8
              F50705FFF07FFFB8F50705FFF07FBFF8F50705FF788FFFB8007705FF87788FF8
              777705F787777888777778787777777777777787777777777777}
            ParentShowHint = False
            ShowHint = True
          end
          object Label11: TLabel
            Left = 284
            Top = 58
            Width = 50
            Height = 17
            Caption = 'Дебет  :'
          end
          object Label14: TLabel
            Left = 470
            Top = 58
            Width = 38
            Height = 17
            Caption = 'НДС :'
          end
          object LabRest: TLabel
            Left = 358
            Top = 56
            Width = 91
            Height = 25
            Alignment = taCenter
            AutoSize = False
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -19
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object LabRestTax: TLabel
            Left = 544
            Top = 58
            Width = 89
            Height = 25
            Alignment = taCenter
            AutoSize = False
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -19
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object LabEdrpou: TLabel
            Left = 688
            Top = 86
            Width = 97
            Height = 25
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object Label16: TLabel
            Left = 592
            Top = 86
            Width = 65
            Height = 25
            AutoSize = False
            Caption = 'ЕДРПОУ'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -16
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
          end
          object EdCodeClient: TMaskEdit
            Left = 116
            Top = 54
            Width = 83
            Height = 25
            EditMask = '9999999;0; '
            MaxLength = 7
            TabOrder = 2
            OnExit = EdCodeClientChange
            OnKeyPress = EdIntKeyPress
          end
          object EdBank: TMaskEdit
            Left = 92
            Top = 164
            Width = 105
            Height = 25
            EditMask = '999999;0; '
            MaxLength = 6
            TabOrder = 8
            OnKeyPress = EdIntKeyPress
          end
          object EdAccount: TMaskEdit
            Left = 346
            Top = 168
            Width = 199
            Height = 25
            EditMask = '999999999999;0; '
            MaxLength = 12
            TabOrder = 9
            Text = '99999999999990'
            OnKeyPress = EdIntKeyPress
          end
          object EdRegNum: TEdit
            Left = 110
            Top = 16
            Width = 121
            Height = 25
            TabOrder = 0
            Text = 'EdRegNum'
          end
          object EdRegDate: TMaskEdit
            Left = 296
            Top = 16
            Width = 73
            Height = 25
            EditMask = '99\.99\.9999;1; '
            MaxLength = 10
            TabOrder = 1
            Text = '  .  .    '
          end
          object RadGrPay: TRadioGroup
            Left = 388
            Top = 12
            Width = 191
            Height = 33
            Hint = 'Приходная либо расходная платежка'
            Columns = 2
            ItemIndex = 1
            Items.Strings = (
              'Исходящие'
              'Входящие')
            TabOrder = 13
            TabStop = True
            OnExit = RadGrPayExit
          end
          object EdPayDate: TMaskEdit
            Left = 264
            Top = 206
            Width = 85
            Height = 25
            EditMask = '99\.99\.9999;1; '
            MaxLength = 10
            TabOrder = 10
            Text = '  .  .    '
          end
          object EdValuePay: TMaskEdit
            Left = 78
            Top = 112
            Width = 69
            Height = 25
            ParentShowHint = False
            ShowHint = False
            TabOrder = 3
            OnChange = EdValuePayChange
            OnExit = EdValuePayExit
            OnKeyPress = EdFloatKeyPress
          end
          object EdValueTax: TMaskEdit
            Left = 242
            Top = 114
            Width = 73
            Height = 25
            TabOrder = 4
            OnExit = EdValueTaxExit
            OnKeyPress = EdFloatKeyPress
          end
          object CBoxPay: TComboBox
            Left = 458
            Top = 208
            Width = 119
            Height = 25
            ItemHeight = 17
            TabOrder = 11
            Text = 'CBoxPay'
          end
          object EdValue: TMaskEdit
            Left = 392
            Top = 114
            Width = 95
            Height = 25
            Enabled = False
            TabOrder = 5
            OnKeyPress = EdFloatKeyPress
          end
          object EdComment: TEdit
            Left = 94
            Top = 248
            Width = 671
            Height = 23
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Times New Roman'
            Font.Style = []
            ParentFont = False
            TabOrder = 12
            Text = 'EdComment'
          end
          object EdBillPay: TMaskEdit
            Left = 622
            Top = 116
            Width = 71
            Height = 25
            EditMask = '99\.99\.9999;1; '
            MaxLength = 10
            TabOrder = 6
            Text = '  .  .    '
            OnExit = EdBillPayExit
          end
          object BtnSav: TBitBtn
            Left = 728
            Top = 118
            Width = 41
            Height = 25
            TabOrder = 7
            OnClick = BtnSavClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              777777770077777777777777A7077777777777777A70777777777777A7A70777
              777777777A7A707777777777A7A7A707777777777A7A7A7077777777A7A7A7A7
              777777777A7A7A7777777777A7A7A777777777777A7A777777777777A7A77777
              777777777A77777777777777A777777777777777777777777777}
          end
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Квитанции'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'Авизо'
      ImageIndex = 2
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 367
    Width = 794
    Height = 187
    Align = alBottom
    TabOrder = 0
    object DBGrBill: TDBGrid
      Left = 1
      Top = 1
      Width = 792
      Height = 185
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Times New Roman'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Times New Roman'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'mmgg'
          Title.Caption = 'Месяц'
          Width = 57
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Pref'
          Title.Caption = 'Вид енергии'
          Width = 38
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'reg_num'
          Title.Caption = 'Номер '
          Width = 63
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'reg_date'
          Title.Caption = 'Дата'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'mmgg_bill'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Title.Caption = 'Период'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Times New Roman'
          Title.Font.Style = [fsBold]
          Width = 71
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'demand_val'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlight
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Title.Caption = 'кВт/г'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Times New Roman'
          Title.Font.Style = [fsBold]
          Width = 56
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'value'
          Title.Caption = 'Начислено'
          Width = 63
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'value_tax'
          Title.Caption = 'НДС начис.'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'value_all'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Title.Caption = 'Всего начис.'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Times New Roman'
          Title.Font.Style = [fsBold]
          Width = 76
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'pay'
          Title.Caption = 'Оплачено'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'pay_tax'
          Title.Caption = 'НДС опл.'
          Width = 54
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'pay_all'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Title.Caption = 'Всего опл.'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Times New Roman'
          Title.Font.Style = [fsBold]
          Width = 69
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'rest'
          Title.Caption = 'Конечн.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'rest_tax'
          Title.Caption = 'НДС нач.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'rest_all'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Title.Caption = 'Всего кон.'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -13
          Title.Font.Name = 'Times New Roman'
          Title.Font.Style = [fsBold]
          Width = 69
          Visible = True
        end>
    end
  end
  object TabControl1: TTabControl
    Left = 6
    Top = 28
    Width = 789
    Height = 43
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    object TCBarClient: TCoolBar
      Left = 4
      Top = 6
      Width = 780
      Height = 33
      Align = alNone
      Anchors = [akLeft, akTop, akRight]
      Bands = <
        item
          BorderStyle = bsSingle
          Break = False
          Color = clScrollBar
          Control = ToolBar1
          FixedBackground = False
          HorizontalOnly = True
          ImageIndex = -1
          MinHeight = 22
          ParentColor = False
          Width = 776
        end>
      object ToolBar1: TToolBar
        Left = 9
        Top = 2
        Width = 246
        Height = 22
        Align = alNone
        AutoSize = True
        Caption = 'TBarClient'
        EdgeBorders = [ebLeft, ebTop, ebRight]
        EdgeInner = esNone
        EdgeOuter = esNone
        Flat = True
        Images = ImageClientBtn
        TabOrder = 0
        object TButtonNew: TToolButton
          Left = 0
          Top = 0
          Caption = 'TButtonNew'
          ImageIndex = 0
        end
        object TButtonDel: TToolButton
          Left = 23
          Top = 0
          Caption = 'TButtonDel'
          ImageIndex = 1
        end
        object ToolButton3: TToolButton
          Left = 46
          Top = 0
          Width = 8
          Caption = 'ToolButton3'
          ImageIndex = 2
          Style = tbsSeparator
        end
        object TBtnLast: TToolButton
          Left = 54
          Top = 0
          Caption = 'TBtnLast'
          ImageIndex = 8
        end
        object TBtnPrev: TToolButton
          Left = 77
          Top = 0
          Caption = 'TBtnPrev'
          ImageIndex = 3
        end
        object TBtnNext: TToolButton
          Left = 100
          Top = 0
          Caption = 'TBtnNext'
          ImageIndex = 4
        end
        object TBtnFirst: TToolButton
          Left = 123
          Top = 0
          Caption = 'TBtnFirst'
          ImageIndex = 2
        end
        object ToolButton8: TToolButton
          Left = 146
          Top = 0
          Width = 8
          ImageIndex = 9
          Style = tbsSeparator
        end
        object TBtnCansel: TToolButton
          Left = 154
          Top = 0
          Caption = 'TBtnCansel'
          ImageIndex = 5
        end
        object TBtnSave: TToolButton
          Left = 177
          Top = 0
          Caption = 'TBtnSave'
          ImageIndex = 6
        end
        object TBtnRefresh: TToolButton
          Left = 200
          Top = 0
          Caption = 'TBtnRefresh'
          ImageIndex = 7
        end
        object TBtnFind: TToolButton
          Left = 223
          Top = 0
          Caption = 'TBtnFind'
          ImageIndex = 9
        end
      end
    end
  end
  object CBoxType: TComboBox
    Left = 602
    Top = 88
    Width = 127
    Height = 25
    ItemHeight = 17
    TabOrder = 3
    Text = 'CBoxType'
  end
  object ImageClientBtn: TImageList
    Left = 329
    Top = 65534
    Bitmap = {
      494C01010B000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FF000000FF000000FF00000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF000000FF000000FF000000FF000000FF000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000FFFFFF0000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF000000FF00000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000840000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000084000000840000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      0000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF000084000000840000008400000084000000840000FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000084000000840000FFFFFF00FFFFFF000084
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000848400008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000840000FFFFFF00FFFFFF000084
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400000000000000000000000000000000000000000000000000000000000000
      000000848400008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF0000840000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF000000FF00000000000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF0000840000FFFFFF00FFFFFF0000840000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      00000000000000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF0000840000FFFFFF00FFFFFF000084000000840000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF000084000000840000008400000084000000840000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008484000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000084000000840000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF000000FF0000000000000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000840000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000FF00000000000000000000000000008484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400848484008484840000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000000000000000000000000000000000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF000000000000000000FFFFFF00FFFFFF00FFFF
      FF000000000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000FFFF00000000000000000000000000000000000084848400848484008484
      8400000000000000000084848400848484008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000000000000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFF0000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000FFFF0000000000000000000000000000000000000000FF000000FF000000
      FF000000FF000000FF000000FF000000000000FF000000FF000000FF000000FF
      000000FF000000FF000000FF000000FF00000000000000000000000000000000
      000000000000000000000000FF000000FF000000FF0000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF000000FF000000FF000000FF000000FF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000FFFF000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      00000000FF000000FF000000FF0000000000000000000000FF000000FF000000
      00000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000084848400848484008484
      8400000000008484840084848400848484008484840084848400848484008484
      84008484840084848400848484000000000000000000000000000000FF000000
      FF000000FF000000FF00000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      FF000000FF0000000000000000000000000000000000FFFFFF0000000000FFFF
      FF0000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF00000000000000000000000000FFFFFF0000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FC00FFFFFDFF0000F000FFFFFCFF0000
      C00083E0F87F0000000083E0F83F0000000083E0F00F000000008080F0010000
      00008000E007000000008100E1FF000000008100C1FF00000000C00181FF0000
      0001E08381FF00000003E08381FF00000007F1C781FF0000001FF1C701FF0000
      00FFF1C703FF000001FFFFFF03FF0000FFFF9FF8FFFFC001FFFF0FF0C001DFFD
      1FFF07E08031C005041F83C18031C005000FC1838031C005000FE0078001C005
      0007F00F8001C0050001F81F8001C0050000F81F8FF1C0050001F00F8FF1C005
      003FE0078FF1C005FC7FC1838FF1C005FFFF83C18FF1C001FFFF07E08FF5C003
      FFFF0FF08001C007FFFF1FF8FFFFC00FFFFFFFFFFC00FFFF0000CFF9F000FFFF
      000087FFC000FFF8000083F30000F8200000C3E70000F0008000E1C70000F000
      0000F08F0000E0000080F81F000080000000FC3F000000000180F81F00008000
      8000F08F0001FC000000C1C70003FE3F000083E30007FFFF000087F9001FFFFF
      0000FFFF007FFFFF0000FFFF01FFFFFF00000000000000000000000000000000
      000000000000}
  end
  object QuerBil: TQuery
    SQL.Strings = (
      'select * from acv_billpay')
    Left = 650
    Top = 347
  end
end
