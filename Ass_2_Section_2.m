%% Section 2

load wbarb

% adds noise to Barbaras image with std=20
Noise = randn(256);
Noise = 20*Noise/std(Noise(:));
NoisyIm = X + Noise;

figure(1);
imagesc(NoisyIm);
title('Noisy Image');
colormap gray


%% A: Regular Average Filter.

figure(2)
for ii = 2:10
    AveFilter{ii-1} = ones(ii)/(ii^2);
    AveFilterIm{ii-1} = conv2(NoisyIm,AveFilter{ii-1},'valid');
    subplot(3,3,ii-1);
    imagesc(AveFilterIm{ii-1});
    title(['Regular Filter Size: ',num2str(ii)]);
end
colormap gray

%% B: Gaussian Filter

figure(3)
for ii = 2:10
    if ~mod(ii,2)
        [r, c] = meshgrid([-ii/2:-1,(1:ii/2)]);
    else
        [r, c] = meshgrid(((-ii+1)/2:(ii-1)/2));
    end
    
    Var = (ii/8)^2;
    H = exp((-(r.^2+c.^2))/(2*Var));
    H = H/(sum(H(:)));
    
    GaussFilter{ii-1} = H;
    GaussFilterIm{ii-1} = conv2(NoisyIm,GaussFilter{ii-1},'valid');
    subplot(3,3,ii-1);
    imagesc(GaussFilterIm{ii-1});
    title(['Gaussian Filter Size: ',num2str(ii)]);
end
colormap gray

%% C: Median Filter

figure(4)
for ii = 2:10
    MedianFilterIm{ii-1} = medfilt2(NoisyIm,[ii,ii]);
    subplot(3,3,ii-1);
    imagesc(MedianFilterIm{ii-1});
    title(['Median Filter Size: ',num2str(ii)]);
end
colormap gray

%% D: Low-Pass Filter - Using FFT2

k = 8.5;

figure(5);
for ii = 1:9
    
    [r, c] = meshgrid(1:256,1:256);
    Circle = double( ((((r - 129).^2 + (c - 129).^2).^0.5) < round(ii*k)));
    FFTFilter = Circle;
    LowPassFFT = ifft2(ifftshift(fftshift(fft2(NoisyIm)).*FFTFilter));
    
    subplot(3,3,ii)
    imagesc(real(LowPassFFT))
    title(['Circle''s Size = ',int2str(round(k*ii))])
    colormap gray
    
end