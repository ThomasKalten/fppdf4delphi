Unit BasicFPCTypes4Delphi;

Interface
{$IFDEF MSWINDOWS}
Uses Windows;
{$ENDIF}

{$IF CompilerVersion > 20 }
  {$LEGACYIFEND OFF}
  {$DEFINE HASINLINE}
{$IFEND}  

type QWord = {$IF CompilerVersion > 20 } uint64 {$ELSE} int64 {$IFEND};
     PQWord = ^QWord;
     ValReal = Extended;
     DWord = {$IF CompilerVersion > 20 } uint32 {$ELSE} LongWord {$IFEND};
     TWordArray = Array[0..(maxint - 1) div sizeOf(Word) - 1] of word;
     PWordArray = ^TWordArray;
     TLongWordArray = Array[0..(maxint - 1) div sizeOf(LongWord) - 1] of LongWord;
     PLongWordArray = ^TLongWordArray;

     {$IF CompilerVersion <= 20 }
     SizeInt = Longint;
     {$ELSE}
     {$IFDEF CPU32BITS}
     SizeInt = LongInt;
     {$ENDIF}
     {$IFDEF CPU64BITS}
     SizeInt = Int64;
     {$ENDIF}
     {$IFEND}
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
{$IF  CompilerVersion > 20}
function GetLocalTimeOffset: integer;
{$IFEND}
function RPos(aCharToFind: char; const aString: string): integer;


function SwapEndian(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function SwapEndian(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function SwapEndian(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function SwapEndian(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function SwapEndian(const AValue: Int64): Int64; overload;
{$IF  CompilerVersion > 20}
function SwapEndian(const AValue: QWord): QWord; overload;
{$IFEND}

function BEtoN(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function BEtoN(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function BEtoN(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function BEtoN(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function BEtoN(const AValue: Int64): Int64; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
{$IF  CompilerVersion > 20}
function BEtoN(const AValue: QWord): QWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
{$IFEND}

function NtoBE(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function NtoBE(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function NtoBE(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function NtoBE(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
function NtoBE(const AValue: Int64): Int64; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
{$IF  CompilerVersion > 20}
function NtoBE(const AValue: QWord): QWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
{$IFEND}

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

{$IF  CompilerVersion > 20}
function GetLocalTimeOffset: integer;
begin
  result:= round(TTImeZone.Local.UtcOffset.TotalMinutes);
end;
{$IFEND}

function RPos(aCharToFind: char; const aString: string): integer;
begin
  result:= LastDelimiter(aCharToFind, aString);
end;

function SwapEndian(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    { the extra Word type cast is necessary because the "AValue shr 8" }
    { is turned into "longint(AValue) shr 8", so if AValue < 0 then    }
    { the sign bits from the upper 16 bits are shifted in rather than  }
    { zeroes.                                                          }
    Result := SmallInt(((Word(AValue) shr 8) or (Word(AValue) shl 8)) and $ffff);
  end;

function SwapEndian(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    Result := ((AValue shr 8) or (AValue shl 8)) and $ffff;
  end;

function SwapEndian(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00) or ((AValue shr 8) and $00FF00FF);
    Result := (Result shl 16) or (Result shr 16);
  end;

function SwapEndian(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
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

{$IF  CompilerVersion > 20}
function SwapEndian(const AValue: QWord): QWord; overload;
  begin
    Result := ((AValue shl 8) and $FF00FF00FF00FF00) or
            ((AValue shr 8) and $00FF00FF00FF00FF);
    Result := ((Result shl 16) and $FFFF0000FFFF0000) or
            ((Result shr 16) and $0000FFFF0000FFFF);
    Result := (Result shl 32) or ((Result shr 32));
  end;
{$IFEND}

{$IFDEF CPUARM}
  {$undef ENDIAN_BIG}
{$ENDIF}
{$IFDEF CPUX86}
  {$undef ENDIAN_BIG}
{$ENDIF}
{$IFDEF CPUX64}
  {$undef ENDIAN_BIG}
{$ENDIF}

function BEtoN(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} 
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} 
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} 
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function BEtoN(const AValue: Int64): Int64; {$IFDEF HASINLINE} inline; {$ENDIF} 
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

{$IF  CompilerVersion > 20}
function BEtoN(const AValue: QWord): QWord; inline;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;
{$IFEND}

function NtoBE(const AValue: SmallInt): SmallInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function NtoBE(const AValue: Word): Word; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function NtoBE(const AValue: LongInt): LongInt; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


function NtoBE(const AValue: DWord): DWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;

function NtoBE(const AValue: Int64): Int64; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;


{$IF  CompilerVersion > 20}
function NtoBE(const AValue: QWord): QWord; {$IFDEF HASINLINE} inline; {$ENDIF} overload;
  begin
    {$IFDEF ENDIAN_BIG}
      Result := AValue;
    {$ELSE}
      Result := SwapEndian(AValue);
    {$ENDIF}
  end;
{$IFEND}

end.

