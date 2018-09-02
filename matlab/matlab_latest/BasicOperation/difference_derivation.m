%% clear screem
close all
clc
clear

%%
syms x
syms t
f = (x + 2)*(x^2 + 3)
der1 = diff(f)
f = (t^2 + 3)*(sqrt(t) + t^3)
der2 = diff(f)
f = (x^2 - 2*x + 1)*(3*x^3 - 5*x^2 + 2)
der3 = diff(f)
f = (2*x^2 + 3*x)/(x^3 + 1)
der4 = diff(f)
f = (x^2 + 1)^17
der5 = diff(f)
f = (t^3 + 3* t^2 + 5*t -9)^(-6)
der6 = diff(f)

y = exp(x)
diff(y)
y = x^9
diff(y)
y = sin(x)
diff(y)
y = tan(x)
diff(y)
y = cos(x)
diff(y)
y = log(x)
diff(y)
y = log10(x)
diff(y)
y = sin(x)^2
diff(y)
y = cos(3*x^2 + 2*x + 1)
diff(y)
y = exp(x)/sin(x)
diff(y)
