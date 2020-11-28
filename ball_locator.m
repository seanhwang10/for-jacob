clc; clear all; 

pos_raw = csvread('positions.csv', 1) %선수 포지션 데이터 불러오기 
event = csvread('sample.csv', 1) %Events 불러오기 

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

for t = 1 : (data_count*5) 
    if (t < 3) %초기설정 
        ball_location(t,1) = pos_extp(t,1);
        ball_location(t,2) = pos_extp(t,2); 
    end 
    if t = evt %event 발생 시 
        if event(
        
        evt = evt + 1; %increment the event index 
    end 
    
    
end 
        
    


%Displaying player & ball position by time 
for i = 1:data_count*5  
    plot(pos_extp(i,1), pos_extp(i,2),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
    hold on 
    plot(pos_extp(i,3), pos_extp(i,4),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
    hold on 
    plot(pos_extp(i,5), pos_extp(i,6),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
    hold off 
    legend('Player 1','Player 2', 'Player 3')
    axis([0 200 0 200]);
    %pause(0.3)
end 

