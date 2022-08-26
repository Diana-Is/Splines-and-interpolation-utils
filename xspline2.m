function curve=xspline2(x,y,vec_s,if_open,repEnds,tstep)
%x - x coordinates of control points
%y - y coordinates of control points
%vec_s -- vector of S for each point. if one value then same value for all points
%if_open -- if ends of spline are "clipped" to the last points or no
%repEnds -- either "TRUE" or "extedn"

N=length(x);
if(length(vec_s)~=N)
  if(length(vec_s)==1)
  vec_s=ones(1,N)*vec_s;
  else
  disp('wrong shape vector!')
  return;
  end

end


if(if_open)%if ends are not "clipped"

  if(strcmp(repEnds,'extend'))
      a1 = angle(x(2:1), y(2:1));
      d1 = dist(x(2)-x(1), y(2)-y(1));
      [ext1x,ext1x] = extend(x(1), y(1), a1, d1);
      a2 = angle(x((N-1):N), y((N-1):N));
      d2 = dist(x(N-1)-x(N), y(N-1)-y(N));
      [ext2x,ext2x] = extend(x(N), y(N), a2, d2);
      x = [ext1x, x, ext2x];
      y = [ext1y, y, ext2y];
      vec_s = [0, vec_s, 0];
      N = N + 2;            
  elseif(repEnds)
      % Force first and last shape to be zero
      vec_s(1) = 0; 
      vec_s(N) = 0;
      %Repeat first and last control points
      x = [x(1), x, x(N)];
      y = [y(1), y, y(N)];
      vec_s=[vec_s(1), vec_s, vec_s(N)];
      N = N + 2;
  end

else 
%Add last control point to start AND last first two control points to end
x = [x(N), x, x(1:2)];
y = [y(N), y, y(1:2)];
vec_s = [vec_s(N), vec_s, vec_s(1:2)];
N = N + 3;
end

curvex = [];
curvey = [];
for (i=1:(N-3)) 
  index = [i:(i+3)];
    if (tstep<=0) 
      %step=xsplineStep(x(index), y(index),vec_s(i+1), vec_s(i+2));
      step=0.01;
    else 
      step=tstep;
    end
  [curvextemp,curveytemp] = xsplinePts(x(index), y(index),vec_s(i+1),vec_s(i+2),[0:step:1]);
  curvex=[curvex,curvextemp];
  curvey=[curvey,curveytemp];
  end
curve=[curvex;curvey];

end %of main function

function [x,y]=extend(x, y, angle, d) 
    x=x + d*cos(angle);
    y=y + d*sin(angle);
end


function ff=fblend(num, denom) 
  u = num/denom;
  p = 2*denom*denom;
  ff=u*u*u*(10 - p + (2*p - 15)*u + (6 - p)*u*u);
end


function gg=gblend(u, q) 
  gg=u*(q + u*(2*q + u*(8 - 12*q + u*(14*q - 11 + u*(4 - 5*q)))));
end
function hh=hblend(u, q) 
  hh=u*(q + u*(2*q + u*u*(-2*q - u*q)));
end

function [x,y]=xsplinePts(px, py, s1, s2, t) 
  Nt=length(t);
  x=zeros(1,Nt);
  y=zeros(1,Nt);
  for(i=1:Nt)
  if (s1 < 0) 
    A0 = hblend(-t(i), -s1);
    A2 = gblend(t(i), -s1);
  else
    if(t(i) < s1)
    A0 = fblend(t(i)-s1,-1-s1);
    else 
    A0=0; 
    end
    A2 = fblend(t(i)+s1,1+s1);
  end
  if (s2 < 0) 
    A1 = gblend((1-t(i)),-s2);
    A3 = hblend(t(i)-1,-s2);
  else
    A1 = fblend(t(i)-1-s2,-1-s2);
    if(t(i) > 1 - s2)
      A3 =fblend(t(i)-1+s2,1+s2);
    else
      A3=0;
    end
  end
  Asum = A0 + A1 + A2 + A3;
  x(i)=(A0*px(1) + A1*px(2) + A2*px(3) + A3*px(4))/Asum;
  y(i)=(A0*py(1) + A1*py(2) + A2*py(3) + A3*py(4))/Asum;
  end
end

function a=angle(x, y)
    a=atan2(y(2) - y(1), x(2) - x(1));
end

function d=dist(dx, dy)
    d=sqrt(dx^2 + dy^2);
end


