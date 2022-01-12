
clc ;

% Reading input from file 
recieved_sig = readmatrix('ConvEnco_output.txt');




%input = '111110010100';
%input = flip(input);

errors_count=[]; % will be used to store the errors for each SNR


% correcting the input (Hard Decision)
Corrected_matrix = [];
SIZ = size(recieved_sig);   % size of recieved message (used for looping)
row = [];
for i=1:SIZ(1)
    for j=1:SIZ(2)
        % for each value in recieved (noisy signal), round it to become
        % zero or one
       recieved_sig(i,j) = Rounding(recieved_sig(i,j));
    end
    %Corrected_matrix(i,:) = row;

end

%                   VITERBI STARTS HERE    

% looping across all signals (same signal with different SNR)
for x =1:SIZ(1)
   
    % converting datatype 
    input = num2str(recieved_sig(x,:));
    %input = convertCharsToStrings(input);
    input = strrep(input,' ','') ;
    % removing spaces 
    
    
    
    % the states are nodes , each node has name 
    S0.name = 'S0';
    S1.name ='S1';
    S2.name ='S2';
    S3.name ='S3';
    
    % Initializing number of errors at each node with inf
    % inf because i want a great number to compare with
    S0.err = inf;
    S1.err = inf;
    S2.err = inf;
    S3.err = inf;
    
    
    %  this "checked" property of the nodes just used to discard all the
    %  nodes in the first column except S0. S0 will be changed later to 1
    % discarding because we don't use them in the first column (refer to
    % lec)
    S0.checked = 0;
    S1.checked = 0;
    S2.checked = 0;
    S3.checked = 0;
    
    
    

    % prev_index is the location of the prev node. Will be used when
    % traversing the tree backwards to find the best path
    % inital value [-1 -1] just a place holder
    S0.prev_index = [-1 -1];
    S1.prev_index = [-1 -1];
    S2.prev_index = [-1 -1];
    S3.prev_index = [-1 -1];
    

    % if we cut the node because it produces large errors , is leaf will be
    % 1 1
    % [1 1] both lines are cut from node
    % [0 1] or [1 0] one line is cut, so it's not leaf
    S0.isleaf = [0 0];
    S1.isleaf = [0 0];
    S2.isleaf = [0 0];
    S3.isleaf = [0 0];
    
    S0.value = [];
    S1.value = [];
    S2.value = [];
    S3.value = [];
    
    
    %S0.i = '1,3';
    

    
    % Setting the next state of each Node as well as it's output in case of
    % 1 or 0 input
    [S0.next1, S0.out1] = getNextState(S0.name,'1');
    [S0.next0 ,S0.out0] = getNextState(S0.name,'0');
    
    [S1.next1, S1.out1] = getNextState(S1.name,'1');
    [S1.next0 ,S1.out0] = getNextState(S1.name,'0');
    
    
    [S2.next1, S2.out1] = getNextState(S2.name,'1');
    [S2.next0 ,S2.out0] = getNextState(S2.name,'0');
    
    [S3.next1, S3.out1] = getNextState(S3.name,'1');
    [S3.next0 ,S3.out0] = getNextState(S3.name,'0');
    
    
    % INITIALIZING THE VITERBI MATRIX 
    arr = [S0; S1; S2;S3]; % just one column. will be repeated n/3 times where n is length of signal
    Viterbi = [];   % the whole matrix
    
    % initializing the Matrix
    for i=1:3:length(input)+1    % adding the right number of columns
        Viterbi = [Viterbi arr];
    end
    Viterbi(1,1).checked = 1;   % to use S0 as a start
    Viterbi(1,1).err = 0;   % error of first node (1,1) is zero
    
    k = 1;
    for i=1:3:length(input)-2
        in = input(i:i+2);
        
        for j=1:4
            state = Viterbi(j,k);   % the current node 
            % the tree starts with one node S0 , so the three nodes in the
            % same column (first column) are not used 
            % checked nodes are the used nodes
            if(state.checked == 1)   
                index = getindex(state.next0);
                diff0 = state.err + compare(in,state.out0);  % adding error of node to new error 
                % this step will be repeated for the other branch of tree
                % (branch 1)
                
               
               %next =  Viterbi(index,k+1);
                
               % if our new error is less than found error in the node ,
               % remove the large error and put the less 
               if(diff0<Viterbi(index,k+1).err)
                   Viterbi(index,k+1).err = diff0 ;
                   Viterbi(index,k+1).checked = 1; % making sure to use the next node
                   if(Viterbi(index,k+1).prev_index ~= [-1 -1])    
                       % if pointer to last node is value other than the
                       % place holder , update it with last upadated parent
                       % of the current node (because each node might have
                       % multiple parents)
                       
                        leaf_i  = Viterbi(index,k+1).prev_index(1);
                        leaf_j = Viterbi(index,k+1).prev_index(2);
                       Viterbi(leaf_i,leaf_j).isleaf = [Viterbi(leaf_i,leaf_j).isleaf 1] ;

                      
                        
                   end
                   %Viterbi(index,k+1).prev_index = append(int2str(j),',',int2str(k));
                   Viterbi(index,k+1).prev_index = [j k];
                   Viterbi(j,k).isleaf =[Viterbi(j,k).isleaf 0] ;
    
                    Viterbi(index,k+1).value = [Viterbi(index,k+1).value 0];
    
               end
    
                % this part is the same as previous block but for the
                % second branch of each node
               diff1 = state.err + compare(in,state.out1);
               
               index = getindex(state.next1);
               
               if(diff1<Viterbi(index,k+1).err)
                   % same as explained before 
                    Viterbi(index,k+1).err = diff1;
                    Viterbi(index,k+1).checked = 1; 
                    if(Viterbi(index,k+1).prev_index ~= [-1 -1])
                        % same as explained before
                       
                        leaf_i  = Viterbi(index,k+1).prev_index(1);
                        leaf_j = Viterbi(index,k+1).prev_index(2);
                       Viterbi(leaf_i,leaf_j).isleaf = [Viterbi(leaf_i,leaf_j).isleaf 1] ;
                        
                   end
                   %Viterbi(index,k+1).prev_index = append(int2str(j),',',int2str(k));
                   Viterbi(index,k+1).prev_index = [j k];
                    Viterbi(j,k).isleaf = [Viterbi(j,k).isleaf 0];
                    Viterbi(index,k+1).value = [Viterbi(index,k+1).value 1];
                    % if 
               end
    
            end
         end
        k = k+1;
    end
    
    
    % 


    % determining if node is leaf based on last two
       % values in isleaf array (possible values
                   % demonstrated in initialization)
    k = (length(input)/3)+1;
    for i=1:4
        for j= 1:k
            if ( (Viterbi(i,j).isleaf(end)==0) && (Viterbi(i,j).isleaf(end-1)==1) )
                Viterbi(i,j).isleaf = 0;
            elseif ( (Viterbi(i,j).isleaf(end)==1) && (Viterbi(i,j).isleaf(end-1)==0) )
                Viterbi(i,j).isleaf = 0;
            elseif ( (Viterbi(i,j).isleaf(end)==1) && (Viterbi(i,j).isleaf(end-1)==1) )
                Viterbi(i,j).isleaf = 1; % leaf because both branches were cut
            end
        end
    end
    
    
       
    % finding the best route
    
    % finding the min node in last column
    min = inf;
    for i=1:4
         if (Viterbi(i,end).err < min)
             min =Viterbi(i,end).err;
             index_min = i;
         end
    end
    
    
    % traversing the tree backwards to find the best path
    output = '';
    state = Viterbi(index_min,end);
    for z = 1:(length(input)/3)
        output = append(output,num2str(state.value(end)));
        state= Viterbi(state.prev_index(1),state.prev_index(2));
        
    
    end
    
    
    
    
    output = flip(output);
    
    % this matrix have all outputs of recieved signals with different snr
    writematrix(output,'Viterbi_out.txt','WriteMode','append');
    % append is used to avoid overwriting 


% calculating the error of each vector compared to 
 error = compare(output,message);
 error = error/length(output);
 errors_count = [errors_count error];

 % selecting the best signal (SNR is largest) to test huffman decoding
 if(error == 0)
     writematrix(output,'Veterbi_Best_output.txt');
 end
 end



 
   
SNR = 5:1:20;
%plot(SNR,errors)

semilogx(SNR,errors_count);
xlabel('SNR');
ylabel('BER');








% this function tells me the row of the state 
% for example, S2 is in the third row in my matrix (Viterbi matrix)
function index = getindex(input)
    switch input
        case 'S0'
            index = 1;
        case 'S1'
            index = 2;
        case 'S2'
            index = 3;
        case 'S3'
            index = 4;
    end
end


%function out=(prev,curr)
 %   swich 


 % Rounding applies Hard decision
 % if noisy value is > 0.5 , then it's probably 1 
 function out=Rounding(in)
    if (in>0.5)
        out = 1;
    else 
        % then it is a zero
        out =0;
    end
 end






