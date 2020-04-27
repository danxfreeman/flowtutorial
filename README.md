# R Programming for Flow Analysis

*A Gentle Introduction to R Programming for Flow Analysis*

*By Dan Freeman*

## Who Are You?

Chances are you're heard of `R` and flirted with the idea of programming for quite some time. You know it's a lucrative area and growing fast. Maybe you've even observed bioinformaticians from afar and marveled at their mysterious dark-lit consoles. Who are these strange sorcerers who walk among mortals? How does one become initiated to such strange and wonderful magic? Well, this is it. *This is how you become a bioinformatician*.

Bioinformaticians vary in their strengths and responsibilities, but they really include anyone who uses a programming language to understand living systems. Some were formally trained, but most learned by Googling how to do stuff enough times that other people started referring to them as "data scientists". So give yourself a congratulations. By doing this tutorial and completing the exercises, you are doing bioinformatics!

## Why Learn R?

You may have heard of `flowCore` and other `Bioconductor` packages created specifically for flow cytometrists. They usually come with a wide variety of “plug-and-play” functions that let you input flow data on one end and get abstract-ready figures on the other. This approach has a low barrier to entry but it limits the user to a set of template analyses. Using `flowCore` in isolation is more like learning a new software by trying out the different features the developer has programmed for you.

For researchers with a genuine interest in data science, I strongly suggest learning base `R`. This approach requires much more time and effort, but you’ll be learning rules and conventions that are universal across `R` and other programming languages rather than memorizing the unique syntax for each `Bioconductor` package. Eventually, you’ll also get to enjoy the satisfaction of building workflows from scratch and watching your code bring order to large and complex datasets. It took me about a year to achieve this level of mastery and I found the process to be extremely rewarding.


Start your journey by completing any of the great `R` tutorials avaliable on the internet. Once you’ve gotten a basic understanding of the language, I also recommend reading the book [R for Data Science](https://r4ds.had.co.nz/) by Hadley Wickham. It’s written in a plain language, is full of fun exercises, and will teach you about 90% of what you need to know about data wrangling and visualization. I created this tutorial to help cover the other 10% that is specific to flow cytometry, including importing FCS files and converting them into a format that base `R` functions can understand. Everything that is not in the book or this tutorial can be picked up as it becomes necessary to the project at hand.

## Useful Tools and Resources

Here are four packages I could not live without
* `tidyverse`: Data wrangling
* `ggplot2`: Visualization
* `data.table`: Extension of `data.frames` that comes with additional features for dealing with big data, including fast read (`fread`), fast write (`fwrite`), and special aggregation functions

A few more fun visualization tools
* `facet_wrap` and `facet_grid`: Create faceted plots
* `ggpubr`: Add statistical tests to `ggplots`
* `ggcyto`: FlowJo-like axis transformations
* `viridis`: Pretty color palettes
* `ggridges`: Visualize fluorescent intensities
* `ggrepel`: Smart text labels

Packages that became useful later on
* `caret`: Quickly [compare machine learning models](https://topepo.github.io/caret/index.html)
* `parallel`: Parallelize big jobs with `mclapply`
* `Rfast`: Quickly aggregate large dataframes

Some other skills that you will probably have to learn at some point
* Regular expressions
* High performance computing (HPC)
* Bash

Books that helped me learn general concepts
* [R for Data Science](https://r4ds.had.co.nz/)
* [Orchestrating Single-Cell Analysis with Bioconductor](https://osca.bioconductor.org/)
* [Feature Engineering and Selection: A Practical Approach for Predictive Models](http://www.feat.engineering/)

## Data Import and Transformation

If you just sit down one day and decide to "learn data science", you'll end up getting pulled in so many directions that eventually you'll just lose interest. The best way to learn data science is to pick an interesting dataset and do a complete analysis, learning the necessary skills along the way. Here, we'll be starting with a toy graft-versus-host (GvHD) dataset.

```
# Code...
```
