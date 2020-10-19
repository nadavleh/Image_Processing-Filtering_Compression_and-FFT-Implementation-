%% Section 3
% This is a test script that shows the differences between the images
% for different compression ratio (c) and block number (nb) inputs to the
% compression functions (Adaptive & Non-Adaptive). Note that the
% Non-Adaptive compress function works for any input but it more efficient 
% for diadic number of blocks (nb), but the Adaptive copress function works
% only for diadic number of blocks (nb=2^x).

load wbarb

% Input Arguments:
nb = 32;    % number of blocks
c = 4;       % compression ratio

% Compress in both methods.
FcNA = BFCNA(X,nb,c);       % Non-Adaptive
[FcA, Ind] = BFCA(X,nb,c);  % Adaptive

% It is possiable to see that the memory size of FcNA and (FcA + Ind) is
% equal to Bytes(X)/c.
whos FcNA FcA Ind X

SizeX = whos('X');
SizeFcA = whos('FcA');
SizeInd = whos('Ind');
SizeFcNA = whos('FcNA');

% Reconstruct both compressed images.
NewImA = ReBFCA(FcA,Ind,nb,size(X,1),size(X,2));
NewImNA = ReBFCNA(FcNA,nb,size(X,1),size(X,2),c);

% Activets the blocks lines cleaner.
ClearImA = CompressClear(NewImA,nb);
ClearImNA = CompressClear(NewImNA,nb);

figure(1)
subplot(1,3,1)
imagesc(X)
title({'Original Image';['Size = ', num2str(SizeX.bytes), ' Bytes']})
axis square
subplot(1,3,2)
imagesc(ClearImNA)
title({'Non-Aaptive Compressed Image';['Size(FcNA) = ', num2str(SizeFcNA.bytes), ' Bytes']})
axis square
subplot(1,3,3)
imagesc(ClearImA)
title({'Adaptive Compressed Image';['Size(FcA + Ind) = ', ...
    num2str(SizeFcA.bytes + SizeInd.bytes), ' Bytes']})
axis square
colormap gray

figure(2)
subplot(1,2,1)
imagesc(NewImNA)
title('Non-Adaptive: Before')
axis square
subplot(1,2,2)
imagesc(ClearImNA)
title('Non-Adaptive: After')
axis square
colormap gray

figure(3)
subplot(1,2,1)
imagesc(NewImA)
title('Adaptive: Before')
axis square
subplot(1,2,2)
imagesc(ClearImA)
title('Adaptive: After')
axis square
colormap gray
