# These are rough examples on how the data handled and plotted
# Some simplification and shortening is made to make the file readable
# 

library(ggplot)
library(reshape2)
# Cpu usage/Mem usage example
cpu_data_batch_25 <- read.csv(file="test_batch_writes_25_clients.out_cpu.csv", sep=";")
cpu_data_batch_25$test <- "25 clients"

# CPU -1 is "all cores"
cpu_data_batch_25_subset <- subset(cpu_data_batch_25, CPU == -1)

# Create new timestamps for plotting, as the measurements are taken at different times
cpu_data_batch_25_subset$actual_timestamp 
              <- starttime + 5 * (seq_len(nrow(cpu_data_batch_25_subset))-1)

# .. repeat above for all sets of data, before binding

# Bind data to one frame

cpu_batch_data <- rbind(cpu_data_batch_25_subset, cpu_data_batch_50_subset,
            cpu_data_batch_60_subset, cpu_data_batch_75_subset)

# Plot the data. Do one more subset to clean up the end of the plot as the tests
# were stopped at slightly different times
ggplot(subset(dat, actual_timestamp <= as.POSIXct('2016-03-13 14:04:30 GMT')), 
        aes(y=X.user, x=actual_timestamp))
        + geom_smooth(se=F, method="loess", size=0.6, aes(color=test)) 
        + ylab("Processor load") + ggtitle("Batch writes") 
        + theme(axis.title.x=element_blank(), text = element_text(size=7),
                axis.text.x = element_blank()) + scale_colour_discrete(name=element_blank())

ggsave("batch_writes_cpu.png", width=4, height = 2)

#
# Response times
#
single_clients_10_requests <- read.csv(file="10clients_single_writes_requests_1457454956.09.csv", sep=",", header=TRUE)
single_clients_10_requests$test <- "10 clients"

# .. repeat above for all sets of data, before binding
# 

# Bind the data together 
requests_single_writes <- rbind(single_clients_10_requests, single_clients_50_requests, 
  single_clients_75_requests, single_clients_100_requests, single_clients_150_requests)

# Melt the data to achieve grouping for bar plots
single_writes_melted <- melt(requests_single_writes[,c("Min.response.time", "Average.response.time", 
                                                        "Max.response.time", "test")])

# Plot the data
ggplot(single_writes_melted, aes(reorder(test,value),value)) 
            + geom_bar(aes(fill =variable), stat="identity", position="dodge") 
            + ylab("Response time / ms") 
            + theme(axis.title.x=element_blank(), text = element_text(size=7), legend.title=element_blank()) 
            + ggtitle("Single writes")

ggsave(filename = "requests_single_writes.png", width=4, height =2)
