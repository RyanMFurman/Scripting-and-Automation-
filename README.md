# Scripting-and-Automation-

Powersheell scripts I created for wgu scripting and automation class. 


TASK 1:
You are working as a server administrator at a consulting firm. Your client is a recent start-up company based out of Salt Lake City, Utah. Currently their environment contains only 35 employees. They will be doubling their staff in the coming months, and you will need to start automating some processes that are commonly run. In the near future, they may be hiring an intern for the system administration. As such, you will need to comment throughout the script to identify the script processes. Please follow the task requirements below to help this company.

A.  Create a PowerShell script named “prompts.ps1” within the “Requirements1” folder. For the first line, create a comment and include your first and last name along with your student ID.


Note: The remainder of this task should be completed within the same script file, prompts.ps1.


B.  Create a “switch” statement that continues to prompt a user by doing each of the following activities, until a user presses key 5:

1.  Using a regular expression, list files within the Requirements1 folder, with the .log file extension and redirect the results to a new file called “DailyLog.txt” within the same directory without overwriting existing data. Each time the user selects this prompt, the current date should precede the listing. (User presses key 1.)

2.  List the files inside the “Requirements1” folder in tabular format, sorted in ascending alphabetical order. Direct the output into a new file called “C916contents.txt” found in your “Requirements1” folder. (User presses key 2.)

3.  List the current CPU and memory usage. (User presses key 3.)

4.  List all the different running processes inside your system. Sort the output by virtual size used least to greatest, and display it in grid format. (User presses key 4.)

5.  Exit the script execution. (User presses key 5.)


C.  Apply scripting standards throughout your script, including the addition of comments that describe the behavior of each of parts B1–B5.


D.  Apply exception handling using try-catch for System.OutOfMemoryException.


E.  Run your script and take a screenshot of the user results when each prompt (parts B3–B4) is chosen. Save each screenshot within the “Requirements1” folder. Compress all files (original and new) within the folder to a ZIP archive.


F.  When you are ready to submit your final script, run the Get-FileHash cmdlet against the “Requirements1” ZIP archive. Note that hash value and place it into the comment section when you submit your task.




TASK 2:
You have been hired as a consultant at a company. The company previously had an SQL server and Active Directory server configured throughout two separate Windows 2012 servers. However, all the drives (including backups) were destroyed due to unforeseen circumstances, and you need to write PowerShell scripts that can accomplish all the required tasks from the local server.

A.  Create a PowerShell script named “Restore-AD.ps1” within the attached “Requirements2” folder. Create a comment block and include your first and last name along with your student ID.


B.  Write the PowerShell commands in “Restore-AD.ps1” that perform all the following functions without user interaction:

1.  Check for the existence of an Active Directory Organizational Unit (OU) named “Finance.” Output a message to the console that indicates if the OU exists or if it does not. If it already exists, delete it and output a message to the console that it was deleted.

2.  Create an OU named “Finance.” Output a message to the console that it was created.

3.  Import the financePersonnel.csv file (found in the attached “Requirements2” directory) into your Active Directory domain and directly into the finance OU. Be sure to include the following properties:

•   First Name

•   Last Name

•   Display Name (First Name + Last Name, including a space between)

•   Postal Code

•   Office Phone

•   Mobile Phone

4.  Include this line at the end of your script to generate an output file for submission:

 Get-ADUser -Filter * -SearchBase “ou=Finance,dc=consultingfirm,dc=com” -Properties DisplayName,PostalCode,OfficePhone,MobilePhone > .\AdResults.txt


C.  Create a PowerShell script named “Restore-SQL.ps1” within the attached “Requirements2” folder. Create a comment block and include your first and last name along with your student ID.


D.  Write the PowerShell commands in a script named “Restore-SQL.ps1” that perform the following functions without user interaction:

1.  Check for the existence of a database named ClientDB. Output a message to the console that indicates if the database exists or if it does not. If it already exists, delete it and output a message to the console that it was deleted.

2.  Create a new database named “ClientDB” on the Microsoft SQL server instance. Output a message to the console that the database was created.

3.  Create a new table and name it “Client_A_Contacts” in your new database. Output a message to the console that the table was created.

4.  Insert the data (all rows and columns) from the “NewClientData.csv” file (found in the attached “Requirements2” folder) into the table created in part D3.

5.  Include this line at the end of your script to generate the output file SqlResults.txt for submission:

Invoke-Sqlcmd -Database ClientDB –ServerInstance .\SQLEXPRESS -Query ‘SELECT * FROM dbo.Client_A_Contacts’ > .\SqlResults.txt


E.  Apply exception handling using try-catch. Output any error messages to the console.


F.  Run your Restore-AD.ps1 script from this console and take a screenshot of the output.

1.  Run your Restore-SQL.ps1 script from this console and take a screenshot of the output.


G.  Compress the “Requirements2” folder as a ZIP archive. When you are ready to submit your final task, run the Get-FileHash cmdlet against the “Requirements2” ZIP archive. Note the hash value and place it into the comment section when you submit your task.

1.  Include all the following files intact within the “Requirements2” folder, including the original files and any additional files you created to support your script:

i.  “Restore-AD.ps1”

ii.  “Restore-SQL.ps1”

iii.  “AdResults.txt”

iv.  “SqlResults.txt”

v.  Screenshots from Parts F and F1


H.  Apply scripting standards throughout your script, including the addition of comments that describe the behavior of the script.
