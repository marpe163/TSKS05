% test positioning

x0 = [1;1];

tag_pos = positioning(x0,10);

x1 = [2;2];
tag_pos = tag_pos.update_position(x1);

mean_vector = [];
for it=3:100
    x = [it;it] + 4*randn(2,1);
    tag_pos = tag_pos.update_position(x);
    mean_val = [mean(tag_pos.saved_pos(1,:)) ; mean(tag_pos.saved_pos(2,:))];
    plot(tag_pos.saved_pos(1,:),tag_pos.saved_pos(2,:),'b');
    hold on
    mean_vector(:,it-2) = tag_pos.moving_avarage();
    plot(mean_vector(1,:),mean_vector(2,:),'r*')
    hold off
    axis([0 100 0 100])
    pause(1/5)
end


