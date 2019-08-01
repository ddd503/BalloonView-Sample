//
//  ViewController.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var redView: UIView!
    @IBOutlet weak private var blueView: UIView!
    @IBOutlet weak private var greenView: UIView!
    @IBOutlet weak private var yellowView: UIView!

    // 赤色Viewのタップ時
    @IBAction func tappedRedView(_ sender: UITapGestureRecognizer) {
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "こんにちは！"
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel, directionType: .lowerRight)
    }

    // 青色Viewのタップ時
    @IBAction func tappedBlueView(_ sender: UITapGestureRecognizer) {
        // 複数行のラベル
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "タップ地点から\n吹き出しを出せる\nようにしました！"
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel, directionType: .lowerRight)
    }

    // 緑色Viewのタップ時
    @IBAction func tappedGreenView(_ sender: UITapGestureRecognizer) {
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "テキスト以外も\n入れられるよ →"
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel, directionType: .lowerRight)
    }

    // 黄色Viewのタップ時
    @IBAction func tappedYellowView(_ sender: UITapGestureRecognizer) {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 40)))
        button.backgroundColor = .blue
        button.setTitle("おわり", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.addTarget(self, action: #selector(removeAllBalloonView(sender:)), for: .touchUpInside)
        sender.showBalloonView(color: .white, contentView: button, directionType: .lowerRight)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
    }

    @objc func removeAllBalloonView(sender: UIButton) {
        let targetViews = [redView, blueView, greenView, yellowView]
        targetViews.forEach { (targetView) in
            targetView?.subviews.forEach({ (subView) in
                if subView is BalloonView {
                    UIView.animate(withDuration: 0.3, animations: {
                        subView.alpha = 0
                    }, completion: { (_) in
                        subView.removeFromSuperview()
                    })
                }
            })
        }
    }
}

private extension UITapGestureRecognizer {
    /// タップした場所にBalloonViewを表示する
    ///
    /// - Parameters:
    ///   - color: 吹き出しの色
    ///   - contentView: 吹き出し内に入れたいView
    ///   - directionType: 吹き出しを出したい方向
    func showBalloonView(color: UIColor, contentView: UIView, directionType: BalloonViewDirectionType) {
        guard let tappedView = self.view else { return }

        // 吹き出しの表示数はタップしたView内で1つのみとする
        tappedView.subviews.forEach {
            if $0 is BalloonView {
                $0.removeFromSuperview()
            }
        }

        let tapPosition = self.location(in: tappedView)
        let balloonView = BalloonView(focusPoint: tapPosition,
                                      contentView: contentView,
                                      color: color,
                                      directionType: directionType)
        balloonView.alpha = 0
        tappedView.addSubview(balloonView)

        UIView.animate(withDuration: 0.3) {
            balloonView.alpha = 1.0
        }
    }
}
