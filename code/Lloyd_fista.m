function [sensors,closer,distancias] = Lloyd_fista(sensors,points,n_sensors,R,coefficients,l_scan)
%
%   [sensors,sum_optval,closer] = Lloyd_fista(sensors,points,n_sensors,R,coefficients)
%   Lloyd_fista solves the k-means minimization problem usinf FISTA for a n_sensors,
%   a set of sensors and a set of points where each sensor as a range R.
%   Returns the sensors position and the closer
%   points from each sensor.
%
    previous = -5*ones(size(sensors));

    while all_zero(abs(sensors-previous)>0.1)
       % Primeira coluna com posicoes, segunda com indices  
        closer=cell(n_sensors,2);
        previous=sensors;

        distancias=zeros(size(points,1),1);
        for k=1:size(points,1)
            d=max(norm(points(k,1:end)-sensors(1,1:end))-R(1),0);
            index=1;
            for j=2:n_sensors
                if d>max(norm(points(k,1:end)-sensors(j,1:end))-R(j),0)
                    index=j;
                    d=max(norm(points(k,1:end)-sensors(j,1:end))-R(j),0);
                end
            end
            distancias(k)=d;
            closer{index,1}=cat(1,closer{index,1},points(k,:));
            closer{index,2}=cat(1,closer{index,2},k);
        end
        
       
        for k=1:n_sensors
            grad=@(x) grad_my_prob(x,closer{k,1},R(k),coefficients,closer{k,2},l_scan);
            prox=@(y,t) y;

            t=1/(2*size(closer{k,1},1));
            [x,iter,todas]= fista(grad,prox,sensors(k,:),t);
            sensors(k,:)=x; 
        end
    end   


end
