unit ServerContainerUnit1;

interface

uses System.SysUtils, System.Classes,
  Datasnap.DSServer, Datasnap.DSCommonServer,
  Datasnap.DSClientMetadata, Datasnap.DSHTTPServiceProxyDispatcher,
  Datasnap.DSProxyJavaAndroid, Datasnap.DSProxyJavaBlackBerry,
  Datasnap.DSProxyObjectiveCiOS, Datasnap.DSProxyCsharpSilverlight,
  Datasnap.DSProxyFreePascal_iOS,
  Datasnap.DSAuth;

type
  TServerContainer1 = class(TDataModule)
    DSServer1: TDSServer;
    DSAuthenticationManager1: TDSAuthenticationManager;
    DSServerClass1: TDSServerClass;
    procedure DSServerClass1GetClass(DSServerClass: TDSServerClass;
      var PersistentClass: TPersistentClass);
    procedure DSAuthenticationManager1UserAuthorize(Sender: TObject;
      EventObject: TDSAuthorizeEventObject; var valid: Boolean);
    procedure DSAuthenticationManager1UserAuthenticate(Sender: TObject;
      const Protocol, Context, User, Password: string; var valid: Boolean;
      UserRoles: TStrings);

  private   // private 宣言
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  function DSServer: TDSServer;
  function DSAuthenticationManager: TDSAuthenticationManager;

implementation


{$R *.dfm}

{$Include 'c4Switch.inc'}

uses
{$ifdef C9SSL_Use}
  c4Consts,
{$endif}
  Winapi.Windows, ServerMethodsUnit1;

var
  FModule: TComponent;
  FDSServer: TDSServer;
  FDSAuthenticationManager: TDSAuthenticationManager;

function DSServer: TDSServer;
begin
  Result := FDSServer;
end;

function DSAuthenticationManager: TDSAuthenticationManager;
begin
  Result := FDSAuthenticationManager;
end;

constructor TServerContainer1.Create(AOwner: TComponent);
begin
  inherited;
  FDSServer := DSServer1;
  FDSAuthenticationManager := DSAuthenticationManager1;
end;

destructor TServerContainer1.Destroy;
begin
  inherited;
  FDSServer := nil;
  FDSAuthenticationManager := nil;
end;

procedure TServerContainer1.DSServerClass1GetClass(
  DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := ServerMethodsUnit1.TServerMethods1;
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthenticate(
  Sender: TObject; const Protocol, Context, User, Password: string;
  var valid: Boolean; UserRoles: TStrings);
begin
  { TODO : クライアントのユーザー名とパスワードを検証します。
    ロールベースの権限付与が必要な場合は、UserRoles パラメータにロール名を追加します  }

{$ifdef C9SSL_Use}
  valid := ((UpperCase(C9SSL_DefUserName) = UpperCase(User)) and (C9SSL_DefPassword = Password));
{$else}
  valid := True;
{$endif}
  if(NOT valid) then
    DoErrorLogWrite('UserAuthenticate(): User and password');
end;

procedure TServerContainer1.DSAuthenticationManager1UserAuthorize(
  Sender: TObject; EventObject: TDSAuthorizeEventObject;
  var valid: Boolean);
begin
  { TODO : ユーザーにメソッドを実行する権限を与えます。
    EventObject から得られる値 (UserName、UserRoles、AuthorizedRoles、DeniedRoles など) を使用します。
    DSAuthenticationManager1.Roles を使用して、特定のサーバー メソッドの
    Authorized ロールと Denied ロールを定義します。}
  valid := True;
end;


initialization
  FModule := TServerContainer1.Create(nil);
finalization
  FModule.Free;
end.

