graph_size = 500

dat = read.csv('SVD_EG-US.csv',header=TRUE) 
cols = c('green','green','red','blue','blue','blue')

png("SVD_EG-US.png", width=graph_size, height=graph_size, bg = "transparent")
plot(dat, col=cols, cex=2, pch=16)
dev.off()

png("SVD_EG-US.V0V1.png", width=graph_size, height=graph_size, bg = "transparent")
plot(dat$f1, dat$f2, xlab='f1', ylab='f2', col=cols, cex=2, pch=16)
dev.off()

dat = read.csv('SVD_EG-VS.csv',header=TRUE)
cols = c('green','green','blue','blue')

png("SVD_EG-VS.png", width=graph_size, height=graph_size, bg = "transparent")
plot(dat, col=cols, cex=2, pch=16)
dev.off()

png("SVD_EG-VS.V0V1.png", width=graph_size, height=graph_size, bg = "transparent")
plot(dat$f1, dat$f2, xlab='f1', ylab='f2', col=cols, cex=2, pch=16)
dev.off()

