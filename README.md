# fppdf4delphi

This is a port of the FreePascal PDF lib to Delphi XE11
(other version not testet) - especially to use it on Android.
Partially adapted to Delphi 6/7 to use the TT-Font registery.

Since the compatibility of the RTL between Delphi and FreePascal is dimishing some more imports have been neccesary.
Therefor two helper units are implemented which hold the types used by FreePascal and are not available in Delphi.

Also included are free pascal libs for images and jpegs (not all units of the libs are needed).

Some units needed adaptions for compilation with Delphi included renames from pp to pas file name extension.

All the code is LGPL as the original code.

Known Bug: 
On Windows the drawing coordinates have a problem. 
The reason may be: type TPoint, TRect etc. are used by win-dll imports and don't use pascal implementations to manipulate them.
