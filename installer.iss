[Setup]
AppName=Open Saw
AppVersion=1.0.0
DefaultDirName={autopf}\OpenSaw
DefaultGroupName=Open Saw
OutputDir=.
OutputBaseFilename=OpenSaw-Setup
Compression=lzma
SolidCompression=yes
SetupIconFile=icon.ico
UninstallDisplayIcon={app}\saw.exe
ChangesEnvironment=yes
PrivilegesRequired=lowest

[Files]
Source: "rust\target\release\saw.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "icon.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; Start Menu shortcut opens the command prompt explicitly so the CLI stays open
Name: "{group}\Open Saw"; Filename: "cmd.exe"; Parameters: "/k ""{app}\saw.exe"""; IconFilename: "{app}\icon.ico"; WorkingDir: "{userprofile}"
; Desktop shortcut opens the command prompt explicitly so the CLI stays open
Name: "{autodesktop}\Open Saw"; Filename: "cmd.exe"; Parameters: "/k ""{app}\saw.exe"""; IconFilename: "{app}\icon.ico"; WorkingDir: "{userprofile}"

[Registry]
; Standard append to system PATH to allow the user to type "saw" in any terminal
Root: HKCU; Subkey: "Environment"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; Check: NeedsAddPath(ExpandConstant('{app}'))

[Code]
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_CURRENT_USER, 'Environment', 'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;
