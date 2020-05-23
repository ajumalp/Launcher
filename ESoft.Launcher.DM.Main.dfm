object dmMain: TdmMain
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 137
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
  object SQLCnnMain: TSQLConnection
    DriverName = 'Sqlite'
    KeepConnection = False
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver250.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver250.bpl'
      'FailIfMissing=True'
      
        'Database=E:\Other Files\Ajmal\Projects\GitHub\Launcher\trunk\Win' +
        '32\Debug\Build\launcher.db3')
    Left = 40
    Top = 16
  end
  object qrySTDBMain: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'SELECT * FROM STDBMAIN ORDER BY PARENTID, OID')
    SQLConnection = SQLCnnMain
    Left = 144
    Top = 16
  end
end
