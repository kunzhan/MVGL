% function [acc, nmi,pu, P, R, F,AR,y] = MVGL_demo
% clc; close all;clear
% restoredefaultpath;
% currentFolder = pwd;
% addpath(genpath(currentFolder));
% addpath('./MV_datasets');
addpath('./tools')
% load('Number123456.mat');	islocal_1 = 0;islocal_2 = 0; k = 15;	%fianl
% load('NH_p4660.mat');     islocal_1 = 1;islocal_2 = 1; k = 50;	%final
% load('C101_p1474.mat');   islocal_1 = 1;islocal_2 = 1; k = 40;	%final
% load('COIL_20.mat');      islocal_1 = 1;islocal_2 = 1; k = 3; 	%final

y0 = truth;
c = max(truth);
nv = length(X_train);
n = size(X_train{1},2);
S = zeros(n,n,nv);
Sv = S;
% alpha = ones(nv,1);
% alpha_v = [0 0 1 0]';
for v = 1:nv
%     X_train{v} = X_train{v}./(sum(sum(X_train{v})));
    S(:,:,v) = Updata_Sv(X_train{v},c,k, islocal_1);
    Sv(:,:,v) = S(:,:,v)./nv;
%     figure,imshow(A(:,:,v),[]),colorbar,colormap jet
end
S0 = sum(Sv,3);
% clear Ab;

J_old = 1; J_new = 10; EPS = 1e-3;
iter = 0;
while abs((J_new - J_old)/J_old) > EPS
    iter = iter +1;
    [y, A, ~] = Updata_A(S0, c,islocal_2);
    alpha = Updata_w(A,S);
    for i = 1:n
        for v = 1:nv        
            Sv(:,i,v) = alpha(v,i).*S(:,i,v);
        end
    end
    S0 = sum(Sv,3);
    clear Ab
%     if iter == 30
%         break
%     end
    J_old = J_new;
    J_new =  sum(sum((A - S0).^2));
    O(iter) = J_new;
end
