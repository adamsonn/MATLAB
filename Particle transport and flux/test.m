% [x,y,z] = ndgrid(1:5:100,1:5:100,1:5:100);
% scatter3(x(:),y(:),z(:),'.')
% 
% 
% %point clouds to get distences too.
% A=[x(:),y(:),z(:)];
% 
% %Cacluclated 
% D=euclideanDistanceTwoPointClouds(C,A);



% % Import an STL mesh, returning a PATCH-compatible face-vertex structure
% fv = stlread('femur.stl');
% 
% patch(fv,'FaceColor',       [0.8 0.8 1.0], ...
%          'EdgeColor',       'none',        ...
%          'FaceLighting',    'gouraud',     ...
%          'AmbientStrength', 0.15);
% 
% % Add a camera light, and tone down the specular highlighting
% camlight('headlight');
% material('dull');
% 
% % Fix the axes scaling, and set a nice view angle
% axis('image');
% view([-135 35]);
% 
% getd = @(p)path(p,path); % scilab users must *not* execute this
% getd('toolbox_signal/');
% getd('toolbox_general/');
% getd('toolbox_graph/');
% getd('toolbox_wavelet_meshes/');


name = 'beetle'; % 1k
name = 'camel'; % 600 v
name = 'cow'; % 700v
name = 'venus'; % 700 v
%name = 'mannequin'; % 400 v
%name = 'nefertiti'; % 300 v
%name = 'bestnose2';

[vertex0,faces0] = read_mesh(name);
clear options; options.name = name;

clf;
options.lighting = 1;
plot_mesh(vertex0,faces0,options);
shading('faceted');

nsub = 2; % number of subdivision steps
options.sub_type = 'loop';
options.verb = 0;
[vertex,faces] = perform_mesh_subdivision(vertex0,faces0,nsub,options);
n = size(vertex,2);


clf;
options.lighting = 1;
plot_mesh(vertex,faces,options);
shading('faceted');

dotp = @(u,v)sum(u.*v,1);
R = @(u)reshape(u, [1 1 length(u)]);

Inv1 = @(M,d)[M(2,2,:)./d -M(1,2,:)./d; -M(2,1,:)./d M(1,1,:)./d];
Inv  = @(M)Inv1(M, M(1,1,:).*M(2,2,:) - M(1,2,:).*M(2,1,:));
Mult = @(M,u)[M(1,1,:).*u(1,1,:) + M(1,2,:).*u(2,1,:);  M(2,1,:).*u(1,1,:) + M(2,2,:).*u(2,1,:)];

W = ones(n,1);

I = [88 2602 883 23];

U = zeros(n,1);

i = [faces(1,:) faces(2,:) faces(3,:) ];
j = [faces(2,:) faces(3,:) faces(1,:) ];
k = [faces(3,:) faces(1,:) faces(2,:) ];

x  = vertex(:,i);
x1 = vertex(:,j) - x;
x2 = vertex(:,k) - x;

uj = U(j);
uk = U(k);
u = [R(uj); R(uk)];
w = R( W(i) );

C = [R(dotp(x1,x1)) R(dotp(x1,x2)); R(dotp(x2,x1)) R(dotp(x2,x2))];
S = Inv(C);

a = sum(sum(S));
b = dotp( sum(S,2), u );
c = dotp( Mult(S,u), u ) - w.^2;

delta = max( b.^2 - a.*c, 0);

d = (b + sqrt(delta) )./a;

alpha = Mult( S, u - repmat(d, 2, 1) );

J = find( alpha(1,1,:)>0 | alpha(2,1,:)>0 );
d1 = sqrt(dotp(x1,x1)); d1 = d1(:).*w(:) + uj(:);
d2 = sqrt(dotp(x2,x2)); d2 = d2(:).*w(:) + uk(:);
d = d(:);
d(J) = min(d1(J), d2(J));

U1 = accumarray(i', d, [n 1], @min);  U1(U1==0) = Inf;

U1(I) = 0;

U = U1;

options.niter = 250*3;
options.verb = 0;
options.svg_rate = 10;
options.U = [];
[U,err,Usvg] = perform_geodesic_iterative(vertex, faces, W, I, options);
% display
t = round(linspace(1,size(Usvg,2)*.5, 4));
clf;
for kdisp=1:4
    subplot(2,2,kdisp);
    options.face_vertex_color = Usvg(:,t(kdisp));
    plot_mesh(vertex,faces,options);
    colormap jet(256);
    shading interp;
end

%exo1;

clf;
h = plot(err);
set(h, 'LineWidth', 2);
axis tight;

mycolor = @(U,k)mod(U/max(U), 1/k);
mycolor = @(U,k)cos(2*pi*k*U/max(U));

clf;
options.face_vertex_color = mycolor(U, 5);
plot_mesh(vertex,faces,options);
colormap jet(256);
shading interp;



 k = 30;
 pend = round(rand(k,1)*n)+1;
 options.method = 'continuous';
 paths = compute_geodesic_mesh(U, vertex, faces, pend, options);
 
 clf;
 plot_fast_marching_mesh(vertex,faces, mycolor(U, 5), paths, options);
 %Calculating the distences along the curves
 i=1;
 while i<length(paths)
 mypoint=paths{1,i};
 pointnumber=1;
 while pointnumber<length(mypoint)
 distance(pointnumber)=norm(mypoint(:,pointnumber)-mypoint(:,pointnumber+1));
 pointnumber=pointnumber+1;
 end
 i=i+1;
 end
