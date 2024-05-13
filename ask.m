bit_no =64;
stream = randi([0, 1], 1, bit_no);
bitrate=1;

%signal after applying linecoding:
t = 0:0.01:(10*length(stream)-1);
signal = unrz(stream,t);

fc=10
c=sin(2*pi*fc*t);

m=signal.*c;
figure;
plot(t,signal)
figure ;
plot(t,c)
%%%%%%%%%%%%%% modulation %%%%%%%%%%%%%%%%%%%%%%%%

%temporal plot of ask modulated stream:
    figure;
    plot(t, m, 'b', 'LineWidth', 1.5);
    title('ASK modulated stream');
    xlabel('Time');
    ylabel('Signal Amplitude');
    %ylim([-0.5, 1.5]);
    grid on;

%spectral plots of ask modulated signal:
    Fs = 100;%sampling frequence
    figure;
    L = length(m);
    Y = fftshift(fft(m))*1/Fs;
    N = L;
    df = Fs/N;
    if(rem(N,2)==0) %% Even
      f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
    else %% Odd
      f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
    end
      plot(f, abs(Y), 'LineWidth', 1.5);
      title('Frequency Spectrum of ASK modulated stream');
      xlabel('Frequency (Hz)');
      ylabel('Amplitude');

%%%%%%%%%%%%%% demodulation %%%%%%%%%%%%%%%%%%%%%%%%
phases =[30,60,90];

for i=1:length(phases)
  local_oscillator=sin(2*pi*t*fc+deg2rad(phases(i)));
  demod_signal= m.*local_oscillator;
  %temporal plot of ask demodulated stream:
    figure;
    plot(t, demod_signal, 'b', 'LineWidth', 1.5);
    title(sprintf('ASK demodulated stream with oscillator phase %d',phases(i)));
    xlabel('Time');
    ylabel('Signal Amplitude');
    %ylim([-0.5, 1.5]);
    grid on;

  %spectral plots of ask modulated signal:
    figure;
    L = length(m);
    Y = fftshift(fft(m))*1/Fs;
    N = L;
    df = Fs/N;
    if(rem(N,2)==0) %% Even
      f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
    else %% Odd
      f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
    end
      plot(f, abs(Y), 'LineWidth', 1.5);
       title(sprintf('Frequency Spectrum of ASK demodulated stream with oscillator phase %d',phases(i)));
      xlabel('Frequency (Hz)');
      ylabel('Amplitude');


end
