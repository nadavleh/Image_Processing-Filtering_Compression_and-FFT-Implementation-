%% Section 1

%% A: Create Circle and Octagon matrices, without using loops.

% Build the grid and the desired shapes
[r, c] = meshgrid(1:110,1:110);
Circle = double( ((((r - 55.5).^2 + (c - 55.5).^2).^0.5) < 45));
Octagon = double( ((( ((r>=11)&( r<=40 )) & ((52-r<=c )&(c<=59+r)) ) |...
    (((r>=41)&(r<=70)) &( (c>=11)&(c<=100) )    )) | ((( r>=71 ) &...
    ( r<=100 )) & (( r-59<=c ) & ( c<=170-r )))));

% Show the images.
figure(1);
imagesc(Circle);
title('Circle');
colormap gray
figure(2);
imagesc(Octagon);
title('Octagon');
colormap gray

%% B: Activates given filters.

% the filters
Fc = [1 -1 ; 1 -1];
Fr = [1 1 ; -1 -1];

% activates both filters on both shapes.
CircleFc = abs(conv2(Circle,Fc,'valid'));
CircleFr = abs(conv2(Circle,Fr,'valid'));
OctagonFc = abs(conv2(Octagon,Fc,'valid'));
OctagonFr = abs(conv2(Octagon,Fr,'valid'));

% Shows the images.
figure(3);
subplot(1,2,1);
imagesc(CircleFc);
axis square
title('Circle: Filter Fc');
colormap gray
subplot(1,2,2);
imagesc(CircleFr);
axis square
title('Circle: Filter Fr');
colormap gray
figure(4);
subplot(1,2,1);
imagesc(OctagonFc);
axis square
title('Octagon: Filter Fc');
colormap gray
subplot(1,2,2);
imagesc(OctagonFr);
axis square
title('Octagon: Filter Fr');
colormap gray

%% C: Combine the images in order to highlight the contours.
FixCircle = max(CircleFc,CircleFr);
FixOctagon = max(OctagonFc,OctagonFr);

figure(5);
imagesc(FixCircle);
title('Circle''s Outlines');
colormap gray
figure(6);
imagesc(FixOctagon);
title('Octagon''s Outlines');
colormap gray

%% D: Kirsch compass kernel

% g{1}-g{8} are the Kirsch compass Kernel filters.
g{1} = [ 5 5 5 ; -3 0 -3; -3 -3 -3];
g{2} = [ -3 5 5 ; -3 0 5; -3 -3 -3];
g{3} = [ -3 -3 5 ; -3 0 5; -3 -3 5];
g{4} = [ -3 -3 -3 ; -3 0 5; -3 5 5];
g{5} = [ -3 -3 -3 ; -3 0 -3; 5 5 5];
g{6} = [ -3 -3 -3 ; 5 0 -3; 5 5 -3];
g{7} = [ 5 -3 -3 ; 5 0 -3; 5 -3 -3];
g{8} = [ 5 5 -3 ; 5 0 -3; -3 -3 -3];

% Activates the filters on both images and plots all the results
for ii = 1:8
    if ii < 5
        jj = ii;
    else
        jj = ii+1;
    end
    
    CircleKir{ii} = abs(conv2(Circle,g{ii},'valid'));
    figure(7);
    subplot(3,3,jj);
    imagesc(CircleKir{ii});
    colormap gray
    
    OctagonKir{ii} = abs(conv2(Octagon,g{ii},'valid'));
    figure(8);
    subplot(3,3,jj);
    imagesc(OctagonKir{ii});
    colormap gray    
end

% Combines the results of each shape in order to highlight the contours.
FixCircleKir = CircleKir{1};
FixOctagonKir = OctagonKir{1};
for ii = 2:8
    FixCircleKir = max(CircleKir{ii},FixCircleKir);
    FixOctagonKir = max(OctagonKir{ii},FixOctagonKir);
end

figure(9);
imagesc(FixCircleKir);
title('Circle''s Outlines - Kirsh Filter');
colormap gray
figure(10);
imagesc(FixOctagonKir);
title('Octagon''s Outlines - Kirsh Filter');
colormap gray

%% E: FFT Filter (High Pass Filter)
% We gave 2 options for this filter requirement. Option A is a square 
% around the center, after activating fftshift(fft2(Image)). the result is
% low frequency landings (increase High frequecy) as requested.
% Option B is a 2-dimensional gaussian filter around the center. We used 
% the fact in most images, most of the information is in the low
% frequencies. Because of that we used a threshold value which depends on
% the average value of shape's fft matrix.

% Option A: Simple Square.

a = 21;
FFTFilter = ones(110);
FFTFilter(55-a:55+a,55-a:55+a) = 0;
CircleFFT = ifftshift(fftshift(fft2(Circle)).*FFTFilter);
OctagonFFT = ifftshift(fftshift(fft2(Octagon)).*FFTFilter);

figure(11)
imagesc(real(ifft2(CircleFFT)));
title('Circle''s Outlines - FFT Filter A');
colormap gray

figure(12)
imagesc(real(ifft2(OctagonFFT)));
title('Octagon''s Outlines - FFT Filter A');
colormap gray


% Option B: 

Threshold = 4.5;
Var = 35^2;
FFTFilter = exp((((r-55.5).^2+(c-55.5).^2))/(2*Var));

figure(13)
CircleShift = fftshift(fft2(Circle));
CircleFFT = ifftshift(CircleShift.*(abs(CircleShift)<(Threshold*mean(abs(CircleShift(:))))).*FFTFilter);
imagesc(abs(ifft2(CircleFFT)))
title('Circle''s Outlines - FFT Filter B')
colormap gray

figure(14)
OctagonShift = fftshift(fft2(Octagon));
OctagonFFT = ifftshift(OctagonShift.*(abs(OctagonShift)<(Threshold*mean(abs(OctagonShift(:))))).*FFTFilter);
imagesc(abs(ifft2(OctagonFFT)))
title('Octagon''s Outlines - FFT Filter B')
colormap gray
