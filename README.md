# rpg_game
## ⚔️ 게임 시스템 설명

### 캐릭터

- 속성: 이름, 체력, 공격력, 방어력
- 행동: 공격, 방어, 상태 확인

### 몬스터

- 속성: 이름, 체력, 공격력(랜덤)
- 행동: 공격, 상태 확인

## 📝 저장 시스템

- 게임 종료 시 결과 저장 가능
- 저장 정보: 캐릭터 이름, 남은 체력, 게임 결과

## 📁 프로젝트 구조 및 설계

### 클래스 구조

```
Copy
project/
├── lib/
│   ├── character.dart   # 캐릭터 클래스
│   │   monster.dart     # 몬스터 클래스
│   ├── game.dart        # 게임 메인 로직
│   └── main.dart        # 프로그램 시작점
├── data/
│   ├── characters.txt      # 캐릭터 기본 스탯 정보
│   ├── monsters.txt        # 몬스터 정보 목록
│   └── result.txt         # 게임 결과 저장
└── README.md

```

### 📌 주요 클래스 설명

## 1. Character 클래스

class Character {
  String name;// 캐릭터 이름
  int health;// 체력
  int attackPower;// 공격력
  int defense;// 방어력

// 주요 기능
  - 몬스터 공격 (attackMonster)
  - 방어 (defend)
  - 상태 확인 (showStatus)
}

```

## 2. Monster 클래스

class Monster {
  String name;// 몬스터 이름
  int health;// 체력
  int maxAttackPower;// 최대 공격력

// 주요 기능
  - 캐릭터 공격 (attackCharacter)
  - 상태 확인 (showStatus)
}

```

## 3. Game 클래스

class Game {
  Character character;// 플레이어 캐릭터
  List<Monster> monsters;// 몬스터 목록
  int defeatedMonsters;// 처치한 몬스터 수

// 주요 기능
  - 게임 시작 (startGame)
  - 전투 진행 (battle)
  - 랜덤 몬스터 선택 (getRandomMonster)
  - 파일 데이터 로드 (loadGameData)
  - 결과 저장 (saveResult)
}

```

### 💾 데이터 파일 구조

## characters.txt

체력,공격력,방어력
100,20,10

```

## monsters.txt

이름,체력,최대공격력
슬라임,50,15
고블린,70,20
드래곤,200,45

```

## result.txt

캐릭터이름,남은체력,게임결과(승리/패배)
용사,80,승리

```

### 🔄 주요 프로세스 흐름

1. main.dart에서 Game 인스턴스 생성
2. 게임 시작 전 파일에서 데이터 로드
3. 캐릭터 이름 입력 받아 게임 시작
4. 턴제 전투 진행
5. 게임 종료 시 결과 저장
