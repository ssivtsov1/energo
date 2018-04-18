object fLog: TfLog
  Left = 190
  Top = 135
  Width = 503
  Height = 277
  Caption = 'SQL лог'
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
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 495
    Height = 250
    Align = alClient
    TabOrder = 0
  end
  object ZMonitor1: TZMonitor
    OnMonitorEvent = ZMonitor1MonitorEvent
    Left = 24
    Top = 16
  end
end
