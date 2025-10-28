; ==============================================
; AB TEX Windows Installer - Inno Setup Script
; Compatible with local + GitHub Actions CI/CD build
; ==============================================

#define MyAppName "Ab tex"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Tamilzorous"
#define MyAppExeName "abtex.exe"
#define MyAppAssocName MyAppName + " File"
#define MyAppAssocExt ".exe"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; --- App Info ---
AppId={{2A069C22-5266-4A4F-BACA-827916F091E9}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}

; --- Architecture & Permissions ---
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin

; --- Output ---
OutputDir=dist
OutputBaseFilename=abtex_installer
SetupIconFile=assets\ab_textile_logo.ico
        Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; \
  GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; --- Main Executable & Dependencies ---
; ✅ Path adjusted for both local + GitHub Actions Flutter builds
Source: "build\windows\x64\runner\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
        Source: "build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
        Source: "build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; \
  Flags: recursesubdirs createallsubdirs ignoreversion

; --- Optional: Add additional config or assets if needed ---
; Source: "extra\config.json"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
; --- Start Menu & Desktop Shortcuts ---
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; --- Launch App After Install ---
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
