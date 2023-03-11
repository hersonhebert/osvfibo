ocluded_area = function(path_pdb, first,last){
  path_orign = getwd()
  pack_path = path.package(package = "osvfibo")
  path = paste(pack_path,"/src/os_v76/os.run", sep = "")
  os_run = readLines(path)
  os_run[11] = "setenv OSDIR /home/herson/Documentos/osvfibo/src/os_v76"
  writeLines(os_run, "src/os_v76/os.run")
  cleaner("/home/herson/Documentos/1ppf.pdb")
  system("chmod 777 src/os_v76/os.run")
  setwd("src/os_v76/")
  system("./compile.csh")
  system("R.")
  system("./os.run")
  prot = read_prot("prot.srf")
  setwd(path_orign)
}
