%Gain-scheduling control of  power sharing

% Author: M. SELLALI
% Copyright 2018-2019 The MathWorks, Inc. 
% Parameters
clear all
clc
global pdK pv

%��������������������������������������������������
Rdc=100000;Cdc=2;to=2;Csc=58;Rsc=0.02
a_batt_min=0.1;  a_batt_max=0.9;
a_sc_min=0.1;   a_sc_max=0.9;
a_sc=0.5;a_b=0.5;
%��������������������������������������������������

% Weighting functions
% n1=[1 0.05]
% d1=[0.5263 50]
% Wu=ltisys('tf',n1,d1)
% n2=[1 5]
% d2=[1 2.5]
% Wp=ltisys('tf',n2,d2)
% n3=[1 0.005]
% d3=[1 100]
% n4=[1 0.0005]
% d4=[1 100]
% Wpp=ltisys('tf',n3,d3)
% Wuu=ltisys('tf',n4,d4)

% Process

% A=[-1/to 0 a_b/Cdc a_sc/Cdc;0  0 0 -1/Csc;0 0 -50 0;0 0 0 -50]
% B=[0 0;0 0;50 0;0 50]
% C=eye(4)
% D=[0 0;0 -Rsc;0 0;0 -Rsc]
% P=ss(A,B,C,D)

%  Specify the range of parameter values (parameter box)
a_batt_min=0.1;  a_batt_max=0.9;
a_sc_min=0.1;   a_sc_max=0.9;
pv=pvec('box',[a_batt_min a_batt_max ; a_sc_min a_sc_max]);

% affine model:

s0 = ltisys([1 0 0 0;0  0 0 -1/Csc;0 0 -50 0;0 0 0 -50],[0 0;0 0;50 0;0 50],eye(4),[0 0;0 -Rsc;0 0;0 0])
s1 = ltisys([0 0 1 0;0  0 0 0;0 0 0 0;0 0 0 0],[0 0;0 0;0 0;0 0],zeros(4),[0 0;0 0;0 0;0 0],zeros(4))
s2 = ltisys([0 0 0 1;0  0 0 0;0 0 0 0;0 0 0 0],[0 0;0 0;0 0;0 0],zeros(4),[0 0;0 0;0 0;0 0],zeros(4))
pdG= psys(pv,[s0 s1 s2])

inputs = 'a;b';
outputs ='wp;wu;wpp;wuu';
K_in ='K:e1=a-G(1);e2=b-G(2)' ;
G_in ='G:K';
[pdP,r] = sconnect(inputs,outputs,K_in,G_in,pdG,'wp:e1',Wp,'wpp:e2',Wpp,'wu:K(1)',Wu,'wuu:K(2)',Wuu)


% append the shaping filters
% Paug = smult(pdP,sdiag(W1,W2,W3,W4,eye(1)))
% [gopt,pdK]=hinfgs(Paug,r,0,1e-3);
[gopt,pdK]=hinfgs(pdP,r,0,1e-3);
    
%break
close all
p=[0.7 0.7];
c1=polydec(pv,p);
Kp=psinfo(pdK,'eval',c1);
[aa,bb,cc,dd]=ltiss(Kp)

