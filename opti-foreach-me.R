DrugDiseaseName <- DisNames[1]
DrugDiseaseGeneMatrix <- GeneAnnotations
DrugDiseaseFeatureMatrix <- DiseaseAnnotations
DFDrgDis <- Diseases

GenesinAnnotation0 <- colSums(DrugDiseaseGeneMatrix)

## Main Functions
GetEnrichedAnnotations <- function(DrugDiseaseName,
                                   DrugDiseaseGeneMatrix,
                                   DrugDiseaseFeatureMatrix,
                                   DFDrgDis){ ## Function Begins
  TotalGenesCount = nrow(DrugDiseaseGeneMatrix)
  ## Get the assosciated Genes for each Drug or Disease
  DrugDiseaseGenes = GetGeneList(DrugDiseaseName,DFDrgDis)
  ## Get the only annotations that Genes from the Drug or Disease List 
  UPDNAnnotations = DrugDiseaseFeatureMatrix[DrugDiseaseName,]
  UPDNAnnotations = UPDNAnnotations[UPDNAnnotations > 0]
  ## First value to the HyperGeometricFunction phyper
  GenesFromInput = DrugDiseaseFeatureMatrix[DrugDiseaseName,names(UPDNAnnotations)]
  ## Second value to the HyperGeometricFunction phyper
  GenesinAnnotation = GenesinAnnotation0[names(UPDNAnnotations)]
  ## Third Value  to the HyperGeometricFunction phyper
  TotalGenes = rep(TotalGenesCount,length(GenesFromInput))
  RemainingGenes = TotalGenes - GenesinAnnotation
  ## Fourth value to the HyperGeometricFunction phyper
  NumberOfGenesInDrug = rep(length(DrugDiseaseGenes),length(GenesFromInput))
  names(NumberOfGenesInDrug) = names(GenesFromInput)
  ## Apply Enrichment ANalysis
  PValues = phyper(GenesFromInput-1,GenesinAnnotation,RemainingGenes,NumberOfGenesInDrug,lower.tail = FALSE)
  AdjustedPvalues = p.adjust(PValues,method = "BH")
  EnrichedAnnotations = AdjustedPvalues[AdjustedPvalues <= 0.05]
  ### When P value is zero, replacing zeros with the minimum value
  EnrichedAnnotations[EnrichedAnnotations == 0] = 2.2e-16
  EnrichedAnnotations = EnrichedAnnotations[EnrichedAnnotations <= 0.05]
  ## Get the log value for the adjusted Pvalues
  EnrichedAnnotations = -log(EnrichedAnnotations,2)
  ## This vector consists of all the annotations including Enriched Annotations
  TotalAnnotaionsVector = rep(0,ncol(DrugDiseaseGeneMatrix))
  names(TotalAnnotaionsVector) = colnames(DrugDiseaseGeneMatrix)
  TotalAnnotaionsVector[names(EnrichedAnnotations)] = EnrichedAnnotations
  return(TotalAnnotaionsVector)
}##Function Ends




## Get GeneList for a given Diseases
GetGeneList = function(DiseaseName,DFDrgDis){
  GeneList = DFDrgDis[DFDrgDis$DrugName == DiseaseName,"Symbol"]
  GeneList = unlist(strsplit(GeneList,","))
  GeneList = trimws(GeneList)
  GeneList = unique(GeneList)
  return(GeneList)
}


## Parraleize the Code
numberofCores = parallel::detectCores() - 1
### Closing all the Existing Connections
closeAllConnections()
### Making a Cluster  with 8 of 8 available cores
Cluster <- parallel::makeCluster(numberofCores)
### Register the Cluster
doParallel::registerDoParallel(Cluster)





## Please download the RObject from below link
## Please download the three objects for reproducible example
## https://drive.google.com/drive/folders/0Bz9Y4BgZAF7oS2dtVVEwN0Z1Tnc?usp=sharing

GeneAnnotations = readRDS("drive-download-20170825T211150Z-001/GeneAnnotations.rds")
DiseaseAnnotations =  readRDS("drive-download-20170825T211150Z-001/DiseaseAnnotations.rds") 
Diseases =  readRDS("drive-download-20170825T211150Z-001/Diseases.rds") 
## Get the Unique Names of Disease List
DisNames = row.names(DiseaseAnnotations)

## Below Function runs the code on parallel to get the Enriched Annotations for Multiple Drugs or Diseases
## Get the Enriched Annotaions for all the Diseases UP Regulated EnricR Genes
library(foreach)
EnrichedAnnotations <- foreach(i=1:length(DisNames), .export= c('GetGeneList'),.packages = "Matrix") %do% {
  GetEnrichedAnnotations(DisNames[i],GeneAnnotations,DiseaseAnnotations,Diseases)
}

## Convert to Matrix
EnrichedAnnotations <- do.call("cbind",EnrichedAnnotations)
EnrichedAnnotations = t(EnrichedAnnotations)

colnames(EnrichedAnnotations) = colnames(EnrichedAnnotations)
rownames(EnrichedAnnotations) = DisNames


## Stop the Cluster
parallel::stopCluster(Cluster)


all.equal(EnrichedAnnotations, save)
