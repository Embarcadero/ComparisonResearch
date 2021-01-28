object DM: TDM
  OldCreateOrder = False
  Height = 527
  Width = 444
  object FDConnection: TFDConnection
    Params.Strings = (
      'User_Name=postgres'
      'Password=postgres'
      'DriverID=PG')
    Left = 32
    Top = 32
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    Left = 128
    Top = 32
  end
  object FDScript: TFDScript
    SQLScripts = <>
    Connection = FDConnection
    ScriptOptions.FileEncoding = ecUTF8
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 24
    Top = 104
  end
  object ChannelsQuery: TFDQuery
    Connection = FDConnection
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select * from channels order by id')
    Left = 24
    Top = 168
  end
  object ArticlesQuery: TFDQuery
    Connection = FDConnection
    FetchOptions.AssignedValues = [evRecordCountMode]
    FetchOptions.RecordCountMode = cmTotal
    SQL.Strings = (
      'select * from articles order by id')
    Left = 128
    Top = 168
  end
end
