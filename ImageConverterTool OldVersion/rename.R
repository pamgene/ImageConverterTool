#oldDir<-"C:\\Users\\Fnaji\\Dropbox\\rprojects\\imageRename\\6312836 after washing"
print("starting")
print(getwd())
print(.libPaths())
if (!"EBImage" %in% installed.packages()){
  source("http://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}
if (!"abind" %in% installed.packages()){
install.packages("abind", repos="http://cran.xl-mirror.nl/")
}
if (!"tiff" %in% installed.packages()){
install.packages("tiff", repos="http://cran.xl-mirror.nl/")
}

if (!"locfit" %in% installed.packages()){
install.packages("locfit", repos="http://cran.xl-mirror.nl/")
}

if (!"BiocGenerics" %in% installed.packages()){
install.packages("BiocGenerics", repos="http://cran.xl-mirror.nl/")
}
if (!"methods" %in% installed.packages()){
install.packages("methods", repos="http://cran.xl-mirror.nl/")
}

if (!"png" %in% installed.packages()){
install.packages("png", repos="http://cran.xl-mirror.nl/")
}
if (!"lpeg" %in% installed.packages()){
install.packages("jpeg", repos="http://cran.xl-mirror.nl/")
}

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

m<-regexpr("[[:digit:]]{7}", oldName)
if (m == -1) barcodePart='0000000' 
else barcodePart<-regmatches(oldName,m)

m<-regexpr("[[:digit:]][[:digit:]]_[[:digit:]][[:digit:]]", oldName)
wellPart<-regmatches(oldName,m)


newName<-gsub(replacement=barcodePart,pattern="XXXXXX",tempName)
newName<-gsub(replacement=paste("W",convert[wellPart,2],sep=""),pattern="YY",newName)

newName<-paste(newDir,newName,sep="\\")
oldName<-paste(oldDir,oldName,sep="\\")
file.copy(from=oldName, to=newName)

suppressWarnings(img<-readImage(newName,type= "tiff"))
img<-img/4
suppressWarnings(writeImage(img,newName))
}
