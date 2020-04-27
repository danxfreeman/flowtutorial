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

# Import and concatenate flow data.
fs <- read.flowSet(key$files)
flow <- fsApply(fs, exprs, simplify = F)
flow <- lapply(flow, as.data.table)
concat <- rbindlist(flow, idcol = "file")
concat <- inner_join(key, concat, by = "file")
concat$file <- NULL

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
