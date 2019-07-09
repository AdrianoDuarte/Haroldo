unit uPrincipal;

interface

uses
  FMX.Controls,
  FMX.Controls.Presentation,
  FMX.Dialogs,
  FMX.Edit,
  FMX.Forms,
  FMX.Graphics,
  FMX.Memo,
  FMX.ScrollBox,
  FMX.StdCtrls,
  FMX.Types,
  System.Classes,
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Variants;

type
  TfrmPrincipal = class(TForm)
    lblTexto: TLabel;
    memTexto: TMemo;
    memChave: TLabel;
    edtChave: TEdit;
    cbEmbaralhar: TCheckBox;
    btnAdicionar: TButton;
    memResultado: TMemo;
    procedure btnAdicionarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

function MisturaPalavra(Seed: Integer; Palavra: string): string;
function MisturaFrase(Seed: Integer; Frase: string): string;

implementation

{$R *.fmx}

function MisturaPalavra(Seed: Integer; Palavra: string): string;
var
  X, R, Len: Integer;
  C: Char;

begin
  RandSeed := Seed;
  Len := Length(Palavra);
  for X := 1 to Len do
  begin
    R := Random(Len) + 1;
    C := Palavra[X];
    Palavra[X] := Palavra[R];
    Palavra[R] := C;
  end;
  Result := Palavra;
end;

function MisturaFrase(Seed: Integer; Frase: string): string;
var
  Palavras: TStringList;
  I: Integer;
  Ponto: Boolean;

begin
  if Frase = '.' then
    Result := '.'
  else
  begin
    Palavras := TStringList.Create;
    try
      I := Pos('.', Frase);
      if I > 0 then
      begin
        Delete(Frase, I, 1);
        Ponto := True;
      end
      else
        Ponto := False;

      I := Pos(' ', Frase);
      while I > 0 do
      begin
        Palavras.Add(Copy(Frase, 1, I - 1));
        Delete(Frase, 1, I);
        I := Pos(' ', Frase)
      end;
      Palavras.Add(Frase);

      if frmPrincipal.cbEmbaralhar.IsChecked then
      begin
        var
          X, R, Len: Integer;
        var
          C: string;

        RandSeed := Seed;
        Len := Palavras.Count;
        for X := 0 to Len - 1 do
        begin
          R := Random(Len);
          C := Palavras[X];
          Palavras[X] := Palavras[R];
          Palavras[R] := C;
        end;
      end;

      Result := MisturaPalavra(Seed, Palavras[0]);
      if Palavras.Count > 1 then
        for I := 1 to Palavras.Count - 1 do
          Result := Result + ' ' + MisturaPalavra(Seed, Palavras[I]);

      if Ponto then
        Result := Result + '.'
    finally
      FreeAndNil(Palavras);
    end;
  end;
end;

procedure TfrmPrincipal.btnAdicionarClick(Sender: TObject);
var
  Frase, TextoInicial, TextoFinal: string;
  I, Seed: Integer;

begin
  TextoInicial := memTexto.Text;
  Seed := StrToIntDef(edtChave.Text, 5);

  I := Pos('.', TextoInicial);
  while I > 0 do
  begin
    Frase := Copy(TextoInicial, 1, I);
    Delete(TextoInicial, 1, I);
    TextoFinal := TextoFinal + MisturaFrase(Seed, Frase);
    I := Pos('.', TextoInicial);
  end;
  if Length(TextoInicial) > 0 then
    TextoFinal := TextoFinal + MisturaFrase(Seed, TextoInicial);

  memResultado.Lines.Add(TextoFinal)
end;

end.
