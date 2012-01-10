(function() {
  /*
  	sengoku
  */
  var DIE_MAX, DIE_MIN, HIT_MISS, ROUND, Samurai, calcHit, canHit, combat, dieRoll, enemies, musashi, round, toggle, yojimbo;
  DIE_MIN = 1;
  DIE_MAX = 6;
  HIT_MISS = 0;
  dieRoll = function() {
    return Math.floor(Math.random() * 6) + 1;
  };
  combat = function(assailant, target) {
    var attack, block, defense, hit, mod, offense, roll;
    if (target.life <= 0) {
      throw "stop hitting on the corpse asshole!";
    }
    offense = assailant.name;
    defense = target.name;
    attack = assailant.attack;
    block = target.block;
    roll = dieRoll();
    if (roll === DIE_MIN) {
      return console.log("[die:" + roll + "] <" + offense + ":" + attack + "> attacks <" + defense + ":" + block + "> and misses.");
    } else if (roll === DIE_MAX) {
      hit = dieRoll();
      console.log("[die:" + roll + "] <" + offense + ":" + attack + "> attacks <" + defense + ":" + block + "> with a direct hit! (" + hit + ")");
      return target.fail(hit, assailant);
    } else {
      mod = attack + (roll - DIE_MID);
      hit = block - mod;
      if (hit > 0) {
        console.log("[die:" + roll + "] <" + offense + ":" + attack + "> attacks <" + defense + ":" + block + "> and hits. (" + hit + ")");
        return target.fail(hit, assailant);
      } else {
        return console.log("[die:" + roll + "] <" + offense + ":" + attack + "> attacks <" + defense + ":" + block + "> and gets blocked.");
      }
    }
  };
  canHit = function(attacker, target, roll) {
    var canhit;
    canhit = [];
    if (target.life <= 0) {
      canhit = [false, 'dead'];
    } else if (roll === DIE_MIN) {
      canhit = [false, 'miss'];
    } else if (roll === DIE_MAX) {
      canhit = [true, 'critical'];
    } else {
      canhit = [true, 'hit'];
    }
    return canhit;
  };
  calcHit = function(attacker, target, roll) {
    var can, dif, hit, output, type, _ref;
    _ref = canHit(attacker, target, roll), can = _ref[0], type = _ref[1];
    output = [can, type];
    if (can) {
      dif = attacker.strength + (roll - Math.floor(DIE_MIN + DIE_MAX / 2));
      hit = target.block - dif;
      if (type === 'critical') {
        hit += dieRoll();
      }
      hit = hit + (attacker.weapon - target.armor);
      if (hit <= 0) {
        can = false;
        output[1] = 'blocked';
        hit = 0;
      }
      if (hit >= target.life) {
        output[1] = 'kill';
        hit = target.life;
      }
      output.push(hit);
    } else {
      output.push(hit = 0);
    }
    target.life = target.life - hit;
    return output;
  };
  Samurai = (function() {
    Samurai.prototype.toString = function() {
      return "<" + this.name + ":[L:" + this.life + ",S:" + this.strength + ",D:" + this.block + "]>";
    };
    function Samurai(name) {
      this.name = name;
      this.life = (5 * dieRoll()) + 5;
      this.strength = dieRoll();
      this.block = dieRoll();
      if (this.attack === 6 && this.block === 6) {
        this.block = this.block - dieRoll();
      }
      this.armor = 1;
      this.weapon = 1;
      return this;
    }
    Samurai.prototype.attack = function(target) {
      var can, hit, roll, type, _ref;
      roll = dieRoll();
      if (this.life === 0) {
        return console.log("In his/her tomb, " + this + " dreams of combat.");
      } else {
        _ref = calcHit(this, target, roll), can = _ref[0], type = _ref[1], hit = _ref[2];
        if (can) {
          return console.log("" + this + " rolled a " + roll + " to attack " + target + " with success [" + type + ", " + hit + "]");
        } else {
          if (type === 'dead') {
            return console.log("" + this + " is raping CORPSES!");
          } else {
            return console.log("" + this + " rolled a " + roll + " to attack " + target + " and failed [" + type + ", " + hit + "]");
          }
        }
      }
    };
    return Samurai;
  })();
  musashi = new Samurai('Myamoto Musashi');
  yojimbo = new Samurai('Yojimbo');
  enemies = [yojimbo, musashi];
  ROUND = 0;
  toggle = (function() {
    var i;
    i = 0;
    return function() {
      return i++ % 2;
    };
  })();
  round = function() {
    var a, b;
    a = toggle();
    b = toggle();
    toggle();
    enemies[a].attack(enemies[b]);
    if (enemies[a].life === 0 || enemies[b].life === 0) {
      return console.log("END");
    } else {
      return setTimeout(round, 500);
    }
  };
  setTimeout(round, 500);
}).call(this);
