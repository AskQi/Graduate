static void NURBSsurfaceRegularEval(int orderU, int orderV, double *cp, int ncp, int kcp, double *knotU, double *knotV, double u0, double deltau, unsigned int numu, double v0, double deltav, unsigned int numv, double *ep){
    
    /* 以给定的常规参数值评估NURBS曲面 */
    
    /* NURBSsurfaceRegularEval( orderU - u中NURBS的顺序, orderV -  v中NURBS的顺序, cp - 控制点指针, ncp - u中控制点数, kcp - v中控制点数, knotU - u中的结序列, knotV - v，u0中的结序列, u0 - 第一个u, deltau - u中的间距, numu - u的数量, v0 - 第一个v, deltav - v中的间距, numv - v的数量, ep - 指向评估点的指针 ) */
    
    unsigned short int i, j, ii, jj, indi, indj, indi2, indj2, myint, myint2;
    unsigned short int numuMinusOne, numvMinusOne, ncpMinusOne, kcpMinusOne, fourncp, fourncpMinusFour;
    unsigned short int degU, degV, *spanArray, sdU, spanScalar, sdV;
    unsigned int epind, ind;
    double *left, *right, *N, *Npoly;
    double utmp, vtmp, wgh, NN;
    char uBounds, vBounds;
    
    numuMinusOne=numu-1;
    numvMinusOne=numv-1;
    
    ncpMinusOne=ncp-1;
    kcpMinusOne=kcp-1;
    
    degU=orderU-1;
    degV=orderV-1;
    
    if (u0<(knotU[degU]+ 1e-12) && (u0+numuMinusOne*deltau)>(knotU[ncp]-1e-12)){//u0<uk&&u(n+k+1)>u(n+1)
        uBounds=1;//满足参数范围？
    }
    else {
        uBounds=0;
    }
    
    if (v0<(knotV[degV]+1e-12) && (v0+numvMinusOne*deltav)>(knotV[kcp]-1e-12)){
        vBounds=1;
    }
    else {
        vBounds=0;
    }
    
    myint=MAX(orderU, orderV);
    left  = (double*) malloc(myint*sizeof(double)+1);//malloc用于分配内存：myint个double单元+1（返回分配的内存区域指针）
    right = (double*) malloc(myint*sizeof(double)+1);
    
    fourncp=4*ncp;
    fourncpMinusFour=fourncp-4;
    
    if ((numu*orderU*sizeof(double)+numu*sizeof(int)+orderV*sizeof(double))<(numv*orderV*sizeof(double)+numv*sizeof(int)+orderU*sizeof(double))){
        
        N = (double*) malloc(orderV*sizeof(double)+1);
        
        spanArray  = (unsigned short *) malloc(numu*sizeof(unsigned short)+1);//u向节点序列内存指针
        Npoly = (double*) malloc(numu*orderU*sizeof(double)+1);//基函数内存？每一个u值对应k+1个递推基函数？
        
        
        if (uBounds && vBounds){
            
            spanArray[0] = degU;//次数（参数域下标初始化？）u的起始下标,从uk开始？？
            sdU = 0;
            
            ep[0]=cp[0]/cp[3];//第一个控制点的笛卡尔坐标
            ep[1]=cp[1]/cp[3];
            ep[2]=cp[2]/cp[3];
            
            utmp=u0;
            
            for (ii = 1; ii < numuMinusOne; ii++){//ii从1取到n+k???去掉首末端点的参数域？
                
                epind=3*ii;//？？？？？？？？
                indi2=ii*orderU;
                
                utmp+=deltau;
                spanArray[ii] = FindSpanIncSeq(ncp, utmp, knotU, spanArray[ii-1]);//knot为u向节点序列的指针
				//递推得到第i个u的下标（二分法）？？？？为什么spanArray为short型而非int型？？？？？
                BasisFuns(spanArray[ii], utmp, degU, knotU, &Npoly[indi2], left, right);
                //返回基函数N
                spanArray[ii-1]=sdU;
                sdU=spanArray[ii]-degU;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(sdU+j);
                    indj2=indi2+j;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numu-2]=sdU;
            
            epind=3*numuMinusOne;
            
            indj=fourncp-1;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
            spanScalar = degV;
            vtmp=v0;
            
            for (jj = 1; jj < numvMinusOne; jj++){
                
                vtmp+=deltav;
                spanScalar = FindSpanIncSeq(kcp, vtmp, knotV, spanScalar);
                BasisFuns(spanScalar, vtmp, degV, knotV, N, left, right);
                sdV = spanScalar - degV;
                
                ind=jj*numu;
                epind=3*ind;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*(sdV+i);
                    ep[epind] += N[i] * cp[indj];
                    ep[epind+1] += N[i] * cp[indj+1];
                    ep[epind+2] += N[i] * cp[indj+2];
                    wgh += N[i] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
                myint2=sdV*ncp;
                
                for (ii = 1; ii < numuMinusOne; ii++){
                    
                    epind=3*(ii+ind);
                    indi2=ii*orderU;
                    myint=myint2+spanArray[ii];
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = N[i] * Npoly[indi2+j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
                epind=3*(numuMinusOne+ind);
                indi=fourncp*sdV+fourncpMinusFour;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*i+indi;
                    ep[epind] += N[i] * cp[indj];
                    ep[epind+1] += N[i] * cp[indj+1];
                    ep[epind+2] += N[i] * cp[indj+2];
                    wgh += N[i] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
            ind=numvMinusOne*numu;
            epind=3*ind;
            indj=kcpMinusOne*fourncp+3;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
            myint=kcpMinusOne*ncp;
            
            for (ii = 1; ii < numuMinusOne; ii++){
                
                epind=3*(ii+ind);
                indi2=ii*orderU;
                
                wgh=0.0;
                indi=myint+spanArray[ii];
                for (j = 0; j <= degU; j++){
                    indj=4*(indi+j);
                    indj2=indi2+j;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
            epind=3*(numu*numv-1);
            indj=fourncp*kcp-1;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
        }
        else if (vBounds){
            
            spanArray[0] = FindSpan(ncp, degU, u0, knotU);
            BasisFuns(spanArray[0], u0, degU, knotU, Npoly, left, right);
            sdU=spanArray[0]-degU;
            
            wgh=0.0;
            for (j = 0; j <= degU; j++){
                indj=4*(sdU+j);
                ep[0] += Npoly[j] * cp[indj];
                ep[1] += Npoly[j] * cp[indj+1];
                ep[2] += Npoly[j] * cp[indj+2];
                wgh += Npoly[j] * cp[indj+3];
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            utmp=u0;
            
            for (ii = 1; ii < numu; ii++){
                
                epind=3*ii;
                indi2=ii*orderU;
                
                utmp+=deltau;
                spanArray[ii] = FindSpanIncSeq(ncp, utmp, knotU, spanArray[ii-1]);
                BasisFuns(spanArray[ii], utmp, degU, knotU, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdU;
                sdU=spanArray[ii]-degU;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(sdU+j);
                    indj2=indi2+j;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numuMinusOne]=sdU;
            
            spanScalar = degV;
            vtmp=v0;
            
            for (jj = 1; jj < numvMinusOne; jj++){
                
                vtmp+=deltav;
                spanScalar = FindSpanIncSeq(kcp, vtmp, knotV, spanScalar);
                BasisFuns(spanScalar, vtmp, degV, knotV, N, left, right);
                sdV = spanScalar - degV;
                ind=jj*numu;
                
                myint2=sdV*ncp;
                
                for (ii = 0; ii < numu; ii++){
                    
                    epind=3*(ii+ind);
                    indi2=ii*orderU;
                    myint=myint2+spanArray[ii];
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = N[i] * Npoly[indi2+j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
            }
            
            ind=numvMinusOne*numu;
            myint=kcpMinusOne*ncp;
            
            for (ii = 0; ii < numu; ii++){
                
                epind=3*(ii+ind);
                indi2=ii*orderU;
                
                wgh=0.0;
                indi=myint+spanArray[ii];
                for (j = 0; j <= degU; j++){
                    indj=4*(indi+j);
                    indj2=indi2+j;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
        }
        else if (uBounds){
            
            spanArray[0] = degU;
            sdU = 0;
            
            spanScalar = FindSpan(kcp, degV, v0, knotV);
            BasisFuns(spanScalar, v0, degV, knotV, N, left, right);
            sdV = spanScalar - degV;
            
            myint2=sdV*ncp;
            
            wgh=0.0;
            for (i = 0; i <= degV; i++){
                indj=fourncp*(sdV+i);
                ep[0] += N[i] * cp[indj];
                ep[1] += N[i] * cp[indj+1];
                ep[2] += N[i] * cp[indj+2];
                wgh += N[i] * cp[indj+3];
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            utmp=u0;
            
            for (ii = 1; ii < numuMinusOne; ii++){
                
                epind=3*ii;
                indi2=ii*orderU;
                
                utmp+=deltau;
                spanArray[ii] = FindSpanIncSeq(ncp, utmp, knotU, spanArray[ii-1]);
                BasisFuns(spanArray[ii], utmp, degU, knotU, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdU;
                sdU=spanArray[ii]-degU;
                
                myint=myint2+sdU;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indi=ncp*i+myint;
                    for (j = 0; j <= degU; j++){
                        indj=4*(indi+j);
                        NN = N[i] * Npoly[indi2+j];
                        ep[epind] += NN * cp[indj];
                        ep[epind+1] += NN * cp[indj+1];
                        ep[epind+2] += NN * cp[indj+2];
                        wgh += NN * cp[indj+3];
                    }
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numu-2]=sdU;
            
            epind=3*numuMinusOne;
            indi=fourncp*sdV+fourncpMinusFour;
            
            wgh=0.0;
            for (i = 0; i <= degV; i++){
                indj=fourncp*i+indi;
                ep[epind] += N[i] * cp[indj];
                ep[epind+1] += N[i] * cp[indj+1];
                ep[epind+2] += N[i] * cp[indj+2];
                wgh += N[i] * cp[indj+3];
            }
            ep[epind]=ep[epind]/wgh;
            ep[epind+1]=ep[epind+1]/wgh;
            ep[epind+2]=ep[epind+2]/wgh;
            
            vtmp=v0;
            
            for (jj = 1; jj < numv; jj++){
                
                vtmp+=deltav;
                spanScalar = FindSpanIncSeq(kcp, vtmp, knotV, spanScalar);
                BasisFuns(spanScalar, vtmp, degV, knotV, N, left, right);
                sdV = spanScalar - degV;
                ind=jj*numu;
                
                epind=3*ind;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*(sdV+i);
                    ep[epind] += N[i] * cp[indj];
                    ep[epind+1] += N[i] * cp[indj+1];
                    ep[epind+2] += N[i] * cp[indj+2];
                    wgh += N[i] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
                myint2=sdV*ncp;
                
                for (ii = 1; ii < numuMinusOne; ii++){
                    
                    epind=3*(ii+ind);
                    indi2=ii*orderU;
                    myint=myint2+spanArray[ii];
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = N[i] * Npoly[indi2+j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
                epind=3*(numuMinusOne+ind);
                indi=fourncp*sdV+fourncpMinusFour;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*i+indi;
                    ep[epind] += N[i] * cp[indj];
                    ep[epind+1] += N[i] * cp[indj+1];
                    ep[epind+2] += N[i] * cp[indj+2];
                    wgh += N[i] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
        }
        else{
            
            spanArray[0] = FindSpan(ncp, degU, u0, knotU);
            BasisFuns(spanArray[0], u0, degU, knotU, Npoly, left, right);
            sdU=spanArray[0]-degU;
            
            spanScalar = FindSpan(kcp, degV, v0, knotV);
            BasisFuns(spanScalar, v0, degV, knotV, N, left, right);
            sdV = spanScalar - degV;
            
            myint2=sdV*ncp;
            myint=myint2+sdU;
            
            wgh=0.0;
            for (i = 0; i <= degV; i++){
                indi=ncp*i+myint;
                for (j = 0; j <= degU; j++){
                    indj=4*(indi+j);
                    NN = N[i] * Npoly[j];
                    ep[0] += NN * cp[indj];
                    ep[1] += NN * cp[indj+1];
                    ep[2] += NN * cp[indj+2];
                    wgh += NN * cp[indj+3];
                }
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            utmp=u0;
            
            for (ii = 1; ii < numu; ii++){
                
                epind=3*ii;
                indi2=ii*orderU;
                
                utmp+=deltau;
                spanArray[ii] = FindSpanIncSeq(ncp, utmp, knotU, spanArray[ii-1]);
                BasisFuns(spanArray[ii], utmp, degU, knotU, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdU;
                sdU=spanArray[ii]-degU;
                
                myint=myint2+sdU;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indi=ncp*i+myint;
                    for (j = 0; j <= degU; j++){
                        indj=4*(indi+j);
                        NN = N[i] * Npoly[indi2+j];
                        ep[epind] += NN * cp[indj];
                        ep[epind+1] += NN * cp[indj+1];
                        ep[epind+2] += NN * cp[indj+2];
                        wgh += NN * cp[indj+3];
                    }
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numuMinusOne]=sdU;
            
            vtmp=v0;
            
            for (jj = 1; jj < numv; jj++){
                
                vtmp+=deltav;
                spanScalar = FindSpanIncSeq(kcp, vtmp, knotV, spanScalar);
                BasisFuns(spanScalar, vtmp, degV, knotV, N, left, right);
                sdV = spanScalar - degV;
                ind=jj*numu;
                
                myint2=sdV*ncp;
                
                for (ii = 0; ii < numu; ii++){
                    
                    epind=3*(ii+ind);
                    indi2=ii*orderU;
                    myint=myint2+spanArray[ii];
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = N[i] * Npoly[indi2+j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
            }
            
        }
        
    }
    else{
        
        N = (double*) malloc(orderU*sizeof(double)+1);

        spanArray  = (unsigned short *) malloc(numv*sizeof(unsigned short)+1);
        Npoly = (double*) malloc(numv*orderV*sizeof(double)+1);
        
        myint2=3*numu;
        
        if (uBounds && vBounds){
            
            spanArray[0] = degV;
            sdV = 0;
            
            ep[0]=cp[0]/cp[3];
            ep[1]=cp[1]/cp[3];
            ep[2]=cp[2]/cp[3];
            
            vtmp=v0;
            
            for (ii = 1; ii < numvMinusOne; ii++){
                
                epind=ii*myint2;
                indi2=ii*orderV;
                
                vtmp+=deltav;
                spanArray[ii] = FindSpanIncSeq(kcp, vtmp, knotV, spanArray[ii-1]);
                BasisFuns(spanArray[ii], vtmp, degV, knotV, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdV;
                sdV=spanArray[ii]-degV;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*(sdV+i);
                    indj2=indi2+i;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numv-2]=sdV;
            
            epind=numvMinusOne*myint2;
            
            indj=fourncp*kcpMinusOne+3;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
            spanScalar = degU;
            utmp=u0;
            
            for (jj = 1; jj < numuMinusOne; jj++){
                
                utmp+=deltau;
                spanScalar = FindSpanIncSeq(ncp, utmp, knotU, spanScalar);
                BasisFuns(spanScalar, utmp, degU, knotU, N, left, right);
                sdU = spanScalar - degU;
                
                ind=3*jj;
                epind=ind;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(sdU+j);
                    ep[epind] += N[j] * cp[indj];
                    ep[epind+1] += N[j] * cp[indj+1];
                    ep[epind+2] += N[j] * cp[indj+2];
                    wgh += N[j] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
                for (ii = 1; ii < numvMinusOne; ii++){
                    
                    epind=myint2*ii+ind;
                    indi2=ii*orderV;
                    myint=sdU+spanArray[ii]*ncp;
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        indj2=indi2+i;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            ep[epind] += Npoly[indj2] * N[j] * cp[indj];
                            ep[epind+1] += Npoly[indj2] * N[j] * cp[indj+1];
                            ep[epind+2] += Npoly[indj2] * N[j] * cp[indj+2];
                            wgh += Npoly[indj2] * N[j] * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
                epind=myint2*numvMinusOne+ind;
                
                myint=sdU+kcpMinusOne*ncp;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(j+myint);
                    ep[epind] += N[j] * cp[indj];
                    ep[epind+1] += N[j] * cp[indj+1];
                    ep[epind+2] += N[j] * cp[indj+2];
                    wgh += N[j] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
            ind=3*numuMinusOne;
            epind=ind;
            indj=fourncp-1;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
            for (ii = 1; ii < numvMinusOne; ii++){
                
                epind=myint2*ii+ind;
                indi2=ii*orderV;
                
                wgh=0.0;
                indi=fourncp*spanArray[ii]+fourncpMinusFour;
                for (i = 0; i <= degV; i++){
                    indj=fourncp*i+indi;
                    indj2=indi2+i;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
            epind=3*(numu*numv-1);
            indj=fourncp*kcp-1;
            ep[epind]=cp[indj-3]/cp[indj];
            ep[epind+1]=cp[indj-2]/cp[indj];
            ep[epind+2]=cp[indj-1]/cp[indj];
            
        }
        else if (vBounds){
            
            spanArray[0] = degV;
            sdV = 0;
            
            spanScalar = FindSpan(ncp, degU, u0, knotU);
            BasisFuns(spanScalar, u0, degU, knotU, N, left, right);
            sdU = spanScalar - degU;
            
            wgh=0.0;
            for (j = 0; j <= degU; j++){
                indj=4*(sdU+j);
                ep[0] += N[j] * cp[indj];
                ep[1] += N[j] * cp[indj+1];
                ep[2] += N[j] * cp[indj+2];
                wgh += N[j] * cp[indj+3];
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            vtmp=v0;
            
            for (ii = 1; ii < numvMinusOne; ii++){
                
                epind=ii*myint2;
                indi2=ii*orderV;
                
                vtmp+=deltav;
                spanArray[ii] = FindSpanIncSeq(kcp, vtmp, knotV, spanArray[ii-1]);
                BasisFuns(spanArray[ii], vtmp, degV, knotV, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdV;
                sdV=spanArray[ii]-degV;
                
                myint=sdV*ncp+sdU;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indi=ncp*i+myint;
                    indj2=indi2+i;
                    for (j = 0; j <= degU; j++){
                        indj=4*(indi+j);
                        NN = Npoly[indj2] * N[j];
                        ep[epind] += NN * cp[indj];
                        ep[epind+1] += NN * cp[indj+1];
                        ep[epind+2] += NN * cp[indj+2];
                        wgh += NN * cp[indj+3];
                    }
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numv-2]=sdV;
            
            epind=numvMinusOne*myint2;
            indi=ncp*kcpMinusOne+sdU;
            
            wgh=0.0;
            for (j = 0; j <= degU; j++){
                indj=4*(indi+j);
                ep[epind] += N[j] * cp[indj];
                ep[epind+1] += N[j] * cp[indj+1];
                ep[epind+2] += N[j] * cp[indj+2];
                wgh += N[j] * cp[indj+3];
            }
            ep[epind]=ep[epind]/wgh;
            ep[epind+1]=ep[epind+1]/wgh;
            ep[epind+2]=ep[epind+2]/wgh;
            
            utmp=u0;
            
            for (jj = 1; jj < numu; jj++){
                
                utmp+=deltau;
                spanScalar = FindSpanIncSeq(ncp, utmp, knotU, spanScalar);
                BasisFuns(spanScalar, utmp, degU, knotU, N, left, right);
                sdU = spanScalar - degU;
                
                ind=3*jj;
                
                epind=ind;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(sdU+j);
                    ep[epind] += N[j] * cp[indj];
                    ep[epind+1] += N[j] * cp[indj+1];
                    ep[epind+2] += N[j] * cp[indj+2];
                    wgh += N[j] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
                for (ii = 1; ii < numvMinusOne; ii++){
                    
                    epind=myint2*ii+ind;
                    indi2=ii*orderV;
                    myint=sdU+spanArray[ii]*ncp;
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        indj2=indi2+i;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = Npoly[indj2] * N[j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
                epind=myint2*numvMinusOne+ind;
                indi=ncp*kcpMinusOne+sdU;
                
                wgh=0.0;
                for (j = 0; j <= degU; j++){
                    indj=4*(indi+j);
                    ep[epind] += N[j] * cp[indj];
                    ep[epind+1] += N[j] * cp[indj+1];
                    ep[epind+2] += N[j] * cp[indj+2];
                    wgh += N[j] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
        }
        else if (uBounds){
            
            spanArray[0] = FindSpan(kcp, degV, v0, knotV);
            BasisFuns(spanArray[0], v0, degV, knotV, Npoly, left, right);
            sdV=spanArray[0]-degV;
            
            wgh=0.0;
            for (i = 0; i <= degV; i++){
                indj=fourncp*(sdV+i);
                ep[0] += Npoly[i] * cp[indj];
                ep[1] += Npoly[i] * cp[indj+1];
                ep[2] += Npoly[i] * cp[indj+2];
                wgh += Npoly[i] * cp[indj+3];
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            vtmp=v0;
            
            for (ii = 1; ii < numv; ii++){
                
                epind=ii*myint2;
                indi2=ii*orderV;
                
                vtmp+=deltav;
                spanArray[ii] = FindSpanIncSeq(kcp, vtmp, knotV, spanArray[ii-1]);
                BasisFuns(spanArray[ii], vtmp, degV, knotV, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdV;
                sdV=spanArray[ii]-degV;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj2=indi2+i;
                    indj=fourncp*(sdV+i);
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numvMinusOne]=sdV;
            
            spanScalar = degU;
            utmp=u0;
            
            for (jj = 1; jj < numuMinusOne; jj++){
                
                utmp+=deltau;
                spanScalar = FindSpanIncSeq(ncp, utmp, knotU, spanScalar);
                BasisFuns(spanScalar, utmp, degU, knotU, N, left, right);
                sdU = spanScalar - degU;
                
                ind=3*jj;
                
                for (ii = 0; ii < numv; ii++){
                    
                    epind=myint2*ii+ind;
                    indi2=ii*orderV;
                    myint=sdU+spanArray[ii]*ncp;
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        indj2=indi2+i;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = Npoly[indj2] * N[j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
            }
            
            ind=3*numuMinusOne;
            
            for (ii = 0; ii < numv; ii++){
                
                epind=myint2*ii+ind;
                indi2=ii*orderV;
                
                indi=fourncp*spanArray[ii]+fourncpMinusFour;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indj2=indi2+i;
                    indj=fourncp*i+indi;
                    ep[epind] += Npoly[indj2] * cp[indj];
                    ep[epind+1] += Npoly[indj2] * cp[indj+1];
                    ep[epind+2] += Npoly[indj2] * cp[indj+2];
                    wgh += Npoly[indj2] * cp[indj+3];
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            
        }
        else{
            
            spanArray[0] = FindSpan(kcp, degV, v0, knotV);
            BasisFuns(spanArray[0], v0, degV, knotV, Npoly, left, right);
            sdV=spanArray[0]-degV;
            
            spanScalar = FindSpan(ncp, degU, u0, knotU);
            BasisFuns(spanScalar, u0, degU, knotU, N, left, right);
            sdU = spanScalar - degU;
            
            myint=sdV*ncp+sdU;
            
            wgh=0.0;
            for (i = 0; i <= degV; i++){
                indi=ncp*i+myint;
                for (j = 0; j <= degU; j++){
                    indj=4*(indi+j);
                    NN = Npoly[i] * N[j];
                    ep[0] += NN * cp[indj];
                    ep[1] += NN * cp[indj+1];
                    ep[2] += NN * cp[indj+2];
                    wgh += NN * cp[indj+3];
                }
            }
            ep[0]=ep[0]/wgh;
            ep[1]=ep[1]/wgh;
            ep[2]=ep[2]/wgh;
            
            vtmp=v0;
            
            for (ii = 1; ii < numv; ii++){
                
                epind=ii*myint2;
                indi2=ii*orderV;
                
                vtmp+=deltav;
                spanArray[ii] = FindSpanIncSeq(kcp, vtmp, knotV, spanArray[ii-1]);
                BasisFuns(spanArray[ii], vtmp, degV, knotV, &Npoly[indi2], left, right);
                
                spanArray[ii-1]=sdV;
                sdV=spanArray[ii]-degV;
                
                myint=sdV*ncp+sdU;
                
                wgh=0.0;
                for (i = 0; i <= degV; i++){
                    indi=ncp*i+myint;
                    indj2=indi2+i;
                    for (j = 0; j <= degU; j++){
                        indj=4*(indi+j);
                        NN = Npoly[indj2] * N[j];
                        ep[epind] += NN * cp[indj];
                        ep[epind+1] += NN * cp[indj+1];
                        ep[epind+2] += NN * cp[indj+2];
                        wgh += NN * cp[indj+3];
                    }
                }
                ep[epind]=ep[epind]/wgh;
                ep[epind+1]=ep[epind+1]/wgh;
                ep[epind+2]=ep[epind+2]/wgh;
                
            }
            spanArray[numvMinusOne]=sdV;
            
            utmp=u0;
            
            for (jj = 1; jj < numu; jj++){
                
                utmp+=deltau;
                spanScalar = FindSpanIncSeq(ncp, utmp, knotU, spanScalar);
                BasisFuns(spanScalar, utmp, degU, knotU, N, left, right);
                sdU = spanScalar - degU;
                
                ind=3*jj;
                
                for (ii = 0; ii < numv; ii++){
                    
                    epind=myint2*ii+ind;
                    indi2=ii*orderV;
                    myint=sdU+spanArray[ii]*ncp;
                    
                    wgh=0.0;
                    for (i = 0; i <= degV; i++){
                        indi=ncp*i+myint;
                        indj2=indi2+i;
                        for (j = 0; j <= degU; j++){
                            indj=4*(indi+j);
                            NN = Npoly[indj2] * N[j];
                            ep[epind] += NN * cp[indj];
                            ep[epind+1] += NN * cp[indj+1];
                            ep[epind+2] += NN * cp[indj+2];
                            wgh += NN * cp[indj+3];
                        }
                    }
                    ep[epind]=ep[epind]/wgh;
                    ep[epind+1]=ep[epind+1]/wgh;
                    ep[epind+2]=ep[epind+2]/wgh;
                    
                }
                
            }
            
        }
        
    }
    
    free(spanArray);//释放内存，与malloc对应
    free(Npoly);
    
    free(left);
    free(right);
    free(N);
    
}
