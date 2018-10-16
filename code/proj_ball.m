function proj = proj_ball(center,radius,point)
%   proj = proj_ball(center,radius,point)
%   Returns projecton (proj) of point to ball centered in center with
%   radius
 
if norm(center-point)<=radius
    proj=point;
else
    proj=radius*(point-center)/norm(center-point);
    proj=center+proj;
end


end