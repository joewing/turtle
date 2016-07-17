//
//  Level.swift
//
//  Created by Joe Wingbermuehle on 6/29/16.
//  Copyright © 2016 Joe Wingbermuehle. All rights reserved.
//

import Foundation

enum Cell: Character {
    case space = "."
    case player = "P"
    case brick = "X"
    case tomato = "t"
    case star = "*"
    case ghost = "G"
    case tar = "T"
}

class Level {
    
    private var data: [[Cell]] = []
    private var playerx: Int = 0
    private var playery: Int = 0
    private var agents: [(Int, Int)] = []
    let id: Int

    init(id: Int) {
        self.id = id
        let filename = "level\(id)"
        do {
            let bundle = NSBundle.mainBundle()
            let path = bundle.pathForResource(filename, ofType: "txt")
            let raw = try String(contentsOfFile: path!)

            // Determine the max line length.
            var height = 0
            var currentWidth = 0
            var width = 0
            for c in raw.characters {
                if c == "\n" {
                    width = max(currentWidth, width)
                    height += 1
                } else {
                    currentWidth += 1
                }
            }

            // Create the array.
            for _ in 0..<height {
                data.append(Array(count: width, repeatedValue: Cell.space))
            }

            // Load the level.
            var x = 0
            var y = 0
            for c in raw.characters {
                switch c {
                case "\n":
                    y += 1
                    x = 0
                case "P":
                    data[y][x] = Cell.space
                    playerx = x
                    playery = y
                    x += 1
                case "G":
                    data[y][x] = Cell.space
                    agents.append((x, y))
                    x += 1
                default:
                    data[y][x] = Cell(rawValue:c) ?? Cell.space
                    x += 1
                }
            }

        } catch {
            print("could not read \(filename)")
        }
    }

    func findPlayer() -> (Int, Int) {
        return (playerx, playery)
    }

    func getAgents() -> [(Int, Int)] {
        return agents
    }

    func width() -> Int {
        return data[0].count;
    }

    func height() -> Int {
        return data.count;
    }

    static func isWall(t: Cell) -> Bool {
        switch t {
        case Cell.space, Cell.star, Cell.tomato, Cell.tar:
            return false
        default:
            return true
        }
    }
    
    func get(x: Int, _ y: Int) -> Cell {
        if x >= width() - 1 || y >= height() - 1 {
            return Cell.tar
        } else if x < 0 || y < 0 {
            return Cell.brick
        } else {
            return data[y][x]
        }
    }

    func set(x: Int, _ y: Int, _ t: Cell) {
        data[y][x] = t
    }
    
}
