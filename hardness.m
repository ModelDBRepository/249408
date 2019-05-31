function[H] = hardness(ch1_size,ch2_size,q,k)
H = 0;
i = ch1_size;
j = ch2_size;


if ((i <= 0.2) & (j <= 0.2) & k(1) == q)
    H = 1;
else if ((i <= 0.1) & (j >= 0.3) & k(2) == q)
        H = 1;
    else if ((i == 0.2) & (j >= 0.3) & k(3) == q)
            H = 1;
        else if ((i >= 0.3) & (j < i) & k(2) == q)
                H = 1;
            else if ((i >= 0.3) & (j > i) & k(3) == q)
                    H = 1;
                else if ((i >= 0.3) & (j == i) & k(4) == q)
                        H = 1;
                    end
                end
            end
        end
    end
end
end