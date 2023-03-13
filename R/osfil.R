#' @title Construction of os.fil file.
#' @name create_osfil
#'
#' @description The code is applied to buil os.fil file that is responsible to
#' store importants parameters to execution.
#' @param first Number of first atom
#' @param last Number of last atom
#' @param raydist Character "y" or "n" that describes if the user wants create raydist
#'
#' @author Herson Hebert
#'
#' @export
create_osfil = function(first, last, raydist){
  #close(file("src/os_v76/os.fil"))
  fileCon = file("src/os_v76/os.fil")
  #path_fil = "src/os_v76/os.fil"
  writeLines(c("temp.pdb",first,last,raydist),fileCon)
  close(fileCon)

}
