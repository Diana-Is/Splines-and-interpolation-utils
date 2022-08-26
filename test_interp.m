function test_interp()
load('brazil_extr.mat');

%WORKING: CENTRIP+AVERAGE, CHORD+AVERAGE, UNIFORM+AVERAGE
int_B_curve=b_spl_int(tmax,mmax,[tmax(1):0.1:tmax(end)],'chord','average');
figure,plot(int_B_curve(1,:),int_B_curve(2,:),tmax,mmax,'*')


%3rd parameter--approximation/interpolation. Approx =1, interp=-1
%3rd parameter can be a VECTOR for every point-- to extrapolate or to interpolate
%4th parameter "if ends are clipped". Are the ends free or binded
%5th parameter -- if extending (cycling) ends
%6th parameter --grid step 
X_curve=xspline2(tmax,mmax,-1,'FALSE','TRUE',0.01);
figure,plot(X_curve(1,:),X_curve(2,:),tmax,mmax,'*')

end