/**************************************************************************
 *
 * function [P,UV,TRI]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 *
 * 在常规网格中的参数值处评估NURBS曲面
 * （参见例如plotNURBS.m）
 *
 * 在Matlab中的用法:
 *
 * P=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 * [P,UV]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 * [P,UV,TRI]=nrbSrfRegularEvalIGES(nurbs,umin,umax,nu,vmin,vmax,nv)
 *
 * 输入:
 * nurbs - NURBS 结构
 * umin - u的最小值
 * umax - u的最大值
 * nu - u的个数
 * vmin - v的最小值
 * vmax - v的最大值
 * nv - v的个数
 *
 * 输出:
 * P - 积分（评估NURBS）
 * UV - P的参数值
 * TRI - 常规网格的三角测量
 *
 *
 * 在Matlab中使用命令“mex nrbSrfRegularEvalIGES.c”编译
 *
 * 有关详细信息，请参阅“help mex”
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
    
    if (nrhs==7){//7个输入参数，对应第一种情况
        
        if (nlhs==0){
            mexErrMsgTxt("Wrong number of inputs or outputs.");
        }
        
        numu = (int)mxGetScalar(nu);//获得输入变量nu（prhs[3]）
        numv = (int)mxGetScalar(nv);
        
        if (numu<2 || numv<2){
            mexErrMsgTxt("nu and nv must be >1");
        } 
        
        intu=numu-1;//参数域区间个数
        intv=numv-1;
        
        u0=mxGetScalar(umin);
        v0=mxGetScalar(vmin);
        
        deltau=(mxGetScalar(umax)-u0)/((double)intu);
        deltav=(mxGetScalar(vmax)-v0)/((double)intv);
        
        if (deltau<0 || deltav<0){
            mexErrMsgTxt("umin<=umax and vmin<=vmax are not both true");
        }
        
        evaluated_points = mxCreateDoubleMatrix(3, numu*numv, mxREAL);
        //创建一个未赋值的3行，numu*numv列的实双精度矩阵
        //////////////////////////////////
        NURBSsurfaceRegularEval((int)mxGetPr(mxGetField(nurbsstructure, 0, "order"))[0], (int)mxGetPr(mxGetField(nurbsstructure, 0, "order"))[1], mxGetPr(mxGetField(nurbsstructure, 0, "coefs")), (int)mxGetPr(mxGetField(nurbsstructure, 0, "number"))[0], (int)mxGetPr(mxGetField(nurbsstructure, 0, "number"))[1], mxGetPr(mxGetCell(mxGetField(nurbsstructure, 0, "knots"), 0)), mxGetPr(mxGetCell(mxGetField(nurbsstructure, 0, "knots"), 1)), u0, deltau, numu, v0, deltav, numv, mxGetPr(evaluated_points));
        
        if(nlhs>1){
        //需要输出第二个参数uv    
            uvregular = mxCreateDoubleMatrix(2, numu*numv, mxREAL);
            
            param=u0;
            for (i = 0; i < 2*numu; i+=2){
                mxGetPr(uvregular)[i]=param;
                mxGetPr(uvregular)[i+1]=v0;
                param+=deltau;
            }//前nu列：v=v0,u按du递增
            param=v0;
            for (j = 2*numu; j < 2*numv*numu; j+=2*numu) {
                param+=deltav;
                mxGetPr(uvregular)[j]=u0;
                mxGetPr(uvregular)[j+1]=param;
            }//后面每个nu列的第一列第一个元素均为u0,第二个元素v按dv递增
            for (j = 2*numu; j < 2*numv*numu; j+=2*numu){
                for (i = 2; i < 2*numu; i+=2){
                    mxGetPr(uvregular)[i+j]=mxGetPr(uvregular)[i];
                    mxGetPr(uvregular)[i+j+1]=mxGetPr(uvregular)[j+1];
                }
            }//最终得到两行数组，共numu*numv列，每numu列中第二个元素v不变，
			//第一个元素u递增，不同的numu列v递增
            
            if(nlhs>2){//需要输出三角剖分TRI
                
                mtri=2*intu*intv;//。。。？？？
                
                dims[0]=mtri;
                dims[1]=3;
                
                triDomain = mxCreateNumericArray(2, dims, mxUINT32_CLASS, mxREAL);
                //创建一个2维阵列，第一维2*numu*numv个元素，第二维3个元素
				ptri = mxGetData(triDomain);//获得阵列的指针
                
                for (j = 0; j < intv; j++){
                    myint=j*intu;//前j行参数区间的网格数
                    myint2=j*numu;//前j行参数区间的节点数
                    for (i = 0; i < intu; i++){
                        myint3=2*(myint+i);//。。。？？？
                        
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
    else if (nrhs==6){//6个输入参数
        
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
        
        if(nlhs>1){//需要输出tri
            
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
