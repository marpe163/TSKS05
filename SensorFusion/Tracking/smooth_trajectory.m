function smoothed_trajectory = smooth_trajectory(N,wn,trajectory)
%Takes a matrix with two rows, where the rows are the x and y coordinates
%of the trajectory respectively. The trajectory is then fed through a LP
%filter in order to obtain a smoother trajectory.

[B,A]=butter(N,wn/2,'low');
xfilt=filtfilt(B,A,trajectory(1,:));
yfilt=filtfilt(B,A,trajectory(2,:));
smoothed_trajectory=[xfilt;yfilt];

end

