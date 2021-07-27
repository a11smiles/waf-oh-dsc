﻿Configuration SqlServer {

    Import-DscResource -ModuleName xPSDesiredStateConfiguration, xSqlServer

    [string]$username = 'webapp'
    [string]$password = 'S0m3R@ndomW0rd$'
    [securestring]$securedPassword = ConvertTo-SecureString $password -AsPlainText -Force
    [pscredential]$loginCredential = New-Object System.Management.Automation.PSCredential ($username, $securedPassword)

    [string]$sqlUsername = 'cloudsqladmin'
    [string]$sqlPassword = 'Pass@word1234!'
    [securestring]$sqlSecuredPassword = ConvertTo-SecureString $password -AsPlainText -Force
    [pscredential]$sqlLoginCredential = New-Object System.Management.Automation.PSCredential ($sqlUsername, $sqlSecuredPassword)

    
    Node localhost {

        xSqlServerDatabase CreateDatabase
        {
            Ensure          = 'Present'
            SQLServer       = 'sqlsvr1'
            Name            = 'CustomerPortal'
            SQLInstanceName = 'MSSSQLSERVER'

            PsDscRunAsCredential = $sqlLoginCredential
        }

        xSqlServerLogin CreateDatabaseLogin
        {
            Ensure          = 'Present'
            Name            = 'webapp'
            LoginType       = 'SqlLogin'
            SQLServer       = 'sqlsvr1'
            SQLInstanceName = 'MSSSQLSERVER'
            LoginCredential = $loginCredential
            LoginMustChangePassword        = $false
            LoginPasswordExpirationEnabled = $false
            LoginPasswordPolicyEnforced    = $true

            PsDscRunAsCredential = $sqlLoginCredential
            DependsOn       = '[xSqlServerDatabase]CreateDatabase'
        }

        <#
        xSqlServerDatabaseUser CreateDatabaseUser
        {
            Ensure          = 'Present'
            SQLServer       = 'sqlsvr1'
            SQLInstanceName = 'MSSSQLSERVER'
            DatabaseName    = 'CustomerPortal'
            Name            = 'webapp'
            UserType        = 'Login'
            LoginName       = 'webapp'

            PsDscRunAsCredential = $sqlLoginCredential
            DependsOn       = '[xSqlServerLogin]CreateDatabaseLogin'
        }
        #>
      }
}