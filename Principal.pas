unit Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  MultiDetailAppearanceU, FMX.ListView, System.ImageList, FMX.ImgList,ControlActividades,
  FMX.ScrollBox, FMX.Memo;

type
  TForm2 = class(TForm)
    ScaledLayout1: TScaledLayout;
    Contenedor: TRectangle;
    ListadoUsuarios: TListView;
    ToolBar1: TToolBar;
    SpeedButton2: TSpeedButton;
    ImageList1: TImageList;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    NombresUsuarios: TMemo;
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure ListadoUsuariosClick(Sender: TObject);
    procedure ListadoUsuariosDblClick(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  Form2: TForm2;
  mi_id,id_orden:Integer;
  agente:String;

implementation
Uses Datas,DetalleControlActividades;
{$R *.fmx}



procedure TForm2.ListadoUsuariosClick(Sender: TObject);
begin

    if ListadoUsuarios.Selected <> Nil then
    begin
         try
            Datas.DataModule1.Consulta.SQL.Clear;
            Datas.DataModule1.Consulta.SQL.Add('select t.id as ID, orden,tarea as actividad, cte.nombre as cliente,v.fecharequerida as fecha from actividad_taller t '+
            'left join venta v on v.id = t.orden '+
            'left join cte on cte.cliente = v.cliente where t.agente=:agente and t.estatus=:estatus ');
            Datas.DataModule1.Consulta.ParamByName('agente').AsString:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
            Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='TRABAJANDO';
            Datas.DataModule1.Consulta.ExecSQL;

            if Datas.DataModule1.Consulta.RecordCount > 0 then
            begin
                 ID_Orden := Datas.DataModule1.Consulta.FieldByName('orden').AsInteger;
                 mi_id := Datas.DataModule1.Consulta.FieldByName('ID').AsInteger;
                 agente:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
                 Form2.Visible:=False;
                 Form4.Visible:=True;
                 Form4.DescripcionExtra.Text:=Datas.DataModule1.Consulta.FieldByName('actividad').AsString;
                 Form4.Pendiente.Enabled:=True;
                 Form4.Finalizar.Enabled:=True;
                 Datas.DataModule1.Consulta.Close;
                 Datas.DataModule1.Consulta.SQL.Clear;
                 datas.DataModule1.Consulta.SQL.Add('select sum(DATEDIFF(DAY,Fecha_inicio,Fecha_fin)) as Dias '+
                 ', sum(DATEDIFF(Hour,Fecha_inicio,Fecha_fin))%24 as Horas '+
                 ', sum(DATEDIFF(Minute,Fecha_inicio,Fecha_fin))%60 as Minutos '+
                 ',sum(DATEDIFF(Second,Fecha_inicio,Fecha_fin))%60 as Segundos '+
                 'from actividad_taller '+
                 'where orden=:orden and agente=:agente and tarea=:tarea'
                 );
                 Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=ID_Orden;
                 Datas.DataModule1.Consulta.ParamByName('agente').AsString:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
                 datas.DataModule1.Consulta.ParamByName('tarea').AsString:=Form4.DescripcionExtra.Text;
                 Datas.DataModule1.Consulta.ExecSQL;
                 Form4.Segundos.Text:=Datas.DataModule1.Consulta.FieldByName('Segundos').AsString;
                 Form4.Minutos.Text:=Datas.DataModule1.Consulta.FieldByName('Minutos').AsString;
                 Form4.Horas.Text:=Datas.DataModule1.Consulta.FieldByName('Horas').AsString;
                 DetalleControlActividades.hr:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Horas').AsString);
                 DetalleControlActividades.min:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Minutos').AsString);
                 DetalleControlActividades.seg:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Segundos').AsString);

                // Form4.Timer1.Enabled:=True;
                 Datas.DataModule1.Consulta.Close;


            end
            else
            begin
                form2.Visible:=False;
                ControlActividades.Form3.NombreAgente.Text:=NombresUsuarios.Lines.Strings[ListadoUsuarios.ItemIndex];
                ControlActividades.Form3.Visible:=True;
                ControlActividades.Form3.cargar_ordenes;
            end;

         finally

         end;





    end;
end;


procedure TForm2.ListadoUsuariosDblClick(Sender: TObject);
begin

    if ListadoUsuarios.Selected <> Nil then
    begin
         try
            Datas.DataModule1.Consulta.SQL.Clear;
            Datas.DataModule1.Consulta.SQL.Add('select t.id as ID, orden,tarea as actividad, cte.nombre as cliente,v.fecharequerida as fecha from actividad_taller t '+
            'left join venta v on v.id = t.orden '+
            'left join cte on cte.cliente = v.cliente where t.agente=:agente and t.estatus=:estatus ');
            Datas.DataModule1.Consulta.ParamByName('agente').AsString:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
            Datas.DataModule1.Consulta.ParamByName('estatus').AsString:='TRABAJANDO';
            Datas.DataModule1.Consulta.ExecSQL;

            if Datas.DataModule1.Consulta.RecordCount > 0 then
            begin
                 ID_Orden := Datas.DataModule1.Consulta.FieldByName('orden').AsInteger;
                 mi_id := Datas.DataModule1.Consulta.FieldByName('ID').AsInteger;
                 agente:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
                 Form2.Visible:=False;
                 Form4.Visible:=True;
                 Form4.DescripcionExtra.Text:=Datas.DataModule1.Consulta.FieldByName('actividad').AsString;
                 Form4.Pendiente.Enabled:=True;
                 Form4.Finalizar.Enabled:=True;
                 Datas.DataModule1.Consulta.Close;
                 Datas.DataModule1.Consulta.SQL.Clear;
                 datas.DataModule1.Consulta.SQL.Add('select sum(DATEDIFF(DAY,Fecha_inicio,Fecha_fin)) as Dias '+
                 ', sum(DATEDIFF(Hour,Fecha_inicio,Fecha_fin))%24 as Horas '+
                 ', sum(DATEDIFF(Minute,Fecha_inicio,Fecha_fin))%60 as Minutos '+
                 ',sum(DATEDIFF(Second,Fecha_inicio,Fecha_fin))%60 as Segundos '+
                 'from actividad_taller '+
                 'where orden=:orden and agente=:agente and tarea=:tarea'
                 );
                 Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=ID_Orden;
                 Datas.DataModule1.Consulta.ParamByName('agente').AsString:=ListadoUsuarios.Items[ListadoUsuarios.ItemIndex].Text;
                 datas.DataModule1.Consulta.ParamByName('tarea').AsString:=Form4.DescripcionExtra.Text;
                 Datas.DataModule1.Consulta.ExecSQL;
                 Form4.Segundos.Text:=Datas.DataModule1.Consulta.FieldByName('Segundos').AsString;
                 Form4.Minutos.Text:=Datas.DataModule1.Consulta.FieldByName('Minutos').AsString;
                 Form4.Horas.Text:=Datas.DataModule1.Consulta.FieldByName('Horas').AsString;
                 DetalleControlActividades.hr:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Horas').AsString);
                 DetalleControlActividades.min:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Minutos').AsString);
                 DetalleControlActividades.seg:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Segundos').AsString);

                // Form4.Timer1.Enabled:=True;
                 Datas.DataModule1.Consulta.Close;


            end
            else
            begin
                form2.Visible:=False;
                ControlActividades.Form3.NombreAgente.Text:=NombresUsuarios.Lines.Strings[ListadoUsuarios.ItemIndex];
                ControlActividades.Form3.Visible:=True;
                ControlActividades.Form3.cargar_ordenes;
            end;

         finally

         end;





    end;
end;

procedure TForm2.SpeedButton3Click(Sender: TObject);
begin
  Application.Terminate;
  Exit;
end;

procedure TForm2.SpeedButton5Click(Sender: TObject);
var
  Items : TListViewItem;
begin
  //Este procedimiento realiza la carga de los usuarios que tienen acceso a esta aplicacion
  Datas.DataModule1.Consulta.SQL.Clear;
  Datas.DataModule1.Consulta.SQL.Add('SELECT agente,Nombre FROM agente WHERE estatus=:Estatus AND Tipo=:Tipo');
  Datas.DataModule1.Consulta.ParamByName('Estatus').AsString:='ALTA';
  Datas.DataModule1.Consulta.ParamByName('Tipo').AsString:='Mecanico';
  try
    Datas.DataModule1.Consulta.ExecSQL;

    if Datas.DataModule1.Consulta.RecordCount > 0 then
    begin
    with Datas.DataModule1.Consulta do
    begin
      while not Datas.DataModule1.Consulta.Eof do
      begin
          items := ListadoUsuarios.Items.Add;
          NombresUsuarios.Lines.Add(Datas.DataModule1.Consulta.FieldByName('Nombre').AsString);
          items.Text:=Datas.DataModule1.Consulta.FieldByName('agente').AsString;
          Items.Data[TMultiDetailAppearanceNames.Detail1]:=Datas.DataModule1.Consulta.FieldByName('Nombre').AsString;
          Next;
      end;
    end;
  end;
  finally

  end;
   Datas.DataModule1.Consulta.Close;
end;

end.
