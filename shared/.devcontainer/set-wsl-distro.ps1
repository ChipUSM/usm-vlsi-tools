
$WSL_DISTRO='Ubuntu'

function get-ubuntu-distro() {
    # Identify if distro has (Predeterminado) or something like that
    Invoke-Expression "wsl --list" | ForEach-Object {
        if ($_ -match '\)' ) {
            $WSL_DISTRO=$_.split('(')[0].replace(" ","")
        }
    }
}

get-ubuntu-distro

[Environment]::SetEnvironmentVariable("WSL_DISTRO", "$WSL_DISTRO", "User")
#[Environment]::SetEnvironmentVariable("WSL_DISTRO", "$WSL_DISTRO", "Machine")
