#include <math.h>
#include "matrix.h"
#include "interpolation.h"
#include <mex.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
mxArray *x_in_m, *y_in_m, *shag_in_m, *t_out_m, *y_int_out_m;
const mwSize *dims;
double *x, *y, *t, *y_interp, *shag_a;
int dimx, dimy, numdims;

//processing insert arguments
x_in_m = mxDuplicateArray(prhs[0]);
y_in_m = mxDuplicateArray(prhs[1]);
shag_in_m = mxDuplicateArray(prhs[2]);
dims = mxGetDimensions(prhs[0]);
dimy = (int)dims[0]; dimx = (int)dims[1];

x = mxGetPr(x_in_m);
y = mxGetPr(y_in_m);
shag_a=mxGetPr(shag_in_m);
double shag=shag_a[0];
double shiftt=x[0];
 for(int i=0;i<dimx;i++)
    {
      x[i]=x[i]-shiftt;
    }
 double divisor = x[dimx-1];
 for(int i=0;i<dimx;i++)
    {
      x[i]=x[i]/divisor;
    }
 
alglib::spline1dinterpolant s;
alglib::ae_int_t const n=dimx;
alglib::real_1d_array x_a_a;
alglib::real_1d_array y_a_a;
double x_p[dimx];
double y_p[dimx];
for (int k=0; k<dimx;k++)
{
x_p[k]=x[k];
y_p[k]=y[k];
}
x_a_a.setcontent(dimx,x_p);
y_a_a.setcontent(dimx,y_p);

spline1dbuildcatmullrom(x_a_a,y_a_a,s);
//double alglib::barycentriccalc(barycentricinterpolant b, double t);
double t_tempo=x_p[0];

int num_points_grid=(1-t_tempo)/(shag);
//int num_points_grid=dimx;
t_out_m = plhs[0] = mxCreateDoubleMatrix(1,num_points_grid,mxREAL); //ona defoltno inizializiruetsa, eto uzhe horosho
y_int_out_m = plhs[1] = mxCreateDoubleMatrix(1,num_points_grid,mxREAL);
t = mxGetPr(t_out_m);
y_interp = mxGetPr(y_int_out_m);
for(int u=0; u<num_points_grid;u++){
  t[u]=(t_tempo+shag*u);
 printf("%f\n",t[u]);
   y_interp[u]=alglib::spline1dcalc(s,t[u]);
   t[u]=t[u]*divisor+shiftt;
}
}