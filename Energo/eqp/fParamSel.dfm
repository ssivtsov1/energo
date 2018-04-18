object fSelParam: TfSelParam
  Left = 196
  Top = 159
  Width = 288
  Height = 375
  Caption = 'fSelParam'
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 280
    Height = 348
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel4Ins: TPanel
      Left = 10
      Top = 370
      Width = 391
      Height = 455
      TabOrder = 0
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
      end
      object RadioButton1: TRadioButton
        Left = 24
        Top = 224
        Width = 137
        Height = 16
        Caption = 'Вставить перед всеми'
        TabOrder = 2
      end
      object RadioButton2: TRadioButton
        Left = 246
        Top = 224
        Width = 73
        Height = 16
        Caption = 'Выбрать'
        TabOrder = 3
      end
      object NextPar: TListView
        Left = 15
        Top = 241
        Width = 340
        Height = 184
        Columns = <>
        TabOrder = 4
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
    object Tree: TTreeView
      Left = 1
      Top = 1
      Width = 278
      Height = 346
      Align = alClient
      Indent = 19
      TabOrder = 1
      OnChanging = TreeChanging
    end
  end
end
