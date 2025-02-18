cls

$disky = Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object DeviceID, FreeSpace

$d_disky = $disky.Length-1
#echo $d_disky
#echo $d_disky.GetType()

for ($xx = 0; $xx -le $d_disky; $xx++) {
#echo $xx
[string] $out = $disky[$xx]
#echo $out

$jednotka = $out.Substring(11,1)
$jednotka += ":\"
echo $jednotka

$d_out = $out.Length
#echo $d_out

if ($d_out -gt 26 ){
#$volne_misto = $out.Substring(25,2) # 10,1
$volne_misto = $out.Substring(25,$d_out-26) # 10,1
#echo $volne_misto"<"
}else{
$volne_misto = "0"
}
#echo $volne_misto"<"
#echo $volne_misto.GetType()
[int64] $volne_misto_int = $volne_misto
echo $volne_misto_int
#echo $volne_misto_int.GetType()

# zaverecny vyhodnoceni a tisk

if ( $volne_misto_int -gt 1000000000 ){
$out_2  = (( $volne_misto_int / 1000000000 ))
$out_3 = "$out_2 Gb"
}

if ( $volne_misto_int -gt 1000000 ){
$out_3  = (( $volne_misto_int / 1000000 ))
$out_3 = "$out_2 Mb"
}

echo $out_3
echo "--------------------------"
}

#@{DeviceID=D:; FreeSpace=}
#0123456789012345678901234567890

#@{DeviceID=E:; FreeSpace=
#0123456789012345678901234567890



95619555328
12345678901
