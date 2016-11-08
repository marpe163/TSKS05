function smoothed_trajectory = smooth_trajectory(N,wn,trajectory,opt)
%Takes a matrix with two rows, where the rows are the x and y coordinates
%of the trajectory respectively. The trajectory is then fed through a LP
%filter in order to obtain a smoother trajectory.

if strcmp(opt,'butter')
    [B,A]=butter(N,wn/2);

elseif strcmp(opt,'cheby1')
    [B,A]=cheby1(N,0.2,wn/2); 
    
elseif strcmp(opt,'cheby2')
    [B,A]=cheby2(N,3,wn/2);
end
if length(trajectory)>14
    xfilt=filtfilt(B,A,trajectory(1,:));
    yfilt=filtfilt(B,A,trajectory(2,:));
    smoothed_trajectory=[xfilt;yfilt];
else
    smoothed_trajectory=trajectory;
end


end

