function y=reglpvobs(e)

global pdK pdK1 pv pv1

xp=e;
%p=80;
c1=polydec(pv1,xp);
Kp1=psinfo(pdK1,'eval',c1);
[a2,b2,c3,d2]=ltiss(Kp1);
y=xp;