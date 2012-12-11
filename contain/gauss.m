function y = gauss(x,algorithm)
% 
% Gaussian function 
% Variable dimensional test function for unconstrained optimization.
% Single optimum function

w = 0.25;
s = 1;
a = 0.2;  % randomization parameters
b = 0.2;


n = length(x);
for i = 1:n;
    s = s.*exp(-(x(i)-pi/2-a.*randn(1)).^2/(2*w.^2));
end
y = -s;

y=y*(1+b*randn(1));

filename=['gauss',num2str(numel(x)),'_',algorithm,'.dat'];
dlmwrite(filename, [y,x(:)'],'delimiter',',','precision',6,'-append');