bit_no =64;
stream = randi([0, 1], 1, bit_no);
bitrate=1;
fc = 3 ;
duration = 64;
Fs = 100; %sampling frequence
ts = 1/Fs ;
%signal after applying linecoding:
t = linspace(0, duration, duration * Fs);     %time vector
signal = unrz(stream,t);

%%%%%%%%%%%%%% modulation %%%%%%%%%%%%%%%%%%%%%%%%
carrier_signal=cos(2*pi*fc*t);
ASK_signal=signal.*carrier_signal;


%temporal plot of ask modulated stream:
    figure;
    plot(t, ASK_signal, 'b', 'LineWidth', 1.5);
    title('ASK modulated stream');
    xlabel('Time');
    ylabel('Signal Amplitude');
    %ylim([-0.5, 1.5]);
    grid on;

%spectral plots of ask modulated signal:
    figure;
    L = length(ASK_signal);
    Y = fftshift(fft(ASK_signal))*1/Fs;
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

%%%%%%%%%transmission through noisy channel %%%%%%%%%%%%%%%%%%


snr_db = 20; % Signal to noise ratio (dB)
noisePower = 10^(-snr_db / 10);
noise = sqrt(noisePower) * randn(size(ASK_signal));
received_signal = ASK_signal + noise;

%%%%%%%%%%%%%% demodulation %%%%%%%%%%%%%%%%%%%%%%%%
phases =[30,60,90];

for j=1:length(phases)
  local_oscillator=sin(2*pi*t*fc+deg2rad(phases(j)));
  demodulated_signal= received_signal.*local_oscillator;

  %quantising recieved signal :

Vth = 0.5;
region = length(t) /Fs;
receiver_output = zeros(1, region);
for i = 1:region
    regionStart = (i - 1) * 100 + 1;
    regionEnd = i * 100;
    region = demodulated_signal(regionStart:regionEnd);
    if any(region > Vth)
        receiver_output(regionStart:regionEnd) = 1;
    else
        receiver_output(regionStart:regionEnd) = 0;
    endif
endfor

  %temporal plot of ask demodulated stream:
    figure;
    plot(t, receiver_output, 'b', 'LineWidth', 1.5);
    title(sprintf('ASK demodulated stream with oscillator phase %d°',phases(j)));
    xlabel('Time');
    ylabel('Signal Amplitude');
    %ylim([-0.5, 1.5]);
    grid on;

  %spectral plots of ask modulated signal:
    figure;
    L = length(receiver_output);
    Y = fftshift(fft(receiver_output))*1/Fs;
    N = L;
    df = Fs/N;
    if(rem(N,2)==0) %% Even
      f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
    else %% Odd
      f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
    end
      plot(f, abs(Y), 'LineWidth', 1.5);
       title(sprintf('Frequency Spectrum of ASK demodulated stream with oscillator phase %d°',phases(j)));
      xlabel('Frequency (Hz)');
      ylabel('Amplitude');


end
