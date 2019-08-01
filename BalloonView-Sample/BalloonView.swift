//
//  BalloonView.swift
//  BalloonView-Sample
//
//  Created by kawaharadai on 2019/07/29.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

enum BalloonViewDirectionType {
    case up
    case under
    case right
    case left
    case upperRight
    case lowerRight
    case upperLeft
    case lowerLeft

    // TODO: 他のtypeの場合も決める
    var degree: CGFloat {
        switch self {
        case .lowerRight:
            return 315
        default:
            return 0
        }
    }
}

final class BalloonView: UIView {
    // 三角部分の幅
    private let triangleBottomLength: CGFloat
    // 三角部分の高さ
    private let triangleHeight: CGFloat
    // 三角形のX軸の中央値
    private let triangleBottomCenter: CGPoint
    // 吹き出しの色
    private let color: UIColor
    // 吹き出しの内容が入るView
    private let innerView: UIView
    // 吹き出すを出す方向
    private let directionType: BalloonViewDirectionType

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
        // 各種プロパティに保持
        self.color = color
        self.directionType = directionType
        self.triangleBottomLength = triangleBottomLength
        self.triangleHeight = triangleHeight
        // 三角形部分の中央値を取得
        self.triangleBottomCenter = BalloonView.circumferenceCoordinate(degree: 315, radius: triangleHeight)
        // 中に入れたいViewのサイズを元に親View(三角形部分含む)のサイズを決めます
        let viewSize = CGSize(width: contentView.frame.size.width * 1.2,
                              height: contentView.frame.size.height * 1.5 + triangleBottomCenter.y)

        let frame = CGRect(origin: focusPoint, size: viewSize)

        // 吹き出し内容View(三角形部分を含まない)のサイズを決めます
        self.innerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: triangleBottomCenter.y),
                                              size: CGSize(width: viewSize.width,
                                                           height: viewSize.height - triangleBottomCenter.y)))

        super.init(frame: frame)
        // 親のsuperViewを透明に（吹き出しのみを見せるため）
        backgroundColor = .clear
        // 吹き出し内容Viewを設定
        innerView.backgroundColor = color
        addSubview(innerView)
        innerView.layer.masksToBounds = true
        innerView.layer.cornerRadius = 10
        innerView.addSubview(contentView)
        contentView.center = self.convert(innerView.center, to: innerView)
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

        // 三角形の各頂点を取得
        let cornerPoints = triangleCornerPoints(type: directionType)
        let tipCornerPoint = rect.origin

        // 開始点を指定
        context.move(to: cornerPoints.left)
        // 移動点から二点以上指定して線を引かないと領域の確保がされずに短形は描画されない
        context.addLine(to: cornerPoints.right)
        context.addLine(to: tipCornerPoint)
        // 描画開始
        context.fillPath()
    }

    private func triangleCornerPoints(type: BalloonViewDirectionType) -> (left: CGPoint, right: CGPoint) {
        switch type {
        case .lowerRight:
            let left = CGPoint(x: (triangleBottomCenter.x - innerView.frame.origin.x) * 0.8, y: innerView.frame.origin.y)
            let right = CGPoint(x: triangleBottomCenter.x + triangleBottomLength, y: innerView.frame.origin.y)
            return (left, right)
        default:
            return (.zero, .zero) // TODO: 他のtypeの場合も決める
        }
    }

    /// 円周上の座標を返す
    ///
    /// - Parameters:
    ///   - degree: 角度
    ///   - radius: 半径
    /// - Returns: 円周上の座標時
    static private func circumferenceCoordinate(degree: Double, radius: CGFloat) -> CGPoint {
        let θ = Double.pi / Double(-180) * Double(degree)
        let x = Double(radius) * cos(θ)
        let y = Double(radius) * sin(θ)
        return CGPoint(x: x, y: y)
    }
}
