function [spline2BezierCrvMat,spline2BezierSrfMat]=matrixSpline2Bezier()

basisMat=zeros(4);

basisMat(1,1)=1;
basisMat(2,1)=-3;
basisMat(3,1)=3;
basisMat(4,1)=-1;
basisMat(1,2)=0;
basisMat(2,2)=3;
basisMat(3,2)=-6;
basisMat(4,2)=3;
basisMat(1,3)=0;
basisMat(2,3)=0;
basisMat(3,3)=3;
basisMat(4,3)=-3;
basisMat(1,4)=0;
basisMat(2,4)=0;
basisMat(3,4)=0;
basisMat(4,4)=1;

spline2BezierCrvMat=inv(basisMat');

A=zeros(16);

row=0;
for j=1:4
    for i=1:4
        row=row+1;
        col=0;
        for jj=1:4
            for ii=1:4
                col=col+1;
                if row<=col
                    A(row,col)=basisMat(ii,i)*basisMat(jj,j);
                end
            end
        end
    end
end

spline2BezierSrfMat=inv(A);