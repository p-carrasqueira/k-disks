function soma=grad_my_prob(x,points,R,weights,index,l_scan)
    soma=0;
%     fprintf('begin\n');
    for ii=1:size(points,1)
        soma=soma+2*min(1,l_scan(index(ii)))*weights(index(ii))*(x - proj_ball(points(ii,:),R,x));
        
%         fprintf('l_scan=%f\t we=%f\t ind=%d\n',l_scan(index(ii)),weights(index(ii)),index(ii));
%         proj=proj_ball(points(ii,:),R,x);
%         fprintf('p=%.2f %.2f \tw=%.2f R=%.2f\t x=%.2f %.2f\t\tproj=%.2f %.2f\n', points(ii,1),points(ii,2),weights(index(ii)),R,x(1),x(2),proj(1),proj(2))
%         fprintf('Soma=%f\n',soma);
    end

end
