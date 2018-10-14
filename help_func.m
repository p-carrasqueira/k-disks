x=[1 1];
y=[5 6];

line=y-x;

bound2=[];
bound2=[bound2; x(1) -10];
bound2=[bound2; x(1) 50];
bound2=[bound2; y(1) 50];
bound2=[bound2; y(1) -50];
bound3=[];
bound3=[bound3; -10 x(2)];
bound3=[bound3; 10 x(2)];
bound3=[bound3; 50 y(2)];
bound3=[bound3; -10 y(2)];
% bound2=[bound2; x];



figure
hold on
fill(bound2(:,1),bound2(:,2),'y','LineStyle','none')
fill(bound3(:,1),bound3(:,2),'y','LineStyle','none')
plot([x(1), y(1)],[x(2), y(2)],'r') 
plot([x(1), y(1)],[x(2), y(2)],'*r') 
viscircles(cat(1,x,y), 2*ones(2,1),'LineWidth',1,'Color','r');
axis manual;
xlim([-2 8]);
ylim([-2 9]);
hold off
