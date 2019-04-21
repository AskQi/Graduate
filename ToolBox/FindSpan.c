
unsigned short int FindSpan(unsigned short int n, unsigned short int p, double u, double *U) {
    /* 算法 A2.1 (有部分修改), L.Piegl 和 W. Tiller 的 NURBS 书籍*/
    /* 确定结跨度指数 */
    /* 输入: n,p,u,U */
    /* 返回: 结跨度指数 */
    
    unsigned short int low, high, mid;
    
    if (u >= U[n-1]){
        return(n-1);
    }
    else if (u < U[p+1]){
        return(p);
    }
    else if ((n-p)==3){
        return(p+1);
    }
    else {
        low = p+1;
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
