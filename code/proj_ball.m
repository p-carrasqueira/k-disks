function proj = proj_ball(center,radius,point)

if norm(center-point)<=radius
    proj=point;
else
    proj=radius*(point-center)/norm(center-point);
    proj=center+proj;
end


end