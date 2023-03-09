from pymol import cmd
from pymol.cgo import *
import string
import math

print 'Enter "dots" to display Occulded Surface dots'

cmd.alter('name H','vdw=1.25 ')
cmd.alter('name HZ1','vdw=1.20')
cmd.alter('name HZ2','vdw=1.20')
cmd.alter('name HZ3','vdw=1.20')
cmd.alter('name HN','vdw=1.20')
cmd.alter('name C','vdw=1.90')
cmd.alter('name CA','vdw=1.90')
cmd.alter('name CB','vdw=1.90')
cmd.alter('name CG','vdw=1.90')
cmd.alter('name CD','vdw=1.90')
cmd.alter('name CE','vdw=1.90')
cmd.alter('name CG1','vdw=1.90')
cmd.alter('name CG2','vdw=1.90')
cmd.alter('name CDT','vdw=1.90')
cmd.alter('name CD1','vdw=1.90')
cmd.alter('name CD2','vdw=1.90')
cmd.alter('name CE1','vdw=1.90')
cmd.alter('name CE2','vdw=1.90')
cmd.alter('name O','vdw=1.70')
cmd.alter('name OD1','vdw=1.70')
cmd.alter('name OD2','vdw=1.70')
cmd.alter('name OE1','vdw=1.70')
cmd.alter('name OE2','vdw=1.70')
cmd.alter('name OG','vdw=1.77')
cmd.alter('name OG1','vdw=1.77')
cmd.alter('name OH','vdw=1.77')
cmd.alter('name OT1','vdw=1.70')
cmd.alter('name OT2','vdw=1.70')
cmd.alter('name OH2','vdw=1.77')
cmd.alter('name N','vdw=1.85')
cmd.alter('name ND1','vdw=1.85')
cmd.alter('name ND2','vdw=1.85')
cmd.alter('name NE1','vdw=1.85')
cmd.alter('name NE','vdw=1.85')
cmd.alter('name NE2','vdw=1.85')
cmd.alter('name NH1','vdw=1.85')
cmd.alter('name NH2','vdw=1.85')
cmd.alter('name NL','vdw=1.85')
cmd.alter('name NR','vdw=1.85')
cmd.alter('name NT','vdw=1.85')
cmd.alter('name NZ','vdw=1.85')
cmd.alter('name NZT','vdw=1.85')
cmd.alter('name S','vdw=2.00')
cmd.alter('name SG','vdw=2.00')
cmd.alter('name SD','vdw=2.00')
cmd.alter('name OW','vdw=1.85')
cmd.alter('name H1','vdw=1.00')
cmd.alter('name H2','vdw=1.00')
cmd.alter('name H1','vdw=1.00')
cmd.alter('name H2','vdw=1.00')
cmd.alter('name ZN','vdw=1.35')
cmd.alter('name FE','vdw=0.64')
cmd.rebuild('all', 'spheres')

obj = []
def dots_visualize(selection='all',name=''):
    col_r = 0.00
    col_g = 0.60
    col_b = 0.20
    radius = 0.2

    infile="raydist.lst"
    lines = open(infile, 'r').readlines()
    for line in lines:
        items = line.strip().split()        
        x1 = float(items[3]); y1 = float(items[4]); z1 = float(items[5])
#       x2 = x1 + (2.8 * float(items[6]) * float(items[8]))
#       y2 = y1 + (2.8 * float(items[6]) * float(items[9]))
#       z2 = z1 + (2.8 * float(items[6]) * float(items[10]))
        x2 = x1 + (0.05 * float(items[8]))
        y2 = y1 + (0.05 * float(items[9]))
        z2 = z1 + (0.05 * float(items[10]))
        obj.extend([ CYLINDER,x1,y1,z1,x2,y2,z2,radius,col_r,col_g,col_b,col_r,col_g,col_b ])
    cmd.load_cgo(obj,'dots_visualize')


cmd.extend("dots",dots_visualize)

#f __name__ == "__main__":
#   dots_visualize()
