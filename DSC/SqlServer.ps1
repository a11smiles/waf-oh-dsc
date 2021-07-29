﻿Configuration SqlServer {
    
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $LoginCredential,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $SqlCredential
    )

    Import-DscResource -ModuleName @{ModuleName="PSDesiredStateConfiguration";ModuleVersion="2.0.5"}, SqlServerDsc

    <#
    [string]$username = 'webapp'
    [string]$password = 'S0m3R@ndomW0rd$'
    [securestring]$securedPassword = ConvertTo-SecureString $password -AsPlainText -Force
    [pscredential]$loginCredential = New-Object System.Management.Automation.PSCredential ($username, $securedPassword)

    [string]$sqlUsername = 'cloudsqladmin'
    [string]$sqlPassword = 'Pass@word1234!'
    [securestring]$sqlSecuredPassword = ConvertTo-SecureString $sqlPassword -AsPlainText -Force
    [pscredential]$sqlLoginCredential = New-Object System.Management.Automation.PSCredential ($sqlUsername, $sqlSecuredPassword)
    #>
    
    Node localhost {

        SqlDatabase CreateDatabase
        {
            Ensure          = 'Present'
            ServerName      = 'sqlsvr1'
            InstanceName    = 'MSSSQLSERVER'
            Name            = 'CustomerPortal'

            PsDscRunAsCredential = $SqlCredential
        }
        <#
        SqlLogin CreateDatabaseLogin
        {
            Ensure          = 'Present'
            Name            = 'webapp'
            LoginType       = 'SqlLogin'
            ServerName      = 'sqlsvr1'
            InstanceName    = 'MSSSQLSERVER'
            LoginCredential = $loginCredential
            LoginMustChangePassword        = $false
            LoginPasswordExpirationEnabled = $false
            LoginPasswordPolicyEnforced    = $true

       #     PsDscRunAsCredential = $sqlLoginCredential
            DependsOn       = '[SqlDatabase]CreateDatabase'
        }

        SqlDatabaseUser CreateDatabaseUser
        {
            Ensure          = 'Present'
            ServerName      = 'sqlsvr1'
            InstanceName    = 'MSSSQLSERVER'
            DatabaseName    = 'CustomerPortal'
            Name            = 'webapp'
            UserType        = 'Login'
            LoginName       = 'webapp'

        #    PsDscRunAsCredential = $sqlLoginCredential
            DependsOn       = '[SqlLogin]CreateDatabaseLogin'
        }
        #>
      }
}