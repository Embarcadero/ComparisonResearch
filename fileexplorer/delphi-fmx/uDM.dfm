object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object ActionList1: TActionList
    Left = 16
    Top = 6
    object FileExit1: TFileExit
      Category = 'File'
      Hint = 'Quit|Quits the application'
    end
  end
end
