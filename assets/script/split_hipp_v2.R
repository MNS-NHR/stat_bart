setwd('~/Desktop/bart/')
library(nat)
dir.create('atlas_split_hipp_v2',recursive = TRUE, showWarnings = FALSE)

roi.list<-read.csv2('Regions_IDs.csv',sep='\t')

c1.mat<-read.nrrd('annotation_25_full.nrrd')

roi.list.range<-383:416
roi.list.add<-length(roi.list.range)

y.thr<-300

for(j in roi.list.range){
  print(paste('now doing ',j,sep=' '))
      rgb.index<-which(c1.mat[,,]==roi.list$id[j] ,arr.ind = TRUE) 
      rgb.index<-rgb.index[which(rgb.index[,2]>=y.thr),]
      if(length(rgb.index)>=1){
        c1.mat[rgb.index]<-roi.list$id[j]+2000}
    }


write.nrrd(c1.mat,file = 'annotation_25_full_split.nrrd')

roi.list.sep<-roi.list[roi.list.range,]
roi.list.sep$id<-roi.list.sep$id+2000

new.roi.list<-rbind(roi.list,roi.list.sep)
write.csv2(new.roi.list,'Regions_IDs_split.csv')