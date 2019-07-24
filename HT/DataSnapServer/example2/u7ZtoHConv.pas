unit u7ZtoHConv;

interface

Uses
  System.SysUtils, Classes, AnsiStrings;

Type
  Tu7ZtoHConv = class
  private
  protected

  public
    // 文字が漢字の１文字目かどうかチェックする
    class function IsKanjiUp(AChar: AnsiCHAR): Boolean;
    class function IsKanjiUpS(AStr: AnsiString; n: Integer): Boolean;
    class function StrLengthCut(
      const src: AnsiString; len: Integer): AnsiString;  // 文字列を len 文字で切り詰める(Shift-JIS漢字対応)
    class Function StrLengthCutWideStr(var src: WideString; ALen: Integer): WideString; // 文字列のサイズ調整(WideString)

    class Function ConvZenToHan(AStr: AnsiString): AnsiString;
    class Function ConvZenToHanAK(AStr: AnsiString): AnsiString;
    class Function GetConvCSVList: AnsiString;

    class function StringStripNoNum(const ASrc: AnsiString): AnsiString;
    class function StripCRLF(
      const src: AnsiString; ANumHan: Boolean = True): AnsiString;

    class Function ConvHanToZen(AStr: AnsiString): AnsiString;

     // 文字列が全部数字であるかどうか判断,'-','.'もダメ
    class function IS_SNUMERIC2(aStr: String): Boolean;
     // NO-BREAK SPACE(ノーブレークスペース) を半角スペースに置き換える
    class function NoBreakSpace_Removed(aStr: String) : String;
    // 文字列の前後・中にあるすべてのスペースを取り除く
    class function AllSpaceRemoved(aStr: String) : String;
    // 半角から全角への変換※ひらがなは変換しない(UTF-8　2バイト以上の文字を含む場合)
    class function ConvZenToHanAKUTF8(AStr: String): String;
    // 文字列の中にある改行コードを半角スペースに置き換える
    class function AllLfCodeRemoved(aStr: String) : String;
    // 文字列の中に特定の文字列が何個あるかカウントする
    class function GetHowMany(aStr, IncStr : string): integer;
    // 半角カタカナの小文字を大文字に置き換える
    class function KanaUpperCase(aStr: AnsiString): AnsiString;
    // 文字列を指定したバイト数で長さをそろえる
    class function ModifyLengthInByte(AStr: String; ALen: Integer): String;
    // アルファベットの次のアルファベットを取得する
    class function GetNextAlpha(AStr: AnsiString): AnsiString;
  end;


Type
  Cv9Table = record
    Org: AnsiString;
    Cnv: AnsiString;
  end;


implementation

//Uses
//  Tec03;

Const
  C9ConvTable : Array[0..207] of Cv9Table = (
    (Org:'１'; Cnv:'1'), (Org:'２'; Cnv:'2'), (Org:'３'; Cnv:'3'), (Org:'４'; Cnv:'4'), (Org:'５'; Cnv:'5'),
    (Org:'６'; Cnv:'6'), (Org:'７'; Cnv:'7'), (Org:'８'; Cnv:'8'), (Org:'９'; Cnv:'9'), (Org:'０'; Cnv:'0'),

    (Org:'　'; Cnv:' '), (Org:'－'; Cnv:'-'), (Org:'ー'; Cnv:'ｰ'), (Org:'（'; Cnv:'('),
    (Org:'）'; Cnv:')'), (Org:'［'; Cnv:'['), (Org:'］'; Cnv:']'), (Org:'「'; Cnv:'['),
    (Org:'」'; Cnv:']'), (Org:'！'; Cnv:'!'), (Org:'”'; Cnv:'"'), (Org:'’'; Cnv:''''),
    (Org:'＃'; Cnv:'#'), (Org:'＄'; Cnv:'$'), (Org:'％'; Cnv:'%'), (Org:'＆'; Cnv:'&'),
    (Org:'～'; Cnv:'~'), (Org:'＾'; Cnv:'^'), (Org:'￥'; Cnv:'\'), (Org:'｛'; Cnv:'{'),
    (Org:'｝'; Cnv:'}'), (Org:'＜'; Cnv:'<'), (Org:'＞'; Cnv:'>'), (Org:'、'; Cnv:','),
    (Org:'，'; Cnv:','), (Org:'．'; Cnv:'.'), (Org:'。'; Cnv:'.'), (Org:'／'; Cnv:'/'),
    (Org:'・'; Cnv:'･'), (Org:'？'; Cnv:'?'), (Org:'＿'; Cnv:'_'), (Org:'；'; Cnv:';'),

    (Org:'￣'; Cnv:'~'), (Org:'〔'; Cnv:'['), (Org:'〕'; Cnv:']'), (Org:'《'; Cnv:'<<'),
    (Org:'》'; Cnv:'>>'), (Org:'『'; Cnv:'['), (Org:'』'; Cnv:']'), (Org:'【'; Cnv:'['),
    (Org:'】'; Cnv:']'), (Org:'〈'; Cnv:'<'), (Org:'〉'; Cnv:'>'),

    (Org:'Ａ'; Cnv:'A'), (Org:'Ｂ'; Cnv:'B'), (Org:'Ｃ'; Cnv:'C'), (Org:'Ｄ'; Cnv:'D'),
    (Org:'Ｅ'; Cnv:'E'), (Org:'Ｆ'; Cnv:'F'), (Org:'Ｇ'; Cnv:'G'), (Org:'Ｈ'; Cnv:'H'),
    (Org:'Ｉ'; Cnv:'I'), (Org:'Ｊ'; Cnv:'J'), (Org:'Ｋ'; Cnv:'K'), (Org:'Ｌ'; Cnv:'L'),
    (Org:'Ｍ'; Cnv:'M'), (Org:'Ｎ'; Cnv:'N'), (Org:'Ｏ'; Cnv:'O'), (Org:'Ｐ'; Cnv:'P'),
    (Org:'Ｑ'; Cnv:'Q'), (Org:'Ｒ'; Cnv:'R'), (Org:'Ｓ'; Cnv:'S'), (Org:'Ｔ'; Cnv:'T'),
    (Org:'Ｕ'; Cnv:'U'), (Org:'Ｖ'; Cnv:'V'), (Org:'Ｗ'; Cnv:'W'), (Org:'Ｘ'; Cnv:'X'),
    (Org:'Ｙ'; Cnv:'Y'), (Org:'Ｚ'; Cnv:'Z'),

    (Org:'ａ'; Cnv:'a'), (Org:'ｂ'; Cnv:'b'), (Org:'ｃ'; Cnv:'c'), (Org:'ｄ'; Cnv:'d'),
    (Org:'ｅ'; Cnv:'e'), (Org:'ｆ'; Cnv:'f'), (Org:'ｇ'; Cnv:'g'), (Org:'ｈ'; Cnv:'h'),
    (Org:'ｉ'; Cnv:'i'), (Org:'ｊ'; Cnv:'j'), (Org:'ｋ'; Cnv:'k'), (Org:'ｌ'; Cnv:'l'),
    (Org:'ｍ'; Cnv:'m'), (Org:'ｎ'; Cnv:'n'), (Org:'ｏ'; Cnv:'o'), (Org:'ｐ'; Cnv:'p'),
    (Org:'ｑ'; Cnv:'q'), (Org:'ｒ'; Cnv:'r'), (Org:'ｓ'; Cnv:'s'), (Org:'ｔ'; Cnv:'t'),
    (Org:'ｕ'; Cnv:'u'), (Org:'ｖ'; Cnv:'v'), (Org:'ｗ'; Cnv:'w'), (Org:'ｘ'; Cnv:'x'),
    (Org:'ｙ'; Cnv:'y'), (Org:'ｚ'; Cnv:'z'),

    (Org:'Ⅰ'; Cnv:'1'), (Org:'Ⅱ'; Cnv:'2'), (Org:'Ⅲ'; Cnv:'3'), (Org:'Ⅳ'; Cnv:'4'), (Org:'Ⅴ'; Cnv:'5'),
    (Org:'Ⅵ'; Cnv:'6'), (Org:'Ⅶ'; Cnv:'7'), (Org:'Ⅷ'; Cnv:'8'), (Org:'Ⅸ'; Cnv:'9'), (Org:'Ⅹ'; Cnv:'10'),
    (Org:'㎜'; Cnv:'mm'), (Org:'㎝'; Cnv:'cm'), (Org:'㎞'; Cnv:'Km'), (Org:'㎎'; Cnv:'mg'), (Org:'㎏'; Cnv:'Kg'),
    (Org:'㏄'; Cnv:'cc'), (Org:'㎡'; Cnv:'m2'),

    (Org:'ガ'; Cnv:'ｶﾞ'), (Org:'ギ'; Cnv:'ｷﾞ'), (Org:'グ'; Cnv:'ｸﾞ'), (Org:'ゲ'; Cnv:'ｹﾞ'), (Org:'ゴ'; Cnv:'ｺﾞ'),
    (Org:'ザ'; Cnv:'ｻﾞ'), (Org:'ジ'; Cnv:'ｼﾞ'), (Org:'ズ'; Cnv:'ｽﾞ'), (Org:'ゼ'; Cnv:'ｾﾞ'), (Org:'ゾ'; Cnv:'ｿﾞ'),
    (Org:'ダ'; Cnv:'ﾀﾞ'), (Org:'ヂ'; Cnv:'ﾁﾞ'), (Org:'ヅ'; Cnv:'ﾂﾞ'), (Org:'デ'; Cnv:'ﾃﾞ'), (Org:'ド'; Cnv:'ﾄﾞ'),
    (Org:'バ'; Cnv:'ﾊﾞ'), (Org:'ビ'; Cnv:'ﾋﾞ'), (Org:'ブ'; Cnv:'ﾌﾞ'), (Org:'ベ'; Cnv:'ﾍﾞ'), (Org:'ボ'; Cnv:'ﾎﾞ'),
    (Org:'パ'; Cnv:'ﾊﾟ'), (Org:'ピ'; Cnv:'ﾋﾟ'), (Org:'プ'; Cnv:'ﾌﾟ'), (Org:'ペ'; Cnv:'ﾍﾟ'), (Org:'ポ'; Cnv:'ﾎﾟ'),
    (Org:'ア'; Cnv:'ｱ'), (Org:'イ'; Cnv:'ｲ'), (Org:'ウ'; Cnv:'ｳ'), (Org:'エ'; Cnv:'ｴ'), (Org:'オ'; Cnv:'ｵ'),
    (Org:'カ'; Cnv:'ｶ'), (Org:'キ'; Cnv:'ｷ'), (Org:'ク'; Cnv:'ｸ'), (Org:'ケ'; Cnv:'ｹ'), (Org:'コ'; Cnv:'ｺ'),
    (Org:'サ'; Cnv:'ｻ'), (Org:'シ'; Cnv:'ｼ'), (Org:'ス'; Cnv:'ｽ'), (Org:'セ'; Cnv:'ｾ'), (Org:'ソ'; Cnv:'ｿ'),
    (Org:'タ'; Cnv:'ﾀ'), (Org:'チ'; Cnv:'ﾁ'), (Org:'ツ'; Cnv:'ﾂ'), (Org:'テ'; Cnv:'ﾃ'), (Org:'ト'; Cnv:'ﾄ'),
    (Org:'ナ'; Cnv:'ﾅ'), (Org:'ニ'; Cnv:'ﾆ'), (Org:'ヌ'; Cnv:'ﾇ'), (Org:'ネ'; Cnv:'ﾈ'), (Org:'ノ'; Cnv:'ﾉ'),
    (Org:'ハ'; Cnv:'ﾊ'), (Org:'ヒ'; Cnv:'ﾋ'), (Org:'フ'; Cnv:'ﾌ'), (Org:'ヘ'; Cnv:'ﾍ'), (Org:'ホ'; Cnv:'ﾎ'),
    (Org:'マ'; Cnv:'ﾏ'), (Org:'ミ'; Cnv:'ﾐ'), (Org:'ム'; Cnv:'ﾑ'), (Org:'メ'; Cnv:'ﾒ'), (Org:'モ'; Cnv:'ﾓ'),
    (Org:'ヤ'; Cnv:'ﾔ'), (Org:'ユ'; Cnv:'ﾕ'), (Org:'ヨ'; Cnv:'ﾖ'),
    (Org:'ラ'; Cnv:'ﾗ'), (Org:'リ'; Cnv:'ﾘ'), (Org:'ル'; Cnv:'ﾙ'), (Org:'レ'; Cnv:'ﾚ'), (Org:'ロ'; Cnv:'ﾛ'),
    (Org:'ワ'; Cnv:'ﾜ'), (Org:'ヲ'; Cnv:'ｦ'), (Org:'ン'; Cnv:'ﾝ'),
    (Org:'ァ'; Cnv:'ｧ'), (Org:'ィ'; Cnv:'ｨ'), (Org:'ゥ'; Cnv:'ｩ'), (Org:'ェ'; Cnv:'ｪ'), (Org:'ォ'; Cnv:'ｫ'),
    (Org:'ャ'; Cnv:'ｬ'), (Org:'ュ'; Cnv:'ｭ'), (Org:'ョ'; Cnv:'ｮ'), (Org:'ッ'; Cnv:'ｯ'),
    (Org:'ヮ'; Cnv:'ﾜ'), (Org:'ヱ'; Cnv:'ｴ'), (Org:'ヵ'; Cnv:'ｶ'), (Org:'ヶ'; Cnv:'ｹ'), (Org:'ヴ'; Cnv:'ｳﾞ'),
    (Org:'ヰ'; Cnv:'ｲ')
  );

  C9ConvTable2 : Array[0..82] of Cv9Table = (
    (Org:'が'; Cnv:'ｶﾞ'), (Org:'ぎ'; Cnv:'ｷﾞ'), (Org:'ぐ'; Cnv:'ｸﾞ'), (Org:'げ'; Cnv:'ｹﾞ'), (Org:'ご'; Cnv:'ｺﾞ'),
    (Org:'ざ'; Cnv:'ｻﾞ'), (Org:'じ'; Cnv:'ｼﾞ'), (Org:'ず'; Cnv:'ｽﾞ'), (Org:'ぜ'; Cnv:'ｾﾞ'), (Org:'ぞ'; Cnv:'ｿﾞ'),
    (Org:'だ'; Cnv:'ﾀﾞ'), (Org:'ぢ'; Cnv:'ﾁﾞ'), (Org:'づ'; Cnv:'ﾂﾞ'), (Org:'で'; Cnv:'ﾃﾞ'), (Org:'ど'; Cnv:'ﾄﾞ'),
    (Org:'ば'; Cnv:'ﾊﾞ'), (Org:'び'; Cnv:'ﾋﾞ'), (Org:'ぶ'; Cnv:'ﾌﾞ'), (Org:'べ'; Cnv:'ﾍﾞ'), (Org:'ぼ'; Cnv:'ﾎﾞ'),
    (Org:'ぱ'; Cnv:'ﾊﾟ'), (Org:'ぴ'; Cnv:'ﾋﾟ'), (Org:'ぷ'; Cnv:'ﾌﾟ'), (Org:'ぺ'; Cnv:'ﾍﾟ'), (Org:'ぽ'; Cnv:'ﾎﾟ'),
    (Org:'あ'; Cnv:'ｱ'), (Org:'い'; Cnv:'ｲ'), (Org:'う'; Cnv:'ｳ'), (Org:'え'; Cnv:'ｴ'), (Org:'お'; Cnv:'ｵ'),
    (Org:'か'; Cnv:'ｶ'), (Org:'き'; Cnv:'ｷ'), (Org:'く'; Cnv:'ｸ'), (Org:'け'; Cnv:'ｹ'), (Org:'こ'; Cnv:'ｺ'),
    (Org:'さ'; Cnv:'ｻ'), (Org:'し'; Cnv:'ｼ'), (Org:'す'; Cnv:'ｽ'), (Org:'せ'; Cnv:'ｾ'), (Org:'そ'; Cnv:'ｿ'),
    (Org:'た'; Cnv:'ﾀ'), (Org:'ち'; Cnv:'ﾁ'), (Org:'つ'; Cnv:'ﾂ'), (Org:'て'; Cnv:'ﾃ'), (Org:'と'; Cnv:'ﾄ'),
    (Org:'な'; Cnv:'ﾅ'), (Org:'に'; Cnv:'ﾆ'), (Org:'ぬ'; Cnv:'ﾇ'), (Org:'ね'; Cnv:'ﾈ'), (Org:'の'; Cnv:'ﾉ'),
    (Org:'は'; Cnv:'ﾊ'), (Org:'ひ'; Cnv:'ﾋ'), (Org:'ふ'; Cnv:'ﾌ'), (Org:'へ'; Cnv:'ﾍ'), (Org:'ほ'; Cnv:'ﾎ'),
    (Org:'ま'; Cnv:'ﾏ'), (Org:'み'; Cnv:'ﾐ'), (Org:'む'; Cnv:'ﾑ'), (Org:'め'; Cnv:'ﾒ'), (Org:'も'; Cnv:'ﾓ'),
    (Org:'や'; Cnv:'ﾔ'), (Org:'ゆ'; Cnv:'ﾕ'), (Org:'よ'; Cnv:'ﾖ'),
    (Org:'ら'; Cnv:'ﾗ'), (Org:'り'; Cnv:'ﾘ'), (Org:'る'; Cnv:'ﾙ'), (Org:'れ'; Cnv:'ﾚ'), (Org:'ろ'; Cnv:'ﾛ'),
    (Org:'わ'; Cnv:'ﾜ'), (Org:'を'; Cnv:'ｦ'), (Org:'ん'; Cnv:'ﾝ'),
    (Org:'ぁ'; Cnv:'ｧ'), (Org:'ぃ'; Cnv:'ｨ'), (Org:'ぅ'; Cnv:'ｩ'), (Org:'ぇ'; Cnv:'ｪ'), (Org:'ぉ'; Cnv:'ｫ'),
    (Org:'ゃ'; Cnv:'ｬ'), (Org:'ゅ'; Cnv:'ｭ'), (Org:'ょ'; Cnv:'ｮ'), (Org:'っ'; Cnv:'ｯ'),
    (Org:'ゎ'; Cnv:'ﾜ'), (Org:'ゐ'; Cnv:'ｲ'), (Org:'ゑ'; Cnv:'ｴ')
  );

  C9ConvTable3 : Array[0..8] of Cv9Table = (
    (Org:'ｧ'; Cnv:'ｱ'), (Org:'ｨ'; Cnv:'ｲ'), (Org:'ｩ'; Cnv:'ｳ'), (Org:'ｪ'; Cnv:'ｴ'), (Org:'ｫ'; Cnv:'ｵ'),
    (Org:'ｬ'; Cnv:'ﾔ'), (Org:'ｭ'; Cnv:'ﾕ'), (Org:'ｮ'; Cnv:'ﾖ'), (Org:'ｯ'; Cnv:'ﾂ')
  );


// Tu7ZtoHConv
// ---------------------------------------------------------------------------

class function Tu7ZtoHConv.IsKanjiUp(AChar: AnsiCHAR): Boolean;
Begin
  Result := False;

  if ((Ord(AChar) >= 129) and (Ord(AChar) <= 159))
    or ((Ord(AChar) >= 224) and (Ord(AChar) <= 252)) then
  begin
    Result := True;
  end;
End;


class function Tu7ZtoHConv.IsKanjiUpS(AStr: AnsiString; n: Integer): Boolean;
var
  i: Integer;
begin
  Result := FALSE;

  // ｎバイト目が最終バイトの場合も除去(ごみ)
  if (Length(Astr) <= n) then
    Exit;

  i := 1;
  while (i < n) do begin
    if (IsKanjiUp(Astr[i]) = TRUE)
    then i := i + 2   // 漢字の次の文字に移動
    else i := i + 1;  // １バイト文字の次の文字に移動
  end;

  if (i = n) then begin
    // ｎバイト目は漢字の第２バイトではない
    if (IsKanjiUp(Astr[i]) = TRUE) then begin
      Result := TRUE;
    end;
  end;
End;


// 文字列を len 文字で切り詰める(Shift-JIS漢字対応)
class function Tu7ZtoHConv.StrLengthCut(
  const src: AnsiString; len: Integer): AnsiString;
var
  n: Integer;
  s: AnsiString;
begin
  s := Src;
  n := Length(s);

  if (len >= n) then begin
    Result := s;
    Exit;
  end;

  //  IsKanjiUpS は 文字列のｎバイト目が漢字の上半分かどうか判断する
  //  戻りが True なら漢字の上半分
  if (IsKanjiUpS(s, len))
  then Result := Copy(s, 1, len - 1)
  else Result := Copy(s, 1, len);
End;

// ---------------------------------------------------------------------------

// 文字列のサイズ調整(WideString)
class Function Tu7ZtoHConv.StrLengthCutWideStr(
 var src: WideString; ALen: Integer): WideString;
Var
 i    : Integer;
 n    : Integer;
 j    : Integer;
 c    : Integer;
 s    : WideString;
 sRes : WideString;
Begin
 s := src;
 n := Length(s);

 i := 1;
 j := 0;
 sRes := '';
 Try
   while ((i <= n) and (j <= ALen)) do begin
     c := Ord(s[i]);
     if((c >= $ff61) and (c <= $ffa0)) then begin
       // 半角カナ
       sRes := sRes + s[i];

       i := i + 1;
       j := j + 1;   // 半角=1バイト

     end else If((Word(s[i]) and $ff00) <> $0) Then Begin
       if((j + 2) > ALen) then
         Break;

       sRes := sRes + s[i];
       i := i + 1;
       j := j + 2;   // 漢字=2バイト

     end else begin
       sRes := sRes + s[i];

       i := i + 1;
       j := j + 1;   // 半角=1バイト
     end;
   end;
 Finally
   Result := sRes;
 End;
End;

// ---------------------------------------------------------------------------

class function Tu7ZtoHConv.ConvZenToHan(AStr: AnsiString): AnsiString;
  Function TableConv(AStr: AnsiString): AnsiString;
  Var
    i : Integer;
  Begin
    for i := Low(C9ConvTable) to High(C9ConvTable) do Begin
      if(C9ConvTable[i].Org = AStr) then begin
        Result := C9ConvTable[i].Cnv;
        Exit;
      End;
    end;

    for i := Low(C9ConvTable2) to High(C9ConvTable2) do Begin
      if(C9ConvTable2[i].Org = AStr) then begin
        Result := C9ConvTable2[i].Cnv;
        Exit;
      End;
    end;

    Result := AStr;
  End;
Var
  i : Integer;
  n : Integer;
  s : AnsiString;
begin
  // Result := AStr;
  Result := '';

  s := '';
  n := Length(AStr);
  i := 1;
  While(i <= n) do Begin
    s := AStr[i];
    if(IsKanjiUp(s[1])) then begin
      i := i + 1;
      s := s + AStr[i];

      Result := Result + TableConv(s);

    End else begin
      Result := Result + s;
    End;

    i := i + 1;
  End;
end;


class Function Tu7ZtoHConv.ConvHanToZen(AStr: AnsiString): AnsiString;
  Function TableConv(const AStr: AnsiString; Var ix: Integer): AnsiString;
  Var
    s : AnsiString;
    i : Integer;
  Begin
    if(Length(AStr) >= (ix + 1))
    then s := AStr[ix] + AStr[ix + 1]
    else s := AStr[ix];

    for i := Low(C9ConvTable) to High(C9ConvTable) do Begin
      if(C9ConvTable[i].Cnv = Copy(s,1, Length(C9ConvTable[i].Cnv))) then begin
        Result := C9ConvTable[i].Org;

        if(Length(C9ConvTable[i].Cnv) > 1) then
          ix := ix + (Length(C9ConvTable[i].Cnv) - 1);

        Exit;
      End;
    end;

    for i := Low(C9ConvTable2) to High(C9ConvTable2) do Begin
      if(C9ConvTable2[i].Cnv = Copy(s,1, Length(C9ConvTable2[i].Cnv))) then begin
        Result := C9ConvTable2[i].Org;

        if(Length(C9ConvTable2[i].Cnv) > 1) then
          ix := ix + (Length(C9ConvTable2[i].Cnv) - 1);

        Exit;
      End;
    end;

    Result := AStr[ix];
  End;
Var
  i : Integer;
  n : Integer;
  s : AnsiString;
begin
  Result := '';

  s := '';
  n := Length(AStr);
  i := 1;
  While(i <= n) do Begin
    s := AStr[i];
    if(IsKanjiUp(s[1])) then begin
      Result := Result + s;
      if((i + 1) <= n) then begin
        Result := Result + AStr[i + 1];
      end;

      i := i + 1;

    End else begin
      Result := Result + TableConv(AStr, i);
    End;

    i := i + 1;
  End;
End;


class function Tu7ZtoHConv.ConvZenToHanAK(AStr: AnsiString): AnsiString;
  Function TableConv(AStr: AnsiString): AnsiString;
  Var
    i : Integer;
  Begin
    for i := Low(C9ConvTable) to High(C9ConvTable) do Begin
      if(C9ConvTable[i].Org = AStr) then begin
        Result := C9ConvTable[i].Cnv;
        Exit;
      End;
    end;

    Result := AStr;
  End;
Var
  i : Integer;
  n : Integer;
  s : AnsiString;
begin
  Result := '';

  s := '';
  n := Length(AStr);
  i := 1;
  While(i <= n) do Begin
    s := AStr[i];
    if(IsKanjiUp(s[1])) then begin
      i := i + 1;
      s := s + AStr[i];

      Result := Result + TableConv(s);

    End else begin
      Result := Result + s;
    End;

    i := i + 1;
  End;
end;


class function Tu7ZtoHConv.GetConvCSVList: AnsiString;
Var
  i : Integer;
begin
  Result := '';

  // 単語変換(ローマ字、数字、かな、カナ)
  for i := Low(C9ConvTable) to High(C9ConvTable) do Begin
    Result := Result + C9ConvTable[i].Org
      + ', ' + C9ConvTable[i].Cnv + Chr($0d) + Chr($0a);
  end;
end;


// ---------------------------------------------------------------------------

class function Tu7ZtoHConv.StringStripNoNum(const ASrc : AnsiString): AnsiString;
Var
  i, n : Integer;
  s    : AnsiString;
Begin
  Result := '';

  s := ConvZenToHanAK(ASrc);
  n := Length(s);
  i := 1;
  While (i <= n) do begin
    // 漢字判別処理
    If (IsKanjiUp(s[i])) Then Begin
      If( s[i] = AnsiCHAR($82) ) Then Begin
        i := i + 1;

        If((s[i] >= AnsiCHAR($4f)) AND (s[i] <= AnsiCHAR($58)) ) Then Begin
          Result := Result + AnsiChar(Ord(s[i]) - $4f + Ord('0'));
        End;

      End Else Begin
        i := i + 1;
      End;

    End Else Begin
      If( (s[i] >= '0') AND (s[i] <= '9') ) Then Begin
        Result := Result + s[i];
      End;
    End;

    i := i + 1;
  End;
End;


// ---------------------------------------------------------------------------

class function Tu7ZtoHConv.StripCRLF(
  const src: AnsiString; ANumHan: Boolean): AnsiString;
Var
  i, j, n: Integer;
begin
  Result := '';

  n := Length(src);
  i := 1;
  While (i <= n) Do Begin
    If(IsKanjiUp(src[i])) Then Begin
      If((i + 1) > n) Then
        Break;

      If(src[i] = AnsiCHAR($81)) then Begin  // 全角スペース
        If(src[i + 1] = AnsiCHAR($40)) then Begin
          i := i + 2;

          j := Length(Result);
          If(j > 0) Then
            If(Result[j] <> ' ') then
              Result := Result + ' ';

          Continue;
        End;

      End Else If(src[i] = AnsiCHAR($82)) Then Begin // 全角数字
        if(ANumHan) then begin
          If((src[i + 1] >= AnsiCHAR($4f))
            AND (src[i + 1] <= AnsiCHAR($58))) then
          Begin
            Result := Result + AnsiCHAR($30 + (Ord(src[i + 1]) - $4f));
            i := i + 2;
            Continue;
          End;
        end else begin
          Result := Result + src[i];
          Result := Result + src[i + 1];
          i := i + 2;
          Continue;
        end;
      End;
      Result := Result + src[i];
      Result := Result + src[i + 1];
      i := i + 2;

    End Else Begin
      j := Ord(src[i]);
      Case j Of
        $0a: Begin  ; End;
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
End;

// ---------------------------------------------------------------------------
   // 文字列が全部数字であるかどうか判断,'-','.'もダメ
class function Tu7ZtoHConv.IS_SNUMERIC2(aStr: String) : Boolean;
var
  SS1 : Integer;
  SS2 : Integer;
  Flg : Boolean;
begin
  Result := False;
  if Length(aStr) < 1 then Exit;

  for SS1 := 1 to Length(aStr) do
  begin
    Flg := False;
    for SS2 := 0 to 9 do
    begin
      if aStr[SS1] = IntToStr(SS2) then
      begin                    {０－９ のどれかに合致}
        Flg := True;
        Break;
      end;
    end;
    if Flg = False then Exit;   {０－９のすべて、マイナス、小数点と合致しない}
  end;
  Result := True;
end;

// ---------------------------------------------------------------------------
// NO-BREAK SPACE(ノーブレークスペース) を半角スペースに置き換える
class function Tu7ZtoHConv.NoBreakSpace_Removed(aStr: String) : String;
  function CharacterCode_Distinction(AChar: CHAR): Boolean;
  begin
    Result := False;

    if Format('%4.4x', [Ord(AChar)]) = '00A0'
    then Result := True;
  end;

var
  i : Integer;
begin
  Result := '';

  for i := 1 to length(aStr) do
  begin
   if (CharacterCode_Distinction(aStr[i]) = TRUE)
   then Result := Result + ' '
   else Result := Result + aStr[i];
  end;
end;

// ---------------------------------------------------------------------------
// 文字列の前後・中にあるすべてのスペースを取り除く
class function Tu7ZtoHConv.AllSpaceRemoved(aStr: String) : String;
var
  s : String;
begin
  // NO-BREAK SPACEを半角スペースに置き換え
  aStr := NoBreakSpace_Removed(aStr);
  // 前後のスペースを取り除きつつ全角スペースを半角スペースに置き換え
  s := Trim(StringReplace(aStr,'　',' ',[rfReplaceAll]));
  // 前後に全角スペースがあった場合の為に再度Trimしつつ半角スペースを排除
  Result := Trim(StringReplace(s, ' ', '', [rfReplaceAll]));
end;

// ---------------------------------------------------------------------------
// 文字列の中にある改行コードを半角スペースに置き換える
class function Tu7ZtoHConv.AllLfCodeRemoved(aStr: String) : String;
var
  s : String;
begin
  s      := Trim(StringReplace(aStr, #10#13, ' ',[rfReplaceAll]));
  Result := Trim(StringReplace(s, #$D#$A, ' ',[rfReplaceAll]));
end;

// ---------------------------------------------------------------------------
// 全角から半角への変換※ひらがなは変換しない(UTF-8　2バイト以上の文字を含む場合)
class function Tu7ZtoHConv.ConvZenToHanAKUTF8(AStr: String): String;
  function TableConv(AStr: AnsiString): AnsiString;
  var
    i : Integer;
  begin
    for i := Low(C9ConvTable) to High(C9ConvTable) do
    begin
      if(C9ConvTable[i].Org = AStr) then
      begin
        Result := C9ConvTable[i].Cnv;
        Exit;
      end;
    end;

    Result := AStr;
  end;

  function GetStrByte(AChar: CHAR): Integer;
  var
    Encoding: TEncoding;
  begin
    Encoding := TEncoding.GetEncoding(65001); //UTF-8：コードページ 65001
    Result := Encoding.GetByteCount(AStr);
    Encoding.Free;
  end;

  function GetCheType(AChar: CHAR): String;
  begin
    Result := '';

    case Ord(AChar) of
      0..9 :           Result := 'Num';     //半角数字
      32..126:         Result := 'Alph';    //半角アルファベット+記号
      12354..12435:    Result := 'Hira';    //ひらがな
      12296..12311,
        12436..12543:  Result := 'Kata';    //カタカナ(全+半)+記号
      19968..40955:    Result := 'Knji';    //漢字
      65283..65312:    Result := 'ZenNum';  //全角数字+記号
      65313..65370:    Result := 'ZenAlph'; //全角アルファベット+記号
    end;
  end;
var
  i : Integer;
  n : Integer;
  s : String;
begin
  Result := '';

  AStr := NoBreakSpace_Removed(AStr);
  AStr := StringReplace(AStr, '　', ' ', [rfReplaceAll,rfIgnoreCase]);
  s := '';
  n := Length(AStr);
  i := 1;
  while(i <= n) do
  begin
    s := copy(AStr, 1, 1);
    begin
      if (GetCheType(s[1]) = 'Num')
        or (GetCheType(s[1]) = 'Alph')
        or (GetCheType(s[1]) = 'Kata')
        or (GetCheType(s[1]) = 'ZenNum')
        or (GetCheType(s[1]) = 'ZenAlph') then
      begin
        Result := Result + String(TableConv(AnsiString(s)));
        AStr := copy(AStr, 2, Length(Astr));
      end else
      begin
       Result := Result + s;
       AStr := copy(AStr, 2, Length(Astr));
      end;
    end;
    i := i + 1;
  end;
end;

// ---------------------------------------------------------------------------
// 文字列の中に特定の文字列が何個あるかカウントする
class function Tu7ZtoHConv.GetHowMany(aStr, IncStr : string): integer;
var
  p:integer;
begin
  result := 0;
  p := AnsiPos(AnsiString(aStr), AnsiString(IncStr));
  while p > 0 do
  begin
    Inc(result);
    IncStr := String(RightStr(AnsiString(IncStr), (Length(AnsiString(IncStr)) -p)));
    p := AnsiPos(AnsiString(aStr), AnsiString(IncStr));
  end;
end;

// ---------------------------------------------------------------------------
// 半角カタカナの小文字を大文字に置き換える
class function Tu7ZtoHConv.KanaUpperCase(aStr: AnsiString): AnsiString;
  function TableConv(aStr: AnsiString): AnsiString;
  var
    i : Integer;
  begin
    for i := Low(C9ConvTable3) to High(C9ConvTable3) do
    begin
      if(C9ConvTable3[i].Org = aStr) then
      begin
        Result := C9ConvTable3[i].Cnv;
        Exit;
      end;
    end;
    Result := aStr;
  end;

var
  i : Integer;
  n : Integer;
  s : AnsiString;
begin
  Result := '';

  s := '';
  n := Length(aStr);
  i := 1;
  while (i <= n) do
  begin
    s := aStr[i];
    Result := Result + TableConv(s);

    i := i + 1;
  end;
end;

// ---------------------------------------------------------------------------
// 文字列を指定したバイト数で長さをそろえる
class function Tu7ZtoHConv.ModifyLengthInByte(AStr: String; ALen: Integer): String;
var
  s : AnsiString;
begin
  Result := TrimRight(AStr);

  s := AnsiString(Result);
  if Length(s) <= ALen then
    Exit;

  if IsKanjiUpS(s, ALen) then
    Result := String(Copy(s, 1, ALen - 1))
  else
    Result := String(Copy(s, 1, ALen));
end;

// ---------------------------------------------------------------------------
// アルファベットの次のアルファベットを取得する
class function Tu7ZtoHConv.GetNextAlpha(AStr: AnsiString): AnsiString;
  //半角アルファベットかどうか
  function IsAlphabet(AChar: AnsiCHAR): Boolean;
  begin
    Result := (Ord(AChar) in [65..90, 97..122]);
  end;

var
  i : Integer;
begin
  Result := '';

  if Length(AStr) > 1 then
    Exit;

  if not IsAlphabet(AStr[1]) then
    Exit;

  for i := Low(C9ConvTable) to High(C9ConvTable) do
  begin
    if(C9ConvTable[i].Cnv = AStr) then
    begin
      Result := C9ConvTable[i + 1].Cnv;
      Exit;
    end;
  end;
end;


end.


