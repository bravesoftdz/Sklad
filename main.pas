unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  DBGrids, EditBtn, Buttons, ExtCtrls, sqldb, Sqlite3DS, db, sqlite3conn;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ButtonFind: TButton;
    ButtonDel: TButton;
    ButtonAdd: TButton;
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    Editprice: TEdit;
    Editquantity: TEdit;
    Editmodel: TEdit;
    EditID: TEdit;
    Editfirm: TEdit;
    Edittype: TEdit;
    Image1: TImage;
    SQLite3Dataset: TSqlite3Dataset;
    SQLite3Connection: TSQLite3Connection;
    SQLQuery: TSQLQuery;
    SQLTransaction: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonAddClick(Sender: TObject);
    procedure ButtonDelClick(Sender: TObject);
    procedure ButtonFindClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    var nakl: text;

     namen,vrem,buff,po:string;
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
function p(a:string):string;
var i:integer;
  s:string;
 begin
   p:='';
   for i:=1 to 15-Length(a) do
     s:=s+' ';
     p:=s+' ';
 end;

procedure TForm1.ButtonAddClick(Sender: TObject);
    var i,quant,symm:integer;
      ds:string;
begin
  quant:=0;
  symm:=0;

  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM sklad where id = :id');
    ParamByName('id').Text:=Editid.Text;
    Open;
  end;
  ds:=SQLQuery.FieldByName('id').AsString;
  quant:=strtoint(SQLQuery.FieldByName('quantity').AsString)+strtoint(Editquantity.Text);
  Edittype.Text:=SQLQuery.FieldByName('type').AsString;
  Editfirm.Text:=SQLQuery.FieldByName('firm').AsString;
  Editmodel.Text:=SQLQuery.FieldByName('name').AsString;
  Editprice.Text:=SQLQuery.FieldByName('price').AsString;
  symm:=strtoint(Editquantity.Text)*strtoint(SQLQuery.FieldByName('price').AsString);
  SQLQuery.Close;
 if ds<>'' then
 begin
  SQLQuery.SQL.Text := 'update sklad set quantity =:quantity where id=:id;';
  SQLQuery.ParamByName('quantity').AsString := inttostr(quant);
  SQLQuery.ParamByName('id').AsString := ds;
  SQLQuery.ExecSQL;
  SQLTransaction.Commit;
  SQLite3Dataset.Open;
 end
else begin
  ShowMessage('Успешно добавлена новая запись');
  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('INSERT INTO sklad(id,type,firm,name,price,quantity,date) VALUES(:id,:type,:firm,:name,:price,:quantity,:date)');
    ParamByName('id').Text:=Editid.Text;
    ParamByName('type').Text:=Edittype.Text;
    ParamByName('firm').Text:=Editfirm.Text;
    ParamByName('name').Text:=Editmodel.Text;
    ParamByName('date').Text:=datetostr(date);
    ParamByName('price').Text:=(Editprice.Text);
    ParamByName('quantity').Text:=(Editquantity.Text);
    quant:=strtoint(Editquantity.Text);
    symm:=strtoint(Editprice.Text)*strtoint(Editquantity.Text);
    ExecSQL;
    SQLTransaction.Commit;
    Close;
  end;
  SQLite3Dataset.Open;
  end;
  vrem:=timetostr(now);
   for i:=1 to 10 do
   if vrem[i]=':' then vrem[i]:='.';
  namen:='kakietonakladnie\'+'nakladnaya_vvoza_za_'+datetostr(date)+'_'+vrem+'.txt';
  AssignFile(nakl,namen);
  Rewrite(nakl);
  for i:=1 to 50 do
  Write(nakl,'*');
  Writeln(nakl,' ');
  Writeln(nakl,'это накладная ввоза  ');
  Writeln(nakl,'от try MLG Sklaga');
  Writeln(nakl,'на склад завезено ');
  Writeln(nakl,Editfirm.Text,' ',Edittype.Text,' ',Editmodel.Text);
  Writeln(nakl,'в количестве ',Editquantity.Text,' с ценой ',Editprice.Text,' за еденицу');
  Writeln(nakl,'id завезенного товара= ',Editid.Text);
  Writeln(nakl,'Общая стоимость завезенного товара= ',symm);
  Writeln(nakl,'Всего на складе данного товара находится ',quant,' штук');
  for i:=1 to 50 do
  Write(nakl,'*');
  CloseFile(nakl);
  quant:=0;
  symm:=0;
    SQLQuery.Close;
    SQLite3Dataset.Open;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Editid.Text:='';
    Edittype.Text:='';
    Editfirm.Text:='';
    Editmodel.Text:='';
    Editprice.Text:='';
    Editquantity.Text:='';
end;

procedure TForm1.Button2Click(Sender: TObject);
    var i,ii:integer;
begin
   vrem:=timetostr(now);
   for i:=1 to 10 do
   if vrem[i]=':' then vrem[i]:='.';
  namen:='kakietonakladnie\'+'inventarnaya_vedomost_za_'+datetostr(date)+'_'+vrem+'.txt';
  AssignFile(nakl,namen);
  Rewrite(nakl);
   for i:=1 to 113 do
  Write(nakl,'*');
   writeln(nakl,' ');
  Writeln(nakl,' ');
  Writeln(nakl,'                                        Инвентарная ведомость от try mlg склада');
  Writeln(nakl,'                                        За ',datetostr(date),', время создания ',timetostr(now));
  writeln(nakl,'');
 for i:=1 to 113 do
  Write(nakl,'*');
 writeln(nakl,' ');
 writeln(nakl,' ');
 for i:=1 to 114 do
  Write(nakl,'-');
 writeln(nakl,' ');
 writeln(nakl,'|   id товара   |  тип товара   |    фирма      |   название    |     цена      |   количество  |  время завоза  |');
  for ii:=1 to 500 do begin
  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM sklad where id = :id');
    ParamByName('id').Text:=inttostr(ii);
    Open;
  end;
 if SQLQuery.FieldByName('firm').AsString<>'' then begin
 buff:=''+SQLQuery.FieldByName('id').AsString+p(SQLQuery.FieldByName('id').AsString)+SQLQuery.FieldByName('type').AsString+p(SQLQuery.FieldByName('type').AsString)+SQLQuery.FieldByName('firm').AsString+p(SQLQuery.FieldByName('firm').AsString)+SQLQuery.FieldByName('name').AsString+p(SQLQuery.FieldByName('name').AsString)+SQLQuery.FieldByName('price').AsString+p(SQLQuery.FieldByName('price').AsString)+SQLQuery.FieldByName('quantity').AsString+p(SQLQuery.FieldByName('quantity').AsString)+SQLQuery.FieldByName('date').AsString+p(SQLQuery.FieldByName('date').AsString);
 end;
  SQLQuery.Close;
 if( buff<>'') then   begin
 for i:=1 to 114 do
  Write(nakl,'-');
  writeln(nakl,'');
 Writeln(nakl,'|',buff,'|');
 buff:='';
 end;
  end;
    for i:=1 to 114 do
  Write(nakl,'-');
    writeln(nakl,' ');
    writeln(nakl,' ');
   for i:=1 to 113 do
  Write(nakl,'*');
  CloseFile(nakl);
end;

procedure TForm1.ButtonDelClick(Sender: TObject);
  var i,quant,id,symm:integer;
begin
   vrem:=timetostr(now);
   for i:=1 to 10 do
   if vrem[i]=':' then vrem[i]:='.';
  namen:='kakietonakladnie\'+'nakladnaya_vivoza_za_'+datetostr(date)+'_'+vrem+'.txt';
  AssignFile(nakl,namen);
  Rewrite(nakl);
  SQLite3Dataset.Close;
  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM sklad where id = :id');
    ParamByName('id').Text:=Editid.Text;
    Open;
  end;
  id:=strtoint(Editid.Text);
  symm:=strtoint(editquantity.text)*strtoint(SQLQuery.FieldByName('price').AsString);
  for i:=1 to 50 do
  Write(nakl,'*');
  Writeln(nakl,' ');
  Writeln(nakl,'это накладная вывоза  ');
  Writeln(nakl,'от try MLG Sklaga');
  writeln(nakl,'со склада вывзено ');
  buff:='';
  quant:=strtoint(SQLQuery.FieldByName('quantity').AsString)-strtoint(Editquantity.Text);
  buff:=SQLQuery.FieldByName('firm').AsString+' '+SQLQuery.FieldByName('type').AsString+' '+SQLQuery.FieldByName('name').AsString;
  writeln(nakl,buff);
  buff:='в количестве '+editquantity.text+' '+'с ценой '+SQLQuery.FieldByName('price').AsString;
  writeln(nakl,buff);
  Write(nakl,'id товара ');
  writeln(nakl,SQLQuery.FieldByName('id').AsString);
  writeln(nakl,'На складе таких товаров осталось ',quant,' штук');
  Writeln(nakl,'Общая сумма накладной= ',symm);
  for i:=1 to 50 do
  Write(nakl,'*');
   SQLQuery.Close;
   //++
  SQLQuery.SQL.Text := 'update sklad set quantity =:quantity where id=:id;';
  SQLQuery.ParamByName('quantity').AsString := inttostr(quant);
  SQLQuery.ParamByName('id').AsString := inttostr(id);
  SQLQuery.ExecSQL;
  SQLTransaction.Commit;
   //++
  SQLQuery.Close;
  if quant<=0 then begin
  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('DELETE FROM sklad where id=:ID');
    ParamByName('ID').Text:=EditID.Text;
    ExecSQL;
    SQLTransaction.Commit;
    Close;
  end;
 end;
  buff:='';
  SQLite3Dataset.Open;


  CloseFile(nakl);
   i:=0;
   quant:=0;
   id:=0;
   symm:=0;
end;

procedure TForm1.ButtonFindClick(Sender: TObject);
begin
  with SQLQuery do
  begin
    SQL.Clear;
    SQL.Add('SELECT * FROM sklad where name = :name');
    ParamByName('name').Text:=Editmodel.Text;
    Open;
  end;
  ShowMessage(SQLQuery.FieldByName('id').AsString);
  SQLQuery.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SQLite3Dataset.FileName:='sklad.db';
  SQLite3Dataset.TableName:='sklad';
  DataSource.DataSet:=SQLite3Dataset;
  SQLite3Connection.DatabaseName:='sklad.db';
  SQLite3Connection.Transaction:=SQLTransaction;
  SQLTransaction.DataBase:=SQLite3Connection;
  SQLQuery.DataBase:=SQLite3Connection;
  SQLQuery.Transaction:=SQLTransaction;
  try
     SQLite3Dataset.Open;
     SQLite3Connection.Connected:=True;
  except
     On E:Exception do
        ShowMessage('Ошибка открытия базы: '+ E.Message);
  end;
end;
end.

