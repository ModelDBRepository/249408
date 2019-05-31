
function output = ramp(a,e,m)

case_zero = find(a < e);
case_a = find(a >= e & a <= 1/m +e);
case_one = find(a > 1/m + e);

output(case_zero) = 0;
output(case_a) = m .* (a(case_a) - e);
output(case_one) = 1;

