unit Datas;

interface

uses
  System.SysUtils, System.Classes, UniProvider, SQLServerUniProvider, Data.DB,
  MemDS, DBAccess, Uni;

type
  TDataModule1 = class(TDataModule)
    Conexion: TUniConnection;
    Consulta: TUniQuery;
    SQLServerUniProvider1: TSQLServerUniProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{
Conexion, objeto que contiene los parametros de conexion a la base de datos.
Parametros de conexion:
1- Provider: Driver para conectarse a un Motor de base de datos especifico, en este caso sql server.

2- Server: Contiene la ip o nombre del host donde esta ubicada la base de datos.

3- Port: El puerto donde esta escuchando la base de datos.

4- Username: Usuario de la base de datos.

5- Password: Password del usuario de la base de datos.

6- Database: Nombre de la  base de datos.

7- LoginPrompt no debe estar activado, para evitar un mensaje de dialogo, solicitando las credenciales para conectarse a la base de datos cada vez que
Inicie la aplicacion.


Consulta: Es el objeto por medio del cual se realizan todas las consultas a la base de datos, utilizando como conductor, la conexion que almacena el
objeto Conexion.

SQLServerUniProvider1: Es el driver que utiliza el objeto Conexion para conectarse a la base de datos.
}

end.
