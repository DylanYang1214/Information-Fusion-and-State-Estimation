function [w123,Pci123,trPci123]=y0_618(Pci12,pp3,deta)   %���ڵ��õ��ļ��и���p1,p2,������
a(1)=0;b(1)=1;
l(1)=a(1)+0.382*(b(1)-a(1));
u(1)=a(1)+0.618*(b(1)-a(1));
for k=1:500             %k��ȡֵ��Χ������һЩ
    p0l(:,:,k)=inv(l(k)*inv(Pci12)+(1-l(k))*inv(pp3));
    p0u(:,:,k)=inv(u(k)*inv(Pci12)+(1-u(k))*inv(pp3));
    if trace(p0l(:,:,k))>trace(p0u(:,:,k))
       if b(k)-l(k)<=deta
           w123=u(k);break;  
       else
           a(k+1)=l(k);b(k+1)=b(k);l(k+1)=u(k);u(k+1)=a(k+1)+0.618*(b(k+1)-a(k+1));
       end
    else
       if u(k)-a(k)<=deta
          w123=l(k);break;
       else
            a(k+1)=a(k);b(k+1)=u(k);u(k+1)=l(k);l(k+1)=a(k+1)+0.382*(b(k+1)-a(k+1));
       end
    end
end
 Pci123=inv(w123*inv(Pci12)+(1-w123)*inv(pp3));
trPci123=trace(Pci123);