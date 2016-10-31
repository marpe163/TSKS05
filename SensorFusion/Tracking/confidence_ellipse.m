function data=confidence_ellipse(mtx)
[V,D]=eig(mtx);
angle=atan(V(2,1)/V(1,1));
rotation_matrix=[cos(angle) -sin(angle);sin(angle) cos(angle)];
t=0:0.1:2*pi+0.1;
data = zeros(2,length(t));
xdev=sqrt(D(1,1));
ydev=sqrt(D(2,2));

data(1,:)=xdev*cos(t);
data(2,:)=ydev*sin(t);

for it=1:length(data)
   data(:,it)=rotation_matrix*data(:,it); 
end


