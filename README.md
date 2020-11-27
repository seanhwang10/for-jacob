# for jacob
 
제이콥 프로젝트 sample 
*** 
## BASICS:
- 0.5초 단위로 location data 있음
- 0.1초 단위로 event data 있음 

- location data 를 0.1초로 sync 해야함 
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



## Algorithm cases 
basic: 

case 1. 공이 선수에게 있을때 
- receive 이후 pass 전 
``` 
ball_location = location(player_with_ball); 
``` 

case 2. 공을 패스했을때 

