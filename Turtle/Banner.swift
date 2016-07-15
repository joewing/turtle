//
//  Banner.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/12/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit


class Banner: SKShapeNode {

    init(scene: GameScene) {
        super.init()

        let width = 2 * CGRectGetWidth(scene.frame) / 3
        let height = CGFloat(spriteSize * 2)
        let x = CGRectGetWidth(scene.frame) / 2 - width / 2
        let y = CGRectGetHeight(scene.frame) / 2 - height / 2
        let rect = CGRect(x: x, y: y, width: width, height: height)
        path = CGPathCreateWithRect(rect, nil)
        fillColor = SKColor.blackColor()
        strokeColor = SKColor.whiteColor()
        zPosition = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update() -> Bool {
        return false
    }
}

class CountDownBanner: Banner {
    private static let counterStart = 3 * 60
    private let bar = SKShapeNode()

    var counter: Int = counterStart
    var label = SKLabelNode()

    init(scene: GameScene, text: String) {
        super.init(scene: scene)
        let width = CGRectGetWidth(self.frame)
        let x = CGRectGetMinX(self.frame)
        let y = CGRectGetMinY(self.frame)
        let rect = CGRect(x: x, y: y, width: width, height: CGFloat(spriteSize / 8))
        bar.path = CGPathCreateWithRect(rect, nil)
        bar.fillColor = SKColor.greenColor()
        bar.zPosition = 3
        label.text = text
        label.fontColor = SKColor.whiteColor()
        label.fontSize = CGFloat(spriteSize)
        label.fontName = "Courier"
        label.position = CGPoint(x: x + width / 2, y: y + CGFloat(spriteSize))
        label.zPosition = 3
        addChild(label)
        addChild(bar)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() -> Bool {
        if counter > 0 {
            counter -= 1
            let width = Int(CGRectGetWidth(self.frame))
            let x = CGRectGetMinX(self.frame)
            let y = CGRectGetMinY(self.frame)
            let rect = CGRect(x: x, y: y,
                              width: CGFloat(width * counter / LevelBanner.counterStart),
                              height: CGFloat(spriteSize / 8))
            bar.path = CGPathCreateWithRect(rect, nil)
            return true
        } else {
            return false
        }
    }
}

class LevelBanner: CountDownBanner {
    init(scene: GameScene, level: Int) {
        super.init(scene: scene, text: "Level \(level)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameOverBanner: Banner {
    override init(scene: GameScene) {
        super.init(scene: scene)
        let width = CGRectGetWidth(self.frame)
        let x = CGRectGetMinX(self.frame)
        let y = CGRectGetMinY(self.frame)
        let label = SKLabelNode(text: "Game Over")
        label.fontColor = SKColor.whiteColor()
        label.fontSize = CGFloat(spriteSize)
        label.fontName = "Courier"
        label.position = CGPoint(x: x + width / 2, y: y + CGFloat(spriteSize))
        label.zPosition = 3
        addChild(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update() -> Bool {
        return true
    }
}
