# Overview

This folder contains the implementations of the calculator benchmark application in Delphi VCL, Delphi FMX, WPF with .NET Framework, and Electron.  These applications are the source material for Emberacadero Technologies' analyis of each framework in its whitepaper ***Discovering the Best Developer Framework Through Benchmarking***. The whitepaper is introduced in this [blog post](https://blogs.embarcadero.com/published-discovering-the-best-developer-framework-through-benchmarking/) and can be downloaded for free from this [repository](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Discovering%20the%20Best%20Developer%20Framework%20Through%20Benchmarking%2012232020.pdf) or through [this form](https://lp.embarcadero.com/Discovering_the_best_framework).

Each framework sub-folder contains implementation source code, executable binaries, and an analysis of that implementation against the specification.

# Specification
Reference [Calculator Specification.md](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Calculator%20Specification.md).  This project sought to emulate the [Windows 10 calculator](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/win10calculator.png).

# Measuring Tools

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
***Discovering the Best Developer Framework Through Benchmarking*** is saved to this [repository](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Discovering%20the%20Best%20Developer%20Framework%20Through%20Benchmarking%2012232020.pdf) and can also be downloaded from the [Embarcadero website](https://lp.embarcadero.com/Discovering_the_best_framework).


## Executive Summary
When businesses choose a software framework, they commit to a long-term relationship for the duration of their application’s lifecycle. Given the strategic consequences of this decision, businesses must carefully consider a framework’s developer productivity, business functionality, application flexibility, and product performance. The best framework demonstrates strength in each category and will minimize product time-to-market, lower maintenance costs, maximize product variety, and provide a superior customer experience. 

This paper evaluates three frameworks for Windows application development - **Delphi**, **Windows Presentation Foundation (WPF)** with the **.NET Framework**, and **Electron**. Each development framework will create Windows applications but calls upon different languages, libraries, IDEs, and compilation models. To assess these frameworks, this paper defines four evaluation categories, describes 23 metrics, defines the benchmark application, and scores each framework using a weighted evaluation. The benchmark, a Windows 10 Calculator clone, assesses frameworks’ ability to re-create a known GUI and target the Windows desktop environment.

Evaluation conclusions include:
1. Delphi and its RAD Studio IDE profoundly enhance development productivity and product time-to-market. Not only that, developing one codebase to reach every desktop and mobile platform simplifies successive releases and product maintenance.
2. WPF with the .NET Framework offers small teams native entry to Windows applications and a solid IDE but struggles to match Delphi’s productivity, IP security, and performance 3. while also missing Delphi and Electron’s cross-platform features. 
Electron offers a free alternative to Delphi and WPF, familiarity to front-end developers, and cross-platform capability at the cost of IP protection, standard IDE tooling, and application performance.

![overview of framework scores](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Delphi_WPF_Electron%204-metric%20chart.png)


# Community Involvement
Please read the paper, examine the source code, and engage!  If you find flaws or missed implrevements, submit an Issue.  Embarcadero plans to update this paper and repository a few times as we refine our techniques and understanding of each framework assessed.


# Contributors
## Embarcadero Technologies, Inc. 
Marco Cantù, RAD Studio Senior Product Manager

Adam Leone, Software Development Intern

Jim McKeeth, Chief Developer Advocate & Engineer

David Millington, RAD Studio Senior Product Manager


## Embarcadero Most Valuable Professionals (MVPs)
[Ian Barker](https://www.codedotshow.com/blog/about/)

[Bob Calco](https://apexdatasolutions.com/news/apex-blog/)

[Javier Gutiérrez Chamorro](https://www.javiergutierrezchamorro.com/)

[Olaf Monien](https://www.developer-experts.net/en/about-us/)

[François Piette](http://francois-piette.blogspot.com/)

[Patrick Prémartin](https://developpeur-pascal.fr/page/_0-a-propos-de-l-auteur.html)

[Yılmaz Yörü](http://www.yyoru.com/)

## Independent Contractors
[Serhii K.](https://www.upwork.com/fl/serhiik)

[Eli M.](https://www.upwork.com/freelancers/~015a0a19afc2593d77)

[Martin P.](https://github.com/martin-pettersson)

[Dhiraj S.](https://www.upwork.com/freelancers/~01139eb7cc53906988)

[Heru S.](https://www.upwork.com/freelancers/~0195227b473e36e942)

[Victor V.](https://www.upwork.com/freelancers/~01393e5253b24c66e9)


