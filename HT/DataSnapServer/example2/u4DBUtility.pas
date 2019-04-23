unit u4DBUtility;

interface

Uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Data.DB, Vcl.DBGrids;

Type
  Tu4DBUtility = class
  private
  protected
    // �������k�\��
    // CR --> ' ',  LF := '', �y�уX�y�[�X�̈��k
    class function StripCRLF(const src: String): String;

    // ������̃T�C�Y����(AnsiString)
    class Function ModifyLength(AStr: String; ALen: Integer): String;

    // CSV �t�@�C���̏o��
    class Function CsvFileWrite(
      ADst: TDataSet; AFName: String; AIDName: String; ANVisWrite: Boolean = False): String;

  public
    // --------------------------------
    // ���t ������̕\��  YYYY/MM/DD
    class procedure GridDisplayCriDate(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Blob ������̕\����ݒ�
    class procedure SetDataSetBlobDisplay(
      ADst: TDataSet; AName: String; ALen: Integer = 0);

    // Blob ������̕\��
    class procedure GridDisplayBlobStr(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // WideMemo ������̕\����ݒ�(������͐؂炸��DisplayWidth(Default50)��ݒ肷��)
    class procedure SetDataSetWideMemoDisplay(
      ADst: TDataSet; AName: String; ADspWidth: Integer = 50);

    // WideMemo ������̕\��
    class procedure GridDisplayWideMemoStr(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_0��)
    class procedure GridDisplayFloat0(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_1��)
    class procedure GridDisplayFloat1(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_2��)
    class procedure GridDisplayFloat2(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_�s��,�J���}�L��)
    class procedure GridDisplayFloat3(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_�s��,�J���}�L��,0��\�����Ȃ�)
    class procedure GridDisplayFloat4(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_�s��,�J���}�L��,0��\������)
    class procedure GridDisplayFloat5(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_�s��,�J���}�L��,0��\�����Ȃ�, �Œጅ��2)
    class procedure GridDisplayFloat6(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // Float ������̕\��(�����_�s��,�J���}�L��,0��\������, �Œጅ��2)
    class procedure GridDisplayFloat7(
      Sender: TField; var Text: String; DisplayText: Boolean);

    // --------------------------------
    // �f�[�^�Z�b�g�ʒu�̎擾�A�ړ�

    // ���ݍs��ID�̎擾
    class Function  GetIDentifier(ADst: TDataSet; AIDName: String = ''): Integer; overload;
    class Function  GetIDentifier(ADBGrid: TDBGrid; AIDName: String = ''): Integer; overload;
    class Function  GetFldStrings(ADst: TDataSet; AName: String): String;

    // �w��ID�ւ̃W�����v
    class Function  JumpIDentifier(
      AID: Integer; ADst: TDataSet; AIDName: String = ''): Boolean; overload;

    class Function  JumpIDentifier(
      AID: Integer; ADBGrid: TDBGrid; AIDName: String = ''): Boolean; overload;

    // DBGrid ����f�[�^�Z�b�g���擾����
    class Function GetDataSetFromDBGrid(ADBGrid: TDBGrid): TDataSet;

    // ������E���������_�ϊ�
    class Function StrToFloatDef(AStr: String; ADefVal: Double = 0.0): Double;

    // �t�B�[���h�𕂓������_�Ƃ��Ď擾(�������̊���l�w��)
    class Function FldToFloatDef(AFld: TField; ADefVal: Double = 0.0): Double;


    // TCustomComboBox ID �擾/�ؑ�
    class Function GetComboID(ACmb: TCustomComboBox): Integer;
    class Procedure SetComboID(AID: Integer; ACmb: TCustomComboBox);


    // --------------------------------
    // CSV �t�@�C���̏o��
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

// �������k�\��
// CR --> ' ',  LF := '', �y�уX�y�[�X�̈��k
class function Tu4DBUtility.StripCRLF(const src: String): String;
Var
  i, j, n: Integer;
begin
  Result := '';

  n := Length(src);
  i := 1;
  While (i <= n) Do Begin
    If(src[i] > Char($ff)) Then Begin
      If(src[i] = '�@') then Begin  // �S�p�X�y�[�X
        Result := Result + ' ';
        i := i + 1;
        continue;
      End Else If((src[i] >= '�O') and (src[i] <= '�X')) Then Begin // �S�p����
        Result := Result + Char(Ord(src[i]) - Ord('�O') + Ord('0'));
        i := i + 1;
        continue;
      End Else If((src[i] >= '�`') and (src[i] <= '�y')) Then Begin // �S�p����
        Result := Result + Char(Ord(src[i]) - Ord('�`') + Ord('A'));
        i := i + 1;
        continue;
      End Else If((src[i] >= '��') and (src[i] <= '��')) Then Begin // �S�p����
        Result := Result + Char(Ord(src[i]) - Ord('��') + Ord('a'));
        i := i + 1;
        continue;
      End;

      Result := Result + src[i];
      i := i + 1;

    End Else Begin

      j := Ord(src[i]);
      Case j Of

        $0a: Begin  ; End;  // �ǂݔ�΂�

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


// ������̃T�C�Y����(AnsiString)
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


// WideMemo ������̕\����ݒ�(������͐؂炸��DisplayWidth(Default50)��ݒ肷��)
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


// Float ������̕\��(�����_0��)
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


// Float ������̕\��(�����_1��)
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



// Float ������̕\��(�����_2��)
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


// Float ������̕\��(�����_�s��,�J���}�L��)
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


// Float ������̕\��(�����_�s��,�J���}�L��,0��\�����Ȃ�)
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

// Float ������̕\��(�����_�s��,�J���}�L��,0��\������)
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

// Float ������̕\��(�����_�s��,�J���}�L��,0��\�����Ȃ�, �Œጅ��2)
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

// Float ������̕\��(�����_�s��,�J���}�L��,0��\������, �Œጅ��2)
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

// ���t ������̕\��  YYYY/MM/DD
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
     ftString,     // �����܂��͕����񍀖�
     ftBlob,       // �o�C�i����K�̓I�u�W�F�N�g�^����
     ftMemo,       // �e�L�X�g��������
     ftWideMemo,   // �e�L�X�g���C�h��������
     ftWideString: // ���C�h��������
       Result := '"' + Tu7ZtoHConv.AllLfCodeRemoved(AFld.AsString) +'"';

     ftSmallint,  // 16 �r�b�g��������
     ftInteger,   // 32 �r�b�g��������
     ftWord:      // 16 �r�b�g�����Ȃ���������
       Result := IntToStr(AFld.AsInteger);

     ftSingle,
     ftFloat:     // ���������_���l�^����
       Result := Format('%.4f', [AFld.AsFloat]);

     //ftBoolean	�_���^����
     //ftCurrency	���z�^����
     //ftBCD	2 �i�� 10 �i���^����

     ftDate,      // ���t�^����
     ftDateTime: // ���t/�����^����
       begin
         if AFld.AsDatetime > 0 then
           Result := '"' + FormatDateTime('YYYY/MM/DD', AFld.AsDatetime) + '"'
         else
           Result := '';
       end;
     ftTime:     // �����^����
       Result := '"' + FormatDateTime('HH:NN:SS', AFld.AsDatetime) + '"';

     //ftBytes	�Œ蒷�o�C�g�^���ځi�o�C�i���i�[�j
     //ftVarBytes	�ϒ��o�C�g�^���ځi�o�C�i���i�[�j
     //ftAutoInc	�����C���N�������g 32 �r�b�g�����J�E���^�^����

     //ftGraphic	�r�b�g�}�b�v����
     //ftFmtMemo	�����t����������
     //ftParadoxOle	Paradox OLE ����
     //ftDBaseOle	dBASE OLE ����
     //ftTypedBinary	�^�t���o�C�i������
     //ftCursor	Oracle �X�g�A�h�v���V�[�W���̏o�̓J�[�\���iTParam �̂݁j
     //ftFixedChar	�Œ蒷�����^����
     //ftWideString	���C�h��������
     //ftLargeint	32 �r�b�g��������
     //ftADT	���ۃf�[�^�^����
     //ftArray	�z�񍀖�
     //ftReference	�Q�ƍ���
     //ftDataSet	�f�[�^�Z�b�g����

     //ftOraBlob	Oracle 8 �e�[�u���� BLOB ����
     //ftOraClob	Oracle 8 �e�[�u���� CLOB ����
     //ftVariant	����`�܂��͊m�肵�Ă��Ȃ��^�̃f�[�^
     //ftInterface	�C���^�[�t�F�[�X (IUnknown) �ւ̎Q��
     //ftIDispatch	IDispatch �C���^�[�t�F�[�X�ւ̎Q��
     //ftGuid	GUID (Globally Unique Identifier) �l

    else   // case-else
      // ftUnknown	���m�܂��͖���
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
      else dlg.Title := '�����݃t�@�C���̎w��';

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
  sFile := GetSaveFileName('CSV�t�@�C���̏o��', AFName);

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
// �f�[�^�Z�b�g�ʒu�̎擾�A�ړ�

// ���ݍs��ID�̎擾
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

// �w��ID�ւ̃W�����v
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

// DBGrid ����f�[�^�Z�b�g���擾����
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

// ������E���������_�ϊ�
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

// �t�B�[���h�𕂓������_�Ƃ��Ď擾(�������̊���l�w��)
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
// TCustomComboBox ID �擾/�ؑ�

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

// CSV �t�@�C���̏o��
class Function Tu4DBUtility.SaveToCsvFile(
  ADst: TDataSet; AIDName: String;
  ADefName: String; ADispMsg, ANVisWrite: Boolean): String;

  // �t�H���_���݂̃`�F�b�N�Ɩ����ꍇ�̍쐬
  Procedure CheckAndCreateLocalFolder(sName: String);
    Function IsExistLocalFolder( sName : String ) : Boolean;
    Begin
      Result := DirectoryExists(sName);
    End;
  Var
    n  : Integer;
    sB : String;  // �x�[�X(��������)
    sE : String;  // �`�F�b�N(����������)
  Begin
    sB := '';
    sE := '';

    n := Pos( '\\', sName );
    If( n > 0 ) then Begin  // ���L�t�@�C��
      sB := '\\';
      sE := Copy(sName,3,Length(sName) - 2);

      n := Pos(':',sE);
      If( n > 0 ) Then Begin
        n := Pos('\',sE);

        If( n > 0 ) then Begin
          sB := sB + Copy(sE,1, n - 1);
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( '�t�H���_�����Ɏ��s���܂����B[' + sName + ']' );
        End;

        n := Pos('\',sE);
        If( n > 0 ) Then Begin
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( '�t�H���_�����Ɏ��s���܂����B[' + sName + ']' );
        End;

      End Else Begin
        n := Pos('\',sE);
        If( n > 0 ) then Begin
          sB := sB + Copy(sE,1, n - 1);
          sE := Copy(sE,n + 1, Length(sE) - n);
        End Else Begin
          Raise Exception.Create( '�t�H���_�����Ɏ��s���܂����B[' + sName + ']' );
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
          Raise Exception.Create( '�t�H���_�����Ɏ��s���܂����B[' + sName + ']' );
        End;

        n := Pos(':',sE);
        If( n > 0 ) Then Begin
          n := Pos('\',sE);
          If( n > 0 ) Then Begin
            sE := Copy(sE,n + 1, Length(sE) - n);
          End Else Begin
            Raise Exception.Create( '�t�H���_�����Ɏ��s���܂����B[' + sName + ']' );
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

          // ���[�g�t�H���_�̎w�莞
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
      // �t�H���_���P�i�߂�
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

      // �t�H���_�̊m�F�y�і����ꍇ�̐���
      If(IsExistLocalFolder(sB) = FALSE) then Begin
        If( CreateDir(sB) = FALSE ) Then Begin  // �t�H���_����
          Raise Exception.Create( '�t�H���_�쐬�Ɏ��s���܂����B[' + sB + ']' );
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

  // �t�H���_�����݂��Ȃ��ꍇ�̍쐬
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
                ShowMessage('�t�@�C�� [' + s + '] ���o�͂��܂����B');
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

