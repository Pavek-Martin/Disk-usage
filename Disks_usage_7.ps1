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
getDiskSpaceInfoUNC "C:" "1kb"
getDiskSpaceInfoUNC "D:" "1gb"
getDiskSpaceInfoUNC "E:" "1gb"
getDiskSpaceInfoUNC "F:" "1gb"
getDiskSpaceInfoUNC "R:" "1kb"
#>

#[string] $xx = getDiskSpaceInfoUNC "c:" "1kb"
#echo $xx
#echo $xx.GetType()

#getDiskSpaceInfoUNC "C:" "1kb" '{0:N0}'

#exit 

for ( $disky = 65; $disky -le 90; $disky++){
$disky_2 = [char] $disky
$disky_2 += ":"
#echo $disky_2"<<"
[string] $out_1 = getDiskSpaceInfoUNC $disky_2 "1kb" '{0:N0}'

#echo $out_1
$zobraz = $out_1.IndexOf("True")
if ($zobraz -ne -1 ){
echo $out_1
$d_out_1 = $out_1.Length
#echo $d_out_1"<<<<"


#
$h_path = "Path="
$n_path = $out_1.IndexOf($h_path)
#echo $n_path
$out_jednotka = $out_1.Substring($n_path+5,2)
echo $out_jednotka
#
$out_total = $out_1.Substring(8,$n_path-10)
echo $out_total
#
$h_free = "Free="
$n_free = $out_1.IndexOf($h_free)
#echo $n_free
#$out_free = $out_1.Substring($n_free+5,4)
$out_free = $out_1.Substring($n_free+5,$d_out_1 - $n_free - 20)



echo $out_free"<"

}

}


