clc
clear
close all
T=4;              %simulation time
fs=100;           %sampling frequency
ts=1/fs;          %time step
N=ceil(T/ts);     %number of time samples
df=1/T;           %frequency step , df=fs/N

t1=-2:ts:-1-ts;
t2=-1:ts:1-ts;
t3=1:ts:2-ts;
t=[t1,t2,t3];           %time vector
x1 = t1 + 2;            %x(t)  ,    -2<t<-1
x2 = ones(size(t2));    %x(t)  ,    -1<t<-1
x3 = 2 - t3;            %x(t)  ,     1<t<2
x = [x1, x2, x3];       %x(t) , signal in time domain
plot(t, x);
title('signal in time domain');
xlabel('time');
ylabel('x(t)');
ylim([0, 2])
xlim([-3, 3])

if(rem(N,2)==0)  %even
  f= (-0.5*fs): df: 0.5*fs-df;     %frequency vector if N is even
else      %odd
  f= -(0.5*fs-0.5*df) :df: (0.5*fs-0.5*df);     %frequency vector if N is odd
end
% Fourier transform
X_FT=fftshift(fft(x))*ts;    % multiblied by ts as the signal is non-periodic
% analytical expression
X_analytical = 3 .* sinc(f) .* sinc(3 * f);
figure 2
plot(f,abs(X_FT),'g',f,abs(X_analytical),'r')
xlabel('frequency');
ylabel('|X(f)|');
title('Fourier Transform of x(t)');
legend('Computed Fourier Transform','Analytical Fourier Transform');



