//
//  Scoreboard.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/9/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

class Scoreboard: SKShapeNode {

    private let starCount = SKLabelNode(text: "x0")
    private let lives = SKLabelNode(text: "x")
    private let timer = SKLabelNode(text: "0:00")

    init(scene: GameScene) {
        super.init()
        let width = CGRectGetWidth(scene.frame)
        let height = CGFloat(SPRITE_SIZE)
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        path = CGPathCreateWithRect(rect, nil)
        fillColor = SKColor.blackColor()
        zPosition = SCOREBOARD_BASE_LAYER

        var x = SPRITE_SIZE / 2
        let y = SPRITE_SIZE / 2
        let tomatoSprite = scene.pool.get(Cell.tomato)!
        tomatoSprite.position = CGPoint(x: x, y: y)
        tomatoSprite.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(tomatoSprite)
        x += SPRITE_SIZE + 8

        starCount.position = CGPoint(x: x, y: 8)
        starCount.fontColor = SKColor.whiteColor()
        starCount.fontSize = FONT_SIZE
        starCount.fontName = FONT_NAME
        starCount.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(starCount)
        x += SPRITE_SIZE * 2

        let livesSprite = scene.pool.get(Cell.player)!
        livesSprite.position = CGPoint(x: x, y: y)
        livesSprite.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(livesSprite)
        x += SPRITE_SIZE + 8

        lives.position = CGPoint(x: x, y: 8)
        lives.fontColor = SKColor.whiteColor()
        lives.fontSize = FONT_SIZE
        lives.fontName = FONT_NAME
        lives.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(lives)
        x += SPRITE_SIZE * 2

        timer.position = CGPoint(x: x, y: 8)
        timer.fontColor = SKColor.whiteColor()
        timer.fontSize = FONT_SIZE
        timer.fontName = FONT_NAME
        timer.zPosition = SCOREBOARD_CONTENT_LAYER
        addChild(timer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(player: Player) {
        starCount.text = "x\(player.stars)"
        lives.text = "x\(player.lives)"
        let seconds = (player.ticks / 60) % 60
        let minutes = (player.ticks / 3600)
        if seconds > 9 {
            timer.text = "\(minutes):\(seconds)"
        } else {
            timer.text = "\(minutes):0\(seconds)"
        }
    }
}
