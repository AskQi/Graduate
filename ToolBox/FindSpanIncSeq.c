unsigned short int FindSpanIncSeq(unsigned short int n, double u, double *U, unsigned short int PrevSpan) {
    /*算法 A2.1 (有部分修改), L.Piegl 和 W. Tiller 的 NURBS 书籍*/
    /* 确定结跨度指数 */
    /* 输入: n,u,U */
    /* 输出: 结跨度指数 */
    
    unsigned short int low, high, mid;
    
    if (u < U[PrevSpan+1]){
        return(PrevSpan);
    }
    else if (u < U[PrevSpan+2]){
        return(PrevSpan+1);
    }
    else if (u >= U[n-1]){
        return(n-1);
    }
    else {
        low = PrevSpan+2;
        high = n-1;
        mid =(low+high)/2;
        while (u < U[mid] || u >= U[mid+1]) {
            if (u < U[mid]){
                high = mid;
            }
            else{
                low = mid+1;
            }
            mid =(low+high)/2;
        }
        return(mid);
    }
    
}
