; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "CloudCompare"
#define MyAppVersion "2.6.0"
#define MyAppPublisher "Daniel Girardeau-Montaut"
#define MyAppURL "http://www.cloudcompare.org/"
#define MyAppExeName "CloudCompare.exe"
#define MyVCRedistPath "E:\These\C++\CloudCompare\vc_redist"
#define MyFaroRedistPath "E:\These\C++\Faro\FARO LS\redist"
#define MyCCPath "E:\These\C++\CloudCompare\bin_x64_msvc_2012\CloudCompare"
#define MyOutputDir "E:\These\C++\CloudCompare\bin_x64_msvc_2012"
#define MyCreationDate GetDateTimeString('mm_dd_yyyy', '', '')

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppID={{4DE0A2C8-03F9-4B3F-BAFC-1D5F2141464B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DefaultGroupName={#MyAppName}
UninstallDisplayIcon={app}\{#MyAppExeName}
AllowNoIcons=true
OutputBaseFilename={#MyAppName}_v{#MyAppVersion}_setup_x64
Compression=lzma2/Ultra64
SolidCompression=true
OutputDir={#MyOutputDir}
InternalCompressLevel=Ultra64
; "ArchitecturesAllowed=x64" specifies that Setup cannot run on
; anything but x64.
ArchitecturesAllowed=x64
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
ArchitecturesInstallIn64BitMode=x64

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1
; Warning: update the 'Faro support' checbkox index in the NextButtonClick method if you insert another checbkox above this one!!!
Name: "StartMenuEntry" ; Description: "Install Faro I/O plugin (to load FWS/FLS files). The will install Faro LS redistributable package as well." ; GroupDescription: "Faro LS support";  Flags: unchecked

[Files]
Source: "{#MyCCPath}\CloudCompare.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MyCCPath}\*"; Excludes: "*.manifest,QBRGM*.dll,QFARO*.dll"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "{#MyVCRedistPath}\2012\vcredist_x64.exe"; DestDir: {tmp}; Flags: deleteafterinstall 64bit;
; FARO LS support
Source: "{#MyFaroRedistPath}\x64\FARO LS 5.3.3.38662 x64 Setup.exe"; DestDir: {tmp}; Flags: deleteafterinstall 64bit; Check: WithFaro
Source: "{#MyFaroRedistPath}\x64\{#MyAppExeName}.manifest"; DestDir: "{app}"; Flags: ignoreversion; Check: WithFaro
Source: "{#MyCCPath}\plugins\QFARO*.dll"; DestDir: "{app}\plugins"; Flags: ignoreversion; Check: WithFaro

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
Filename: "{tmp}\vcredist_x64.exe"; Parameters: "/q"
Filename: "{tmp}\FARO LS 5.3.3.38662 x64 Setup.exe"; Check: WithFaro

[Code]
var
  WithFaroSupport: Boolean;

function WithFaro: Boolean;
begin
  Result := WithFaroSupport;
end;

/////////////////////////////////////////////////////////////////////
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;

  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/SILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      Result := 3
    else
      Result := 2;
  end else
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;

/////////////////////////////////////////////////////////////////////
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if (CurPageID = wpSelectTasks) then
  begin
    //'Faro support' checbkox is the 2nd one but each checkbox is nested
    //inside a group, and each group conuts as 1!
    WithFaroSupport := WizardForm.TasksList.Checked[3];
  end;
end;
