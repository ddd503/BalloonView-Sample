//
//  ViewController.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let balloon = BalloonView(frame: CGRect(x: 200,
                                                y: 200,
                                                width: view.bounds.size.width / 3,
                                                height: 100))
        balloon.backgroundColor = .clear
        view.addSubview(balloon)

        let label = UILabel(frame: balloon.bounds)
        label.frame.origin.y -= 8.7
        label.text = "ニャーオ"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        balloon.addSubview(label)

    }

    @IBAction func tappedRedView(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func tappedBlueView(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func tappedGreenView(_ sender: UITapGestureRecognizer) {
    }

    @IBAction func tappedYellowView(_ sender: UITapGestureRecognizer) {
    }
    
}

