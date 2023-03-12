#' @title Calculating Occluded Surface Areas.
#' @name ocluded_area
#'
#' @description This a principal function of package osvfibo. It's a innovation
#' method based in Occluded Surface, but now using Fibonnaci Distribution.
#' @param path_pdb Name or path of pdb.
#' @param first Number of first atom.
#' @param last Number of last atom.
#' @param raydist Character that define if the user wants to generate raydist file.
#' @author Herson Hebert
#'
#' @export

ocluded_area = function(path_pdb, first,last, raydist){
  create_osfil(first, last, raydist)
  path_orign = getwd()
#   pack_path = path.package(package = "osvfibo")
   path_1 = "/src/os_v76/os.run"
   path_2 = "/src/os_v76"
   os_run = readLines(path_1)
#   os_run[11] = paste("setenv OSDIR ",path_2, sep = "")
#   writeLines(os_run, path_1)
#   cleaner(path_pdb)
#   system(paste("chmod 777 ",path_1,sep = ""))
#   setwd(path_2)
# #  system("./compile.csh")
#   system("./os.run")
#   prot = read_prot("prot.srf")
#   setwd(path_orign)
#   return(prot)
}
