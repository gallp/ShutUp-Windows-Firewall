# ShutUpWindows

Strict firewall rules for Windows 7, 10 and 11.<br>
Configuration for maximum security statefull firewall implicit-deny paradigm.<br>

Only DHCP, DNS, Outbound-ICMP-Echo and Web Browsing is ALLOWED.<br>

no Windows Updates<br>
no Windows Telemetry<br>
no IPv6 solicitation<br>
no NetBios chatter<br>
no ...<br>

It is very quiet now ;)

# How to use

run powershell with administrative privileges and enable execution of scripts:

	PS C:\> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
  
run the script: 

	PS C:\> .\shutUpWindows.ps1
  
then disable execution of scripts:

	PS C:\> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted


