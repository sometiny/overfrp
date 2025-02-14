
$platforms = @("win-x64", "win-arm64", "linux-x64", "linux-arm64", "osx-arm64", "osx-x64", "linux-musl-x64", "linux-musl-arm64");

foreach($platform in $platforms) {
    vbt compress ./$platform/ ./overfrp-$platform.zip --quite
}