clear; clc;
%Q1
fileid = fopen('Test_Text_File.txt', 'r');
message = fscanf(fileid, '%c');
fclose(fileid);
[entropy, probs, freqs, unique] = entropy(message);
%printing the entropy
%Q2
fprintf("entropy = %f \n", entropy);
len = size(freqs);
%Q3
num_of_bits = ceil(log2(len(2)));
fprintf("Number of bits = %f \n", num_of_bits);
eff = entropy / num_of_bits;
fprintf("efficiency = %f \n", eff);

%Q4
%%sorting
SortedPro(length(probs))= 0;
SortedChars(length(probs))= "";
for i=1:length(probs)
  Mini = inf;
  MiniIndex = 0;
  for j=1:length(probs)
   if(probs(j) < Mini)
    Mini = probs(j); 
    MiniIndex = j;
   end
  end 
  SortedPro(i) = probs(MiniIndex);
  SortedChars(i) = unique(MiniIndex);
  probs(MiniIndex) = inf;
end   

%SProp = SortedPro;
%SChars = SortedChars;

%initializing Matrix
for i=1:length(SortedChars)
   Output(i,1) = SortedChars(i);
   Output(i,2) = SortedPro(i);
   Output(i,3) = "";
end

for i=1:length(SortedPro)-1
  Sum = SortedPro(1)+SortedPro(2);
  Holder = SortedPro;%hold sorted probs
  Char1 = SortedChars(1);
  Char2 = SortedChars(2);
  ChHolder = SortedChars;
  SortedChars = "";
  SortedPro = [];
  for j=3:length(Holder)+1
      if(j<length(Holder)+1 && Holder(j)<=Sum) 
      SortedPro(j-2) = Holder(j);
      SortedChars(j-2) = ChHolder(j);
      else
      SortedPro(j-2) = Sum;
      SortedChars(j-2) = Char1 + Char2;
      SortedPro(j-1:length(Holder)-1) = Holder(j:end);
      SortedChars(j-1:length(ChHolder)-1) = ChHolder(j:end);
      LC1 = split(Char1,"");
      LC2 = split(Char2,"");
      LC1(end) = [];
      LC1(1) = [];
      LC2(1) = [];
      LC2(end) = []; 
      for le=1:length(LC1)
       index = find(Output(:,1) == LC1(le));   
       Output(index,3) = "0" + Output(index,3);  
      end
       for le=1:length(LC2)
       index = find(Output(:,1) == LC2(le));   
       Output(index,3) = "1" + Output(index,3);  
       end
      break;
      end
  end  
end

%storing the sorted unique characters
TableArray = "";
for i=1:length(Output)
 Holder = string(Output(i));
 TableArray(i) = char(Holder);
end   

% encoding table is the matrix Output
%You can check it for each symbol and the corresponding code

%Q4-b
%writing the encoded in a file
fileid = fopen('Test_Text_File.txt', 'r');
signal = fscanf(fileid, '%c');
fclose(fileid);
mess = char(signal);
enc_text = '';
for h = 1 : length(mess)
    index = find(Output(:, 1) == mess(h));
    enc_text = [enc_text, Output(index, 3)];
end
enc_text(1) = [];
fid = fopen('encoding.txt','w');
fprintf(fid, "%s", enc_text);
fclose(fid);


%Q5
%decoding the encoded file
fileid = fopen('Veterbi_Best_output.txt', 'r');
code_text = fscanf(fileid, '%c');
fclose(fileid);
decoded = "" ; 
code = "";
maxlength = 0;
for L = 1:length(Output(:,3))
    cc = char(Output(L,3));
    if length(cc) > maxlength
        maxlength = length(cc);
    end
end
for i = 1 : length(code_text)
    code = code + code_text(i);
    code = string(code);	
    if code(1) == ""
       code(1) = []; 
    end
    found = find(Output(:, 3) == code);
    if found >= 1
        decoded = decoded + Output(found , 1);
        code = "";
    end
    
    if length(code) > maxlength
       code = ""; 
    end
end
%chech whether the decoding process is done well
if decoded == message
   disp("decoding went fine"); 
end

fid = fopen('decoding result.txt','w');
fprintf(fid, "%s", decoded);
fclose(fid);

%%% Code Lavg
Lavg = 0;
for i=1:length(TableArray)
   Lavg = Lavg + str2num(Output(i,2))*length(char(Output(i,3)));
end    

Huf_eff = entropy / Lavg;
fprintf("efficiency = %f \n", Huf_eff);
