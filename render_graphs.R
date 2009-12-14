dat = read.csv('SVD_EG-US.csv',header=TRUE) 
cols = c('green','green','red','blue','blue','blue')

png("SVD_EG-US.png", width=500, height=500, bg = "transparent")
plot(dat, col=cols, pch=16)
dev.off()

png("SVD_EG-US.V0V1.png", width=500, height=500, bg = "transparent")
plot(dat$V0, dat$V1, xlab='V0', ylab='V1', col=cols, pch=16)
dev.off()

dat = read.csv('SVD_EG-VS.csv',header=TRUE)
cols = c('green','green','blue','blue')

png("SVD_EG-VS.png", width=500, height=500, bg = "transparent")
plot(dat, col=cols, pch=16)
dev.off()

png("SVD_EG-VS.V0V1.png", width=500, height=500, bg = "transparent")
plot(dat$V0, dat$V1, xlab='V0', ylab='V1', col=cols, pch=16)
dev.off()

