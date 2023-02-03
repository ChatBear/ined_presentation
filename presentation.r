library(aws.s3) 
library(datasets)

## Il n’est pas nécessaire de configurer les droits d’accès au système S3, 
## car le service RStudio en dispose dès son lancement.

#Imporation des données 
bucketlist(region="")
df <- 
  aws.s3::s3read_using(
    FUN = data.table::fread,
    nrows = 1000L,
    select = c("AGEMERE", "AGEPERE"),
    object = "Naissance/FD_NAIS_2019.csv",
    bucket = "sadamaly",
    opts = list("region" = "")
  )

#Légère transformation et ajout d'une colonne 
df$AGEREMERE <- df$AGEMERE/max(df$AGEMERE)
df$AGEPERE <- df$AGEPERE/max(df$AGEPERE)

# Écriture des données sur le bucket s3
# On écrit le changement sur les données 
aws.s3::s3write_using(
  df2,
  FUN = data.table::fwrite,
  # Les options de fread sont ici
  object = "Naissance/FD_NAIS_2019.csv",
  bucket = "sadamaly",
  opts = list("region" = "")
)

# On enregistre une nouvelle donnée sur le bucket. Par exemple, nous allons enregistrer les données
# airquality provenant du package datasets. 
data("airquality")
df2 <- airquality

aws.s3::s3write_using(
  df2,
  FUN = data.table::fwrite,
  # Les options de fread sont ici
  object = "airquality.csv",
  bucket = "sadamaly",
  opts = list("region" = "")
)

