object SaveDoc: TSaveDoc
  Left = 331
  Top = 137
  Width = 328
  Height = 511
  Caption = 'Сохранение документа'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 46
    Top = 184
    Width = 170
    Height = 13
    Caption = 'Выберите группу документов для'
  end
  object SpeedButton1: TSpeedButton
    Left = 208
    Top = 456
    Width = 105
    Height = 25
    Caption = 'Сохранить'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 8
    Top = 456
    Width = 105
    Height = 25
    Caption = 'Отменить'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object Label3: TLabel
    Left = 221
    Top = 184
    Width = 26
    Height = 13
    Caption = 'Label'
  end
  object Label10: TLabel
    Left = 121
    Top = 325
    Width = 77
    Height = 13
    Caption = 'Выбор клиента'
  end
  object GroupTree: TTreeView
    Left = 8
    Top = 203
    Width = 305
    Height = 118
    Indent = 19
    TabOrder = 0
    OnChanging = GroupTreeChanging
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 320
    Height = 57
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 4
      Top = 14
      Width = 133
      Height = 13
      Caption = 'Наименование документа'
    end
    object Label6: TLabel
      Left = 43
      Top = 38
      Width = 93
      Height = 13
      Caption = 'Дата регистрации'
    end
    object Edit: TEdit
      Left = 144
      Top = 7
      Width = 169
      Height = 21
      TabOrder = 0
    end
    object MaskEdit2: TMaskEdit
      Left = 144
      Top = 31
      Width = 65
      Height = 21
      EditMask = '!99/99/00;1;_'
      MaxLength = 8
      TabOrder = 1
      Text = '  .  .  '
    end
  end
  object Panel_tmp: TPanel
    Left = 0
    Top = 57
    Width = 320
    Height = 72
    Align = alTop
    TabOrder = 2
    object Label4: TLabel
      Left = 60
      Top = 16
      Width = 76
      Height = 13
      Caption = 'Вид документа'
    end
    object Label9: TLabel
      Left = 85
      Top = 43
      Width = 50
      Height = 13
      Caption = 'Описание'
    end
    object ComboBox2: TComboBox
      Left = 144
      Top = 8
      Width = 171
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBox2Change
    end
    object Memo1: TMemo
      Left = 144
      Top = 32
      Width = 170
      Height = 33
      TabOrder = 1
    end
  end
  object Panel_doc: TPanel
    Left = 0
    Top = 129
    Width = 320
    Height = 84
    Align = alTop
    TabOrder = 3
    object Label5: TLabel
      Left = 11
      Top = 15
      Width = 126
      Height = 13
      Caption = 'Регистрационный номер'
    end
    object Label7: TLabel
      Left = 50
      Top = 38
      Width = 87
      Height = 13
      Caption = 'Вид отправления'
    end
    object Label8: TLabel
      Left = 15
      Top = 61
      Width = 121
      Height = 13
      Caption = 'Направление движения'
    end
    object Edit1: TEdit
      Left = 144
      Top = 9
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object ComboBox1: TComboBox
      Left = 144
      Top = 32
      Width = 170
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      OnChange = ComboBox1Change
    end
    object ComboBox3: TComboBox
      Left = 144
      Top = 55
      Width = 170
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      OnChange = ComboBox3Change
    end
  end
  object Cli: TTreeView
    Left = 8
    Top = 339
    Width = 305
    Height = 113
    Indent = 19
    TabOrder = 4
    OnChange = CliChange
  end
end
