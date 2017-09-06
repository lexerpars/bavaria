object DataModule1: TDataModule1
  OldCreateOrder = False
  Height = 260
  Width = 316
  object Conexion: TUniConnection
    ProviderName = 'SQL Server'
    Port = 1433
    Database = 'Bavaria_pruebas'
    Username = 'Programador'
    Server = '192.1.2.34'
    LoginPrompt = False
    Left = 24
    Top = 16
    EncryptedPassword = 'BEFF8CFF9BFF99FFCEFFCDFFCCFF'
  end
  object Consulta: TUniQuery
    Connection = Conexion
    Left = 32
    Top = 104
  end
  object SQLServerUniProvider1: TSQLServerUniProvider
    Left = 40
    Top = 200
  end
end
