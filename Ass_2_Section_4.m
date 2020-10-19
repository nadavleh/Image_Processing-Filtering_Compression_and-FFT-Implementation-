%% Section 4

%% A:
% in this section we will compare the runtimes and differnces of the simple
% fuction written to preform DFT to an array sized m by b, to that of
% matlab's (fft() and fft2()). 
% two images of different sizes (the circle and octagon from question 1)
% will be valued at the freequncy domain, aswell as two vectors of different
% sizes, sampled from a sin() and parabolic functions. uncomment the second
% option to activate the octagon and parabolic inputs. runtime and error
% norm will be printed on the screen, aswell as the data from the written
% function using the seperability of the 2D transform (again, uncomment to
% show)

clc; clear;

% 2D array
[r, c] = meshgrid(1:110,1:110);
Im = double( ((((r - 55.5).^2 + (c - 55.5).^2).^0.5) < 45));

% Another Option:
% [r, c] = meshgrid(1:200,1:200);
% Im = double((((((r>=11)&(r<=40))&((52-r<=c)&(c<=59+r))) | ...
% (((r>=41)&(r<=70))&((c>=11)&(c<=100)))) | (((r>=71)&(r<=100))&((r-59<=c)&(c<=170-r)))));


% 1D array
t = 0:99;
x = sin(2*pi*0.01*t);

% Another Option:
% t = 0:1000;
% x = t.^2;

% comparison of DFT functions of matlab (fft and fft2) to the function we
% wrote not using the seperability of the transform:
disp('1D comparison : using matlab''s fft function of x vector  yields runtime of:')
tic
Fx1 = fft(x);
toc

disp('using our DFT function of x vector yields:')
tic
Fx2 = Q4a(x);
toc
disp('the error (L2 norm of difference vector) of our DFT to Matlab''s fft:')
norm(Fx2(:)-Fx1(:))

disp('2D comparison : using matlab''s fft2 function of Im matrix  yields:')
tic
Fx1=fft2(Im);
toc


disp('using our DFT function of Im matrix yields:')
tic
Fx2=Q4a(Im);
toc
disp('the error of our 2D DFT to Matlab''s fft2:')
norm(Fx2(:)-Fx1(:))

% % % % uncomment to show 2D DFT using the seperabilty property

% disp('using our DFT function and seperability property of the transform yields:')
% tic
% Fx2=Q4a(Im, 'sep');
% toc
% 
% disp('the error of our 2D DFT using seperability, to Matlab''s fft2:')
% norm(Fx2(:)-Fx1(:))


%% B:

clc;clear;

% in this section we will compare Ofer Levi's simple radix-2 butterfly
% recursive fft algorithm (only a bit different and shorter syntax wize),
% to that of matlabs. 
for n=1:10
    t=linspace(0,1,2^n);    % diadic time vector of size 2 to 1024
    x=sin(2*pi*t*n);        % the vector to be transformed  
    tic
    Fx1=fft(x);
    t_matlab(n) = toc;
    tic
    Fx2=Q4b_fft(x);
    t_recursive(n) = toc ; 
    norm_diff(n)=norm(Fx1(:)-Fx2(:));
end
Signal_length=(2*ones(1,n)).^(1:n);
figure(1);clf;
plot(Signal_length,t_matlab,'*r',Signal_length,t_recursive,'ob');
xlabel('Input Signal Length')
ylabel('time [s]')
title('runtime of matlab''s fft and Q4b\_fft')
grid on
legend('fft(x)', 'Q4b\_fft(x)')
figure(2);clf;
plot(Signal_length,norm_diff,'ok');
xlabel('Input Signal Length')
ylabel('L2 norn of difference vector')
title('Difference of matlab''s fft to Q4b\_fft')
grid on


%% C:
% in this section we will preform 2d DFT using the seperability properety
% and and the recursive fft algorithm of Q4b_fft(x) used in the previous section.
% again we will write a funcion Q4c_fft2 and use it to do so.
% we will compare once more the runtime and error of matlab's function to
% our's
clc;clear;
% define an arbitray image, lets use the circle from question 1, only now in
% diade size of 128 by 128 and not centered
[r, c] = meshgrid(1:128,1:128);
Im = double( ((((r - 55.5).^2 + (c - 55.5).^2).^0.5) < 45));


% lets comapre matlabs fft2 function's runtime on the diade matrix Im, to
% our resaults thus far
disp('matlabs fft2 runtime: ')
tic
FIm_matlab=fft2(Im);
toc
disp('')

% using seperability of DF transform we can compute the image's fft using
% the recursive 1D fft algorithm written in section b by computing the rows
% fft and then the collumns fft (or vise versa)
disp('our fft2 using seperability property: ')
tic
FIm_fft_sep=Q4c_fft2( Im );
toc
disp('the norm difference between the two outputs: ')
norm(FIm_matlab(:)-FIm_fft_sep(:))

% it will show that matlabs optimized interperter for matrix-vector
% opperations resaults in a better runtime for the DFT using the
% seperability property
disp('our DFT using seperability property: ')
tic
FIm_dft_sep=Q4a( Im,'sep' );
toc
disp('the norm difference between the output and matlab''s fft2 : ')
norm(FIm_matlab(:)-FIm_dft_sep(:))

% the worst runtime of all will be the DFT written in section A
disp('our DFT without using seperability property: ')
tic
FIm_dft=Q4a( Im );
toc
disp('the norm difference between the output and matlab''s fft2 : ')
norm(FIm_matlab(:)-FIm_dft(:))

%%%%%%%%%%%%%%%%%%%%%%%%%~~~2nd comparison~~~%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is a comparison of different diadic size images between matlabs fft2
% to our Q4c_fft2

% define matricis and measure runtime
for n=1:4
   A{n}=zeros(2^n); 
   [j1,j2]=meshgrid(linspace(0,1,2^n),linspace(0,1,2^n));
   A{n} = sin(2*pi*(j1 + j2)) + n*sin(2*pi*n*(j1 + j2))...
       +9*sin(2*pi*5*n*(j1 + j2))+8*sin(2*pi*9*n*(j1 + j2)); 
   tic
   Fx2=Q4c_fft2( A{n} );
   t_sep(n)=toc;    
   tic
   Fx1=fft2( A{n} );
   t_matlab(n)=toc;    
   norm_diff(n)=norm(Fx1(:)-Fx2(:));
end

% plot resaults
matrix_size=((2*ones(1,n)).^(1:n));
figure(1);clf;
plot(matrix_size,t_matlab,'*r',matrix_size,t_sep,'ob');
xlabel('n')
ylabel('time [s]')
title('runtime of matlab''s fft2 and Q4c\_fft2 to input of matrix of size n by n')
grid on
legend('fft2(x)', 'Q4c\_fft2(x)')
figure(2);clf;
plot(matrix_size,norm_diff,'ok');
xlabel('n')
ylabel('L2 norn of difference vector (output matricis are vectorized)')
title('Difference of matlab''s fft2 to Q4c\_fft2 to input of matrix of size n by n')
grid on
