#' @title Reading Values of Occluded Surface Area.
#' @name read_prot
#'
#' @description It's a important function to load calculated values to use of user.
#' @param prot Name or path of prot.srf.
#'
#' @author Herson Hebert
#'
#' @importFrom readr read_fwf
#' @importFrom dplyr filter
#' @importFrom stringr str_count
#' @importFrom tidyr separate
#'
#' @export
read_prot = function(prot){
  dado = read_fwf(prot)
  dado = filter(dado, X1 == "INF")
  dado$X7 = NULL
  colunas1 <- paste0("RESIDUE", 1:(max(str_count(dado$X2, '   '))))
  dado = separate(dado, X2, into=colunas1, sep='   ', remove=TRUE, extra="merge")

  dado$RESIDUE2= gsub("\\_\\_\\_"," ",dado$RESIDUE2)
  dado$RESIDUE2= gsub("\\_\\_"," ",dado$RESIDUE2)
  dado$RESIDUE2= gsub("\\_"," ",dado$RESIDUE2)
  colunas1 <- paste0("AUX", 1:(max(str_count(dado$RESIDUE2, 's>'))))
  dado = separate(dado, RESIDUE2, into=colunas1, sep='>', remove=TRUE, extra="merge")
  dado$AUX0= gsub("\\s\\s\\s",";",dado$AUX0)
  dado$AUX0= gsub("\\s\\s",";",dado$AUX0)
  dado$AUX0= gsub("\\s",";",dado$AUX0)
  colunas1 <- paste0("A", 1:(max(str_count(dado$AUX0, ';'))))
  dado = separate(dado, AUX0, into=colunas1, sep=';', remove=TRUE, extra="merge")
  dado = rename(dado, INF = X1, RESIDUE_1 = RESIDUE1, ATOM_1 = AUX1, RESIDUE_2 = A1,ATOM_2 = A2, NUMBER_POINTS = X3, AREA = X4, RAYLENGTH = X5, DISTANCE = X6)
  dado$ATOM_1 = gsub("\\@"," ", dado$ATOM_1)
  dado$ATOM_2 = gsub("\\@"," ", dado$ATOM_2)
  dado$ATOM_2 = gsub("\\;","", dado$ATOM_2)
  dado$NUMBER_POINTS = gsub("\\s\\pts","", dado$NUMBER_POINTS)
  dado$AREA = gsub("\\s\\A2","", dado$AREA)
  dado$RAYLENGTH = gsub("\\s\\Rlen","", dado$RAYLENGTH)
  dado$NUMBER_POINTS = as.integer(dado$NUMBER_POINTS)
  dado$AREA = as.double(dado$AREA)
  dado$RAYLENGTH = as.double(dado$RAYLENGTH)
  dado$DISTANCE = as.double(dado$DISTANCE)

  return(dado)
}
