# Overview

This folder contains implementations of the UnicodeReader benchmark application in Delphi VCL, Delphi FMX, and Electron.  

Each framework sub-folder contains implementation source code, executable binaries, and an analysis of that implementation against the specification.

# Specification
Reference [Unicode Reader Specification.md](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/Unicode%20Reader%20Specification.md).  This project sought to create a simple [RSS Feed application (Unicode Reader)](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/unicodeReaderDark.png) that would provide some basic, useful functionality while highlighting each framework's approach to database integration.

# Setup Requirements
## PostgreSQL 10
1. Download PostgreSQL **version 10** from the [PostgreSQL website](https://www.postgresql.org/download/).
2. Install per the installation wizard.  **Remember your password or set it to *postgres***.
3. Run **pgAdmin4** as an administrator and log into the console for the first time.  You should see one or more servers listed in the left sidebar (must have PostgreSQL 10).  

    ![pgAdmin Server View](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/documentation/pgadmin.PNG)

4. Right click the PostgreSQL 10 server, select "Connect Server", and enter the password you established when you installed PostgreSQL.


### Troubleshooting: pgAdmin stuck at loading screen (Windows)

If pgAdmin hangs at the loading screen, there are Windows settings blocking its scripts.  [To fix](https://stackoverflow.com/questions/64891592/pgadmin-for-windows-in-the-latest-version-4-28-doesnt-start-anymore-hangs-in):
- open the Registry Editor
- navigate to *Computer\HKEY_CLASSES_ROOT\.js*
- Change the **Content Type** value from "text/plain" to **"text/javascript"**
- Close the editor, shutdown and restart the pgAdmin server.

## Initialize the Unicode Reader Database
1. Add PostgreSQL to the Windows Path
  - Search "Environmental Variables" in the start menu, open and select the "Environmental Variables" button, then double-click on the Path entry in the user variables table.
  - Find your PostgreSQL installation location.  Should look similar to **C:\Program Files (x86)\PostgreSQL\10\bin**.
  - Add the PostgreSQL 10 bin location as a new Path entry and apply in all windows.

2. If not present, add [five .dll files and one .dylib file](https://github.com/Embarcadero/ComparisonResearch/tree/main/unicode-reader/library-and-setup-files) to the PostgreSQL 10 bin folder.
3. Download the **create.sql** script.
4. Open a console window (CMD or PowerShell), navigate to the **create.sql** script, and enter the following command:

```psql -U postgres -f .\create.sql```

5. Enter your PostgreSQL password when prompted.  You should see output from the script as a result.

    ![create.sql Script Output](https://github.com/Embarcadero/ComparisonResearch/blob/main/unicode-reader/documentation/createSQLScriptOutput.PNG)
    
