//
//  SpritePool.swift
//  Turtle
//
//  Created by Joe Wingbermuehle on 7/3/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import SpriteKit

class SpritePool {

    private let size: Int
    private let nameMap: [Cell: String] = [
        Cell.brick: "brick",
        Cell.tomato: "tomato",
        Cell.player: "turtle1",
        Cell.star: "star",
        Cell.tar: "tar",
    ]

    init(size: Int) {
        self.size = size
    }

    func get(t: Cell) -> SKSpriteNode? {
        let filename = nameMap[t]
        if filename != nil {
            let sprite = SKSpriteNode(imageNamed: filename!)
            sprite.size = CGSize(width: size, height: size)
            sprite.zPosition = CELL_LAYER
            return sprite
        }
        return nil
    }

}
