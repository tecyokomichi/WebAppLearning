unit u4DBUtility;

interface

Uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Data.DB, Vcl.DBGrids;

Type
  Tu4DBUtility = class
  private
  protected
    // 文字圧縮表示
    // CR --> ' ',  LF := '', 及びスペースの圧縮
    class function StripCRLF(const src: String): String;

    // 文字列のサイズ調整(AnsiString)
    class Function ModifyLength(AStr: String; ALen: Integer): String;

    // CSV ファイルの出力
    class Function CsvFileWrite(
      ADst: TDataSet; AFName: String; AIDName: String; ANVisWrite: Boolean = False): String;

  public
    // --------------------------------
    // 日付 文字列の表示  YYYY/MM/DD
    class procedure GridDisplayCriDate(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Blob 文字列の表示を設定
    class procedure SetDataSetBlobDisplay(
      ADst: TDataSet; AName: String; ALen: Integer = 0);

    // Blob 文字列の表示
    class procedure GridDisplayBlobStr(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // WideMemo 文字列の表示を設定(文字列は切らずにDisplayWidth(Default50)を設定する)
    class procedure SetDataSetWideMemoDisplay(
      ADst: TDataSet; AName: String; ADspWidth: Integer = 50);

    // WideMemo 文字列の表示
    class procedure GridDisplayWideMemoStr(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点0桁)
    class procedure GridDisplayFloat0(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点1桁)
    class procedure GridDisplayFloat1(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点2桁)
    class procedure GridDisplayFloat2(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点不定,カンマ有り)
    class procedure GridDisplayFloat3(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点不定,カンマ有り,0を表示しない)
    class procedure GridDisplayFloat4(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点不定,カンマ有り,0を表示する)
    class procedure GridDisplayFloat5(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点不定,カンマ有り,0を表示しない, 最低桁数2)
    class procedure GridDisplayFloat6(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float 文字列の表示(小数点不定,カンマ有り,0を表示する, 最低桁数2)
    class procedure GridDisplayFloat7(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // --------------------------------
    // データセット位置の取得、移動

    // 現在行のIDの取得
    class Function  GetIDentifier(ADst: TDataSet; AIDName: String = ''): Integer; overload;
    class Function  GetIDentifier(ADBGrid: TDBGrid; AIDName: String = ''): Integer; overload;
    class Function  GetFldStrings(ADst: TDataSet; AName: String): String;

    // 指定IDへのジャンプ
    class Function  JumpIDentifier(
      AID: Integer; ADst: TDataSet; AIDName: String = ''): Boolean; overload;

    class Function  JumpIDentifier(
      AID: Integer; ADBGrid: TDBGrid; AIDName: String = ''): Boolean; overload;

    // DBGrid からデータセットを取得する
    class Function GetDataSetFromDBGrid(ADBGrid: TDBGrid): TDataSet;

    // 文字列・浮動小数点変換
    class Function StrToFloatDef(AStr: String; ADefVal: Double = 0.0): Double;

    // フィールドを浮動小数点として取得(無効時の既定値指定)
    class Function FldToFloatDef(AFld: TField; ADefVal: Double = 0.0): Double;


    // TCustomComboBox ID 取得/切替
    class Function GetComboID(ACmb: TCustomComboBox): Integer;
    class Procedure SetComboID(AID: Integer; ACmb: TCustomComboBox);


    // --------------------------------
    // CSV ファイルの出力
    class Function SaveToCsvFile(
      ADst: TDataSet; AIDName: String; ADefName: String;
      ADispMsg: Boolean = False; ANVisWrite: Boolean = False): String;
  end;

implementation

Uses
  Winapi.Windows,
  Vcl.Dialogs,
  u7ZtoHConv;


// Tu4DBUtility
// ---------------------------------------------------------------------------

// 文字圧縮表示
// CR --> ' ',  LF := '', 及びスペースの圧縮
class function Tu4DBUtility.StripCRLF(const src: String): String;
Var
  i, j, n: Integer;
begin
  Result := '';

  n := Length(src);
  i := 1;
  While (i <= n) Do Begin
    If(src[i] > Char($ff)) Then Begin
      If(src[i] = '　') then Begin  // 全角スペース
        Result := Result + ' ';
        i := i + 1;
        continue;
      End Else If((src[i] >= '０') and (src[i] <= '９')) Then Begin // 全角数字
        Result := Result + Char(Ord(src[i]) - Ord('０') + Ord('0'));
        i := i + 1;
        continue;
      End Else If((src[i] >= 'Ａ') and (src[i] <= 'Ｚ')) Then Begin // 全角数字
        Result := Result + Char(Ord(src[i]) - Ord('Ａ') + Ord('A'));
        i := i + 1;
        continue;
      End Else If((src[i] >= 'ａ') and (src[i] <= 'ｚ')) Then Begin // 全角数字
        Result := Result + Char(Ord(src[i]) - Ord('ａ') + Ord('a'));
        i := i + 1;
        continue;
      End;

      Result := Result + src[i];
      i := i + 1;

    End Else Begin

      j := Ord(src[i]);
      Case j Of

        $0a: Begin  ; End;  // 読み飛ばし

        $20, $0d, $08:
          Begin
            j := Length(Result);
            If(j > 0) Then Begin
              If(Result[j] <> ' ') then Begin
                Result := Result + ' ';
              End;
            End;
          End;
       Else
         Result := Result + src[i];
       End;

      i := i + 1;
    End;
  End;

  Result := Trim(Result);
end;


// 文字列のサイズ調整(AnsiString)
class Function Tu4DBUtility.ModifyLength(AStr: String; ALen: Integer): String;
Var
  i : Integer;
  n : Integer;
  l : Integer;
Begin
  Result := '';
  if(ALen <= 0) then
    Exit;

  n := Length(AStr);
  l := 0;
  for i := 1 to n do begin
    if(AStr[i] >= Chr($ff)) then begin
      if((l + 2) > ALen) then
        Exit;

      Result := Result + AStr[i];
      l := l + 2;
    end else begin
      Result := Result + AStr[i];
      l := l + 1;
    end;

    if(l >= ALen) then
      Break;
  end;
End;


class procedure Tu4DBUtility.GridDisplayBlobStr(
  Sender: TField; var Text: String; DisplayText: Boolean);
Begin
  If(DisplayText) then begin
    //Text := ModifyLength(  // StripCRLF(Sender.AsAnsiString), Sender.DisplayWidth);
    //Text := ModifyLength(StripCRLF(Sender.AsWideString), Sender.DisplayWidth);

    Text := ModifyLength(
      Tu7ZtoHConv.AllLfCodeRemoved(Sender.AsString), Sender.DisplayWidth);

  End Else Begin
    Text := Sender.AsString;
  End;
End;


// WideMemo 文字列の表示を設定(文字列は切らずにDisplayWidth(Default50)を設定する)
class procedure Tu4DBUtility.SetDataSetWideMemoDisplay(
  ADst: TDataSet; AName: String; ADspWidth: Integer = 50);
Var
  fld : TField;
Begin
  if(NOT Assigned(ADst)) then
    Exit;

  fld := ADst.FindField(AName);
  if(Assigned(fld)) then begin
    fld.DisplayWidth := ADspWidth;

    fld.OnGetText := GridDisplayWideMemoStr;
  end;
End;


class procedure Tu4DBUtility.GridDisplayWideMemoStr(
  Sender: TField; var Text: String; DisplayText: Boolean);
Begin
  If(DisplayText) then begin
    Text := Tu7ZtoHConv.AllLfCodeRemoved(Sender.AsString);

  End Else Begin
    Text := Sender.AsString;
  End;
End;


// Float 文字列の表示(小数点0桁)
class procedure Tu4DBUtility.GridDisplayFloat0(
  Sender: TField; var Text: String; DisplayText: Boolean);
Var
  f : Double;
begin
  If(DisplayText) then begin
    if(Sender.AsString <> '')
    then f := Sender.AsFloat
    else f := 0.0;

    if(Abs(f) >= 0.01)
    then Text := Format('%.0n', [f])
    else Text := '';
  End Else Begin
    Text := Sender.AsString;
  End;
end;


// Float 文字列の表示(小数点1桁)
class procedure Tu4DBUtility.GridDisplayFloat1(
  Sender: TField; var Text: String; DisplayText: Boolean);
Var
  f : Double;
begin
  If(DisplayText) then begin
    if(Sender.AsString <> '')
    then f := Sender.AsFloat
    else f := 0.0;

    if(Abs(f) >= 0.01)
    then Text := Format('%.1n', [f])
    else Text := '';

  End Else Begin
    Text := Sender.AsString;
  End;
end;



// Float 文字列の表示(小数点2桁)
class procedure Tu4DBUtility.GridDisplayFloat2(
  Sender: TField; var Text: String; DisplayText: Boolean);
Var
  f : Double;
begin
  If(DisplayText) then begin
    if(Sender.AsString <> '')
    then f := Sender.AsFloat
    else f := 0.0;

    if(Abs(f) >= 0.01)
    then Text := Format('%.2n', [f])
    else Text := '';

  End Else Begin
    Text := Sender.AsString;
  End;
end;


class procedure Tu4DBUtility.SetDataSetBlobDisplay(
  ADst: TDataSet; AName: String; ALen: Integer);
Var
  fld : TField;
Begin
  if(NOT Assigned(ADst)) then
    Exit;

  fld := ADst.FindField(AName);
  if(Assigned(fld)) then begin
    if(ALen > 0) then
      fld.DisplayWidth := ALen;

    fld.OnGetText := GridDisplayBlobStr;
  end;
End;


// Float 文字列の表示(小数点不定,カンマ有り)
class procedure Tu4DBUtility.GridDisplayFloat3(
  Sender: TField; var Text: String; DisplayText: Boolean);
var
  s  : String;
  s1 : String;
  s2 : String;
  cmp : TComponent;
begin
  cmp := Sender.GetParentComponent;

  if TDataSet(cmp).RecordCount <= 0 then
    Exit;

  Text := '';
  if Sender.AsString <> '' then
  begin
    s  := Sender.AsString;
    if StrToFloatDef(s, 0) <> 0 then
    begin
      if pos('.', s) > 0 then
      begin
        s1 := copy(s, pos('.', s) + 1, Length(s));
        s2 := copy(s, 1, pos('.', s) - 1);
        Text := FormatFloat('#,##0', StrToFloat(s2)) + '.' + s1;
      end else
        Text := FormatFloat('#,##0', StrToFloat(s));
    end else
    begin
      if s = '0' then
        Text := s;
    end;
  end;
end;


// Float 文字列の表示(小数点不定,カンマ有り,0を表示しない)
class procedure Tu4DBUtility.GridDisplayFloat4(
  Sender: TField; var Text: String; DisplayText: Boolean);
var
  s   : String;
  s1  : String;
  s2  : String;
  cmp : TComponent;
begin
  cmp := Sender.GetParentComponent;

  if TDataSet(cmp).RecordCount <= 0 then
    Exit;

  Text := '';
  if Sender.AsString <> '' then
  begin
    s  := Sender.AsString;
    if StrToFloatDef(s, 0) <> 0 then
    begin
      if pos('.', s) > 0 then
      begin
        s1 := copy(s, pos('.', s) + 1, Length(s));
        s2 := copy(s, 1, pos('.', s) - 1);
        Text := FormatFloat('#,##0', StrToFloat(s2)) + '.' + s1;
      end else
        Text := FormatFloat('#,##0', StrToFloat(s));
    end;
  end;
end;

// Float 文字列の表示(小数点不定,カンマ有り,0を表示する)
class procedure Tu4DBUtility.GridDisplayFloat5(
  Sender: TField; var Text: String; DisplayText: Boolean);
var
  s  : String;
  s1 : String;
  s2 : String;
  cmp : TComponent;
begin
  cmp := Sender.GetParentComponent;

  if TDataSet(cmp).RecordCount <= 0 then
    Exit;

  Text := '0';
  if Sender.AsString <> '' then
  begin
    s  := Sender.AsString;
    if StrToFloatDef(s, 0) <> 0 then
    begin
      if pos('.', s) > 0 then
      begin
        s1 := copy(s, pos('.', s) + 1, Length(s));
        s2 := copy(s, 1, pos('.', s) - 1);
        Text := FormatFloat('#,##0', StrToFloat(s2)) + '.' + s1;
      end else
        Text := FormatFloat('#,##0', StrToFloat(s));
    end;
  end;
end;

// Float 文字列の表示(小数点不定,カンマ有り,0を表示しない, 最低桁数2)
class procedure Tu4DBUtility.GridDisplayFloat6(
  Sender: TField; var Text: String; DisplayText: Boolean);
var
  s  : String;
  s1 : String;
  s2 : String;
  cmp : TComponent;
begin
  cmp := Sender.GetParentComponent;

  if TDataSet(cmp).RecordCount <= 0 then
    Exit;

  Text := '';
  if Sender.AsString <> '' then
  begin
    s  := Sender.AsString;
    if StrToFloatDef(s, 0) <> 0 then
    begin
      Text := FormatFloat('#,##0.00', StrToFloat(s));
      if pos('.', s) > 0 then
      begin
        s1 := copy(s, pos('.', s) + 1, Length(s));
        if Length(s1) > 2  then
        begin
          s2 := copy(s, 1, pos('.', s) - 1);
          Text := FormatFloat('#,##0', StrToFloat(s2)) + '.' + s1;
        end;
      end;
    end;
  end;
end;

// Float 文字列の表示(小数点不定,カンマ有り,0を表示する, 最低桁数2)
class procedure Tu4DBUtility.GridDisplayFloat7(
  Sender: TField; var Text: String; DisplayText: Boolean);
var
  s  : String;
  s1 : String;
  s2 : String;
  cmp : TComponent;
begin
  cmp := Sender.GetParentComponent;

  if TDataSet(cmp).RecordCount <= 0 then
    Exit;

  Text := '0.00';
  if Sender.AsString <> '' then
  begin
    s  := Sender.AsString;
    if StrToFloatDef(s, 0) <> 0 then
    begin
      Text := FormatFloat('#,##0.00', StrToFloat(s));
      if pos('.', s) > 0 then
      begin
        s1 := copy(s, pos('.', s) + 1, Length(s));
        if Length(s1) > 2  then
        begin
          s2 := copy(s, 1, pos('.', s) - 1);
          Text := FormatFloat('#,##0', StrToFloat(s2)) + '.' + s1;
        end;
      end;
    end;
  end;
end;

// 日付 文字列の表示  YYYY/MM/DD
class procedure Tu4DBUtility.GridDisplayCriDate(
  Sender: TField; var Text: String; DisplayText: Boolean);
Var
  dt : TDateTime;
begin
  if(DisplayText) then begin
    if(Trim(Sender.AsString) <> '') then begin
      Try
        dt := Sender.AsDateTime;
        Text := FormatDateTime('YYYY/MM/DD', dt);
      Except
        On E: Exception do begin
          Text := '';
        end;
      End;
    end else begin
      Text := '';
    end;
  end else begin
    Text := Sender.AsString;
  end;
end;

// ---------------------------------------------------------------------------

class Function Tu4DBUtility.CsvFileWrite(
  ADst: TDataSet; AFName: String; AIDName: String; ANVisWrite: Boolean): String;

  Function GetTilteString(ADst: TDataSet; ANVisWrite: Boolean): String;
  Var
    i, n : Integer;
    fld  : TField;
  Begin
    Result := '';

    n := ADst.FieldCount - 1;
    for i := 0 to n do begin
      fld := ADst.Fields[i];
      if(Assigned(fld)) then begin
        if((fld.Visible)
          or (ANVisWrite)) then
        begin
          Result := '"' + Tu7ZtoHConv.AllLfCodeRemoved(fld.DisplayLabel) +'"';
          Break;
        end;
      end;
    end;

    i := i + 1;
    while (i <= n) do begin
      fld := ADst.Fields[i];
      if(Assigned(fld)) then begin
        if((fld.Visible)
          or (ANVisWrite)) then
        begin
          Result := Result + ',"' + Tu7ZtoHConv.AllLfCodeRemoved(fld.DisplayLabel) +'"';
          //Break;
        end;
      end;

      i := i + 1;
    end;
  End;
  Function GetFieldString(AFld: TField): String;
  Begin
    case AFld.DataType of
     ftString,     // 文字または文字列項目
     ftBlob,       // バイナリ大規模オブジェクト型項目
     ftMemo,       // テキストメモ項目
     ftWideMemo,   // テキストワイドメモ項目
     ftWideString: // ワイド文字項目
       Result := '"' + Tu7ZtoHConv.AllLfCodeRemoved(AFld.AsString) +'"';

     ftSmallint,  // 16 ビット整数項目
     ftInteger,   // 32 ビット整数項目
     ftWord:      // 16 ビット符号なし整数項目
       Result := IntToStr(AFld.AsInteger);

     ftSingle,
     ftFloat:     // 浮動小数点数値型項目
       Result := Format('%.4f', [AFld.AsFloat]);

     //ftBoolean	論理型項目
     //ftCurrency	金額型項目
     //ftBCD	2 進化 10 進数型項目

     ftDate,      // 日付型項目
     ftDateTime: // 日付/時刻型項目
       begin
         if AFld.AsDatetime > 0 then
           Result := '"' + FormatDateTime('YYYY/MM/DD', AFld.AsDatetime) + '"'
         else
           Result := '';
       end;
     ftTime:     // 時刻型項目
       Result := '"' + FormatDateTime('HH:NN:SS', AFld.AsDatetime) + '"';

     //ftBytes	固定長バイト型項目（バイナリ格納）
     //ftVarBytes	可変長バイト型項目（バイナリ格納）
     //ftAutoInc	自動インクリメント 32 ビット整数カウンタ型項目

     //ftGraphic	ビットマップ項目
     //ftFmtMemo	書式付きメモ項目
     //ftParadoxOle	Paradox OLE 項目
     //ftDBaseOle	dBASE OLE 項目
     //ftTypedBinary	型付きバイナリ項目
     //ftCursor	Oracle ストアドプロシージャの出力カーソル（TParam のみ）
     //ftFixedChar	固定長文字型項目
     //ftWideString	ワイド文字項目
     //ftLargeint	32 ビット整数項目
     //ftADT	抽象データ型項目
     //ftArray	配列項目
     //ftReference	参照項目
     //ftDataSet	データセット項目

     //ftOraBlob	Oracle 8 テーブルの BLOB 項目
     //ftOraClob	Oracle 8 テーブルの CLOB 項目
     //ftVariant	未定義または確定していない型のデータ
     //ftInterface	インターフェース (IUnknown) への参照
     //ftIDispatch	IDispatch インターフェースへの参照
     //ftGuid	GUID (Globally Unique Identifier) 値

    else   // case-else
      // ftUnknown	未知または未定
      Result := '';
    end;
  End;
  Function GetDetailString(ADst: TDataSet; ANVisWrite: Boolean): String;
  Var
    i, n : Integer;
    fld  : TField;
  Begin
    Result := '';

    n := ADst.FieldCount - 1;
    for i := 0 to n do begin
      fld := ADst.Fields[i];
      if(Assigned(fld)) then begin
        if((fld.Visible)
          or (ANVisWrite)) then
        begin
          Result := GetFieldString(fld);
          Break;
        end;
      end;
    end;

    i := i + 1;
    while (i <= n) do begin
      fld := ADst.Fields[i];
      if(Assigned(fld)) then begin
        if((fld.Visible)
          or (ANVisWrite)) then
        begin
          Result := Result + ',' + GetFieldString(fld);
          //Break;
        end;
      end;

      i := i + 1;
    end;
  End;
  Function GetSaveFileName(ATitle, AName: String; ABase: String = ''): String;
  Var
    dlg      : TSaveDialog;
    fName    : String;
    fOffName : String;
  begin
    Result := AName;

    dlg := TSaveDialog.Create(Nil);
    Try
      if(ATitle <> '')
      then dlg.Title := ATitle
      else dlg.Title := '書込みファイルの指定';

      dlg.Filter := 'All files (*.*)|*.*';
      dlg.FilterIndex := 1;
      dlg.Options := [ofOverwritePrompt,ofEnableSizing,ofHideReadOnly];

      If(FileExists(ExpandUNCFileName(AName))) then Begin
        dlg.FileName   := ExpandUNCFileName(AName);
        dlg.InitialDir := ExtractFileDir(dlg.FileName);
        dlg.FileName   := ExtractFileName(dlg.FileName);
      end else if(Trim(ABase) = '') then begin
        dlg.FileName   := ExpandUNCFileName(AName);
        dlg.InitialDir := ExtractFileDir(dlg.FileName);
        dlg.FileName   := ExtractFileName(dlg.FileName);
      end Else BEgin
        dlg.FileName   := AName;
        dlg.InitialDir := ABase;
      End;

      If(dlg.Execute) then Begin
        fName := ExpandUNCFileName(dlg.FileName);

        If(Trim(ABase) <> '')
        then fOffName := ExtractRelativePath(ABase + '\',fName)
        else fOffName := fName;

        Result := fOffName;
      end else begin
        Result := '';
      End;

    Finally
      If(Assigned(dlg)) then
        dlg.Free;
    End;
  End;
  Function GetIdentifier(ADst: TDataSet; AIDName: String): Integer;
  Var
    fld : TField;
  Begin
    Result := -1;
    if(NOT Assigned(Self)) then
      Exit;

    If(NOT Assigned(ADst)) then
      Exit;

    If(ADst.State = dsInactive) then
      Exit;

    If(ADst.RecordCount <= 0) then
      Exit;

    fld := ADst.FindField(AIDName);
    If(Assigned(fld)) then
      Result := StrToIntDef(fld.AsString,-1);
  End;
  Function JumpIdentifier(AID: Integer; ADst: TDataSet; AIDName: String): Boolean;
  Begin
    Result := False;

    If(NOT Assigned(ADst)) then
      Exit;

    If(ADst.State = dsInactive) then
      Exit;

    If(ADst.RecordCount <= 0) then
      Exit;

    Result := ADst.Locate(AIDName, AID, []);
  End;
Var
  nID   : Integer;
  s     : String;
  sFile : String;
  sl    : TStringList;
Begin
  Result := '';
  sFile := GetSaveFileName('CSVファイルの出力', AFName);

  if(Trim(sFile) = '') then
    Exit;

  // ShowMessage('[' + sFile + ']');

  nID := GetIdentifier(ADst, AIDName);
  ADst.DisableControls;
  Try
    sl := TStringList.Create();
    Try
      s := Trim(GetTilteString(ADst, ANVisWrite));
      if(s = '') then
        Exit;

      sl.Add(s);

      ADst.First;
      while (NOT ADst.Eof) do begin
        sl.Add(GetDetailString(ADst, ANVisWrite));

        ADst.Next;
      end;

      if(sl.Text <> '') then begin
        Try
          sl.SaveToFile(sFile);
          Result := sFile;

          // System.SysUtils.Beep();
        Except
          on E: Exception do begin  ShowMessage(E.Message); end;
        end;
      end;
    Finally
      if(Assigned(sl)) then
        sl.Free;
    End;
  Finally
    JumpIdentifier(nID, ADst, AIDName);
    ADst.EnableControls;
  End;
End;


// ---------------------------------------------------------------------------
// データセット位置の取得、移動

// 現在行のIDの取得
class Function Tu4DBUtility.GetIDentifier(
  ADst: TDataSet; AIDName: String): Integer;
Var
  SID : String;
  fld : TField;
Begin
  Result := -1;
  if(NOT Assigned(ADst)) then
    Exit;

  if(ADst.State = dsInactive) then
    Exit;

  if(ADst.RecordCount <= 0) then
    Exit;

  sID := Trim(AIDName);
  if(sID = '') then
    sID := 'id';

  fld := ADst.FindField(sID);
  if(Assigned(fld)) then
    Result := StrToIntDef(fld.AsString, Result);
end;


class Function Tu4DBUtility.GetIDentifier(ADBGrid: TDBGrid; AIDName: String): Integer;
begin
  Result := GetIDentifier(GetDataSetFromDBGrid(ADBGrid), AIDName);
end;


class Function Tu4DBUtility.GetFldStrings(ADst: TDataSet; AName: String): String;
Var
  SID : String;
  fld : TField;
Begin
  Result := '';
  if(NOT Assigned(ADst)) then
    Exit;

  if(ADst.State = dsInactive) then
    Exit;

  if(ADst.RecordCount <= 0) then
    Exit;

  sID := Trim(AName);
  if(sID = '') then
    Exit;

  fld := ADst.FindField(sID);
  if(Assigned(fld)) then
    Result := fld.AsString;
end;


// ------------------------------------

// 指定IDへのジャンプ
class Function Tu4DBUtility.JumpIDentifier(
  AID: Integer; ADst: TDataSet; AIDName: String): Boolean;
Var
  sID : String;
Begin
  Result := False;
  if((AID = 0)
    or (AID = -1))
  then
    Exit;

  if(NOT Assigned(ADst)) then
    Exit;

  if(ADst.State = dsInactive) then
    Exit;

  if(ADst.RecordCount <= 0) then
    Exit;

  Try
    sID := Trim(AIDName);
    if(sID = '') then
      sID := 'id';

    Result := ADst.Locate(sID, AID, [loCaseInsensitive, loPartialKey]);
  Except
    On E: Exception do begin  ; end;
  End;
End;


class Function Tu4DBUtility.JumpIDentifier(
  AID: Integer; ADBGrid: TDBGrid; AIDName: String): Boolean;
begin
  Result := JumpIDentifier(AID, GetDataSetFromDBGrid(ADBGrid), AIDName);
end;


// ------------------------------------

// DBGrid からデータセットを取得する
class Function Tu4DBUtility.GetDataSetFromDBGrid(ADBGrid: TDBGrid): TDataSet;
begin
  Result := Nil;

  if(Assigned(ADBGrid)) then begin
    if(Assigned(ADBGrid.DataSource)) then begin
      if(Assigned(ADBGrid.DataSource.DataSet)) then begin

        //if(ADBGrid.DataSource.DataSet.State <> dsInactive) then
        Result := ADBGrid.DataSource.DataSet;
      end;
    end;
  end;
end;


// ---------------------------------------------------------------------------

// 文字列・浮動小数点変換
class Function Tu4DBUtility.StrToFloatDef(AStr: String; ADefVal: Double): Double;
Var
  s: String;
begin
  s := Trim(AStr);
  if(s = '') then begin
    Result := ADefVal;
    Exit;
  end;

  Try
    Result := StrToFloat(s);
  Except
    On E: Exception do begin
      Result := ADefVal;
    end;
  End;
end;

// フィールドを浮動小数点として取得(無効時の既定値指定)
class Function Tu4DBUtility.FldToFloatDef(
  AFld: TField; ADefVal: Double): Double;
Begin
  if(NOT Assigned(AFld)) then begin
    Result := ADefVal;
    Exit;
  End;

  Try
    if(Trim(AFld.AsString) <> '')
    then Result := AFld.AsFloat
    else Result := ADefVal;
  Except
    On E: Exception Do begin
      Result := ADefVal;
      Exit;
    End;
  End;
End;


// ---------------------------------------------------------------------------
// TCustomComboBox ID 取得/切替

class Function Tu4DBUtility.GetComboID(ACmb: TCustomComboBox): Integer;
Begin
  Result := 0;

  If(NOT Assigned(ACmb)) then
    Exit;

  If(ACmb.ItemIndex >= 0) then
    Result := Integer(ACmb.Items.Objects[ACmb.ItemIndex]);
End;


class Procedure Tu4DBUtility.SetComboID(AID: Integer; ACmb: TCustomComboBox);
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

// CSV ファイルの出力
class Function Tu4DBUtility.SaveToCsvFile(
  ADst: TDataSet; AIDName: String;
  ADefName: String; ADispMsg, ANVisWrite: Boolean): String;

  // フォルダ存在のチェックと無い場合の作成
  Procedure CheckAndCreateLocalFolder(sName: String);
    Function IsExistLocalFolder( sName : String ) : Boolean;
    Begin
      Result := DirectoryExists(sName);
    End;
  Var
    n  : Integer;
    sB : String;  // ベース(解決部分)
    sE : String;  // チェック(未解決部分)
  Begin
    sB := '';
    sE := '';

    n := Pos( '\\', sName );
    If( n > 0 ) then Begin  // 共有ファイル
      sB := '\\';
      sE := Copy(sName,3,Length(sName) - 2);

      n := Pos(':',sE);
      If( n > 0 ) Then Begin
        n := Pos('\',sE);

        If( n > 0 ) then Begin
          sB := sB + Copy(sE,1, n - 1);
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( 'フォルダ解決に失敗しました。[' + sName + ']' );
        End;

        n := Pos('\',sE);
        If( n > 0 ) Then Begin
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( 'フォルダ解決に失敗しました。[' + sName + ']' );
        End;

      End Else Begin
        n := Pos('\',sE);
        If( n > 0 ) then Begin
          sB := sB + Copy(sE,1, n - 1);
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( 'フォルダ解決に失敗しました。[' + sName + ']' );
        End;
      End;
    End Else Begin
      n := Pos( '//', sName );
      If( n > 0 ) Then Begin
        sB := '\\';
        sE := Copy(sName,3,Length(sName) - 2);

        n := Pos('/',sE);
        If( n > 0 ) Then Begin
          sB := sB + Copy(sE,1,n - 1);
          sE := Copy(sE,n + 1, Length(sE) - n );
        End Else Begin
          Raise Exception.Create( 'フォルダ解決に失敗しました。[' + sName + ']' );
        End;

        n := Pos(':',sE);
        If( n > 0 ) Then Begin
          n := Pos('\',sE);
          If( n > 0 ) Then Begin
            sE := Copy(sE,n + 1, Length(sE) - n);
          End Else Begin
            Raise Exception.Create( 'フォルダ解決に失敗しました。[' + sName + ']' );
          End;
        End;
      End Else Begin
        sB := '';
        sE := sName;

        n := Pos('\',sE);
        If( n = 1 ) then Begin
          sB := '\';
          sE := Copy(sE,n + 1,Length(sE) - n );
        end else if (n = 0) then begin

          // ルートフォルダの指定時
          if((Length(sE) >= 2)
            AND (UpperCase(sE[1]) >= 'A')
            AND (UpperCase(sE[1]) <= 'Z')
            AND (UpperCase(sE[2]) = ':')) then
          begin
            sB := sName;
            sE := '';
          End;
        End;
      End;
    End;

    While( Length(sE) > 0 ) Do Begin
      // フォルダを１つ進める
      n := Pos('\',sE);

      If( n > 0 ) Then Begin
        If( Length(sB) > 1 ) Then Begin
          sB := sB + '\' + Copy(sE,1,n - 1);
        End Else Begin
          sB := sB + Copy(sE,1,n - 1);
        End;
        sE := Copy(sE,n + 1, Length(sE) - n);
      End Else Begin
        sB := sB + '\' + sE;
        sE := '';
      End;

      // フォルダの確認及び無い場合の生成
      If(IsExistLocalFolder(sB) = FALSE) then Begin
        If( CreateDir(sB) = FALSE ) Then Begin  // フォルダ生成
          Raise Exception.Create( 'フォルダ作成に失敗しました。[' + sB + ']' );
        End;
      End;
    End;
  End;
Var
  s         : String;
  sFileName : String;
begin
  Result := '';
  if(NOT Assigned(ADst)) then
    Exit;

  if(ADst.State = dsInactive) then
    Exit;

  if(ADst.RecordCount <= 0) then
    Exit;

  sFileName := Trim(ADefName);
  if(sFileName = '') then begin
    sFileName := FormatDateTime('YYYYMMDD', Now());
    sFileName := ChangeFileExt(sFileName, '.csv');
  end;

  // フォルダが存在しない場合の作成
  if(Trim(sFileName) <> '') then
    CheckAndCreateLocalFolder(ExtractFileDir(sFileName));

  s := '';
  Try
    //ADst := dbgList.DataSource.DataSet;
    if(Assigned(ADst)) then begin
      if(ADst.State <> dsInactive) then begin
        if(ADst.RecordCount > 0) then begin
          Try
            s := Trim(CsvFileWrite(ADst, sFileName, AIDName, ANVisWrite));

            if(ADispMsg) then begin
              if(s <> '') then
                ShowMessage('ファイル [' + s + '] を出力しました。');
            end;
          Except
            On E: Exception do begin
              System.SysUtils.Beep();
              ShowMessage(E.Message);
              s := '';
            end;
          End;
        end;
      end;
    end;
  Finally
    Result := s;
  End;
end;


// ---------------------------------------------------------------------------

end.

