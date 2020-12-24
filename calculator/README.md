# Overview

This folder contains the implementations of the calculator benchmark application in Delphi VCL, Delphi FMX, WPF with .NET Framework, and Electron.  These applications are the source material for Emberacadero Technologies' analyis of each framework in its whitepaper ***Discovering the Best Developer Framework Through Benchmarking***. The whitepaper is introduced in this [blog post](https://blogs.embarcadero.com/published-discovering-the-best-developer-framework-through-benchmarking/) and can be downloaded for free from this [repository](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Discovering%20the%20Best%20Developer%20Framework%20Through%20Benchmarking%2012232020.pdf) or through [this form](https://lp.embarcadero.com/Discovering_the_best_framework).

Each framework sub-folder contains implementation source code, executable binaries, and an analysis of that implementation against the specification.

# Specification
Reference [Calculator Specification.md](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/Calculator%20Specification.md).  This project sought to emulate the [Windows 10 calculator](https://github.com/Embarcadero/ComparisonResearch/blob/main/calculator/win10calculator.png).

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


