//
//  ViewController.swift
//  tapTest
//
//  Created by Yunqi Mao on 11/13/14.
//  Copyright (c) 2014 NYU. All rights reserved.
//

import UIKit
import AssetsLibrary

class AddViewController: UIViewController, UIPageViewControllerDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    var pvc: UIPageViewController?
    var startingVC: photoViewController?
    var childPageControl: UIPageControl?
    
    @IBOutlet weak var deselectItem: UIBarButtonItem!
    
    
    let defaultImg: UIImage = UIImage(named: "photos")!
    var selectedImages = [UIImage]()
    var viewControllers = [photoViewController]()
    var BarStatusHidden: Bool = false
    var isPageCurlMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
    
        self.pvc = self.storyboard!.instantiateViewControllerWithIdentifier("pvc") as? UIPageViewController
        self.isPageCurlMode = (pvc?.transitionStyle == UIPageViewControllerTransitionStyle.PageCurl)
        self.pvc?.dataSource = self
        if(selectedImages.count <= 0){
            self.pvc?.view.userInteractionEnabled = false
        }
        self.startingVC = self.viewControllerAtIndex(0)!
        viewControllers.append(startingVC!)
        self.pvc?.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        self.pvc?.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        self.pvc?.view.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        self.pvc?.view.autoresizesSubviews = true
        
        self.addChildViewController(pvc!)
        self.view.addSubview(pvc!.view)
        self.pvc!.didMoveToParentViewController(self)
        self.childPageControl = getPageControlForPageViewController()
        
        self.childPageControl?.frame = CGRect(x: 0, y: 35, width: 0, height: 0)
        self.childPageControl?.backgroundColor = UIColor.clearColor()
        
        
//        self.view.bringSubviewToFront(self.pvc!.view)
//        self.view.bringSubviewToFront(self.childPageControl!)
        
    //for tap gesture
        var tapSensor = UITapGestureRecognizer(target: self, action: Selector("tapSensor:"))
        self.pvc?.view.addGestureRecognizer(tapSensor)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //handle tap action
    func tapSensor(sender: UIGestureRecognizer) {
        
        if(self.selectedImages.count > 0){
//           var flag = true
            navigationController?.setNavigationBarHidden(BarStatusHidden, animated: true)
            navigationController?.setToolbarHidden(BarStatusHidden, animated: true)
//            navigationController?.setToolbarHidden(flag, animated: true)
            self.BarStatusHidden = !self.BarStatusHidden
           
            if(!isPageCurlMode){
//                var color = (BarStatusHidden) ?UIColor.blackColor() :UIColor.whiteColor()
//                (self.pvc?.viewControllers[0] as pageContentViewController).setBGColor(color)
                self.view.backgroundColor = (BarStatusHidden) ?UIColor.whiteColor() :UIColor.blackColor()
            }
//            println("current index: \(self.presentationIndexForPageViewController(self.pvc!))")
        }
    }
    
    func viewControllerAtIndex(index: Int) -> photoViewController?{
        if(index != 0 && index >= selectedImages.count){
            return nil
        }
        let photoVC = self.storyboard!.instantiateViewControllerWithIdentifier("phvc") as photoViewController
        
        photoVC.pageIndex = index
        
        if(self.selectedImages.count <= 0){
            photoVC.pageImage = defaultImg
            photoVC.pageIndex = 0
        }
        else{
            photoVC.pageImage = selectedImages[index]
            photoVC.isDefaultPage = false
            self.pvc?.view.userInteractionEnabled = true
        }
        photoVC.isPageCurlMode = self.isPageCurlMode
        
        return photoVC
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
        }
        else{
            NSLog("No Camera.")
        }

    }
    
    //similar to UIImagePicker
    //with the delegation thing done in the same method
    @IBAction func addFromAlbum(sender: AnyObject) {
        var ipc = BSImagePickerController()
        var flag: Bool = true
        
        presentViewController(ipc, animated: true, completion: nil)
        ipc.keepSelection = true
        
        ipc.toggleBlock = { (asset: ALAsset!, select: Bool) in
            if(select) {
                NSLog("Image selected");
            } else {
                NSLog("Image deselected");
            }
        }
        
        //"delegation" part
        
        //cancel buttion clicked
        ipc.cancelBlock = { (assets: [AnyObject]!) in
            NSLog("User canceled")
            ipc.dismissViewControllerAnimated(flag, completion: nil)
        }
        
        //what to be done when finishing picking
        ipc.finishBlock = { (assets: [AnyObject]!) in
            NSLog("User finished")
            var alasets = assets as [ALAsset]
            var imgset = [UIImage]()
            for alaImg in alasets{
                var x = self.UIImageFromALAsset(alaImg)
                imgset.append(x)
            }
            self.selectedImages = imgset
            if(self.selectedImages.count != 0){
//                println("selectedimage count:\(self.selectedImages.count)")
                self.viewControllers[0] = self.viewControllerAtIndex(0)!
                self.pvc?.setViewControllers(self.viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
                self.pvc?.viewDidDisappear(!flag)
                self.deselectItem.enabled = true
            }else{
//                self.imgPreview.image = self.defaultImg
                self.deselectItem.enabled = false
            }
//            println("number of content view controller is \(self.viewControllers.count)")
            ipc.dismissViewControllerAnimated(flag, completion: nil)
        }
    }

    //deselect img by remove it from the image array
    @IBAction func DeselectImg(sender: UIBarButtonItem) {

        var dismissAnime: Bool = true
        var currentIndex = self.presentationIndexForPageViewController(self.pvc!)
//        println("current index#: \(currentIndex) \n")
        
        //the first if-block can be removed
        if(self.selectedImages.count <= 0){
            //disable button
            sender.enabled = false
            self.pvc?.view.userInteractionEnabled = false
        }
            
        else if(self.selectedImages.count == 1){
            
            self.selectedImages.removeAll(keepCapacity: true)
            self.viewControllers[0] = self.viewControllerAtIndex(0)!
            
            pvc?.setViewControllers(self.viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
            sender.enabled = false
            self.pvc?.view.userInteractionEnabled = false
        }
        else{
            //at last selected image view
            if(self.selectedImages.count <= currentIndex + 1){
                self.viewControllers[0] = self.viewControllerAtIndex(currentIndex - 1)!
                self.viewControllers[0].pageImage = self.selectedImages[currentIndex - 1]
                self.selectedImages.removeAtIndex(currentIndex)
                pvc?.setViewControllers(self.viewControllers, direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
            }
            else{
                self.viewControllers[0] = self.viewControllerAtIndex(currentIndex)!
                self.viewControllers[0].pageImage = self.selectedImages[currentIndex + 1]
                self.selectedImages.removeAtIndex(currentIndex)
                pvc?.setViewControllers(self.viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            }
        }
    }
    
    //at "add picture" view (current view), cancel button action(not tested)
    
    
    @IBAction func cancel(sender: AnyObject) {
        var flag: Bool = true
        self.dismissViewControllerAnimated(flag, completion: nil)
    }
    
    //turn image from photoalbum to UIImage
    func UIImageFromALAsset(asset: ALAsset) -> UIImage {
        let defaultRep: ALAssetRepresentation = asset.defaultRepresentation()
        let imgRef: CGImageRef = defaultRep.fullResolutionImage().takeUnretainedValue()
        var repScale = CGFloat(defaultRep.scale())
        var repOri: UIImageOrientation = UIImageOrientation(rawValue: defaultRep.orientation().rawValue)!
        
        let img: UIImage = UIImage(CGImage: imgRef, scale: repScale, orientation: repOri)!
        return img
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        
        NSLog("ipc func called..")
        
        let OriginalImage = info[UIImagePickerControllerOriginalImage] as UIImage
        
        self.selectedImages.removeAll(keepCapacity: false)
        self.selectedImages.append(OriginalImage)
        
        
        self.viewControllers[0] = self.viewControllerAtIndex(0)!
        self.pvc?.setViewControllers(self.viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.pvc?.viewDidDisappear(false)
        self.deselectItem.enabled = true
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?{
        var index:NSInteger = (viewController as photoViewController).pageIndex
        if(index <= 0 || index == NSNotFound){
            return nil
        }
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?{
        var index:NSInteger = (viewController as photoViewController).pageIndex
        if (index == NSNotFound) {
            return nil;
        }
        
        index++
        
        if(index == selectedImages.count){
            return nil
        }
        return viewControllerAtIndex(index)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int{
        var currentVC = pageViewController.viewControllers[0] as photoViewController
        return currentVC.pageIndex
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {

//        self.childPageControl?.numberOfPages = self.selectedImages.count

        return self.selectedImages.count
    }
    
    @IBAction func confirm(sender: AnyObject) {
        navigationController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func getPageControlForPageViewController() -> UIPageControl? {
        for subview in self.pvc!.view.subviews {
            if let v = subview as? UIPageControl {
                println("page control found")
                return v
            }
        }
        
        return nil
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return BarStatusHidden
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var abvc = segue.destinationViewController as AddPicController
        if (self.selectedImages.count != 0){
            abvc.imageSet.removeAll(keepCapacity: false)
        }
        abvc.imageSet = self.selectedImages
    }
}

