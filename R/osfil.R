create_osfil = function(first, last, raydist){
  first = 1
  last = 268
  raydist = "y"
  fileCon = file("src/os_v76/os.fil")
  writeLines(c("data/temp.pdb",first,last,raydist),fileCon)
  close(fileCon)
}
