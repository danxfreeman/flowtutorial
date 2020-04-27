# R Programming for Flow Analysis

*A gentle introduction to R programming for flow analysis, by Dan Freeman*

## Who Are You?

Chances are you've heard of `R` and flirted with the idea of programming for quite some time. You know it's a lucrative area and growing fast. You also know it make you a better researcher. Maybe you've even observed bioinformaticians from afar and marveled at their mysterious dark-lit consoles. Where did they come from? How did they become initiated to such strange and wonderful magic? Well, this is it.

Bioinformaticians vary in their strengths and responsibilities, but they really include anyone who uses a programming language to study living systems. Some were formally trained, but most learned by Googling how to do stuff enough times that other people started referring to them as "data scientists". So give yourself a congratulations. By doing this tutorial and completing the exercises, you are doing bioinformatics!

## Why Learn R?

You may have heard of `flowCore` and other `Bioconductor` packages created specifically for flow cytometrists. These usually come with a wide variety of “plug-and-play” functions that let you input flow data on one end and get abstract-ready figures on the other. While this approach has a low barrier to entry, it limits the user to a set of template analyses. Using `flowCore` in isolation is more like learning a new software by trying out the different features the developer has programmed for you.

For researchers with a genuine interest in data science, I strongly suggest learning base `R`. This approach requires much more time and effort, but you’ll be learning rules and conventions that are universal across `R` and other programming languages rather than memorizing the unique syntax for each `Bioconductor` package. Eventually, you’ll also get to enjoy the satisfaction of building workflows from scratch and watching your code bring order to large and complex datasets. It took me about a year to achieve this level of mastery and I found the process to be extremely rewarding.

Start your journey by completing any of the great `R` tutorials available on the internet. Once you’ve gotten a basic understanding of the language, I also recommend reading the book [R for Data Science](https://r4ds.had.co.nz/) by Hadley Wickham. It’s written in a plain language, is full of fun exercises, and will teach you about 90% of what you need to know about data wrangling and visualization. I created this tutorial to help cover the other 10% that is specific to flow cytometry, including importing FCS files and converting them into a format that base `R` functions can understand. Everything that is not in the book or this tutorial can be picked up as it becomes necessary to the project at hand.

In summary, this is how I learned `R` and is what I suggest for others.
* General `R` tutorial
* [R for Data Science](https://r4ds.had.co.nz/)
* `flowCore` and `ggcyto`
* Your first data science project

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

Packages that became useful later on
* `caret`: Quickly [develop and compare machine learning models](https://topepo.github.io/caret/index.html)
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

If you just sit down one day and decide to "learn data science", you'll end up getting pulled in so many directions that eventually you'll just lose interest. The best way to learn data science is to pick an interesting dataset and do a complete analysis, learning the necessary skills along the way. Here, we'll be starting with a public graft-versus-host (GvHD) dataset.

```
# Load libraries.
library(flowCore)
library(ggcyto)

library(data.table)
library(tidyverse)

library(ggplot2)
library(ggpubr)
library(ggridges)

# Import sample annotations.
key <- read.csv("key.csv")
key$sample <- str_extract(key$file, "[^\\.]+")

# Import and concatenate flow data.
fs <- read.flowSet(key$files)
flow <- fsApply(fs, exprs, simplify = F)
flow <- lapply(flow, as.data.table)
concat <- rbindlist(flow, idcol = "file")
concat <- inner_join(key, concat, by = "file")
concat$file <- NULL
```

Next, let's make some simple visualizations about our data.

```
# Plot sample counts.
p1 <- samples %>%
  group_by(outcome, visit) %>%
  summarise(count = n()) %>%
  ggplot(aes(x = visit, y = count, fill = outcome, label = count)) +
  geom_col(position = "dodge") +
  geom_text(vjust = -1, position = position_dodge(0.9)) +
  scale_y_continuous(limits = c(0, 12), breaks = seq(0, 12, 2)) +
  ggtitle("Sample Count") +
  xlab("Visit") +
  ylab("Number of Samples") +
  labs(fill = "Outcome")

# Plot cell counts.
key$count <- fsApply(fs, nrow)
p2 <- key %>%
  ggplot(aes(x = cell, y = events, fill = outcome)) +
  geom_boxplot() +
  geom_dotplot(binaxis = "y", stackdir = "center", position = position_dodge(0.75)) +
  stat_compare_means(method = "t.test", label = "p.format", label.y.npc = 0.9) +
  ggtitle("Cell Count") +
  xlab("Cell Type") +
  ylab("Number of Cells") +
  labs(fill = "Outcome")

# Arrange plots.
panel <- ggarrange(p1, p2, nrow = 1, align = "h")
ggsave(panel, file = "sample_cell_count.pdf")
```

Finally, let's see what each marker looks like at the cellular level. You can plug flowFrames directly into `ggcyto` or convert them into dataframes and use plain `ggplot2`.

```
# Plot flourescent distributions.
flow %>%
  select(ends_with("H")) %>%
  gather("marker", "intensity") %>%
  arrange(outcome) %>%
  mutate(patient = factor(patient, levels = unique(patient))) %>%  # preserves sample order
  ggplot(aes(x = intensity, y = patient, fill = outcome)) +
  geom_density_ridges(alpha = 0.5) +
  scale_x_flowjo_biexp() +
  facet_grid(cols = vars(marker), scales = "free") +
  ggtitle("Marker Distribution") +
  xlab("Biexponential Intensity") +
  ylab("Patient") +
  labs(fill = "Outcome") +
  theme_ggpubr()
```
