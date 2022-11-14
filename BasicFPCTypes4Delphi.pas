Unit BasicFPCTypes4Delphi;

Interface
{$IFDEF MSWINDOWS}
Uses Windows;
{$ENDIF}

type QWord = uint64;
     PQWord = ^QWord;
     ValReal = Extended;
     DWord = uint32;
     TWordArray = Array[0..(maxint - 1) div sizeOf(Word) - 1] of word;
     PWordArray = ^TWordArray;
     TLongWordArray = Array[0..(maxint - 1) div sizeOf(LongWord) - 1] of LongWord;
     PLongWordArray = ^TLongWordArray;

     {$IFDEF CPU32BITS}
     SizeInt = LongInt;
     {$ENDIF}
     {$IFDEF CPU64BITS}
     SizeInt = Int64;
     {$ENDIF}
const
     FPC_FULLVERSION = 30399; // 30400 mit hat sich scheinbar einiges geändert
     {$IFDEF MSWINDOWS}
     AllFilesMask = '*.*';
     {$ELSE}
     AllFilesMask = '*';
     {$ENDIF}
     {$IFDEF MSWINDOWS}
     MaxPathLen = windows.MAX_PATH;
     {$ENDIF}

procedure FillWord(var data; wordCount: integer; fillValue: word);
function SetDirSeparators(const aPath: string): string;
function GetLocalTimeOffset: integer;
function RPos(aCharToFind: char; const aString: string): integer;


function SwapEndian(const AValue: SmallInt): SmallInt; inline; overload;
function SwapEndian(const AValue: Word): Word; inline; overload;
function SwapEndian(const AValue: LongInt): LongInt; inline; overload;
function SwapEndian(const AValue: DWord): DWord; inline; overload;
function SwapEndian(const AValue: Int64): Int64; overload;
function SwapEndian(const AValue: QWord): QWord; overload;

function BEtoN(const AValue: SmallInt): SmallInt; inline; overload;
function BEtoN(const AValue: Word): Word; inline; overload;
function BEtoN(const AValue: LongInt): LongInt; inline; overload;
function BEtoN(const AValue: DWord): DWord; inline; overload;
function BEtoN(const AValue: Int64): Int64; inline; overload;
function BEtoN(const AValue: QWord): QWord; inline; overload;

function NtoBE(const AValue: SmallInt): SmallInt; inline; overload;
function NtoBE(const AValue: Word): Word; inline; overload;
function NtoBE(const AValue: LongInt): LongInt; inline; overload;
function NtoBE(const AValue: DWord): DWord; inline; overload;
function NtoBE(const AValue: Int64): Int64; inline; overload;
function NtoBE(const AValue: QWord): QWord; inline; overload;

Implementation
uses DateUtils, SysUtils;

procedure FillWord(var data; wordCount: integer; fillValue: word);
var wordArray: array [0..0] of word absolute data;
    i: integer;
begin
  {$R-}
  for i:= 0 to wordCount do
      wordArray[i]:= fillValue;
end;

function SetDirSeparators(const aPath: string): string;
begin
  result:= aPath; // Todo: check implementation
end;

function GetLocalTimeOffset: integer;
begin
  result:= round(TTImeZone.Local.UtcOffset.TotalMinutes);
end;

function RPos(aCharToFind: char; const aString: string): integer;
begin
  result:= LastDelimiter(aCharToFind, aString);
end;

function SwapEndian(const AValue: SmallInt): SmallInt; inline; overload;
  begin
    { the extra Word type cast is necessary because the "AValue shr 8" }
    { is turned into "longint(AValue) shr 8", so if AValue < 0 then    }
    { the sign bits from the upper 16 bits are shifted in rather than  }
    { zeroes.                                                          }
    Result := SmallInt(((Word(AValue) shr 8) or (Word(AValue) shl 8)) and $ffff);
  end;

function SwapEndian(const AValue: Word): Word; inline; overload;
  begin
    Result := ((AValue shr 8) or (AValue shl 8)) and $ffff;
  end;

function SwapEndian(const AValue: LongInt): LongInt; inline; overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00) or ((AValue shr 8) and $00FF00FF);
    Result := (Result shl 16) or (Result shr 16);
  end;

function SwapEndian(const AValue: DWord): DWord; inline; overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00) or ((AValue shr 8) and $00FF00FF);
    Result := (Result shl 16) or (Result shr 16);
  end;

function SwapEndian(const AValue: Int64): Int64; overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00FF00FF00) or
            ((AValue shr 8) and $00FF00FF00FF00FF);
    Result := ((Result shl 16) and $FFFF0000FFFF0000) or
            ((Result shr 16) and $0000FFFF0000FFFF);
    Result := (Result shl 32) or ((Result shr 32));
  end;

function SwapEndian(const AValue: QWord): QWord; overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00FF00FF00) or
            ((AValue shr 8) and $00FF00FF00FF00FF);
    Result := ((Result shl 16) and $FFFF0000FFFF0000) or
            ((Result shr 16) and $0000FFFF0000FFFF);
    Result := (Result shl 32) or ((Result shr 32));
  end;

{$IFDEF CPUARM}
  {$undef ENDIAN_BIG}
{$ENDIF}
{$IFDEF CPUX86}
  {$undef ENDIAN_BIG}
{$ENDIF}
{$IFDEF CPUX64}
  {$undef ENDIAN_BIG}
{$ENDIF}

function BEtoN(const AValue: SmallInt): SmallInt; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: Word): Word; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: LongInt): LongInt; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: DWord): DWord; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: Int64): Int64; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function BEtoN(const AValue: QWord): QWord; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function NtoBE(const AValue: SmallInt): SmallInt; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function NtoBE(const AValue: Word): Word; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function NtoBE(const AValue: LongInt): LongInt; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function NtoBE(const AValue: DWord): DWord; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function NtoBE(const AValue: Int64): Int64; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function NtoBE(const AValue: QWord): QWord; inline; overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


end.

