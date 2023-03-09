cleaner = function(path_pdb){
  pdb = bio3d::read.pdb(path_pdb)
  bio3d::write.pdb(pdb, "data/temp.pdb")
  cmd = paste("./src/clean.csh data/temp.pdb")
  system(cmd)
  file.remove("data/temp.pdb")
  file.rename("data/temp.cln", "data/temp.pdb")
  file.copy("data/temp.pdb", "src/os_v76/")
  file.remove("data/temp.pdb")
}
