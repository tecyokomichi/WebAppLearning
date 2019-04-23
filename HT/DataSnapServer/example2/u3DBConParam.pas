unit u3DBConParam;

interface

Uses
  SysUtils, Classes, StdCtrls, u2ParamIO;

Type
  // DB のタイプ(メモリ内でのみ使用)
  K2DBType = (
    k2dbtUnknown,    // 不明
    k2dbtSQLite,     // SQLite
    k2dbtFirebird,   // Firebird
    k2dbtMySQL       // MySQL
  );


Type
  Tu3DBConParam = class(Tu2ParamIO)
  private
    FServer     : String;    // Server
    FDatabase   : String;    // Database
    FAccUser    : String;    // User
    FAccPass    : String;    // Password

    FDBType     : K2DBType;  // DBType
    FSQLDialect : Integer;   // SQL Dialect(InterBase/Firebird) [1 or 3])
    FDefCharSet : String;    // Default Character Set
    FComment    : String;    // 備考

  protected
    Procedure SetSQLDialect(AVal: Integer);
    Procedure SetDatabase(APath: String);
    Procedure SetComment(AMemo: String);

  public
    class Function IsSameObject(Other: TObject): Boolean; override;
    Function  IsEqual(Other: TObject): Boolean; override;
    Procedure Assign(Other: TObject); override;

    Procedure ClearData; override;

    class Function  GetDBType(ADBPath: String): K2DBType;
    class Function  DBTypeToStr(AType: K2DBType): String;
    class Function  MakeDBpath(AServer, ADBPath: String): String;
    class Procedure CepareteServe(APath: String; var ADBPath, AServer: String);
    class Procedure CepareteServerFirebird(APath: String; var ADBPath, AServer: String);
    class Procedure CepareteServerMySQL(APath: String; var ADBPath, AServer: String);

    class Procedure SetComboDBType(ACombo: TComboBox);
    class Procedure SetComboDBType2(ACombo: TComboBox);  // Firebird or MySQL (SQLite無し)
    class Procedure SetComboSQLDiarect(ACombo: TComboBox);
    class Procedure SetComboDefCharSet(ACombo: TComboBox);

    class Function GetComboID(ACmb: TCustomComboBox): Integer;
    class Procedure SetComboID(AID: Integer; ACmb: TCustomComboBox);

    // 文字列のオブジェクト項目分解
    Function LoadFromString(AStr: String; ABasePath: String = ''): Boolean;

    // オブジェクトの項目リスト文字列生成
    Function GetStringFromObj(ABasePath: String = ''): String;

    // デバック用オブジェクト文字列
    Function GetDumpString: String;

    Procedure Load; override;
    Procedure Save(AForce: Boolean = False); override;

    property Server   : String read FServer   write FServer;
    property Database : String read FDatabase write SetDatabase;
    property AccUser  : String read FAccUser  write FAccUser;
    property AccPass  : String read FAccPass  write FAccPass;

    property DBType     : K2DBType read FDBType     write FDBType;
    property SQLDialect : Integer  read FSQLDialect write SetSQLDialect;
    property DefCharSet : String   read FDefCharSet write FDefCharSet;
    property Comment    : String   read FComment    write SetComment;
  end;


implementation

Uses
  Graphics;


Const
  C9ParamName1 = 'ServerParam ';
  C9ParamName2 = 'ServerParam=';

  // 備考前の文字数(備考開始位置の調整)
  C9CommentStart = 70;


// Tu3DBConParam
// ---------------------------------------------------------------------------

procedure Tu3DBConParam.ClearData;
begin
  inherited;

  Self.FServer   := '';
  Self.FDatabase := '';
  Self.FAccUser  := '';
  Self.FAccPass  := '';

  Self.FDBType     := k2dbtMySQL;    // DBType  k2dbtUnknown;
  Self.FSQLDialect := 3;             // SQL Dialect(InterBase/Firebird) [1 or 3])
  Self.FDefCharSet := '';            // Default Character Set
  Self.FComment    := '';            // 備考
end;

// ---------------------------------------------------------------------------

class Function Tu3DBConParam.GetDBType(ADBPath: String): K2DBType;
Var
  n : Integer;
  s : String;
begin
  s := UpperCase(ExtractFileExt(ADBPath));
  if(s = '') then begin
    // MySQL Check
    s := Trim(ADBPath);
    n := Pos('[', s);
    if(n >= 1) then begin
      n := Pos(']', s);
      if(n = Length(s)) then begin
        Result := k2dbtMySQL;
        Exit;
      end;
    end;

    Result := k2dbtMySQL;  // k2dbtUnknown;

    Exit;
  end;

  if(s = '.SQLITE') then       Result := k2dbtSQLite      // SQLite
  else if(s = '.SQLITE2') then Result := k2dbtSQLite      // SQLite
  else if(s = '.SQLITE3') then Result := k2dbtSQLite      // SQLite
  else if(s = '.SDB') then     Result := k2dbtSQLite      // SQLite
  else if(s = '.DB') then      Result := k2dbtSQLite      // SQLite
  else if(s = '.FDB') then     Result := k2dbtFirebird    // Firebird
  else if(s = '.GDB') then     Result := k2dbtFirebird    // Firebird
  else                         Result := k2dbtUnknown;    // 不明
end;


class Function Tu3DBConParam.DBTypeToStr(AType: K2DBType): String;
begin
  case AType of
    k2dbtSQLite:     Result := 'SQLite';     // SQLite
    k2dbtFirebird:   Result := 'Firebird';   // Firebird
    k2dbtMySQL:      Result := 'MySQL';      // MySQL
  else  // case-else
    // k2dbtUnknown:    // 不明
    Result := '不明';
  end;
end;


class Function Tu3DBConParam.MakeDBpath(AServer, ADBPath: String): String;
Var
  sSvr : String;
  sPath: String;
begin
  sSvr  := Trim(AServer);
  sPath := Trim(ADBPath);

  case GetDBType(sPath) of
   k2dbtSQLite,     // SQLite
   k2dbtFirebird:   // Firebird
    begin
      if(sSvr <> '')
      then Result := sSvr + ':' + sPath
      else Result := sPath;
    end;
   k2dbtMySQL:      // MySQL
    begin
      if(sSvr <> '')
      then Result := sSvr + ':[' + sPath + ']'
      else Result := '[' + sPath + ']';
    end
  else  // case-else
    //k2dbtUnknown,    // 不明

    if(sSvr <> '')
    then Result := sSvr + ':' + sPath
    else Result := sPath;
  end;
end;


class Procedure Tu3DBConParam.CepareteServe(
  APath: String; var ADBPath, AServer: String);
begin
  case GetDBType(APath) of
   k2dbtMySQL:       // MySQL
    begin
      CepareteServerMySQL(APath, ADBPath, AServer);

    end;
  else // case-else
    //k2dbtUnknown,    // 不明
    //k2dbtSQLite,     // SQLite
    //k2dbtFirebird,   // Firebird
    CepareteServerFirebird(APath, ADBPath, AServer);
  end;
end;


class Procedure Tu3DBConParam.CepareteServerFirebird(
  APath: String; var ADBPath, AServer: String);
Var
  n  : Integer;
  s1 : String;
  s2 : String;
Begin
  ADBPath := APath;
  AServer := '';

  n := Pos(':', ADBPath);
  if(n > 4) then begin
    s1 := Copy(ADBPath, 1, n - 1);
    s2 := Copy(ADBPath, n + 1, Length(ADBPath) - n);
    if(Pos('.', s1) > 0) then begin
      AServer := s1;
      ADBPath := s2;
    end else if(Pos(':', s2) > 0) then begin
      AServer := s1;
      ADBPath := s2;
    end else if(Pos('.', s2) > 0) then begin
      AServer := s1;
      ADBPath := s2;
    end;
    //ShowMessage('[' + s1 + '][' + s2 + ']');
  end;
End;


class Procedure Tu3DBConParam.CepareteServerMySQL(
  APath: String; var ADBPath, AServer: String);
Var
  n  : Integer;
  s1 : String;
  s2 : String;
Begin
  ADBPath := APath;
  AServer := '';
  Try
    n := Pos(':', ADBPath);
    if(n > 1) then begin
      s1 := Copy(ADBPath, 1, n - 1);
      s2 := Copy(ADBPath, n + 1, Length(ADBPath) - n);
      if(Pos('.', s1) > 0) then begin
        AServer := s1;
        ADBPath := s2;
      end else if(Pos(':', s2) > 0) then begin
        AServer := s1;
        ADBPath := s2;
      end else begin
        if(Pos('[', s2) > 0) then begin
          AServer := s1;
          ADBPath := s2;
        end;
      end;
      //ShowMessage('[' + s1 + '][' + s2 + ']');
    end;
  Finally
    s2 := ADBPath;
    n := Pos('[', s2);
    if(n > 0) then begin
      s2 := Copy(s2, n + 1, Length(s2) - n);

      n := Pos(']', s2);
      if(n > 0) then begin
        s2 := Copy(s2, 1, n - 1);
      end;

      ADBPath := s2;
    end;
  End;
End;


class Procedure Tu3DBConParam.SetComboDBType(ACombo: TComboBox);
Var
  i : K2DBType;
begin
  if(NOT Assigned(ACombo)) then
    Exit;

  ACombo.Items.Clear();
  ACombo.Clear();
  ACombo.Style      := csOwnerDrawVariable;  // csOwnerDrawFixed;
  ACombo.ItemHeight := Abs(ACombo.Font.Height) + 2;

  for i := k2dbtSQLite to k2dbtMySQL do begin
    ACombo.Items.AddObject(DBTypeToStr(i), TObject(Ord(i)));
  end;

  SetComboID(Ord(k2dbtFirebird), ACombo)
end;


// Firebird or MySQL (SQLite無し)
class Procedure Tu3DBConParam.SetComboDBType2(ACombo: TComboBox);
Var
  i : K2DBType;
begin
  if(NOT Assigned(ACombo)) then
    Exit;

  ACombo.Items.Clear();
  ACombo.Clear();
  ACombo.Style      := csOwnerDrawVariable;  // csOwnerDrawFixed;
  ACombo.ItemHeight := Abs(ACombo.Font.Height) + 2;

  for i := k2dbtFirebird to k2dbtMySQL do begin
    ACombo.Items.AddObject(DBTypeToStr(i), TObject(Ord(i)));
  end;

  SetComboID(Ord(k2dbtMySQL), ACombo)
end;


// SQL Diarect
class Procedure Tu3DBConParam.SetComboSQLDiarect(ACombo: TComboBox);
begin
  if(NOT Assigned(ACombo)) then
    Exit;

  ACombo.Items.Clear();
  ACombo.Clear();
  ACombo.Style      := csOwnerDrawVariable;
  ACombo.ItemHeight := Abs(ACombo.Font.Height) + 2;

  ACombo.Items.AddObject('SQL Diarect 1', TObject(1));
  ACombo.Items.AddObject('SQL Diarect 3', TObject(3));

  ACombo.ItemIndex := ACombo.Items.Count - 1;
end;


// Default Character Set
class Procedure Tu3DBConParam.SetComboDefCharSet(ACombo: TComboBox);
begin
  if(NOT Assigned(ACombo)) then
    Exit;

  ACombo.Items.Clear();
  ACombo.Clear();
  //ACombo.Style      := csOwnerDrawVariable;
  //ACombo.ItemHeight := Abs(ACombo.Font.Height) + 2;
  ACombo.Style      := csDropDown;

  ACombo.Items.AddObject(' ',         TObject(0));
  ACombo.Items.AddObject('NONE',      TObject(1));
  ACombo.Items.AddObject('UTF8',      TObject(2));
  ACombo.Items.AddObject('SJIS_0208', TObject(3));
  ACombo.Items.AddObject('EUCJ_0208', TObject(4));

  if(ACombo.Items.Count > 2) then
    ACombo.ItemIndex := 2;

  ACombo.ItemIndex := ACombo.Items.Count - 1;
end;


class Function Tu3DBConParam.GetComboID(ACmb: TCustomComboBox): Integer;
begin
  Result := 0;

  If(NOT Assigned(ACmb)) then
    Exit;

  If(ACmb.ItemIndex >= 0) then
    Result := Integer(ACmb.Items.Objects[ACmb.ItemIndex]);
end;


class Procedure Tu3DBConParam.SetComboID(AID: Integer; ACmb: TCustomComboBox);
Var
  n : Integer;
Begin
  If(NOT Assigned(ACmb)) then
    Exit;

  Try
    If(AID < 0) then Begin
      If(ACmb.Items.Count > 0) then
        ACmb.ItemIndex := 0;
      Exit;
    End;

    n := ACmb.Items.IndexOfObject(TObject(AID));

    If(n >= 0) then Begin
      ACmb.ItemIndex := n;
    End Else Begin
      If(ACmb.Items.Count > 0) then
        ACmb.ItemIndex := 0;
    End;
  Except
    On E: Exception Do Begin
      If(ACmb.Items.Count > 0) then
        ACmb.ItemIndex := 0;
    End;
  End;
End;


// ---------------------------------------------------------------------------

procedure Tu3DBConParam.SetSQLDialect(AVal: Integer);
begin
  if(AVal = 1)
  then Self.FSQLDialect := 1
  else Self.FSQLDialect := 3;
end;


Procedure Tu3DBConParam.SetDatabase(APath: String);
Var
  s : String;
  t : K2DBType;
Begin
  s := Trim(APath);

  if(Self.FDatabase <> s) then
    Self.FDatabase := s;

  t := GetDBType(s);
  if(Self.FDBType <> t) then
    Self.FDBType := t;

  if(t <> k2dbtFirebird) then begin
    if(Self.FSQLDialect <> 3) then
      Self.FSQLDialect := 3;
  end;
End;


Procedure Tu3DBConParam.SetComment(AMemo: String);
Var
  s : String;
Begin
  s := Trim(AMemo);

  if(Self.FComment <> s) then
    Self.FComment := s;
End;


// ---------------------------------------------------------------------------

class Function Tu3DBConParam.IsSameObject(Other: TObject): Boolean;
Begin
  Result := False;
  if(NOT Assigned(Other)) then
    Exit;

  Result := (Other is Tu3DBConParam);
End;


Function Tu3DBConParam.IsEqual(Other: TObject): Boolean;
Var
  AObj : Tu3DBConParam;
Begin
  Result := False;
  if(NOT IsSameObject(Other)) then
    Exit;

  AObj := Tu3DBConParam(Other);

  if(Trim(Self.Server)   <> Trim(AObj.Server))   then Exit;
  if(Trim(Self.Database) <> Trim(AObj.Database)) then Exit;
  if(Trim(Self.AccUser)  <> Trim(AObj.AccUser))  then Exit;
  if(Trim(Self.AccPass)  <> Trim(AObj.AccPass))  then Exit;

  if(Self.DBType           <> AObj.DBType)           then Exit;
  if(Self.SQLDialect       <> AObj.SQLDialect)       then Exit;
  if(Trim(Self.DefCharSet) <> Trim(AObj.DefCharSet)) then Exit;
  if(Trim(Self.Comment)    <> Trim(AObj.Comment))    then Exit;

  Result := True;
End;


Procedure Tu3DBConParam.Assign(Other: TObject);
Var
  AObj : Tu3DBConParam;
Begin
  Inherited Assign(Other);

  if(NOT IsSameObject(Other)) then
    Exit;

  AObj := Tu3DBConParam(Other);

  Self.Server   := Trim(AObj.FServer);    // Server
  Self.Database := Trim(AObj.FDatabase);  // Database
  Self.AccUser  := Trim(AObj.FAccUser);   // User
  Self.AccPass  := Trim(AObj.FAccPass);   // Password

  Self.DBType     := AObj.FDBType;            // DBType
  Self.SQLDialect := AObj.FSQLDialect;        // SQL Dialect(InterBase/Firebird) [1 or 3])
  Self.DefCharSet := Trim(AObj.FDefCharSet);  // Default Character Set
  Self.Comment    := Trim(AObj.FComment);     // 備考

End;


// ---------------------------------------------------------------------------

// 文字列のオブジェクト項目分解
Function Tu3DBConParam.LoadFromString(AStr: String; ABasePath: String): Boolean;
  {
  // [=] で文字列を分割 (エリアスと構成文字列)
  Function CepareteEqual(var AStr: String): String;
  Var
    n : Integer;
    s : String;
  Begin
    Result := '';

    s := Trim(AStr);
    if(s = '') then begin
      AStr := '';
      Exit;
    end;

    n := Pos('=', s);
    if(n > 0) then begin
      Result := Trim(Copy(s, 1,     n - 1));
      AStr   := Trim(Copy(s, n + 1, Length(s) - n));
    end else begin
      Result := s;
      AStr   := '';
    end;
  End;
  }

  // [#] で文字列を分割 (コメントとコメント以外)
  Function CepareteSharp(var AStr: String): String;
  Var
    n : Integer;
    s : String;
  Begin
    Result := '';

    s := Trim(AStr);
    if(s = '') then begin
      AStr := '';
      Exit;
    end;

    n := Pos('#', s);
    if(n > 0) then begin
      Result := Trim(Copy(s, 1,     n - 1));
      AStr   := Trim(Copy(s, n + 1, Length(s) - n));
    end else begin
      Result := s;
      AStr   := '';
    end;
  End;

  // [,] で文字列を分割 (データベースパスとデータベースダイアレクト以降)
  Function CepareteCamma(var AStr: String): String;
  Const
    C9Comma = ',';
  Var
    n : Integer;
    s : String;
  Begin
    Result := '';

    s := Trim(AStr);
    if(s = '') then begin
      AStr := '';
      Exit;
    end;

    n := Pos(C9Comma, s);
    if(n > 0) then begin
      Result := Trim(Copy(s, 1,     n - 1));
      AStr   := Trim(Copy(s, n + 1, Length(s) - n));
    end else begin
      // 最終文字列
      Result := s;
      AStr   := '';
    end;
  End;

  {
  // DBPath の正規化 (相対パスであれば基準フォルダ位置との結合)
  Function DecodeDBPath(APath, ABase: String): String;
  Begin
    Result := Trim(APath);  // ExpandUNCFileName(APath);
    if(ABase <> '') then begin
      if(APath <> '') then Begin
        if(APath[1] = '.') then begin
          if(ABase[Length(ABase)] = '\')
          then Result := ExpandUNCFileName(ABase + APath)
          else Result := ExpandUNCFileName(ABase + '\' + APath);
          //ShowMessage('[' + Result + ']');
        end;
      end;
    end;
  End;
  }
Var
  s   : String;
  s2  : String;
  sSv : String;
  sDB : String;
Begin
  Result := False;
  ClearData();

  s  := Trim(AStr);

  // コメント行のチェック
  if(s = '') then begin
    Self.FComment := '';  // 空行

    Result := True;
    Exit;

  end else if(s[1] = '#') then begin
    // 備考
    Self.FComment := Trim(Copy(s, 2, Length(s) - 1));

    Result := True;
    Exit;
  end;

  // エリアス名の取得
  //s2 := CepareteEqual(s);
  //if(s2 = '') then
  //  Exit;
  //
  //Self.FAliasName := s2;   // エリアス名

  s2 := CepareteSharp(s);
  if(s2 = '') then
    Exit;

  Self.FComment := s;      // 備考

  // データベース・パス
  s  := s2;
  s2 := CepareteCamma(s);

  CepareteServe(s2, sDB, sSv);

  Self.Server   := sSv;  // Server
  Self.Database := sDB;  // Database

  // SQL Dialect(InterBase/Firebird)
  s2 := CepareteCamma(s);
  Self.SQLDialect := StrToIntDef(s2, 3);

  // アクセスユーザー名
  s2 := CepareteCamma(s);
  if(s2 <> '') then
    Self.FAccUser := DecodeString(s2);

  // アクセスパスワード
  s2 := CepareteCamma(s);
  if(s2 <> '') then
    Self.FAccPass := DecodeString(s2);

  // Default Character Set
  s2 := CepareteCamma(s);
  Self.FDefCharSet := s2;

  Result := True;
End;


// オブジェクトの項目リスト文字列生成
Function Tu3DBConParam.GetStringFromObj(ABasePath: String = ''): String;
  Function MakeUserAndPassword: String;
  Var
    sU : String;
    sP : String;
  begin
    Result := '';

    sU := Trim(Self.FAccUser);
    sP := Trim(Self.FAccPass);

    if(sU <> '') then begin
      Result := Result + ',' + EncodeString(sU);

      if(sP <> '') then begin
        Result := Result + ',' + EncodeString(sP);
      end;
    end else if(sP <> '') then begin
      Result := Result + ',,' + EncodeString(sP);
    end;
  end;

  Function GetRelativePath(ADBPath: String; ABase: String): String;
    Procedure CepareteServer(APath: String; var ADBPath, AServer: String);
    Var
      n  : Integer;
      s1 : String;
      s2 : String;
    Begin
      ADBPath := APath;
      AServer := '';

      n := Pos(':', ADBPath);
      if(n > 4) then begin
        s1 := Copy(ADBPath, 1, n - 1);
        s2 := Copy(ADBPath, n + 1, Length(ADBPath) - n);
        if(Pos('.', s1) > 0) then begin
          AServer := s1;
          ADBPath := s2;
        end else if(Pos(':', s2) > 0) then begin
          AServer := s1;
          ADBPath := s2;
        end;
        //ShowMessage('[' + s1 + '][' + s2 + ']');
      end;
    End;
    Function GetFirstFolder(APath: String): String;
    Var
      n  : Integer;
      s  : String;
      ss : String;
    begin
      Result := '';

      s := Trim(APath);
      if(Pos(':', s) <= 0) then
        s := ExpandUNCFileName(APath);

      ss := '\\';
      n := Pos(ss, s);
      if(n > 0) then begin
        // netPath
        Result := Copy(s, 1, n + Length(ss) - 1);
        s      := Copy(s, n + Length(ss), Length(s) - n - Length(ss) + 1);

        ss := '\';
        n := Pos(ss, s);
        if(n > 0) then begin
          Result := Result + Copy(s, 1, n);
          s      := Copy(s, n + Length(ss), Length(s) - n - Length(ss) + 1);

          n := Pos(ss, s);
          if(n > 0) then begin
            Result := Result + Copy(s, 1, n - 1);
          end;
        end;
      end else begin
        ss := '\';
        n := Pos(ss, s);
        if(n > 0) then begin
          Result := Copy(s, 1, n);
          s      := Copy(s, n + 1, Length(s) - n);

          n := Pos(ss, s);
          if(n > 0) then begin
            Result := Result + Copy(s, 1, n - 1);
          end;
        end else begin
          Result := APath;  // path不明
          Exit;
        end;
      end;
    end;
  Var
    sServer: String;
    sPath  : String;
    sBase  : String;
  begin
    Result := Trim(ADBPath);
    if((Pos('[', Result) > 0) or (Pos(']', Result) > 0)) then
      Exit;  // MySQL

    CepareteServer(Result, sPath, sServer);
    if(sServer <> '') then
      Exit;

    if(Pos('\\', sPath) > 0) then
      Exit;

    sBase := ABase;

    if(Pos(GetFirstFolder(sBase), sPath) > 0) then
      sPath := ExtractRelativePath(sBase + '\', sPath);

    if(sServer <> '')
    then Result := sServer + ':' + sPath
    else Result := sPath;
  end;
Var
  sPwd : String;
Begin
  // コメント行 チェック
  if((Trim(Self.FServer) = '')
    and (Trim(Self.FDatabase) = '')) then
  begin
    if(Trim(Self.FComment) <> '')
    then Result := '# ' + Self.FComment
    else Result := '';

    Exit;
  end;

  //if(ABasePath <> '')
  //then Result := Self.FAliasName + '=' + GetRelativePath(Self.FDBPath, ABasePath)
  //else Result := Self.FAliasName + '=' + Self.FDBPath;

  if(ABasePath <> '')
  then Result := GetRelativePath(MakeDBpath(Self.FServer, Self.FDatabase), ABasePath)
  else Result := MakeDBpath(Self.FServer, Self.FDatabase);

  sPwd := MakeUserAndPassword();  // アクセスユーザー名, アクセスパスワード

  // SQLDialect <> 3 ならカンマの後に追記 (3なら省略)
  if(Self.SQLDialect <> 3) then begin
    if(sPwd <> '')
    then Result := Result + ',' + IntToStr(Self.SQLDialect) + sPwd
    else Result := Result + ',' + IntToStr(Self.SQLDialect) + ',,';
  end else begin
    if(sPwd <> '')
    then Result := Result + ',' + sPwd
    else Result := Result + ',' + ',,';
  end;

  // Default Character Set
  Result := Result + ',' + Trim(Self.FDefCharSet);

  // 行末にコメントを追加
  if(Trim(Self.FComment) <> '') then
    Result := Format('%-*s',[C9CommentStart, Result]) + ' # ' + Self.FComment;
End;


// デバック用オブジェクト文字列
Function Tu3DBConParam.GetDumpString: String;
Const
  CRLF = (Chr($0d) + Chr($0a));
Begin
  Result :=
      'Server   = [' + Self.FServer + ']' + CRLF
    + 'Database = [' + Self.FDatabase    + ']' + CRLF;

  case Self.DBType of
   k2dbtUnknown:    Result := Result + 'DBType = [Unknown]'  + CRLF;
   k2dbtSQLite:     Result := Result + 'DBType = [SQLite]'   + CRLF;
   k2dbtFirebird:   Result := Result + 'DBType = [Firebird]' + CRLF;
   k2dbtMySQL:      Result := Result + 'DBType = [MySQL]' + CRLF;
  end;

  Result := Result
    + 'SQDialect = ' + IntToStr(Self.SQLDialect) + CRLF
    + 'Comment= [' + Self.FComment   + ']' + CRLF;
End;


// ---------------------------------------------------------------------------

procedure Tu3DBConParam.Load;
Var
  i      : Integer;
  n      : Integer;
  m      : Integer;
  s      : String;
  ss     : String;
  sParam : String;
  AList  : TStringList;
begin
  inherited;

  AList := TStringList.Create();
  Try
    sParam := Trim(Self.FileName);
    if(FileExists(sParam)) then
      AList.LoadFromFile(sParam);

    n := AList.Count - 1;
    for i := 0 to n do begin
      s := Trim(AList.Strings[i]);

      ss := UpperCase(C9ParamName1);
      if(Pos(ss, UpperCase(s)) > 0) then begin
        m := Pos('=', s);
        if(m > 0) then begin
          if(LoadFromString(Copy(s, m + 1, Length(s) - m), ExtractFilePath(Self.FileName))) then
            Exit;
        end;
      end;

      ss := UpperCase(C9ParamName2);
      m := Pos(ss, UpperCase(s));
      if(m > 0) then begin
        m := m + Length(C9ParamName2);
        if(LoadFromString(Copy(s, m, Length(s) - m + 1), ExtractFilePath(Self.FileName))) then
          Exit;
      end;
    end;
  Finally
    if(Assigned(AList)) then
      AList.Free;
  End;
end;


// ---------------------------------------------------------------------------

procedure Tu3DBConParam.Save(AForce: Boolean);
  Function IsEqualsFile: Boolean;
  Var
    AObj: Tu3DBConParam;
  begin
    AObj:= Tu3DBConParam.Create();
    Try
      AObj.Load();

      Result := AObj.IsEqual(Self);
    Finally
      if(Assigned(AObj)) then
        AObj.Free;
    End;
  end;
Var
  i      : Integer;
  n      : Integer;
  m      : Integer;
  s      : String;
  ss     : String;
  sParam : String;
  sBase  : String;
  AList  : TStringList;
begin
  inherited;

  if(NOT AForce) then begin
    if(IsEqualsFile()) then
      Exit;
  end;

  AList := TStringList.Create();
  Try
    sParam := Trim(Self.FileName);
    if(FileExists(sParam)) then
      AList.LoadFromFile(sParam);

    sBase := ExtractFileDir(sParam);

    n := AList.Count - 1;
    for i := 0 to n do begin
      s := Trim(AList.Strings[i]);

      ss := UpperCase(C9ParamName1);
      if(Pos(ss, UpperCase(s)) > 0) then begin
        m := Pos('=', s);
        if(m > 0) then begin
          AList.Strings[i] := C9ParamName1 +'= ' + GetStringFromObj(sBase);

          Try
            AList.SaveToFile(sParam);
          Except
            On E: Exception do begin  ; end;
          End;

          Exit;
        end;
      end;

      ss := UpperCase(C9ParamName2);
      m := Pos(ss, UpperCase(s));
      if(m > 0) then begin
        AList.Strings[i] := C9ParamName1 +'= ' + GetStringFromObj(sBase);

        Try
          AList.SaveToFile(sParam);
        Except
          On E: Exception do begin  ; end;
        End;

        Exit;
      end;
    end;

    // ファイルが空(パラメータが存在しない)
    AList.Add(C9ParamName1 +'= ' + GetStringFromObj(sBase));
    Try
      AList.SaveToFile(sParam);
    Except
      On E: Exception do begin  ; end;
    End;

  Finally
    if(Assigned(AList)) then
      AList.Free;
  End;
end;


// ---------------------------------------------------------------------------



end.


