cls

function getDiskSpaceInfoUNC($p_UNCpath, $p_unit = 1tb, $p_format = '{0:N1}')
{
    # unit, one of --> 1kb, 1mb, 1gb, 1tb, 1pb
    $l_typeDefinition = @' 
        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)] 
        [return: MarshalAs(UnmanagedType.Bool)] 
        public static extern bool GetDiskFreeSpaceEx(string lpDirectoryName, 
            out ulong lpFreeBytesAvailable, 
            out ulong lpTotalNumberOfBytes, 
            out ulong lpTotalNumberOfFreeBytes); 
'@
    $l_type = Add-Type -MemberDefinition $l_typeDefinition -Name Win32Utils -Namespace GetDiskFreeSpaceEx -PassThru

    $freeBytesAvailable     = New-Object System.UInt64 # differs from totalNumberOfFreeBytes when per-user disk quotas are in place
    $totalNumberOfBytes     = New-Object System.UInt64
    $totalNumberOfFreeBytes = New-Object System.UInt64

    $l_result = $l_type::GetDiskFreeSpaceEx($p_UNCpath,([ref]$freeBytesAvailable),([ref]$totalNumberOfBytes),([ref]$totalNumberOfFreeBytes)) 

    $totalBytes     = if($l_result) { $totalNumberOfBytes    /$p_unit } else { '' }
    $totalFreeBytes = if($l_result) { $totalNumberOfFreeBytes/$p_unit } else { '' }

    New-Object PSObject -Property @{
        Success   = $l_result
        Path      = $p_UNCpath
        Total     = $p_format -f $totalBytes
        Free      = $p_format -f $totalFreeBytes
    } 
}

<#
getDiskSpaceInfoUNC "C:\" "1gb"
getDiskSpaceInfoUNC "D:\" "1gb"
getDiskSpaceInfoUNC "E:\" "1gb"
getDiskSpaceInfoUNC "F:\" "1gb"
#>


for ( $disky = 65; $disky -le 90; $disky++){
$disky_2 = [char] $disky
$disky_2 += ":\"
#echo $disky_2"<<"
getDiskSpaceInfoUNC $disky_2 "1gb"
}

sleep 10


