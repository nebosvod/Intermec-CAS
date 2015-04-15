unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Sockets;

type
  TForm1 = class(TForm)
    Button1: TButton;
    TcpClient1: TTcpClient;
    Edit1: TEdit;
    Label1: TLabel;
    Button2: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label8: TLabel;
    Edit8: TEdit;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    Button3: TButton;
    Label9: TLabel;
    Edit9: TEdit;
    Label10: TLabel;
    Edit10: TEdit;
    Label11: TLabel;
    Edit11: TEdit;
    Label12: TLabel;
    Edit12: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure Edit7KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit8KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  f2:textfile;
  schet: integer;
  
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
 var
 kk:string; //строка в файле
 f1:textfile; stroka:string;
begin

TCPClient1.RemotePort:='9100';
TCPClient1.RemoteHost:=edit1.Text;
TCPClient1.active:=true;

if  TCPClient1.Connected then begin
//--------------передача--------------------

//********** гружу список PLU*********
   try
kk:='open "plues.txt" for output as #10';
TCPClient1.Sendln(kk);
   AssignFile(f1,'c:\plues.txt');
   reset(f1);
   while not eof(f1) do
     begin
      Readln(f1,stroka);
      kk:='print #10,"'+stroka+'"';
      TCPClient1.Sendln(kk);
     end;
   closefile(f1);
     kk:='close #10';
     TCPClient1.Sendln(kk);
 except
 end;
//*******************
  kk:='RUN "LABEL.PRG"';
  TCPClient1.Sendln(kk);
  end else//if  TCPClient1.Connected
  showmessage('неверный IP');
  TCPClient1.Close;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
               try
                AssignFile(f2,'C:\config.txt');
                Rewrite(f2);
                WriteLn(f2,edit1.Text);
                CloseFile(f2);
              except
                Exit;
              end;
end;

procedure TForm1.FormCreate(Sender: TObject);
 var
  n:string;
begin

 schet:=1;

  if (not FileExists('C:\config.txt')) then  begin
     AssignFile(f2,'C:\config.txt');
     rewrite(f2);
     writeln(f2,'');
     closefile(f2);
    end else begin
    try
     AssignFile(f2,'C:\config.txt');
     reset(f2);
     readln(f2,n);
     edit1.Text:=n;
     closefile(f2);
    except
    Exit;
    end;
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
 label l2,l3;
var
 kk:string;
 f1,f3:textfile;
 flag:integer;
begin

// если файла нет, создадим:
if (not FileExists('C:\plues.txt')) then  begin
     AssignFile(f1,'C:\plues.txt');
     rewrite(f1);
     //writeln(f1,'');
     //Добавлялся перенос строки при создании файла, зачем - не понятно
     closefile(f1);
end;

flag:=0;
AssignFile(f1,'C:\plues.txt');
reset(f1);
while not eof(f1) do begin
 readln(f1,kk);
 //если PLU уже есть:
 if (copy(kk,1,6)='PLUNO=') and (edit2.Text=copy(kk,7,length(kk))) then flag:=1;
end;
closefile(f1);

if flag=1 then
if MessageBox(Form1.Handle, PChar('Товар существует. Заменить?'), '',
 MB_YESNO + MB_ICONQUESTION)=IDYES then goto l2 else  goto l3;

//**************** дописываю **************************
   schet:=strtoint(edit2.Text);

     AssignFile(f1,'C:\plues.txt');
     append(f1);

     kk:= 'PLUNO='+edit2.Text;
     writeln(f1,kk);
     kk:= 'NAME1='+edit3.Text;
     writeln(f1,kk);
     kk:= 'NAME2='+edit4.Text;
     writeln(f1,kk);
     kk:= 'GODEN='+edit5.Text;
     writeln(f1,kk);
     kk:= 'VESKOR='+edit6.Text;
     writeln(f1,kk);
     kk:= 'INTERVAL='+edit7.Text;
     writeln(f1,kk);
     kk:= 'KODTOV='+edit8.Text;
     writeln(f1,kk);
     kk:= 'NAMEORG='+edit11.Text;
     writeln(f1,kk);
     kk:= 'TOCHNOST='+edit9.Text;
     writeln(f1,kk);
     kk:= 'OKRUGLENIE='+edit10.Text;
     writeln(f1,kk);
     kk:= 'USUSHKA='+edit12.Text;
     writeln(f1,kk);


     closefile(f1);
     
     schet:=schet+1;
     goto l3;
//**************** дописал **************************


l2:
//******* заменяю *****************************************
    AssignFile(f1,'C:\plues.txt');
     AssignFile(f3,'C:\plues1.txt');
     reset(f1);
     rewrite(f3);
 while not eof(f1) do begin
   readln(f1,kk);
   writeln(f3,kk);
 //как только нашли нужный PLU, пишем в него новую инфу:
  if (copy(kk,1,6)='PLUNO=') and (edit2.Text=copy(kk,7,length(kk))) then begin
   writeln(f3,'NAME1='+edit3.text);
   writeln(f3,'NAME2='+edit4.text);
   writeln(f3,'GODEN='+edit5.text);
   writeln(f3,'VESKOR='+edit6.text);
   writeln(f3,'INTERVAL='+edit7.text);
   writeln(f3,'KODTOV='+edit8.text);
   writeln(f3,'NAMEORG='+edit11.text);
   writeln(f3,'TOCHNOST='+edit9.text);
   writeln(f3,'OKRUGLENIE='+edit10.text);
   writeln(f3,'USUSHKA='+edit12.text);
   //пробегаю старую инфу:
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   readln(f1,kk);
   //----------------------
  end;
 //------------------------------------------------------
 end;
 closefile(f1);
 closefile(f3);
 // копируем новый f3 в старый f1 (false - замена будет):
 copyfile('C:\plues1.txt','C:\plues.txt',false);
 deletefile('C:\plues1.txt');
//******* заменил ************************************************

l3: // выхожу...
     button2.Visible:=false;
     checkbox1.Checked:=false;

     label2.Visible:=false;
     label3.Visible:=false;
     label4.Visible:=false;
     label5.Visible:=false;
     label6.Visible:=false;
     label7.Visible:=false;
     label8.Visible:=false;
     label9.Visible:=false;
     label10.Visible:=false;
     label11.Visible:=false;
     label12.Visible:=false;

     edit2.Visible:=false;
     edit3.Visible:=false;
     edit4.Visible:=false;
     edit5.Visible:=false;
     edit6.Visible:=false;
     edit7.Visible:=false;
     edit8.Visible:=false;
     edit9.Visible:=false;
     edit10.Visible:=false;
     edit11.Visible:=false;
     edit12.Visible:=false;

     button1.Visible:=true;

end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
    edit2.Text:=inttostr(schet);

    if checkbox1.Checked=true then begin
     label2.Visible:=true;
     label3.Visible:=true;
     label4.Visible:=true;
     label5.Visible:=true;
     label6.Visible:=true;
     label7.Visible:=true;
     label8.Visible:=true;
     label9.Visible:=true;
     label10.Visible:=true;
     label11.Visible:=true;
     label12.Visible:=true;

     edit2.Visible:=true;
     edit3.Visible:=true;
     edit4.Visible:=true;
     edit5.Visible:=true;
     edit6.Visible:=true;
     edit7.Visible:=true;
     edit8.Visible:=true;
     edit9.Visible:=true;
     edit10.Visible:=true;
     edit11.Visible:=true;
     edit12.Visible:=true;

     button2.Visible:=true;
     button1.Visible:=false;
    end else
    if checkbox1.Checked=false then begin
     label2.Visible:=false;
     label3.Visible:=false;
     label4.Visible:=false;
     label5.Visible:=false;
     label6.Visible:=false;
     label7.Visible:=false;
     label8.Visible:=false;
     label9.Visible:=false;
     label10.Visible:=false;
     label11.Visible:=false;
     label12.Visible:=false;

     edit2.Visible:=false;
     edit3.Visible:=false;
     edit4.Visible:=false;
     edit5.Visible:=false;
     edit6.Visible:=false;
     edit7.Visible:=false;
     edit8.Visible:=false;
     edit9.Visible:=false;
     edit10.Visible:=false;
     edit11.Visible:=false;
     edit12.Visible:=false;

     button2.Visible:=false;
     button1.Visible:=true;
    end;
end;

procedure TForm1.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
edit6.MaxLength:=4;
end;

procedure TForm1.Edit7KeyPress(Sender: TObject; var Key: Char);
begin
 edit7.MaxLength:=1;
end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
 edit2.MaxLength:=4;
end;

procedure TForm1.Edit8KeyPress(Sender: TObject; var Key: Char);
begin
 edit8.MaxLength:=9;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 kk:string; //строка в файле
begin
TCPClient1.RemotePort:='9100';
TCPClient1.RemoteHost:=edit1.Text;
TCPClient1.active:=true;

if  TCPClient1.Connected then begin
//********** сбрасываю № коробки***
try
kk:='open "korob.txt" for output as #22';
TCPClient1.Sendln(kk);
kk:='print #22,"0"';
TCPClient1.Sendln(kk);
kk:='close #22';
TCPClient1.Sendln(kk);
except
end;
//*******************
  TCPClient1.Close;
  end else//if  TCPClient1.Connected
  showmessage('неверный IP');
end;

end.
