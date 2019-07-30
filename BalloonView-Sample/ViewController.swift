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
        // 1行のみのラベル
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "こんにちは！"
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel)
    }

    @IBAction func tappedBlueView(_ sender: UITapGestureRecognizer) {
        // 複数行のラベル
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "タップ地点から\n吹き出しを出せる\nようにしました！"
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel)
    }

    @IBAction func tappedGreenView(_ sender: UITapGestureRecognizer) {
        let titleLabel = UILabel(frame: CGRect(origin: .zero, size: .zero))
        titleLabel.textAlignment = .center
        titleLabel.text = "テキスト以外も\n入れられるよ！"
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        sender.showBalloonView(color: .white, contentView: titleLabel)
    }

    @IBAction func tappedYellowView(_ sender: UITapGestureRecognizer) {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 50)))
        button.backgroundColor = .blue
        button.setTitle("ボタン", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        sender.showBalloonView(color: .white, contentView: button)
    }
    
}

private extension UITapGestureRecognizer {
    /// タップした場所にBalloonViewを表示する
    ///
    /// - Parameter color: BalloonViewの色
    func showBalloonView(color: UIColor, contentView: UIView) {
        guard let tappedView = self.view else { return }

        // 吹き出しの表示数はタップしたView内で1つのみとする
        tappedView.subviews.forEach {
            if $0 is BalloonView {
                $0.removeFromSuperview()
            }
        }

        let tapPosition = self.location(in: tappedView)
        let balloonView = BalloonView(focusPoint: tapPosition, contentView: contentView, color: color)
        balloonView.alpha = 0
        tappedView.addSubview(balloonView)

        UIView.animate(withDuration: 0.3) {
            balloonView.alpha = 1.0
        }
    }
}
