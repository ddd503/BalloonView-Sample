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

    var degree: CGFloat {
        switch self {
        case .up:
            return 90
        case .under:
            return 270
        case .right:
            return 0
        case .left:
            return 180
        case .upperRight:
            return 45
        case .lowerRight:
            return 315
        case .upperLeft:
            return 135
        case .lowerLeft:
            return 225
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

        self.triangleBottomCenter = BalloonView.circumferenceCoordinate(degree: 315, radius: triangleHeight)

        let viewFrame = BalloonView.getFrame(balloonDirection: directionType,
                                             focusPoint: focusPoint,
                                             contentViewSize: contentView.frame.size,
                                             triangleBottomCenter: triangleBottomCenter)

        // 吹き出し内容View(三角形部分を含まない)のサイズを決めます
        self.innerView = UIView(frame: BalloonView.innerViewFrame(balloonDirection: directionType,
                                                                  parentViewFrame: viewFrame,
                                                                  triangleBottomCenter: triangleBottomCenter))

        super.init(frame: viewFrame)

        // BalloonView自体の背景を透明に（吹き出しのみを見せるため）
        backgroundColor = .clear
        // 吹き出し内容Viewを設定
        innerView.backgroundColor = self.color
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

    /// 吹き出しに入れるViewのサイズを元にBalloonViewのframeを取得する
    ///
    /// - Parameters:
    ///   - balloonDirection: 吹き出しを出す方向
    ///   - focusPoint: 吹き出しが出る地点
    ///   - contentViewSize: 吹き出しに入れるViewのサイズ
    ///   - triangleBottomCenter: 吹き出しの先端部分の三角形の中央値
    /// - Returns: BalloonView自体のframe
    static private func getFrame(balloonDirection: BalloonViewDirectionType,
                                 focusPoint: CGPoint,
                                 contentViewSize: CGSize,
                                 triangleBottomCenter: CGPoint) -> CGRect {
        switch balloonDirection {
        case .right:
            let origin = CGPoint(x: focusPoint.x, y: focusPoint.y - (contentViewSize.height / 2))
            let size = CGSize(width: contentViewSize.width * 1.3 + triangleBottomCenter.x,
                              height: contentViewSize.height * 1.2)
            return CGRect(origin: origin, size: size)
        case .lowerRight:
            let origin = focusPoint
            let size = CGSize(width: contentViewSize.width * 1.2,
                              height: contentViewSize.height * 1.5 + triangleBottomCenter.y)
            return CGRect(origin: origin, size: size)
        default: return .zero
        }
    }

    /// 吹き出し内のコンテンツ部分のViewのframeを取得する
    ///
    /// - Parameters:
    ///   - balloonDirection: 吹き出しを出す方向
    ///   - parentViewFrame: BalloonView自体のframe
    ///   - triangleBottomCenter: 吹き出しの先端部分の三角形の中央値
    /// - Returns: 吹き出し内のコンテンツ部分のViewのframe
    static private func innerViewFrame(balloonDirection: BalloonViewDirectionType,
                                       parentViewFrame: CGRect,
                                       triangleBottomCenter: CGPoint) -> CGRect {
        switch balloonDirection {
        case .right:
            return CGRect(origin: CGPoint(x: triangleBottomCenter.x, y: 0),
                          size: CGSize(width: parentViewFrame.size.width - triangleBottomCenter.x,
                                       height: parentViewFrame.size.height))
        case .lowerRight:
            return CGRect(origin: CGPoint(x: 0, y: triangleBottomCenter.y),
                          size: CGSize(width: parentViewFrame.width,
                                       height: parentViewFrame.height - triangleBottomCenter.y))
        default: return .zero
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

    /// 吹き出しの三角形部分を描画する
    ///
    /// - Parameters:
    ///   - context: UIGraphicsGetCurrentContext
    ///   - rect: BalloonView自体のFrame
    func contextBalloonPath(context: CGContext, rect: CGRect) {
        // 三角部分の色
        context.setFillColor(color.cgColor)
        // 三角形の各頂点を取得
        let cornerPoints = triangleCornerPoints(type: directionType, parentViewRect: rect)
        // 開始点を指定
        context.move(to: cornerPoints.top)
        // 移動点から二点以上指定して線を引かないと領域の確保がされずに短形は描画されない
        context.addLine(to: cornerPoints.left)
        context.addLine(to: cornerPoints.right)
        // 描画開始
        context.fillPath()
    }

    /// 三角形の各頂点を決定する
    ///
    /// - Parameter type: 吹き出しを出す方向
    /// - Returns: 各定点の座標
    private func triangleCornerPoints(type: BalloonViewDirectionType, parentViewRect: CGRect) -> (top: CGPoint, left: CGPoint, right: CGPoint) {
        switch type {
        case .right:
            let top = CGPoint(x: parentViewRect.origin.x, y: parentViewRect.origin.y + (parentViewRect.size.height / 2))
            let left = CGPoint(x: innerView.frame.origin.x,
                               y: innerView.frame.origin.y + (innerView.frame.size.height / 2) - (triangleBottomLength / 2))
            let right = CGPoint(x: innerView.frame.origin.x,
                                y: innerView.frame.origin.y + (innerView.frame.size.height / 2) + (triangleBottomLength / 2))
            return (top, left, right)
        case .lowerRight:
            let top = parentViewRect.origin
            let left = CGPoint(x: (triangleBottomCenter.x - innerView.frame.origin.x) * 0.8, y: innerView.frame.origin.y)
            let right = CGPoint(x: triangleBottomCenter.x + triangleBottomLength, y: innerView.frame.origin.y)
            return (top, left, right)
        default:
            return (.zero, .zero, .zero) // TODO: 他のtypeの場合も決める
        }
    }
}
