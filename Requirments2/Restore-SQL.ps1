# Ryan Furman 012240009

try {
    $sqlServerInstanceName = "SRV19-PRIMARY\SQLEXPRESS"
    $databaseName = "ClientDB"

    # Check if database exists
    $databaseExists = Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "SELECT COUNT(*) AS Count FROM sys.databases WHERE name = '$databaseName'" | Select-Object -ExpandProperty Count

    if ($databaseExists -eq 1) {
        Write-Host "The database '$databaseName' already exists. Attempting to drop it..."

        # Force disconnect all connections to the database before dropping
        Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "ALTER DATABASE [$databaseName] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;"
        Write-Host "Set database '$databaseName' to SINGLE_USER mode with rollback immediate."

        # Drop the database
        Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "DROP DATABASE [$databaseName];"
        Write-Host "The database '$databaseName' has been dropped."
    } else {
        Write-Host "The database '$databaseName' does not exist. Proceeding to create it."
    }

    # Create the database
    Write-Host "Creating the database '$databaseName'..."
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query "CREATE DATABASE [$databaseName];"
    Write-Host "The database '$databaseName' has been created."

    # Create the table only if it does not exist
    $tableName = "Client_A_Contacts"
    $tableScript = @"
USE [$databaseName];
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = '$tableName')
BEGIN
    CREATE TABLE dbo.[$tableName]
    (
        First_Name varchar(100),
        Last_Name varchar(100),
        City varchar(50),
        County varchar(50),
        Zip varchar(20),
        OfficePhone varchar(15),
        MobilePhone varchar(15)
    );
END
"@

    Write-Host "Creating the table '$tableName' if it does not exist..."
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Query $tableScript
    Write-Host "Table '$tableName' is ready."

    # Insert data from CSV file
    $csvPath = Join-Path $PSScriptRoot "NewClientData.csv"
    $csvSqlPath = $csvPath -replace '\\', '\\\\'

    $insertScript = @"
BULK INSERT dbo.[$tableName]
FROM '$csvSqlPath'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
"@

    Write-Host "Inserting data from '$csvPath' into '$tableName'..."
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Database $databaseName -Query $insertScript
    Write-Host "Data has been inserted into '$tableName'."

    # Generate output file with table contents
    $outputFilePath = Join-Path $PSScriptRoot "SqlResults.txt"
    $outputScript = "SELECT * FROM dbo.[$tableName];"
    Invoke-Sqlcmd -ServerInstance $sqlServerInstanceName -Database $databaseName -Query $outputScript | Out-File -FilePath $outputFilePath -Encoding UTF8
    Write-Host "The 'SqlResults.txt' file has been generated."

} catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
}
