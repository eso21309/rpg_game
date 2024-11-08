import 'dart:math';

import 'package:rpg_game/character.dart';

class Monster {
  String name;
  int health;
  int maxAttackPower;
  late int currentAttackPower;
  int defense = 0;

  Monster(this.name, this.health, this.maxAttackPower);

  void calculateAttackPower(int characterDefense) {
    currentAttackPower =
        max(Random().nextInt(maxAttackPower + 1), characterDefense);
  }

  void attackCharacter(Character character) {
    int damage = max(0, currentAttackPower - character.defense);
    character.health -= damage;
    print('$name이(가) ${character.name}에게 $damage의 데미지를 입혔습니다!');
  }

  void showStatus() {
    print('이름: $name');
    print('체력: $health');
    print('현재 공격력: $currentAttackPower');
  }
}
