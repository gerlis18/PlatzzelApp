//
//  ViewController.swift
//  Platzzel
//
//  Created by SimpleAp on 6/05/18.
//  Copyright © 2018 SimpleAp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var board: UIView!
    @IBOutlet weak var countLabel: UILabel!
    var tileWidth : CGFloat = 0.0
    var tileCenterX : CGFloat = 0.0
    var tileCenterY : CGFloat = 0.0
    var tapCount : Int = 0
    var tileArray : NSMutableArray = []
    var tileCenterArray : NSMutableArray = []
    var tileEmptyCenter : CGPoint = CGPoint(x: 0, y: 0)
    
    @IBAction func btnRandom(_ sender: Any) {
        self.ramdomTiles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.makeTiles()
        self.ramdomTiles()
    }
    
    func makeTiles() {
        let boardWidth = self.board.frame.width
        self.tileWidth = boardWidth / 4
        self.tileCenterX = tileWidth / 2
        self.tileCenterY = tileWidth / 2
        var tileCount : Int = 0
        
        for _ in 0..<4{
            for _ in 0..<4 {
                let tileFrame : CGRect = CGRect(x: 0, y: 0, width: self.tileWidth - 2, height: self.tileWidth - 2)
                let tile : CustomLabel = CustomLabel(frame: tileFrame)
                let currentCenter : CGPoint = CGPoint(x: tileCenterX, y: tileCenterY)
                tile.center = currentCenter
                tile.centerOrigin = currentCenter
                tileCenterArray.add(currentCenter)
                
                tileCount = tileCount + 1
                //tile.text = "\(tileCount)"
                if (tileCount <= 16) {
                    tile.backgroundColor = UIColor(patternImage: UIImage(named: "\(tileCount).jpg")!)
                }
                tile.textAlignment = NSTextAlignment.center
                tile.isUserInteractionEnabled = true
                
                self.board.addSubview(tile)
                self.tileArray.add(tile)
                self.tileCenterX = self.tileCenterX + tileWidth
            }
            self.tileCenterX = self.tileWidth / 2
            self.tileCenterY = self.tileCenterY + self.tileWidth
        }
        let lastTile : CustomLabel = self.tileArray.lastObject as! CustomLabel
        lastTile.removeFromSuperview()
        self.tileArray.remove(lastTile)
    }
    
    func ramdomTiles() {
        let tempTileCenterArray : NSMutableArray = self.tileCenterArray.mutableCopy() as! NSMutableArray
        for anyTile in self.tileArray {
            let ramdomIndex : Int = Int(arc4random()) % tempTileCenterArray.count
            let ramdomCenter : CGPoint = tempTileCenterArray[ramdomIndex] as! CGPoint
            (anyTile as!  CustomLabel).center = ramdomCenter
            tempTileCenterArray.removeObject(at: ramdomIndex)
        }
        self.tileEmptyCenter = tempTileCenterArray.lastObject as! CGPoint
        self.tapCount = 0
        self.countLabel.text = "0"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTouch : UITouch = touches.first!
        if (self.tileArray.contains(currentTouch.view as Any)) {
            //currentTouch.view?.alpha = 0;
            let touchLabel : CustomLabel = currentTouch.view as! CustomLabel
            
            let xDif : CGFloat = touchLabel.center.x - self.tileEmptyCenter.x
            let yDif : CGFloat = touchLabel.center.y - self.tileEmptyCenter.y
            let distance : CGFloat = sqrt(pow(xDif, 2) + pow(yDif, 2))
            
            if (distance == self.tileWidth) {
                let tempCenter : CGPoint = touchLabel.center
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                touchLabel.center = self.tileEmptyCenter
                UIView.commitAnimations()
                self.tileEmptyCenter = tempCenter
                self.tapCount = self.tapCount + 1
                self.countLabel.text = "\(self.tapCount)"
            }
        }
    }
}

class CustomLabel : UILabel {
    var centerOrigin : CGPoint = CGPoint(x: 0, y: 0)
}
