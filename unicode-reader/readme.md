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
    


# Measurement Tools

## Fiddler
**[Fiddler](https://www.telerik.com/fiddler)** is a web-debugging proxy that captures network traffic for analysis. It can be used to view the HTTP requests and responses and measure their duration.  The total elapsed time of an RSS feed refresh should be roughly the same for all frameworks and implementations of the Unicode Reader assuming the network is stable and untaxed by other processes because it measures only network time rather than internal processing time.  This is useful because differences in the total elapsed time from the user clicking "refresh" to the application displaying fresh data can be attributed to the frameworks and their internal processes rather than other causes.

To set up Fiddler to view network time:
1. [Download](https://www.telerik.com/fiddler) and install.
2. Select *View* -> *Preferences*. 
    - Check *Capture HTTPS traffic* and install/trust root certificate.
    - In the *Connections* tab, make sure *Act as system proxy on startup* is selected.
    - Exit *Preferences* and restart.
3. Select the *Live Traffic (Capturing)* tab.
4. Click the hamburger-like symbol directly underneath the "eye" of the *Live Traffic* tab.  The hovertext says **Stream - responses are streamed to the client as they are read from the server, if enabled**. This will prevent Fiddler from interrupting traffic or causing delays that impact the message timing.
5. Start an instance of the Unicode Reader.  Open the Task Manager (or OS equivalent) and note the process name and process ID.
6. Click the three dots on the right side of the *Process* column header and type the process name under the "Contains" field.  Click *Enable* to add the filter and only see traffic from the Unicode Reader application.
7. Click the three dots on the right side of any column header and select **Columns** at the bottom.  Check the *Time* and *Duration* boxes.  Uncheck *Comments* or any other undesired columns.
8. In the Unicode Reader application, connect to the database and refresh an RSS feed.  You should see an HTTP CONNECT and a GET message appear in Fiddler.  The *Time* column will list the start times of each traffic.  

**Total elapsed network time is found by subtracting the CONNECT time from the GET time (giving milliseconds between messages) and adding the GET message duration.**

## Internal Application Timers
The Delphi and Electron applications created by Embarcadero Technologies incorporate two timers as a way to measure the duration of internal processes.  These timers start when the user clicks a button and are stopped after the result is rendered to the user.  They will be used for two tests that fully exercise two aspects of framework database liraries.

### Test 1 - Database Storage
Starting with an empty (but configured) database, this test will iterate over every RSS feed and store every article returned (ideally over 200).  Because these tests will be run on the same computer (per OS), same network, and with the same PostgreSQL database server, differences in test duration between applications highlight efficiencies or extra overhead in their respective framework libraries.

### Test 2 - Database Retreival
Starting with an "full" database from the Database Storage test, this test will iterate over every article returned (ideally over 200) and concatenate them into a flat .html file with some simple formatting for viewing in a web browser.  The purpose of this test is to exercise each framework's database retrieval functions and tease out the efficiency differences in each as measured by test duration.  The concatenation of files is intended to be minimally intensive and merely provides a reason to touch every file in the database.


## AppTimer
Passmark Software's [AppTimer](https://www.passmark.com/products/apptimer/) for Windows runs an executable defined by the user and measures startup time over a number of iterations.  The user can define the number of iterations, the conditions that must be met before the application is "running", and the method of shutting down the app.  Results are logged in a text file.

   ![AppTimer](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/AppTimer%20Setup.PNG)

To set up AppTimer:
1. [Download](https://www.passmark.com/products/apptimer/) and unzip.
2. Click the three dots to the right of the *Application* field and navigate to the **.exe** file you want to test.
3. Click the three dots to the right of the *Log File* field, navigate folder you want the log file in, and name your file.
4. Enter the application name in the Window Name (run the application and see what the top bar says).
5. Enter a number of executions - this paper averaged 100 executions with a 10ms delay.
6. Check *New windows only*, *Input idle*, *Window Name*, *Visible*, and *WM_CLOSE*.  These settings ensure the most complete application startup and normal exit.
7. Click **Run App**, wait, and examine the log file for results.

## Task Manager Deluxe
MiTeC's [Task Manager Deluxe](https://www.mitec.cz/tmx.html#:~:text=Task%20Manager%20DeLuxe%20(TMX)%20is%20based%20on%20MiTeC,can%20be%20easily%20used%20as%20portable%20application%20everywhere.) is a richly featured task manager alternative that provides more granular data about individual processes.

  ![TMX](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/TMX%20Setup.PNG)
 
To set up Task Manager Deluxe:
1. [Download](https://www.mitec.cz/tmx.html#:~:text=Task%20Manager%20DeLuxe%20(TMX)%20is%20based%20on%20MiTeC,can%20be%20easily%20used%20as%20portable%20application%20everywhere.) and install.
2. Open the application to examine.
3. Start TMX64.exe
4. Search for the window name of your application in the TMX search bar.
5. Double click on the process for your application.
6. Examine the process details in the window that appeared.  The left sidebar provides data on CPU and Memory use among other performance metrics.
  

# Analysis



## Executive Summary


# Community Involvement
Please read the paper, examine the source code, and engage!  If you find flaws or missed implrevements, submit an Issue.  Embarcadero plans to update this paper and repository a few times as we refine our techniques and understanding of each framework assessed.


# Contributors
## Embarcadero Technologies, Inc. 
Jim McKeeth, Chief Developer Advocate & Engineer



## Embarcadero Most Valuable Professionals (MVPs)


## Independent Contractors
[Serhii K.](https://www.upwork.com/fl/serhiik)

[Adam Leone](https://github.com/ildrummer)

[Eli M.](https://www.upwork.com/freelancers/~015a0a19afc2593d77)

[Martin P.](https://github.com/martin-pettersson)

[Heru S.](https://www.upwork.com/freelancers/~0195227b473e36e942)

[Victor V.](https://www.upwork.com/freelancers/~01393e5253b24c66e9)
