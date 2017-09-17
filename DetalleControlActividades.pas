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
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    procedure HomeClick(Sender: TObject);
    procedure IniciarClick(Sender: TObject);
    procedure PendienteClick(Sender: TObject);
    procedure FinalizarClick(Sender: TObject);
    procedure CerrarClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure controltiempo;
  procedure inicializa_tiempo;

    { Public declarations }
  end;

var
  Form4: TForm4;
  hr,min,seg:Integer;
  precio,uts:string;


implementation
Uses Principal,ControlActividades,Datas;
{$R *.fmx}

procedure TForm4.inicializa_tiempo;
begin

    Datas.DataModule1.Consulta.SQL.Clear;
    Datas.DataModule1.Consulta.SQL.Add('select isnull(sum(DATEDIFF(DAY,Fecha_inicio,isnull(Fecha_fin,getdate()))),0) as Dias '+
        ', isnull(sum(DATEDIFF(Hour,Fecha_inicio,isnull(Fecha_fin,getdate())))%24,0) as Horas '+
        ', isnull(sum(DATEDIFF(Minute,Fecha_inicio,isnull(Fecha_fin,getdate())))%60,0) as Minutos '+
        ',isnull(sum(DATEDIFF(Second,Fecha_inicio,isnull(Fecha_fin,getdate())))%60,0) as Segundos '+
        'from actividad_taller '+
        'where orden=:orden and agente=:agente and tarea=:tarea'
        );
        Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=Principal.id_orden;
        Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Form2.ListadoUsuarios.Items[Form2.ListadoUsuarios.ItemIndex].Text;
        Datas.DataModule1.Consulta.ParamByName('tarea').AsString:=Form4.DescripcionExtra.Text;
        Datas.DataModule1.Consulta.ExecSQL;

                  hr:=Datas.DataModule1.Consulta.FieldByName('Horas').AsInteger;
                  min:= Datas.DataModule1.Consulta.FieldByName('Minutos').AsInteger;
                  seg:= Datas.DataModule1.Consulta.FieldByName('Segundos').AsInteger;
                 Form4.Segundos.Text:=IntToStr(seg);
                 Form4.Minutos.Text:=IntToStr(min);
                 Form4.Horas.Text:=IntToStr(hr);

                // Form4.inicializa_tiempo;
                 Form4.Timer1.Enabled:=True;
                 Datas.DataModule1.Consulta.Close;


end;

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


       Form2.ListadoUsuarios.Selected:=nil;
       Form4.Visible:=False;
       Form2.Visible:=True;

       {Form3.cargar_ordenes;
       form3.ListaDetalle.Items.Clear;
       Form3.Visible:=true;   }

end;

procedure TForm4.HomeClick(Sender: TObject);
begin
  Form2.Visible:=True;
  Form4.Close;
  Form3.ListaDetalle.Items.Clear;
  Form3.Close;
  Form2.ListadoUsuarios.Selected:=nil;
end;

procedure TForm4.IniciarClick(Sender: TObject);
var
  nuevo_id : integer;
  estat : string;
begin
    Iniciar.Enabled:=False;
    Pendiente.Enabled:=True;
    Finalizar.Enabled:=True;
   

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
    //Timer1.Enabled:=True;
    Form2.Visible:=True;
    Form2.ListadoUsuarios.Selected:=nil;
    Form4.Close;
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
          Timer1.Enabled:=False;
          Form4.Close;
          Form3.cargar_ordenes;
          Form3.Visible:=true;
          Form3.NombreAgente.Text:=Principal.Nombre;
          Form3.ListaDetalle.Items.Clear;
          Form3.Ordenes.Selected:=nil;

        finally

        end;

    end;
    Datas.DataModule1.Consulta.Close;

end;




procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
  if Principal.trabajando = 0  then
  begin
    Form3.Visible:=True;
    Form3.ListaDetalle.Items.Clear;
    Form3.Ordenes.Selected:=nil;
    Form4.Close;
  end;
 if Principal.trabajando = 1 then
 begin
   Form2.ListadoUsuarios.Selected:=nil;
   Form4.Visible:=False;
   Form2.Visible:=True;
   Principal.Trabajando:=0;
 end;

end;

procedure TForm4.Timer1Timer(Sender: TObject);
begin
controltiempo;
end;

end.
