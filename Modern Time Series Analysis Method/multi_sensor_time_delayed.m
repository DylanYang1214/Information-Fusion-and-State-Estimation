%*************************************%
%*************************************%
path(path,'C:\Documents and Settings\Administrator\����\�ִ�ʱ�����з�������')
clc;close all;clear;Bushu=100;
%*************************************%
T=1.5;
Qw=2;
Qv1=[1 0;0 1];Qv2=[2 0;0 1];Qv3=[3 1;0 1];
fai=[1 T;0 1];gama=[0.5*T^2;T];H01=[1 2;0 1];H12=[1 1;0 1];H03=[1 0;0 1];H13=[1 0;0 1];
%--------------------%
randn('seed',4);w=sqrt(Qw)*randn(1,Bushu+10);
randn('seed',1);v1=sqrt(Qv1)*randn(2,Bushu+10);
randn('seed',1);v2=sqrt(Qv2)*randn(2,Bushu+10);
randn('seed',5);v3=sqrt(Qv3)*randn(2,Bushu+10);

x(:,2)=[0;0];x(:,1)=[0;0];
y1(:,1)=v1(:,1);y1(:,2)=H01*x(:,2)+v1(:,2);
y2(:,1)=v2(:,1);y2(:,2)=H12*x(:,1)+v2(:,2);
y3(:,1)=v3(:,1);y3(:,2)=H03*x(:,2)+H13*x(:,1)+v3(:,2);
for i=3:Bushu+10
    x(:,i)=fai*x(:,i-1)+gama*w(i-1);
    y1(:,i)=H01*x(:,i)+v1(:,i);
    y2(:,i)=H12*x(:,i-1)+v2(:,i);
    y3(:,i)=H03*x(:,i)+H13*x(:,i-1)+v3(:,i);
end
%----------------sensor-1--------------%
A0=eye(2);
A1=[-1 -T;0 -1];
B0=[0;0];
B1=[0.5*T*T+2*T;T];
%--------------------%
R(1:2,1:2)=B0*Qw*B0'+B1*Qw*B1'+A0*Qv1*A0'+A1*Qv1*A1';
R(:,3:4)=B1*Qw*B0'+A1*Qv1*A0';
%*************************************%
[Qe,d]=TS_GW(Bushu,R);
%*************************************%
D1=d(1:2,199:200);Qe=Qe(1:2,199:200);
%----------����������----------%
e1(:,1)=[0;0];e1(:,2)=[0;0];
for t=3:Bushu+1
    e1(:,t)=A0*y1(:,t)+A1*y1(:,t-1)-D1*e1(:,t-1);
    v1jian(:,t)=Qv1*A0'*inv(Qe)*e1(:,t);
end
for t=3:Bushu+1
    x1jian(:,t)=inv(H01)*y1(:,t)-inv(H01)*v1jian(:,t);
end
%------------------------------%
P1(:,:,1)=0.1*eye(2);
for i=1:Bushu
%     PP1(:,:,t+1)=fai*P1(:,:,t)*fai'+gama*Qw*gama';
%     Qeps1(:,:,t+1)=H01*PP1(:,:,t+1)*H01'+Qv1;
%     k1(:,:,t+1)=(PP1(:,:,t+1)*H01')*inv(Qeps1(:,:,t+1));
%     P1(:,:,t+1)=PP1(:,:,t+1)-k1(:,:,t+1)*Qeps1(:,:,t+1)*k1(:,:,t+1)';
%     x1jian(:,t)=inv(H01)*y1(:,t)-inv(H01)*v1jian(:,t);

    PP1(:,:,i+1)=fai* P1(:,:,i)*fai'+gama*Qw*gama';%Ԥ��������
    Qeps1(:,:,i+1)=H01*PP1(:,:,i+1)*H01'+Qv1;
    k1(:,:,i+1)=PP1(:,:,i+1)*H01'*inv(Qeps1(:,:,i+1));
    P1(:,:,i+1)=(eye(2)-k1(:,:,i+1)*H01)*PP1(:,:,i+1);%�˲�������
end
t=1:Bushu;
% figure;
% subplot(2,2,1);plot(t,v1jian(1,t),'b:');
% subplot(2,2,2);plot(t,v1jian(2,t),'b:');
subplot(2,2,1);plot(t,x(1,t),'b',t,x1jian(1,t),'r:');
subplot(2,2,2);plot(t,x(2,t),'b',t,x1jian(2,t),'r:');

%----------------sensor-2--------------%
A0=eye(2);
A1=[-1 -T;0 -1];
B0=[0;0];B1=[0;0];
B2=[0.5*T*T+T;T];
%--------------------%
R(1:2,1:2)=B0*Qw*B0'+B1*Qw*B1'+B2*Qw*B2'+A0*Qv2*A0'+A1*Qv2*A1';
R(:,3:4)=B1*Qw*B0'+B2*Qw*B1'+A1*Qv2*A0';
%*************************************%
[Qe,d]=TS_GW(Bushu,R);
%*************************************%
D1=d(1:2,199:200);Qe=Qe(1:2,199:200);
%----------����������----------%
e2(:,1)=[0;0];e2(:,2)=[0;0];
for t=3:Bushu+2
    e2(:,t)=A0*y2(:,t)+A1*y2(:,t-1)-D1*e2(:,t-1);
end
for t=3:Bushu+1
    v2jian(:,t)=Qv2*A0'*inv(Qe)*e2(:,t)+Qv2*(-D1*A0+A1)'*inv(Qe)*e2(:,t+1);
end
%------------------------------%
for t=3:Bushu+1
    x2jian(:,t)=inv(H12)*y2(:,t)-inv(H12)*v2jian(:,t);
end
%------------------------------%
P2(:,:,1)=0.1*eye(2);
for i=1:Bushu
%     PP2(:,:,t+1)=fai*P2(:,:,t)*fai'+gama*Qw*gama';
%     Qeps2(:,:,t+1)=H12*P2(:,:,t)*H12'+Qv2;
%     k2(:,:,t+1)=(P2(:,:,t)*H12')*inv(Qeps2(:,:,t+1));
%     P2(:,:,t+1)=PP2(:,:,t+1)-k2(:,:,t+1)*Qeps2(:,:,t+1)*k2(:,:,t+1)';
%     x2jian(:,t)=inv(H12)*y2(:,t)-inv(H12)*v2jian(:,t);
    PP2(:,:,i+1)=fai* P2(:,:,i)*fai'+gama*Qw*gama';%Ԥ��������
    Qeps2(:,:,i+1)=(H12*inv(fai))*PP2(:,:,i+1)*(H12*inv(fai))'+(H12*inv(fai)*gama)*Qw*(H12*inv(fai)*gama)'+Qv2;
    k2(:,:,i+1)=(PP2(:,:,i+1)*(inv(fai))'*H12')*inv(Qeps2(:,:,i+1));
    P2(:,:,i+1)=(fai-k2(:,:,i+1)*H12)*P2(:,:,i)*(fai-k2(:,:,i+1)*H12)'+k2(:,:,i+1)*Qv2*k2(:,:,i+1)'+gama*Qw*gama';%�˲�������
end
t=1:Bushu;
figure;
% subplot(2,2,1);plot(t,v2jian(1,t),'b:');
% subplot(2,2,2);plot(t,v2jian(2,t),'b:');
subplot(2,2,1);plot(t,x(1,t),'b',t,x2jian(1,t),'r:');
subplot(2,2,2);plot(t,x(2,t),'b',t,x2jian(2,t),'r:');
%----------------sensor-3--------------%
A0=eye(2);
A1=[-1 -T;0 -1];
B0=[0;0];
B1=[0.5*T*T;T];
B2=[0.5*T*T;T];
%--------------------%
R(1:2,1:2)=B0*Qw*B0'+B1*Qw*B1'+B2*Qw*B2'+A0*Qv3*A0'+A1*Qv3*A1';
R(:,3:4)=B1*Qw*B0'+B2*Qw*B1'+A1*Qv3*A0';
% R(:,5:6)=B2*Qw*B0';    %R(:,5:6)=0
%*************************************%
[Qe,d]=TS_GW(Bushu,R);
%*************************************%
D1=d(1:2,199:200);Qe=Qe(1:2,199:200);
%----------����������----------%
e3(:,1)=[0;0];e3(:,2)=[0;0];
for t=3:Bushu+2
    e3(:,t)=A0*y3(:,t)+A1*y3(:,t-1)-D1*e3(:,t-1);
end
for t=3:Bushu+1
    v3jian(:,t)=Qv3*A0'*inv(Qe)*e3(:,t)+Qv3*(-D1*A0+A1)'*inv(Qe)*e3(:,t+1);
    w3jian(t)=Qw*B0'*inv(Qe)*e3(:,t);
end
%------------------------------%
for t=3:Bushu+1
    x3jian(:,t)=inv(H03*fai+H13)*y3(:,t)-inv(H03*fai+H13)*v3jian(:,t);
end
%------------------------------%
P3(:,:,1)=0.1*eye(2);
for i=1:Bushu
%     PP3(:,:,t+1)=fai* P3(:,:,t)*fai'+gama*Qw*gama';
%     Qeps3(:,:,t+1)=H03*PP3(:,:,t+1)*H03'+H13*P3(:,:,t)*H13'+H03*fai*P3(:,:,t)*H13'+H13*P3(:,:,t)*fai'*H03'+Qv3;
%     %k3(:,:,t+1)=(PP3(:,:,t+1)*H03'+P3(:,:,t)*H13')*inv(Qeps3(:,:,t+1));
%     k3(:,:,t+1)=(PP3(:,:,t)*H03'+PP3(:,:,t)*H13')*inv(Qeps3(:,:,t+1));
%     P3(:,:,t+1)=PP3(:,:,t+1)-k3(:,:,t+1)*Qeps3(:,:,t+1)*k3(:,:,t+1)';
%     x3jian(:,t)=inv(H03*fai+H13)*y3(:,t)-inv(H03*fai+H13)*v3jian(:,t);

    PP3(:,:,i+1)=fai* P3(:,:,i)*fai'+gama*Qw*gama';%Ԥ��������
    Qeps3(:,:,i+1)=(H03+H13*inv(fai))*PP3(:,:,i+1)*(H03+H13*inv(fai))'+(H13*inv(fai)*gama)*Qw*(H13*inv(fai)*gama)'+Qv3;
    k3(:,:,i+1)=(PP3(:,:,i+1)*(H03+H13*inv(fai))')*inv(Qeps3(:,:,i+1));
    P3(:,:,i+1)=(fai-k3(:,:,i+1)*H03*fai-k3(:,:,i+1)*H13)*P3(:,:,i)*(fai-k3(:,:,i+1)*H03*fai-k3(:,:,i+1)*H13)'+...
                k3(:,:,i+1)*Qv3*k3(:,:,i+1)'+((eye(2)-k3(:,:,i+1)*H03)*gama)*Qw*((eye(2)-k3(:,:,i+1)*H03)*gama)';%�˲�������
end
%------------------------------%
t=1:Bushu;
% figure;
% subplot(2,2,1);plot(t,v3jian(1,t),'b:');
% subplot(2,2,2);plot(t,v3jian(2,t),'b:');
% subplot(2,2,3);plot(t,w3jian(t),'b:');
figure;
subplot(2,2,1);plot(t,x(1,t),'b',t,x3jian(1,t),'r:');
subplot(2,2,2);plot(t,x(2,t),'b',t,x3jian(2,t),'r:');
%---------------------------------------------------%
%-----------------�˲���Э������----------------%
P11(:,:,1)=eye(2);P12(:,:,1)=eye(2);P13(:,:,1)=eye(2);P23(:,:,1)=eye(2);
for i=1:Bushu  
    %---Ԥ����Э������----%
%     PP11(:,:,i+1)=fai* P11(:,:,i)*fai'+gama*Qw*gama';
    PP12(:,:,i+1)=fai* P12(:,:,i)*fai'+gama*Qw*gama';
    PP13(:,:,i+1)=fai* P13(:,:,i)*fai'+gama*Qw*gama';
    PP23(:,:,i+1)=fai* P23(:,:,i)*fai'+gama*Qw*gama';
    %---�˲���Э������----%
%     Qeps11(:,:,i+1)=H01*PP11(:,:,i+1)*H01';
    Qeps12(:,:,i+1)=H01*PP12(:,:,i+1)*H12';
    Qeps13(:,:,i+1)=H01*PP13(:,:,i+1)*H03'+H01*PP13(:,:,i+1)*H13';
    Qeps23(:,:,i+1)=H12*PP23(:,:,i+1)*H03'+H12*PP23(:,:,i+1)*H13';
    
%     P11(:,:,i+1)=PP11(:,:,i+1)+k1(:,:,i+1)*Qeps11(:,:,i+1)*k1(:,:,i+1)'-k1(:,:,i+1)*H01*PP11(:,:,i+1)-PP11(:,:,i+1)*H01'*k1(:,:,i+1)';
    P12(:,:,i+1)=PP12(:,:,i+1)+k1(:,:,i+1)*Qeps12(:,:,i+1)*k2(:,:,i+1)'-k1(:,:,i+1)*H01*PP12(:,:,i+1)-PP12(:,:,i+1)*H12'*k2(:,:,i+1)';
    P13(:,:,i+1)=PP13(:,:,i+1)+k1(:,:,i+1)*Qeps13(:,:,i+1)*k3(:,:,i+1)'-k1(:,:,i+1)*H01*PP13(:,:,i+1)-PP13(:,:,i+1)*H03'*k3(:,:,i+1)'-PP13(:,:,i+1)*H13'*k3(:,:,i+1)';
    P23(:,:,i+1)=PP23(:,:,i+1)+k2(:,:,i+1)*Qeps23(:,:,i+1)*k3(:,:,i+1)'-k2(:,:,i+1)*H12*PP23(:,:,i+1)-PP23(:,:,i+1)*H03'*k3(:,:,i+1)'-PP23(:,:,i+1)*H13'*k3(:,:,i+1)';
end
%-----------------��Ȩ�ں��˲���---------------%
for i=1:Bushu
    Psigma(:,:,i)=[P1(:,:,i),P12(:,:,i),P13(:,:,i);
                  P12(:,:,i)',P2(:,:,i),P23(:,:,i);
                  P13(:,:,i)',P23(:,:,i)',P3(:,:,i)];
end
e=[eye(2),eye(2),eye(2)]';
for i=1:Bushu
    A(:,:,i)=inv(Psigma(:,:,i))*e*inv(e'*inv(Psigma(:,:,i))*e);
    Po(:,:,i)=inv(e'*inv(Psigma(:,:,i))*e);%������
    xojian(:,i)=A(1:2,:,i)'*x1jian(:,i)+A(3:4,:,i)'*x2jian(:,i)+A(5:6,:,i)'*x3jian(:,i);
end
%------------------------------%
t=1:Bushu;
figure;
subplot(2,2,1);plot(t,x(1,t),'b',t,xojian(1,t),'r:');
subplot(2,2,2);plot(t,x(2,t),'b',t,xojian(2,t),'r:');
%-------------������ļ�----------------%
trP1=trace(P1(:,:,Bushu))
trP2=trace(P2(:,:,Bushu))
trP3=trace(P3(:,:,Bushu))
trPo=trace(Po(:,:,Bushu))
