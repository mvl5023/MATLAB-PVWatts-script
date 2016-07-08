/*
  This is the file mspa.h

  This file provides a set of macro functions for checking arguments to a
  MEX-file.

  $Id: mspa.h 91 2011-08-23 16:55:42Z abel $

  mspa.h is Copyright (C) 2011 Anders Lennartsson
  All rights reserved.

  mspa.h is Licensed by the Modified BSD License.

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

#define max(A, B)       ((A) > (B) ? (A) : (B))
#define min(A, B)       ((A) < (B) ? (A) : (B))

/* Function prototypes */
static int exCheckArgumentValueOutsideRange(double, double, double);
static int exCheckArgument(const mxArray *, int, int, int);

/* Function to check whether value of scalar argument is outside of range */
static int exCheckArgumentValueOutsideRange(double value, double minval, double maxval)
{
  return ( (value < minval) || (value > maxval) );
}

/* Function prototypes */
enum {
  SWAPDIMS,     // 
  EXACTDIMS,    // 
  ROWDIM,       // 
  COLDIM,       // 
  VECTORCHECK,  // 
  ANYDIMSIZE,   // 
  MBYNBYP       // 
};

/* Function to check dimensions of matrix argument */
static int exCheckArgument(const mxArray *array_ptr, int cm, int cn, int mxf)
{
  int m, n;
  m = mxGetM(array_ptr);
  n = mxGetN(array_ptr);
  /* checking for array of size cm x cn x p */
  if (mxf==MBYNBYP)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>3) ||
	    (m!=cm) || (mxGetDimensions(array_ptr)[1]!=cn));
  /* real double of any dimension and size */
  else if (mxf==ANYDIMSIZE)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) || !mxIsDouble(array_ptr));
  /* vector of arbitrary length */
  else if (mxf==VECTORCHECK)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>2) ||
	    ((m>1) && (n>1)) );
  /* checking for m x cn matrix, n=cn */
  else if (mxf==COLDIM)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>2) ||
	    (n != cn));
  /* checking for cm x n matrix, m=cm */
  else if (mxf==ROWDIM)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>2) ||
	    (m != cm));
  /* checking for cm x cn matrix, m=cm && n=cn */
  else if (mxf==EXACTDIMS)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>2) ||
	    (m != cm) || (n != cn));
  /* checking for cm x cn or cn x cm matrix, cm=m and cn=n || cm=n and cn=m */
  else if (mxf==SWAPDIMS)
    return (!mxIsNumeric(array_ptr) || mxIsComplex(array_ptr) ||
	    !mxIsDouble(array_ptr) || (mxGetNumberOfDimensions(array_ptr)>2) ||
	    (max(m,n) != max(cm,cn)) || (min(m,n) != min(cm,cn)));
  else
    return 1;
}
