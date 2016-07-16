//
//  Player.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/3/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

class Player: Agent {

    private let imageNames = ["turtle1", "turtle2", "turtle3"]
    var stars = 0
    var lives = 8
    var die = false
    var win = false
    var ticks: UInt64 = 0

    init() {
        super.init(imageNames: imageNames, posx: 0, posy: 0)
    }

    override func reset(level: Level) {
        super.reset(level)
        let (x, y) = level.findPlayer()
        posx = x * SPRITE_SIZE
        posy = y * SPRITE_SIZE
    }

    override func hit(scene: GameScene, _ x: Int, _ y: Int) {
        let t = level.get(x, y)
        if t == Cell.brick {
            level.set(x, y, Cell.space)
        }
    }

    override func touch(scene: GameScene, _ x: Int, _ y: Int) {
        let t = level.get(x, y)
        switch t {
        case Cell.tomato:
            level.set(x, y, Cell.space)
            stars += 1
        case Cell.star:
            clear()
        case Cell.tar:
            kill()
        default:
            break
        }
    }

    func clear() {
        win = true
    }

    func kill() {
        die = true
        let (x, y) = level.findPlayer()
        posx = x * SPRITE_SIZE
        posy = y * SPRITE_SIZE
    }

    override func update(scene: GameScene) -> Bool {
        var moved = super.update(scene)
        ticks += 1
        moved = moved || (ticks % 60) == 0
        if die {
            lives -= 1
            die = false
            moved = true
            if lives == 0 {
                scene.showBanner(GameOverBanner(scene: scene))
            } else {
                scene.showBanner(CountDownBanner(scene: scene, text: "Lives: \(lives)"))
            }
        } else if win {
            scene.nextLevel()
            win = false
            moved = true
        }
        return moved
    }

}
