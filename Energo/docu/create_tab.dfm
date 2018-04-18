object CreateTab: TCreateTab
  Left = 308
  Top = 160
  Width = 375
  Height = 486
  Caption = 'Создание таблицы'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 367
    Height = 137
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 28
      Top = 49
      Width = 92
      Height = 13
      Caption = 'Количество рядов'
    end
    object Label2: TLabel
      Left = 17
      Top = 81
      Width = 104
      Height = 13
      Caption = 'Количество колонок'
    end
    object SpeedButton1: TSpeedButton
      Left = 257
      Top = 41
      Width = 90
      Height = 54
      Caption = 'Создать'
      Flat = True
      OnClick = SpeedButton1Click
    end
    object JoinBut: TSpeedButton
      Left = 17
      Top = 106
      Width = 330
      Height = 25
      Caption = 'Обьединить ячейки'
      Flat = True
      Visible = False
      OnClick = JoinButClick
    end
    object Label3: TLabel
      Left = 3
      Top = 21
      Width = 122
      Height = 13
      Caption = 'Наименование таблицы'
    end
    object Rows: TEdit
      Left = 129
      Top = 41
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Cols: TEdit
      Left = 129
      Top = 73
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object TableName: TEdit
      Left = 128
      Top = 15
      Width = 219
      Height = 21
      TabOrder = 2
    end
  end
  object Parent: TPanel
    Left = 0
    Top = 137
    Width = 367
    Height = 281
    Align = alClient
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 0
    Top = 418
    Width = 367
    Height = 41
    Align = alBottom
    TabOrder = 2
    object SpeedButton2: TSpeedButton
      Left = 80
      Top = 8
      Width = 217
      Height = 25
      Caption = 'Сохранить таблицу'
      Flat = True
      OnClick = SpeedButton2Click
    end
  end
end
