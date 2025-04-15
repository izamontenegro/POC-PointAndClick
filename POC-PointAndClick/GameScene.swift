//
//  GameScene.swift
//  POC-PointAndClick
//
//  Created by Izadora de Oliveira Albuquerque Montenegro on 14/04/25.
//

import SpriteKit
import SwiftUI

enum CauldronEffects: Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case copper, iron

    var displayText: String {
        switch self {
        case .copper: return "Caldeirão de cobre"
        case .iron: return "Caldeirão de ferro"
        }
    }
    
    var textureName: String {
        switch self {
        case .copper: return "copperCauldron"
        case .iron: return "ironCauldron"
        }
    }
    
    func effect(ingredient: inout IngredientData) {
        if self == .copper {
            print("Inverteu efeito de ingrediente")
            ingredient.toggleEffect()
        } else {}
    }
}

enum ingredientsEffects: Codable, CaseIterable, Identifiable {
    var id: Self { self }
    
    case memory, health, courage, affection, wisdom, Nomemory, Nohealth, Nocourage, Noaffection, Nowisdom
    
    var effectText: String {
        switch self {
        case .memory: return "Aumenta sua memória"
        case .health: return "Aumenta sua saúde"
        case .courage: return "Aumenta sua coragem"
        case .affection: return "Aumenta seu afeto"
        case .wisdom: return "Aumenta sua sabedoria"
        case .Nomemory: return "Diminui sua memória"
        case .Nohealth: return "Diminui sua saúde"
        case .Nocourage: return "Diminui sua coragem"
        case .Noaffection: return "Diminui seu afeto"
        case .Nowisdom: return "Diminui sua sabedoria"
        }
    }
    
    // fiquei com preguica de fazer tudo
    var textureName: String {
        switch self {
        case .memory: return "memoryImage"
        case .health: return "healthImage"
        default: return "ingredientImage"
        }
    }
}

struct IngredientData {
    var effect: ingredientsEffects
    
    mutating func toggleEffect() {
        switch effect {
        case .memory:
            effect = .Nomemory
        case .health:
            effect = .Nohealth
        case .courage:
            effect = .Nocourage
        case .affection:
            effect = .Noaffection
        case .wisdom:
            effect = .Nowisdom
        case .Nomemory:
            effect = .memory
        case .Nohealth:
            effect = .health
        case .Nocourage:
            effect = .courage
        case .Noaffection:
            effect = .affection
        case .Nowisdom:
            effect = .wisdom
        }
    }
}

struct CauldronData {
    let effect: CauldronEffects
}

class IngredientNode: SKSpriteNode {
    var data: IngredientData {
        didSet {
            self.texture = SKTexture(imageNamed: data.effect.textureName)
        }
    }
    
    init(data: IngredientData) {
        self.data = data
        let texture = SKTexture(imageNamed: data.effect.textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CauldronNode: SKSpriteNode {
    let data: CauldronData
    
    init(data: CauldronData) {
        self.data = data
        let texture = SKTexture(imageNamed: data.effect.textureName)
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameScene: SKScene {
    let ingredientsData = [
        IngredientData(effect: .health),
        IngredientData(effect: .memory)
    ]
    
    let cauldronsData = [
        CauldronData(effect: .copper),
        CauldronData(effect: .iron)
    ]
    var selectedIngredient: SKSpriteNode? = nil
    
    override func didMove(to view: SKView) {
        for (index, data) in ingredientsData.enumerated() {
            let ingredient = IngredientNode(data: data)
            ingredient.position = CGPoint(x: CGFloat(index - 1) * 200, y: 350)
            ingredient.setScale(0.2)
            addChild(ingredient)
        }
        
        for (index, data) in cauldronsData.enumerated() {
            let cauldron = CauldronNode(data: data)
            cauldron.position = CGPoint(x: CGFloat(index - 1) * 200, y: 50)
            cauldron.setScale(0.2)
            addChild(cauldron)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)
        
        
        if let ingredient = tappedNode as? IngredientNode {
            if selectedIngredient == ingredient {
                ingredient.run(SKAction.scale(to: 0.3, duration: 0.1))
                selectedIngredient = nil
            } else {
                selectedIngredient?.run(SKAction.scale(to: 0.2, duration: 0.1))
                selectedIngredient = ingredient
                selectedIngredient?.run(SKAction.scale(to: 0.3, duration: 0.1))
            }
            return
        }
                
        if let selected = selectedIngredient as? IngredientNode, let cauldron = tappedNode as? CauldronNode {
            let moveAction = SKAction.move(to: tappedNode.position, duration: 0.2)
            selected.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
            var ingredientData = selected.data
                    cauldron.data.effect.effect(ingredient: &ingredientData)
                    selected.data = ingredientData
            
            selected.run(SKAction.scale(to: 0.2, duration: 0.1))
            selectedIngredient = nil
        } else if let selected = selectedIngredient {
            selected.run(SKAction.scale(to: 0.2, duration: 0.1))
            selectedIngredient = nil
        }
    }

}

//        if (tappedNode.name == "ingredient" || tappedNode.name == "ingredient2" || tappedNode.name == "ingredient3") {
//            if selectedIngredient == tappedNode {
//                selectedIngredient?.run(SKAction.scale(to: 1.0, duration: 0.1))
//                selectedIngredient = nil
//            } else {
//                selectedIngredient?.run(SKAction.scale(to: 1.0, duration: 0.1))
//                selectedIngredient = tappedNode as? SKSpriteNode
//                selectedIngredient?.run(SKAction.scale(to: 1.2, duration: 0.1))
//            }
//            return
//        }

//        let cauldron1 = SKSpriteNode(color: .gray, size: CGSize(width: 100, height: 50))
//        cauldron1.name = "Caldeirão 1"
//        cauldron1.position = CGPoint(x: 0, y: 50)
//        addChild(cauldron1)
//
//        let cauldron2 = SKSpriteNode(color: .darkGray, size: CGSize(width: 100, height: 50))
//        cauldron2.name = "Caldeirão 2"
//        cauldron2.position = CGPoint(x: 0, y: 200)
//        addChild(cauldron2)
