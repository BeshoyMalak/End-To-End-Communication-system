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
