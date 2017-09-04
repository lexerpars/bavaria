program Taller;

uses
  System.StartUpCopy,
  FMX.Forms,
  Principal in 'Principal.pas' {Form2},
  Datas in 'Datas.pas' {DataModule1: TDataModule},
  Logs in 'Logs.pas' {Form1},
  ControlActividades in 'ControlActividades.pas' {Form3},
  DetalleControlActividades in 'DetalleControlActividades.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
