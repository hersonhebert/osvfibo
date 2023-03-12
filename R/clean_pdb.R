#' @title Organiza o PDB
#' @name cleaner
#'
#' @description The code extracts only the 'ATOM' records
#' from a PDB file and removes hydrogens and most alternate
#' conformations.
#' @param path_pdb One string that describe the walk to find the PDB file
#'
#' @author Herson Hebert
#'
#' @importFrom bio3d read.pdb
#' @importFrom bio3d write.pdb
#' @importFrom bio3d clean.pdb
#'
#' @export
cleaner = function(path_pdb){
  pack_path = path.package("osvfibo")
  pdb = read.pdb(path_pdb)
  pdb = clean.pdb(pdb, fix.chain = TRUE)
  path = paste(pack_path,"/src/os_v76/temp.pdb", sep = "")
  write.pdb(pdb, path)
}
