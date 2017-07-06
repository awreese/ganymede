/**
 *  Astrorush: TBD (The Best Defense)
 *  Copyright (C) 2017  Andrew Reese, Daisy Xu, Rory Soiffer
 *
 * This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package gameUnits.weapons.turrets;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.weapon.FlxWeapon.FlxTypedWeapon;
import flixel.addons.weapon.FlxWeapon.FlxWeaponFireFrom;
import flixel.addons.weapon.FlxWeapon.FlxWeaponSpeedMode;
import flixel.system.FlxSound;
import flixel.util.helpers.FlxBounds;
import gameUnits.combat.I_Combatant;
import gameUnits.weapons.I_Weapon;
import gameUnits.weapons.WeaponSize;
import gameUnits.weapons.ammunition.Ammunition.Charge;
import gameUnits.weapons.ammunition.Laser;

/**
 * This class represents the in-game turrets.
 * 
 * Basic turret classes are (high damage low range/low damage high range): 
 * Energy (Pulse/Beam Laser)
 * Projectile (Autocannon/Artillery)
 * Hybrid (Blasters/Railguns)
 * 
 * @author Drew Reese
 */
class Turret extends FlxTypedWeapon<Charge> implements I_Weapon {
    
    private var source:I_Combatant;
	private var size(get, null):WeaponSize;

    /**
     * Constructs new turret.
     * @param source    source object for this turret
     * @param name  name of this turret
     * @param chargeFactory factory that produces charges for this turret
     * @param fireFrom  location to spawn charges
     * @param speedMode speed of charges
     */
    private function new(source:FlxSprite, name:String, chargeFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
        super(name, chargeFactory, fireFrom, speedMode);
		
        this.rotateBulletTowardsTarget = true;
        this.source = cast(source, I_Combatant);
        
        FlxG.state.add(this.group);
    }
    
    /**
     * Returns the size of this weapon.
     * @return size of this weapon
     */
    public function get_size():WeaponSize {
        return this.size;
    }
    
    /**
     * Fires charge at selected target.
     */
    public function fire():Void {
        var target = source.selectTarget();
        if (target != null && fireAtTarget(cast(target, FlxSprite))) {
            currentBullet.target = cast(target, FlxSprite);
        }
    }
    
}

/**
 * Energy Turrets - Pulse & Beam Lasers
 */
class Energy extends Turret {
	
	private function new(source:FlxSprite, name:String, ammoFactory:FlxTypedWeapon<Charge>->Charge, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		super(source, name, ammoFactory, fireFrom, speedMode);
		
		var laser_snd:FlxSound;
		#if flash
			laser_snd = FlxG.sound.load(AssetPaths.laser__mp3);
		#else
			laser_snd = FlxG.sound.load(AssetPaths.laser__ogg);
		#end
		laser_snd.looped = false;
		this.onPreFireSound = laser_snd;
	}
}

class GatlingPulseLaser extends Energy {
    
    public function new(source:FlxSprite) {
        super(source, "Gatling Pulse Laser I", 
            function(d) {
                var pulse = new Pulse_Small(true);
                return pulse;
            }, 
            FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), false), 
            FlxWeaponSpeedMode.SPEED(Laser.PULSE_SPEED)
        );
        this.bulletLifeSpan = Pulse_Small.LIFESPAN;
		this.fireRate = 500;
        this.size = WeaponSize.SMALL;
    }
}

class SmallFocusedBeamLaser extends Energy {
    
    public function new(source:FlxSprite) {
        super(source, "Small Focused Beam Laser I",
            function(d) {
                var beam = new Beam_small(cast (source, I_Combatant), false);
                return beam;
            },
            FlxWeaponFireFrom.PARENT(source, new FlxBounds(source.origin), false),
            FlxWeaponSpeedMode.SPEED(Laser.BEAM_SPEED)
        );
        this.bulletLifeSpan = new FlxBounds(1.0);
        this.fireRate = 5000;
        this.size = WeaponSize.SMALL;
    }
}

//class Hybrid extends FlxTypedWeapon<HybridAmmo> {
	//
	//public function new(name:String, ammoFactory:FlxTypedWeapon<HybridAmmo>->HybridAmmo, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		//super(name, ammoFactory, fireFrom, speedMode);
		//
	//}
//}

//class Projectile extends FlxTypedWeapon<ProjectileAmmo> {
	//
	//public function new(name:String, ammoFactory:FlxTypedWeapon<ProjectileAmmo>->ProjectileAmmo, fireFrom:FlxWeaponFireFrom, speedMode:FlxWeaponSpeedMode) {
		//super(name, ammoFactory, fireFrom, speedMode);
		//
	//}
//}
