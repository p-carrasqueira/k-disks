function sensors = kplusplus(n_sensors,points)
%
%   sensors = kplusplus(n_sensors,sensors,points)
%   kplusplus makes a initialization for solving k-means for a set of
%   points to cover and a number of sensors n_sensors.
%   Returns the sensors positions.
%

    % Escolher a posicao do primeiro random de todos os pontos to cover
    sensors=points(randi(size(points,1)),:);
    
    % Comecando no segundo sensor atribuir posicoes para os restantes 
    for j=2:n_sensors
        dist=[];
        % Inicializacao das probabilidades atraves das distancias dos
        % pontos relativamente ao que esta mais perto
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
        % Escolha do valor da proxima posicao
        aux=0;
        valor=rand; % Numero aleatorio uniformemente distribuido entre [0:1]
        k=0;
        while aux<valor % Quando as somas das probabilidades for superior ao rand estamos no limite
            k=k+1;
            aux=aux+dist(k);
        end
        sensors=cat(1,sensors,points(k,:)); 
    end
    

end