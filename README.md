# README

###
<div align="center">
<img width="281" alt="스크린샷 2020-10-29 오전 12 29 12" src="https://user-images.githubusercontent.com/57888770/101991430-ea425c80-3cef-11eb-94a8-e1efffc69e35.png">

## [맵시] : 아름답고 보기 좋은 모양새 🌻 
사용자의 경험을 극대화한 수백만 개 이상의 POI를 표시하는 클러스터링 앱

### ✨ 맵시 있는 사람들
| [@SeungeonKim](https://github.com/Seungeon-Kim) | [@A-by-alimelon](https://github.com/A-by-alimelon) | [@rnfxl92](https://github.com/rnfxl92) | [@DonggeonOh](https://github.com/DonggeonOh) | [@eunjeongS2](https://github.com/eunjeongS2) |
|:--------------------------------------------------:|:--------------------------------------------------:|:--------------------------------------:|:--------------------------------------------:|:--------------------------------------------:|
|    <img width="200" src="https://i.imgur.com/JG88w51.png">      | <img width="200" src="https://i.imgur.com/UXiKFVa.png">    |<img width="200" src="https://i.imgur.com/tEmhx43.png">    | <img width="200" src="https://i.imgur.com/sYKyHpZ.png"> | <img width="200" src="https://i.imgur.com/t2PRPzZ.png">
|           S010_김승언😇                 |                 S016_문성주🙇🏻‍♀️                 |             S017_박성민🤡              |                S033_오동건🤪                 |                S040_이은정🤓                 |

</div>

---

## 개요
| **Point Of Interest** - 관심지점, 관심지역정보 | **Clustering** |
|:--------------------------------------------------:|:--------------------------------------------------:|
|    <img src="https://i.imgur.com/n1RLvUU.png" width=70%>     | <img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/9b996105-4292-4ddf-aed2-2753d037f4b9/CentroidBasedClustering.svg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20201212%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20201212T151041Z&X-Amz-Expires=86400&X-Amz-Signature=afadcd46f9a432a509f465398666b4f10bed99204b5561fe0ad5ea0eca37c43a&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22CentroidBasedClustering.svg%22" width=100%>    |
|    주요 시설물, 역, 공항, 터미널, 호텔 등을 좌표로 전자수치지도에 표시하는 데이터      | 개체들이 주어졌을 때, 개체들을 몇 개의 클러스터 (부분 그룹)으로 나누는 과정 |

>지도 상의 대량의 POI들 중 사용자가 관심 있는 지역을 손 쉽게 접근 할 수 있도록 클러스터링 하여 나타내 더 좋은 경험을 제공 

## 기술스택
<img width="500" src="https://i.imgur.com/hHVytU3.png">

<br>

### 📆 프로젝트 기간
2020년 11월 16일 ~ 2020년 12월 18일

### ⛳️ 프로젝트 목표

1. 대량의 데이터를 빠른 속도로 클러스터링 할 수 있는 알고리즘 적용
2. 실제 프로토타입을 작성하여 비교해가며 기능 적용
3. 사용자의 편의를 고려한 UX, UI
4. 간단한 사용자 이벤트만으로 다양한 기능을 구현


## 기능 소개

### [**Launch Screen]**
|  화면  |  <center>구현 내용 </center>         |
|:-----:|:----------------------------------|
|<img src="https://user-images.githubusercontent.com/57888770/101991536-ac920380-3cf0-11eb-877b-11936d57b1f3.gif" width=200>|• BezierPath를 통해 통통 튀어 오는 애니메이션 <br> • UILabel의 Text를 딜레이를 줘서 한 글자씩 나오도록 구현 |

---

### [Main Scene]
### - 클러스터링 
|  화면  |  <center>구현 내용 </center>    |
|:-----:|:------------------------------|
|<img src="https://github.com/Seungeon-Kim/Baekjoon_Algorithm/blob/master/pyhton_basic/maingif.gif?raw=true" width=200>|• Naver SDK에서 제공하는 TileCoverHelper의 `onTileChanged` 이벤트에 맞춰 새로 클러스터링 <br>• CAAnimation으로 `Fade in / out` 자연스러운 화면 전환 <br> • 클러스터 내의 데이터 수에 따라 원의 크기 및 색상 조정<br>• 클러스터 마커 터치 시 해당 클러스터의 데이터 범위로 카메라 이동|

<br> 


### - 마커 추가
|  화면  |  <center>구현 내용 </center>         |
|:-----:|:----------------------------------|
|<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/617d9009-b754-4ef3-915e-466375bbeb85/ezgif.com-crop-2.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20201212%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20201212T153951Z&X-Amz-Expires=86400&X-Amz-Signature=13b457849c0779f11571026176bcd54b10bc6776f7b029a68b02a4730aae03e6&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22ezgif.com-crop-2.gif%22" width=200>|• 지도에 롱 터치 이벤트 발생 시 마커 추가 Alert 표시<br>• 추가하고자 하는 장소의 이름을 입력받아 마커 생성 <br>• 리프노드 마커에는 통통튀는 애니메이션 적용

<br>

### - 마커 삭제
|  화면  |  <center>구현 내용 </center>         |
|:-----:|:----------------------------------|
| <img src="https://user-images.githubusercontent.com/57888770/101991646-86209800-3cf1-11eb-9a04-f0973023a0bd.gif" width=200>|• 기본 앱 삭제 경험과 유사한 경험 제공<br>• 마커를 롱 터치 시 Edit 모드로 전환<br>• 마이너스 버튼으로 보이는 모든 마커 삭제 가능<br>• `CAKeyframeAnimation`으로 `shake` 애니메이션 구현<br>• 각 마커마다 시작 value를 랜덤으로 주어 다르게 애니메이션 가능|




### - 클러스터 Zoom In
|  화면  |  <center>구현 내용 </center>         |
|:-----:|:----------------------------------|
|<img src="https://user-images.githubusercontent.com/57888770/101991662-9a649500-3cf1-11eb-8bd6-162e1a52e3e1.gif" width=320>|• 클러스터 마커를 터치 시 데이터 바운더리에 맞춰 카메라 이동<br>• 데이터 양이 많은 경우, 데이터 바운더리를 검색하는 시간이 오래걸리므로 일괄적으로 줌 레벨 2단계씩 카메라 이동<br>• 각 트리에 대한 탐색이 병렬로 진행되며, 각각의 트리의 클러스터링도 독립적으로 표현|


### - POI 정보 창
|  화면  |  <center>구현 내용 </center>         |
|:-----:|:----------------------------------|
|<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/fc43badc-d38a-4fbe-8f0a-05b01dca3af0/_2020-12-12__10.37.09.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20201212%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20201212T154301Z&X-Amz-Expires=86400&X-Amz-Signature=d16c325a2db64f54215a3e624d4125682f5994a80f86b1d48d1d6cc117e763ce&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22_2020-12-12__10.37.09.png%22" width=60%>|• 원하는 마커 선택 시 선택을 알리기 위해 마커 크기 확대<br>• 마커 지역 정보 customWindow 로 표시<br>• 장소 이름, 카테고리 정보 출력|


### - POI 리스트 목록

이미지 추후 등록 예정

- 사용자가 BottomSheetView의 히든 여부를 선택

    BottomSheetView 내 Hidden 버튼 클릭 시, Hidden 후 플로팅 버튼 생성

    플로팅 버튼 클릭시, BottomSheetView를 Visible 

- URLSession DownloadTask를 이용한 이미지 다운로드, 이미지 캐싱

## 기술 특장점
### [CoreData]

* 병렬 처리를 통한 빠른 Fetch
* Migration을 이용한 버전 관리


### [QuadTree]

* 많은 데이터를 빠르게 처리
* `GCD`를 이용한 병렬 처리를 적극 활용
* 클러스터링 횟수를 최소화


### [User Interaction]

* Core Animation을 사용한 가벼운 애니메이션
* Layer로 한층 더 가볍게
* 다양한 제스쳐 이벤트에 대응하는 interaction



## 🏋️‍♂️ 저희는 다양한 도전을 했어요! 🏋️
### 앱 실행시 트리 생성 시간이 오래걸리는 문제를 해결하기 도전!



- 트리의 오브젝트 그래프를 CoreData에 저장하는 기능
```
앱 설치 후 처음 실행 시에만 트리를 생성하고,
이후에는 저장된 트리를 사용하면 트리 생성에 대한 시간을 줄일 수 있지 않을까 생각

1. NSManagedObject를 사용하기 위해서는 기존의 struct를 class로 변환해야하는 상황이 발생
    → 많은 양의 데이터를 Heap 메모리에 생성과 해제를 해야하기 때문에 리소스 낭비가 심했다.
2. fetch 및 save의 시간 소요가 트리를 생성하는 시간보다 빠르지 못했다.
``` 
[관련 PR] https://github.com/boostcamp-2020/Project17-C-Map/pull/67

- 트리를 JSON 파일로 변환해 디스크에 저장 / 트리를 아카이브해 UserDefault에 저장
```
CoreData에 저장하고 불러오는 것이 생각보다 느려서, 저장방식의 문제인지 확인해보려고 영구저장소에 저장하는 두 가지 방법을 더 시도했다.
    → 데이터를 읽고 decode, unarchive하는 과정이 트리를 생성하는 시간보다 느렸다.
``` 

- Coordinate Fetch시 전체 데이터를 한번에 불러온 뒤, 불러온 데이터를 Filter하여 사용
```
CoreData에서 Fetch를 여러번 하는 것이 성능에 안 좋은지 확인해보기 위해 한번에 불러오고 직접 필터하는 방법을 시도했다.
    → 전체 데이터를 한번에 Fetch하는 시간이 바운더리 영역에 대해 여러번 Fetch 했을 때 시간보다 느렸다.
```

[ 관련 PR ] [https://github.com/boostcamp-2020/Project17-C-Map/pull/71]
[ 관련 PR ] [https://github.com/boostcamp-2020/Project17-C-Map/pull/59]

### 다양한 방법으로 클러스터링 알고리즘을 비교했어요! ( 🤼 Kmeans VS QuadTree 🤼 ) 

### **[KMeans](https://github.com/boostcamp-2020/Project17-C-Map/tree/master/Project17-C-Map/InteractiveClusteringMap/Clustering/KMeans)**
- KMeans 초기 중앙 점을 정하는 방법 
```
    1. 랜덤 
    2. 화면 기준 분할  
    3. ballCut 
```
[ 관련 PR ] https://github.com/boostcamp-2020/Project17-C-Map/pull/34
[ 관련 PR ] https://github.com/boostcamp-2020/Project17-C-Map/pull/37
    
- KMeans 구현
```
    1. 상태에 따라 클러스터링 종료 
    2. Coverage Distance 기준으로 클러스터링 종료
```
[ 관련 PR ] https://github.com/boostcamp-2020/Project17-C-Map/pull/31

- k값 검증 방법 
```
    1. 실루엣 검증
    2. DBI 검증
```
[ 관련 PR ] https://github.com/boostcamp-2020/Project17-C-Map/pull/46
[ 관련 PR ] https://github.com/boostcamp-2020/Project17-C-Map/pull/33


### **[QuadTree](https://github.com/boostcamp-2020/Project17-C-Map/tree/master/Project17-C-Map/InteractiveClusteringMap/Clustering/QuadTree)**

- 구현 과정
    1. [Quadtree bounding box 구현](https://github.com/boostcamp-2020/Project17-C-Map/pull/24)
    2. [Quadtree node 구현, 테스트](https://github.com/boostcamp-2020/Project17-C-Map/pull/25)
    3. [QuadtreeClusteringService 구현](https://github.com/boostcamp-2020/Project17-C-Map/pull/38)
    4. [Concurrent 방식의 QuadTree 생성](https://github.com/boostcamp-2020/Project17-C-Map/pull/59)



## 🏆 Kmeans VS QuadTree 🏆
### 결과 : QuadTree Win! 🥇
- 같은 8000개의 데이터로 동일한 조건에서 돌려봤을 때, QuadTree가 트리만드는 속도를 감안하고도 눈으로 봐도 더욱 빨랐다. 
- K-means는 알고리즘 자체로는 빠르지만, K값 검증 로직을 넣으면 급격히 속도가 떨어지는 것을 확인했다.
- K-means의 장점은 QuadTree에 비해 분포를 잘 나타낸다는 것인데, K 검증을 하지 못하면 무의미하게 되므로 QuadTree 알고리즘을 채택했다.
- QuadTree는 초기 트리 생성이 끝난 후 탐색할 때는 메모리나, CPU 사용량에서 매우 좋은 성능을 보였다.



