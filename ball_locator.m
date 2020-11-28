clc; clear all; 

pos_raw = csvread('positions.csv', 1) %선수 포지션 데이터 불러오기 
data_count = 11; %데이터셋 몇개인지 

%Position Extrapolation loop 
%선수 포지션이 0.5 단위니까 0.1단위로 extrapolate 해야함 
for c = 1:6 
    
    for s = 0 : data_count-1
        ori = s * 5; 
        location_slice = (pos_raw((s+2),(c+1)) - pos_raw((s+1),(c+1))) / 5
        for h = 1:5
            if (h == 1) 
                pos_extp((ori+h),c) = pos_raw((s+1),(c+1));
            else 
                pos_extp((ori+h), c) = pos_raw((s+1),(c+1)) + (location_slice * (h-1));
            end 
        end 
    end 
end 

% for i = 1:11 
%     plot(pos_raw(i,2), pos_raw(i,3),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
%     hold on 
%     plot(pos_raw(i,4), pos_raw(i,5),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
%     hold on 
%     plot(pos_raw(i,6), pos_raw(i,7),'or', 'MarkerSize',5,'MarkerFaceColor','r') 
%     hold off 
%     axis([0 200 0 200]);
%     pause(1)
% end 


% for i=1:n
%     plot(XY(1,i),XY(2,i),'or','MarkerSize',5,'MarkerFaceColor','r')
%     hold on 
%     plot(XY(1,i),XY(2,i),'or','MarkerSize',2,'MarkerFaceColor','b')
%     hold off 
%     legend('original','new')
%     axis([-5 5 -5 5])
%     pause(1)
% end

