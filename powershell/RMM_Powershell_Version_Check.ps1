$error.clear()
$PS_Version = (get-host).Version.Major
if($PS_Version -ge 5) {
    $PS_Version
    exit 0
}else{
    $PS_Version
    exit 1
}
