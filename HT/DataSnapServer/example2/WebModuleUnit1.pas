unit WebModuleUnit1;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp, Datasnap.DSHTTPCommon,
  Datasnap.DSHTTPWebBroker, Datasnap.DSServer, Web.WebFileDispatcher,
  Web.HTTPProd, Datasnap.DSAuth, Datasnap.DSProxyJavaScript, IPPeerServer,
  Datasnap.DSMetadata, Datasnap.DSServerMetadata, Datasnap.DSClientMetadata,
  Datasnap.DSCommonServer, Datasnap.DSHTTP, ServerMethodsUnit1,
  FireDAC.Stan.StorageJSON, Data.FireDACJSONReflect, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, Vcl.Forms, Vcl.StdCtrls,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf;

type
  TWebModule1 = class(TWebModule)
    DSHTTPWebDispatcher1: TDSHTTPWebDispatcher;
    DSServer1: TDSServer;
    DSServerClass1: TDSServerClass;
    ServerFunctionInvoker: TPageProducer;
    GetTableData: TPageProducer;
    WebFileDispatcher1: TWebFileDispatcher;
    DSProxyGenerator1: TDSProxyGenerator;
    DSServerMetaDataProvider1: TDSServerMetaDataProvider;
    PageProducer1: TPageProducer;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
      const TagString: string; TagParams: TStrings; var ReplaceText: string);
    procedure WebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleBeforeDispatch(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebFileDispatcher1BeforeDispatch(Sender: TObject;
      const AFileName: string; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModule1GetAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure WebModule1DefaultHandlerAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);

  private
    { private 宣言 }
    FServerFunctionInvokerAction: TWebActionItem;
    function AllowServerFunctionInvoker: Boolean;

  public
    { public 宣言 }
  end;

var
  WebModuleClass: TComponentClass = TWebModule1;

implementation

{$R *.dfm}

uses
  Web.WebReq;

procedure TWebModule1.DSServerClass1GetClass(DSServerClass: TDSServerClass;
  var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

procedure TWebModule1.ServerFunctionInvokerHTMLTag(Sender: TObject; Tag: TTag;
  const TagString: string; TagParams: TStrings; var ReplaceText: string);
begin
  if SameText(TagString, 'urlpath') then
    ReplaceText := string(Request.InternalScriptName)
  else if SameText(TagString, 'port') then
    ReplaceText := IntToStr(Request.ServerPort)
  else if SameText(TagString, 'host') then
    ReplaceText := string(Request.Host)
  else if SameText(TagString, 'classname') then
    ReplaceText := ServerMethodsUnit1.TServerMethods1.ClassName
  else if SameText(TagString, 'loginrequired') then
    if DSHTTPWebDispatcher1.AuthenticationManager <> nil then
      ReplaceText := 'true'
    else
      ReplaceText := 'false'
  else if SameText(TagString, 'serverfunctionsjs') then
    ReplaceText := string(Request.InternalScriptName) + '/js/serverfunctions.js'
  else if SameText(TagString, 'servertime') then
    ReplaceText := DateTimeToStr(Now)
  else if SameText(TagString, 'serverfunctioninvoker') then
    if AllowServerFunctionInvoker then
      ReplaceText := '<div><a href="' + string(Request.InternalScriptName) +
        '/ServerFunctionInvoker" target="_blank">Server Functions</a></div>'
    else
      ReplaceText := '';
end;

procedure TWebModule1.WebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
 // WebModule1DefaultHandlerAction(Sender, Request, Response, Handled);
  { if (Request.InternalPathInfo = '') or (Request.InternalPathInfo = '/')then
    Response.Content := WebModule1DefaultHandlerAction.Response.Content
    else
    Response.SendRedirect(Request.InternalScriptName + '/');  _ }
end;

procedure TWebModule1.WebModule1DefaultHandlerAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<!DOCTYPE html>' + '<html lang="en">' + '<head>' +
    '<meta http-equiv="content-type" content="text/html; charset=utf-8" />' +
    '<title>Web サーバー アプリケーション</title>' + '</head>' + '<body>' +
    '<h2>Web サーバー アプリケーション</h2>' + '<form method="get" action="/get">' +
    '何か入力してください：<input type="text" name="txt">' + '<input type="submit">' +
    '</form>' + '</body>' + '</html>';
end;

procedure TWebModule1.WebModule1GetAction(Sender: TObject; Request: TWebRequest;
  Response: TWebResponse; var Handled: Boolean);
var
  s    : string;
  s1   : string;
  s2   : string;
  s3   : string;
  ssql : string;
  sTbl : string;
  n    : Integer;
  oStr : TMemoryStream;
  LDataSetList: TFDJSONDataSets;
  aMemTable1  : TFDMemTable;
begin
  aMemTable1 := TFDMemTable.Create(nil);
  try
    s := Request.ContentFields.Values['txt'];
    if pos('select', s) > 0 then
    begin
      ssql := s;
      sTbl := '';
    end else
    begin
      if pos('/', s) > 0 then
      begin
        s1 := copy(s, 1, pos('/', s) -1);
        s2 := copy(s, pos('/', s) +1, Length(s));
      end else
      begin
        s2 := s;
        s1 := 'srm';
      end;

      if s1 = 'srm' then
        n := 4
      else
        n := 5;

      if StrToIntDef(s2, 0) > 0 then
      begin
        while Length(s2) < n do
          s2 := '0' + s2;
      end else
        s2 := '';

      ssql := 'select * from ' + s1 + '';
      if s2 <> '' then
        ssql := ssql + ' where F002 = ''' + s2 + '''';
      sTbl := s1;
    end;
    LDataSetList := ServerMethods1.GetServerQuery2(ssql, sTbl);
    aMemTable1.AppendData(TFDJSONDataSetsReader.GetListValue(LDataSetList, 0));

    oStr  := TMemoryStream.Create;
    try
      ServerMethods1.FDSchemaAdapter1.SaveToStream(oStr, TFDStorageFormat.sfJSON);

    if aMemTable1.RecordCount = 0 then
{    begin
      if s1 = 'srm' then
      begin
        s1 := ServerMethods1.FDQuery2.FieldByName('F003').AsString;
        s3 := ServerMethods1.FDQuery2.FieldByName('F011').AsString;
      end else
      begin
        s1 := ServerMethods1.FDQuery2.FieldByName('F004').AsString;
        s3 := ServerMethods1.FDQuery2.FieldByName('F012').AsString;
      end;

      s2 := ServerMethods1.FDQuery2.FieldByName('F010').AsString;
      s  := s1 + '    ' + s2 + '    ' + s3;
    end else   }
      s := '対象データがありません'

  //  else// beginif ServerMethods1.FDQuery2.RecordCount <= 1 then
//    Response.Content := '<!DOCTYPE html>' + '<html lang="en">' + '<head>' + '<meta charset="utf-8">' +
//      '<title>Web サーバー アプリケーション</title>' + '</head>' + '<body>' +
//      '<h2> Getした文字列の表示</h2>' + '<p>' + s + '</p>' + '<a href="/">戻る</a>' +
//      '</body>' + '</html>'
  else begin

      Response.SendStream(oStr);

      Response.Content := '<!DOCTYPE html>' + '<html lang="en">' + '<head>' + '<meta http-equiv="content-type" content="text/html; charset=utf-8" />' + '<meta http-equiv="Access-Control-Allow-Origin" content="*">' +
        '</head>' + '<body>' + '</body>' + '</html>';
    end;
    except
      oStr.Free;
      raise;
    //end;
  end;
  finally
    aMemTable1.Free;
  end;
end;

procedure TWebModule1.WebModuleBeforeDispatch(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  if FServerFunctionInvokerAction <> nil then
    FServerFunctionInvokerAction.Enabled := AllowServerFunctionInvoker;
end;

function TWebModule1.AllowServerFunctionInvoker: Boolean;
begin
  Result := (Request.RemoteAddr = '127.0.0.1') or
    (Request.RemoteAddr = '0:0:0:0:0:0:0:1') or (Request.RemoteAddr = '::1');
end;

procedure TWebModule1.WebFileDispatcher1BeforeDispatch(Sender: TObject;
  const AFileName: string; Request: TWebRequest; Response: TWebResponse;
  var Handled: Boolean);
var
  D1, D2: TDateTime;
begin
  Handled := False;
  if SameFileName(ExtractFileName(AFileName), 'serverfunctions.js') then
    if not FileExists(AFileName) or
      (FileAge(AFileName, D1) and FileAge(WebApplicationFileName, D2) and
      (D1 < D2)) then
    begin
      DSProxyGenerator1.TargetDirectory := ExtractFilePath(AFileName);
      DSProxyGenerator1.TargetUnitName  := ExtractFileName(AFileName);
      DSProxyGenerator1.Write;
    end;
end;

procedure TWebModule1.WebModuleCreate(Sender: TObject);
begin
  FServerFunctionInvokerAction := ActionByName('ServerFunctionInvokerAction');
end;

initialization

finalization

Web.WebReq.FreeWebModules;

end.
