
% conv encoder trial 1
clc;
clear;

fid = fopen("encoding.txt",'r');
message = fscanf(fid,'%c');
fclose(fid);

input = message;



final_output = [];
state = 'S0';   % initial state 

% Looping across the input
for i=1:length(input)
    % get Next State function takes the current state and the input .
    % return the next state and the output  (function is implemented below)
    [Next out]=getNextState(state,input(i));
    state = Next;
    final_output = [final_output out];
    % concatenating the output

end


% Just converting the data type from str to num to be able to apply SNR to
% the numeric values
num_output = [];
for i=1:length(final_output)
    num_output = [num_output str2num(final_output(i))];
end


% THIS IS JUST FOR ONE SNR VALUE (NOT USED) 
noisy_output = awgn(num_output,20);
% 5 ,11, 20


% Here is adding different SNR values to the same signal
SNR = 1:1:16; % SNR from 1 to 16

noisy_matrix = []; % this matrix stores the same signal but each row is the signal with different SNR
for k=1:length(SNR)
    noisy_matrix = [noisy_matrix; awgn(num_output,SNR(k))];
    
end


% fid = fopen('ConvEnco_output.txt','w');
% fprintf(fid,'%s',noisy_matrix,',');
% fclose(fid);


%converting values to binary 


%compare(sent_output,num_output)


% Writing the matrix to a file. This is the transmitted signal
writematrix(noisy_matrix,'ConvEnco_output.txt');







% THis function is essential in Encoding and Decoding
% Takes current state and input (0,1) 
% returns the next state and the output 
% It follows a state diagram similar to what in the lecture but we modified
% the output to be 3 bits instead of 2
function [next_state,output] =getNextState(curr_state,input)
    switch curr_state
        case 'S0'
            if input == '0'
                next_state = 'S0';
                output = '000';
            else 
                next_state = 'S1';
                output = '111';
            end
        case 'S1'
            if input == '0'
                next_state = 'S2';
                output = '001';
            else 
                next_state = 'S3';
                output = '110';
            end    
        case 'S2'
            if input == '0'
                next_state = 'S0';
                output = '011';
            else 
                next_state = 'S1';
                output = '100';
            end 
        case 'S3'
            if input == '0'
                next_state = 'S2';
                output = '010';
            else 
                next_state = 'S3';
                output = '101';
            end        
    end
end



% THis function returns the number of differences between two binary inputs
% will be used in decoder
function diff=compare(bin1,bin2)
    diff = 0;
    if length(bin1) ~= length(bin2)
        disp("invalid length ")
    end
    for i=1:length(bin1)
        if (bin1(i))~= bin2(i)
            diff = diff +1;
        end
    end    

end


