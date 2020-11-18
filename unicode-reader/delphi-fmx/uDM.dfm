object DM: TDM
  OldCreateOrder = False
  Height = 488
  Width = 437
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=postgres'
      'Server=127.0.0.1'
      'Password=postgres'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 33
    Top = 20
  end
  object ArticlesQuery: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from  articles  order by id')
    Left = 160
    Top = 84
  end
  object ChannelsQuery: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'select * from  channels order by id')
    Left = 160
    Top = 20
  end
  object CreateScripts: TFDScript
    SQLScriptFileName = 'F:\Work\FMXResearch\Last\create.sql'
    SQLScripts = <
      item
        Name = 'SQL'
      end>
    Connection = FDConnection1
    Params = <>
    Macros = <>
    FetchOptions.AssignedValues = [evItems, evAutoClose, evAutoFetchAll]
    FetchOptions.AutoClose = False
    FetchOptions.Items = [fiBlobs, fiDetails]
    ResourceOptions.AssignedValues = [rvMacroCreate, rvMacroExpand, rvDirectExecute, rvPersistent]
    ResourceOptions.MacroCreate = False
    ResourceOptions.DirectExecute = True
    Left = 24
    Top = 164
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    Left = 33
    Top = 68
  end
end
