%% Point placement and sensor parameter
height=100;
width=100;

n_sensors=10;

bound=[0 0];
bound=cat(1,bound,[width 0]);
bound=cat(1,bound,[width height]);
bound=cat(1,bound,[0 height]);
bound=cat(1,bound,[0 0]);

% Sensor model parameter
d=5*ones(n_sensors,1);
k=.05*ones(n_sensors,1);

% Detection probability
prob_p=1.0;   % Point probability
prob_t=0.8;   % Area probability

% Ranges definition
R=ones(n_sensors,1);
R_t=ones(n_sensors,1);
L=ones(n_sensors,1);
for i=1:size(d,1)
    R(i)=-log(prob_p)/k(i)+d(i);      
    R_t(i)=-log(prob_t)/k(i)+d(i);
    L(i)=-log(prob_t/prob_p)/k(i);    
end

L=min(L);

l=sqrt(L^2/2);      % Grid side maximum size 
pos=l;
points=[];
maxi=0;    % Maximum point position of first line of x
maxi2=0;   % Maximum point position of first line of y

tolerance=1/2;
primeira=1;
firstx=0;

% Point placement 
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
    % Center points of line
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

% Center points in width 
d=max(points(:,1));
d2=min(points(:,1));
d=(-d+width+d2)/2;
M=cat(2,ones(size(points,1),1),zeros(size(points,1),1));
points=points-d2*M+d*M;
 
%% Point Placement plot

fh = figure('rend','painters','pos',[10 10 400 300]); % por lado a lado
%fh = figure('rend','painters','pos',[10 10 300 200]); 
hold on
set(gcf,'color','w');
axis manual;
axis square
xlim([-5 width+7.5]);
ylim([-5 height+7.5]);
plot(bound(:,1),bound(:,2));  
p1=plot(points(:,1),points(:,2),'*');
p2=viscircles(points, L*ones(size(points,1),1),'LineWidth',1,'Color','k');
%lg1=legend([p1;p2],{'Anchor Points';'Ball with $$r=b$$'},'Position',[0.75 0.89 0.09 0.1]);
%set(lg1,'Interpreter','latex','FontSize',10);
legend boxoff
xlabel('$x$ (m)','Interpreter','latex','FontSize',10);
ylabel('$y$ (m)','Interpreter','latex','FontSize',10);
hold off


%% Area Coverage solution

sensors=zeros(n_sensors,2);

trys=20;
% Cell with positions ans sum(opt_val) 
possible=cell(trys,2);
l_scan=ones(size(points,1),1);
minimum=+inf;
weights=ones(size(points,1),1);

for i=1:trys
	possible{i,1}=kplusplus(n_sensors,points);
  
    [possible{i,1},closer,dist]=Lloyd_fista(possible{i,1},points,n_sensors,R,weights,l_scan);
    possible{i,2}=0;
    
    for ii=1:size(dist,1)
        possible{i,2}=possible{i,2}+max(0,dist(ii))^2;
    end
    
    fprintf('Para i = %d \t Soma dos valores do potencial =%.3f\n',i,possible{i,2});
    
    if minimum>possible{i,2}
        i
        minimum=possible{i,2};
        sensors=possible{i,1};
        s_closer=closer;
    end
end

closer=s_closer;
%% Area Coverage plot
%
%fh = figure;
fh = figure('rend','painters','pos',[10 10 300 300]); % por lado a lado
hold on
set(gcf,'color','w');
axis manual;
axis square
xlim([-5 width+5]);
ylim([-5 height+5]);
plot(bound(:,1),bound(:,2));  
[vx,vy] = voronoi(sensors(:,1),sensors(:,2));
plot(vx,vy,'b-');
for i=1:n_sensors
    p1=plot(closer{i}(:,1),closer{i}(:,2),'*');
end
%p1=plot(points(:,1),points(:,2),'*');
p2=plot(sensors(:,1),sensors(:,2),'xb');
p3=viscircles(sensors, R,'LineWidth',1,'Color','k');
p4=viscircles(sensors,R_t,'LineWidth',1,'Color',[100,100,100]/250,'LineStyle','--');%'$R_{j,\varepsilon}$'
%lg1=legend([p1,p2,p3,p4],{'Anchor Points','Sensors','$R_{j\tau}$','$R_{j\varepsilon}$'},'Position',[0.82 0.87 0.09 0.1]);
%set(lg1,'Interpreter','latex','FontSize',10);
%legend boxoff
xlabel('$x$ (m)','Interpreter','latex','FontSize',10);
ylabel('$y$ (m)','Interpreter','latex','FontSize',10);
hold off

%% Patroll/ Tracking
%load('Data_s.mat');
time=120;

% If intruders are considered this is where we first define them
% intruder=[size(points,1)+1;size(points,1)+2];
intruder=[size(points,1)+1];

% x_c=50;
% y_c=50;


% points=[points;[x_c y_c];[25 75]];
% points=[points;[50 50]];
% r=5;
% t=0;
% v=2;

weights=ones(size(points,1),1);
% weights(end)=0;
% weights(end-1)=0;

l_scan=ones(size(points,1),1);
size(points)
% l_scan=[l_scan; 0];

% p_sensors=randi([0 50],3,2);
sensors=p_sensors;	% Usada para utilizar sempre o mesmo ponto inicial

aux=[];
all_sensors=cell(1,time);
all_closer=cell(n_sensors,2*time);
intru=cell(size(intruder,1),time);
i=1;

for i=1:time
%while 1
    fprintf('Time=%d\n',i); 
    l_sensors=sensors;
    [sensors,closer,distancias]=Lloyd_fista2(sensors,points,n_sensors,R,weights,l_scan,l_sensors,intruder);

    if i==1
        l_scan=zeros(size(points,1),1);
    end
    
    [weights,l_scan] = update_coef(n_sensors,weights,l_scan,closer,R,distancias,intruder,l_sensors,sensors,i);
   

%    intru{1,i}=points(end,:);
%    intru{2,i}=points(end-1,:);    
    
    all_sensors{1,i}=sensors;
    for j=1:n_sensors
        all_closer{j,2*i-1}=closer{j,1};
        all_closer{j,2*i}=closer{j,2};
    end
    aux=cat(2,aux,l_scan);
    
    save('Data.mat','aux','all_sensors','all_closer','time','width','height','bound','R','R_t','n_sensors','intruder','points','i','intru')

%    weights(end-1)=1000;
%    weights(end)=1000;
%    points(end-1,:)=[x_c y_c]+[r*cos(t) r*sin(t)];
%    points(end,:)=points(end,:)+[0.75 0.75];
%    points(end,:)=[max(0,min(points(end,1)+rand*30-15,width)) max(0,min(points(end,2)+rand*30-15,height))];%    r=r+0.2;
%    r=r+0.25;
%    t=t+v/r;
%    l_scan(end)=2;
%    l_scan(end-1)=2;


%     Stop if all were covered
    a=aux(:,i)<i;
    if (sum(a)==size(aux,1))
        break;
    end
    sum(a)

% i=i+1;
end

% save('Data.mat','aux','all_sensors','all_closer','time','width','height','bound','R','R_t','n_sensors','intruder')
%clear all
