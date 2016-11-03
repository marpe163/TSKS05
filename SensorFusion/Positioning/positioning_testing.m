% test positioning

x0 = [1;1];

tag_pos = positioning(x0,10);

x1 = [2;2];
tag_pos = tag_pos.update_position(x1);

for it=3:60
    x = [it;it] + randn(2,1);
    tag_pos = tag_pos.update_position(x)
    plot(tag_pos.saved_pos(1,:),tag_pos.saved_pos(2,:));
    axis([0 70 0 70])
    pause
end


