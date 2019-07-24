unit ServerMethodsUnit1;

interface

uses System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth, DataSnap.DSProviderDataModuleAdapter,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Stan.StorageBin, FireDAC.Stan.StorageJSON, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.UI,
  Data.FireDACJSONReflect, FireDAC.Phys.IBBase, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, IPPeerClient, IPPeerServer, Datasnap.DBClient,
  Datasnap.Win.MConnect, Datasnap.Win.SConnect, Datasnap.DSCommonServer,
  Datasnap.DSHTTP, Datasnap.DSHTTPWebBroker, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope;

Type  // 2015/07/06
  TEvt7AddErrEvt = Procedure(AMeg: String) of object;

type
{$METHODINFO ON}
  TServerMethods1 = class(TDataModule)
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery1: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDQuery2: TFDQuery;
    FDConnection1: TFDConnection;
    FDSchemaAdapter1: TFDSchemaAdapter;
    procedure DataModuleCreate(Sender: TObject);

  private   // private 宣言
    function GetTblName(sSQLid: Integer): String;
    function GetTblName2(ssql: String): String;
    function GetsSQL(sSQLid: Integer): String;
    procedure SetSQL(ssql: String; var qry: TFDQuery);
    Function GenQuery: TFDQuery;
    class Procedure PrepareFreeDataSet(ADataSet: TComponent);


  public   // public 宣言
    function IniSetConnection: Boolean;  // function IniSetConnection(dbsv, dtbs, usnm, pswd: String): Boolean;

    function GetServerQuery(sno: Integer; var tblnm: String): TFDJSONDataSets;
    function GetServerQuery2(ssql: String; var tblnm: String): TFDJSONDataSets;
    function GetDataSetOnSQL(ssql: String): TDataSet;

    procedure ApplyChangesToServer(tblnm: String; dltslst: TFDJSONDeltas);
    procedure ApplyChangesToServer2(tblnm: String; dltslst: TFDJSONDeltas);

    Function ExecuteQuery(ASQLs: String): Boolean;
    Function ApplyChangesToServer3(tblnm, slsql: String; dltslst: TFDJSONDeltas): Boolean;

//    procedure Get(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
//    [ResourceSuffix('{item}')]
//    procedure GetItem(const AContext: TEndpointContext; const ARequest: TEndpointRequest; const AResponse: TEndpointResponse);
  end;
{$METHODINFO OFF}

  // DB接続パラメータの初期化
  Procedure InitialConnectionParam;

  // エラーメッセージの表示と登録処理関連の処理
  Procedure SetLogWriteEvt(AEvt: TEvt7AddErrEvt);               // 2015/07/06 イベントメソッドの設定
  Procedure DoErrorLogWrite(AMsg: String; ErrCD: Integer = 0);  // 2015/07/06 エラーメッセージの表示と保存

var
  ServerMethods1: TServerMethods1;

implementation

{$R *.dfm}

uses
  System.StrUtils,
  u3DBConParam, u6DBConnUtil;  //   u3DBConParam, u4DBUtility;


// Test Use  // TStringList() を使用してテスト結果をファイル出力
// {$DEFINE C9TestDump}


Var  // 2015/06/08
  F9LogWriteEvt : TEvt7AddErrEvt;       // 2015/07/06
  F9DBConnParam : Tu3DBConParam = Nil;  // 2015/11/26


procedure TServerMethods1.DataModuleCreate(Sender: TObject);
begin
  // 2015/06/08  2015/11/30

//  IniSetConnection();
end;

function TServerMethods1.IniSetConnection: Boolean;
begin
  if(NOT Assigned(F9DBConnParam)) then begin
    Result := False;
    DoErrorLogWrite('IniSetConnection(): Param error.');
    Exit;
  end;

  try
    if(Self.FDConnection1.Connected) then
      FDConnection1.Close();

    // TFDConnection のパラメータによる初期化
    Tu6DBConnUtil.InintialFDConnection(FDConnection1, F9DBConnParam);

    Self.FDConnection1.Open();   // Open() の成否によりパラメータをチェック
    Self.FDConnection1.Close();
    Result := True;
  except
    on E: Exception do begin
      DoErrorLogWrite('IniSetConnection(): ' + E.Message);
      Result := False;
    end;
  end;
end;

function TServerMethods1.GetServerQuery(sno: Integer; var tblnm: String): TFDJSONDataSets;
var
  oStr: TMemoryStream;
begin
  oStr := TMemoryStream.Create;
  try
    Result := TFDJSONDataSets.Create;
    tblnm := GetTblName(sno);
    SetSQL(GetsSQL(sno), FDQuery1);
    TFDJSONDataSetsWriter.ListAdd(Result, tblnm, FDQuery1);
    FDQuery1.Open();
    FDSchemaAdapter1.SaveToStream(oStr, TFDStorageFormat.sfJSON);
  except
    oStr.Free;
    raise;
  end;
end;

function TServerMethods1.GetServerQuery2(ssql: String; var tblnm: String): TFDJSONDataSets;
begin
    Result := TFDJSONDataSets.Create;
    tblnm := GetTblName2(ssql);
    SetSQL(ssql, FDQuery2);
    TFDJSONDataSetsWriter.ListAdd(Result, tblnm, FDQuery2);
end;

function TServerMethods1.GetDataSetOnSQL(ssql: String): TDataSet;
begin
  SetSQL(ssql, FDQuery2);
  FDQuery2.Active := True;
  Result := FDQuery2;
end;

procedure TServerMethods1.ApplyChangesToServer(tblnm: String; dltslst: TFDJSONDeltas);
var
  LApply: IFDJSONDeltasApplyUpdates;
begin
  LApply := TFDJSONDeltasApplyUpdates.Create(dltslst);
  LApply.ApplyUpdates(tblnm, FDQuery1.Command);

  if LApply.Errors.Count > 0 then begin
    //raise Exception.Create(LApply.Errors.Strings.Text);

    // 2015/07/06
    DoErrorLogWrite('JSON Error' + LApply.Errors.Strings.Text);
  end;
end;

procedure TServerMethods1.ApplyChangesToServer2(tblnm: String; dltslst: TFDJSONDeltas);
var
  LApply: IFDJSONDeltasApplyUpdates;
begin
  LApply := TFDJSONDeltasApplyUpdates.Create(dltslst);
  LApply.ApplyUpdates(tblnm, FDQuery2.Command);

  if LApply.Errors.Count > 0 then begin
    //raise Exception.Create(LApply.Errors.Strings.Text);

    // 2015/07/06
    DoErrorLogWrite('JSON Error' + LApply.Errors.Strings.Text);
  end;
end;

procedure TServerMethods1.SetSQL(ssql: String; var qry: TFDQuery);
begin
  if qry.Active then
    qry.Close;
  qry.SQL.BeginUpdate;
  try
    qry.SQL.Clear;
    qry.SQL.Add(ssql);
  finally
    qry.SQL.EndUpdate;
  end;
  try
    qry.Open;
    qry.FetchAll;
  Except
    On E:Exception do begin
      // 2015/07/06
      DoErrorLogWrite('Open Error' + E.Message);
    end;
  end;
end;

function TServerMethods1.GetsSQL(sSQLid: Integer): String;
//const
//  dfdate: String = '2015/01/01';  // 2015/11/30  Dummy
begin
  case sSQLid of
  2: Result := 'select * from srm';
  1: Result := 'select * from tom';


//   101: Result := 'select * from rui where sale_date >= "' + dfdate + '" order by sale_date,shipping_no,line_no';  // 2015/11/30 Dummy
  end;
end;

function TServerMethods1.GetTblName(sSQLid: Integer): String;
var
  i, j: Integer;
  ssql: String;
begin
  Result := '';
  if sSQLid > 0
  then ssql := GetsSQL(sSQLid)
  else ssql := FDQuery1.SQL.Text;   // FDQuery1　に書かれたSQL文で実行
  if ssql = '' then Exit;
  i := Pos('FROM', UpperCase(ssql));
  if i = 0 then Exit;
  i := i + 5;
  for j := i to Length(ssql) do if ssql[j] = ' ' then break;
  Result := Copy(ssql, i, j - i);
end;

function TServerMethods1.GetTblName2(ssql: String): String;
var
  i, j: Integer;
begin
  Result := '';
  if ssql = '' then Exit;
  i := Pos('FROM', UpperCase(ssql));
  if i = 0 then Exit;
  i := i + 5;
  for j := i to Length(ssql) do if ssql[j] = ' ' then break;
  Result := Copy(ssql, i, j - i);
end;


// ---------------------------------------------------------------------------

Function TServerMethods1.GenQuery: TFDQuery;
begin
  Result := TFDQuery.Create(Nil);

  if(Assigned(Result)) then begin
    Result.Connection := FDConnection1;
  end;
end;


class Procedure TServerMethods1.PrepareFreeDataSet(ADataSet: TComponent);
  procedure CloseDBObject(ADB: TCustomConnection);
  Begin
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
  End;
Var
  DstQ : TFDQuery;
  DstT : TFDTable;
  DstC : TFDCommand;
begin
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
end;


// ---------------------------------------------------------------------------

// DataSet 取得を含まない、DB更新 SQL の実行
function TServerMethods1.ExecuteQuery(ASQLs: String): Boolean;
Var
  Query : TFDQuery;
begin
  Result := False;

  Query := GenQuery();
  Try
    Try
      Query.SQL.Text := ASQLs;

      Query.ExecSQL();
      Result := True;
    Except
      On E: Exception do begin
        // Result := False;
        DoErrorLogWrite('ExecUpdateQuery(): ' + E.Message);
      end;
    End;
  Finally
    if(Assigned(Query)) then begin
      PrepareFreeDataSet(Query);
      Query.Free;
    end;
  End;
end;


// SQL を指定した TFDMemTable のアップデート
//  GetServerQuery2() の対
Function TServerMethods1.ApplyChangesToServer3(
  tblnm, slsql: String; dltslst: TFDJSONDeltas): Boolean;
var
  LApply : IFDJSONDeltasApplyUpdates;
  Query  : TFDQuery;
begin
  Result := False;

  Query := GenQuery();  // TFDQuery の動的生成
  Try
    SetSQL(slsql, Query);  // SQL を指定

    // JSONDeltas 差分によるＤＢ更新
    LApply := TFDJSONDeltasApplyUpdates.Create(dltslst);
    LApply.ApplyUpdates(tblnm, Query.Command);

    // 処理後のエラーチェック
    if LApply.Errors.Count > 0
    then DoErrorLogWrite('JSON Error' + LApply.Errors.Strings.Text)   // 2015/07/06
    else Result := True;
  Finally
    if(Assigned(Query)) then begin
      PrepareFreeDataSet(Query);
      Query.Free;
    end;
  End;
end;


// ---------------------------------------------------------------------------

// DB接続パラメータの初期化  2015/06/08
Procedure InitialConnectionParam;
Const
  C9ParamName = 'DataSnapServer.ini';
begin
  if(NOT Assigned(F9DBConnParam)) then begin
    F9DBConnParam := Tu3DBConParam.Create();  // 2015/11/26
  end;

  if(Assigned(F9DBConnParam)) then begin
    // パラメータファイル名を固定ファイル名に変更 2016/03/02
    F9DBConnParam.FileName := F9DBConnParam.GetProgramBasePath() + C9ParamName;

    F9DBConnParam.Load();
  end;
end;


// ---------------------------------------------------------------------------
// エラーメッセージの表示と登録処理関連の処理

// 2015/07/06  イベントメソッドの設定
Procedure SetLogWriteEvt(AEvt: TEvt7AddErrEvt);
begin
  F9LogWriteEvt := AEvt;
end;


// 2015/07/06 エラーメッセージの表示と保存
Procedure DoErrorLogWrite(AMsg: String; ErrCD: Integer);
Var
  s : String;
begin
  if(NOT Assigned(F9LogWriteEvt)) then
    Exit;

  s := Trim(AMsg);
  if(s <> '') then begin
    if(ErrCD <> 0)
    then s := '  Error(' + IntToStr(ErrCD) + '): ' + s
    else s := '  Errorr():' + s;
  end;

  Try
    F9LogWriteEvt(s);
  Except
    On E: Exception do begin  ; end;
  End;
end;


// ---------------------------------------------------------------------------

Initialization
  F9LogWriteEvt := Nil;      // 2015/07/06
  InitialConnectionParam();  // 2015/06/08

Finalization
  F9LogWriteEvt := Nil;      // 2015/07/06

  if(Assigned(F9DBConnParam)) then begin  // 2015/11/30
    F9DBConnParam.Free;
    F9DBConnParam := Nil;
  end;


end.


