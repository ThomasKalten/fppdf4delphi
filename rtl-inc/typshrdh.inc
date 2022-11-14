{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2015 by Marco van de Voort
    member of the Free Pascal development team.

    Types that are in unit types on all platforms but also in 
    unit Windows on win<x> 

    Name is types shared, but 8.3'd to typshard

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

// the aliases without "T" remain unit Windows only, so are in unit Windows, not here.
// note 2.6.x requires a space after the operator, 3.x.x seems to fix it.
// tried to make all records unions with an array type as second form, but that
// fails because of the properties. TRect doesn't suffer from this because it has
// getters/setters in the properties instead of field references

  TArray4IntegerType = array[0..3] of Longint;

  PSmallPoint = ^TSmallPoint;
  TSmallPoint =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
  packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
  record
      X,
      Y : SmallInt;
      end;

  TSize =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
  packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
  record
      cx : Longint; cy : Longint;
     public
       {$ifdef VER3}
       constructor Create(ax,ay:Longint); overload;
       constructor Create(asz :TSize); overload;
       {$endif}
       function Add(const asz: TSize): TSize;
       function Distance(const asz : TSize) : Double;
       function IsZero : Boolean;
       function Subtract(const asz : TSize): TSize;
       {$IFDEF FPC}
       class operator = (const asz1, asz2 : TSize) : Boolean;
       class operator <> (const asz1, asz2 : TSize): Boolean;
       class operator + (const asz1, asz2 : TSize): TSize;
       class operator - (const asz1, asz2 : TSize): TSize;
       {$ELSE}
       class operator Equal (const asz1, asz2 : TSize) : Boolean;
       class operator NotEqual (const asz1, asz2 : TSize): Boolean;
       class operator Add (const asz1, asz2 : TSize): TSize;
       class operator Subtract (const asz1, asz2 : TSize): TSize;
       {$ENDIF}
       property Width : Longint read cx write cx;
       property Height: Longint read cy write cy;
     end;
  PSize =^TSize;

  TPoint  =
  {$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
   packed
  {$endif FPC_REQUIRES_PROPER_ALIGNMENT}
  record
       X : Longint; Y : Longint;
     public
       {$ifdef VER3}
       constructor Create(ax,ay:Longint); overload;
       constructor Create(apt :TPoint); overload;
       {$endif}
       class function Zero: TPoint; static; inline;
       function Add(const apt: TPoint): TPoint;
       function Distance(const apt: TPoint) : ValReal;
       function IsZero : Boolean;
       function Subtract(const apt : TPoint): TPoint;
       procedure SetLocation(const apt :TPoint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure SetLocation(ax,ay : Longint);  {$IFNDEF FPC} overload; {$ENDIF}
       procedure Offset(const apt :TPoint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure Offset(dx,dy : Longint); {$IFNDEF FPC} overload; {$ENDIF}
       class function PointInCircle(const apt, acenter: TPoint; const aradius: Integer): Boolean; static; inline;
       class operator {$IFDEF FPC} =  {$ELSE} Equal {$ENDIF} (const apt1, apt2 : TPoint) : Boolean;
       class operator {$IFDEF FPC} <> {$ELSE} NotEqual {$ENDIF} (const apt1, apt2 : TPoint): Boolean;
       class operator {$IFDEF FPC} +  {$ELSE} Add {$ENDIF} (const apt1, apt2 : TPoint): TPoint;
       class operator {$IFDEF FPC} - {$ELSE} Subtract {$ENDIF} (const apt1, apt2 : TPoint): TPoint;
       class operator {$IFDEF FPC}:= {$ELSE} Implicit {$ENDIF} (const aspt : TSmallPoint) : TPoint;
       class operator Explicit (Const apt : TPoint) : TSmallPoint;
     end;
  PPoint = ^TPoint;

  TSplitRectType = (
    srLeft,
    srRight,
    srTop,
    srBottom
  );

  { TRect }

  TRect =
{$ifndef FPC_REQUIRES_PROPER_ALIGNMENT}
  packed
{$endif FPC_REQUIRES_PROPER_ALIGNMENT}
  record
     private
       function  getHeight: Longint; inline;
       function  getLocation: TPoint;
       function  getSize: TSize;
       function  getWidth : Longint; inline;
       procedure setHeight(AValue: Longint);
       procedure setSize(AValue: TSize);
       procedure setWidth (AValue: Longint);
     public
       constructor Create(Origin: TPoint); {$IFNDEF FPC} overload; {$ENDIF} // empty rect at given origin
       constructor Create(Origin: TPoint; AWidth, AHeight: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       constructor Create(ALeft, ATop, ARight, ABottom: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       constructor Create(P1, P2: TPoint; Normalize: Boolean = False); {$IFNDEF FPC} overload; {$ENDIF}
       constructor Create(R: TRect; Normalize: Boolean = False); {$IFNDEF FPC} overload; {$ENDIF}
       class operator {$IFDEF FPC} = {$ELSE} Equal {$ENDIF} (L, R: TRect): Boolean;
       class operator {$IFDEF FPC}<> {$ELSE} NotEqual {$ENDIF} (L, R: TRect): Boolean;
       class operator {$IFDEF FPC} + {$ELSE} Add {$ENDIF} (L, R: TRect): TRect; // union
       class operator {$IFDEF FPC} * {$ELSE} Multiply {$ENDIF} (L, R: TRect): TRect; // intersection
       class function Empty: TRect; static;
       procedure NormalizeRect;
       function IsEmpty: Boolean;
       function Contains(Pt: TPoint): Boolean; {$IFNDEF FPC} overload; {$ENDIF}
       function Contains(R: TRect): Boolean; {$IFNDEF FPC} overload; {$ENDIF}
       function IntersectsWith(R: TRect): Boolean;
       class function Intersect(R1: TRect; R2: TRect): TRect; {$IFNDEF FPC} overload; {$ENDIF} static;
       procedure Intersect(R: TRect); {$IFNDEF FPC} overload; {$ENDIF}
       class function Union(R1, R2: TRect): TRect; {$IFNDEF FPC} overload; {$ENDIF} static;
       procedure Union(R: TRect); {$IFNDEF FPC} overload; {$ENDIF}
       class function Union(const Points: array of TPoint): TRect; {$IFNDEF FPC} overload; {$ENDIF} static;
       procedure Offset(DX, DY: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure Offset(DP: TPoint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure SetLocation(X, Y: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure SetLocation(P: TPoint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure Inflate(DX, DY: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       procedure Inflate(DL, DT, DR, DB: Longint); {$IFNDEF FPC} overload; {$ENDIF}
       function CenterPoint: TPoint;
       function SplitRect(SplitType: TSplitRectType; ASize: Longint): TRect; {$IFNDEF FPC} overload; {$ENDIF}
       function SplitRect(SplitType: TSplitRectType; Percent: Double): TRect; {$IFNDEF FPC} overload; {$ENDIF}
     public
       property Height: Longint read getHeight write setHeight;
       property Width : Longint read getWidth  write setWidth;
       property Size  : TSize   read getSize   write setSize;
       property Location  : TPoint read getLocation write setLocation;
       case Longint of
         0: (Left,Top,Right,Bottom : Longint);
         1: (TopLeft,BottomRight : TPoint);
         2: (Vector:TArray4IntegerType);
       end;
  PRect = ^TRect;


