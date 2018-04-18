object ClientPar: TClientPar
  Left = 165
  Top = 124
  Width = 671
  Height = 475
  Caption = 'ClientPar'
  Color = clBtnFace
  DefaultMonitor = dmDesktop
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 663
    Height = 448
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 161
      Top = 31
      Width = 3
      Height = 416
      Cursor = crHSplit
    end
    object Tree: TTreeView
      Left = 1
      Top = 31
      Width = 160
      Height = 416
      Align = alLeft
      Indent = 19
      TabOrder = 0
      OnChange = TreeChange
    end
    object Panel2: TPanel
      Left = 164
      Top = 31
      Width = 498
      Height = 416
      Align = alClient
      BevelOuter = bvLowered
      Caption = 'Параметры отсутствуют'
      TabOrder = 1
      object Panel3: TPanel
        Left = 1
        Top = 1
        Width = 496
        Height = 41
        Align = alTop
        TabOrder = 0
        object AddBut: TSpeedButton
          Left = 18
          Top = 8
          Width = 81
          Height = 23
          Caption = 'Добавить'
          Flat = True
          OnClick = AddButClick
        end
        object InsBut: TSpeedButton
          Left = 113
          Top = 8
          Width = 81
          Height = 23
          Caption = 'Вставить'
          Flat = True
          OnClick = InsButClick
        end
        object DelBut: TSpeedButton
          Left = 209
          Top = 8
          Width = 81
          Height = 23
          Caption = 'Удалить'
          Flat = True
          OnClick = DelButClick
        end
      end
      object Panel4Add: TPanel
        Left = 19
        Top = 49
        Width = 462
        Height = 328
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 8
          Width = 204
          Height = 13
          Caption = 'Выберите тип добавляемого параметра'
        end
        object Label2: TLabel
          Left = 16
          Top = 120
          Width = 226
          Height = 13
          Caption = 'Задайте значение добавляемого параметра'
        end
        object SpeedButton4: TSpeedButton
          Left = 191
          Top = 308
          Width = 89
          Height = 22
          Caption = 'Принять'
          Flat = True
          OnClick = SpeedButton4Click
        end
        object SpeedButton5: TSpeedButton
          Left = 10
          Top = 308
          Width = 89
          Height = 22
          Caption = 'Отменить'
          Flat = True
          OnClick = SpeedButton5Click
        end
        object Label7: TLabel
          Left = 16
          Top = 48
          Width = 134
          Height = 13
          Caption = 'Наименование параметра'
        end
        object Label10: TLabel
          Left = 16
          Top = 85
          Width = 97
          Height = 13
          Caption = 'Размер параметра'
        end
        object ComboBox1: TComboBox
          Left = 16
          Top = 24
          Width = 145
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'ComboBox1'
        end
        object Memo1: TMemo
          Left = 15
          Top = 136
          Width = 273
          Height = 89
          Lines.Strings = (
            'Memo1')
          TabOrder = 1
          OnChange = Memo1Change
        end
        object Edit1: TEdit
          Left = 16
          Top = 64
          Width = 273
          Height = 21
          TabOrder = 2
          Text = 'Edit1'
        end
        object Edit4: TEdit
          Left = 16
          Top = 101
          Width = 49
          Height = 21
          TabOrder = 3
          Text = '0'
          OnChange = Edit4Change
        end
        object UpDown2: TUpDown
          Left = 65
          Top = 101
          Width = 15
          Height = 21
          Associate = Edit4
          Min = 0
          Max = 255
          Position = 0
          TabOrder = 4
          Wrap = False
        end
      end
      object Panel4Prop: TPanel
        Left = 113
        Top = 138
        Width = 240
        Height = 135
        TabOrder = 3
        object Label5: TLabel
          Left = 8
          Top = 8
          Width = 77
          Height = 13
          Caption = 'Тип параметра'
        end
        object SpeedButton8: TSpeedButton
          Left = 160
          Top = 24
          Width = 81
          Height = 21
          Caption = 'Изменить'
          Flat = True
          OnClick = SpeedButton8Click
        end
        object Label6: TLabel
          Left = 8
          Top = 53
          Width = 106
          Height = 13
          Caption = 'Значение параметра'
        end
        object SpeedButton9: TSpeedButton
          Left = 136
          Top = 176
          Width = 81
          Height = 21
          Caption = 'Изменить'
          Flat = True
          OnClick = SpeedButton9Click
        end
        object ComboBox3: TComboBox
          Left = 8
          Top = 24
          Width = 145
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'ComboBox3'
        end
        object Memo3: TMemo
          Left = 8
          Top = 72
          Width = 337
          Height = 97
          Lines.Strings = (
            'Memo3')
          TabOrder = 1
          OnChange = Memo3Change
        end
      end
      object Panel4Ins: TPanel
        Left = 10
        Top = 370
        Width = 391
        Height = 455
        TabOrder = 2
        object Label3: TLabel
          Left = 16
          Top = 3
          Width = 204
          Height = 13
          Caption = 'Выберите тип добавляемого параметра'
        end
        object Label4: TLabel
          Left = 16
          Top = 118
          Width = 226
          Height = 13
          Caption = 'Задайте значение добавляемого параметра'
        end
        object SpeedButton6: TSpeedButton
          Left = 15
          Top = 433
          Width = 89
          Height = 21
          Caption = 'Отменить'
          Flat = True
        end
        object SpeedButton7: TSpeedButton
          Left = 266
          Top = 434
          Width = 89
          Height = 21
          Caption = 'Принять'
          Flat = True
          OnClick = SpeedButton7Click
        end
        object Label8: TLabel
          Left = 16
          Top = 40
          Width = 134
          Height = 13
          Caption = 'Наименование параметра'
        end
        object Label9: TLabel
          Left = 16
          Top = 80
          Width = 97
          Height = 13
          Caption = 'Размер параметра'
        end
        object ComboBox2: TComboBox
          Left = 16
          Top = 19
          Width = 145
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          Text = 'ComboBox1'
        end
        object Memo2: TMemo
          Left = 15
          Top = 134
          Width = 340
          Height = 88
          Lines.Strings = (
            'Memo1')
          MaxLength = 1
          TabOrder = 1
          OnChange = Memo2Change
        end
        object RadioButton1: TRadioButton
          Left = 24
          Top = 224
          Width = 137
          Height = 16
          Caption = 'Вставить перед всеми'
          TabOrder = 2
          OnClick = RadioButton1Click
        end
        object RadioButton2: TRadioButton
          Left = 246
          Top = 224
          Width = 73
          Height = 16
          Caption = 'Выбрать'
          TabOrder = 3
          OnClick = RadioButton2Click
        end
        object NextPar: TListView
          Left = 15
          Top = 241
          Width = 340
          Height = 184
          Columns = <>
          TabOrder = 4
          OnChange = NextParChange
        end
        object Edit2: TEdit
          Left = 16
          Top = 56
          Width = 273
          Height = 21
          TabOrder = 5
          Text = 'Edit1'
        end
        object Edit3: TEdit
          Left = 16
          Top = 96
          Width = 49
          Height = 21
          TabOrder = 6
          Text = '0'
          OnChange = Edit3Change
        end
        object UpDown1: TUpDown
          Left = 65
          Top = 96
          Width = 15
          Height = 21
          Associate = Edit3
          Min = 0
          Max = 255
          Position = 0
          TabOrder = 7
          Wrap = False
        end
      end
    end
    object ControlBar1: TControlBar
      Left = 1
      Top = 1
      Width = 661
      Height = 30
      Align = alTop
      AutoSize = True
      TabOrder = 2
      object SpeedButton1: TSpeedButton
        Left = 630
        Top = 2
        Width = 23
        Height = 22
        Caption = '+'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -20
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButton1Click
      end
      object Direction: TCheckBox
        Left = 11
        Top = 2
        Width = 204
        Height = 22
        Caption = 'Добавлять подчиненные элементы'
        TabOrder = 0
      end
      object Simple: TCheckBox
        Left = 369
        Top = 2
        Width = 118
        Height = 22
        Caption = 'Простой параметр'
        TabOrder = 1
      end
      object DataCheck: TCheckBox
        Left = 228
        Top = 2
        Width = 128
        Height = 22
        Caption = 'Данные на карточке'
        TabOrder = 2
      end
      object CheckBox1: TCheckBox
        Left = 500
        Top = 2
        Width = 117
        Height = 22
        Caption = 'Данные в имени'
        TabOrder = 3
      end
    end
  end
end
