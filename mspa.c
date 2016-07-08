/*
  This is the file mspa.c

  mspa provides a MATLAB and Octave MEX interface to the Solar
  Position Algoritm reference implementation spa.c for computing to
  high accuracy the angular position of the sun from positions on the
  earth.

  Details of the spa function are provided in the National Renewable
  Energy Laboratory Report NREL/TP-560-34302, Solar Position Algoritm
  for Solar Radiation Applications, by Ibrahim Reda and Afshin
  Andreas. The report, spa.c and accompanying files can not be
  distributed but are available from the NLER website, www.nler.gov,
  at the link http://www.nrel.gov/midc/spa/

  Compile mspa.c for MATLAB with:
  mex mspa.c spa.c

  Compile mspa.c for Octave with:
  mkoctfile --mex mspa.c spa.c

  Then try out the first example mspa_tester.

  $Id: mspa.c 91 2011-08-23 16:55:42Z abel $

  mspa.c is Copyright (C) 2011 Anders Lennartsson
  All rights reserved.

  mspa.c is Licensed by the Modified BSD License.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.
      * Neither the name of the <organization> nor the
        names of its contributors may be used to endorse or promote products
        derived from this software without specific prior written permission.
 
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */

#include <mex.h>
#include "spa.h"
#include "mspa.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
  double *result_pointer;
  double *argument_pointer;
  spa_data spa;
  int result, ncolumns, ii;

  if (nrhs != 1)
    { mexErrMsgTxt("mspa requires 1 input argument."); }
  else if (nlhs > 1)
    { mexErrMsgTxt("mspa requires one output argument."); }
  else if (exCheckArgument(prhs[0],17,0,ROWDIM))
    mexErrMsgTxt("mspa requires that the argument is a 17 x n matrix.");
  ncolumns = mxGetN(prhs[0]);
  argument_pointer = mxGetPr(prhs[0]);
  /* Checking argument values */
  for (ii=0;ii<ncolumns;ii++) {
    /* Code helpful for debugging */
    /*
    printf("year          : %10.10f\n", argument_pointer[0+ii*17]);
    printf("month         : %10.10f\n", argument_pointer[1+ii*17]);
    printf("day           : %10.10f\n", argument_pointer[2+ii*17]);
    printf("hour          : %10.10f\n", argument_pointer[3+ii*17]);
    printf("minut         : %10.10f\n", argument_pointer[4+ii*17]);
    printf("second        : %10.10f\n", argument_pointer[5+ii*17]);
    printf("timezone      : %10.10f\n", argument_pointer[6+ii*17]);
    printf("delta_t       : %10.10f\n", argument_pointer[7+ii*17]);
    printf("longitude     : %10.10f\n", argument_pointer[8+ii*17]);
    printf("latitude      : %10.10f\n", argument_pointer[9+ii*17]);
    printf("elevation     : %10.10f\n", argument_pointer[10+ii*17]);
    printf("pressure      : %10.10f\n", argument_pointer[11+ii*17]);
    printf("temperature   : %10.10f\n", argument_pointer[12+ii*17]);
    printf("slope         : %10.10f\n", argument_pointer[13+ii*17]);
    printf("azm_rotation  : %10.10f\n", argument_pointer[14+ii*17]);
    printf("atmos_refract : %10.10f\n", argument_pointer[15+ii*17]);
    printf("function      : %10.10f\n", argument_pointer[16+ii*17]);
    printf("\n");
    */
    if (exCheckArgumentValueOutsideRange(argument_pointer[0+ii*17],-2000,6000))
      mexErrMsgTxt("Argument year outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[1+ii*17],1,12))
      mexErrMsgTxt("Argument month outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[2+ii*17],1,31))
      mexErrMsgTxt("Argument day outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[3+ii*17],0,24))
      mexErrMsgTxt("Argument hour outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[4+ii*17],0,59))
      mexErrMsgTxt("Argument minute outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[5+ii*17],0,59))
      mexErrMsgTxt("Argument second outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[6+ii*17],-18,18))
      mexErrMsgTxt("Argument timezone outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[7+ii*17],-8000,8000))
      mexErrMsgTxt("Argument delta_t outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[8+ii*17],-180,180))
      mexErrMsgTxt("Argument longitude outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[9+ii*17],-90,90))
      mexErrMsgTxt("Argument latitude outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[10+ii*17],-6500000,6500000))
      mexErrMsgTxt("Argument elevation outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[11+ii*17],0,5000))
      mexErrMsgTxt("Argument pressure outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[12+ii*17],-273,6000))
      mexErrMsgTxt("Argument temperature outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[13+ii*17],-360,360))
      mexErrMsgTxt("Argument slope outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[14+ii*17],-360,360))
      mexErrMsgTxt("Argument azm_rotation outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[15+ii*17],-5,5))
      mexErrMsgTxt("Argument atmos_refract outside valid range.");
    else if (exCheckArgumentValueOutsideRange(argument_pointer[16+ii*17],0,3))
      mexErrMsgTxt("Argument function outside valid range.");
  }

  /* Creating a matrix for the result and getting its pointer. */
  plhs[0] = mxCreateDoubleMatrix(13,ncolumns,mxREAL);
  result_pointer = (double *)mxGetPr(plhs[0]);

  /* Calculate for each column in the argument matrix */
  for (ii=0;ii<ncolumns;ii++) {
    spa.year          = argument_pointer[0+ii*17];
    spa.month         = argument_pointer[1+ii*17];
    spa.day           = argument_pointer[2+ii*17];
    spa.hour          = argument_pointer[3+ii*17];
    spa.minute        = argument_pointer[4+ii*17];
    spa.second        = argument_pointer[5+ii*17];
    spa.timezone      = argument_pointer[6+ii*17];
    spa.delta_t       = argument_pointer[7+ii*17];
    spa.longitude     = argument_pointer[8+ii*17];
    spa.latitude      = argument_pointer[9+ii*17];
    spa.elevation     = argument_pointer[10+ii*17];
    spa.pressure      = argument_pointer[11+ii*17];
    spa.temperature   = argument_pointer[12+ii*17];
    spa.slope         = argument_pointer[13+ii*17];
    spa.azm_rotation  = argument_pointer[14+ii*17];
    spa.atmos_refract = argument_pointer[15+ii*17];
    if (argument_pointer[16+ii*17] == 0)
      spa.function = SPA_ZA;
    else if (argument_pointer[16+ii*17] == 1)
      spa.function = SPA_ZA_INC;
    else if (argument_pointer[16+ii*17] == 2)
      spa.function = SPA_ZA_RTS;
    else if (argument_pointer[16+ii*17] == 3)
      spa.function = SPA_ALL;
    /* Setting values in spa struct from arguments. */
    /* Calling spa to calculate results. */
    result = spa_calculate(&spa);
    if (result == 1)
      mexErrMsgTxt("spa_calculate returned error code 1 : year outside of valid range");
    else if (result == 2)
      mexErrMsgTxt("spa_calculate returned error code 2 : month outside of valid range");
    else if (result == 3)
      mexErrMsgTxt("spa_calculate returned error code 3 : day outside of valid range");
    else if (result == 4)
      mexErrMsgTxt("spa_calculate returned error code 4 : hour outside of valid range");
    else if (result == 5)
      mexErrMsgTxt("spa_calculate returned error code 5 : minute outside of valid range");
    else if (result == 6)
      mexErrMsgTxt("spa_calculate returned error code 6 : second outside of valid range");
    else if (result == 7)
      mexErrMsgTxt("spa_calculate returned error code 7 : delta_t outside of valid range");
    else if (result == 8)
      mexErrMsgTxt("spa_calculate returned error code 8 : timezone outside of valid range");
    else if (result == 9)
      mexErrMsgTxt("spa_calculate returned error code 9 : longitude outside of valid range");
    else if (result == 10)
      mexErrMsgTxt("spa_calculate returned error code 10 : latitude outside of valid range");
    else if (result == 11)
      mexErrMsgTxt("spa_calculate returned error code 11 : elevation outside of valid range");
    else if (result == 12)
      mexErrMsgTxt("spa_calculate returned error code 12 : pressure outside of valid range");
    else if (result == 13)
      mexErrMsgTxt("spa_calculate returned error code 13 : temperature outside of valid range");
    else if (result == 14)
      mexErrMsgTxt("spa_calculate returned error code 14 : slope outside of valid range");
    else if (result == 15)
      mexErrMsgTxt("spa_calculate returned error code 15 : azm_rotation outside of valid range");
    else if (result == 16)
      mexErrMsgTxt("spa_calculate returned error code 16 : atmos_refract outside of valid range");
    /* Copying results from struct spa to resulting matrix */
    result_pointer[0+ii*13]  = spa.jd;
    result_pointer[1+ii*13]  = spa.l;
    result_pointer[2+ii*13]  = spa.b;
    result_pointer[3+ii*13]  = spa.r;
    result_pointer[4+ii*13]  = spa.h;
    result_pointer[5+ii*13]  = spa.del_psi;
    result_pointer[6+ii*13]  = spa.del_epsilon;
    result_pointer[7+ii*13]  = spa.epsilon;
    result_pointer[8+ii*13]  = spa.zenith;
    result_pointer[9+ii*13]  = spa.azimuth;
    result_pointer[10+ii*13] = spa.incidence;
    result_pointer[11+ii*13] = spa.sunrise;
    result_pointer[12+ii*13] = spa.sunset;
  }
}
