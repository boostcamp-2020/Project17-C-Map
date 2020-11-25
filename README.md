
###
<div align="center">
<img width="281" alt="스크린샷 2020-10-29 오전 12 29 12" src="https://user-images.githubusercontent.com/62557093/100237742-ac64da80-2f72-11eb-949e-e3a8d212c253.png">


# MapC [맵시: 아름답고 보기 좋은 모양새]


| [@SeungeonKim](https://github.com/Seungeon-Kim) | [@A-by-alimelon](https://github.com/A-by-alimelon) | [@rnfxl92](https://github.com/rnfxl92) | [@DonggeonOh](https://github.com/DonggeonOh) | [@eunjeongS2](https://github.com/eunjeongS2) |
| :-------: | :--------: | :-------: | :--------: | :-------: |
| S010_김승언😇 | S016_문성주🙇🏻‍♀️ | S017_박성민🤡 | S033_오동건🤪 | S040_이은정🤓 |

---

## 개요
 사용자의 경험에 맞는 클러스터링 지도 앱 개발 
### 프로젝트 기간
> 2020년 11월 16일 ~ 2020년 12월 18일


## 프로젝트 목표
### [클러스터링]
> 다양한 클러스터링 방법 분석 및 적용 
* QuadTree
* K-means
    * 초기화 방법
        랜덤, 화면 기준 분할, 정렬 후 분할 (3가지)
    * K 계수 적합성 검정 
* Mean-shift

> 분석 방법 
* measure 이용해서 비교 
* performance result를 보면서 확인
* Silhouette

### [애니메이션] 
- 회오리로 뭉치는 애니메이션 
- 점프 ! 약간 바운딩 
- floating `ex) 29cm`
- 모이거나 흩어지는 애니메이션
- 흔들었을 때 회오리 치기

### [인터렉션]
* 원하는 장소를 찾기 까지의 클릭 수 최소화 > 최대 6회 이하
* 클러스터 마커 클릭 시 카메라 이동 및 줌 레벨 조정
* POI 정보 보여줄 때 지도 패딩 적용

### [비동기]
* WorkItem 관리 (perform, cancel)
* DispatchGroup (enter, leave, notify)
