%%%Questions: 1-3 (Aziza)%%%

clc
clear
close all
T=8;              %simulation time
fs=100;           %sampling frequency
ts=1/fs;          %time step
N=ceil(T/ts);     %number of time samples
df=1/T;           %frequency step , df=fs/N

t1=-2:ts:-1-ts;
t2=-1:ts:1-ts;
t3=1:ts:2-ts;
t4=2:ts:6-ts;
t=[t1,t2,t3,t4];           %time vector
x1 = t1 + 2;            %x(t)  ,    -2<t<-1
x2 = ones(size(t2));    %x(t)  ,    -1<t<-1
x3 = 2 - t3;            %x(t)  ,     1<t<2
x4=zeros(size(t4));
x = [x1, x2, x3,x4];       %x(t) , signal in time domain
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
X_FT=fftshift(fft(x))*ts;    % multiplied by ts as the signal is non-periodic
% analytical expression
X_analytical = 3 .* sinc(f) .* sinc(3 * f);
figure 2
plot(f,abs(X_FT),'g',f,abs(X_analytical),'r')
xlabel('frequency');
ylabel('|X(f)|');
title('Fourier Transform of x(t)');
legend('Computed Fourier Transform','Analytical Fourier Transform');


 %%%Questions:4-6(Sarah)%%%
 
% Band width (BW):
P_max = max(abs(X_FT));
threshold = 0.05*P_max;
index = find((abs(X_FT)) > threshold, 1, 'last');
bw = f(index);
 
% LPF with BW=1Hz :
H = zeros(size(f));
H(f>-1.1 & f<1.1)=1;
figure(3)
plot(f,abs(H))
ylim([0, 2])
xlim([-2, 2])
xlabel('f')
ylabel('|H(f)|')

% After LPF:
x_received = (ifft(ifftshift(H.*X_FT)/ts));
figure(4)
plot(t,x_received)
hold on
plot(t,x,'r')
ylim([0, 2])
xlim([-3, 3])
legend('Received message','Transmitted message')
xlabel('t')
ylabel('x(t)')

% LPF with BW=0.3Hz:
%H = abs(f) < 0.3;
H = zeros(size(f));
H(f > -0.6 & f < 0.6) = 1;
figure(5)
plot(f,abs(H))
ylim([0, 2])
xlim([-1, 1])
xlabel('f')
ylabel('|H(f)|')

% After LPF:
x_received = (ifft(ifftshift(H.*X_FT) / ts));
figure(6)
plot(t,x_received)
hold on
plot(t,x,'r')
ylim([0, 2])
xlim([-3, 3])
legend('Received message','Transmitted message')
xlabel('t')
ylabel('x(t)')

%%%Questions:7(Omnia)%%%

fm= 1;     %defining message frequency
t0=-2:ts:0-ts;
t1=0:ts:6-ts;  % generating  time vector from 0 to 6 with ts step

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m1=zeros(size(t0));
m2=cos(2*pi*fm*t1);   % defining the signal in time domain
m=[m1,m2];
figure(7)
plot(t,m);          % plotting the signal in time domain
xlabel('time');        %setting xaxis label
ylabel('m(t)');        %setting yaxis label
title('signal in time domain'); grid on;
xlim([0, 6])

% Fourier transform
M=fftshift(fft(m)) *ts;   %converting signal from time domain into frequency domain using fourier transform and shifting it to be symm. about y axis
figure(8)
plot(f,abs(M));         % plotting the signal in time domain
hold on
xlim([-20,20])
xlabel('freq');         %setting xaxis label
ylabel('M(f)');         %setting xaxis label
grid on;
% analytical expression
M_analytical = 3 * (sinc(6 * (f - 1)) + sinc(6 * (f + 1))) .* exp(-1i * 6 * pi * f);
plot(f,abs(M_analytical),'r');
title('Fourier Transform of m(t)');
legend('Computed Fourier Transform','Analytical Fourier Transform');

 %%%Questions:8-11(Doaa)%%%
BW=3;
fc1=20;
c1= cos(2*pi*fc1*t);
s1 = x_received.*c1;   %% DSB-SC  signal
figure(9)
plot(t,s1)
xlabel('t')
ylabel('s1(t)')
xlim([-2, 2])
title('modulated signal 1 in time domain');
grid on;

s1f = fftshift(fft (s1)) *ts;% dt non-periodic signal %s1 in freq fomain
figure(10)
plot(f,abs(s1f))
xlabel('Frequency (Hz)')
ylabel('|S1(f)|')
title('modulated signal 1 in Frequency domain');


fc2=25.5; %2.5 guard between two modulated signals
c2= cos(2*pi*fc2*t);%Q10
%% SSB-SC  signal
s2t=m.*c2;
s2f= fftshift(fft (s2t)) *ts; %modulated signal 2 before SSB in frequency domain (DSB)
 figure(11)
 plot(f,abs(s2f))
 xlabel('Frequency (Hz)')
ylabel('|S2(f)| before SSB')
title('modulated signal 2 before SSB in Frequency domain');


 %Band Pass filter to pass USB only
 H = zeros(size(f));
  H((f>fc2-0.1) & f<(fc2+BW+0.1))=1 ;   %% +ve frequency
  H((f<-fc2+0.1) & f>-(fc2+BW+0.1))=1;    %% -ve frequency
  figure(12)
  plot(f,H) %% Filter spectrum
  ylim([0, 2])
  xlabel('Frequency (Hz)')
  ylabel('|H(f)|')
  title('BBf');
  box off

 s2f =s2f.*H; %s2f to get SSB modulated signal
  figure(13)
  plot(f,abs(s2f))
 xlabel('Frequency (Hz)')
  ylabel('|S2(f)| after SSB')
  title('modulated signal 2 after SSB in Frequency domain');
  box off

 s2t= real(ifft(ifftshift(s2f) / ts));  %modulated signal 2 after SSB in time domain

  s_tt = s1 + s2t; %Q11
  figure(14)
  plot(t,s_tt);
   xlabel('t')
  ylabel('s_tt')
  title('addition of the two modulated signals  s1+s2t');
  box off
  s_tf=fftshift(fft (s_tt)) *ts;
  figure(15)
  plot(f,abs(s_tf))
 xlabel('Frequency (Hz)')
  ylabel('|s_tf|')
  title('addition of the two modulated signals in frequency domain');
