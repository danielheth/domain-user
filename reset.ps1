
param (
    [string]$username = $(throw "-username is required."),
    [string]$password = $(throw "-password is required.")
)
 
if ($username.Contains("@")) {
    $usr = $username.Split("@",2);
    $username = $usr[0];
    $domain = $usr[1];
} else {
    $dom = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
    #Forest                  : corp.moranit.com
    #DomainControllers       : {dc.corp.moranit.com}
    #Children                : {}
    #DomainMode              : Windows2012R2Domain
    #Parent                  :
    #PdcRoleOwner            : dc.corp.moranit.com
    #RidRoleOwner            : dc.corp.moranit.com
    #InfrastructureRoleOwner : dc.corp.moranit.com
    #Name                    : corp.moranit.com
    $domain = $dom.Name;
}
$dmn = "cn=Users,dc=" + $domain.replace(".",",dc=");

$full_user_string = "cn=" + $username + "," + $dmn
#echo $full_user_string


Try {
    $pwd = ConvertTo-SecureString $password -asplaintext -force

    $usrObject = get-aduser -filter "SamAccountName -like '$username'" -searchbase $dmn

    Set-ADAccountPassword $usrObject -NewPassword $pwd
}
Catch {
    Write-Warning "Failed to reset password for $Username"
    Write-Warning $_.Exception.Message
}