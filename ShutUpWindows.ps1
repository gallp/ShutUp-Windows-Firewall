
#Reset Windows Firewall to microsofts defaults
(New-Object -ComObject HNetCfg.FwPolicy2).RestoreLocalFirewallDefaults()

#Lock down Windows Firewall to implicit-deny paradigm
$fwProfiles = Get-NetFirewallProfile
foreach($p in $fwProfiles){
    Set-NetFirewallProfile -Verbose -DefaultInboundAction Block -DefaultOutboundAction Block
}

#Remove Windows Firewall in-build rules 
$fwRules = Get-NetFirewallRule
ForEach($r in $fwRules){
    Remove-NetFirewallRule -Verbose
}

#DHCP Lease
New-NetFirewallRule -Verbose `
    -DisplayName DHCP-DORA `
    -Profile Any `
    -Direction Outbound `
    -Service Dhcp `
    -Protocol UDP `
    -LocalPort 68 `
    -RemotePort 67 `
    -Action Allow

#DNS Request
New-NetFirewallRule -Verbose `
    -DisplayName DNS-Request `
    -Profile Domain,Private `
    -Direction Outbound `
    -Service Dnscache `
    -Protocol UDP `
    -LocalPort Any `
    -RemotePort 53 `
    -Action Allow

#ICMP ping
New-NetFirewallRule -Verbose `
    -DisplayName ICMP-Echo `
    -Profile Domain,Private `
    -Direction Outbound `
    -Protocol ICMPv4 `
    -Action Allow

$browser = @('msedge.exe','firefox.exe','chrome.exe','opera.exe')

foreach($b in $browser){

    $c =  (Get-Item (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$b").'(Default)')
        
    if($c){

        $cPath = $c.DirectoryName.ToString()+'\'+$c.Name.ToString()

        New-NetFirewallRule -Verbose `
            -DisplayName "$c-HTTPS-TCP" `
            -Profile Domain,Private `
            -Direction Outbound `
            -Protocol TCP `
            -LocalPort Any `
            -RemotePort 443 `
            -Program $cPath `
            -Action Allow

        New-NetFirewallRule -Verbose `
            -DisplayName "$c-HTTPS-UDP" `
            -Profile Domain,Private `
            -Direction Outbound `
            -Protocol UDP `
            -LocalPort Any `
            -RemotePort 443 `
            -Program $cPath `
            -Action Allow

        New-NetFirewallRule -Verbose `
            -DisplayName "$c-HTTP-TCP" `
            -Profile Domain,Private `
            -Direction Outbound `
            -Protocol TCP `
            -LocalPort Any `
            -RemotePort 80 `
            -Program $cPath `
            -Action Allow

        New-NetFirewallRule -Verbose `
            -DisplayName "$c-HTTP-UDP" `
            -Profile Domain,Private `
            -Direction Outbound `
            -Protocol UDP `
            -LocalPort Any `
            -RemotePort 80 `
            -Program $cPath `
            -Action Allow
    }
    
}