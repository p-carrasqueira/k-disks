function [weights,l_scan] = update_coef(n_sensors,weights,l_scan,closer,R,distancias,intruder,l_sensors,sensors,time)


n=50;    % Factor potencia da distancia
m=75;    % Factor potencia do tempo
sigma=0;

for i=1:n_sensors
    for j=1:size(closer{i,1},1)
        if ~ismember(closer{i,2}(j),intruder)
            if distancias(closer{i,2}(j))<=R(i)
%                   fprintf('<R\t ind=%d\tdist=%.2f\tR=%.2f\n',closer{i,2}(j),distancias(closer{i,2}(j)),R(i))
                l_scan(closer{i,2}(j))=0;
            else
%                   fprintf('>R\t ind=%d\t dist=%.2f\tR=%.2f\n',closer{i,2}(j),distancias(closer{i,2}(j)),R(i))
                l_scan(closer{i,2}(j))=l_scan(closer{i,2}(j))+1;
            end
            % Colocar a zero os do path
            if time>1
                t=sum((closer{i,1}(j,:)-l_sensors(i,:)).*(sensors(i,:)-l_sensors(i,:)))/(norm(sensors(i,:)-l_sensors(i,:))^2);
                dist=norm(l_sensors(i,:)+t*(sensors(i,:)-l_sensors(i,:)) -closer{i,1}(j,:));
%               fprintf('k=%d\tDist= %.1f\t point=%.1f %.1f\t sen=%.1f %.1f\t l_sen=%.1f %.1f\n',closer{i,2}(j),dist,closer{i,1}(j,1),closer{i,1}(j,2),sensors(1,1),sensors(1,2),l_sensors(1,1),l_sensors(1,2));
%               fprintf('%d \t %d \t %d\t %d \t %d\n',closer{i,1}(j,1)>=min(sensors(i,1),l_sensors(i,1)),closer{i,1}(j,1)<=max(sensors(i,1),l_sensors(i,1)) , points(k,2)>=min(sensors(j,2),l_sensors(j,2)), points(k,2)<=max(sensors(j,2),l_sensors(j,2)), ((points(k,1)>=min(sensors(j,1),l_sensors(j,1)) && points(k,1)<=max(sensors(j,1),l_sensors(j,1)) ) || (points(k,2)>=min(sensors(j,2),l_sensors(j,2)) && points(k,2)<=max(sensors(j,2),l_sensors(j,2)))));
                if (dist<=R(i) && (t>=0 && t<=1))
                    l_scan(closer{i,2}(j))=0;
%                     fprintf('k=%d\n',closer{i,2}(j));
                end
            end
        end
    end
    random_dist=zeros(size(closer{i,2}));
    soma2=0;
    soma=0;
    for j=1:size(closer{i,2},1)
        if ~ismember(closer{i,2}(j),intruder)
%            random_dist(j)=max(0,(normrnd(distancias(closer{i,2}(j))-R(i),sigma))^(min(100,l5+_scan(closer{i,2}(j)))));
            random_dist(j)=max(0,(normrnd(distancias(closer{i,2}(j))-R(i),sigma))^n);
            soma=soma+random_dist(j);
            soma2=soma2+l_scan(closer{i,2}(j))^m;
        end
    end
    if soma2==0
        soma2=1;
    end
    if soma==0
        soma=1;
    end
    
    for j=1:size(closer{i,1},1)
        if ~ismember(closer{i,2}(j),intruder)
            weights(closer{i,2}(j))=0.3*(max(0,random_dist(j)))/soma+0.7*l_scan(closer{i,2}(j))^m/soma2;
        end
    end
   
end


end