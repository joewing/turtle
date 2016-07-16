//
//  GameScene.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 6/29/16.
//  Copyright (c) 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

let SPRITE_SIZE = 64
let FONT_NAME = "Courier"
let FONT_SIZE = CGFloat(SPRITE_SIZE - 4)

typealias GameLayer = CGFloat
let FIELD_LAYER: GameLayer = 0
let SCOREBOARD_BASE_LAYER: GameLayer = 0
let SCOREBOARD_CONTENT_LAYER: GameLayer = 1
let CELL_LAYER: GameLayer = 1
let AGENT_LAYER: GameLayer = 2
let BANNER_BASE_LAYER: GameLayer = 3
let BANNER_CONTENT_LAYER: GameLayer = 4

let LEVELS = [
    "level1",
    "level2",
]

class GameScene: SKScene {

    let pool = SpritePool(size: SPRITE_SIZE)
    private var scoreboard: Scoreboard!
    private var field: SKCropNode!
    private var levelIndex: Int = 0
    private var level: Level!
    private var viewx: Int = 0
    private var viewy: Int = 0
    private var basey: Int = 0
    private var player: Player!
    private var agents: [Agent] = []
    private var lastUpdate: CFTimeInterval = 0.0
    private var banner: Banner?

    override func didMoveToView(view: SKView) {
        initField()
        initScore()
        reset()
    }

    private func reset() {
        level = Level(filename: LEVELS[levelIndex])
        player = Player(level: level)
        agents = []
        for (x, y) in level.getAgents() {
            let agent = Enemy(level: level, player: player, x: x, y: y)
            agents.append(agent)
        }
        viewx = 0
        viewy = 0
        render()
        if levelIndex == 0 {
            showBanner(CountDownBanner(scene: self, text: "Get Ready!"))
        } else {
            showBanner(CountDownBanner(scene: self, text: "Level Complete!"))
        }
    }

    final func nextLevel() {
        levelIndex += 1
        if levelIndex == LEVELS.count {
            showBanner(WinnerBanner(scene: self))
        } else {
            reset()
        }
    }

    final func showBanner(banner: Banner) {
        if self.banner != nil {
            self.banner!.removeFromParent()
        }
        self.banner = banner
        field.addChild(banner)
    }

    private func initField() {
        let x = CGFloat(0)
        let y = CGFloat(SPRITE_SIZE)
        let width = CGRectGetWidth(self.frame)
        let height = CGRectGetHeight(self.frame) - CGFloat(SPRITE_SIZE)
        let node = SKShapeNode(rect: CGRect(x: x, y: y, width: width, height: height))
        node.fillColor = NSColor(calibratedRed: 0.4, green: 0.5, blue: 0.9, alpha: 1)
        field = SKCropNode()
        field.maskNode = node
        field.zPosition = FIELD_LAYER
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
        let viewWidth = (width + SPRITE_SIZE - 1) / SPRITE_SIZE
        let viewHeight = (height + SPRITE_SIZE - 1) / SPRITE_SIZE

        // Keep X centered around the player.
        viewx = player.posx - SPRITE_SIZE * viewWidth / 2 + SPRITE_SIZE
        viewx = max(0, viewx)

        // Keep Y the same unless the player moves more than half way
        // up the view or if the player goes down.
        let maxy = player.posy - SPRITE_SIZE * (viewHeight - 9)
        let miny = player.posy - SPRITE_SIZE * (viewHeight - 4)
        if basey == 0 {
            basey = miny
        }
        viewy = basey
        viewy = min(viewy, maxy)
        viewy = max(viewy, miny)

        // Render the new field.
        // We render 1 additional cell in each direction.
        pool.reset()
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

        scoreboard.update(player)
    }

    private func renderCell(x: Int, _ y: Int) {
        let cellx = x + (viewx / SPRITE_SIZE)
        let celly = y + (viewy / SPRITE_SIZE)
        let c = level!.get(cellx, celly)
        if c == Cell.space {
            return
        }
        let sprite = pool.get(c)
        if sprite != nil {
            let height = Int(CGRectGetHeight(self.frame))
            let posx = (x * SPRITE_SIZE) + SPRITE_SIZE - (viewx % SPRITE_SIZE)
            let posy = height - (y * SPRITE_SIZE) + (viewy % SPRITE_SIZE)
            sprite!.position = CGPoint(x: posx, y: posy)
            field.addChild(sprite!)
        }
    }

    func renderAgent(agent: Agent) {
        let height = Int(CGRectGetHeight(self.frame))
        let posx = agent.posx - viewx + SPRITE_SIZE
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
                        player.reset()
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
                render()
            }
        }
        lastUpdate = currentTime
    }
}
