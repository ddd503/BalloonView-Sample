//
//  BalloonView.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class BalloonView: UIView {
    // 三角部分の幅
    private let triangleBottomLength: CGFloat
    // 三角部分の高さ
    private let triangleHeight: CGFloat
    // 塗りつぶしの色
    private let color: UIColor
    // 吹き出しの内容が入るView
    private let innerView: UIView

    /// 吹き出しのイニシャライズ
    ///
    /// - Parameters:
    ///   - focusPoint: 吹き出しが出る地点(三角形の頂点)
    ///   - contentView: 吹き出しの中に入れたいView（今回は長方形のUILabelを渡しています）
    ///   - color: 吹き出しの色
    ///   - triangleBottomLength: 三角形部分の幅
    ///   - triangleHeight: 三角形部分の高さ
    init(focusPoint: CGPoint, contentView: UIView,
         color: UIColor, triangleBottomLength: CGFloat = 25, triangleHeight: CGFloat = 20) {
        // 各種プロパティに保持
        self.color = color
        self.triangleBottomLength = triangleBottomLength
        self.triangleHeight = triangleHeight
        // 中に入れたいViewのサイズを元に親View(三角形部分含む)のサイズを決めます
        let viewSize = CGSize(width: contentView.frame.size.width * 1.2,
                              height: contentView.frame.size.height * 1.5 + triangleHeight)
        let frame = CGRect(origin: CGPoint(x: focusPoint.x - viewSize.width / 2,
                                           y: focusPoint.y - viewSize.height),
                           size: viewSize)
        // 吹き出し内容View(三角形部分を含まない)のサイズを決めます
        self.innerView = UIView(frame: CGRect(origin: .zero,
                                              size: CGSize(width: viewSize.width,
                                                           height: viewSize.height - triangleHeight)))
        super.init(frame: frame)
        // 親のsuperViewを透明に（吹き出しのみを見せるため）
        backgroundColor = .clear
        // 吹き出し内容Viewを設定
        innerView.backgroundColor = color
        addSubview(innerView)
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 10
        innerView.addSubview(contentView)
        contentView.center = innerView.center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            // UIGraphicsGetCurrentContextを用意できない場合は吹き出しは描画しない
            return
        }
        contextBalloonPath(context: context, rect: rect)
    }

    func contextBalloonPath(context: CGContext, rect: CGRect) {

        context.setFillColor(color.cgColor)

        // 三角と内容Viewの間に隙間が空いてしまうため+1としている
        let leftEndPoint = CGPoint(x: rect.size.width / 2 - (triangleBottomLength / 2), y: rect.size.height - (triangleHeight + 1))
        let rightEndPoint = CGPoint(x: leftEndPoint.x + triangleBottomLength, y: rect.size.height - (triangleHeight + 1))
        let tipCornerPoint = CGPoint(x: rect.size.width / 2, y: rect.maxY)

        // 開始点を指定
        context.move(to: leftEndPoint)
        // 移動点から二点以上指定して線を引かないと領域の確保がされずに短形は描画されない
        context.addLine(to: rightEndPoint)
        context.addLine(to: tipCornerPoint)
        // 描画開始
        context.fillPath()
    }
}
