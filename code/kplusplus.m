function sensors = kplusplus(n_sensors,points)
%
%   sensors = kplusplus(n_sensors,sensors,points)
%   kplusplus makes a initialization for solving k-means for a set of
%   points to cover and a number of sensors n_sensors.
%   Returns the sensors positions.
%

    % First position chosen randomly
    sensors=points(randi(size(points,1)),:);
    
    for j=2:n_sensors
        dist=[];
        % Inicialize probabilities of the algorithm
        for k=1:size(points,1)
            aux=norm(sensors(1,:)-points(k,:));
            for l=2:j-1
                if (norm(sensors(l,:)-points(k,:))<aux)
                    aux=norm(sensors(l,:)-points(k,:));
                end
            end
            dist=cat(1,dist,aux);
        end
        dist=dist.^2;
        dist=dist/sum(dist);
        % Selecting position according to probabilities 
        aux=0;
        valor=rand; 
        k=0;
        while aux<valor
            k=k+1;
            aux=aux+dist(k);
        end
        sensors=cat(1,sensors,points(k,:)); 
    end
   
end