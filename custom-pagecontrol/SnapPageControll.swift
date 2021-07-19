//
//  snapPageControll.swift
//  custom-pagecontrol
//
//  Created by user195713 on 7/18/21.
//

import UIKit

@IBDesignable open class SnapPageControll: UIView {
    @IBInspectable open var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            layoutActivePageIndicator(progress)
        }
    }
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    @IBInspectable open var snapSize: CGSize = CGSize(width: 20, height: 2.5) {
        didSet {
            
        }
    }
    
    @IBInspectable open var activeTint: UIColor = UIColor.white {
        didSet {
            activeLayer.backgroundColor = activeTint.cgColor
        }
    }
    
    @IBInspectable open var inactiveTint: UIColor = UIColor(white: 1, alpha: 0.3){
        didSet {
            inactiveLayers.forEach() { $0.backgroundColor = inactiveTint.cgColor}
        }
    }
    
    @IBInspectable open var indicatorPadding: CGFloat = 7 {
        didSet {
            layoutInactivePageIndicator(inactiveLayers)
        }
    }
    
    fileprivate var inactiveLayers = [CALayer]()
    fileprivate lazy var activeLayer: CALayer = { [unowned self] in
        let layer = CALayer()
        layer.frame = CGRect(origin: CGPoint.zero,
                             size: CGSize(width: self.snapSize.width, height: self.snapSize.height))
        layer.backgroundColor = self.activeTint.cgColor
        layer.cornerRadius = self.snapSize.height/2
        layer.actions = [
            "bounds": NSNull(),
            "frame": NSNull(),
            "postion": NSNull()]
        return layer
    }()
    
    fileprivate func updateNumberOfPages(_ count: Int){
        guard count != inactiveLayers.count else { return }
        inactiveLayers.forEach() { $0.removeFromSuperlayer()}
        inactiveLayers = [CALayer]()
        inactiveLayers = stride(from: 0, to: count, by: 1).map() { _ in
            let layer = CALayer()
            layer.backgroundColor = self.inactiveTint.cgColor
            self.layer.addSublayer(layer)
            return layer
        }
        
        layoutInactivePageIndicator(inactiveLayers)
        self.layer.addSublayer(activeLayer)
        layoutActivePageIndicator(progress)
        self.invalidateIntrinsicContentSize()
    }
    
   
    fileprivate func layoutActivePageIndicator(_ progress: CGFloat) {
        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else {return}
        let denormalizedProgress = progress * (snapSize.width + indicatorPadding)
        activeLayer.frame.origin.x = denormalizedProgress
    }
    
    fileprivate func layoutInactivePageIndicator(_ layers: [CALayer]){
        var layerFrame = CGRect(origin: CGPoint.zero, size: snapSize)
        layers.forEach() { layer in
            layer.cornerRadius = layerFrame.size.height / 2
            layer.frame = layerFrame
            layerFrame.origin.x += layerFrame.width + indicatorPadding
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactiveLayers.count) * snapSize.width + CGFloat(inactiveLayers.count - 1) * indicatorPadding, height: snapSize.height)
    }
}

