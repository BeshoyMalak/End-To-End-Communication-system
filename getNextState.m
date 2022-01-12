function [next_state,output] =getNextState(curr_state,input)
% THis function is essential in Encoding and Decoding
% Takes current state and input (0,1) 
% returns the next state and the output 
% It follows a state diagram similar to what in the lecture but we modified
% the output to be 3 bits instead of 2
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

