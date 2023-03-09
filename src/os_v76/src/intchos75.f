c*************************************************************
c       Program RESPAK_INTCH
c
c       Version 75
c
c       Calculates a packing parameter for each residue
c       in chain a to chain b and visa versa.
c
c       Intra-chain interaction is ignored
c
c       The packing parameter is equal to:
c       (sum[occ surf])*(1-<raylength>)
c
c       Requires a "prot.srf" file from the OS package
c
c       The input asks for input file, output file, and 
c       the residue number of the last A chain residue
c************************************************************

        integer i,j,k,lunit     !lunit is file unit in askfil
        integer maxres          !maximum number of residues

        parameter (maxres=10000)

        character fname*40,prompt(2)*23,line*80,resnam(maxres)*3
        character name*3
        character aa(21)*3

        integer dummy           !Used for comparison
        integer resnum(maxres)
        integer strta           !First resnum of chain  
        integer enda            !Last resnum of chain  
        integer occresnum       !Occluding residue number



c The "packing value" = sum[occ surf*(1-raylength)]

        real respv(500)		!Residue Packing Value
        real pupv(maxres)       !Packing Unit Packing Value
        real resos(500)		!Residue os
        real totos(maxres)	!Total os in interaction faces
        integer thisres
        integer frstres         !Store number of first residue

c These used to identify restype 
        data aa/'ALA','ARG','ASN','ASP','CYS',
     1  'GLN','GLU','GLY','HIS','ILE',
     2  'LEU','LYS','MET','PHE','PRO',
     3  'SER','THR','TRP','TYR','VAL','UNK'/

c Get filenames and open files

        data prompt /
     &  'Name of the .srf file? ','Name for output file? ' /

        lunit=1
c       call askfil(lunit,fname,'old',prompt(lunit))
        open(unit=lunit,file='prot.srf',status='old')

        write(6,45)
        read(5,*)strta

        write(6,50)
        read(5,*)enda

        lunit=2
c       call askfil(lunit,fname,'unk',prompt(lunit))
        open(unit=lunit,file='intch.os',status='unknown')

c Initialize arrays

        do i=1,50
          respv(i)=0.0
        end do
        do i=1,maxres
          pupv(i)=0.0
        end do
        do i=1,50
          resos(i)=0.0
        end do
        do i=1,maxres
          totos(i)=0.0
        end do

c Formats
45      format('     What is the first residue of chain? ---->',$)
50      format('     What is the last residue of chain? ----->',$)
100     format(a80)           !for reading each line
102     format(4x,a3,1x,i4)          !for reading first residue
104     format(4x,a3,1x,i4,9x,i4)          !for reading first residue
108     format(4x,'Resnum',2x,'Resname',7x,'OS',5x,'os*[1-raylen]')
110     format(5x,i4,5x,a3,5x,f7.2,5x,f7.2)     !writing output
112     format(5x,i4,'      ?         0.0         0.0')

c Start main program

        i=0

c Get number of first residue for later register
c Have to find first INF line

200     continue
        read(1,100,end=909)line       !When EOF exit do loop
        if(line(1:3) .eq. 'INF')then     !want this record
        backspace (unit = 1)
           read(1,102)thisres,frstres
           i=frstres                       !make i=resnum (integer)
           backspace (unit = 1)  !want to re-read below in loop
        else
          goto 200
        end if

c Now start main loop

        do while (.true.)
201        continue

c Must always find INF line

          read(1,100,end=909)line       !When EOF exit do loop
          if(line(1:3) .eq. 'INF')then     !want this record
          backspace (unit = 1)
          read(1,104,end=909)name,thisres,occresnum
           if (thisres .eq. i) then	!still same residue?
             if ((thisres .ge. strta) .and. (thisres .le. enda)) then
				!within chain of concern
               if ((occresnum .lt. strta).or.(occresnum .gt. enda)) then
				!occluding atom
                 resnam(i) = name
                 backspace (unit = 1) !Dumb but then can use rescalc
                 call  rescalc(i,respv,resos)
                 totos(i)=totos(i)+resos(i)
                 pupv(i)=pupv(i)+respv(i)   !Sum packing unit packing value
                 goto 201
               end if
             else if (thisres .gt. enda) then	!Now in chain B
               if (occresnum .le. enda) then	!occluding atom?
                 resnam(i) = name
                 backspace (unit = 1) !Dumb but then can use rescalc
                 call  rescalc(i,respv,resos)
                 totos(i)=totos(i)+resos(i)
                 pupv(i)=pupv(i)+respv(i)   !Sum packing unit packing value
                 goto 201
               end if
             end if
           else 
              backspace (unit = 1)	!Must be into next residue
              i=i+1                       !increase residue counter
           end if   
          else
             goto 201
          end if
        end do
909     continue	!Here at EOF for .inf file

c Write out packing to file, "prot.pak"
        write(2,108)
        do k=frstres,(i)
            dummy = 0
          do j=1,21           !determine if residue has os
            if(resnam(k).eq.aa(j))then
              write(2,110)k,resnam(k),totos(k),pupv(k)
              dummy = 1
            end if
          end do
            if (dummy .eq. 0) then  !Residue had no os and
c                                   !we don't know its name
c                                   !because had no INF line
              write(2,112)k
            end if
        end do

        end             !End of main program

c*************************************************************
c
        subroutine askfil (lunit, fname, age, prompt)
c
c*************************************************************

c Argument declarations
        integer lunit
        character*3 age         !either "old" or "new"
        character*40 fname
        character*(*) prompt

        write(6,100) prompt     !Ask for file name
        read(5,200) fname

        if (age .eq. 'old') then
          open(unit=lunit,file=fname,status='old')
        else if (age .eq. 'new') then
          open(unit=lunit,file=fname,status='new')
        else if (age .eq. 'unk') then
          open(unit=lunit,file=fname,status='unknown')
        end if

100     format(5x,a,'---->',$)
200     format(a40)

        return
        end

c************************************************************
c
        subroutine rescalc(i,respv,resos)
c
c Calculates residue packing value (respv) for a residue
c************************************************************

c Argument Declarations
        real respv(50)          !Residue Packing Value
        real resos(50)		!Residue OS
        integer i

c Local Declarations
        real os,raylen          !occ surf and raylength

        read(1,110)os,raylen
110     format(21x,4x,18x,f5.3,7x,f5.3)
c       print*, os, raylen

c If raylen is greater than 1.0 make it 1.0
        if (raylen .gt. 1.0) then
          raylen = 1.0
        end if

c Calculate residue packing value
        resos(i)=os
        respv(i)=(os*(1-raylen))
c       print*, respv(i)
c       print*, ' '


        return
        end


