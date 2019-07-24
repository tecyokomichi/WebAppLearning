unit u6DBConnUtil;

interface

Uses
  SysUtils, Classes, Data.DB, u3DBConParam;

Type
  Tu6DBConnUtil = class
  private
  protected
    // TFDQuery の作成
    class Function GenerateFDQuery(AConn: TCustomConnection): TDataSet;

    // TFDConnection と TDataSet の接続
    class Procedure SetDefPropDataSet(
      ADst: TComponent; AConn: TCustomConnection);

    // TFDConnection へのパラメータセット
    class Procedure SetDBParam(AConn: TCustomConnection; AParam, AValue: String);

    // SQL の設定
    class Function SetQueryString(ADst: TComponent; AStrs: TStrings): Boolean; overload;
    class Function SetQueryString(ADst: TComponent; AStr: String): Boolean; overload;

    // イベントメソッド
    class Procedure SimpleDataSetBeforeRefresh(ADst: TDataSet);
    class Procedure SimpleDataSetAfterPost(ADst: TDataSet);

  public
    // TFDConnection のDB接続パラメータによる初期化
    class Procedure InintialFDConnection(
      ADBCon: TComponent; AParam: Tu3DBConParam);

    // DB接続パラメータによる TFDConnection テスト接続
    class Function TestFDConnection(AParam: Tu3DBConParam; var AMsg: String): Boolean;

    // FireDAC DataSet の開放準備
    class Procedure PrepareFreeDataSet(ADataSet: TComponent);
    class procedure CloseDBObject(ADB: TCustomConnection);
  end;

implementation

Uses
  Vcl.Forms, Windows,

  // Delphi XE7
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.Comp.UI,

  // Phis IB
  FireDAC.Phys.IBDef, FireDAC.Phys.IBBase, FireDAC.Phys.IB,

  // Phis SQLite
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite,

  // Phis MySQL
  FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef;



// ---------------------------------------------------------------------------


// Tu6DBConnUtil
// ---------------------------------------------------------------------------

// TFDConnection のパラメータによる初期化
class procedure Tu6DBConnUtil.InintialFDConnection(
  ADBCon: TComponent; AParam: Tu3DBConParam);

  // ファイルの絶対パスを取得(Service対応)
  Function ExpandFilePath(AFileName: String): String;
    // プログラムの Path (フォルダ) の取得
    function GetProgramBasePath: String;
    Var
      cName : array[0..MAX_PATH] of Char;
      sName : String;
    Begin
      SetString(sName, cName, GetModuleFileName(hInstance, cName, SizeOf(cName)));
      Result := ExtractFilePath(ExpandUNCFileName(sName));
    End;
  begin
    Result := Trim(AFileName);

    if(Pos('.', Result) = 1)  // 相対パス
    then Result := ExpandUNCFileName(GetProgramBasePath() + Result)
    else Result := ExpandUNCFileName(Result);
  end;
Const
  C9DefSQLiteStringFormat = 'UTF8';
  C9DefFBServerCharSet    = 'UTF8';
  C9DefMySQLServerCharSet = 'UTF8';
  C9DefFBUserName         = 'SYSDBA';
  C9DefFBPassword         = 'masterkey';
  C9DefMySQLUserName      = 'root';
  C9DefMySQLPassword      = 'pikaichi';
Var
  s    : String;
  oConn: TFDConnection;
begin
  if(NOT Assigned(ADBCon)) then
    Exit;

  if(NOT (ADBCon is TFDConnection)) then
    Exit;

  if(NOT Assigned(AParam)) then
    Exit;

  // oConn オブジェクトの設定
  oConn := TFDConnection(ADBCon);

  // 接続設定の変更の前に 接続を閉じる
  oConn.Connected := False;

  case AParam.DBType of
   k2dbtSQLite:    // SQLite
    Begin
      Try
        oConn.DriverName  := 'SQLite';
        oConn.LoginPrompt := False;

        SetDBParam(oConn, 'DriverID', 'SQLite');
        SetDBParam(oConn, 'OpenMode', 'ReadWrite');
        SetDBParam(oConn, 'Encrypt',  'no');

        if(Trim(AParam.DefCharSet) <> '') then begin
          SetDBParam(oConn, 'StringFormat', Trim(AParam.DefCharSet));
        end else begin
          if(AParam.SQLDialect <> 1)
          then SetDBParam(oConn, 'StringFormat', C9DefSQLiteStringFormat)
          else SetDBParam(oConn, 'StringFormat', Trim(AParam.DefCharSet));
        end;

        SetDBParam(oConn, 'DateTimeFormat', 'String');

        s := ExpandFilePath(AParam.Database);
        SetDBParam(oConn, 'Database',  s);

        SetDBParam(oConn, 'user_name', AParam.AccUser);
        SetDBParam(oConn, 'password',  AParam.AccPass);
      Except
        on E: Exception do begin  ; End;
      End;
    End;
   k2dbtFirebird:  // Firebird/Interbase
    Begin
      Try
        oConn.DriverName    := 'IB';
        oConn.LoginPrompt   := False;

        SetDBParam(oConn, 'DriverID', 'IB');

        SetDBParam(oConn, 'protocol',   'TCPIP');             // 'local'
        SetDBParam(oConn, 'SQLDialect', IntToStr(AParam.SQLDialect));

        if(Trim(AParam.DefCharSet) <> '')
        then SetDBParam(oConn, 'CharacterSet', Trim(AParam.DefCharSet))
        else SetDBParam(oConn, 'CharacterSet', C9DefFBServerCharSet);

        SetDBParam(oConn, 'CreateDatabase', 'No');
        SetDBParam(oConn, 'PageSize',       '8192');

        SetDBParam(oConn, 'Server',   AParam.Server);

        s := ExpandFilePath(AParam.Database);
        SetDBParam(oConn, 'Database', s);

        if(Trim(AParam.AccUser) <> '')
        then SetDBParam(oConn, 'user_name', AParam.AccUser)
        else SetDBParam(oConn, 'user_name', C9DefFBUserName);

        if(Trim(AParam.AccPass) <> '')
        then SetDBParam(oConn, 'password', AParam.AccPass)
        else SetDBParam(oConn, 'password', C9DefFBPassword);
      Except
        on E: Exception do begin  ; end;
      end;
    end;
   k2dbtMySQL:
    begin
      Try
        oConn.DriverName  := 'MySQL';
        oConn.LoginPrompt := False;

        SetDBParam(oConn, 'DriverID', 'MySQL');

        if(Trim(AParam.DefCharSet) <> '')
        then SetDBParam(oConn, 'CharacterSet', Trim(AParam.DefCharSet))
        else SetDBParam(oConn, 'CharacterSet', C9DefMySQLServerCharSet);

        SetDBParam(oConn, 'Server',   AParam.Server);
        SetDBParam(oConn, 'Database', AParam.Database);

        if(Trim(AParam.AccUser) <> '')
        then SetDBParam(oConn, 'user_name', AParam.AccUser)
        else SetDBParam(oConn, 'user_name', C9DefMySQLUserName);

        if(Trim(AParam.AccPass) <> '')
        then SetDBParam(oConn, 'password', AParam.AccPass)
        else SetDBParam(oConn, 'password', C9DefMySQLPassword);

      Except
        on E: Exception do begin  ; end;
      end;
    end;
  end;
end;


// ---------------------------------------------------------------------------

class Function Tu6DBConnUtil.TestFDConnection(
  AParam: Tu3DBConParam; var AMsg: String): Boolean;

  Procedure PrepareQueryStringFB(ADst: TDataSet);
  Var
    sl : TStringList;
  begin
    sl := TStringList.Create();
    Try
      sl.Clear();
      sl.Add('Select ');
      sl.Add('    * ');
      sl.Add('  from rdb$databsase ');
      sl.Add(' ; ');

      SetQueryString(ADst, sl);
    Finally
      if(Assigned(sl)) then
        sl.Free;
    End;
  end;
Var
  AConn: TFDConnection;
begin
  AMsg := '';

  Result := False;
  if(NOT Assigned(AParam)) then
    Exit;

  AConn := TFDConnection.Create(Nil);
  Try
    InintialFDConnection(AConn, AParam);

    Try
      case AParam.DBType of
       k2dbtSQLite:    // SQLite
        begin
          AConn.Open();
          Result := True;
        End;

       k2dbtFirebird:  // Firebird/Interbase
        Begin
          AConn.Open();
          Result := True;
        end;

       k2dbtMySQL:
        begin
          AConn.Open();
          Result := ((Trim(AParam.AccUser) <> '') and (Trim(AParam.AccPass) <> '')) ;
          if(NOT Result) then
            AMsg := 'ユーザーまたは、パスワードに誤りがあります。';
        end;
      else // case-else
        //Result := False;
        Exit;
      end;
    Except
      On e: Exception do begin
        AMsg := e.Message;
      end;
    End;
  Finally
    if(Assigned(AConn)) then begin
      CloseDBObject(AConn);

      AConn.Free;
    end;
  End;
end;


// ---------------------------------------------------------------------------

// TFDQuery の作成
class Function Tu6DBConnUtil.GenerateFDQuery(AConn: TCustomConnection): TDataSet;
begin
  Result := TFDQuery.Create(Nil);

  SetDefPropDataSet(Result,  AConn);
end;


// ---------------------------------------------------------------------------

// イベントメソッド
class Procedure Tu6DBConnUtil.SimpleDataSetBeforeRefresh(ADst: TDataSet);
begin
  if(ADst is TFDDataSet) then begin
    if(TFDQuery(ADst).ApplyUpdates(-1) > 0) then begin
      TFDDataSet(ADst).CancelUpdates();
    end;
    Application.ProcessMessages;
  end;

  if(ADst is TFDDataSet) then begin
    if(TFDDataSet(ADst).ApplyUpdates(-1) > 0) then begin
      TFDDataSet(ADst).CancelUpdates();
    end;
    Application.ProcessMessages;
  end;
end;

class Procedure Tu6DBConnUtil.SimpleDataSetAfterPost(ADst: TDataSet);
begin
  if(ADst is TFDDataSet) then begin
    if(TFDDataSet(ADst).ApplyUpdates(-1) > 0) then begin
      TFDDataSet(ADst).CancelUpdates();
    end;
    Application.ProcessMessages;
  end;
end;


// ---------------------------------------------------------------------------

// TFDConnection へのパラメータセット
class Procedure Tu6DBConnUtil.SetDBParam(AConn: TCustomConnection; AParam, AValue: String);
Var
  s : String;
Begin
  s := Trim(AValue);

  if(AConn is TFDConnection) then begin
    if(UpperCase(TFDConnection(AConn).Params.Values[AParam]) <> UpperCase(s)) then
      TFDConnection(AConn).Params.Values[AParam] := s;
  end;
End;


// SQL の設定
class Function Tu6DBConnUtil.SetQueryString(
  ADst: TComponent; AStrs: TStrings): Boolean;

  Function SetQueryStringFDac(
    ADst: TComponent; AStrs: TStrings): Boolean;
  Var
    i, n   : Integer;
    Query  : TFDQuery;
    QueryC : TFDCommand;
  Begin
    Result := False;
    if(NOT Assigned(ADst)) then
      Exit;

    if(NOT Assigned(AStrs)) then
      Exit;

    if(ADst is TFDQuery) then begin
      Query := TFDQuery(ADst);

      n := AStrs.Count - 1;
      if(n < 0) then
        Exit;

      Query.SQL.Clear();
      for i := 0 to n do begin
        Query.SQL.Add(AStrs.Strings[i]);
      end;

      Result := (Trim(Query.SQL.Text) <> '');

    end else if(ADst is TFDCommand) then begin
      QueryC := TFDCommand(ADst);

      n := AStrs.Count - 1;
      if(n < 0) then
        Exit;

      QueryC.CommandText.Clear();
      for i := 0 to n do begin
        QueryC.CommandText.Add(AStrs.Strings[i]);
      end;

      Result := (Trim(QueryC.CommandText.Text) <> '');
    end;
  End;
begin
  if(ADst is TFDQuery) then
    Result := SetQueryStringFDac(ADst, AStrs)
  else if(ADst is TFDCommand) then
    Result := SetQueryStringFDac(ADst, AStrs)
  else if(ADst is TFDTable) then
    Result := SetQueryStringFDac(ADst, AStrs)
  else
    Result := False;
end;

class Function Tu6DBConnUtil.SetQueryString(ADst: TComponent; AStr: String): Boolean;
Var
  sl : TStringList;
begin
  sl := TStringList.Create();
  Try
    sl.Clear();
    sl.Text := AStr;

    Result := SetQueryString(ADst, sl);
  Finally
    if(Assigned(sl)) then
      sl.Free;
  End;
end;


// TFDConnection と TDataSet の接続
class Procedure Tu6DBConnUtil.SetDefPropDataSet(
  ADst: TComponent; AConn: TCustomConnection);
Var
  DstQ : TFDQuery;
  DstT : TFDTable;
  DstC : TFDCommand;
Begin
  if(NOT Assigned(ADst)) then
    Exit;

  if(ADst is TFDQuery) then begin
    // TFDQuery
    DstQ := TFDQuery(ADst);
    if(AConn is TFDConnection) then begin
      DstQ.Connection := TFDConnection(AConn);
    end;

    //Dst.DisableStringTrim := True;
    //DstQ.CachedUpdates    := True;
    DstQ.AggregatesActive    := True;

    DstQ.BeforeEdit    := SimpleDataSetAfterPost;
    DstQ.BeforeRefresh := SimpleDataSetBeforeRefresh;

    DstQ.AfterPost     := SimpleDataSetAfterPost;
    DstQ.AfterDelete   := SimpleDataSetAfterPost;

    //DstQ.DataSet.GetMetaData := True;
    //DstQ.Dataset.CommandType := ctQuery;
    //DstQ.FetchOnDemand       := True;

    DstQ.Params.Clear;

  end else if(ADst is TFDTable) then begin
    // TFDTable
    DstT := TFDTable(ADst);
    if(AConn is TFDConnection) then begin
      DstT.Connection := TFDConnection(AConn);
    end;

    //DstT.DisableStringTrim   := True;
    DstT.AggregatesActive    := True;

    DstT.BeforeEdit    := SimpleDataSetAfterPost;
    DstT.BeforeRefresh := SimpleDataSetBeforeRefresh;

    DstT.AfterPost     := SimpleDataSetAfterPost;
    DstT.AfterDelete   := SimpleDataSetAfterPost;

    //DstT.DataSet.GetMetaData := True;
    //DstT.Dataset.CommandType := ctQuery;
    //DstT.FetchOnDemand       := True;
    //DstT.Params.Clear;

  end else if(ADst is TFDCommand) then begin
    // TFDCommand
    DstC := TFDCommand(ADst);
    if(AConn is TFDConnection) then begin
      DstC.Connection := TFDConnection(AConn);
    end;

    DstC.Params.Clear;
  end;
End;


// ---------------------------------------------------------------------------

// FireDAC DataSet の開放準備
class Procedure Tu6DBConnUtil.PrepareFreeDataSet(ADataSet: TComponent);
Var
  DstQ : TFDQuery;
  DstT : TFDTable;
  DstC : TFDCommand;
Begin
  if(ADataSet is TFDQuery) then begin
    DstQ := TFDQuery(ADataSet);

    if(DstQ.State <> dsInactive) then begin
      Try
        DstQ.Close;
      Except
        On E: Exception Do begin  ; End;
      End;

      Try
        if(DstQ.Prepared) then
          DstQ.Prepared := False;
      Except
        On E: Exception Do begin  ; End;
      End;
    end;

    // オブジェクト自身の解放は、ここでは行わない
    if(Assigned(DstQ.Connection)) then
      DstQ.Connection := Nil;

  end else if(ADataSet is TFDTable) then begin
    DstT := TFDTable(ADataSet);

    if(DstT.State <> dsInactive) then begin
      Try
        DstT.Close;
      Except
        On E: Exception Do begin  ; End;
      End;

      Try
        if(DstT.Prepared) then
          DstT.Prepared := False;
      Except
        On E: Exception Do begin  ; End;
      End;
    end;

    // オブジェクト自身の解放は、ここでは行わない
    if(Assigned(DstT.Connection)) then
      DstT.Connection := Nil;

  end else if(ADataSet is TFDCommand) then begin
    DstC := TFDCommand(ADataSet);

    if(DstC.State <> csInactive) then begin
      Try
        DstC.Close;
      Except
        On E: Exception Do begin  ; End;
      End;

      Try
        if(DstC.Prepared) then
          DstC.Prepared := False;
      Except
        On E: Exception Do begin  ; End;
      End;
    end;

    // オブジェクト自身の解放は、ここでは行わない
    if(Assigned(DstC.Connection)) then
      DstC.Connection := Nil;

  end else if(ADataSet is TFDConnection) then begin
    CloseDBObject(TCustomConnection(ADataSet));
  end;
End;

class procedure Tu6DBConnUtil.CloseDBObject(ADB: TCustomConnection);
begin
  if(NOT Assigned(ADB)) then
    Exit;

  if(NOT (ADB is TFDConnection)) then
    Exit;

  // TSQLConnection
  Try
    if(Assigned(ADB)) then begin
      if(ADB.Connected) then
        ADB.Close();
    end;
  Except
    On E: Exception do begin  ; end;
  End;
end;


// ---------------------------------------------------------------------------


end.


