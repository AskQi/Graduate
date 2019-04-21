
void BasisFuns(unsigned short int i, double u, unsigned short int p, double *U, double *N, double *left, double *right) {
    /* 算法 A2.1 (有部分修改), L.Piegl 和 W. Tiller 的 NURBS 书籍 */
    /* 计算非万能基础功能 */
    /* 输入: i,u,p,U */
    /* 输出: N */
    
    unsigned short int j, r;
    double saved, temp;
    
    N[0] = 1.0;
    
    for (j = 1; j <= p; j++) {
        left[j]  = u - U[i+1-j];
        right[j] = U[i+j] - u;
        
        temp = N[0] / (right[1] + left[j]);
        N[0] = right[1] * temp;
        saved = left[j] * temp;
        
        for (r = 1; r < j; r++) {
            temp = N[r] / (right[r+1] + left[j-r]);
            N[r] = saved + right[r+1] * temp;
            saved = left[j-r] * temp;
        }
        N[j] = saved;
    }
    
}
