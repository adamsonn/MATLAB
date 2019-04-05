i=1;
while i<length(rawpoints)+1

A=rawpoints(i,1:3);
B=rawpoints(i,4:6);
pts= [A; B];

plot3(pts(:,1),pts(:,2),pts(:,3));
hold on
i=i+1;
end

i=1;
figure

while i<436
cylinder2P(rawpoints(i,7),15,[rawpoints(i,1) rawpoints(i,2) rawpoints(i,3)], [rawpoints(i,4) rawpoints(i,5) rawpoints(i,6)]);
hold on
i=i+1;
end