clc; clear all; 

pos_raw = csvread('positions.csv', 1) %선수 포지션 데이터 불러오기 
event = csvread('sample_M.csv', 1) %Events 불러오기 
ball_location = csvread('test.csv', 1) 

data_count = 11; %데이터셋 몇개인지 

%Position Extrapolation loop 
%선수 포지션이 0.5 단위니까 0.1단위로 extrapolate 해야함 
for c = 1:6 
    
    for s = 0 : data_count-1
        ori = s * 5; 
        location_slice = (pos_raw((s+2),(c+1)) - pos_raw((s+1),(c+1))) / 5;
        for h = 1:5
            if (h == 1) 
                pos_extp((ori+h),c) = pos_raw((s+1),(c+1));
            else 
                pos_extp((ori+h), c) = pos_raw((s+1),(c+1)) + (location_slice * (h-1));
            end 
        end 
    end 
end 
 
%Ball positioning 
%Event Code 사용했음 PASS = 1, RECEIVE = 2
event(:,1) = event(:,1) * 10; 
evt = 3; %event log index (first) 
pass = 0; 

for t = 1 : (data_count*5) 
    if (t < 3) %초기설정 
        ball_location(t,1) = pos_extp(t,1);
        ball_location(t,2) = pos_extp(t,2); 
    end 
    
    if (t == evt) %event 발생 시 
        
        if (event(evt, 5) == 1) %pass event 
            pass = 1;
            receive = 0; 
            who_passed = event(evt, 3); %who passed the ball
            pass_to = event(evt+1, 3); %passed to? 
            receive_time = event(evt+1, 1); 
        else %receive event 
            pass = 0; 
            receive = 1;
            ball_at = event(evt, 3) %who has the ball 
        end 
        
        if evt == 16
            evt = 16; 
        else 
            evt = evt + 1; %increment the event index 
        end 
    end 
    
    if(pass == 1) 
        if (who_passed == 1) 
            start_pos(1,1) = pos_extp(t, 1); 
            start_pos(1,2) = pos_extp(t, 2);
        end 
        
        if (who_passed == 2) 
            start_pos(1,1) = pos_extp(t, 3); 
            start_pos(1,2) = pos_extp(t, 4);
        end 
        
        if (who_passed == 3)
            start_pos(1,1) = pos_extp(t, 5); 
            start_pos(1,2) = pos_extp(t, 6);
        end 
        
        if (pass_to == 1) 
            endos(1,1) = pos_extp(receive_time, 1)
            end_pos(1,2) = pos_extp(receive_time, 2)
        end 

        if (pass_to == 2) 
            end_pos(1,1) = pos_extp(receive_time, 3)
            end_pos(1,2) = pos_extp(receive_time, 4)
        end 
        
        if (pass_to == 3) 
            end_pos(1,1) = pos_extp(receive_time, 5)
            end_pos(1,2) = pos_extp(receive_time, 6)
        end 
        
        ball_loc_slice(1,1) = end_pos(1,1) - start_pos (1,1) 
        ball_loc_slice(1,2) = end_pos(1,2) - start_pos (1,2) 
        
        duration = event(evt+1,1) - event(evt); 
        
        ball_location(t,1) = pos_extp(t,1) + (ball_loc_slice(1,1) / duration);
        ball_location(t,2) = pos_extp(t,2)+ (ball_loc_slice(1,2) / duration); 
    end
    
    if (receive == 1)
            if (ball_at == 1) 
                ball_location(t,1) = pos_extp(t,1);
                ball_location(t,2) = pos_extp(t,2); 
            end 

            if (ball_at == 2) 
                ball_location(t,1) = pos_extp(t,3);
                ball_location(t,2) = pos_extp(t,4); 
            end 

            if (ball_at == 3)
                ball_location(t,1) = pos_extp(t,5);
                ball_location(t,2) = pos_extp(t,6); 
            end
    end 

end 

Displaying player & ball position by time 
for i = 1:data_count*5  
    plot(pos_extp(i,1), pos_extp(i,2),'or', 'MarkerSize',10,'MarkerFaceColor','w') 
    hold on 
    plot(pos_extp(i,3), pos_extp(i,4),'or', 'MarkerSize',10,'MarkerFaceColor','w') 
    hold on 
    plot(pos_extp(i,5), pos_extp(i,6),'or', 'MarkerSize',10,'MarkerFaceColor','w') 
    hold on 
    plot(ball_location(i,1), ball_location(i,2),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
    hold off 
    legend('Player 1','Player 2', 'Player 3', 'Ball')
    title('time',i/10)
    axis([0 200 0 200]);
    pause(0.1)
end 

