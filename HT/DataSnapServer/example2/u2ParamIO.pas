unit u2ParamIO;

interface

Uses
  SysUtils, Classes;

Type
  Tu2ParamIO = class
  private
    FFileName : String;

  protected
    procedure InitialVars;

    class Function DefParamName: String; virtual;

    class Function EncodeString(ASrc: String): String; virtual;
    class Function DecodeString(ASrc: String): String; virtual;

  public
    Constructor Create;
    Procedure Free;
    class Function IsSameObject(Other: TObject): Boolean; virtual;
    Function  IsEqual(Other: TObject): Boolean; virtual;
    Procedure Assign(Other: TObject); virtual;
    Procedure ClearData; virtual;

    class Function GetProgramBasePath: String; virtual;

    class Function  GetFolderPath(sTitle: String; AFullPath: Boolean = False;
      ALastPath: String = ''; ANewFolder: Boolean = False): String;

    Procedure Load; virtual;
    Procedure Save(AForce: Boolean = False); virtual;

    property FileName : String read FFileName write FFileName;

  end;

implementation

Uses
 //Vcl.Dialogs;
  Forms, Windows, Winapi.ShlObj,
  System.NetEncoding, Soap.EncdDecd;


// Tu2ParamIO
// ---------------------------------------------------------------------------

constructor Tu2ParamIO.Create;
begin
  Inherited;

  InitialVars();
end;

procedure Tu2ParamIO.Free;
begin
  ;
end;


// ---------------------------------------------------------------------------

procedure Tu2ParamIO.InitialVars;
begin
  Inherited;

  Self.FFileName := DefParamName();

  ClearData();
end;


Procedure Tu2ParamIO.ClearData;
begin
  ;
end;

// ---------------------------------------------------------------------------

class Function Tu2ParamIO.IsSameObject(Other: TObject): Boolean;
begin
  Result := False;
  if(NOT Assigned(Other)) then
    Exit;

  Result := (Other is Tu2ParamIO);
end;


Function Tu2ParamIO.IsEqual(Other: TObject): Boolean;
Var
  AObj : Tu2ParamIO;
Begin
  Result := False;
  if(NOT IsSameObject(Other)) then
    Exit;

  AObj := Tu2ParamIO(Other);

  if(LowerCase(Trim(Self.FFileName)) <> LowerCase(Trim(AObj.FFileName))) then Exit;

  Result := True;
End;


Procedure Tu2ParamIO.Assign(Other: TObject);
Var
  AObj : Tu2ParamIO;
Begin
  if(NOT IsSameObject(Other)) then
    Exit;

  AObj := Tu2ParamIO(Other);

  Self.FFileName := Trim(AObj.FFileName);
End;


// ---------------------------------------------------------------------------

class function Tu2ParamIO.GetProgramBasePath: String;
Var
  cName : array[0..MAX_PATH] of Char;
  sName : String;
Begin
  SetString(sName, cName, GetModuleFileName(hInstance, cName, SizeOf(cName)));
  Result := ExtractFilePath(ExpandUNCFileName(sName));
End;


class Function Tu2ParamIO.DefParamName: String;
Var
  cName : array[0..MAX_PATH] of Char;
  sName : String;
begin
  SetString(sName, cName, GetModuleFileName(hInstance, cName, SizeOf(cName)));
  Result := ExpandUNCFileName(sName);

  Result := ChangeFileExt(Result, '.ini');  // Service‘Î‰ž 2016/03/01 YIkezawa
end;


// ---------------------------------------------------------------------------

class Function Tu2ParamIO.EncodeString(ASrc: String): String;
var
  i : Integer;
begin
  Try
    if(Trim(ASrc) <> '')
    then Result := Soap.EncdDecd.EncodeString(ASrc)
    else Result := '';
  Except
    on E: Exception do begin
      Result := '';
    end;
  End;

  for i := 1 to Length(Result) do begin
    Result[i] := Char(Integer(Result[i]) - 1);
  end;
end;


class Function Tu2ParamIO.DecodeString(ASrc: String): String;
var
  i : Integer;
begin
  for i := 1 to Length(ASrc) do begin
    ASrc[i] := Char(Integer(ASrc[i]) + 1);
  end;

  try
    if(Trim(ASrc) <> '')
    then Result := Soap.EncdDecd.DecodeString(ASrc)
    else Result := '';
  Except
    on E: Exception do begin
      Result := '';
    end;
  end;
end;


// ---------------------------------------------------------------------------

procedure Tu2ParamIO.Load;
begin
  ;
end;

procedure Tu2ParamIO.Save;
begin
  ;
end;


// ---------------------------------------------------------------------------

Var
  F9BasePath : String;

function GetFolderPathCallback(
  Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
Begin
  if(uMsg = BFFM_INITIALIZED) then begin
    if(Trim(F9BasePath) <> '') then
      SendMessage(Wnd, BFFM_SETSELECTION, 1, Longint(F9BasePath));
  end;

  Result := 0;
End;


class Function Tu2ParamIO.GetFolderPath(sTitle: String;
  AFullPath: Boolean; ALastPath: String; ANewFolder: Boolean): String;

  Function GetBaseDir: String;
  Begin
    Result := ExtractFileDir(ExpandUNCFileName(Application.ExeName));
  End;
  Function GetBaseFolder: String;
  Begin
    Result := ExtractFilePath(ExpandUNCFileName(Application.ExeName));
  End;
Var
  Browse : TBrowseInfo;
  IDList : PItemIDList;
  Buf    : PChar;
  sTtl   : String;
Begin
  Result := '';

  GetMem(Buf, MAXWORD);
  Try
    sTtl       := sTitle;
    F9BasePath := ExpandUNCFileName(ALastPath);

    Browse.hwndOwner      := Application.Handle;
    Browse.pidlRoot       := Nil;
    Browse.pszDisplayName := buf;
    Browse.lpszTitle      := PCHAR(sTtl);
    if(ANewFolder) then begin
      Browse.ulFlags      :=
        BIF_RETURNONLYFSDIRS or BIF_BROWSEINCLUDEFILES
        or BIF_USENEWUI or BIF_NEWDIALOGSTYLE or BIF_EDITBOX
        or BIF_RETURNFSANCESTORS;
    end else begin
      Browse.ulFlags      :=
        BIF_RETURNONLYFSDIRS or BIF_BROWSEINCLUDEFILES or BIF_USENEWUI
        or BIF_NONEWFOLDERBUTTON;
    end;
    Browse.lpfn           := GetFolderPathCallback;  // Nil;
    Browse.lParam         := 0;

    IDLIst := SHBrowseForFolder(Browse);
    if(IDLIST <> Nil) then begin
      SHGetPathFromIDLIst(IDList, Buf);
      Result := String(Buf);

      if(FileExists(Result)) then
        Result := ExtractFilePath(Result);

      if(NOT AFullPath) then begin
        if((UpperCase(Result) <> UpperCase(GetBaseDir()))
          and (UpperCase(Result) <> UpperCase(GetBaseFolder())))
        then Result := ExtractRelativePath(GetBaseFolder(), Result)
        else Result := '.\';
      End;
    end;
  Finally
    FreeMem(Buf, MAXWORD);
  End;
End;


// ---------------------------------------------------------------------------


end.


