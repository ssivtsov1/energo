object fPeriodSelect: TfPeriodSelect
  Left = 157
  Top = 225
  Width = 545
  Height = 198
  Caption = 'Выбор перода'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 130
    Top = 124
    Width = 10
    Height = 13
    Caption = 'С:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 123
    Top = 151
    Width = 17
    Height = 13
    Caption = 'По:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object rbDay: TRadioButton
    Left = 16
    Top = 96
    Width = 100
    Height = 17
    Caption = '&День'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = cbQuarterChange
  end
  object rbQuarter: TRadioButton
    Left = 16
    Top = 42
    Width = 100
    Height = 17
    Caption = '&Квартал'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = cbQuarterChange
  end
  object rbMonth: TRadioButton
    Left = 16
    Top = 69
    Width = 100
    Height = 17
    Caption = '&Месяц'
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    TabStop = True
    OnClick = cbQuarterChange
  end
  object InfoPanel: TPanel
    Left = 8
    Top = 8
    Width = 521
    Height = 19
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'Выбран период с 01.01.2002 по 31.12.2002'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object cbQuarter: TComboBox
    Left = 144
    Top = 40
    Width = 97
    Height = 21
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 4
    OnChange = cbQuarterChange
    Items.Strings = (
      '1 Квартал'
      '2 Квартал'
      '3 Квартал'
      '4 Квартал')
  end
  object cbWithBeginYear: TCheckBox
    Left = 304
    Top = 42
    Width = 129
    Height = 17
    Caption = 'С начала года'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    OnClick = cbQuarterChange
  end
  object cbWithBeginQuarter: TCheckBox
    Left = 304
    Top = 69
    Width = 129
    Height = 17
    Caption = 'С начала квартала'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = cbQuarterChange
  end
  object cbWithBeginMonth: TCheckBox
    Left = 304
    Top = 96
    Width = 129
    Height = 17
    Caption = 'С начала месяца'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    OnClick = cbQuarterChange
  end
  object cbMonth: TComboBox
    Left = 144
    Top = 67
    Width = 97
    Height = 21
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 8
    OnChange = cbQuarterChange
    Items.Strings = (
      'Январь'
      'Февраль'
      'Март'
      'Апрель'
      'Май'
      'Июнь'
      'Июль'
      'Август'
      'Сентябрь'
      'Октябрь'
      'Ноябрь'
      'Декабрь')
  end
  object DateEdit: TDateTimePicker
    Left = 144
    Top = 94
    Width = 155
    Height = 21
    CalAlignment = dtaLeft
    Date = 38617.4841568982
    Time = 38617.4841568982
    DateFormat = dfShort
    DateMode = dmComboBox
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = dtkDate
    ParseInput = False
    ParentFont = False
    TabOrder = 9
    OnChange = cbQuarterChange
  end
  object StDateEdit: TDateTimePicker
    Left = 144
    Top = 120
    Width = 155
    Height = 21
    CalAlignment = dtaLeft
    Date = 38617.4841568982
    Time = 38617.4841568982
    DateFormat = dfShort
    DateMode = dmComboBox
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = dtkDate
    ParseInput = False
    ParentFont = False
    TabOrder = 10
    OnChange = cbQuarterChange
  end
  object EdDateEdit: TDateTimePicker
    Left = 144
    Top = 147
    Width = 155
    Height = 21
    CalAlignment = dtaLeft
    Date = 38617.4841568982
    Time = 38617.4841568982
    DateFormat = dfShort
    DateMode = dmComboBox
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Kind = dtkDate
    ParseInput = False
    ParentFont = False
    TabOrder = 11
    OnChange = cbQuarterChange
  end
  object rbInterval: TRadioButton
    Left = 16
    Top = 122
    Width = 100
    Height = 17
    Caption = '&Интервал'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 12
    OnClick = cbQuarterChange
  end
  object Button1: TButton
    Left = 456
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 1
    ParentFont = False
    TabOrder = 13
  end
  object Button2: TButton
    Left = 456
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Отмена'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 2
    ParentFont = False
    TabOrder = 14
  end
  object Button3: TButton
    Left = 456
    Top = 104
    Width = 75
    Height = 25
    Caption = 'Без периода'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ModalResult = 10
    ParentFont = False
    TabOrder = 15
  end
  object edYear1: TMaskEdit
    Left = 244
    Top = 40
    Width = 49
    Height = 21
    EditMask = '0000;1;_'
    MaxLength = 4
    TabOrder = 16
    Text = '    '
    OnChange = cbQuarterChange
  end
  object edYear2: TMaskEdit
    Left = 244
    Top = 67
    Width = 49
    Height = 21
    EditMask = '0000;1;_'
    MaxLength = 4
    TabOrder = 17
    Text = '    '
    OnChange = cbQuarterChange
  end
end
