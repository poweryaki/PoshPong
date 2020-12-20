
<#
.SYNOPSIS
PowerShell PONG.

.DESCRIPTION
Play the classic PONG game.

.PARAMETER Speed
Specify the speec of the ball.

.PARAMETER MaxScore
Specify the maximum score to achieve a win.

.PARAMETER LeftPlayerName
Specify the name of the player on the left.

.PARAMETER LeftPlayerKeyUp
Specify the 'Up' key of the player on the left.

.PARAMETER LeftPlayerKeyDown
Specify the 'Down' key of the player on the left.

.PARAMETER RightPlayerName
Specify the name of the player on the right.

.PARAMETER RightPlayerKeyUp
Specify the 'Up' key of the player on the right.

.PARAMETER RightPlayerKeyDown
Specify the 'Down' key of the player on the right.

.PARAMETER BatLength
Specify the length of both bats.

.PARAMETER Mute
Specify that no sound is played.

.PARAMETER Theme
Specify the theme of the game.

.PARAMETER CourtLength
Specify the length (PowerShell width) of the court.

.PARAMETER CourtWidth
Specify the wigth (PowerShell height) of the court.

.NOTES
Author   : PowerYaki
Created  : 15/5/2020
Updated  : 

Thanks to 'Free Sound Effects' for the, erm, sound effects.

.LINK https://www.freesoundeffects.com/free-sounds
#>

#Requires -Version 5.1

[CmdletBinding()]
Param (
    [Parameter()]
    [ValidateRange(1,11)]
    [Int]
    $Speed = 4,

    [Parameter()]
    [ValidateRange(1,9)]
    [Int]
    $MaxScore = 5,

    [Parameter()]
    [ValidateLength(1,30)]
    [String]
    $LeftPlayerName = "Left Player",

    [Parameter()]
    [String]
    $LeftPlayerKeyUp = 'a',
    
    [Parameter()]
    [String]
    $LeftPlayerKeyDown = 'z',

    [Parameter()]
    [ValidateLength(1,30)]
    [String]
    $RightPlayerName = "Right Player",

    [Parameter()]
    [String]
    $RightPlayerKeyUp = 'k',

    [Parameter()]
    [String]
    $RightPlayerKeyDown = 'm',

    [Parameter()]
    [ValidateRange(3,15)]
    [Int]
    $BatLength = 8,

    [Parameter()]
    [Switch]
    $Mute,

    [Parameter()]
    [ValidateSet(
        'Horror',
        'Pong',
        'Tennis'
    )]
    [String]
    $Theme = 'Pong',

    [Parameter()]
    [ValidateRange(50,200)]
    [Int]
    $CourtLength = 80,

    [Parameter()]
    [ValidateRange(20,70)]
    [Int]
    $CourtWidth = 30
)


#region : VARIABLES
Switch ( $Host.Version.Major ) {
    5 { $HostVersion = 'WindowsPowerShell' }
    7 { $HostVersion = 'PowerShell' }
    Default { Throw "Sorry, PongShell hasn't been configured for PowerShell version '$($Host.Version.Major)' yet." }
}

# Theme
[Hashtable]$PongThemes = @{
    'WindowsPowerShell' = @{
        Horror = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Background = @{
                Colour = [System.ConsoleColor]'Black'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'DarkGreen'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'DarkGreen'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'Red'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'Green'
            }
        }
        Pong = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Gray'
            }
            Background = @{
                Colour = [System.ConsoleColor]'DarkMagenta'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'White'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'White'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'White'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'White'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Gray'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'White'
            }
        }
        Tennis = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Background = @{
                Colour = [System.ConsoleColor]'DarkGreen'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'Cyan'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'DarkRed'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'Yellow'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'White'
            }
        }
    }
    'PowerShell' = @{
        Horror = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Background = @{
                Colour = [System.ConsoleColor]'Black'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'DarkGreen'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'DarkGreen'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'Red'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Red'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'Green'
            }
        }
        Pong = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Gray'
            }
            Background = @{
                Colour = [System.ConsoleColor]'Black'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'White'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'White'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'White'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'White'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Gray'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'White'
            }
        }
        Tennis = @{
            Announcement = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Background = @{
                Colour = [System.ConsoleColor]'DarkGreen'
            }
            Ball = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Bat = @{
                LeftPlayer = @{
                    Colour = [System.ConsoleColor]'Cyan'
                }
                RightPlayer = @{
                    Colour = [System.ConsoleColor]'DarkRed'
                }
            }
            Net = @{
                Colour = [System.ConsoleColor]'White'
            }
            Player = @{
                Name = @{
                    Colour = [System.ConsoleColor]'Yellow'
                }
            }
            Score = @{
                Colour = [System.ConsoleColor]'Yellow'
            }
            Wall = @{
                Colour = [System.ConsoleColor]'White'
            }
        }
    }
}


# Announcement
[Hashtable]$Announcement = @{
    GameOver = [String[]]@(
        '############################################################'
        '#                                                          #'
        '#   ##### ##### #   # #####      ##### #   # ##### #####   #'
        '#   #     #   # ## ## #          #   # #   # #     #   #   #'
        '#   #  ## ##### # # # #####      #   # #   # ##### ####    #'
        '#   #   # #   # #   # #          #   #  # #  #     #  #    #'
        '#   ##### #   # #   # #####      #####   #   ##### #   #   #'
        '#                                                          #'
        '############################################################'
    )
    Score = [String[]]@(
        '##########################################'
        '#                                        #'
        '#   ##### ##### ##### ##### #####   ##   #'
        '#   #     #     #   # #   # #       ##   #'
        '#   ##### #     #   # ##### #####   ##   #'
        '#       # #     #   # #  #  #            #'
        '#   ##### ##### ##### #   # #####   ##   #'
        '#                                        #'
        '##########################################'
    )
}
[Int]$SleepAnnouncement = 4
[System.ConsoleColor]$AnnouncementColour = $PongThemes.$HostVersion.$Theme.Announcement.Colour


 # Wall
[int]$WallXMin = 1
[Int]$WallXMax = $CourtLength
[int]$WallYMin = 10
[Int]$WallYMax = $WallYMin + $CourtWidth
[System.ConsoleColor]$WallColour = $PongThemes.$HostVersion.$Theme.Wall.Colour
[String]$WallTopBottomChar = [char]9608


# Bat
[Hashtable[]]$BatLeftArea = @{}
[Hashtable[]]$BatRightArea = @{}
[String]$BatChar = [char]9608
[System.ConsoleColor]$BallColour = $PongThemes.$HostVersion.$Theme.Ball.Colour
[System.ConsoleColor]$BatLeftColour = $PongThemes.$HostVersion.$Theme.Bat.LeftPlayer.Colour
[Int]$BatSpace = 5
[Int]$BatStartingPosition = (($WallYMax - $WallYMin) / 2) + $WallYMin - ($BatLength / 2)
[Int]$BatLeftX = $BatSpace
[Int]$BatLeftY = $BatStartingPosition
[Int]$BatRightX = $WallXMax - $BatSpace
[Int]$BatRightY = $BatStartingPosition
[System.ConsoleColor]$BatRightColour = $PongThemes.$HostVersion.$Theme.Bat.RightPlayer.Colour
[Int]$BatYMin = $WallYMin + 1
[Int]$BatYMax = $WallYMax -1
[Int]$BatWidth = 2
[Hashtable]$MoveBat = @{ Player = ''; Direction = '' }

# Ball
[String]$BallChar = [char]9787
[String]$BallXDirection = 'Right'
[String]$BallYDirection = 'Down'
[Int]$BallStartingPositionX = $BatSpace + $BatWidth
[Int]$BallStartingPositionY = $BatStartingPosition + ($BatLength / 2)
[int]$BallX = $BallStartingPositionX
[int]$BallXMin = $WallXMin
[int]$BallXMax = $WallXMax
[int]$BallYMin = $WallYMin + 1
[int]$BallYMax = $WallYMax - 1
[int]$BallY = $BallStartingPositionY
[Int]$SleepBall = 200 / $Speed
[Int]$BallXAngle = 1
[Int]$BallYAngle = 1


[Int]$CenterCourt = (($WallXMax - $WallXMin) / 2) + $WallXMin

[String]$CharBlank = ' '

# Console
[System.ConsoleColor]$PongShellUiBackgroundColour = $PongThemes.$HostVersion.$Theme.Background.Colour
[Int]$PongShellUiWindowSizeX = $WallXMax + 1
[Int]$PongShellUiWindowSizeY = $WallYMax + 1
[Int]$PongShellUiBufferSizeX = $WallXMax + 1
[Int]$PongShellUiBufferSizeY = $WallYMax + 1
[String]$PowerShellWindowsTitle = '### PowerShell PONG! ###'
[Int]$OrigHostRawUiCursorSize = $Host.UI.RawUI.CursorSize
[String]$OrigHostRawUiWindowsTitle = $Host.UI.RawUI.WindowTitle
[System.Management.Automation.Host.Size]$OrigHostRawUiWindowsSize = $Host.UI.RawUI.WindowSize
[System.Management.Automation.Host.Size]$OrigHostRawUiBufferSize = $Host.UI.RawUI.BufferSize
[System.ConsoleColor]$OrigHostRawUiBackgroundColour = $Host.ui.RawUI.BackgroundColor


# Game Status
[String]$Winner = $null
[Boolean]$GameOver = $false


# Net
[String]$NetChar = [char]9618
[String[]]$NetCoordinates = @()
[Int]$NetX = $CenterCourt
[System.ConsoleColor]$NetColour = $PongThemes.$HostVersion.$Theme.Net.Colour
[Int]$NetGap = 0


# Player
[Int]$LeftPlayerScore = 0
[Int]$RightPlayerScore = 0
[Int]$PlayNameSpaceCount = 4
[String]$PlayNameSpace = " " * $PlayNameSpaceCount
[String]$PlayerDivider = "V"
[String]$PlayerNames = $LeftPlayerName + $PlayNameSpace + $PlayerDivider + $PlayNameSpace + $RightPlayerName
[Int]$PlayerNamesX = $CenterCourt - $PlayNameSpaceCount - ($LeftPlayerName.length)
[Int]$PlayerNamesY = 2
[System.ConsoleColor]$PlayerNameCharColour = $PongThemes.$HostVersion.$Theme.Player.Name.Colour


# Preference
$ErrorActionPreference = 'Stop'

# Serve
[String]$Serve = 'Left'
[String]$ServeKey = 'Spacebar'

# Score
[String]$ScoreChar = [char]9608
[System.ConsoleColor]$ScoreCharColour = $PongThemes.$HostVersion.$Theme.Score.Colour
    
[Int]$ScoreLeftX = $CenterCourt - 10
[Int]$ScoreLeftY = 4
[Int]$ScoreRightX = $CenterCourt + 5
[Int]$ScoreRightY = 4
[String]$ScoreDirection = $null

# Sound
$SoundEffects = @{}
[String]$SoundsPath = "$PSScriptRoot\Sound\$Theme"
[String]$SoundsFileType = "$SoundsPath\*.wav"
[String]$SoundEffectServe = 'Serve'
[String]$SoundEffectPlayerLeft = 'PlayerLeft'
[String]$SoundEffectPlayerRight = 'PlayerRight'
[String]$SoundEffectBallBounce = 'BallBounce'
[Int]$SountEffectApplauseRandomMin = 0
[Int]$SountEffectApplauseRandomMax = 0
[String]$SountEffectApplause = 'Applause'
[String]$SoundEffectGameOver = 'GameOver'

#endregion : VARIABLES


#region : FUNCTIONS
Function Get-PongBatCenter {
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $BatArea
    )

    $BatArea[([Int]$BatArea.count / 4)].Y

} #Function Get-PongBatCenter


Function Get-PongSoundEffectLibrary {
    
    $SoundFiles = Get-ChildItem -Path $SoundsFileType
    If ( $SoundFiles ) {
        $SoundFiles | ForEach-Object {
            $SoundPlayer = New-Object media.soundplayer ($_.FullName)
            $SoundPlayer.load()
            $script:SoundEffects[$_.BaseName] = $SoundPlayer
            If ( $_.BaseName -match $SountEffectApplause ) { $script:SountEffectApplauseRandomMax += 1 }
        } #ForEach-Object
    } #If
    Else {
        Write-Error "No sound effects found in '$SoundsFileType'"
    } #If

    If ( $script:SountEffectApplauseRandomMax -gt 0 ) { $script:SountEffectApplauseRandomMin = 1 }
    Else { Write-Error "Applause sound effects not found" }

} #Function Get-PongSoundEffectLibrary


Function Get-PongSoundEffectApplause {
    
    [Int]$SeRnd = 1

    If ( $SountEffectApplauseRandomMax -ne $SountEffectApplauseRandomMin ) {
        $SeRnd = Get-Random -Maximum $SountEffectApplauseRandomMax -Minimum $SountEffectApplauseRandomMin
    } #If
    $script:SoundEffect = "$SountEffectApplause$SeRnd"

} #Function Get-PongSoundEffectApplause


Function Get-PongKey {
    
    If ( [console]::KeyAvailable ) {
        $Key = [System.Console]::ReadKey('Noecho').Key

        Switch ( $Key ) {
            $LeftPlayerKeyUp { If ( $BatLeftArea[0].Y -gt $BatYMin ) { $script:MoveBat = @{ Player = 'Left'; Direction = 'Up' } } }
            $LeftPlayerKeyDown { If ( $BatLeftArea[-1].Y -lt $BatYMax ) { $script:MoveBat = @{ Player = 'Left'; Direction = 'Down' } } }
            $RightPlayerKeyUp {  If ( $BatRightArea[0].Y -gt $BatYMin ) { $script:MoveBat = @{ Player = 'Right'; Direction = 'Up' } } }
            $RightPlayerKeyDown { If ( $BatRightArea[-1].Y -lt $BatYMax ) { $script:MoveBat = @{ Player = 'Right'; Direction = 'Down' } } }
            $ServeKey { 
                If ( $script:Serve -ne '' ) {
                    $script:Serve = '' 
                    $Script:SoundEffect = $SoundEffectServe
                } #If
            }
            Default { 
                $script:MoveBat = @{ Player = ''; Direction = '' }
                $script:MoveRightBat = ''
                $Script:SoundEffect = ''
            }
        } #Switch
    } #If

} #Function Get-PongKey


Function Invoke-PongGameOver {

    If ( -not $Mute ) { Invoke-PongSoundEffect -Sound $SoundEffectGameOver }
    Write-PongAnnouncement -Announcement $Announcement.GameOver -Colour $AnnouncementColour
    $script:GameOver = $true

} #Function Invoke-PongGameOver


Function Invoke-PongKey {
    
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $BatArea,

        [Parameter()]
        [System.ConsoleColor]
        $BatColour = 'White'
    )


    #region : VARIABLES
    [Int]$BatNewYCoordinate = $null
    [Int]$BatOldYCoordinate = $null
    [Int]$BatOldEndYCoordinate = $null
    #endregion : VARIABLES

    
    Switch ( $MoveBat.Direction ) {
        'Up' {
            $BatOldEndYCoordinate = $BatArea[0].Y
            $BatNewYCoordinate = $BatOldEndYCoordinate - 1
            $BatOldYCoordinate = $BatArea[-1].Y
        }
        'Down' {
            $BatOldEndYCoordinate = $BatArea[-1].Y
            $BatNewYCoordinate = $BatOldEndYCoordinate + 1
            $BatOldYCoordinate = $BatArea[0].Y
        }
    } #Switch

    $BatArea | ForEach-Object {
        If ( $_.Y -eq $BatOldYCoordinate ) { $BatOldCoordinate += @( @{ X= $_.X; Y = $BatOldYCoordinate } ) }
        ElseIf ( $_.Y -eq $BatOldEndYCoordinate ) {
            If ( $MoveBat.Direction -eq 'Up' ) { $NewBatArea += @( @{ X = $_.X; Y = $BatNewYCoordinate } ) }
            $NewBatArea += @( @{ X = $_.X; Y = $_.Y } )
            If ( $MoveBat.Direction -eq 'Down' ) { $NewBatArea += @( @{ X = $_.X; Y = $BatNewYCoordinate } ) }
            $BatNewCoordinate += @( @{ X = $_.X; Y = $BatNewYCoordinate } )
        } #If
        Else { $NewBatArea += @( $_ ) }
    } #ForEach-Object

    Write-PongBat -NewCoordinate $BatNewCoordinate -OldCoordinate $BatOldCoordinate -Colour $BatColour 
    If ( $MoveBat.Player -eq $Serve ) {
        Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $CharBlank
        Switch ( $MoveBat.Direction ) {
            'Up' { $script:BallY -= 1 }
            'Down' { $script:BallY += 1 }
        } #Switch
        Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $BallChar -Colour $BallColour
    } #If

    $NewBatArea

} #Function Invoke-PongKey


Function Invoke-PongSoundEffect {
    Param (
        [Parameter(Mandatory = $true)]
        [String]
        $Sound
    )

    Try { $SoundEffects[$Sound].play() }
    Catch { Write-Error "Failed to play sound effect '$Sound'.`n$_" }

} #Function Invoke-PongSoundEffect


Function Restore-HostRawUi {
    
    $Host.UI.RawUI.BackgroundColor = $OrigHostRawUiBackgroundColour
    $Host.UI.RawUI.BufferSize.Height = $OrigHostRawUiBufferSize.Height
    $Host.UI.RawUI.BufferSize.Width = $OrigHostRawUiBufferSize.Width
    $Host.UI.RawUI.WindowSize.Height = $OrigHostRawUiWindowsSize.Height
    $Host.UI.RawUI.WindowSize.Width = $OrigHostRawUiWindowsSize.Width
    $Host.UI.RawUI.WindowTitle = $OrigHostRawUiWindowsTitle
    $Host.UI.RawUI.CursorSize = $OrigHostRawUiCursorSize
    
    Clear-Host

} #Function Restore-HostRawUi 


Function Set-PongBallAngle {
    Param (
        [Parameter(Mandatory = $true)]
        [Hashtable[]]
        $BatArea
    )

    #region : VARIABLES
    [Int]$BatBlock = 0
    #endregion : VARIABLES
    

    If ( $BatArea.count -ge 6 ) {
        $BatBlock = Get-PongBatCenter -BatArea $BatArea
    } #If

    If ( $BatBlock -eq $BallY ) {         
        $script:BallXAngle = 2
        $script:BallYAngle = 0
    } #If
    Else {
        If ( $script:BallYAngle -eq 0 ) {
            If ( $BallY -lt $BatBlock ) { $script:BallYDirection = 'Up' }
            Else { $script:BallYDirection = 'Down' }
        } #If
        $script:BallXAngle = 1
        $script:BallYAngle = 1 
    } #If

} #Function Set-PongBallAngle


Function Set-PongBallLocation {

    Switch ( $BallXDirection ) {
        'Left' { $script:BallX -= $BallXAngle }
        'Right' { $script:BallX += $BallXAngle }
    } #Switch
    Switch ( $BallYDirection ) {
        'Up' { $script:BallY -= $BallYAngle }
        'Down' { $script:BallY += $BallYAngle }
    } #Switch
    
    If ( $BatLeftArea.X -eq ($BallX - $BallXAngle) -and $BatLeftArea.Y -eq $BallY ) {
        $script:BallXMin = $BallX
        $script:SoundEffect = $SoundEffectPlayerLeft
        Set-PongBallAngle -BatArea $BatLeftArea
    } #If
    ElseIf ( $BatRightArea.X -eq ($BallX + $BallXAngle) -and $BatRightArea.Y -eq $BallY ) {
        $script:BallXMax = $BallX
        $script:SoundEffect = $SoundEffectPlayerRight
        Set-PongBallAngle -BatArea $BatRightArea
    } #If
    Else {
        $script:BallXMin = $WallXMin
        $script:BallXMax = $WallXMax
    } #If
    
    If ( $BallX -eq $BallXMin -or $BallX -eq $BallXMax ) {
        Switch ( $BallXDirection ) {
            'Left' { $script:BallXDirection = 'Right' }
            'Right' { $script:BallXDirection = 'Left' }
        } #Switch
        If ( $BallX -eq $WallXMin ) { 
            $script:ScoreDirection = 'Left' 
            If ( -not $Mute ) { Get-PongSoundEffectApplause }
        } #If
        ElseIf ( $BallX -eq $WallXMax ) {
            $script:ScoreDirection = 'Right'            
            If ( -not $Mute ) { Get-PongSoundEffectApplause }
        } #If
        Else { 
            $script:ScoreDirection = $null 
        } #If
    } #If
    Else { $script:SoundFreq = $null }

    If ( $BallY -eq $BallYMin -or $BallY -eq $BallYMax ) {
        Switch ( $BallYDirection ) {
            'Up' { $script:BallYDirection = 'Down' }
            'Down' { $script:BallYDirection = 'Up' }
        } #Switch
        If ( -not $Mute ) { $script:SoundEffect = $SoundEffectBallBounce }
    } #If

} #Function Set-PongBallLocation


Function Set-PongBatArea {

    Param (
        [Parameter(Mandatory = $true)]
        [Int]
        $X,

        [Parameter(Mandatory = $true)]
        [Int]
        $Y,

        [Parameter(Mandatory = $true)]
        [Int]
        $Width,

        [Parameter(Mandatory = $true)]
        [Int]
        $Length
    )


    For ( $BatW = 0; $BatW -lt $Width; $BatW++ ) {
        $BatX = $X + ($BatW * 1)
        For ( $BatL = 0; $BatL -lt $Length; $BatL++ ) {
            $BatY = $Y + ($BatL * 1)
            $BatArea += @(
                @{
                    X = $BatX
                    Y = $BatY
                }
            )
        } #For
    } #For

    $BatArea

} #Function Set-PongBatArea


Function Set-PongShellRawUi {

    #region : VARIABLES
    [Int]$NewWindowSizeWidth = 0
    [Int]$NewBufferSizeWidth = 0
    [Int]$NewWindowSizeHeight = 0
    [Int]$NewBufferSizeHeight = 0
    #endregion : VARIABLES

    
    $Host.UI.RawUI.BackgroundColor = $PongShellUiBackgroundColour
    $Host.UI.RawUI.CursorSize = 0

    $BufferSize = New-Object System.Management.Automation.Host.Size($PongShellUiBufferSizeX,$PongShellUiBufferSizeY)
    $WindowSize = New-Object System.Management.Automation.Host.Size($PongShellUiWindowSizeX,$PongShellUiWindowSizeY)

    If ( $Host.UI.RawUI.WindowSize.Width -lt $PongShellUiWindowSizeX ) {
        $NewWindowSizeWidth = $Host.UI.RawUI.WindowSize.Width
        $NewBufferSizeWidth = $PongShellUiBufferSizeX
    } #If
    Else { 
        $NewWindowSizeWidth = $PongShellUiBufferSizeX
        $NewBufferSizeWidth = $Host.UI.RawUI.WindowSize.Width
    } #If

    If ( $Host.UI.RawUI.WindowSize.Height -lt $PongShellUiWindowSizeY ) {
        $NewWindowSizeHeight = $Host.UI.RawUI.WindowSize.Height
        $NewBufferSizeHeight = $PongShellUiBufferSizeY
    } #If
    Else { 
        $NewWindowSizeHeight = $PongShellUiBufferSizeY
        $NewBufferSizeHeight = $Host.UI.RawUI.WindowSize.Height
    } #If

    $Host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size($NewBufferSizeWidth,$NewBufferSizeHeight)
    $Host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size($NewWindowSizeWidth,$NewWindowSizeHeight)
    $Host.UI.RawUI.BufferSize = $BufferSize
    $Host.UI.RawUI.WindowSize = $WindowSize
    
    $Host.UI.RawUI.WindowTitle = $PowerShellWindowsTitle
    Clear-Host

} #Function Set-PongShellRawUi 


Function Write-PongAnnouncement {
    Param (
        [Parameter(Mandatory = $true)]
        [String[]]
        $Announcement,

        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]
        $Colour
    )


    [Int]$AnnouncementX = $CenterCourt - (($Announcement[0]).length / 2)
    [Int]$AnnouncementY = (($WallYMax -$WallYMin)/ 2) + $WallYMin - ($Announcement.count / 2)
    $AnnouncementYOrig = $AnnouncementY
    $Announcement | ForEach-Object {
        Write-PongBlock -BlockX $AnnouncementX -BlockY $AnnouncementY -Char $_ -Colour $Colour
        $AnnouncementY += 1
    } #ForEach-Object
    
    Start-Sleep -Seconds $SleepAnnouncement

    $AnnouncementY = $AnnouncementYOrig
    $Announcement | ForEach-Object {
        Write-PongBlock -BlockX $AnnouncementX -BlockY $AnnouncementY -Char $($CharBlank * $_.length)
        $AnnouncementY += 1
    } #ForEach-Object
    
    Write-PongNet

} #Function Write-PongAnnouncement


Function Write-PongBat {
    Param (
        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Area'
        )]
        [Hashtable[]]
        $Area,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Coorindate'
        )]
        [Hashtable[]]
        $NewCoordinate,

        [Parameter(
            Mandatory = $true,
            ParameterSetName = 'Coorindate'
        )]
        [Hashtable[]]
        $OldCoordinate,

        [Parameter()]
        [System.ConsoleColor]
        $Colour = 'White'
    )

    If ( $Area ) {
        $Area | ForEach-Object { Write-PongBlock -BlockX $_.X -BlockY $_.Y -Char $BatChar -Colour $Colour }
    } #If
    Else {
        $NewCoordinate | ForEach-Object { Write-PongBlock -BlockX $_.X -BlockY $_.Y -Char $BatChar -Colour $Colour }
        $OldCoordinate | ForEach-Object { Write-PongBlock -BlockX $_.X -BlockY $_.Y -Char $CharBlank -Colour $Colour }
    } #If

} #Function Write-PongBat


Function Write-PongBlock {
    Param (
        [Parameter(Mandatory = $true)]
        [int]
        $BlockX,

        [Parameter(Mandatory = $true)]
        [int]
        $BlockY,
        
        [Parameter(Mandatory = $true)]
        [String]
        $Char,

        [Parameter()]
        [System.ConsoleColor]
        $Colour
    )


    If ( $Colour ) { 
        [String]$ForegroundColourOrig = $Host.UI.RawUI.ForegroundColor
        $Host.UI.RawUI.ForegroundColor = $Colour
    } #If

    $Host.UI.RawUI.CursorPosition = @{ X = $BlockX; Y = $BlockY }
    $Host.UI.Write($Char)

    If ( $Colour ) { $Host.UI.RawUI.ForegroundColor = $ForegroundColourOrig }

} #Function Write-PongBlock


Function Write-PongNet {
    $NetYMin = $WallYMin + 1
    $NetYMax = $WallYMax - 1

    For ( $NetY = $NetYMin; $NetY -le $NetYMax; $NetY += (1 + $NetGap) ) {
        Write-PongBlock -BlockX $NetX -BlockY $NetY -Char $NetChar -Colour $NetColour
        $script:NetCoordinates += @("$NetX,$NetY")
    } #For

} #Function Write-PongNet


Function Write-PongScore {
    Param(
        [Parameter(Mandatory = $true)]
        [Int]
        $Score,
        
        [Parameter(Mandatory = $true)]
        [Int]
        $X,

        [Parameter(Mandatory = $true)]
        [Int]
        $Y,

        [Parameter(Mandatory = $true)]
        [System.ConsoleColor]
        $Colour
    )


    #region : VARIABLES
    $Scores = [ordered]@{
        'Blank' = @(
            "     "
            "     "
            "     "
            "     "
            "     "
        )
        '0' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
        )
        '1' = @(
            "    $ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
        )
        '2' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
        )
        '3' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
        )
        '4' = @(
            "$ScoreChar   $ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
        )
        '5' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"        
        )
        '6' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"        
        )
        '7' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
        )
        '8' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
        )
        '9' = @(
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "$ScoreChar   $ScoreChar"
            "$ScoreChar$ScoreChar$ScoreChar$ScoreChar$ScoreChar"
            "    $ScoreChar"
            "    $ScoreChar"
        )

    }
    #endregion : VARIABLES


    $ScoreY = $Y
    $Scores."Blank" | ForEach-Object { 
        Write-PongBlock -BlockX $X -BlockY $ScoreY -Char $_ -Colour $ScoreCharColour
        $ScoreY += 1
    }
    $ScoreY = $Y
    $Scores."$Score" | ForEach-Object { 
        Write-PongBlock -BlockX $X -BlockY $ScoreY -Char $_ -Colour $Colour
        $ScoreY += 1
    }
    
} #Function Write-PongScore


Function Write-PongWalls {
    [String]$WallTopBottom = $WallTopBottomChar * $WallXMax

    Write-PongBlock -BlockX $WallXMin -BlockY $WallYMin -Char $WallTopBottom -Colour $WallColour
    Write-PongBlock -BlockX $WallXMin -BlockY $WallYMax -Char $WallTopBottom -Colour $WallColour
} #Function Write-PongWalls
#endregion : FUNCTIONS



#region : Load game
Set-PongShellRawUi
Write-PongWalls
Write-PongNet

$BatLeftArea = Set-PongBatArea -X $BatLeftX -Y $BatLeftY -Width $BatWidth -Length $BatLength
$BatRightArea = Set-PongBatArea -X $BatRightX -Y $BatRightY -Width $BatWidth -Length $BatLength

Write-PongBat -Area $BatLeftArea -Colour $BatLeftColour
Write-PongBat -Area $BatRightArea -Colour $BatRightColour

Write-PongBlock -BlockX $PlayerNamesX -BlockY $PlayerNamesY -Char $PlayerNames -Colour $PlayerNameCharColour

Write-PongScore -Score $LeftPlayerScore -X $ScoreLeftX -Y $ScoreLeftY -Colour $ScoreCharColour
Write-PongScore -Score $RightPlayerScore -X $ScoreRightX -Y $ScoreRightY -Colour $ScoreCharColour

Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $BallChar -Colour $BallColour

If ( -not $Mute ) { Get-PongSoundEffectLibrary }
#endregion : Load game


While ( -not $GameOver ) {

    Do {
        Get-PongKey
        If ( $MoveBat.Player -ne '' -and $MoveBat.Direction -ne '' ) { 
            If ( $MoveBat.Player -eq 'Left' ) { $BatLeftArea = Invoke-PongKey -BatArea $BatLeftArea -BatColour $BatLeftColour }
            If ( $MoveBat.Player -eq 'Right' ) { $BatRightArea = Invoke-PongKey -BatArea $BatRightArea -BatColour $BatRightColour }
            $MoveBat = @{ Player = ''; Direction = '' }
        } #If
    } #Do
    Until ( $Serve -eq '' )

    Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $BallChar -Colour $BallColour
    If ( $NetCoordinates -contains "$PreviousBallX,$PreviousBallY" ) { $PreviousChar = $NetChar }
    Else { $PreviousChar = $CharBlank }
    Write-PongBlock -BlockX $PreviousBallX -BlockY $PreviousBallY -Char $PreviousChar


    If ( -not $mute -and $SoundEffect ) {
        Invoke-PongSoundEffect -Sound $SoundEffect
        $script:SoundEffect = ''
    } #If
    If ( $ScoreDirection ) {
        Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $CharBlank
        Switch ( $ScoreDirection ) {
            'Left' {
                $RightPlayerScore += 1 
                Write-PongScore -Score $RightPlayerScore -X $ScoreRightX -Y $ScoreRightY -Colour $ScoreCharColour
                If ( $RightPlayerScore -eq $MaxScore ) { $Winner = $RightPlayerName }
                Else {
                    $BallX = $BatSpace + $BatWidth
                    $BallY = Get-PongBatCenter -BatArea $BatLeftArea
                    $Serve = 'Left'
                } #If
            }
            'Right' {
                $LeftPlayerScore += 1
                Write-PongScore -Score $LeftPlayerScore -X $ScoreLeftX -Y $ScoreLeftY -Colour $ScoreCharColour
                If ( $LeftPlayerScore -eq $MaxScore ) { $Winner = $LeftPlayerName }
                Else {
                    $BallX = $WallXMax - $BatSpace - $BatWidth + 1
                    $BallY = Get-PongBatCenter -BatArea $BatRightArea
                    $Serve = 'Right'
                } #If
            }
        } #Switch
        $ScoreDirection = $null
        Write-PongAnnouncement -Announcement $Announcement.Score -Colour $AnnouncementColour
        If ( $Winner ) { Invoke-PongGameOver }
        Else { Write-PongBlock -BlockX $BallX -BlockY $BallY -Char $BallChar -Colour $BallColour }
    } #If
    Else {
        $PreviousBallX = $BallX
        $PreviousBallY = $BallY
        Set-PongBallLocation

        [DateTime]$BallSpeedTimeStart = Get-Date
        Do {
            Get-PongKey
            If ( $MoveBat.Player -ne '' -and $MoveBat.Direction -ne '' ) { 
                If ( $MoveBat.Player -eq 'Left' ) { $BatLeftArea = Invoke-PongKey -BatArea $BatLeftArea -BatColour $BatLeftColour }
                If ( $MoveBat.Player -eq 'Right' ) { $BatRightArea = Invoke-PongKey -BatArea $BatRightArea -BatColour $BatRightColour }
                $MoveBat = @{ Player = ''; Direction = '' }
            } #If
            [DateTime]$BallSpeetTimeCurrent = Get-Date
        } #Do
        Until ( ($BallSpeetTimeCurrent - $BallSpeedTimeStart).Milliseconds -gt $SleepBall )
    } #If

} #While

Restore-HostRawUi
