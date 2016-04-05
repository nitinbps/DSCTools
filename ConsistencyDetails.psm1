function Get-NextDSCConsistencyTime
{
    #get last consistency run details
    $consistencyRuns = gcfgs -all | where { $_.Type -ieq 'consistency'}
    $configTime = (get-dsclocalconfigurationmanager).ConfigurationModeFrequencyMins
    if( $consistencyRuns.Count -eq 0 )
    {
        return $configTime
    }

    $lastrunTime = $consistencyRuns[0].StartDate

    #get current time
    $currentTime = [Datetime]::Now
    #Get amount of time passed since last run
    $timeElapsed = $currentTime - $lastrunTime
    if($timeElapsed -ge $configTime)
    {
        # we are almost ready to run another consistency check
        return 0
    }
    $remainingTime = $configTime - $timeElapsed.TotalMinutes

    [int]$remainingTime
}

Export-ModuleMember -function Get-NextDSCConsistencyTime