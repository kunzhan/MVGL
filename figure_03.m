clc; close all;clear
addpath('./tools')
% load TC_DS; c = 3;
load TM_DS; c = 2;
n = 100;
% X = twomoon_gen(n,n,0);
% [X1,la] = threecircles(n,0.14);
% X2 = threecircles(n,0.16);
% gt = [ones(n,1);2*ones(n,1)]; 
Kini = 15;
KCAN1 = 5;
KCAN2 = 5;
A0 = constructW_PKN(X1', Kini, 0);
A = A0;
A = (A+A')/2;
subplot(221); 
% figure
hold on;
% plot(X1(:,1),X1(:,2),'.k', 'MarkerSize', 18); hold on;
plot(X1(gt==1,1),X1(gt==1,2),'.r', 'MarkerSize', 18); 
plot(X1(gt==2,1),X1(gt==2,2),'.', 'MarkerSize', 18);
plot(X1(gt==3,1),X1(gt==3,2),'k.', 'MarkerSize', 18); 
nn = c*n;
for ii = 1 : nn;
    for jj = 1 : ii
        weight = A(ii, jj);
        if weight > 0
            plot([X1(ii, 1), X1(jj, 1)], [X1(ii, 2), X1(jj, 2)], '-g', 'LineWidth', 15*weight)
        end
    end;
end;
hold off
axis equal;

S1 = Updata_Sv(X1',c,KCAN1, 1);
A = S1;
A = (A+A')/2;
subplot(223); hold on;
plot(X1(gt==1,1),X1(gt==1,2),'.r', 'MarkerSize', 18); 
plot(X1(gt==2,1),X1(gt==2,2),'.', 'MarkerSize', 18); 
plot(X1(gt==3,1),X1(gt==3,2),'k.', 'MarkerSize', 18); 
nn = c*n;
for ii = 1 : nn;
    for jj = 1 : ii
        weight = A(ii, jj);
        if weight > 0
            plot([X1(ii, 1), X1(jj, 1)], [X1(ii, 2), X1(jj, 2)], '-g', 'LineWidth', 15*weight);
        end
    end;
end;
hold off
axis equal;
% ____
A0 = constructW_PKN(X2', Kini, 0);
A = A0;
A = (A+A')/2;
subplot(222); hold on;
plot(X2(gt==1,1),X2(gt==1,2),'.r', 'MarkerSize', 18); 
plot(X2(gt==2,1),X2(gt==2,2),'.', 'MarkerSize', 18);
plot(X2(gt==3,1),X2(gt==3,2),'k.', 'MarkerSize', 18); 
nn = c*n;
for ii = 1 : nn;
    for jj = 1 : ii
        weight = A(ii, jj);
        if weight > 0
            plot([X2(ii, 1), X2(jj, 1)], [X2(ii, 2), X2(jj, 2)], '-g', 'LineWidth', 15*weight);
        end
    end;
end;
hold off
axis equal;
S2 = Updata_Sv(X2',c,KCAN2, 1);
A = S2;
A = (A+A')/2;
subplot(224); hold on;
plot(X2(gt==1,1),X2(gt==1,2),'.r', 'MarkerSize', 18);
plot(X2(gt==2,1),X2(gt==2,2),'.', 'MarkerSize', 18); 
plot(X2(gt==3,1),X2(gt==3,2),'k.', 'MarkerSize', 18); 
nn = c*n;
for ii = 1 : nn;
    for jj = 1 : ii
        weight = A(ii, jj);
        if weight > 0
            plot([X2(ii, 1), X2(jj, 1)], [X2(ii, 2), X2(jj, 2)], '-g', 'LineWidth', 15*weight);
        end
    end;
end;
hold off
axis equal;

%________________
S(:,:,1) = S1;
S(:,:,2) = S2;
A0 = S1./2 + S2./2;
J_old = 1; J_new = 10; EPS = 1e-3;
iter = 0;
while abs((J_new - J_old)/J_old) > EPS
    iter = iter +1;
    [y, A, evs] = Updata_A(A0, c,1);
    alpha = Updata_w(A,S);
    for i = 1:nn
        for v = 1:2        
            Ab(:,i,v) = alpha(v,i).*S(:,i,v);
        end
    end
    A0 = sum(Ab,3);
    A0 = (A0+A0')/2;
    clear Ab
%     if iter == 30
%         break
%     end
    J_old = J_new;
    J_new =  sum(sum((A - A0).^2));
    O(iter) = J_new;
end
A = (A+A')/2;
figure, hold on;
plot(X2(gt==1,1),X2(gt==1,2),'.r', 'MarkerSize', 18);
plot(X2(gt==2,1),X2(gt==2,2),'.', 'MarkerSize', 18); 
plot(X2(gt==3,1),X2(gt==3,2),'k.', 'MarkerSize', 18); 
nn = c*n;
for ii = 1 : nn;
    for jj = 1 : ii
        weight = A(ii, jj);
        if weight > 0
            plot([X2(ii, 1), X2(jj, 1)], [X2(ii, 2), X2(jj, 2)], '-g', 'LineWidth', 15*weight);
        end
    end;
end;
hold off
axis equal;
