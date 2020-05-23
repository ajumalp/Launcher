object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 143
  Width = 223
  object clntDSetSTDBMain: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'dsProSTDBMain'
    OnReconcileError = clntDSetSTDBMainReconcileError
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
end
