//
//  Agent.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/3/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

class Agent {

    private let speedx = 8
    private let speedy = 16
    private let jumpSize = 12

    let level: Level
    var sprites: [SKSpriteNode] = []
    var spriteIndex = 0
    var posx: Int
    var posy: Int
    var vx: Int = 0
    var jumpCounter: Int = 0

    init(level: Level, imageNames: [String], posx: Int, posy: Int) {
        self.level = level
        self.posx = posx
        self.posy = posy
        for name in imageNames {
            let node = SKSpriteNode(imageNamed: name)
            node.xScale = 1
            node.size = CGSize(width: spriteSize, height: spriteSize)
            node.zPosition = 2
            sprites.append(node)
        }
    }

    func nextSprite() {
        spriteIndex = (spriteIndex + 1) % sprites.count
        sprites[spriteIndex].xScale = 1
    }

    func prevSprite() {
        spriteIndex = (spriteIndex + 1) % sprites.count
        sprites[spriteIndex].xScale = -1
    }

    func sprite() -> SKSpriteNode {
        return sprites[spriteIndex]
    }

    final func jump() {
        // Must be on the ground to jump.
        let absx1 = posx / spriteSize
        let absx2 = (posx + spriteSize - 1) / spriteSize
        let absy = (posy / spriteSize) + 1
        let t1 = level.get(absx1, absy)
        let t2 = level.get(absx2, absy)
        if t1 != Cell.space || t2 != Cell.space {
            jumpCounter = jumpSize
        }
    }

    final func move(dx: Int) {
        vx = dx * speedx
    }

    func hit(scene: GameScene, _ x: Int, _ y: Int) {
    }

    func touch(scene: GameScene, _ x: Int, _ y: Int) {
    }

    private func updatex(scene: GameScene) -> Bool {
        var moved = false
        if vx != 0 {
            if vx > 0 {
                nextSprite()
            } else {
                prevSprite()
            }
            let nextx = posx + vx
            let offsetx = vx > 0 ? spriteSize - 1 : 0
            let absx = (nextx + offsetx) / spriteSize
            let absy1 = posy / spriteSize
            let absy2 = (posy + spriteSize - 1) / spriteSize
            let t1 = level.get(absx, absy1)
            let t2 = level.get(absx, absy2)
            if !level.isWall(t1) && !level.isWall(t2) {
                posx = nextx
                moved = true
            }
            if t1 != Cell.space {
                touch(scene, absx, absy1)
            }
            if t2 != Cell.space {
                touch(scene, absx, absy2)
            }
        }
        return moved
    }

    private func updatey(scene: GameScene) -> Bool {
        var moved = false
        let absx1 = posx / spriteSize
        let absx2 = (posx + spriteSize - 1) / spriteSize
        if jumpCounter > 0 {
            // Jumping
            let nexty = posy - speedy
            let absy = nexty / spriteSize
            let t1 = level.get(absx1, absy)
            let t2 = level.get(absx2, absy)
            if !level.isWall(t1) && !level.isWall(t2) {
                jumpCounter -= 1
                posy = nexty
                moved = true
            } else {
                jumpCounter = 0
            }
            if t1 != Cell.space {
                hit(scene, absx1, absy)
                touch(scene, absx1, absy)
            }
            if  t2 != Cell.space {
                hit(scene, absx2, absy)
                touch(scene, absx2, absy)
            }
        } else {
            // Falling
            let nexty = posy + speedy
            let absy = (nexty + spriteSize - 1) / spriteSize
            let t1 = level.get(absx1, absy)
            let t2 = level.get(absx2, absy)
            if !level.isWall(t1) && !level.isWall(t2) {
                posy = nexty
                moved = true
            }
            if t1 != Cell.space {
                touch(scene, absx1, absy)
            }
            if t2 != Cell.space {
                touch(scene, absx2, absy)
            }
        }
        return moved
    }

    func update(scene: GameScene) -> Bool {
        let movex = updatex(scene)
        let movey = updatey(scene)
        return movex || movey
    }

}
