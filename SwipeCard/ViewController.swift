//
//  ViewController.swift
//  SwipeCard
//
//  Created by Tiago Valente on 11/09/2018.
//  Copyright © 2018 Tiago Valente. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var goodImageView: UIImageView!
    @IBOutlet weak var badImageView: UIImageView!
    
    var divisionParam: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        divisionParam = (view.frame.size.width/2)/0.61
        goodImageView.alpha = 0
        badImageView.alpha = 0
        
        cardView.layer.cornerRadius = 8
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        cardView.addGestureRecognizer(pan)
        cardView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
        let cardView = sender.view!
        let translationPoint = sender.translation(in: view)
        cardView.center = CGPoint(x: view.center.x+translationPoint.x, y: view.center.y+translationPoint.y)
        
        let distanceMoved = cardView.center.x - view.center.x
        if distanceMoved > 0 { // moved right side
            goodImageView.alpha = abs(distanceMoved)/view.center.x
            badImageView.alpha = 0
        }
        else { // moved left side
            badImageView.alpha = abs(distanceMoved)/view.center.x
            goodImageView.alpha = 0
        }
        
        cardView.transform = CGAffineTransform(rotationAngle: distanceMoved/divisionParam)
        
        if sender.state == UIGestureRecognizerState.ended {
            if cardView.center.x < 100 { // Moved to left
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x-350, y: cardView.center.y)
                })
                return
            } else if (cardView.center.x > (view.frame.size.width-100)) { // Moved to right
                UIView.animate(withDuration: 0.3, animations: {
                    cardView.center = CGPoint(x: cardView.center.x+350, y: cardView.center.y)
                })
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.resetCardViewToOriginalPosition()
            })
        }
    }
    
    func resetCardViewToOriginalPosition(){
        cardView.center = self.view.center
        self.badImageView.alpha = 0
        self.goodImageView.alpha = 0
        cardView.transform = .identity
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.resetCardViewToOriginalPosition()

    }
    
}

