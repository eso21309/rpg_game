import 'package:rpg_game/monster.dart';
import 'package:rpg_game/character.dart';
import 'dart:io';
import 'dart:math';

class Game {
  // 1. 기본 속성 정의하기
  late Character character;
  List<Monster> monsters = [];
  int defeatedMonsters = 0;

  // 2. 생성자 (초기 세팅에 오류가 있을 수 있으므로 상위로 한번 묶고)
  // 생성자는 클래스 안에!
  Game() {
    try {
      loadCharacterStats(); // 캐릭터 정보 로드
      loadMonsterStats(); // 몬스터들 정보 로드
    } catch (e) {
      //// ignore: avoid_print
      print('게임 초기화 중 오류 발생: $e');
      exit(1);
    }
  }

  //(그다음 상위 생성자 안에 있는 함수(데이터 가져오기)에 대한 것을 풀어감)

  // 3. 캐릭터 txt 데이터를 가져오는 메소드
  void loadCharacterStats() {
    //예외케이스 정의
    //예외케이스를 고려하여 전체를 try catch로 묶고 그 안에 변수와 객체를 정의함
    try {
      //변수 선언하기 - 파일 가져오기
      final file = File('assets/data/characters.txt');
      final contents = file.readAsStringSync();
      final stats = contents.split(',');
      //// ignore: prefer_const_constructors
      if (stats.length != 3) throw FormatException('Invalid character data');

      //생성자 부분 - 파일의 정보를 가공하여 코드에 맞게 변형하기
      int health = int.parse(stats[0]);
      int attack = int.parse(stats[1]);
      int defense = int.parse(stats[2]);

      //getCharacterName 메소드를 정의해줘야함.
      // 이름 입력값을 받는 방법! 조건 3가지 - 이부분이 이해하는게 어려웠음
      String getCharacterName() {
        //while (true)구문 이해하기 : 루프
        while (true) {
          //input의 힌트메시지 출력
          print('캐릭터의 이름을 입력해주세요(한글 또는 영문만 가능):');
          String? input = stdin.readLineSync();

          //유효성 검사 : 해당되면 리턴값 뱉고 반복문 끝남
          if (input != null &&
              input.isNotEmpty &&
              RegExp(r'^[a-zA-Z가-힣]+$').hasMatch(input)) {
            return input;
          }

          //if에 해당되지 않으면 에러라고 생각하고 다음 순서인 프린트 값 출력
          print('올바르지 않은 이름입니다. 다시 입력해주세요.');
        }
      }

      //위에서 정의한 캐릭터이름 얻기의 변수를 객체로 생성함
      //이 게임클래스에서 사용할 변수인 name과 character를 정의
      //생성자 형태
      String name = getCharacterName(); //순서상 변수 정의 다음에 와야함
      character = Character(name, health, attack, defense);
    } catch (e) {
      print('캐릭터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  // 4. 몬스터 txt 데이터를 가져오는 메소드
  List<Monster> loadMonsterStats() {
    try {
      //변수 선언하기
      final file = File('assets/data/monsters.txt');
      final contents = file.readAsStringSync();
      final lines = contents.split('\n'); // 줄별로 분리

      for (var line in lines) {
        final stats = line.split(','); //가독성때문에 라인을 분리하는 것임
        if (stats.length != 3) continue; // 잘못된 형식은 건너뛰기

        //생성자 부분
        String name = stats[0];
        int health = int.parse(stats[1]);
        int maxAttackPower = int.parse(stats[2]);

        monsters.add(Monster(name, health, maxAttackPower));
      }
      //메소드 실행 부분
      return monsters;
    } catch (e) {
      print('몬스터 데이터를 불러오는 데 실패했습니다: $e');
      exit(1);
    }
  }

  //몬스터를 랜덤하게 가져오기 위한 변수 정의
  Monster getRandomMonster() {
    if (monsters.isEmpty) {
      throw Exception('남은 몬스터가 없습니다!');
    }
    final random = Random();
    return monsters[random.nextInt(monsters.length)];
  }

  //게임 결과 저장 메소드
  void saveGameResult(String result) {
    print('결과를 저장하시겠습니까? (y/n)');
    String? input = stdin.readLineSync()?.toLowerCase();

    if (input == 'y') {
      try {
        final file = File('assets/data/result.txt');
        final contents = '캐릭터: ${character.name}\n'
            '남은 체력: ${character.health}\n'
            '게임 결과: $result';
        file.writeAsString(contents);
        print('게임 결과가 저장되었습니다!');
      } catch (e) {
        print('결과 저장에 실패했습니다: $e');
      }
    }
  }

  // 5. 게임 실행 메소드
  void startGame() {
    print('\n============ RPG 게임 시작 ============');
    print('${character.name}님 환영합니다!');
    character.showStatus();

    bool isGameOver = false;

    //게임이 끝나지 않았다면 계속 반복하기
    while (!isGameOver) {
      if (monsters.isEmpty) {
        print('\n 축하합니다! 모든 몬스터를 물리쳤습니다!');
        saveGameResult('승리');
        isGameOver = true;
        continue;
      }

      //랜덤 몬스터 선택
      Monster currentMonster = getRandomMonster();
      print('\n새로운 몬스터가 나타났습니다!');
      print('${currentMonster.name}과(와) 전투를 시작합니다!');

      battle(currentMonster);

      //캐릭터 사망 체크
      if (character.health <= 0) {
        print('\n 캐릭터가 사망했습니다... 게임 오버');
        saveGameResult('패배');
        isGameOver = true;
        continue;
      }

      //다음 전투 여부 확인
      print('\n다음 몬스터와 대결하시겠습니까? (y/n)');
      String? input = stdin.readLineSync()?.toLowerCase();

      if (input != 'y') {
        print('\n게임을 종료합니다.');
        saveGameResult('중도포기');
        isGameOver = true;
      }
    }
  }

  void battle(Monster monster) {
    print('\n============전투 시작 =========');

    monster.calculateAttackPower(character.defense);

    while (monster.health > 0 && character.health > 0) {
      //상태 출력
      print('\n[현재 상태]');
      character.showStatus();
      monster.showStatus();

      //플레이어 턴
      print('\n무엇을 하시겠습니까?');
      print('[1] 공격하기 / [2] 방어하기');

      String? input = stdin.readLineSync();

      switch (input) {
        case '1':
          character.attackMonster(monster);
          break;
        case '2':
          character.defend(monster);
          break;
        default:
          print('잘못된 입력입니다. 턴을 넘깁니다.');
      }

      //몬스터가 죽었는지 체크
      if (monster.health <= 0) {
        print('\n 몬스터를 물리쳤습니다!');
        defeatedMonsters++;

        //물리친 몬스터 목록에서 제거
        monsters.remove(monster);
        break;
      }

      //몬스터 턴
      print('\n몬스터의 턴!');
      monster.attackCharacter(character);
    }
    print('\n==========전투 종료 ===========');
  }
}
