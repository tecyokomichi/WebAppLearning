object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 371
  Width = 364
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 224
    Top = 160
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 224
    Top = 40
  end
  object FDQuery1: TFDQuery
    CachedUpdates = True
    Connection = FDConnection1
    SchemaAdapter = FDSchemaAdapter1
    SQL.Strings = (
      'select * from stm')
    Left = 88
    Top = 96
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 224
    Top = 280
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 224
    Top = 224
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    Left = 224
    Top = 96
  end
  object FDQuery2: TFDQuery
    CachedUpdates = True
    Connection = FDConnection1
    SchemaAdapter = FDSchemaAdapter1
    SQL.Strings = (
      'select * from stm')
    Left = 88
    Top = 152
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=localhost:C:\JSESS\Data_IB\JSESS_IB.FDB'
      'User_Name=sysdba'
      'Password=masterkey'
      'DriverID=FB')
    Left = 88
    Top = 40
  end
  object FDSchemaAdapter1: TFDSchemaAdapter
    Left = 92
    Top = 216
  end
end
