# AudirvanaToolkit
Script to export playlist files (e.g. m3u) from Audirvana with PowerShell.

# Example
```
PS C:\> Export-AudirvanaPlaylists -pDestination "D:\Music\Playlists" -sDB "C:\Users\WhereTheTimeWent\AudirvanaPlusDatabaseV2.sqlite"
```
This example exports all playlists from Audirvana to "D:\Music\Playlists" as .m3u8 files.

# Parameters
> -pDestination

Mandatory. Path to where the playlist files get exported to. If it doesn't exist, the script tries to create it.

> -sDB

Mandatory. Path of your Audirvana SQLite database. If you don't know where yours is, check Audirvana settings (library file).

> -sFileExtension

Not mandatory. Defaults to .m3u8. Could be changed to .m3u, .txt or pretty much anything else.

# How to run it on Windows

1. Launch PowerShell with administrator privileges, type 
```
Set-ExecutionPolicy RemoteSigned
Install-Module PSSQLite
```
2. Import the script to your current PowerShell session, edit the path and type
```
Import-Module "C:\Path\To\File\AudirvanaToolkit.ps1"
```
3. To permanently import script, type
```
notepad.exe $Profile
```
4. Paste the text from 2. into the notepad window and save
5. Start PowerShell (no administrator privileges needed), type
```
Export-AudirvanaPlaylists
```
... and the script should start.
