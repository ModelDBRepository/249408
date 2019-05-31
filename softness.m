function[S] = softness(ch1_size,ch2_size,q,k)
S = 0;
i = ch1_size;
j = ch2_size;

if ((i <= 0.2) & (j <= 0.2) & k(1) == q)
    S = 1;
else if ((i <= 0.2) & (j >= 0.3) & k(2) == q)
        S = 1;
    else if ((i >= 0.3) & (j <= 0.2) & k(2) == q)
            S = 1;
        else if ((i >= 0.3) & (j >= 0.3) & k(5) == q)
                S = 1;
            end
        end
    end
end
end

