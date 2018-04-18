object CreateForm: TCreateForm
  Left = 358
  Top = 192
  Width = 305
  Height = 251
  BorderIcons = []
  Caption = 'Создание элемента документа'
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
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 192
    Top = 193
    Width = 97
    Height = 25
    Caption = 'Создать'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 8
    Top = 193
    Width = 97
    Height = 25
    Caption = 'Отменить'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 45
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 48
      Top = 3
      Width = 198
      Height = 13
      Caption = 'Выберите тип создаваемого элемента'
    end
    object TypeList: TComboBox
      Left = 76
      Top = 19
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = TypeListChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 45
    Width = 297
    Height = 78
    Align = alTop
    TabOrder = 1
    object Label2: TLabel
      Left = 82
      Top = 2
      Width = 128
      Height = 13
      Caption = 'Наименование элемента'
    end
    object Label4: TLabel
      Left = 87
      Top = 39
      Width = 122
      Height = 13
      Caption = 'Тип хранимых значений'
    end
    object Edit1: TEdit
      Left = 74
      Top = 17
      Width = 145
      Height = 21
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 74
      Top = 53
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox1Change
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 123
    Width = 297
    Height = 31
    Align = alTop
    TabOrder = 2
    object Label3: TLabel
      Left = 20
      Top = 8
      Width = 114
      Height = 13
      Caption = 'Длина поля для ввода'
    end
    object Edit2: TEdit
      Left = 139
      Top = 5
      Width = 79
      Height = 21
      TabOrder = 0
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 154
    Width = 297
    Height = 41
    Align = alTop
    Caption = 'Panel4'
    TabOrder = 3
    object ComboBox2: TComboBox
      Left = 75
      Top = 9
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'ComboBox2'
      OnChange = ComboBox2Change
    end
  end
end
