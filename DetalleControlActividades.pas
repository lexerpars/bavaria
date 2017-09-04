unit DetalleControlActividades;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ScrollBox, FMX.Memo;

type
  TForm4 = class(TForm)
    ScaledLayout1: TScaledLayout;
    DescripcionExtra: TLabel;
    ToolBar1: TToolBar;
    Iniciar: TSpeedButton;
    Pendiente: TSpeedButton;
    Finalizar: TSpeedButton;
    Cerrar: TSpeedButton;
    Home: TSpeedButton;
    Memo1: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    Horas: TLabel;
    Label3: TLabel;
    Minutos: TLabel;
    Label5: TLabel;
    Segundos: TLabel;
    Label7: TLabel;
    Timer1: TTimer;
    procedure HomeClick(Sender: TObject);
    procedure IniciarClick(Sender: TObject);
    procedure PendienteClick(Sender: TObject);
    procedure FinalizarClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
  procedure controltiempo;
    { Public declarations }
  end;

var
  Form4: TForm4;
  hr,min,seg:integer;

implementation
Uses Principal,ControlActividades,Datas;
{$R *.fmx}

procedure TForm4.controltiempo;
begin
   seg:=Seg+1;

    if seg=60 then
    begin
         min:=Min+1;

         if (min>9) and  (min<=59)then
          begin
            Minutos.Text:=IntToStr(min);
          end;

          if min<=9 then
          begin
            Minutos.Text:='0'+IntToStr(min);;
          end;

          seg:=0;
          Segundos.Text:='00';

          if min=60 then
          begin
              hr:=hr+1;

              if (hr>9) and  (hr<=59)then
              begin
                 horas.Text:=IntToStr(hr);
              end;

              if hr<=9 then
              begin
                Horas.Text:='0'+IntToStr(hr);;
              end;

              min:=0;
              Minutos.Text:='00';
          end;
    end;




    if (seg>9) and  (seg<=59)then
    begin
      Segundos.Text := IntToStr(seg);
    end;

    if seg<=9 then
    begin

      Segundos.Text := '0'+IntToStr(seg);
    end;









end;
procedure TForm4.CerrarClick(Sender: TObject);
begin
  Application.Terminate;
  Exit;
end;

procedure TForm4.FinalizarClick(Sender: TObject);
begin

       Datas.DataModule1.Consulta.SQL.Clear;
       Datas.DataModule1.Consulta.SQL.Add('update actividad_taller set fecha_fin=getdate(),estatus=:estat where ID=:id');
       Datas.DataModule1.Consulta.ParamByName('estat').AsString:='FINALIZADO';
       Datas.DataModule1.Consulta.ParamByName('id').AsInteger:=Principal.mi_id;
       Datas.DataModule1.Consulta.ExecSQL;



       Datas.DataModule1.Consulta.SQL.Clear;
       Datas.DataModule1.Consulta.SQL.Add('select distinct orden from actividad_taller where estatus in (:E1,:E2) AND AGENTE=:AGENTE AND ORDEN=:ORDEN');
       Datas.DataModule1.Consulta.ParamByName('E1').AsString:='PENDIENTE';
       Datas.DataModule1.Consulta.ParamByName('E2').AsString:='NO INICIADA';
       Datas.DataModule1.Consulta.ParamByName('ORDEN').AsInteger:=Principal.ID_Orden;
       Datas.DataModule1.Consulta.ParamByName('AGENTE').AsString:=Principal.agente;
       Datas.DataModule1.Consulta.ExecSQL;

       if Datas.DataModule1.Consulta.RecordCount = 0 then
       begin
       Datas.DataModule1.Consulta.SQL.Clear;
       Datas.DataModule1.Consulta.SQL.Add('INSERT INTO TALLER_ORDEN (ORDEN,AGENTE) VALUES (:ORDEN,:AGENTE)');
       Datas.DataModule1.Consulta.ParamByName('ORDEN').AsInteger:=Principal.ID_Orden;
       Datas.DataModule1.Consulta.ParamByName('AGENTE').AsString:=Principal.agente;
       Datas.DataModule1.Consulta.ExecSQL;
       end;

       Pendiente.Enabled:=False;
       Finalizar.Enabled:=False;

end;

procedure TForm4.HomeClick(Sender: TObject);
begin
  Form4.Visible:=False;
  finalizar.Enabled:=False;
  pendiente.Enabled:=False;
  timer1.Enabled:=False;
  Form2.Visible:=True;
  Minutos.Text:='00';
  Segundos.Text:='00';
  Horas.Text:='00';
  min:=0;
  seg:=0;
  hr:=0;

end;

procedure TForm4.IniciarClick(Sender: TObject);
var
  nuevo_id : integer;
  estat : string;
begin
    Iniciar.Enabled:=False;
    Pendiente.Enabled:=True;
    Finalizar.Enabled:=True;
    seg:=0;
    min:=0;
    hr:=0;

    try
       Datas.DataModule1.Consulta.SQL.Clear;
       Datas.DataModule1.Consulta.SQL.Add('select ID,ESTATUS AS ESTA from actividad_taller where orden=:id and agente=:agente and tarea=:tarea and estatus in (:estatus,:estatus1)');
       Datas.DataModule1.Consulta.ParamByName('id').AsInteger:=StrToInt(Form3.IDSOrdenes.Lines.Strings[Form3.Ordenes.ItemIndex]);
       Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='PENDIENTE';
       Datas.DataModule1.Consulta.ParamByName('estatus1').AsString:='NO INICIADA';
       Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;
       Datas.DataModule1.Consulta.ParamByName('tarea').AsString:=DescripcionExtra.Text;
       Datas.DataModule1.Consulta.ExecSQL;

       if Datas.DataModule1.Consulta.RecordCount > 0 then
       begin

        estat := Datas.DataModule1.Consulta.FieldByName('ESTA').AsString;
        nuevo_id := Datas.DataModule1.Consulta.FieldByName('ID').AsInteger;
        if (estat = 'PENDIENTE') OR (estat = 'NO INICIADA')  then
        begin
                  Datas.DataModule1.Consulta.SQL.Clear;
                  Datas.DataModule1.Consulta.SQL.Add('update actividad_taller set fecha_inicio=getdate(),estatus=:estat where ID=:orden and agente=:agente and estatus=:estatus');
                  Datas.DataModule1.Consulta.ParamByName('estat').AsString:='TRABAJANDO';
                  Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=nuevo_id;
                  Datas.DataModule1.Consulta.ParamByName('estatus').AsString:=estat;
                  Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;;
                  Datas.DataModule1.Consulta.ExecSQL;
        end;
       end
       else
       begin
          Datas.DataModule1.Consulta.SQL.Clear;
          Datas.DataModule1.Consulta.SQL.Add('insert into actividad_taller(orden,agente,tarea,fecha_inicio,estatus) values (:orden,:agente,:tarea,getdate(),:estatus)');
          Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=StrToInt(Form3.IDSOrdenes.Lines.Strings[Form3.Ordenes.ItemIndex]);
          Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;
          Datas.DataModule1.Consulta.ParamByName('tarea').AsString:=DescripcionExtra.Text;
          Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='TRABAJANDO';
          Datas.DataModule1.Consulta.ExecSQL;
          showmessage('no hay registros');
       end;
    finally

    end;
    Timer1.Enabled:=True;
end;

procedure TForm4.PendienteClick(Sender: TObject);
begin
    if (memo1.Visible = True) and (Memo1.Text.Length < 10) then
    begin
      ShowMessage('Debe ingresar una justificacion mayor a 10 caracteres');
    end;

    Memo1.Visible:=True;
    Label1.Visible:=True;

    if Memo1.Text.Length >= 10 then
    begin
        try
          Datas.DataModule1.Consulta.SQL.Clear;
          Datas.DataModule1.Consulta.SQL.Add('update actividad_taller set justificacion=:justi,estatus=:estatus, fecha_fin=getdate() where id=:id');
          Datas.DataModule1.Consulta.ParamByName('id').AsInteger:=Principal.mi_id;
          Datas.DataModule1.Consulta.ParamByName('justi').AsString:=Memo1.Text;
          Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='FINALIZADO';
          Datas.DataModule1.Consulta.ExecSQL;

          Datas.DataModule1.Consulta.SQL.Clear;
          Datas.DataModule1.Consulta.SQL.Add('insert into actividad_taller(orden,agente,tarea,estatus) values (:orden,:agente,:tarea,:estatus)');
          Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=Principal.ID_Orden;
          Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Principal.agente;
          Datas.DataModule1.Consulta.ParamByName('tarea').AsString:= DescripcionExtra.Text;
          Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='PENDIENTE';
          Datas.DataModule1.Consulta.ExecSQL;
          Memo1.Text:='';
          Memo1.Visible:=False;
          Label1.Visible:=False;
          Pendiente.Enabled:=False;
          Finalizar.Enabled:=False;
          Iniciar.Enabled:=True;

        finally

        end;

    end;
    Datas.DataModule1.Consulta.Close;

end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin
controltiempo;
end;

end.
