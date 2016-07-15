//
//  Player.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/3/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

class Player: Agent {

    private let imageNames = ["turtle1", "turtle2", "turtle3"]
    private let startx: Int
    private let starty: Int
    var stars = 0
    var lives = 8
    var die = false
    var win = false
    var ticks: UInt64 = 0

    init(level: Level) {
        let (x, y) = level.findPlayer()
        let posx = x * SPRITE_SIZE
        let posy = y * SPRITE_SIZE
        startx = posx
        starty = posy
        super.init(level: level, imageNames: imageNames, posx: posx, posy: posy)
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
        posx = startx
        posy = starty
    }

    func kill() {
        die = true
        posx = startx
        posy = starty
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
            win = false
            moved = true
            scene.showBanner(CountDownBanner(scene: scene, text: "Level Complete!"))
        }
        return moved
    }

}
