
## We divide all data into different catalogues
cna_data <- mydata
colnames(cna_data) <- c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K')



## 'A'
col <- mydata[, 1]
cut1 <- 0
cut2 <- 2
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,1] <- col

## 'B'
col <- mydata[, 2]
cut1 <- 50000
cut2 <- 100000
cut3 <- 200000
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col <= cut3 & col > cut2] <- 2
col[col > cut3] <- 3
cna_data[,2] <- col

## 'C'
col <- mydata[, 3]
cut1 <- 300000
cut2 <- 500000
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,3] <- col

## 'D'
col <- mydata[, 4]
cut1 <- 31457280
cut2 <- 52428800
cut3 <- 1048576000
col[col <= cut1] <- 3
col[col <= cut2 & col > cut1] <- 2
col[col <= cut3 & col > cut2] <- 1
col[col > cut3] <- 0
cna_data[,4] <- col

## 'E'
col <- mydata[, 5]
cut1 <- 0
cut2 <- 20
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,5] <- col

## 'F'
col <- mydata[, 6]
cut1 <- 0
cut2 <- 1
col[col <= cut1] <- 0
col[ col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,6] <- col

## 'G'
col <- mydata[, 7]
cut1 <- 0
cut2 <- 2
col[col <= cut1] <- 0
col[col < cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,7] <- col

## 'H'
col <- mydata[, 8]
cut1 <- 144*108*3
cut2 <- 1280*720*3
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,8] <- col

## I 
col <- mydata[, 9]
cut1 <- 524288
cut2 <- 3*1048576
col[col <= cut1] <- 2
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 0
cna_data[,9] <- col

## J
col <- mydata[, 10]
cut1 <- 30000
cut2 <- 100000
cut3 <- 300000
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col <= cut3 & col > cut2] <- 2
col[col > cut3] <- 3
cna_data[,10] <- col

## K
col <- mydata[, 11]
cut1 <- 10000
cut2 <- 60000
col[col <= cut1] <- 0
col[col <= cut2 & col > cut1] <- 1
col[col > cut2] <- 2
cna_data[,11] <- col
cna_data[,11] <- col

cna(cna_data, con = 0.9, cov = 0.1, outcome = c("J=3"))
cna(cna_data, con = 0.6, cov = 0.6, outcome = c("J=3"))
