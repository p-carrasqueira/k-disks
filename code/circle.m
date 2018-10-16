height=50;
width=50;

n_sensors=10;


% Parametros do modelo
% d=[2;5;5;5;5;10;10;10;10;10];        % Distancia ate a qual todos os pontos estão cobertos 
% k=[0.05;0.05;0.05;0.05;0.05;0.04;0.04;0.04;0.04;0.04];     % Parametro para decaimento

d=5*ones(n_sensors,1);
k=.05*ones(n_sensors,1);

% Probabilidades de detecao
prob_p=1.0;   % Probabilidade de detecao dos pontos
prob_t=0.8;   % Probabilidade de detecao da area total requerida

R=ones(n_sensors,1);
R_t=ones(n_sensors,1);
L=ones(n_sensors,1);


for i=1:size(d,1)
    R(i)=-log(prob_p)/k(i)+d(i);         % Range maxima para garantir os pontos cobertos com prob_p
    R_t(i)=-log(prob_t)/k(i)+d(i);
    L(i)=-log(prob_t/prob_p)/k(i);    % Se os pontos tem prob_p a distancia entre pontos necessaria
                                % para garantir prob_t e L
end

L=min(L);

l=sqrt(L^2/2);      % Largura de um quadrado com diagonal L
points=[];
% l=[l l];       % Posicao inicial de criacao dos pontos
maxi=0;  % Posicao maxima possivel para os pontos da primeira linha em x
maxi2=0; % Posicao maxima possivel para os pontos da primeira linha em y

tolerance=1/2;
primeira=1;
firstx=0;

% Criacao dos pontos 
while (maxi-firstx)<width
    line=[];
    aux1=maxi-rand*(tolerance*l);
    aux2=maxi2-rand*(tolerance*l);
    first=aux2;
    while (aux2-first)<=height
        line=cat(1,line, [aux1 aux2] );
        maxi2=aux2+2*l;
        aux1=maxi-rand*(tolerance*l);
        aux2=maxi2-rand*(tolerance*l);
    end
%    line=cat(1,line, [aux1 aux2] );
    d=max(line(:,2));
    d2=min(line(:,2));
    d=(height-d+d2)/2;
    M=cat(2,zeros(size(line,1),1),ones(size(line,1),1));
    line=line-d2*M+d*M;
    maxi2= 0;
    if primeira==1
        firstx=min(line(:,1));
        primeira=2;
    end
    maxi=min(min(line(:,1))+2*l,width-firstx);
    points=cat(1,points, line );
end

% % Centralizacao dos pontos
d=max(points(:,1));
d2=min(points(:,1));
d=(-d+width+d2)/2;
M=cat(2,ones(size(points,1),1),zeros(size(points,1),1));
points=points-d2*M+d*M;
 
% d=max(points(:,2));
% d2=min(points(:,2));
% d=(height-d+d2)/2;
% M=cat(2,zeros(size(points,1),1),ones(size(points,1),1));
% points=points-d2*M+d*M;

xc=25;
yc=25;

rc=25;
points2=[];

for i=1:size(points,1)
    if(norm(points(i,:)-[xc yc])<=rc)
        points2=[points2;points(i,:)];
    end
end


d=max(points2(:,1));
d2=min(points2(:,1));
d=(-d+2*rc+d2)/2;
M=cat(2,ones(size(points2,1),1),zeros(size(points2,1),1));
points2=points2-d2*M+d*M;

%%
fh = figure('rend','painters','pos',[10 10 400 300]); % por lado a lado
hold on
set(gcf,'color','w');
axis manual;
axis square
xlim([-5 width+7.5]);
ylim([-5 height+7.5]);
p1=plot(500,500,'*');
p1=plot(points2(:,1),points2(:,2),'*');
viscircles([xc yc], rc,'LineWidth',1);
p2=viscircles(points2, L*ones(size(points2,1),1),'LineWidth',1,'Color','k');
%lg1=legend([p1;p2],{'Anchor Points';'Ball with $$r=b$$'},'Position',[0.8 0.85 0.09 0.1]);
%set(lg1,'Interpreter','latex');
%legend boxoff
xlabel('$x$ (m)','Interpreter','latex','FontSize',10);
ylabel('$y$ (m)','Interpreter','latex','FontSize',10);
hold off

% points2=[points2;4.9 39.5]
% points2=[points2;11. 44.8]
% points2=[points2;38.4 44.8]
% points2=[points2;45.1 38.5]
% points2=[points2;45 10.5]
% points2=[points2;38.7 4.1]
% points2=[points2;11.5  4.75]
% points2=[points2;5.5  11.7]