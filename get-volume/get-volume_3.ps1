cls
#Get-Volume -DriveLetter C
#Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property C,FreeSpace
Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property C,@{'Name' = 'FreeSpace (GB)'; Expression={ [int]($_.FreeSpace / 1GB) }}
#Start-Sleep -Seconds 10


