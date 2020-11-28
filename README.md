# for jacob
 
제이콥 프로젝트 sample 
### 난 MATLAB으로 했는데 파이썬으로 구현하는게 사실 더 쉬움. 나는 파이썬 syntax 까먹어서 요즘 익숙한 멧랩으로 함. 작동방식은 파이썬도 동일. 수도코드는 최대한 파이썬으로 해보겠음. 
*** 
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

작동 순서: 
1. input으로 시간을 주면 (0.1초 단위) 공의 x,y 좌표를 뱉는 함수 필요 
2. loop 사용해서 90분동안 (필요한만큼) 위 함수에 시간 파라미터 feed 해주고 공 좌표들 받기.
3. 1번만 있어도 니가 원하는 시간에 공이 어디있는지 알수있음. 2번 있으면 animate 가능. 
- 나는 에니메잇을 하기로 함. 

## event cases 

case 1. 공이 선수에게 있을때 
- receive 이후 pass 전 
``` 
ball_location = location(player_with_ball); 
``` 

case 2. 공을 패스했을때 
``` 
ball_location = location( (패스한애 - 받는애) / lapse_slice ) 
```

## 간 - 단 

