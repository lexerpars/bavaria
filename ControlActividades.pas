unit ControlActividades;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  MultiDetailAppearanceU, FMX.ScrollBox, FMX.Memo;

type
  TForm3 = class(TForm)
    ToolBar1: TToolBar;
    NombreAgente: TSpeedButton;
    ScaledLayout1: TScaledLayout;
    Ordenes: TListView;
    ToolBar2: TToolBar;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    IDSOrdenes: TMemo;
    ListaDetalle: TListView;
    DescripcionTarea: TMemo;
    UTS: TMemo;
    PRECIO: TMemo;
    procedure SpeedButton2Click(Sender: TObject);
    procedure OrdenesChange(Sender: TObject);
    procedure ListaDetalleChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure cargar_ordenes;
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
Uses Principal,Datas,DetalleControlActividades;
{$R *.fmx}

procedure TForm3.cargar_ordenes;
var
  Items : TListViewItem;
begin
    try
      IDSOrdenes.text:='';
      Ordenes.Items.Clear;
      Datas.DataModule1.Consulta.SQL.Clear;
      Datas.DataModule1.Consulta.SQL.Add('SELECT DISTINCT V.ID AS ID, MOVID, CTE.NOMBRE AS NOMBRE, '+
      'V.FECHAREQUERIDA AS REQUERIDA, CASE WHEN V.SERVICIOPLACAS IS NULL THEN :NOPLACA ELSE V.SERVICIOPLACAS END AS PLACAS , V.SERVICIOARTICULO AS SERVICIO, CASE WHEN A.FABRICANTE IS NULL THEN '+
      ' A.DESCRIPCION1 ELSE A.FABRICANTE END AS FABRICANTE FROM VENTA V '+
      'LEFT JOIN VENTAD VD ON VD.ID=V.ID '+
      'LEFT JOIN CTE ON CTE.CLIENTE = V.CLIENTE '+
      'LEFT JOIN ART A ON A.ARTICULO = V.SERVICIOARTICULO '+
      'WHERE VD.AGENTE=:AGENTE AND V.MOVID NOT LIKE :GUION AND V.MOV=:MOV AND V.ESTATUS=:ESTATUS AND '+
      'V.ID NOT IN (SELECT DISTINCT ORDEN FROM TALLER_ORDEN WHERE AGENTE=:AGENTE1) '+
      'AND YEAR(V.FECHAEMISION)>=2016');
      Datas.DataModule1.Consulta.ParamByName('AGENTE').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;
      Datas.DataModule1.Consulta.ParamByName('AGENTE1').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;
      Datas.DataModule1.Consulta.ParamByName('GUION').AsString:='%'+'-'+'%';
      Datas.DataModule1.Consulta.ParamByName('ESTATUS').AsString:='PENDIENTE';
      Datas.DataModule1.Consulta.ParamByName('MOV').AsString:='Servicio';
      Datas.DataModule1.Consulta.ParamByName('NOPLACA').AsString:='NO DISPONIBLE';
      Datas.DataModule1.Consulta.ExecSQL;

      if Datas.DataModule1.Consulta.RecordCount > 0 then
      begin
        with Datas.DataModule1.Consulta do
        begin
          while not Datas.DataModule1.Consulta.Eof do
          begin
            Items := Ordenes.Items.Add;
            Items.Text := Datas.DataModule1.Consulta.FieldByName('MOVID').AsString +' - '+Datas.DataModule1.Consulta.FieldByName('REQUERIDA').AsString;
            Items.Data[TMultiDetailAppearanceNames.Detail1]:= Datas.DataModule1.Consulta.FieldByName('NOMBRE').AsString;
            Items.Data[TMultiDetailAppearanceNames.Detail2]:= Datas.DataModule1.Consulta.FieldByName('FABRICANTE').AsString +
            ' - '+Datas.DataModule1.Consulta.FieldByName('SERVICIO').AsString;
            Items.Data[TMultiDetailAppearanceNames.Detail3]:='Placa '+Datas.DataModule1.Consulta.FieldByName('PLACAS').AsString;
            IDSOrdenes.Lines.Add(Datas.DataModule1.Consulta.FieldByName('ID').AsString);
            Next;
          end;
        end;
      end;

    finally

    end;
      Datas.DataModule1.Consulta.Close;
end;

procedure TForm3.ListaDetalleChange(Sender: TObject);
begin
    Form3.Visible:=False;
    Form4.Visible:=True;
    Form4.DescripcionExtra.Text:=ListaDetalle.Items[ListaDetalle.ItemIndex].Text;
    Form4.Iniciar.Enabled:=True;

    Datas.DataModule1.Consulta.SQL.Clear;
    datas.DataModule1.Consulta.SQL.Add('select isnull(sum(DATEDIFF(DAY,Fecha_inicio,isnull(Fecha_fin,getdate()))),0) as Dias '+
    ', isnull(sum(DATEDIFF(Hour,Fecha_inicio,isnull(Fecha_fin,getdate())))%24,0) as Horas '+
    ', isnull(sum(DATEDIFF(Minute,Fecha_inicio,isnull(Fecha_fin,getdate())))%60,0) as Minutos '+
    ',isnull(sum(DATEDIFF(Second,Fecha_inicio,isnull(Fecha_fin,getdate())))%60,0) as Segundos '+
    'from actividad_taller '+
    'where orden=:orden and agente=:agente and tarea=:tarea'
    );
    Datas.DataModule1.Consulta.ParamByName('orden').AsInteger:=StrtoInt(IDSOrdenes.Lines.Strings[Ordenes.ItemIndex]);
    Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Form2.ListadoUsuarios.Items[Form2.ListadoUsuarios.ItemIndex].Text;
    datas.DataModule1.Consulta.ParamByName('tarea').AsString:=Form4.DescripcionExtra.Text;
    Datas.DataModule1.Consulta.ExecSQL;
    Form4.Segundos.Text:=Datas.DataModule1.Consulta.FieldByName('Segundos').AsString;
    Form4.Minutos.Text:=Datas.DataModule1.Consulta.FieldByName('Minutos').AsString;
    Form4.Horas.Text:=Datas.DataModule1.Consulta.FieldByName('Horas').AsString;
    DetalleControlActividades.hr:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Horas').AsString);
    DetalleControlActividades.min:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Minutos').AsString);
    DetalleControlActividades.seg:= StrToInt(Datas.DataModule1.Consulta.FieldByName('Segundos').AsString);
    //Form4.Timer1.Enabled:=True;
    Datas.DataModule1.Consulta.Close;
end;

procedure TForm3.OrdenesChange(Sender: TObject);
var
  Items : TListViewItem;
begin
    if Ordenes.Selected <> Nil then
    begin
      Listadetalle.Items.Clear;
      Datas.DataModule1.Consulta.SQL.Clear;
      Datas.DataModule1.Consulta.SQL.Add('SELECT * FROM actividad_taller WHERE ORDEN = :id');
      Datas.DataModule1.Consulta.ParamByName('id').AsInteger:=StrToInt(IDSOrdenes.Lines.Strings[Ordenes.ItemIndex]);
      Datas.DataModule1.Consulta.ExecSQL;

      if Datas.DataModule1.Consulta.RecordCount = 0 then
      begin
         Datas.DataModule1.Consulta.SQL.Clear;
         Datas.DataModule1.Consulta.SQL.Add('INSERT INTO ACTIVIDAD_TALLER(orden,agente,tarea,estatus) '+
         'select V.ID AS ID,VD.agente as agente, VD.DESCRIPCIONExtra AS TAREA, :es from venta v '+
         'left join ventad vd on vd.id = v.id '+
         'LEFT JOIN art ar on ar.ARTICULO = vd.articulo '+
         'left join agente a on a.agente = vd.agente '+
         'where a.tipo=:tipo and v.estatus=:estat  and ar.CATEGORIA=:cat and vd.id=:id');
         Datas.DataModule1.Consulta.ParamByName('tipo').AsString:='Mecanico';
         Datas.DataModule1.Consulta.ParamByName('estat').AsString:='PENDIENTE';
         Datas.DataModule1.Consulta.ParamByName('es').AsString:='NO INICIADA';
         Datas.DataModule1.Consulta.ParamByName('cat').AsString:='24-MANO DE OBRA';
         Datas.DataModule1.Consulta.ParamByName('id').AsInteger:= StrToInt(IDSOrdenes.Lines.Strings[Ordenes.ItemIndex]);
         Datas.DataModule1.Consulta.ExecSQL;
      end;

      try
          Datas.DataModule1.Consulta.SQL.Clear;
          Datas.DataModule1.Consulta.SQL.Add('SELECT DISTINCT TAREA FROM actividad_taller WHERE ORDEN = :id AND AGENTE=:agente AND ESTATUS <> :estat');
          Datas.DataModule1.Consulta.ParamByName('id').AsInteger:=StrToInt(IDSORdenes.Lines.Strings[Ordenes.ItemIndex]);
          Datas.DataModule1.Consulta.ParamByName('agente').AsString:=Principal.Form2.ListadoUsuarios.Items[Principal.Form2.ListadoUsuarios.ItemIndex].Text;
          Datas.DataModule1.Consulta.ParamByName('estat').AsString:='FINALIZADO';
          Datas.DataModule1.Consulta.ExecSQL;
          with Datas.DataModule1.Consulta do
          begin
              DescripcionTarea.Text:='';
              while not Datas.DataModule1.Consulta.Eof do
              begin
                  Items := ListaDetalle.Items.Add;
                  Items.Text:=Datas.DataModule1.Consulta.FieldByName('TAREA').AsString;
                  DescripcionTarea.Lines.Add(Datas.DataModule1.Consulta.FieldByName('TAREA').AsString);
                  Next;
              end;

          end;


      finally

      end;


    end;
    Datas.DataModule1.Consulta.Close;

end;

procedure TForm3.SpeedButton1Click(Sender: TObject);
begin
  Form3.Close;
  Form2.Visible:=True;
  Form2.ListadoUsuarios.Selected:=nil;
end;

procedure TForm3.SpeedButton2Click(Sender: TObject);
begin
   Application.Terminate;
   Exit;
end;

end.
