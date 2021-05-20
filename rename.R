
library(reshape2)
#oldDir<-"C:\\Users\\Fnaji\\Dropbox\\rprojects\\imageRename\\6312836 after washing"
print("starting")
print(getwd())
print(.libPaths())

library(EBImage)
convert<-read.delim2(file="convert.txt",stringsAsFactors=FALSE, header=FALSE)
rownames(convert)<-convert[[1]]
oldDir<-choose.dir()

newDir<-paste(oldDir,"-ImageResults",sep="")
cat("directory=",oldDir,"\n")

dir.create(newDir)
fileList<-list.files(oldDir, pattern=".\\.tif")
tempName<-'XXXXXX_YY_F1_T1_P1_I1_A1.tif'



for (i in 1:length(fileList)) {
#oldName<-'0123456 abcdef 01_01.tif'
#oldName<-'After blocking_50ms_01_01.tif'
print(i)
oldName<-fileList[i]

m<-regexpr("[[:digit:]]{7,9}", oldName)
if (m == -1) barcodePart='0000000' else barcodePart<-regmatches(oldName,m)

m<-regexpr("_[[:digit:]][[:digit:]]_[[:digit:]][[:digit:]]\\.tif", oldName)
wellPart<-regmatches(oldName,m)
wellPart<-substr(oldName, m+1,m+5)

r <- convert[wellPart,3]
c <- convert[wellPart,4]
s <- convert[wellPart,5]

newName<-gsub(replacement=barcodePart,pattern="XXXXXX",tempName)
newName<-gsub(replacement=paste("W",convert[wellPart,2],sep=""),pattern="YY",newName)

newName<-paste(newDir,newName,sep="\\")
oldName<-paste(oldDir,oldName,sep="\\")

print(oldName)
print(newName)
file.copy(from=oldName, to=newName)

suppressWarnings(img<-readImage(newName,type= "tiff"))

bimg <-img
bimg <- bimg * 256
m <- median(bimg)

outputFile <- paste0(dirname(newName),"\\","median.txt")
oFile <- file(description=outputFile, open = "a+")

if (i==1) {
  oFile <- file(description=outputFile, open = "a+")
  cat(file=oFile, "Row","\t", "Col","\t", "Strip", "\t", "OldName", "\t", "NewName", "\t", "Median", "\n")
  }

cat(file=oFile, r,"\t",c,"\t", s, "\t", basename(oldName), "\t", basename(newName), "\t", as.character(m), "\n")


img <-img/4

suppressWarnings(writeImage(img,newName))

close(oFile)

}

in_file <- read.delim(file=outputFile, stringsAsFactors = FALSE)

#n<-as.numeric(in.file$Median)
#in.file$Median  <-as.numeric(in.file$Median)
#lapply(in.file, class)


out_file<-dcast(in_file, Col ~ Row, mean)
r<-1:8
r<-as.character(r)
r<-paste0("#0", r)


out_file$Col <- r
colnames(out_file) <- c("Col()","01","02","03","04","05","06", "07","08", "09", "10", "11", "12")
o <- paste0(outputFile,"-plate")
writeLines("r script", con= o)
write.table(file=o ,out_file, row.names=FALSE, sep="\t", quote=FALSE, append = TRUE)

