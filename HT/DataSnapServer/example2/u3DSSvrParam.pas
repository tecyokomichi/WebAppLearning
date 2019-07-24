unit u3DSSvrParam;

interface

Uses
  SysUtils, Classes, u2ParamIO;

Type
  Tu3DSSvrParam = class(Tu2ParamIO)
  private
    FDSSServer : String;   // DataSnap サーバー
    FDSSPort   : Integer;  // DataSnap ポート

  protected
    class Function DefParamName: String; override;

  public
    Procedure ClearData; override;

    Procedure Load; override;
    Procedure Save(AForce: Boolean = False); override;

    property DSSServer : String  read FDSSServer write FDSSServer;
    property DSSPort   : Integer read FDSSPort   write FDSSPort;
  end;

implementation

// Tu3DSServer
// ---------------------------------------------------------------------------

class function Tu3DSSvrParam.DefParamName: String;
Const
  C9FileName = 'DSSvrPrm.ini';
begin
  Result := GetProgramBasePath + '\' + C9FileName;
end;


// ---------------------------------------------------------------------------

procedure Tu3DSSvrParam.ClearData;
begin
  inherited;

  Self.FDSSServer := '';  // DataSnap サーバー
  Self.FDSSPort   := 0;   // DataSnap ポート
end;


// ---------------------------------------------------------------------------

procedure Tu3DSSvrParam.Load;
Var
  n      : Integer;
  s      : String;
  sParam : String;
  AList  : TStringList;
begin
  inherited;

  AList := TStringList.Create();
  Try
    sParam := Trim(Self.FileName);
    if(FileExists(sParam)) then
      AList.LoadFromFile(sParam);

    // サーバー
    s := Trim(AList.Values['DSSServer']);
    if(s <> '')
    then Self.FDSSServer := s
    else Self.FDSSServer := '';

    // ポート
    n := StrToIntDef(Trim(AList.Values['DssPort']), 0);
    if(n <> Self.FDssPort)
    then Self.FDSSPort := n
    else Self.FDSSPort := 0;

  Finally
    if(Assigned(AList)) then
      AList.Free;
  End;
end;



// ---------------------------------------------------------------------------

procedure Tu3DSSvrParam.Save(AForce: Boolean);
Var
  bWri   : Boolean;
  n      : Integer;
  s      : String;
  sParam : String;
  AList  : TStringList;
begin
  inherited;

  AList := TStringList.Create();
  Try
    sParam := Trim(Self.FileName);
    if(FileExists(sParam)) then
      AList.LoadFromFile(sParam);

    bWri := False;

    // サーバー
    s := Trim(AList.Values['DSSServer']);
    if(s <> Trim(Self.FDSSServer)) then begin
      AList.Values['DSSServer'] := Trim(Self.FDSSServer);
      bWri := True;
    end;

    // ポート
    n := StrToIntDef(Trim(AList.Values['DSSPort']), 0);
    if(n <> Self.FDSSPort) then begin
      AList.Values['DSSPort'] := IntToStr(Self.FDSSPort);
      bWri := True;
    end;


    // Write File
    if(bWri or AForce) then begin
      Try
        AList.SaveToFile(sParam);
      Except
        On E: Exception do begin  ; end;
      End;
    end;
  Finally
    if(Assigned(AList)) then
      AList.Free;
  End;
end;


// ---------------------------------------------------------------------------


end.
