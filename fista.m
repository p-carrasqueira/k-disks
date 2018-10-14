function [x,iter,todas]= fista(grad,prox,x_0,t)

    iter=0;
    x=x_0;
    x_2=x_0;
%    fprintf('Iter=%d\tx=%f\tx_1=%f\n',iter,x,x_2);
    todas=zeros(size(x,2),1e5);
    while (((norm(grad(x))>0.0001 ) || iter==0  ) && iter<1000 && (norm(x_2-x)>1e-3 || iter==0) ) % && norm(x_2-x)>1e-10
        iter=iter+1;
        y=x+(iter-2)/(iter+1)*(x-x_2);
        x_2=x;
        x=prox(y-t*grad(y),t);
        todas(:,iter)=x;
%         fprintf('Iter=%d\ty=%f\tx=%f\tx_1=%f\tprox=%f\t grad=%f\n',iter,y,x,x_2,y-t*grad(y),grad(y));
%         fprintf('%f\n',norm(grad(x)));
    end
        
end