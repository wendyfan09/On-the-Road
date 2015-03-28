//
//  imageScrollView.swift
//  tapTest
//
//  Created by Yunqi Mao on 12/2/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import UIKit

class imageScrollView:UIScrollView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            self.displayImage()
        }
    }
    
    var index: NSInteger?
    
    internal(set) var zoomView: UIImageView?
    internal(set) var imageSize: CGSize?
    internal(set) var pointToCenterAfterResize: CGPoint?
    internal(set) var scaleToRestoreAfterResize: CGFloat?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.bouncesZoom = true
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delegate = self
        
    }
    
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //
    //        self.showsVerticalScrollIndicator = false
    //        self.showsHorizontalScrollIndicator = false
    //        self.bouncesZoom = true
    //        self.decelerationRate = UIScrollViewDecelerationRateFast
    //        self.delegate = self
    //        println("image scroll view initiated")
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsSize = self.bounds.size
        var frameToCenter = zoomView!.frame
        
        if(frameToCenter.size.width < boundsSize.width){
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        }
        else{
            frameToCenter.origin.x = 0
        }
        
        if(frameToCenter.size.height < boundsSize.height){
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        }
        else{
            frameToCenter.origin.y = 0
        }
        
        self.zoomView?.frame = frameToCenter
    }
    
    override var frame: CGRect {
        
        get { return super.frame }
        set {
            let sizeChanging: Bool = !CGSizeEqualToSize(newValue.size, self.frame.size)
            if(sizeChanging){
                self.prepareToResize()
            }
            
            super.frame = newValue
            
            if(sizeChanging) {
                self.recoverFromResizing()
            }
        }
    }
    
    //    override func drawRect(rect: CGRect) {
    //
    //    }
    
    func displayImage() {
        //clear previous image
        self.zoomView?.removeFromSuperview()
        self.zoomView = nil
        
        //reset zoomScale to 1.0
        self.zoomScale = 1.0
        
        self.zoomView = UIImageView(image: self.image!)
        self.addSubview(self.zoomView!)
        
        self.configureForImageSize(self.image!.size)
    }
    
    func configureForImageSize(imageSize: CGSize) {
        self.imageSize = imageSize
        self.contentSize = imageSize
        self.setMaxMinZoomScalesForCurrentBounds()
        self.zoomScale = self.minimumZoomScale
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return zoomView
    }
    
    
    func prepareToResize() {
        var boundsCenter: CGPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        self.pointToCenterAfterResize = self.convertPoint(boundsCenter, toView: zoomView)
        
        self.scaleToRestoreAfterResize = self.zoomScale
        
        // If we're at the minimum zoom scale, preserve that by returning 0, which will be converted to the minimum
        // allowable scale when the scale is restored.
        if(self.scaleToRestoreAfterResize <=  self.minimumZoomScale + CGFloat(FLT_EPSILON)) {
            self.scaleToRestoreAfterResize = 0
        }
    }
    
    func recoverFromResizing() {
        self.setMaxMinZoomScalesForCurrentBounds()
        
        //restore zoom scale
        let maxZoomScale = max(self.maximumZoomScale, self.scaleToRestoreAfterResize!)
        self.zoomScale = min(self.maximumZoomScale, maxZoomScale)
        
        //restore center point
        let boundsCenter = self.convertPoint(self.pointToCenterAfterResize!, fromView: zoomView)
        var offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0,
            boundsCenter.y - self.bounds.size.height / 2.0)
        let maxOffset = self.maximumContentOffset()
        let minOffset = self.minimumContentOffset()
        
        var realMaxOffset = min(maxOffset.x, offset.x)
        offset.x = max(minOffset.x, realMaxOffset)
        
        realMaxOffset = min(maxOffset.y, offset.y);
        offset.y = max(minOffset.y, realMaxOffset);
        
        self.contentOffset = offset;
    }
    
    func maximumContentOffset() -> CGPoint {
        let contentSize = self.contentSize;
        let boundsSize = self.bounds.size;
        return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
    }
    
    func minimumContentOffset() -> CGPoint {
        return CGPointZero
    }
    
    func setMaxMinZoomScalesForCurrentBounds() {
        let boundsSize = self.bounds.size
        let xScale = bounds.size.width / self.imageSize!.width
        let yScale = bounds.size.height / self.imageSize!.height
        
        let imagePortrait = imageSize?.height > imageSize?.width
        let phonePortrait = boundsSize.height > boundsSize.width
        
        var minScale = imagePortrait == phonePortrait ? xScale : min(xScale, yScale)
        
        let maxScale = 1.0 / UIScreen.mainScreen().scale
        
        if(minScale > maxScale){
            minScale = maxScale
        }
        
        self.minimumZoomScale = minScale
        self.maximumZoomScale = maxScale
        
    }
    
    
}
