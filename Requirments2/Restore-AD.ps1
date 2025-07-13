# Ryan Furman 012240009

try {
    # Check if Finance OU exists
    $ouExists = Get-ADOrganizationalUnit -Filter {Name -eq 'Finance'} -ErrorAction SilentlyContinue

    if ($ouExists) {
        Write-Host "The 'Finance' OU already exists. Deleting it..."
        Remove-ADOrganizationalUnit -Identity 'OU=Finance,DC=consultingfirm,DC=com' -Confirm:$false -Recursive -ErrorAction Stop
        Write-Host "The 'Finance' OU has been deleted."
    } else {
        Write-Host "The 'Finance' OU does not exist."
    }

    # Create the 'Finance' OU
    Write-Host "Creating the 'Finance' OU..."
    New-ADOrganizationalUnit -Name 'Finance' -Path 'DC=consultingfirm,DC=com' -DisplayName 'Finance' -ProtectedFromAccidentalDeletion $false
    Write-Host "The 'Finance' OU has been created!"

    # Import the financePersonnel.csv file into the 'Finance' OU
    Write-Host "--- Importing user data from financePersonnel.csv in 'Finance' OU ---"
    $csvPath = Join-Path $PSScriptRoot '.\financePersonnel.csv'
    $users = Import-Csv -Path $csvPath
    $ouPath = "OU=Finance,DC=consultingfirm,DC=com"

    foreach ($ADUser in $users) {
        $firstname = $ADUser.First_Name
        $lastname = $ADUser.Last_Name
        $displayname = $firstname + " " + $lastname
        $samAcct = $ADUser.samAccount -replace '[^\w\-]', '' -replace '\'. ''
        $postalcode = $ADUser.Postalcode
        $officephone = $ADUser.OfficePhone
        $mobilephone = $ADUser.MobilePhone

        if ($displayname.Length -gt 20) {
            $displayname = $displayname.Substring(0, 20)
        }

        $name = "$firstname $lastname"

        $userParams = @{
            SamAccountName   = $samAcct
            GivenName        = $firstname
            Surname          = $lastname
            DisplayName      = $displayname
            PostalCode       = $postalcode
            OfficePhone      = $officephone
            MobilePhone      = $mobilephone
            AccountPassword  = (ConvertTo-SecureString 'Passw0rd!' -AsPlainText -Force)
            Enabled          = $true
            Path             = $ouPath
            Name             = $name
        }

        try {
            Write-Host "Creating User '$displayname', '$firstname', '$lastname', '$postalcode', '$officephone', '$mobilephone'"
            New-ADUser @userParams -ErrorAction Stop
            Write-Host "User '$displayname' has been created!"
        } catch {
            Write-Host "An error occurred while creating user '$displayname': $_"
        }
    }

    # Generate output file for AdResults.txt (Part B4 - Rubric Specific Line)
    try {
        Get-ADUser -Filter * -SearchBase "OU=Finance,DC=consultingfirm,DC=com" -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt
        Write-Host "All users from financePersonnel.csv have been imported and 'AdResults.txt' file has been generated!"
    } catch {
        Write-Host "An error occurred while generating the 'AdResults.txt' file: $($_.Exception.Message)"
    }
} catch {
    Write-Host "Error occurred: $($_.Exception.Message)"
}
