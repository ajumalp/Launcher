object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 137
  Width = 223
  object clntDSetRTDBMain: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dsProRTDBMain'
    Left = 144
    Top = 72
  end
  object dsProRTDBMain: TDataSetProvider
    DataSet = qryRTDBMain
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
  object qryRTDBMain: TADOQuery
    Connection = SQLCnnMain
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM RTDBMAIN ORDER BY PARENTID, OID')
    Left = 144
    Top = 16
  end
end
