
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


# See this https://deno.land/x/install@v0.3.2/install.ps1
# On that script they update the variables

[Environment]::SetEnvironmentVariable("WSL_DISTRO", "$WSL_DISTRO", "User")
#[Environment]::SetEnvironmentVariable("WSL_DISTRO", "$WSL_DISTRO", "Machine")
