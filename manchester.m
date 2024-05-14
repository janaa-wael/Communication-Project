function [encoded_signal]=manchester(stream,n,v_high)
  %manchester line coding
  %@ stream : row vector containing the stream of bits
  %@ n : half the number of points in line coding that represent a single bit
  encoded_signal=[];
    for i = 1:length(stream)
        % If the current bit is 0
        if stream(i) == 0
            % Append a low-to-high transition followed by a high-to-low transition
        encoded_signal = [encoded_signal, repmat([-1*v_high,-1*v_high], 1, n), repmat([v_high,v_high], 1, n)];
        % If the current bit is 1
        elseif stream(i) == 1
            % Append a high-to-low transition followed by a low-to-high transition
        encoded_signal = [encoded_signal, repmat([v_high,v_high], 1, n), repmat([-1*v_high,-1*v_high], 1, n)];
        end
    end
