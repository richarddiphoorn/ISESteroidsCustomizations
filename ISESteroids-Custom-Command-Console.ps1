Set-Location C:\
Clear-Host
Start-Steroids

function prompt {

    $err = !$?

    $psISE.CurrentPowerShellTab.DisplayName = "PoSh # $($tabs.IndexOf($curtab))"

    $Host.UI.RawUI.WindowTitle = 'No events watched currently! Update Calendar.csv!'

    $Calendar = Import-Csv (Join-Path (Split-Path $profile) Calendar.csv)

    foreach ($item in $Calendar) {

        $TitleBarDate = New-TimeSpan -End $item.Date

        if ($TitleBarDate -gt 0) {

            $TitleBarEvent = $item.Title

            $Host.UI.RawUI.WindowTitle = 'Only {0} day, {1} hours and {2} minutes to {3}' -f $TitleBarDate.Days, 

                $TitleBarDate.Hours, $TitleBarDate.Minutes, $TitleBarEvent

            break

        }         

    }

    # Feed first line...

    Write-Host '<# ' -ForegroundColor Gray -NoNewline 

    Write-Host 'Provider: ' -NoNewline -ForegroundColor Green 

    Write-Host $pwd.Provider.Name -NoNewLine -ForegroundColor Cyan  

    Write-Host ' => Location: ' -NoNewline -ForegroundColor Green 

    Write-Host $pwd.Path -NoNewline -ForegroundColor Cyan 

    # Make sure Windows and .Net know where we are (they can only handle the FileSystem)

 

    [Environment]::CurrentDirectory = (Get-Location -PSProvider FileSystem).ProviderPath

    Write-host ' ID: ' -NoNewLine -fore Gray

    # FIRST, make a note if there was an error in the previous command    

    # Also, put the path in the title ... (don't restrict this to the FileSystem

    # Determine what nesting level we are at (if any)

    $Nesting = "$([char]0xB7)" * $NestedPromptLevel



    # Generate PUSHD(push-location) Stack level string

    $Stack = '+' * (Get-Location -Stack).count

  

    # my New-Script and Get-PerformanceHistory functions use history IDs

    # So, put the ID of the command in, so we can get/invoke-history easier

    # eg: "r 4" will re-run the command that has [4]: in the prompt

    $global:lastCommandId = (Get-History -count 1).Id

    $global:nextCommandId = $global:lastCommandId + 1

    # Output prompt string

    # If there's an error, set the prompt foreground to "Red", otherwise, "Yellow"

    if($err) { $fg = 'Red' } else { $fg = 'Yellow' }

    # Notice: no angle brackets, makes it easy to paste my buffer to the web

    Write-Host "[${Nesting}${nextCommandId}${Stack}]" -ForegroundColor $fg

    Write-host ' #>' -NoNewLine -ForegroundColor Gray

    return "$("$([char]8288)"*3) "

}
