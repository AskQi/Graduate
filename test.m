clear;
clc;
n=[1.2990 0.7500 0]';
N=[1.2990 2.7607 7.2254]';
O=[0 14.7376 0]';
R1=n-O;
R2=N-O;
theta=subspace(R1,R2);
R=[];
R=[R1,R];
X=[];
W=cross(R1,R2);
th=linspace(0,theta,100);
dt=(th(2)-th(1))/norm(W);
for m=1:length(th)
    Rota=R(:,end)+cross(W,R(:,end))*dt;
    R=[R,Rota];
    X=[X,O+Rota];
end
X=[n,X,N];
plot3(X(1,:),X(2,:),X(3,:));
hold on
plot3(n(1),n(2),n(3),'r.');
hold on
plot3(N(1),N(2),N(3),'r.');
hold on
plot3(O(1),O(2),O(3),'r.');