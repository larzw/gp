#Publication Quality Plots in Gnuplot with Latex Labels

This is a simple Perl script to create

* Publication quality standalone and cropped 2D/3D plots in gnuplot.
* Latex is used for the fonts via the epslatex terminal.

To achieve this I set the gnuplot terminal to epslatex and execute gnuplot commands to get the desired plot. Then, I run pdflatex on the epslatex terminal output and crop the latex document to produce a standalone figure.

##Example

The gp.pl script contains example commands to produce a 2D plot from example data. Run it by inputting the output filename and optionally the font size (default is 35)

```bash
perl gp.pl plot 25
```

this produces plot.pdf

##Dependencies

You should already have most of these if you're using Linux
* TeX Live
* pdfcrop
* ps2pdf
