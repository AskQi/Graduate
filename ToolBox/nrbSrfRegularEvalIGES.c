/**************************************************************************
 *
 * function [P,UV,TRI]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 *
 * �ڳ��������еĲ���ֵ������NURBS����
 * ���μ�����plotNURBS.m��
 *
 * ��Matlab�е��÷�:
 *
 * P=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 * [P,UV]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 * [P,UV,TRI]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 *
 * ����:
 * nurbs - NURBS �ṹ
 * umin - u����Сֵ
 * umax - u�����ֵ
 * nu - u�ĸ���
 * vmin - v����Сֵ
 * vmax - v�����ֵ
 * nv - v�ĸ���
 *
 * ���:
 * P - ���֣�����NURBS��
 * UV - P�Ĳ���ֵ
 * TRI - ������������ǲ���
 *
 *
 * ��Matlab��ʹ�����mex nrbSrfRegularEvalIGES.c������
 *
 * �й���ϸ��Ϣ������ġ�help mex��
 *
 **************************************************************************/

#include <math.h>
#include "mex.h"

#if !defined(MAX)
#define	MAX(A, B)	((A) > (B) ? (A) : (B))
#endif

#if !defined(MIN)
#define	MIN(A, B)	((A) < (B) ? (A) : (B))
#endif

#define mwSize long long unsigned int
/* Alternative 1 */

/* Input Arguments */

#define	nurbsstructure	prhs[0]
#define umin	prhs[1]
#define	umax	prhs[2]
#define nu	prhs[3]
#define vmin	prhs[4]
#define	vmax	prhs[5]
#define nv	prhs[6]

/* Output Arguments */

#define	evaluated_points	plhs[0]
#define	uvregular	plhs[1]
#define	triDomain	plhs[2]


/* Alternative 2 *///no nurbs structure input

/* Input Arguments */

#define uIImin	prhs[0]
#define	uIImax	prhs[1]
#define nIIu	prhs[2]
#define vIImin	prhs[3]
#define	vIImax	prhs[4]
#define nIIv	prhs[5]

/* Output Arguments */

#define	uvIIregular	plhs[0]
#define	triIIDomain	plhs[1]


/* Sub functions (in folder "mexSourceFiles") */

#include "FindSpan.c"
#include "FindSpanIncSeq.c"
#include "BasisFuns.c"
#include "NURBSsurfaceRegularEval.c"

/* Main function */

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    
    int i, j, intu, intv, myint, myint2, myint3;
    int numu, numv;
    double u0, v0, deltau, deltav,param;
    unsigned int *ptri=NULL;
    int dims[2], mtri;
    
    if (nrhs==7){//7�������������Ӧ��һ�����
        
        if (nlhs==0){
            mexErrMsgTxt("Wrong number of inputs or outputs.");
        }
        
        numu = (int)mxGetScalar(nu);//����������nu��prhs[3]��
        numv = (int)mxGetScalar(nv);
        
        if (numu<2 || numv<2){
            mexErrMsgTxt("nu and nv must be >1");
        } 
        
        intu=numu-1;//�������������
        intv=numv-1;
        
        u0=mxGetScalar(umin);
        v0=mxGetScalar(vmin);
        
        deltau=(mxGetScalar(umax)-u0)/((double)intu);
        deltav=(mxGetScalar(vmax)-v0)/((double)intv);
        
        if (deltau<0 || deltav<0){
            mexErrMsgTxt("umin<=umax and vmin<=vmax are not both true");
        }
        
        evaluated_points = mxCreateDoubleMatrix(3, numu*numv, mxREAL);
        //����һ��δ��ֵ��3�У�numu*numv�е�ʵ˫���Ⱦ���
        //////////////////////////////////
        NURBSsurfaceRegularEval((int)mxGetPr(mxGetField(nurbsstructure, 0, "order"))[0], (int)mxGetPr(mxGetField(nurbsstructure, 0, "order"))[1], mxGetPr(mxGetField(nurbsstructure, 0, "coefs")), (int)mxGetPr(mxGetField(nurbsstructure, 0, "number"))[0], (int)mxGetPr(mxGetField(nurbsstructure, 0, "number"))[1], mxGetPr(mxGetCell(mxGetField(nurbsstructure, 0, "knots"), 0)), mxGetPr(mxGetCell(mxGetField(nurbsstructure, 0, "knots"), 1)), u0, deltau, numu, v0, deltav, numv, mxGetPr(evaluated_points));
        
        if(nlhs>1){
        //��Ҫ����ڶ�������uv    
            uvregular = mxCreateDoubleMatrix(2, numu*numv, mxREAL);
            
            param=u0;
            for (i = 0; i < 2*numu; i+=2){
                mxGetPr(uvregular)[i]=param;
                mxGetPr(uvregular)[i+1]=v0;
                param+=deltau;
            }//ǰnu�У�v=v0,u��du����
            param=v0;
            for (j = 2*numu; j < 2*numv*numu; j+=2*numu) {
                param+=deltav;
                mxGetPr(uvregular)[j]=u0;
                mxGetPr(uvregular)[j+1]=param;
            }//����ÿ��nu�еĵ�һ�е�һ��Ԫ�ؾ�Ϊu0,�ڶ���Ԫ��v��dv����
            for (j = 2*numu; j < 2*numv*numu; j+=2*numu){
                for (i = 2; i < 2*numu; i+=2){
                    mxGetPr(uvregular)[i+j]=mxGetPr(uvregular)[i];
                    mxGetPr(uvregular)[i+j+1]=mxGetPr(uvregular)[j+1];
                }
            }//���յõ��������飬��numu*numv�У�ÿnumu���еڶ���Ԫ��v���䣬
			//��һ��Ԫ��u��������ͬ��numu��v����
            
            if(nlhs>2){//��Ҫ��������ʷ�TRI
                
                mtri=2*intu*intv;//������������
                
                dims[0]=mtri;
                dims[1]=3;
                
                triDomain = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
                //����һ��2ά���У���һά2*numu*numv��Ԫ�أ��ڶ�ά3��Ԫ��
				ptri = mxGetData(triDomain);//������е�ָ��
                
                for (j = 0; j < intv; j++){
                    myint=j*intu;//ǰj�в��������������
                    myint2=j*numu;//ǰj�в�������Ľڵ���
                    for (i = 0; i < intu; i++){
                        myint3=2*(myint+i);//������������
                        
                        ptri[myint3]=myint2+numu+i+1;
                        ptri[myint3+1]=myint2+i+2;
                        
                        ptri[myint3+mtri]=myint2+i+2;
                        ptri[myint3+1+mtri]=myint2+numu+i+1;
                        
                        ptri[myint3+2*mtri]=myint2+i+1;
                        ptri[myint3+1+2*mtri]=myint2+numu+i+2;
                    }
                }
                
            }
        }
        
    }
    else if (nrhs==6){//6���������
        
        if (nlhs==0){
            mexErrMsgTxt("Wrong number of inputs or outputs.");
        }
        
        numu = (int)mxGetScalar(nIIu);
        numv = (int)mxGetScalar(nIIv);
        
        if (numu<2 || numv<2){
            mexErrMsgTxt("nu and nv must be >1");
        }
        
        intu=numu-1;
        intv=numv-1;
        
        u0=mxGetScalar(uIImin);
        v0=mxGetScalar(vIImin);
        
        deltau=(mxGetScalar(uIImax)-u0)/((double)intu);
        deltav=(mxGetScalar(vIImax)-v0)/((double)intv);
        
        if (deltau<0 || deltav<0){
            mexErrMsgTxt("umin<=umax and vmin<=vmax are not both true");
        }
        
        uvIIregular = mxCreateDoubleMatrix(2, numu*numv, mxREAL);
        
        param=u0;
        for (i = 0; i < 2*numu; i+=2){
            mxGetPr(uvIIregular)[i]=param;
            mxGetPr(uvIIregular)[i+1]=v0;
            param+=deltau;
        }
        param=v0;
        for (j = 2*numu; j < 2*numv*numu; j+=2*numu){
            param+=deltav;
            mxGetPr(uvIIregular)[j]=u0;
            mxGetPr(uvIIregular)[j+1]=param;
        }
        for (j = 2*numu; j < 2*numv*numu; j+=2*numu){
            for (i = 2; i < 2*numu; i+=2){
                mxGetPr(uvIIregular)[i+j]=mxGetPr(uvIIregular)[i];
                mxGetPr(uvIIregular)[i+j+1]=mxGetPr(uvIIregular)[j+1];
            }
        }
        
        if(nlhs>1){//��Ҫ���tri
            
            mtri=2*intu*intv;
            
            dims[0]=mtri;
            dims[1]=3;
            
            triIIDomain = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
            ptri = mxGetData(triIIDomain);
            
            for (j = 0; j < intv; j++){
                myint=j*intu;
                myint2=j*numu;
                for (i = 0; i < intu; i++){
                    myint3=2*(myint+i);
                    
                    ptri[myint3]=myint2+numu+i+1;
                    ptri[myint3+1]=myint2+i+2;
                    
                    ptri[myint3+mtri]=myint2+i+2;
                    ptri[myint3+1+mtri]=myint2+numu+i+1;
                    
                    ptri[myint3+2*mtri]=myint2+i+1;
                    ptri[myint3+1+2*mtri]=myint2+numu+i+2;
                }
            }
            
        }
        
    }
    else {
        
        mexErrMsgTxt("Wrong number of inputs or outputs.");
        
    }
    
}
