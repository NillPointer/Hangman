//
//  GameViewController.swift
//  Hangman
//
//  Created by Oleksandr  on 27/11/2017.
//  Copyright © 2017 Oleksandr . All rights reserved.
//

import UIKit
import SpriteKit

/*
 Extensions to extend Character and String functionality (which should already be part of Swift!) taken from Stackoverflow
 */
extension Character {
    var string: String { return String(self) }
}

extension String.CharacterView {
    var string: String { return String(self) }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}

extension String {
    func index(at offset: Int) -> Index? {
        precondition(offset >= 0, "offset can't be negative")
        return index(startIndex, offsetBy: offset, limitedBy: index(before: endIndex))
    }
    func character(at offset: Int) -> Character? {
        precondition(offset >= 0, "offset can't be negative")
        guard let index = index(at: offset) else { return nil }
        return self[index]
    }
    subscript(offset: Int) -> String {
        precondition(offset >= 0, "offset can't be negative")
        guard let character = character(at: offset) else { return "" }
        return String(character)
    }
    subscript(range: Range<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        guard let startIndex = index(at: range.lowerBound) else { return "" }
        return self[startIndex..<(index(startIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(range: ClosedRange<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
        guard let startIndex = index(at: range.lowerBound) else { return "" }
        return self[startIndex..<(index(startIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)]
    }
    subscript(partialRange: PartialRangeFrom<Int>) -> Substring {
        return self[partialRange.lowerBound..<endIndex.encodedOffset]
    }
    subscript(partialRange: PartialRangeUpTo<Int>) -> Substring {
        return self[startIndex.encodedOffset..<partialRange.upperBound]
    }
    subscript(partialRange: PartialRangeThrough<Int>) -> Substring {
        return self[startIndex.encodedOffset...partialRange.upperBound]
    }
}

class GameViewController: UIViewController {
    
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var hiddenWord: UILabel!
    
    var scene : GameScene? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene?.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        tipLabel.isHidden = true
        tipLabel.text = scene?.currentWordDefintion
        hiddenWord.text = ""
        
        for _ in (scene?.currentWord)! {
            hiddenWord.text?.append("_ ")
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func onTipButton() {
        tipLabel.isHidden = !tipLabel.isHidden
    }
    
    @IBAction func onLetterButton(_ sender: UIButton) {
        let letter = Character((sender.titleLabel?.text?.lowercased())!)
        var charIndexs : [Int] = []
        var toBeHidden : Bool = false
        
        for index in 0...(scene?.currentWord)!.count-1{
            let c = (scene?.currentWord.lowercased())!.character(at: index)!
            if c==letter {
                charIndexs.append(index)
                toBeHidden = true
            }
        }
        
        for i in 0...charIndexs.count-1{
            hiddenWord.text = replace(myString: hiddenWord.text!, (charIndexs[i]*2), (scene?.currentWord.uppercased())!.character(at: charIndexs[i])!)
        }
        
        if toBeHidden {
            sender.isHidden = true
        }
    }
    
    // This method is taken from Stackoverflow because Swift doesn't want me to have an easy life
    // replacing some characters in a string
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var modifiedString = String()
        for (i, char) in myString.characters.enumerated() {
            modifiedString += String((i == index) ? newChar : char)
        }
        return modifiedString
    }
    
}
