# AudirvanaToolkit
Script to export playlist files (e.g. m3u) from Audirvana with PowerShell.

Audirvana is an incredible audio player I just discovered a few days before writing this script: https://audirvana.com/

# Why would I need this?
I used iTunes for years, but every device I want my music synced to is not an Apple product.
After many years of using third party software (which always had at least one downside), I wrote my own PowerShell script that syncs my music from iTunes to my Android phone and other devices.

A few days before I posted this script, I discovered Audirvana, fell in love with it and decided to use it instead of iTunes.

So far I used this (actually great) tool to export playlists from iTunes via CLI: http://www.ericdaugherty.com/dev/itunesexport

With Audirvana I needed something new to export its playlists. Since it uses a SQLite database, it was very easy from the start to export its playlists.
Now I'm able to continue using my music sync script.

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
