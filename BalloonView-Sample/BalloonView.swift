//
//  BalloonView.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

final class BalloonView: UIView {
    // 吹き出しの色
    private let color: UIColor
    // 吹き出すを出す方向
    private let directionType: BalloonViewDirectionType
    // 三角部分の幅
    private let triangleBottomLength: CGFloat
    // 三角部分の高さ
    private let triangleHeight: CGFloat
    // 吹き出し内のコンテンツ部分を管理するView
    private let innerView: UIView

    /// 吹き出しのイニシャライズ
    ///
    /// - Parameters:
    ///   - focusPoint: 吹き出しが出る地点(三角形の頂点)
    ///   - contentView: 吹き出しの中に入れたいView（今回は長方形のUILabelを渡しています）
    ///   - color: 吹き出しの色
    ///   - directionType: 吹き出すを出す方向
    ///   - triangleBottomLength: 三角形部分の幅
    ///   - triangleHeight: 三角形部分の高さ
    init(focusPoint: CGPoint, contentView: UIView,
         color: UIColor, directionType: BalloonViewDirectionType,
         triangleBottomLength: CGFloat = 25, triangleHeight: CGFloat = 20) {
        self.color = color
        self.directionType = directionType
        self.triangleBottomLength = triangleBottomLength
        self.triangleHeight = triangleHeight

        let viewSize = directionType.viewSize(contentViewSize: contentView.frame.size, triangleHeight: triangleHeight)
        let viewOrigin = directionType.viewOrigin(focusPoint: focusPoint, viewSize: viewSize)
        let viewFrame = CGRect(origin: viewOrigin, size: viewSize)

        // 吹き出しの内容部分描画用のViewを用意
        let innerViewSize = directionType.innerViewSize(superViewFrame: viewFrame, triangleHeight: triangleHeight)
        let innerViewOrigin = directionType.innerViewOrigin(triangleHeight: triangleHeight)
        innerView = UIView(frame: CGRect(origin: innerViewOrigin, size: innerViewSize))

        super.init(frame: viewFrame)

        // BalloonView自体の背景を透明に（吹き出しのみを見せるため）
        backgroundColor = .clear

        innerView.backgroundColor = color
        addSubview(innerView)
        innerView.addSubview(contentView)
        contentView.center = self.convert(innerView.center, to: innerView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 10

        guard let context = UIGraphicsGetCurrentContext() else {
            // UIGraphicsGetCurrentContextを用意できない場合は吹き出しは描画しない
            return
        }

        contextBalloonPath(context: context, rect: rect)
    }

    /// 吹き出しの三角形部分を描画する
    ///
    /// - Parameters:
    ///   - context: UIGraphicsGetCurrentContext
    ///   - rect: BalloonView自体のFrame
    func contextBalloonPath(context: CGContext, rect: CGRect) {
        // 三角形の各頂点を取得
        let cornerPoints = directionType.triangleCornerPoints(superViewRect: rect,
                                                              triangleBottomLength: triangleBottomLength,
                                                              triangleHeight: triangleHeight)
        // 三角形の描画
        let triangle = UIBezierPath()
        triangle.move(to: cornerPoints.left)
        triangle.addLine(to: cornerPoints.top)
        triangle.addLine(to: cornerPoints.right)
        triangle.close()
        // 内側の色をセット
        color.setFill()
        // 内側を塗りつぶす
        triangle.fill()
    }
}
