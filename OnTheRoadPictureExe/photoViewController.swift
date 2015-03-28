//
//  photoViewController.swift
//  tapTest
//
//  Created by Yunqi Mao on 12/2/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import UIKit

class photoViewController: UIViewController {

    
    @IBOutlet weak var scrollView: imageScrollView!

//    var scrollView: imageScrollView!
    //    var imgView:UIImageView!
    var pageImage: UIImage?
    var pageIndex: NSInteger!
    var isDefaultPage: Bool = true
    var isPageCurlMode = false
    var flag: Bool = true
    
    //    override func loadView() {
    //        scrollView = imageScrollView.alloc()
    //        scrollView.index = pageIndex
    //        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
    //        self.view = scrollView
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        self.view.addSubview(self.scrollView)
        if !isPageCurlMode{
            self.view.backgroundColor = UIColor.clearColor()
        }
        
        self.scrollView.index = pageIndex
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        
        if(!isDefaultPage){
            self.scrollView.userInteractionEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollView.image = self.pageImage
    }
    
    
    
    func setBGColor(BGColor: UIColor){
        self.view.backgroundColor = BGColor;
    }
    
    func supportedInterfaceOrientation() -> UInt{
        return UIInterfaceOrientationMask.AllButUpsideDown.rawValue
    }
    
    
}
