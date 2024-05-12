bit_no =64;
stream = randi([0, 1], 1, bit_no);

    % Define time axis
    t = 0:1:(100*length(stream)-1);
    bit_duration = 1;
    %Apply the manchester line coding :
    encoded_signal=manchester(stream,25)


    % Plot the Manchester encoded signal
    figure;
    plot(t, encoded_signal , 'b', 'LineWidth', 1.5);
    title('Manchester Encoded Signal');
    xlabel('Time');
    ylabel('Signal Amplitude');
    ylim([-1.5, 1.5]); % Set y-axis limit for better visualization
    grid on;
    %applying the unipolar NRZ line coding:
    signal =unrz(stream,t)

    figure;
% Plot the unipolar NRZ encoded signal
    plot(t, signal, 'b', 'LineWidth', 1.5);
    title('Unipolar NRZ Encoded Signal');
    xlabel('Time');
    ylabel('Signal Amplitude');
    ylim([-0.5, 1.5]); % Set y-axis limit for better visualization
    grid on;
%%%% spectral plots: %%%%%
    Fs = 100;%sampling frequence

    uniPolarSignal = signal;
    figure;
    L = length(uniPolarSignal);
    Y = fftshift(fft(uniPolarSignal))*1/Fs;
    N = L;
    df = Fs/N;
 if(rem(N,2)==0) %% Even
  f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
else %% Odd
  f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
 end
    plot(f, abs(Y), 'LineWidth', 1.5);
    title('Single-Sided Amplitude Spectrum of Unipolar NRZ Signal');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');



manchesterSignal = encoded_signal;
    figure;
    L = length(manchesterSignal);
    Y = fftshift(fft(manchesterSignal))*1/Fs;
    N = L
    df = Fs/N;
 if(rem(N,2)==0) %% Even
  f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
else %% Odd
  f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
 end
    plot(f,  abs(Y), 'LineWidth', 1.5);
    title('Single-Sided Amplitude Spectrum of Manchester Signal');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');
