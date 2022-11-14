# fppdf4delphi

This is a port of the FreePascal PDF lib to Delphi XE11
(other version not testet) - especially to use it on Android.

Since the compatibility of the RTL between Delphi and FreePascal is dimishing some more imports have been neccesary.
Therefor two helper units are implented which hold the types used by FreePascal and are not available in Delphi.

Also included are free pascal libs for images and jpegs (not all units of the libs are needed).

Since some PDF features are missing they may be added here.

Known Bug: On Windows the drawing coordinates have a problem.


