clc
clear
close all

bit_no =64;
v_high=1.2;
stream=[];
stream = randi([0, 1], 1, bit_no);

    % Define time axis
    t = 0:1:(100*length(stream)-1);
    bit_duration = 1;
    %Apply the manchester line coding :
    encoded_signal=manchester(stream,25,v_high)


    % Plot the Manchester encoded signal
    figure;
    plot(t, encoded_signal , 'b', 'LineWidth', 1.5);
    title('Manchester Encoded Signal');
    xlabel('Time (s)');
    ylabel('Signal Amplitude');
    ylim([-1.5, 1.5]); % Set y-axis limit for better visualization
    grid on;
    %applying the unipolar NRZ line coding:
    signal =unrz(stream,t,v_high);

    figure;
% Plot the unipolar NRZ encoded signal
    plot(t, signal, 'b', 'LineWidth', 1.5);
    title('Unipolar NRZ Encoded Signal');
    xlabel('Time (s)');
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
    title('Double-Sided Frequency Spectrum of Unipolar NRZ Signal');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');



manchesterSignal = encoded_signal;
    figure;
    L = length(manchesterSignal);
    Y = fftshift(fft(manchesterSignal))*1/Fs;
    N = L;
    df = Fs/N;
 if(rem(N,2)==0) %% Even
  f = - (0.5*Fs) : df : (0.5*Fs-df) ; %% Frequency vector if x/f is even
else %% Odd
  f = - (0.5*Fs-0.5*df) : df : (0.5*Fs-0.5*df) ; %% Frequency vector if x/f is odd
 end
    plot(f,  abs(Y), 'LineWidth', 1.5);
    title('Double-Sided Frequency Spectrum of Manchester Signal');
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');





% Simulate Noise
snr = 10;  % Signal-to-noise ratio in dB
noisy_manchester = awgn(encoded_signal, snr, 'measured');
noisy_nrz = awgn(signal, snr, 'measured');

% Adiing noise to our signals so we can calculate BER
received_manchester = zeros(1, bit_no);
received_nrz = zeros(1, bit_no);

for i = 1:bit_no
    bit_start = (i - 1) * bit_duration + 1;
    bit_end = i * bit_duration;

    received_manchester(i) = mean(noisy_manchester(bit_start:bit_end)) > 0;
    received_nrz(i) = mean(noisy_nrz(bit_start:bit_end)) > 0.5;
end

%Comparing BER for both mechanisms Because WHY NOT?
ber_manchester = sum(stream ~= received_manchester) / length(stream);
ber_nrz = sum(stream ~= received_nrz) / length(stream);
fprintf('BER for Manchester Encoding: %f\n', ber_manchester);
fprintf('BER for Unipolar NRZ Encoding: %f\n', ber_nrz);
%Comparison plots
figure;
subplot(2,1,1);
plot(t, noisy_manchester, 'r', 'LineWidth', 1.5);
hold on;
plot(t, encoded_signal, 'b', 'LineWidth', 1.5);
title('Manchester Encoded Signal with Noise');
xlabel('Time (s)');
ylabel('Signal Amplitude');
ylim([-1.5, 1.5]);
legend('Noisy', 'Original');
grid on;

subplot(2,1,2);
plot(t, noisy_nrz, 'r', 'LineWidth', 1.5);
hold on;
plot(t, signal, 'b', 'LineWidth', 1.5);
title('Unipolar NRZ Encoded Signal with Noise');
xlabel('Time (s)');
ylabel('Signal Amplitude');
ylim([-0.5, 1.5]);
legend('Noisy', 'Original');
grid on;
