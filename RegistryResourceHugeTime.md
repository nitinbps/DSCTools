####
This workaround can be used if DSC registry resource is taking a long time to process the request. Workaround is to periodically delete files from the folder “$env:windir\system32\config\systemprofile\AppData\Local\Microsoft\Windows\PowerShell\CommandAnalysis”.

###

1)	Implement the following logic within DSC configuration itself. 
 
 <pre>
Configuration $configName
{    
   # User Data
    Registry SetRegisteredOwner
    {
        Ensure = 'Present'
        Force = $True
        Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows NT\CurrentVersion'
        ValueName = 'RegisteredOwner'
        ValueType = 'String'
        ValueData = $Node.RegisteredOwner
    }
    #
    # Script to delete the config 
    #
    script DeleteCommandAnalysisCache
    {
        getscript="@{}"
        testscript = 'Remove-Item -Path $env:windir\system32\config\systemprofile\AppData\Local\Microsoft\Windows\PowerShell\CommandAnalysis -Force -Recurse -ErrorAction SilentlyContinue -ErrorVariable ev | out-null;$true'
        setscript = '$true'
    }
}
 
</pre>

2) Have periodic task to clean up this folder either via task scheduler or other scheduling infrastructure.
