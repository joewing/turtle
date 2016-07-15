//
//  GameScene.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 6/29/16.
//  Copyright (c) 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

let spriteSize = 64

class GameScene: SKScene {

    let pool = SpritePool(size: spriteSize)
    private var scoreboard: Scoreboard!
    private var field: SKCropNode!
    private var level: Level!
    private var viewx: Int = 0
    private var viewy: Int = 0
    private var basey: Int = 0
    private var player: Player!
    private var agents: [Agent] = []
    private var lastUpdate: CFTimeInterval = 0.0
    private var banner: Banner?

    override func didMoveToView(view: SKView) {
        reset()
    }

    private func reset() {
        initField()
        initScore()
        level = Level(filename: "level1")
        player = Player(level: level)
        field.addChild(player.sprite())
        for (x, y) in level.getAgents() {
            let agent = Enemy(level: level, player: player, x: x, y: y)
            field.addChild(agent.sprite())
            agents.append(agent)
        }
        viewx = 0
        viewy = 0
        render()
        showBanner(LevelBanner(scene: self, level: 1))
    }

    func showBanner(banner: Banner) {
        if self.banner != nil {
            self.banner!.removeFromParent()
        }
        self.banner = banner
        field.addChild(banner)
    }

    private func initField() {
        let x = CGFloat(0)
        let y = CGFloat(spriteSize)
        let width = CGRectGetWidth(self.frame)
        let height = CGRectGetHeight(self.frame) - CGFloat(spriteSize)
        let node = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: height))
        node.fillColor = NSColor(calibratedRed: 0.4, green: 0.5, blue: 0.9, alpha: 1)
        field = SKCropNode()
        field.maskNode = node
        field.zPosition = 0
        self.addChild(field)
    }

    private func initScore() {
        scoreboard = Scoreboard(scene: self)
        addChild(scoreboard)
    }

    func remove(agent: Agent) {
        agents = agents.filter({ e in agent !== e })
    }

    private func render() {
        let width = Int(CGRectGetWidth(self.frame))
        let height = Int(CGRectGetHeight(self.frame))
        let viewWidth = (width + spriteSize - 1) / spriteSize
        let viewHeight = (height + spriteSize - 1) / spriteSize

        // Keep X centered around the player.
        viewx = player.posx - spriteSize * viewWidth / 2 + spriteSize
        viewx = max(0, viewx)

        // Keep Y the same unless the player moves more than half way
        // up the view or if the player goes down.
        let maxy = player.posy - spriteSize * (viewHeight - 9)
        let miny = player.posy - spriteSize * (viewHeight - 4)
        if basey == 0 {
            basey = miny
        }
        viewy = basey
        viewy = min(viewy, maxy)
        viewy = max(viewy, miny)

        // Render the new field.
        // We render 1 additional cell in each direction.
        field.removeAllChildren()
        for y in -1...viewHeight {
            for x in -1...viewWidth + 1 {
                renderCell(x, y)
            }
        }

        renderAgent(player)
        for agent in agents {
            renderAgent(agent)
        }
    }

    private func renderCell(x: Int, _ y: Int) {
        let cellx = x + (viewx / spriteSize)
        let celly = y + (viewy / spriteSize)
        let c = level!.get(cellx, celly)
        if c == Cell.space {
            return
        }
        let sprite = pool.get(c)
        if sprite != nil {
            let height = Int(CGRectGetHeight(self.frame))
            let posx = (x * spriteSize) + spriteSize - (viewx % spriteSize)
            let posy = height - (y * spriteSize) + (viewy % spriteSize)
            sprite!.position = CGPoint(x: posx, y: posy)
            field.addChild(sprite!)
        }
    }

    func renderAgent(agent: Agent) {
        let height = Int(CGRectGetHeight(self.frame))
        let posx = agent.posx - viewx + spriteSize
        let posy = height - (agent.posy - viewy)
        let sprite = agent.sprite()
        sprite.position = CGPoint(x: posx, y: posy)
        field.addChild(sprite)
    }

    override func keyDown(theEvent: NSEvent) {
        let key = theEvent.keyCode
        switch key {
        case 0, 123: // "a" - left
            player.move(-1)
        case 1, 125: // "s" - down
            return
        case 2, 124: // "d" - right
            player.move(1)
        case 13, 126: // "w" - up
            return
        case 49: // space - jump
            player.jump()
        case 53: // esc
            exit(0);
        default:
            print(key)
            return
        }
    }

    override func keyUp(theEvent: NSEvent) {
        let key = theEvent.keyCode
        switch key {
        case 0, 123: // "a" - left
            player.move(0)
        case 1, 125: // "s" - down
            return
        case 2, 124: // "d" - right
            player.move(0)
        case 13, 126: // "w" - up
            return
        default:
            return
        }
    }

    override func update(currentTime: CFTimeInterval) {
        if lastUpdate != 0.0 {
            let diff = currentTime - lastUpdate
            let iterations = max(1, Int(60 * diff))
            var moved = false
            for _ in 0..<iterations {
                if banner != nil {
                    if !banner!.update() {
                        banner!.removeFromParent()
                        banner = nil
                    }
                } else {
                    if player.update(self) {
                        moved = true
                    }
                    for agent in agents {
                        if agent.update(self) {
                            moved = true
                        }
                    }
                }
            }
            if moved && banner == nil {
                scoreboard.update(player)
                render()
            }
        }
        lastUpdate = currentTime
    }
}
