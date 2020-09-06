
%Gain-scheduling control of  power sharing

% Author: M. SELLALI
% Copyright 2018-2019 The MathWorks, Inc. 

global pdK pv

n1=10
d1=[1 10]
w1=ltisys('tf',n1,d1);
sys = tf(n1,d1); 
fig1=figure;
%title('filter for  S=1/(1+GK)  (performance)')


%  Filter w2 to shape KS                   
w2=0.8;
 
title('filter for  K/(1+GK)  (control action)')
W11=sdiag(w1,w1)
W22=sdiag(w2,w2);
%  Specify the range of parameter values (parameter box);
% 
a_batt_min=0.1;  a_batt_max=0.9;
a_sc_min=0.1;   a_sc_max=0.9;
pv=pvec('box',[a_batt_min a_batt_max; a_sc_min a_sc_max]);


%��������������������������������������������������
Rdc=10000;Cdc=2000^6;
Lsc=0.001;Lbatt=0.001;
%��������������������������������������������������

%  Specify the parameter-dependent model with PSYS

s0 = ltisys([0 1;0 0],[0;1],[-1 0;0 1],[0;0])
s1 = ltisys([-1 0;0 0],[0;0],zeros(2),[0;0],0)
s2 = ltisys([0 0;-1 0],[0;0],zeros(2),[0;0],0)
pdG = psys(pv,[s0 s1 s2])

%  Specify the loop-shaping control structure with SCONNECT r(2) deux entr�e aux syst�me

[pdP,r]=sconnect('r(2)','W11;W22','K:e=r-G;r','G:K',pdG,'W11:e',W11,'W22:G',W22);

%  Augment with the shaping filters EYE5(n); n=ordre du syst�me

[gopt,pdK]=hinfgs(pdP,r,0,1e-4);




