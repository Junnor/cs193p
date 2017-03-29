//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Ju on 2017/3/29.
//  Copyright © 2017年 Ju. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination
        if let navigationVC = destinationVC as? UINavigationController {
            destinationVC = navigationVC.visibleViewController ?? destinationVC
        }
        
        if let faceVC = destinationVC as? FaceViewController,
            let identifer = segue.identifier,
            let expression = emotionalFaces[identifer] {
            faceVC.expression = expression
            faceVC.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }
    
    private let emotionalFaces = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk),
    ]

}
