# Define the path to the source CSV file
$sourceFile = ""
$targetFile = ""

function ProcessAndAppendCsvWithHash {
  param(
    [Parameter(Mandatory = $true)]
    [string] $sourceFile,
    [string] $targetFile
  )
  
  # Function to calculate MD5 hash
  function Get-MD5Hash {
    param(
      [Parameter(Mandatory = $true)]
      [string] $FilePath
    )
  
    Get-FileHash -Algorithm MD5 -Path $FilePath | Select-Object -ExpandProperty Hash
  }
  
  # Get the MD5 hash of the source file
  $fileHash = Get-MD5Hash -FilePath $sourceFile 
  
  # Read the header and data from the source file
  $data = Import-Csv -Path $sourceFile
  $colnames = ($data[0].psobject.Properties).name


  foreach ($row in $data) {
    $row | Add-Member -MemberType NoteProperty -Name "tourn_id" -Value $fileHash
  }


  
  # Export the modified data with the new header
  $data | Export-Csv -Path $targetFile -NoTypeInformation -Append
  Write-Host "Processed $sourceFile and added MD5 hash ('tourn_id') to each row."


}

# Validate the existence of the source file
if (Test-Path -Path $targetFile) {

  ProcessAndAppendCsvWithHash -sourceFile $sourceFile -targetFile $targetFile
    
  Write-Host "Appending $sourceFile to $targetFile..."
  Write-Host "Moving $sourceFile to old_stats..."
  #Remove Source
  Remove-Item -Path $sourceFile
}
else {
  ProcessAndAppendCsvWithHash -sourceFile $sourceFile -targetFile $targetFile
  # Rename the source file to the target file
  Write-Host "Renaming $sourceFile to $targetFile..." 
  Write-Host "testtttt"
  #Remove Source
  Remove-Item -Path $sourceFile
}


