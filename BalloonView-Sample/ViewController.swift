//
//  ViewController.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func tappedRedView(_ sender: UITapGestureRecognizer) {
        sender.showBalloonView(color: .white)
    }

    @IBAction func tappedBlueView(_ sender: UITapGestureRecognizer) {
        sender.showBalloonView(color: .white)
    }

    @IBAction func tappedGreenView(_ sender: UITapGestureRecognizer) {
        sender.showBalloonView(color: .white)
    }

    @IBAction func tappedYellowView(_ sender: UITapGestureRecognizer) {
        sender.showBalloonView(color: .white)
    }
    
}

private extension UITapGestureRecognizer {
    /// タップした場所にBalloonViewを表示する
    ///
    /// - Parameter color: BalloonViewの色
    func showBalloonView(color: UIColor) {
        guard let tappedView = self.view else { return }

        // 吹き出しの表示数はタップしたView内で1つのみとする
        tappedView.subviews.forEach {
            if $0 is BalloonView {
                $0.removeFromSuperview()
            }
        }

        let tapPosition = self.location(in: tappedView)
        let balloonView = BalloonView(focusPoint: tapPosition, color: color)
        balloonView.alpha = 0
        tappedView.addSubview(balloonView)

        UIView.animate(withDuration: 0.3) {
            balloonView.alpha = 1.0
        }
    }
}
