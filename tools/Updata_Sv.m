function A = Updata_Sv(X, c, k, islocal)
% X = gpuArray(X);
NITER = 30;
num = size(X,2);
if nargin < 4
    islocal = 0;
end;
if nargin < 3
    k = 15;
end;

distX = L2_distance_1(X,X);
[distX1, idx] = sort(distX,2);
A = zeros(num);
rr = zeros(num,1);
for i = 1:num
    di = distX1(i,2:k+2);
    rr(i) = 0.5*(k*di(k+1)-sum(di(1:k)));
    id = idx(i,2:k+2);
    A(i,id) = (di(k+1)-di)/(k*di(k+1)-sum(di(1:k))+eps);
end;
lambda = 1;
A0 = (A+A')/2;

D0 = diag(sum(A0));
L0 = D0 - A0;
[F, ~, evs] = eig1(L0, c, 0);
% if sum(evs(1:c+1)) < 0.00000000001
%     error('The original graph has more than %d connected we component', c);
% end;
for iter = 1:NITER
    distf = L2_distance_1(F',F');
%     [distf1, ~] = sort(distf,2);                %%
    A = zeros(num);
    for i=1:num
        if islocal == 1
            idxa0 = idx(i,2:k+1);
        else
            idxa0 = 1:num;
        end;
        dfi = distf(i,idxa0);
        ad = -dfi/2/lambda;                        %%
        A(i,idxa0) = EProjSimplex_new(ad);
    end;
    A = (A+A')/2;
    D = diag(sum(A));
    L = D-A;
    F_old = F;
    [F, ~, ev]=eig1(L, c, 0);
    evs(:,iter+1) = ev;

    fn1 = sum(ev(1:c));
    fn2 = sum(ev(1:c+1));
    if fn1 > 0.00000000001
        lambda = lambda/2;
    elseif fn2 < 0.00000000001
        lambda = lambda*2;  F = F_old;
    else
        break;
    end
end