import 'dart:math';

import 'package:rpg_game/monster.dart';

class Character {
  String name; // 캐릭터 이름
  int health; // 현재 체력
  int attackPower; // 고정 공격력 (max 삭제, 이름도 변경)
  int defense; // 방어력

  // 생성자도 수정
  Character(this.name, this.health, this.attackPower, this.defense);

  // calculateAttackPower 메서드는 불필요 (삭제)

  // 몬스터를 공격하는 메서드
  void attackMonster(Monster monster) {
    // 최종 데미지 = 고정 공격력 - 몬스터 방어력
    int damage = max(0, attackPower - monster.defense);
    monster.health -= damage;
    print('$name이(가) ${monster.name}에게 $damage의 데미지를 입혔습니다!');
  }

  void defend(Monster monster) {
    health += monster.currentAttackPower;
  }

  void showStatus() {
    print('이름: $name');
    print('체력: $health');
    print('공격력: $attackPower'); // current 삭제
    print('방어력: $defense');
  }
}
