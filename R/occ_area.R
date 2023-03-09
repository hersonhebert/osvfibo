ocluded_area = function(path_pdb, first,last){
  path_orign = getwd()
  os_run = readLines("src/os_v76/example/os.run")
  os_run[11] = "setenv OSDIR /home/herson/Documentos/osvfibo/src/os_v76"
  writeLines(os_run, "src/os_v76/os.run")
  cleaner("/home/herson/Documentos/1ppf.pdb")
  system("chmod 777 src/os_v76/os.run")
  setwd("src/os_v76/")
  system("./compile.csh")
  system("./os.run")
  prot = read_prot("prot.srf")
  setwd(path_orign)
}
