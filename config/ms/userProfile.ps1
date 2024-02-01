# Prompt
Import-Module Terminal-Icons
$env:POSH_GIT_ENABLED = $ture

## Themes
# oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\fish.omp.json | Invoke-Expression
# oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\agnoster.minimal.omp.json | Invoke-Expression
oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\takuya.omp.json | Invoke-Expression

# Icons
Import-Module Terminal-Icons

# PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView

# Fzf
Set-PSFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

## Utilities
<#
.SYNOPSIS
This function is respnsible for copying a given string value or a piped input to the clipoad

.PARAMETER String
Optional paramater, if not provided it will assume the value is the output from a piped command.

.EXAMPLE
For regualr cases `ctc "hello"` will copy hello to the clipboard.
For piped cases `pwd | ctc` will copy only the current working direcoty.

#>
function Copy-To-ClipBoard($String) {
  
  if ($String) {
    Write-Output "$String" | Set-Clipboard 
  }
  else {
  
    Write-Output $input | Set-Clipboard 
  }
}

function Show-Wifi-Password {
  param(
    
    [Parameter(Mandatory = $true)]
    [string]$WifiName,
    [Parameter(Mandatory = $false)]
    [switch]$copy
    
  )
  $netshOutput = netsh wlan show profiles "$WifiName" key=clear | grep "Key Content"

  $splitted = $netshOutput -split ":"
  $password = $splitted[1].Trim()
  
  if ($copy) {
    # Copy the password to the clipboard
    $password | Set-Clipboard
    Write-Host "Password copied to clipboard."
  }
  else {
    Write-Output $password;
  }
}

function which($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Touch-File {
  param ([Parameter()] [String]$file)
  if (Test-Path -Path $file) {
    #It exists. Update the timestamp
    (Get-ChildItem -Path $file).LastWriteTime = Get-Date
  }
  else {
    #It does not exist. Create it
    New-Item -ItemType File -Name $file
  }
}


# Alias 
Set-Alias l ls
# Set-Alias -Name ll -Value "ls -Force"
Set-Alias vim nvim
Set-Alias -Name touch -Value Touch-File
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias -Name ctc -Value Copy-To-ClipBoard
Set-Alias -Name swp -Value Show-Wifi-Password
Set-Alias -Name csc -Value 'C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc.exe'
Set-Alias -Name cat -Value bat
Set-Alias -Name less -Value bat
