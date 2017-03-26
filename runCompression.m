function  []  = runCompression( fileObject, QuantizationPair );
%JPEGCompressor: Used to compress JPEG files

%This function when supplied with a JPEG document compresses it using
%1. Image Block Preparation
%2. Foward DCT
%3. Quantisation
%4. Image Display

%Begin Operation
fprintf('\nFILE COMPRESSION STARTED\n\n');

%Check for validity of input
%Make sure an input argument is passed
fprintf('JPEGCompressor input validation in progress...\n');
if nargin ~= 2
    error('runCompression:Invalid_No_Of_Arguments_Passed','This function works with 2 arguments -fileObject-.')
end

%Make sure input argument is an image object
try
    fileData = imread(fileObject);
catch
    error('runCompression:Invalid_Type_Of_Input','This function works with an image type object input arguments.');
end

%Check if image is a clolur image
[xDim yDim zDim] = size(fileData);

if(zDim>1)
    %Coloured Image
    
    %Convert to YCbCr
    fileData = rgb2ycbcr(fileData);
    
    Luminance = fileData(:,:,1);
    BlueChrominance = fileData(:,:,2);
    RedChrominance = fileData(:,:,3);
    
    %Run Transform Coding on each of its components
    [quantizedLuminance quantizeReversedLuminanceIDCT] =  JPEGCompressor(Luminance, 0, QuantizationPair);
    [quantizedBlueChrominance quantizeReversedBlueChrominanceIDCT] = JPEGCompressor(BlueChrominance, 1, QuantizationPair);
    [quantizedRedChrominance quantizeReversedRedChrominanceIDCT] = JPEGCompressor(RedChrominance, 1, QuantizationPair);
    
    %Combine Result
    recombinedImage = zeros(xDim, yDim, zDim);
    recombinedIDCT = zeros(xDim, yDim, zDim);
    recombinedImage(:,:,1) = quantizedLuminance;
    recombinedImage(:,:,2) = quantizedBlueChrominance;
    recombinedImage(:,:,3) = quantizedRedChrominance;
    
    recombinedIDCT(:,:,1) = quantizeReversedLuminanceIDCT;
    recombinedIDCT(:,:,2) = quantizeReversedBlueChrominanceIDCT;
    recombinedIDCT(:,:,3) = quantizeReversedRedChrominanceIDCT;
    
    
    %Calculate Savings
    NoOfZeros = compressionRatioGen(recombinedImage);
    compressionRatio = ((xDim * yDim*zDim)/((xDim * yDim * zDim)-NoOfZeros));
    percentageSavings = (NoOfZeros*100)/(xDim * yDim * zDim);
    
    
    %shift back (if my input was a uint, then i'd subtract by 128)
    recombinedIDCT =  recombinedIDCT+0.5;
    
    %Convert Image Back to RGB
    fileData = ycbcr2rgb(uint8(recombinedIDCT));
    
    %Get original Image
    originalFileData = imread(fileObject);
    
    %Plot New Result
    %Plot New Result
    subplot(1, 2, 1);
    imshow(originalFileData);
    title('Original Image');
    
    
    subplot(1, 2, 2);
    imshow(fileData);
    plotTitle = sprintf('Compressed Image Plot.\n Compression ratio = %f \n Percent Space Savings = %f',compressionRatio,percentageSavings);
    title(plotTitle);
    
elseif (zDim==1)
    %Black and White Image
    %No need for chrominance quantization, because it is blacka and white
    [quantizedImage, quantizeReversedImageIDCT] =  JPEGCompressor(fileData, 0, QuantizationPair);
    
    
    
    %Calculate Savings % Compression Ratio
    NoOfZeros = compressionRatioGen(quantizedImage);
    compressionRatio = ((xDim * yDim)/((xDim * yDim)-NoOfZeros));
    percentageSavings = (NoOfZeros*100)/(xDim * yDim);
    
    %Get original Image
    originalFileData = imread(fileObject);
    originalFileData = uint8 (originalFileData);
    
    %Plot New Result
    subplot(1, 2, 1);
    imshow(originalFileData);
    title('Original Image');
    
    
    subplot(1, 2, 2);
    % Shift back. if my input was a uint, then i'd subtract by 128
    quantizeReversedImageIDCT = quantizeReversedImageIDCT+0.5;
    imshow(uint8(quantizeReversedImageIDCT));
    plotTitle = sprintf('Compressed Image Plot.\n Compression ratio = %f \n Percent Space Savings = %f',compressionRatio,percentageSavings);
    title(plotTitle);
    
end

end