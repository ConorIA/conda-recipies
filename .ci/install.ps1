# Adapted from: Sample script to install Miniconda under Windows
# Original authors: Olivier Grisel, Jonathan Helmus and Kyle Kastner, Robert McGibbon
# License: CC0 1.0 Universal: http://creativecommons.org/publicdomain/zero/1.0/

$MINICONDA_URL = "http://repo.continuum.io/miniconda/"
$CONDA_HOME = $env:CONDA_HOME
$CONDA_PATH = $env:CONDA_PATH

function DownloadMiniconda () {
    $webclient = New-Object System.Net.WebClient
    $filename = "Miniconda3-latest-Windows-x86_64.exe"
    $url = $MINICONDA_URL + $filename

    $basedir = $pwd.Path + "\"
    $filepath = $basedir + $filename
    if (Test-Path $filename) {
        Write-Host "Reusing" $filepath
        return $filepath
    }

    # Download and retry up to 3 times in case of network transient errors.
    Write-Host "Downloading" $filename "from" $url
    $retry_attempts = 2
    for($i=0; $i -lt $retry_attempts; $i++){
        try {
            $webclient.DownloadFile($url, $filepath)
            break
        }
        Catch [Exception]{
            Start-Sleep 1
        }
   }
   if (Test-Path $filepath) {
       Write-Host "File saved at" $filepath
   } else {
       # Retry once to get the error message if any at the last try
       $webclient.DownloadFile($url, $filepath)
   }
   return $filepath
}


function InstallMiniconda () {
    Write-Host "Installing Python for 64 bit architecture to" $CONDA_HOME
    if (Test-Path $CONDA_HOME) {
        Write-Host $CONDA_HOME "already exists, skipping."
        return $false
    }

    $filepath = DownloadMiniconda
    Write-Host "Installing" $filepath "to" $CONDA_HOME
    $install_log = $CONDA_HOME + ".log"
    $args = "/S /D=$CONDA_HOME"
    Write-Host $filepath $args
    Start-Process -FilePath $filepath -ArgumentList $args -Wait -Passthru
    if (Test-Path $CONDA_HOME) {
        Write-Host "Python installation complete"
    } else {
        Write-Host "Failed to install Python in $CONDA_HOME"
        Get-Content -Path $install_log
        Exit 1
    }
}


function InstallCondaPackages ($spec) {
    $args = "install -yq " + $spec
    Write-Host ("conda " + $args)
    Start-Process -FilePath "$CONDA_PATH" -ArgumentList $args -Wait -Passthru
}


function UpdateConda () {
    Write-Host "Updating conda..."
    $args = "update -yq conda"
    Write-Host $CONDA_PATH $args
    Start-Process -FilePath "$CONDA_PATH" -ArgumentList $args -Wait -Passthru
}


function main () {
    InstallMiniconda
    UpdateConda
    InstallCondaPackages "conda-build jinja2 anaconda-client"
}

main
