c********************************************************************
c  Program MAIN for Occluded Surface (OS) Package
c
C* Copyright (c) Laboratory for the Structure of Matter, 
C* Naval Research Laboratory, Washington DC 20375 and Geo-Centers Inc
C* Fort Washington, MD 20744.
C* and
C* Yale University, New Haven, CT 06520
C* All rights reserved.  
C
C  The program either in full or in part should not be distributed
C  in any form or by any means without the prior written
C  permission of the author:
C
C* N. Pattabirman
C* Bldg 430/ Room 206
C* PRI-NCI/FCRDC
C* P. O. Box B
C* Frederick, MD 21702-1201
C* E-mail : pattabir@fcrfv1.ncifcrf.gov
C
C* Patrick Fleming
C* Yale University
C* Dept. of Molecular Biophysics and Biochemistry
C* P. O. Box 208114
C* 260 Whitney Ave.
C* New Haven, CT 06520-8114
C* fleming@csb.yale.edu
C
c********************************************************************

       program main

       parameter (maxat=50000, maxres=10000)

       character*60 infile
       character*130 cmd
       character atype(maxat)*4, restype(maxat)*3      !read_coords
       character chain(maxres)*1			!read_coords
       character aarestype(maxres)*3
       character rayflag	!Flag for ray printing from surfcal
				!Should by y or n

       integer resnum(maxres), nchains, aa_per_chain,
     & canum(maxres), natm      !see read_coords
       integer iresf,iresl      !first and last residue to calculate
       integer naa                      !number of residues
       integer ires                     !residue of interest
       integer number

       real x(3,maxat)          !see read_coords

10     format(a)
15     format(i1)
20     format('   Residue(s) to calculate not in PDB file.')
30     format(75x)
40     format(a3,1x,i4,'    C')
50     format(a3,1x,i4,'    O')
60     format(a3,1x,i4)
70     format('   ',1x,i4,'    N')
80     format('part_v.pdb')
82     format('part_i.ms')
84     format('part_i.pdb')
86     format('part_v.ms')

c Read os.fil for name of pdb file
       read(5,10) infile

c Read first and last residue numbers to be calculated
       read(5,*) iresf
       read(5,*) iresl

c Read flag for printing of rays
       read(5,10) rayflag

c Open pdb file as unit=1
       open (unit=1, file=infile, status='old')

c Read pdb file and put info in arrays
c Note: The CA residue numbers are not used but were
c left in for future use.

       call read_coords (atype,restype,chain,resnum,nchains,
     &  aarestype,x,canum,natm,maxat,maxres,naa)
        print*, 'naa = ', naa

c Close pdb file
         close(unit=1)

c Now check that what you read is what you think
c      do 888 i=1,natm
c        write(6,88)atype(i),
c    &       restype(i),chain(i),resnum(i),
c    &       (x(j,i),j=1,3)
c88      format('ATOM', 7X, 1X, A4, 1X, A3, 1X, A, I4, 4X, 3F8.3)
c888   continue


c Check that range of interest is in pdb file
       if (iresf .lt. resnum(1)) then
         write(6,20)
       else if (iresl .gt. resnum(natm)) then
         write(6,20)
       end if

c Begin the main loop for the program
       do 100 ires=iresf,iresl

c Write pdb records for residue of interest
         call wrtresi (ires,atype,restype,chain,resnum,x,natm,
     &   maxat,maxres)

c Write pdb records for rest of protein
         call wrtresj (ires,atype,restype,chain,resnum,x,natm,
     &   maxat,maxres)


c Make dot surface and calc normal for ires
         cmd = 'ds75 part_i.pdb' 
         call system(cmd)

c Prepare input for ray analysis
         open(unit=9,file='part.inp',status='unknown')

c Write flag for printing of rays
         if ((rayflag .eq. 'y') .or.
     &   (rayflag .eq. 'Y')) then
           number = 1
           write(9,15) number
         else
           number = 0
           write(9,15) number
         endif

c Ignore atoms C and O of i-1 when extending rays
         if (ires.eq.1) then
           write(9,30)
         else
           write(9,40)aarestype(ires-1),(ires-1)
           write(9,50)aarestype(ires-1),(ires-1)
         end if
 

c For ires
         write(9,60)aarestype(ires),(ires)

c Ignore atom N of ires+1 when extending rays
         if (ires .eq. naa) then
           write(9,30)
         else
           write(9,70)(ires+1)
         end if

c Add following to input for surfcal
         write(9,80)
         write(9,82)
c        write(9,84)
c        write(9,86)

c And close the input for surfcal
         close(unit=9)

c Now call the surfcal program
          cmd='surfcal76 < part.inp'
          call system(cmd)

c Copy results for this residue into the .srf file
          cmd = 'cat file.srf >> prot.srf'
          call system(cmd)


 100   continue
       end
 
c***********************************************************************

       subroutine read_coords (atype,restype,chain,resnum,nchains,
     &  aarestype,x,canum,natm,maxat,maxres,naa)

c atype =                       Atom type, ' CD1'
c restype =             Residue type, 'ALA' for record, i
c aarestype =           Residue type, 'ALA' for residue, i
c resnum =              Residue number, '  35'
c nchains =             Number of chains, '1' (Left in for hist. reas.)
c x =                   Coordinates, '  5.212  15.936   2.350'
c canum =                       Atom numbers of CA atoms
c natm =                        Number of total atoms


c Argument declarations

c      parameter (maxat=50000, maxres=10000)
       integer resnum(maxres), nchains, 
     & canum(maxres), natm

       real x(3,maxat)

       character atype(maxat)*4      !atype of record number
       character restype(maxat)*3    !restype of record number
       character aarestype(maxres)*3 !restype of res number
       character chain(maxres)*1
       character*80 line


c Local declarations

       integer lunit, icrd, i, naa

       character fname*30, prompt*30, oldchain*1

       logical scrollerror, notdone


c Initialize

       natm=0
       nchains = 0
       oldchain = '?'
       lunit = 1

c Formats
  5     format(a)
 10     format(6X, 5X, 1X, A4, 1X, A3, 1X, A, I4, 4X, 3F8.3)
 20     format('Coordinate file does not have the',
     & ' correct ATOM record format.')
 25     format('  Exceeded maximum of 2000 residues.')
 30     format('  Read TER record')
 35     format('  Finished reading PDB file at END record')

c Scroll to first atom in PDB file.
       scrollerror = .true.
       do while (scrollerror)
         call pdbscroll (lunit, 'ATOM', scrollerror)
         if (scrollerror) then
           write(6,20)
           close (lunit)
         else
c Start reading atoms
           notdone = .true.
           naa = 0
           n=0
           do while (notdone .and. (naa .lt. maxat))
             read(lunit,5,end=100)line
             if (line(1:4) .ne. 'ATOM') then
               if (line(1:3) .eq. 'TER') then
                 write(6,30)
                 goto 90
               else if (line(1:3) .eq. 'END') then
                 write(6,35)
                 goto 100
               else
                 goto 100
               endif
             end if
             n=n+1
             read(line,10,end=100)atype(n),
     &       restype(n),chain(n),resnum(n),
     &       (x(i,n),i=1,3)

             if (resnum(n) .ne. resnum(n-1)) then
               naa = naa + 1
c Look for CA
               if (atype(n) .eq. ' CA ') then
                  canum(naa)=n     !gives atom number of CA
               end if
               aarestype(resnum(n))=restype(n) !3-letter code
               if (naa .gt. maxres)then
                 write(6,25)
                 goto 999
               end if
               if (chain(n) .ne. oldchain) then
                 nchains = nchains +1
                 oldchain = chain(n)
               end if
             end if
90           continue
           end do
 100        continue
            natm = n
         endif
       end do


 999    continue

       return
       end

c***********************************************************************

       subroutine pdbscroll (lunit, target, error)

c Argument declarations

       integer lunit
       character*4 target
       logical error

c Local declarations

       character*4 key
       logical looking

c Formats

 10     format(a4)

c Initialize

       looking = .true.
       rewind (lunit)
       do while (looking)
         read (lunit,10,end = 100) key
         if (key .eq. target) then
           looking = .false.
         end if
       end do
 100    continue

       if (looking) then        !target not found
         error = .true.
       else                     !found target, repostion file pointer
         error = .false.
         backspace (lunit)
       end if
       return
       end

*********************************************************
       subroutine wrtresi (ires,atype,restype,chain,resnum,x,natm,
     & maxat,maxres)

c Writes coordinates of residue i to part_i.pdb and also
c the coords of C(i-1) and N(i+1)

cArgument Declaration
c      parameter  (maxat=20000, maxres=10000)
       integer ires
       integer natm
       integer resnum(maxres)

       real x(3,maxat)

       character atype(maxat)*4
       character restype(maxat)*3
       character chain(maxres)*1
c Local Declarations
       integer j,l

c Formats

 10     format('ATOM',3x,i4,1x,a4,1x,a3,1x,a,i4,4x,3f8.3)
 20     format('END')
c Open the file for output
       open(unit=8,file='part_i.pdb',status='unknown')

c Find atom C of residue (i-1)
       do 100 j=1,natm
         if ((resnum(j) .eq. (ires-1)) .and.
     &   (atype(j) .eq. ' C  ')) then
           write(8,10)j,atype(j),restype(j),chain(j),resnum(j),
     &     (x(l,j),l=1,3)
         end if
 100    continue

c Write coords of ires
       do 110 j=1,natm
         if (resnum(j) .eq. (ires))then
           write(8,10)j,atype(j),restype(j),chain(j),resnum(j),
     &     (x(l,j),l=1,3)
         end if
 110    continue

c Find atom N of ires+1
       do 120 j=1,natm
         if ((resnum(j) .eq. (ires+1)) .and.
     &   (atype(j) .eq. ' N  ')) then
           write(8,10)j,atype(j),restype(j),chain(j),resnum(j),
     &     (x(l,j),l=1,3)
         end if

 120    continue

       write(8,20)
       close (unit=8)

       return
       end
 
c******************************************************************
       subroutine wrtresj (ires,atype,restype,chain,resnum,x,natm,
     & maxat,maxres)

c Writes coordinates of rest of protein to  part_v.pdb
c omitting ires (leaves void)

c Argument Declaration
c      parameter (maxat=20000,maxres=10000)
       integer ires,natm
       integer resnum(maxres)

       real x(3,maxat)

       character atype(maxat)*4, restype(maxat)*3
       character chain(maxres)*1

c Formats
10     format('ATOM',3x,i4,1x,a4,1x,a3,1x,a,i4,4x,3f8.3)
20     format('END')

c Open the file for output
       open(unit=8,file='part_v.pdb',status='unknown')

c Write coords of everything but ires
       do 100 j=1,natm
         if (resnum(j) .ne. (ires))then
           write(8,10)j,atype(j),restype(j),chain(j),
     &     resnum(j),(x(l,j),l=1,3)
         end if
100    continue

       write(8,20)
       close (unit=8)

       return
       end


