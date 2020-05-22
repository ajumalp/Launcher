object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 195
  Width = 223
  object clntDSetSTDBMain: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dsProSTDBMain'
    Left = 144
    Top = 72
  end
  object dsProSTDBMain: TDataSetProvider
    DataSet = qrySTDBMain
    Left = 40
    Top = 72
  end
  object SQLCnnMain: TADOConnection
    ConnectionString = 
      'DRIVER=SQLite3 ODBC Driver;Database=E:\Other Files\Ajmal\Project' +
      's\GitHub\Launcher\trunk\Win32\Debug\launcher.db3;LongNames=0;Tim' +
      'eout=1000;NoTXN=0;SyncPragma=NORMAL;StepAPI=0;'
    KeepConnection = False
    Left = 40
    Top = 16
  end
  object qrySTDBMain: TADOQuery
    Connection = SQLCnnMain
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM STDBMAIN ORDER BY PARENTID, OID')
    Left = 144
    Top = 16
  end
  object qryGeneral: TADOQuery
    Connection = SQLCnnMain
    Parameters = <>
    Left = 40
    Top = 128
  end
end
