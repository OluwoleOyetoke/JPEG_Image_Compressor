function  [QuantizedMatrix, quantizedReversedImageMatrixIDCT]  = JPEGCompressor( fileData, Layer, QuantizationPair );
%JPEGCompressor: Used to compress JPEG files

%This function when supplied with a JPEG document compresses it using 
%1. Image Block Preparation 
%2. Foward DCT 
%3. Quantisation 
%4. Entropy Encoding 
%5. Frame Building

%Check for validity of input
% Make sure an input argument is passed
fprintf('JPEGCompressor input validation in progress...\n');
if nargin ~= 3
  error('JPEGCompressor:Invalid_No_Of_Arguments_Passed','This function works with 3 arguments -fileData, LayerNo and Quantization Table Pair.')
%Layer 0 = Luminance
%Layer 1 = Blue Chrominance
%layer 1 = Red Chrominance
end

%Check to make sure the right quantization type is passed
if((Layer~=0) && (Layer ~=1))
      error('JPEGCompressor:Invalid_No_Of_Arguments_Passed','Pleaseinput either Luminance or Chrominance Quantization (Layer 0, Layer 1)')   
end

if ((QuantizationPair~=1) && (QuantizationPair~=2) && (QuantizationPair~=3) && (QuantizationPair~=4))
  error('JPEGCompressor:Invalid_Quantization_Table_Selection','1 = Quantization Table Pair 1 and 2 = Quantization Table Pair 2...')
end

%Appropriate data size by checking file data size, making sure its 
%divisible by 8 and padding with zeros if not
[x y] = size(fileData);
fprintf('\nImage size is %d by %d\n', x, y);
remainderx = 0;
remaindery = 0;
newx=x;
newy=y;
if(mod(x,8)~=0)
    warning('file x-axis (rows) not a factor of 8. Will be padded with zeros (0) for the sake of uniform block size'); 
%%Calculate new x value
remainderx = mod(x,8);
newx = x+(8-remainderx);
end
if(mod(y,8)~=0)
    warning('file y-axis (columns) not a factor of 8. Will be padded with zeros (0) for the sake of uniform block size'); 

    %%Calculate new y value
remaindery = mod(y,8);
newy = y+(8-remaindery);
end

%Create new stable array if previous dimension was not a factor of 8
validatedFileData = double (fileData);
if((newx~=x) || (newy~=y))
    validatedFileData = zeros(newx,newy); 
    validatedFileData(1:x,1:y) = fileData;
end

%define DC coefficient Matrix
%DC Coefficients usually stored separately
DCCoeff = zeros((newx/8), (newy/8));

ImageDCTMatrix = zeros(newx,newy);
quantizedImageMatrix = zeros(newx,newy);
quantizedImageMatrixIDCT = zeros(newx,newy);
quantizedReversedImageMatrixIDCT = zeros(newx,newy);
fullImageIDCT = zeros(newx,newy);

%fprintf('Input validation completed\n');

   %Begin to extract image data into 8 by 8 blocks
   %fprintf('Image Data Extraction Started\n'); 
   %instantiate 8x8 matrix
   block = zeros(8);

   %scan through validatedFileData & get the 8x8 elements of the image file
   columnHopCount = 1;
   rowHopCount = 1;
   for loop =1:((newx/8)*(newy/8))
       a= ((rowHopCount-1)*8)    + 1;
       b= ((rowHopCount-1)*8)    + 8;
       c= ((columnHopCount-1)*8) + 1;
       d= ((columnHopCount-1)*8) + 8;
%fprintf('ROW-%d TO ROW-%d FOR COLUMN-%d TO COLUMN-%d\n',a,b,c,d); 
       
   block = validatedFileData(a:b, c:d);
   %fprintf('BLOCK ROW-%d, Column-%d\n',rowHopCount,columnHopCount);   
   %Centre Matrix Around 0
   % if my input was a uint, then i'd subtract by 128
   block = block-0.5;

   %Call My DCT function for DCT Operation on Block
  %spatialFrequencyCoeff = myDCT2(block);
   spatialFrequencyCoeff = myDCT2(block);
   ImageDCTMatrix(a:b,c:d) = spatialFrequencyCoeff;
   
   %Save DC components of the Co-efficients
   DCCoeff(rowHopCount, columnHopCount) =  spatialFrequencyCoeff(1,1);
   
   %Quantize spatialFrequencyCoeff using Standard Chrominance Quantization table
   %To use the Standard Luminance Table, Change parameter 2 of the quantizer method to
   %'1'

    temp = quantizer(spatialFrequencyCoeff, Layer, QuantizationPair);
%temp = spatialFrequencyCoeff./tst;
    quantizedImageMatrix(a:b,c:d) = temp;
    %Now that the zeros have been eliminated, Multiply back by the
    %quantization table and Perform idct
  
    unQuantizedBlock = unQuantizer(temp, Layer, QuantizationPair);
    quantizedReversedImageMatrixIDCT(a:b,c:d) = double (idct2(unQuantizedBlock));
    
   quantizedImageMatrixIDCT(a:b,c:d) =idct2(temp);
    fullImageIDCT(a:b,c:d) = idct2(spatialFrequencyCoeff);
    
    
   %When end of column is reached
     columnHopCount = columnHopCount+1;
   if((rowHopCount~=newx/8) && (columnHopCount>(newy/8)))
     columnHopCount = 1;  
     rowHopCount = rowHopCount+1;
   end
   if((rowHopCount==newx/8) && (columnHopCount>(newy/8)))
   %When end of row and last column is reached
     break; 
    end
  
    
   end

  QuantizedMatrix =  quantizedImageMatrix;
 % imshow(uint8(quantizedImageMatrixIDCT));
end

