Get-ChildItem -Force -Recurse | ForEach-Object {
   Get-Item -LiteralPath $_.FullName -Stream * -Force
} |
ForEach-Object {
  if ($_.Stream -ne ':$DATA') {
    if ($_.Stream -eq 'Zone.Identifier') {
      Write-Host ("Unblocking " + $_.FileName)
      Remove-Item -LiteralPath $_.FileName -Stream $_.Stream
    }
  }
}
