//
//  Scoreboard.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/9/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

class Scoreboard: SKShapeNode {

    private let tomatoCount = SKLabelNode(text: "xXX")
    private let lives = SKLabelNode(text: "XX")
    private let timer = SKLabelNode(text: "XX:XX")
    private let level = SKLabelNode(text: "Level: XX")

    init(scene: GameScene) {
        super.init()
        let width = CGRectGetWidth(scene.frame)
        let height = CGFloat(SPRITE_SIZE)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        path = CGPathCreateWithRect(rect, nil)
        fillColor = SKColor.blackColor()
        zPosition = SCOREBOARD_BASE_LAYER

        var x = CGFloat(0)
        let spacing = CGFloat(SPRITE_SIZE)
        let padding = CGFloat(4)

        // Level
        x = initLabel(level, x) + spacing

        // Lives
        let livesSprite = scene.pool.create(Cell.player)!
        x = initSprite(livesSprite, x) + padding
        x = initLabel(lives, x) + spacing

        // Tomatos
        let tomatoSprite = scene.pool.create(Cell.tomato)!
        x = initSprite(tomatoSprite, x) + padding
        x = initLabel(tomatoCount, x) + spacing

        // Timer
        x = initLabel(timer, x) + spacing

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initNode(node: SKNode, _ x: CGFloat, _ y: CGFloat) -> CGFloat {
        let nodex = x + CGRectGetWidth(node.frame) / 2
        node.position = CGPoint(x: nodex, y: y)
        node.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(node)
        return x + CGRectGetWidth(node.frame)
    }

    private func initSprite(sprite: SKSpriteNode, _ x: CGFloat) -> CGFloat {
        let spritey = CGFloat(SPRITE_SIZE) / 2
        return initNode(sprite, x, spritey)
    }

    private func initLabel(label: SKLabelNode, _ x: CGFloat) -> CGFloat {
        label.fontColor = SKColor.whiteColor()
        label.fontSize = FONT_SIZE
        label.fontName = FONT_NAME
        let labely = CGRectGetHeight(frame) / 2 - CGRectGetHeight(label.frame) / 2
        return initNode(label, x, labely)
    }

    func update(player: Player) {
        tomatoCount.text = "x\(player.stars)"
        lives.text = "x\(player.lives)"
        level.text = "Level \(player.level.id)"
        let seconds = (player.ticks / 60) % 60
        let minutes = (player.ticks / 3600)
        if seconds > 9 {
            timer.text = "\(minutes):\(seconds)"
        } else {
            timer.text = "\(minutes):0\(seconds)"
        }
    }
}
