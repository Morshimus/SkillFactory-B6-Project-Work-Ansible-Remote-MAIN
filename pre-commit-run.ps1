
if($(tf validate) -match "Success!"){ 
    
 docker run --entrypoint cat ghcr.io/antonbabenko/pre-commit-terraform:latest /usr/bin/tools_versions_info 

 write-host -NoNewline "Terraform validate..........................................................." ;Write-host -NoNewline -b Green "Passed";Write-host " "


 $TAG="latest" 
 
 $Stdout = $(docker run --rm -v  "$($(Get-location).path -replace "\\","\\"):/lint" `
 -w /lint ghcr.io/antonbabenko/pre-commit-terraform:$TAG run -a)



 if($Stdout -match "Failed"){$Stdout;New-Error}else{$Stdout}

}else{write-host -NoNewline "Terraform validate..........................................................." ;Write-host -NoNewline -b red "Failed";New-Error}


function New-Error {
    [CmdletBinding()]
    param()
    $MyErrorRecord = new-object System.Management.Automation.ErrorRecord `
        "Was completed with errors", `
        "", `
        ([System.Management.Automation.ErrorCategory]::NotSpecified), `
        "Was completed with errors"
    $PSCmdlet.WriteError($MyErrorRecord)
}