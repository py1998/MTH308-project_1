X =  @(t) 3*sin(2*pi*t);
Y =  @(t) 4*cos(2*pi*t);
dXdt =   @(t) 6*pi*cos(2*pi*t);
dYdt =  @(t) -8*pi*sin(2*pi*t);
x0 = 9;
y0 = 13;
eps = 0.00001;

tic
tc = orthoProjectionOnCurve(x0, y0, X, Y, dXdt, dYdt, eps);
toc

[X(tc) Y(tc)]