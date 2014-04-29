unit Form;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  synaser { Synaser library downloaded from http://synapse.ararat.cz/files/synaser.zip }
  ;

type
  TMainForm = class(TForm)
    Mem_Rcv: TMemo;
    Tmr_Rcv: TTimer;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure Tmr_RcvTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Mem_RcvChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  ser: TBlockSerial;
  myFile: Text;
  XonOff : boolean ; { manual XonOff handling ... I want to see it }


implementation

{$R *.DFM}


procedure TMainForm.Tmr_RcvTimer(Sender: TObject);
var Ch: Byte ;
    sl: TStringList;
    tfs: string;
    floattemp: extended;
begin //Memo1.Lines.BeginUpdate;

  DecimalSeparator := '.';
  repeat
    Ch := Ser.RecvByte(2) ;
    if ser.LastError<>ErrTimeout then
      if Ch=13 Then
        begin
        Mem_Rcv.Lines.Append('');
        sl:=TStringList.Create; //Objekt erzeugen
        try  //try-finally hilft, das Objekt auch dann freizugeben, wenn ein Fehler auftritt
        floattemp:=-1000;
        floattemp:=strtofloat(Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]);
        if floattemp<>-1000 then
        begin
          AssignFile (MyFile,'C:\Brauerei\Temperatur\log.txt');  //new
          try Append(MyFile); except exit; end;    //new
          tfs:=(DateTimeToStr(Now)+';'+Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]); //Text hinzufügen    //new
          writeln(MyFile, tfs);   //new
          CloseFile(MyFile);      //new
          //  sl.Add(Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]);
          //  sl.LoadFromFile('C:\Brauerei\Temperatur\log.txt');  //Datei in Stringliste laden
          //  sl.Add(DateTimeToStr(Now)+';'+Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]); //Text hinzufügen
          //  sl.SaveToFile('C:\Brauerei\Temperatur\log.txt'); //Datei speichern
          Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]:=(DateTimeToStr(Now)+';'+Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-2]); //Text hinzufügen
        end;
        finally
          sl.free; //Objekt wieder freigeben
          end;
        end
      else if Ch=17 then
        begin
        XonOff := false ;
        end
      else if Ch=19 then
        begin
        XonOff := true ;
        end
      else if (Ch<>13)and(Ch<>10) then
        Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-1] :=
           Mem_Rcv.Lines.Strings[Mem_Rcv.Lines.Count-1] + chr(Ch)
    ;
  until ser.LastError=ErrTimeout ;
  //Mem_Rcv.Lines.EndUpdate;
end;

procedure OpenLine ;
begin with MainForm do begin
  ser.Connect(ComboBox1.Text) ;
  if ser.LastError<>sOK then begin Mem_Rcv.Lines.Append('No '+ComboBox1.Text) ; exit ; end ;
  ser.Config({Baud}1200, {Bits}8, {Parity}'N', {StopBits}SB1, {Xon/Xoff}false, {DTR/CTS}false);
  if ser.LastError<>sOK then begin Mem_Rcv.Lines.Append('Config fail') ; exit ; end ;
  Mem_Rcv.Lines.append('Connected');
  Mem_Rcv.Lines.Append('');
  Tmr_Rcv.Interval := 10 ; Tmr_Rcv.Enabled := True ; XonOff := false ;
  Mem_Rcv.Color := clWindow ;
end ; end ;

procedure CloseLine ;
begin with MainForm do begin
  Tmr_Rcv.Enabled := false ;
  ser.CloseSocket ;
end ; end ;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if DeleteFile('C:\Brauerei\Temperatur\log.txt') then
  begin
    AssignFile(myFile, 'C:\Brauerei\Temperatur\log.txt');
    ReWrite(myFile);
    Writeln(myFile, '01-01-2000 00:00:00;21.0');
    CloseFile(myFile);
  end;
  Label2.Caption:=DateTimeToStr(Now);
  ser:=TBlockserial.Create;
  ser.RaiseExcept:=False;
  OpenLine;
end;

procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  CloseLine;
  OpenLine;
end;

procedure TMainForm.Mem_RcvChange(Sender: TObject);
begin
  Label1.Caption:=DateTimeToStr(Now);
end;

end.
