function smoothed_traj = rt_smooth(data, old_traj)
%real time smoothing
            lend = length(data);
            lenot = length(old_traj);
           smoothed_traj=[]
           disp('im smooth')
            if lenot < 20 %marigin to not go out of bounds
                smoothed_traj = smooth_trajectory(5,0.1,data)
            else if lend-30>lenot
                    
                tmpvec=[old_traj(1:2,(lenot-15):lenot) data(1:2, lenot+1:end)];
                tmpvec=smooth_trajectory(5,0.1,tmpvec);
                smoothed_traj=[old_traj tmpvec(1:2,lenot+1:end-5)];
                
                
            end


end

