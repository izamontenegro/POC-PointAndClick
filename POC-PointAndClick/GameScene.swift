//
//  GameScene.swift
//  POC-PointAndClick
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 14/04/25.
//

import SpriteKit

class GameScene: SKScene {
    
    var selectedIngredient: SKSpriteNode? = nil
    
    override func didMove(to view: SKView) {
        let ingredient = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        ingredient.name = "ingredient"
        ingredient.position = CGPoint(x: 0, y: 300)
        addChild(ingredient)
        
        let ingredient2 = SKSpriteNode(color: .green, size: CGSize(width: 50, height: 50))
        ingredient2.name = "ingredient2"
        ingredient2.position = CGPoint(x: 100, y: 300)
        addChild(ingredient2)
        
        let ingredient3 = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        ingredient3.name = "ingredient3"
        ingredient3.position = CGPoint(x: -100, y: 300)
        addChild(ingredient3)
        
        let pan1 = SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 50))
        pan1.name = "pan1"
        pan1.position = CGPoint(x: 0, y: 50)
        addChild(pan1)
        
        let pan2 = SKSpriteNode(color: .darkGray, size: CGSize(width: 100, height: 50))
        pan2.name = "pan2"
        pan2.position = CGPoint(x: 0, y: 200)
        addChild(pan2)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)
        
        if (tappedNode.name == "ingredient" || tappedNode.name == "ingredient2" || tappedNode.name == "ingredient3") {
            if selectedIngredient == tappedNode {
                selectedIngredient?.run(SKAction.scale(to: 1.0, duration: 0.1))
                selectedIngredient = nil
            } else {
                selectedIngredient?.run(SKAction.scale(to: 1.0, duration: 0.1))
                selectedIngredient = tappedNode as? SKSpriteNode
                selectedIngredient?.run(SKAction.scale(to: 1.2, duration: 0.1))
            }
            return
        }
        
        if let selected = selectedIngredient, tappedNode.name == "pan1" || tappedNode.name == "pan2" {
            let moveAction = SKAction.move(to: tappedNode.position, duration: 0.2)
            selected.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
            selected.run(SKAction.scale(to: 1.0, duration: 0.1))
            selectedIngredient = nil
        } else if let selected = selectedIngredient {
            selected.run(SKAction.scale(to: 1.0, duration: 0.1))
            selectedIngredient = nil
        }
    }

}
