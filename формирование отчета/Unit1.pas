unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls,ComObj;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f1,f2:textfile;
  excelapp,workbook,range,range1,range2,cell1,cell2,vdata:variant;
  specno:integer;
  specno_str:string;
  ves_pal:string;
  f3:textfile;

implementation

{$R *.dfm}

procedure TForm1.Button3Click(Sender: TObject);
  var z,x,nomer,nomer1:string;
  i,j:integer; // строка,столбец
  sum,sumb:real;
  vesk:string; // тара
  d:integer;
begin
  i:=0; j:=0; sum:=0; vesk:=''; z:=''; x:=''; nomer:=''; nomer1:=''; d:=0; sumb:=0;

  IF FileExists('C:\files\schik.txt') =true THEN BEGIN

    assignfile(f1,'C:\Inetpub\ftproot\SHAPKA.TXT');
    reset(f1);
   while not eof(f1) do begin
    readln(f1,nomer); // читаю последнюю строку файла, т.е. кол-во № п/п
   end;
    closefile(f1);
    nomer1:=inttostr(strtoint(nomer)+8); //+8 - если учитывать шапку

//--------- открываю excell и настраиваю его -----------
   excelapp:=createoleobject('Excel.Application');
   excelapp.application.enableevents:=false;
   workbook:= excelapp.workbooks.add;
   excelapp.range['A1','H'+nomer1].font.size:=10;

   excelapp.range['A1','H'+nomer1].numberformat:='@';
   excelapp.range['A1','H'+nomer1].font.name:='Times new roman';
   excelapp.range['A1','H'+nomer1].ColumnWidth:=10;
   excelapp.range['A3','H3'].RowHeight:=20;
   excelapp.range['A7','H7'].RowHeight:=20;
   excelapp.range['A1','H'+nomer1].wraptext:=true;
//--- конец открываю excell и настраиваю его -----------

//---- создаю шапку ------------------------------------
   assignfile(f1,'C:\Inetpub\ftproot\shapka.txt');
   reset(f1);

   readln(f1,vesk); // вес коробки

   // меняю точку на запятую:
    d:= pos(chr(46),vesk);
   if d<>0 then begin
    delete(vesk,d,1);
    insert(chr(44),vesk,d);
   end;


   readln(f1,z); // наим.организации

   cell1:=workbook.worksheets[1].cells[1,1];
   cell2:=workbook.worksheets[1].cells[1,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=2;
   vdata:=z;
   range.value:=vdata;
   range.borders.linestyle:=0;

   readln(f1,z);
   cell1:=workbook.worksheets[1].cells[2,1];
   cell2:=workbook.worksheets[1].cells[3,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=2;
   vdata:=z;
   range.value:=vdata;
   range.borders.linestyle:=0;

   readln(f1,z);
   cell1:=workbook.worksheets[1].cells[4,1];
   cell2:=workbook.worksheets[1].cells[4,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=2;
   vdata:='Дата изготовления: '+z;
   range.value:=vdata;
   range.borders.linestyle:=0;

   cell1:=workbook.worksheets[1].cells[5,1];
   cell2:=workbook.worksheets[1].cells[5,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=2;
   vdata:='Масса нетто групповой упаковки: ';
   range.value:=vdata;
   range.borders.linestyle:=0;

   cell1:=workbook.worksheets[1].cells[6,1];
   cell2:=workbook.worksheets[1].cells[6,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=2;
   vdata:='Масса брутто групповой упаковки: ';
   range.value:=vdata;
   range.borders.linestyle:=0;

   readln(f1,z);
   cell1:=workbook.worksheets[1].cells[7,1];
   cell2:=workbook.worksheets[1].cells[7,8];
   range:= workbook.worksheets[1].range[cell1,cell2];
   range.mergecells:=true;
   range.HorizontalAlignment:=1;
   range.VerticalAlignment:=1;
   vdata:='Количество единиц потребительской упаковки в групповой упаковке: '+z;
   range.value:=vdata;
   range.borders.linestyle:=0;

   closefile(f1);
//---- конец создаю шапку -------------------------------

  i:=8; // данные о взвешиваниях начинаются после шапки, т.е. с 8й строки
  assignfile(f1,'C:\Inetpub\ftproot\table.csv');
  reset(f1);
while not eof(f1) do begin
  j:=1; // № столбца
  readln(f1,z);
 repeat
  if pos(';',z)<>0 then begin
    x:=Copy(z,1,pos(';',z)-1);
    delete(z,1,pos(';',z));

    cell1:=workbook.worksheets[1].cells[i,j];
    cell2:=workbook.worksheets[1].cells[i,j];
    range:= workbook.worksheets[1].range[cell1,cell2];
    range.mergecells:=true;
    range.HorizontalAlignment:=3;
    range.VerticalAlignment:=2;
    vdata:=x;
    range.value:=vdata;
    range.borders[1].linestyle:=1;
    range.borders[2].linestyle:=1;
    range.borders[3].linestyle:=1;
    range.borders[4].linestyle:=1;


  if (i>8) and (j=4) then begin
    sum:=sum+strtofloat(x);
    sumb:=sum+(strtofloat(vesk)*strtofloat(nomer));

    cell1:=workbook.worksheets[1].cells[5,1];
    cell2:=workbook.worksheets[1].cells[5,8];
    range:= workbook.worksheets[1].range[cell1,cell2];
    range.mergecells:=true;
    range.HorizontalAlignment:=1;
    range.VerticalAlignment:=2;
    vdata:='Масса нетто групповой упаковки: '+floattostr(sum)+' кг';
    range.value:=vdata;
    range.borders.linestyle:=0;

    cell1:=workbook.worksheets[1].cells[6,1];
    cell2:=workbook.worksheets[1].cells[6,8];
    range:= workbook.worksheets[1].range[cell1,cell2];
    range.mergecells:=true;
    range.HorizontalAlignment:=1;
    range.VerticalAlignment:=2;
    vdata:='Масса брутто групповой упаковки: '+floattostr(sumb)+' кг, в том числе вес паллета '+edit1.Text+' кг';
    range.value:=vdata;
    range.borders.linestyle:=0;
   end;

    j:=j+1; // перехожу на следущий столбец строки
   end;
  until pos(';',z)=0;
   i:=i+1; // перехожу на следущую строку
end; // while not eof(f1)...
   closefile(f1);

if i>48 then begin
// + 4 столбца ----------------
 range1:= workbook.worksheets[1].range['A8:D8'];
 range1.copy;  // скопировал в буфер
 range2:= workbook.worksheets[1].range['E8:H8'];
 range1.copy(range2);  // вставил в новое место

 range1:= workbook.worksheets[1].range['A49:D200'];
 range1.cut;  // вырезал
 range2:= workbook.worksheets[1].range['E9:H200'];
 range1.cut(range2);  // вставил в новое место
// -----------------------------
end;

// -- № спецификации ------
  if specno >= 9999 then  begin
   specno := 1;
   edit2.Text:= inttostr(specno);
  end;
// ------------------------

 try
  excelapp.displayalerts:=false;
  workbook.saveas('c:\otchet\specN'+edit2.text+'.xls');
 except
  showmessage('нельзя сохранить');
  exit;
 end;

 // ПЕЧАТЬ:
workbook.worksheets[1].printout;
workbook.worksheets[1].printout;
workbook.worksheets[1].printout;

// -- № спецификации ------
  specno:=strtoint(edit2.Text);
  specno := specno + 1;
  edit2.Text:= inttostr(specno);
// ------------------------

excelapp.displayalerts:=false;
excelapp.quit; //если запущен  excelapp
END;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

  if (not FileExists('C:\otchet\config.txt')) then begin
   AssignFile(f3,'C:\otchet\config.txt');
    Rewrite(f3);
     Writeln(f3,'1');
    Writeln(f3,'');
   CloseFile(f3);
  end;


  try
   AssignFile(f3,'C:\otchet\config.txt');
    reset(f3);
     readln(f3,specno_str);
    readln(f3,ves_pal);
   CloseFile(f3);
  except
   showmessage('error');
   Exit;
  end;

  specno:= StrToInt(specno_str);
   edit2.Text:= specno_str;
  edit1.Text:= ves_pal;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
    AssignFile(f3,'C:\otchet\config.txt');
     Rewrite(f3);
      WriteLn(f3,edit2.Text);
     WriteLn(f3,edit1.Text);
    CloseFile(f3);
except
end;
end;

end.
