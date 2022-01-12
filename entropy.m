function [entropyy, probs, freqs, catt] = entropy(message)
chars = char(message);
len = length(chars);
checked = -1;
freq = zeros(1,len);
cat = char(len);
%counting the occurances of charachters

for i = 1:len
	count = 1;
	for c = i+1: len
		if chars(i) == chars(c)
			count = count + 1;
			freq(c) = checked;
		end
	end
	if freq(i) ~= checked
		freq(i) = count;
		cat(i) = chars(i);
	end
end
%removing duplicates 

freq = freq(freq ~= -1);
cat = cat(cat ~= 0);
catt = cat;
H_of_S = 0;

%length of the freq array is 39
I = []; % this is the amount of information array
prob = []; % probabilities array
s = size(freq);

for i = 1: s(2) % calculate entropy
	prob(i) = freq(i) / sum(freq); % calculating the prob of each character
	I(i) = log2(1/prob(i)); %from its rule
	H_of_S = H_of_S + (prob(i) * I(i));
end
probs = prob;
freqs = freq;
entropyy = H_of_S;
%printing the entropy
%fprintf("entropy = %f", H_of_S);
end