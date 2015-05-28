# these lines will first add a submenu, then add commands to it:
$parent = $psise.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add('Exchange', $null, $null)

# this line will add a new custom command without a keyboard shortcut:
$parent.Submenus.Add('Exchange PSRemoting', { 

        $exCredentials = (Get-Credential ( [Environment]::UserDomainName + '\' + [Environment]::UserName ) )
        $exServer = '<servername>'

        # Getting existing PowerShell remoting sessions and imported modules, and removing them and imported modules to prevent cmdlet clobbering.
        Get-PSSession | Remove-PSSession
        Get-Module | Where-Object { $_.Name -like '*tmp*' } | Remove-Module -Confirm:$false

        # Creating a new PowerShell Remoting Session.
        $exSession = New-PSSession –ConfigurationName Microsoft.Exchange –ConnectionUri ( 'http://' + $exServer + '/PowerShell/?SerializationLevel=Full' ) -Credential $exCredentials –Authentication Kerberos

        # Importing the new PowerShell Remoting Session to make the cmdlets locally available.
        Import-PSSession $exSession


 }, $null)
 
 # these lines will first add a submenu, then add commands to it:
$parent = $psise.CurrentPowerShellTab.AddOnsMenu.SubMenus.Add('Active Directory', $null, $null)

# this line will add a new custom command without a keyboard shortcut:
$parent.Submenus.Add('AD PSRemoting', { 

        $adCredentials = (Get-Credential ( [Environment]::UserDomainName + '\' + [Environment]::UserName ) )
        $adServer = '<servername>'

        # Getting existing PowerShell remoting sessions and imported modules, and removing them and imported modules to prevent cmdlet clobbering.
        Get-PSSession | Remove-PSSession
        Get-Module | Where-Object { $_.Name -like '*tmp*' } | Remove-Module -Confirm:$false

        # Creating a new PowerShell Remoting Session.
        $adSession = New-PSSession -ComputerName $adServer -Credential $adCredentials –Authentication Kerberos

        # Import the module using implicit remoting
        Import-Module ActiveDirectory -PSSession $adSession -Force
        
        # Importing the new PowerShell Remoting Session to make the cmdlets locally available.
        #Import-PSSession $adSession


 }, $null)
