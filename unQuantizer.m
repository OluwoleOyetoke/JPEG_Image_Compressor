function [ unQuantizedOutput ] = unQuantizer( inputMatrix, quantizationType, Pair )
%unQuantizer Used to Unquantize the Matrix

%Check to ensure that two arguments are passed to the function
if nargin ~= 3
  error('unQuantizer:Invalid_No_Of_Arguments_Passed','This function works with 2 arguments -DCTCoeff, quantizationType & Quantization table Pair-.')
end

%Check to ensure that quantizationType is a 0 or a 1
if ((quantizationType~=1) && (quantizationType~=0))
  error('unQuantizer:Invalid_Quantization_Table_Selection','1 = Chrominance Quantization, 0 = Luminance Quantization')
end

%Check to ensure that quantization Table Pair Selected is Available is 1 or
%2
if ((Pair~=1) && (Pair~=2) && (Pair~=3)&& (Pair~=4))
  error('quantizer:Invalid_Quantization_Table_Selection','1, 2, 3 or 4 for Quantization Table Pair 1, 2, 3 or 4')
end

%Quantization table Pair 1
%quantizationType 0
luminanceQuantizationTablePair1 = [
1 1 1 1 1 1 1 2;
1 1 1 1 1 1 1 2;
1 1	1 1	1 1	2 2;
1 1	1 1	1 2	2 3;
1 1	1 1	2 2	3 3;
1 1	1 2	2 3	3 3;
1 1	2 2	3 3	3 3;
2 2	2 3	3 3	3 3];


chrominanceQuantizationTablePair1 = [
1 1 1 2 3 3 3 3;
1 1	1 2	3 3	3 3;
1 1 2 3 3 3 3 3;
2 2 3 3	3 3	3 3;
3 3	3 3	3 3 3 3;
3 3 3 3 3 3 3 3;
3 3	3 3 3 3	3 3;
3 3 3 3 3 3 3 3];

%Quantization Table  Pair 2
luminanceQuantizationTablePair2=[
    16  11  10  16  24  40  51  61;
    12  12  14  19  26  58  60  55;
    14  13  16  24  40  57  69  56;
    14  17  22  29  51  87  80  62;
    18  22  37  56  68  109 103 77;
    24  35  55  64  81  104 113 92;
    49  64  78  87  103 121 120 101;
    72  92  95  98  112 100 103 99];

%quantizationType 1
chrominanceQuantizationTablePair2 = [
17 18 24 47	99 99 99 99;
18 21 26 66	99 99 99 99;
24 26 56 99	99 99 99 99;
47 66 99 99	99 99 99 99;
99 99 99 99	99 99 99 99;
99 99 99 99	99 99 99 99;
99 99 99 99	99 99 99 99;
99 99 99 99	99 99 99 99];

%Pair 3
%Should produce produce a compression ratio of 1
chrominanceQuantizationTablePair3= ones(8);
luminanceQuantizationTablePair3 = ones(8);

%Pair4
%quantizationType 0
luminanceQuantizationTablePair4 = [32 33 51	81 66 39 34	17;
33 36 48 47	28 23 12 12;
51 48 47 28	23 12 12 12;
81 47 28 23	12 12 12 12;
66 28 23 12	12 12 12 12;
39 23 12 12	12 12 12 12;
34 12 12 12	12 12 12 12;
17 12 12 12	12 12 12 12];

chrominanceQuantizationTablePair4 = [
34 51 52 34	20 20 17 17;
51 38 24 14	14 12 12 12;
52 24 14 14	12 12 12 12;
34 14 14 12	12 12 12 12;
20 14 12 12	12 12 12 12;
20 12 12 12	12 12 12 12;
17 12 12 12	12 12 12 12;
17 12 12 12	12 12 12 12];


%Select Quantization table Pair to Use

if(Pair==1)
    switch(quantizationType)
        case 0 
         quantizationTable = luminanceQuantizationTablePair1; 
        case 1
          quantizationTable = chrominanceQuantizationTablePair1;
    end

elseif (Pair==2)
  switch(quantizationType)
        case 0 
         quantizationTable = luminanceQuantizationTablePair2; 
        case 1
          quantizationTable = chrominanceQuantizationTablePair2;
  end
  
elseif (Pair==3)
   switch(quantizationType)
        case 0 
         quantizationTable = luminanceQuantizationTablePair3; 
        case 1
          quantizationTable = chrominanceQuantizationTablePair3;
   end
    
   elseif (Pair==4)
   switch(quantizationType)
        case 0 
         quantizationTable = luminanceQuantizationTablePair4; 
        case 1
          quantizationTable = chrominanceQuantizationTablePair4;
   end
end

    %Do the multiplication
unQuantizedOutput = inputMatrix .* quantizationTable;
end

