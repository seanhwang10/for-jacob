# for jacob
제이콥 프로젝트 sample 
### 난 MATLAB으로 했는데 파이썬으로 구현하는게 사실 더 쉬움. 나는 파이썬 syntax 까먹어서 요즘 익숙한 멧랩으로 함. 작동방식은 파이썬도 동일. 수도코드는 최대한 파이썬으로 해보겠음. 
*** 
# outcome!! 

source code: ball_locator.m 

데이터 너가 보내준 사진 토대로 만들어봄 간단하게 

![](https://github.com/seanhwang10/for-jacob/blob/main/data1.PNG)  

![](https://github.com/seanhwang10/for-jacob/blob/main/data2.PNG)

코드 돌리면 나오는거: 

![](https://github.com/seanhwang10/for-jacob/blob/main/demo.gif)
  

## BASICS:
- 0.5초 단위로 location data 있음
- 0.1초 단위로 event data 있음 

- location data 를 0.1초로 sync 해야함 
psuedocoding: 
``` 
#Optimized algorithm (각 event 때의 위치를 계산) 
player_location(lapse)  begin 
if (lapse % 0.5) 
	lapse_slice = lapse % 0.5 #가장 가까운 0.5초 data와 '0.1초 slice' 차이 
	lapse_load = lapse / 0.5 #가장 가까운 시간에 있는 data

	location_start = location(lapse_load) 
	location_end = location(lapse_load + 0.5) 
	location_slice = location_start - location_end
	location_slice /= 5  

	for i = 1:lapse_slice
		player_location += location_slice

end 
```

actual: 
``` 
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
``` 

작동 순서: 
1. input으로 시간을 주면 (0.1초 단위) 공의 x,y 좌표를 뱉는 함수 필요 
2. loop 사용해서 90분동안 (필요한만큼) 위 함수에 시간 파라미터 feed 해주고 공 좌표들 받기.
3. 1번만 있어도 니가 원하는 시간에 공이 어디있는지 알수있음. 2번 있으면 animate 가능. 
- 나는 에니메잇을 하기로 함. 

## event cases 
- 일단 모든 가능한 state cases 를 지정하고 pass 상태인지 receive 상태인지 공 소유 상황인지 (이건 자동으로 되지만) 

```
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
```


case 1. 공이 선수에게 있을때 
- receive 이후 pass 전 
``` 
ball_location = location(player_with_ball); 
``` 

```
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
```

case 2. 공을 패스했을때 (다른애가 받을떄) 
``` 
ball_location = location( (패스한애 - 받는애) / lapse_slice ) 
```

```
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

``` 

드리고 맨 위 보여준거처럼 디스플레이를 하던지 아니면 이렇게 데이터를 뽑던지 하기 가능. 
- 시간 단위는 10으로 곱해놓음 나 편하자구 
- 아래 사진에서 5가 실제로는 0.5초고 20이 원래 2초고 이런식 

![](https://github.com/seanhwang10/for-jacob/blob/main/balldata.PNG)





