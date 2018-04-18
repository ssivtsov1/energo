object Mv: TMv
  Left = 380
  Top = 229
  Width = 330
  Height = 384
  Caption = 'Перенос документа в другую группу'
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
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 106
    Height = 13
    Caption = 'Перенести документ'
  end
  object Label3: TLabel
    Left = 136
    Top = 48
    Width = 43
    Height = 13
    Caption = 'В группу'
  end
  object MoveBut: TButton
    Left = 224
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Перенести'
    TabOrder = 0
    OnClick = MoveButClick
  end
  object Button2: TButton
    Left = 24
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Отменить'
    TabOrder = 1
    OnClick = Button2Click
  end
  object GroupTree: TTreeView
    Left = 8
    Top = 72
    Width = 305
    Height = 249
    Images = Module2DB.Images4grp
    Indent = 19
    TabOrder = 2
    OnChanging = GroupTreeChanging
  end
  object Doc_name: TEdit
    Left = 128
    Top = 8
    Width = 185
    Height = 21
    Enabled = False
    TabOrder = 3
  end
end
