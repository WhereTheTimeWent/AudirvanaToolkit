<#
	.SYNOPSIS
		Exports playlist files as text files from Audirvana
	.DESCRIPTION
		This script exports playlists from Audirvana.
		No additional information inside the playlist files, simply a list of paths from every song in every playlist from Audirvana.
	.EXAMPLE
		PS C:\> Export-AudirvanaPlaylists -pDestination "D:\Music\Playlists" -sDB "C:\Users\WhereTheTimeWent\AudirvanaPlusDatabaseV2.sqlite"
		This example exports all playlists from Audirvana to "D:\Music\Playlists" as .m3u8 files.
	.INPUTS
		-pDestination
			Mandatory. Path to where the playlist files get exported to. If it doesn't exist, the script tries to create it.

		-sDB
			Mandatory. Path of your Audirvana SQLite database. If you don't know where yours is, check Audirvana settings (library file).
			
		-sFileExtension
			Not mandatory. Defaults to .m3u8. Could be changed to .m3u, .txt or pretty much anything else.
	.OUTPUTS
		No outputs from function. Playlists get exported to specified directory with UTF8 encoding.
	.NOTES
		This script needs PSSQLite to access Audirvana's database. To install, launch PowerShell as administrator and run: Install-Module PSSQLite
		Author: WhereTheTimeWent
		GitHub: 
#>
function Export-AudirvanaPlaylists {
	#Requires -Module PSSQLite
	#Requires -Version 5
	param(
		# Put output directory of playlist files here
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$pDestination,
		# File extension of playlist files, e.g. .m3u - defaults to .m3u8
		[string]
		$sFileExtension = ".m3u8",
		# Put path of SQLite file here
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[string]
		$sDB
	)
	if(Test-Path -LiteralPath $sDB) {
		Copy-Item $sDB $env:TMP
		$sDB = [Path]::Combine($env:TMP, [Path]::GetFileName($sDB))
	} else {
		Write-Error "SQLite file not found! Script can't continue."
		return
	}
	if(!(Test-Path -LiteralPath $pDestination)) {
		try {
			mkdir $pDestination | Out-Null
		} catch {
			Write-Error "Destination path doesn't exist and couldn't be created. Script can't continue."
			return
		}
	}
	try {
		$aPlaylists = Invoke-SqliteQuery -Query "SELECT playlist_id, title FROM PLAYLISTS WHERE predicate IS NULL;" -DataSource $sDB		
	} catch {
		Write-Error "Couldn't get playlists from database!"
		return
	}
	foreach($Playlist in $aPlaylists) {
		[string]$sSQL = "SELECT TRACKS.location_dev_uuid, TRACKS.location_rel_path" + $nl
		$sSQL += "FROM TRACKS" + $nl
		$sSQL += "INNER JOIN PLAYLISTS_TRACKS ON TRACKS.track_id = PLAYLISTS_TRACKS.track_id" + $nl
		$sSQL += "AND playlist_id = " + $Playlist.playlist_id + ";"
		try {
			$aPlaylist = Invoke-SqliteQuery -Query $sSQL -DataSource $sDB			
		} catch {
			Write-Error ("Couldn't get tracks from playlist '" + $Playlist.title + "'")
		}
		[string]$sPlaylist = $null
		foreach($Song in $aPlaylist) {
			$sPlaylist += [Path]::Combine($Song.location_dev_uuid, $Song.location_rel_path) + $nl
		}
		$fDestination = [Path]::Combine($pDestination, $Playlist.title + $sFileExtension)
		$sPlaylist.Trim() | Out-File $fDestination -Encoding utf8
	}
}