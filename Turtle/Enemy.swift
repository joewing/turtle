//
//  Enemy.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/3/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

class Enemy: Agent {

    private var direction = 1
    private let player: Player

    init(player: Player, x: Int, y: Int) {
        self.player = player
        let posx = x * SPRITE_SIZE
        let posy = y * SPRITE_SIZE
        super.init(imageNames:["ghost"], posx: posx, posy: posy)
    }

    override func touch(scene: GameScene, _ x: Int, _ y: Int) {
        let t = level.get(x, y)
        if t == Cell.tar {
            scene.remove(self)
        }
    }

    override func update(scene: GameScene) -> Bool {
        var moved = super.update(scene)
        if !moved {
            direction = -direction
            move(direction)
        }
        let rect1 = CGRect(x: posx, y: posy, width: SPRITE_SIZE, height: SPRITE_SIZE)
        let rect2 = CGRect(x: player.posx, y: player.posy, width: SPRITE_SIZE, height: SPRITE_SIZE)
        if rect1.intersects(rect2) {
            player.kill()
            scene.remove(self)
            moved = true
        }
        return moved
    }
}
