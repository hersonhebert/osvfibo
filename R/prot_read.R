read_prot = function(prot){
  prot = "prot.srf"
  dado = readr::read_table(prot, col_names = FALSE)
  dado = dplyr::filter(dado, X1 == "INF")
  dado$X13 = dado$X14 = NULL
  dado$X3 = gsub("\\@"," ",dado$X3)
  dado$X4 = gsub("\\@"," ",dado$X4)
  dado$X3= gsub("\\_\\_\\_"," ",dado$X3)
  dado$X3= gsub("\\_\\_"," ",dado$X3)
  dado$X3= gsub("\\_"," ",dado$X3)
  dado$X4= gsub("\\_\\_\\_"," ",dado$X4)
  dado$X4= gsub("\\_\\_"," ",dado$X4)
  dado$X4= gsub("\\_"," ",dado$X4)
  dado$X3 = gsub("\\s>"," ",dado$X3)

  return(dado)
}
