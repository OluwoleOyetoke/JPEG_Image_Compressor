function [ savings ] = compressionRatioGen( quantizedMatrix )
%compressionRatioGen Gets the number of zero elements in the matrix

% Make sure an input argument is passed
if nargin ~= 1
  error('compressionRatioGen:Invalid_No_Of_Arguments_Passed','This function works with 1 arguments -quantizedMatrix-')
end

[x y]  = size(quantizedMatrix);

%Scan through Array and pick out the number of zeros in it
idx=quantizedMatrix==0;
zersoNo=sum(idx(:));

%Calculate savings
savings = zersoNo;
savings
end

