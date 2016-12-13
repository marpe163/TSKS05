h1 = openfig('goodoneopenspace.fig','reuse'); % open figure

ax1 = gca; % get handle to axes of figure

h2 = openfig('closetowallopenspace.fig','reuse');

ax2 = gca;

h3 = openfig('corridorbench.fig','reuse');

ax3 = gca;

% test1.fig and test2.fig are the names of the figure files which you would % like to copy into multiple subplots

h4 = figure; %create new figure

s1 = subplot(3,1,1); %create and get handle to the subplot axes
xlim([0 2])
s2 = subplot(3,1,2);
xlim([0 2])
ylabel('Frequency')
title('test because jack')
s3=subplot(3,1,3)
xlim([0 2])
xlabel('Distance error [m]')

fig1 = get(ax1,'children'); %get handle to all the children in the figure

fig2 = get(ax2,'children');
fig3 = get(ax3,'children');

copyobj(fig1,s1); %copy children to new parent axes i.e. the subplot axes

copyobj(fig2,s2);
copyobj(fig3,s3);
