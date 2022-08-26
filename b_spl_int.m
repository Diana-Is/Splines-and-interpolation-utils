function int_curve=b_spl_int(x,y,grid,param_gen_type,knot_v_gen_type)
%INPUT:
%x,y - coordinates of interpolation points
%TYPE - type of parametrization
% - uniform
%--------------------------------------
%OUTPUT:
%int_curve - curve drawn through points
%--------------------------------------
%p - degree is equal to 3, cubic spline
%m - number of knots
%n+1 - number of data points and parameters


%n+1 data points D_0,...D_n
%as many parameters as data points
%p=3 cubical curve
%m=n+p+1 knots
%u_0=u_1=u_2=u_3=0

%WORKING: CENTRIP+AVERAGE, CHORD+AVERAGE, UNIFORM+AVERAGE

grid_init=grid;
x_init=x;
y_init=y;
n=size(y,2)-1;
p=3; %spline degree
ynorm=max(y);
y=y/ynorm;
R=[x',y'];
%t=zeros(1,n+1);%parameter vector

%Parameter vector generation:
%uniform
%chord
%arc-length
%centripetal
if strcmp(param_gen_type,'uniform')
t=[0:1/n:1];

elseif strcmp(param_gen_type,'chord')
for i=1:1:n
L(i)=sqrt((x(i+1)-x(i))^2+(y(i+1)-y(i))^2);
end
Lcs=cumsum(L);
t=[0,Lcs(1:end-1)/Lcs(end),1];

elseif strcmp(param_gen_type,'arc')



elseif strcmp(param_gen_type,'centrip')
alpha=0.6;
for i=1:1:n
L(i)=(sqrt((x(i+1)-x(i))^2+(y(i+1)-y(i))^2))^alpha;
end
Lcs=cumsum(L);
t=[0,Lcs(1:end-1)/Lcs(end),1];
else
disp('wrong param_gen_type')
    
end

[grid,gnorm,gshift]=shift_grid(grid);
[x,xnorm,xshift]=shift_grid(x);

%knot vector generation
if strcmp(knot_v_gen_type,'uniform')
j=[1:1:n-p];
internal=j/(n-p+1);
knots_t=[0,0,0,0,internal,1,1,1,1];
elseif strcmp(knot_v_gen_type,'average')
for i=1:n-p
internal(i)=(t(i+1)+t(i+2)+t(i+3))/p;
end
knots_t=[0,0,0,0,internal,1,1,1,1];
elseif strcmp(knot_v_gen_type,'universal')

else
    disp('wrong knot generation type')
end

P=cont_points_calc(x,y,t,knots_t,p);
int_curve=bspline_deboor(p+1,knots_t,P',size(grid,2));
%figure,plot(int_curve(1,:),int_curve(2,:),x,y,'*');
int_curve(2,:)=int_curve(2,:)*ynorm;
int_curve(1,:)=int_curve(1,:)*gnorm+gshift;
%figure,plot(grid_init,int_curve,x_init,y_init,'*');
end


function P=cont_points_calc(x,y,t,knots_t,p)
R=[x',y'];
B=bspline_basismatrix2(p+1,knots_t,t);
P=B^(-1)*R;
end

function [grid,gnorm,gshift]=shift_grid(grid)
gshift=grid(1);
grid=grid-gshift;
gnorm=grid(end);
grid=grid/gnorm;    
end

