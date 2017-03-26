function [ coefficients ] = myDCT2( inputMatrix );
%myDCT2: Function used to compute the DCT of a 2D image array
%   Function receives the 2D Array and computes the DCT coefficient for 
%   each of the elements of the array

%Begin Operation
%fprintf('\nDCT COMPUTATION STARTED\n\n');

%Check for validity of input
% Make sure an input argument is passed
%fprintf('myDCT input validation in progress...\n');
if nargin ~= 1
  error('myDCT2:Invalid_No_Of_Arguments_Passed','This function works with 1 arguments -inputMatrix-.')
end

%Begin DCT Operation

%Get size of input matrix
[x y] = size(inputMatrix);
coefficients = zeros(x,y);
%inputMatrix = inputMatrix - 128;

%Although for loops slow down MATLab, we need to use foor loops here
Ci = 0;
Cj =0;
PI = 3.1416;
for loopI = 0:x-1
 if((loopI==0))
        Ci = 1/(sqrt(x));   
      else
        Ci = (sqrt(2/x));  
 end   %end if statement
    for loopJ = 0:y-1
        currentLoopComputation=0;
        if((loopJ==0))
        Cj = 1/(sqrt(y));      
       else
        Cj = (sqrt(2/y)); 
     end   %end if statement
   
     %Internal For loops for x and y
     for loopX = 0:x-1 

   for loopY = 0:y-1
     
   numeratorX = ((2*loopX)+1)*(pi*loopI);
   numeratorY = ((2*loopY)+1)*(pi*loopJ);
   %Sum computation
   currentLoopComputation = currentLoopComputation+ (inputMatrix(loopX+1,loopY+1) *cos( numeratorX/(2*x)) *cos(numeratorY/(2*y)));       
   end 
   
     end
%Based on the formular from : https://uk.mathworks.com/help/images/ref/dct2.html
         coefficients(loopI+1,loopJ+1) =   Ci* Cj* currentLoopComputation;
       
    end
    
end 
end

