clear all;
clc;

A = complex([1+2*i 1+3*i 1+4*i;
     1+3*i 3+4*i 4+5*i;
     1+4*i 4+5*i 5-4*i]);
x_0 = [10+9*i; 4+5*i; 7-2*i];
b_vec = A*x_0;
b_vec_1 = [-4+71*i; 12+96*i; -8+51*i];

X0 = [0+0*i; 0+0*i; 0+0*i];


[X_real,X_imag,err] = conjgrad_complex(A,b_vec_1,X0,1e-7,-1);

for ii = 1:length(X_real)
	X_rst(ii,1) = complex(X_real(ii,1),X_imag(ii,1));
end
