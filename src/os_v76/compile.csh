#!/bin/csh -f

set osname = `uname`
if ($osname == "Linux") then

  set PROCESSOR_TYPE = `uname -m`

  if ($PROCESSOR_TYPE == "x86_64") then

    gfortran -march=native -ftree-vectorize -o bin/main75 src/main75.f 
    gfortran -march=native -ftree-vectorize -o bin/ds75 src/ds75.f
    gfortran -march=native -ftree-vectorize -o bin/occsurf75 src/occsurf75.f
    gfortran -march=native -ftree-vectorize -o bin/respak75 src/respak75.f
    gfortran -march=native -ftree-vectorize -o bin/intchos75 src/intchos75.f
    gfortran -march=native -ftree-vectorize -o bin/surfcal76 src/surfcal76.f
    gfortran -march=native -ftree-vectorize -o bin/renum75 src/renum75.f

  else

    gfortran -march=native -o bin/main75 src/main75.f
    gfortran -march=native -o bin/ds75 src/ds75.f
    gfortran -march=native -o bin/occsurf75 src/occsurf75.f
    gfortran -march=native -o bin/respak75 src/respak75.f
    gfortran -march=native -o bin/intchos75 src/intchos75.f
    gfortran -march=native -o bin/surfcal76 src/surfcal76.f
    gfortran -march=native -o bin/renum75 src/renum75.f

  endif

else if ($osname == "Darwin") then
# This works for gfortran-mp-4.8, later compilers will give working code
# but will throw unbounded value messages. 

  gfortran  -o bin/main75 src/main75.f
  gfortran  -o bin/ds75 src/ds75.f
  gfortran  -o bin/occsurf75 src/occsurf75.f
  gfortran  -o bin/respak75 src/respak75.f
  gfortran  -o bin/intchos75 src/intchos75.f
  gfortran  -o bin/surfcal76 src/surfcal76.f
  gfortran -o bin/renum75 src/renum75.f

else
   echo 'Do not recognise your achitecture'
endif
