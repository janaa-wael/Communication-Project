function [signal]=unrz(stream,t)
%unipolar non return to zero
%@ stream: stream of bits
%@ t: time vector of the linecoding
signal = zeros(1, length(t));
for j = 1:length(stream)
        % If the current bit is 1, set the corresponding time duration to high
        if stream(j) == 1
            signal((j-1)*length(t)/length(stream) + 1 : j*length(t)/length(stream)) = 1;
        end
    end


