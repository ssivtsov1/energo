object InsForm: TInsForm
  Left = 412
  Top = 255
  Width = 304
  Height = 362
  Caption = 'Вставка элемента в документ'
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
  object Label1: TLabel
    Left = 69
    Top = 24
    Width = 161
    Height = 13
    Caption = 'Выберите элемент для вставки'
  end
  object SpeedButton1: TSpeedButton
    Left = 7
    Top = 304
    Width = 137
    Height = 25
    Caption = 'Отмена'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 153
    Top = 304
    Width = 137
    Height = 25
    Caption = 'Вставить'
    Flat = True
    OnClick = SpeedButton2Click
  end
  object List: TListView
    Left = 8
    Top = 40
    Width = 281
    Height = 81
    Columns = <>
    LargeImages = Module2DB.Images4doc_s
    SmallImages = Module2DB.Images4doc_s
    TabOrder = 0
    ViewStyle = vsList
    OnChanging = ListChanging
  end
  object RadioButton1: TRadioButton
    Left = 16
    Top = 136
    Width = 113
    Height = 17
    Caption = 'Вставить первым'
    TabOrder = 1
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 168
    Top = 136
    Width = 113
    Height = 17
    Caption = 'Вставить после'
    Checked = True
    TabOrder = 2
    TabStop = True
    OnClick = RadioButton2Click
  end
  object ListElem: TListView
    Left = 7
    Top = 160
    Width = 281
    Height = 137
    Columns = <>
    LargeImages = Module2DB.Images4grp
    SmallImages = Module2DB.Images4grp
    TabOrder = 3
    ViewStyle = vsList
    OnChanging = ListElemChanging
  end
  object Edit1: TEdit
    Left = 7
    Top = 2
    Width = 282
    Height = 21
    TabOrder = 4
  end
end
