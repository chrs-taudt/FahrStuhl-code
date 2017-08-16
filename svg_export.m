%% simple function to export data from octave to svg files as a polygon
%% just insert coordinate pairs as a matrix 
%% version 0.2 2017-05-12
%% cc-by christopher taudt

%% version .2 adds corel output option
%% version .3 adds two line breaks in the definition of svg
%% version .4 writes coordinates as continous string instead of dlmwrite

%clear all; clf;
%close all;

function [export] = svg_export(coord_pairs, file_name, corel_output)

fid = fopen ( [file_name ".svg"], "w");
%%% the first paragraph writes the header part of the where the file is defined
fdisp (fid, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n <!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n");

%%%this part defines the sheet size of the per we print on
fdisp (fid, "<svg xmlns=\"http://www.w3.org/2000/svg\" xml:space=\"preserve\" width=\"800mm\" height=\"400mm\" style=\"shape-rendering:geometricPrecision; text-rendering:geometricPrecision; image-rendering:optimizeQuality; fill-rule:evenodd; clip-rule:evenodd\"\n viewBox=\"0 0 80000 40000\"\n xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n");
%%%% here we define the stroke parameters of our line (7.62 is hairstroke in corel--> can be changed as needed
fdisp (fid, "<defs>\n  <style type=\"text/css\">\n <![CDATA[\n .str0 {stroke:red;stroke-width:7.62}\n .fil0 {fill:none}\n ]]>\n </style>\n </defs>\n <g id=\"layer_1\">\n");
if corel_output 
fdisp (fid, "<metadata id=\"CorelCorpID_0Corel-Layer\"/>");
endif
%%%% here the actual data is written to the svg file
fprintf (fid, ["<polyline class=\"fil0 str0\" points=\"" coord_pairs "\"/>"]);
%%%end the svg file
fdisp (fid, "\n</g>\n </svg>");
fclose (fid);

endfunction


% this is some test data

%coordinates = [3415,12611; 6767,16068; 7966,13246; 10435,15328; 9271,12153]
%svg_exp(coordinates,"test_export2");