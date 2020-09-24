#!/usr/bin/env perl
#
#Purpose:
#	This script makes publication quality standalone and cropped 2D/3D plots in gnuplot.
#	Latex is used for the fonts via the epslatex terminal.
#	Simply enter your gnuplot commands between the code block
###############ENTER GNUPLOT COMMANDS HERE#######################################
#
#. . .
#
#	Use single quotes for gnuplot commands so you will not interfere with perl.
#
#. . .
#
#########################END#####################################################
#
#Inputs:
#	1) $filename = Name of output file. Don't include the file type extension; namely, instead of filename.pdf use filename
#	2) $fontsize = Font size (optional input, default is 35)
#
#Output:
#	filename.pdf = A pdf file which contains your plot
#
#To run:
#	$perl gp plot 25
#
#	Alternatively, run it with the default font size of 35
#
#	$perl gp plot
#
#Notes:
#	For 3D plots the following gnuplot commands my be useful to you
#
#set xlabel  'x label' offset 0,-1.5,0
#set ylabel 'y label' offset -0.5,0,0
#set zlabel 'z label' rotate by 90 offset -1,0,0
#
#set ticslevel 0.1
#set border 4095
#set view 61,5
#set hidden3d
#
#splot 'data.dat' lc rgb '#87CEFA' w l
#
#Author:
#	Larz White, University of Idaho, Department of Physics: Nuclear Theory Group
#
sub gnuplot{

#Define lines for gnuplot. The use of these is optional.
$line1="lc rgb '#8B0000' lt 1 lw 10 smooth cspline";
$line2="lc rgb '#006400' lt 4 lw 10 smooth cspline";
$line3="lc rgb '#00008B' lt 2 lw 10 smooth cspline";
$line4="lc rgb '#FF8C00' lt 5 lw 10 smooth cspline";
$line5="lc rgb '#FF1493' lt 8 lw 10 smooth cspline";
$line6="lc rgb '#8B008B' lt 7 lw 10 smooth cspline";
$line7="lc rgb '#B8860B' lt 1 lw 10 smooth cspline";
$line8="lc rgb '#000000' lt 1 lw 10 smooth cspline";
$line9="lc rgb '#A9A9A9' lt 1 lw 10 smooth cspline";

#Define error bars for gnuplot. The use of these is optional.
$errbar1="lc rgb '#8B0000' lt 1 lw 3 pt 7";
$errbar2="lc rgb '#006400' lt 1 lw 3 pt 5";
$errbar3="lc rgb '#00008B' lt 1 lw 3 pt 1";
$errbar4="lc rgb '#FF8C00' lt 1 lw 3 pt 2";

#Open pipe to gnuplot
open(gnuplot,"|gnuplot");
print gnuplot<<ENDGNUPLOT;
set terminal epslatex newstyle color rounded dashed lw 2 dl 10 font ",$_[0]" size 10,7
set format "\$\%g\$"
set output "GnuplotLaTeX_fileWill_BeRemoved.tex"
###############ENTER GNUPLOT COMMANDS HERE#######################################
#set xzeroaxis
#set yzeroaxis

#set label 'Arbitrary text' at 3,3
#set arrow from 0,0 to -1,1

#set xrange [45:51]
#set yrange [0:7000]

#Spacing between tick marks and their lenght/scale i.e. set xtics 15 scale 3
set xtics scale 3
set ytics scale 3

set nokey
#set key box
#set key left top #Or set key at 1,1
#set key samplen 6 #Length of line to show in key box

#set pointsize 2

#set title 'Plot title'
set xlabel '\$x_1\$'
set ylabel '\$\\alpha\$ [MeV]'

plot 'data/data1.dat' $line1,'data/data2.dat' $line2,'data/data3.dat' $line3,'data/data4.dat' $line4,'data/data5.dat' $line5,'data/data6.dat' $line6,'data/data7.dat' $line7,'data/data8.dat' $line8,'data/data9.dat' $line9
#########################END#####################################################
ENDGNUPLOT
close(gnuplot);
}

$filename=$ARGV[0]; #Name of output file.
$fontsize=$ARGV[1]; #Font size (optional).

#Define color for error message.
$red="\e[1;31m";
$normal="\e[0m\n";

#Make sure you passed a filename to $ARGV[0]
if(!defined $ARGV[0]){
die "$red Need to include file name for plot at run time.$normal";
}

#If fontsize is not specified then the default fontsize is 35
if(!defined $ARGV[1]){
$fontsize=35;
}

gnuplot($fontsize); #Run the gnuplot script

system("ps2pdf -dEPSCrop GnuplotLaTeX_fileWill_BeRemoved.eps GnuplotLaTeX_fileWill_BeRemoved.pdf"); #Convert .eps file to .pdf

#Create latex document
open(latex,">LaTeX_fileWill_BeRemoved.tex");
$latex=<<ENDLATEX;
\\documentclass{article}
\\usepackage{mathtools,graphicx,nopageno,anyfontsize}
\\usepackage[paperwidth=50in,paperheight=50in]{geometry}
\\begin{document}
\\fontsize{$fontsize}{1}\\selectfont
\\input{GnuplotLaTeX_fileWill_BeRemoved.tex}
\\end{document}
ENDLATEX
print latex $latex;
close(latex);

system("pdflatex LaTeX_fileWill_BeRemoved.tex>/dev/null 2>&1"); #pdflatex the .tex document

system("pdfcrop --margins 10 LaTeX_fileWill_BeRemoved.pdf $filename.pdf>/dev/null 2>&1"); #Crop the latex document.

#Clean up
system("rm GnuplotLaTeX_fileWill_BeRemoved.tex");
system("rm GnuplotLaTeX_fileWill_BeRemoved.eps");
system("rm GnuplotLaTeX_fileWill_BeRemoved.pdf");
system("rm LaTeX_fileWill_BeRemoved.tex");
system("rm LaTeX_fileWill_BeRemoved.pdf");
system("rm LaTeX_fileWill_BeRemoved.log");
system("rm LaTeX_fileWill_BeRemoved.aux");
