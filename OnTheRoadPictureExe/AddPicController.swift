//
//  ViewContentController.swift
//  OnTheRoadPictureExe
//
//  Created by JiangYi Zhang on 14/11/8.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit


class AddPicController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate, MKMapViewDelegate {
    // UIImagePickercontrollerdelegate 负责摄像头的父类
    // CLLocationManagerDelegate 管理 寻找现在地点
    
    var userid: String!
    
    var location: CLLocationCoordinate2D!
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var latitude = 0.0
    var longitude = 0.0
    var city = ""
    var zipCode = ""
    var state = ""
    var country = ""
    // 一种新的数组定义方式// 存储图片数组
    var imageSet = [UIImage]()
    
    var context: NSManagedObjectContext!
    
    var image : UIImage!
    
    var play_flag: Bool = true
    
    @IBOutlet weak var playbutton: UIButton!
    @IBOutlet weak var piccommentTextView: UITextView!
    
    @IBOutlet weak var picImageView: UIImageView!
    
    @IBOutlet weak var MKmapView: MKMapView!
    
    @IBOutlet weak var mapImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //NSLog("test")
        context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        self.view.backgroundColor = UIColor.blackColor()
    }
    
    @IBAction func TapGesture(sender: AnyObject) {
        // 关键盘
        self.view.endEditing(true)
        
    }
    
    
    
    // show 按钮
    @IBAction func BtnShowClicked(sender: AnyObject) {
        
        if(play_flag){
            picImageView.animationImages = self.imageSet
            picImageView.animationDuration = 1.5
            picImageView.startAnimating()
        
        }else{
            picImageView.stopAnimating()
        }

        play_flag = !play_flag
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    override func viewWillAppear(animated: Bool) {
         // 掉用找位置方法
         findMyLocation()
        
        if (imageSet.isEmpty){
        
        image = UIImage(named: "Aerial02")!
         picImageView.image = image
        }
        else{
            image = imageSet[0]
            picImageView.image = image
        }
        var userDefault: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        userid = userDefault.stringForKey("userid")
        println("\(self.userid)")
    }
    
    
    func findMyLocation() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        let authStatus = CLLocationManager.authorizationStatus()
        if (authStatus == .NotDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locValue:CLLocationCoordinate2D = manager.location.coordinate
        if (abs(latitude - locValue.latitude) > 0.0 || abs(longitude - locValue.longitude) > 0.0) {
        latitude = locValue.latitude     //经度，注意类型是浮点数
        longitude = locValue.longitude    //纬度，类型是浮点数不是string
        println("latitude: \(latitude) \nlongitude: \(longitude)")
            
//            let span = MKCoordinateSpanMake(0.25, 0.25)
//            let region = MKCoordinateRegion(center: locValue, span: span)
//            MKmapView.setRegion(region, animated: false)
        
        self.geocoder.reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
        }
    }
        
    func displayLocationInfo(placemark: CLPlacemark?) {
        
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            //locationManager.stopUpdatingLocation()
            //获取地点信息
            city = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            zipCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            state = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            println(city)   //城市
            println(zipCode)    //邮编
            println(state)      //州
            println(country)    //国家
            self.addMap()
        }
        
    }
    
    //生成地图
    //Build map
    func addMap() {
        location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //添加当前城市地点到地图
        //add current location to map
        let annotation = MKPointAnnotation()
        annotation.setCoordinate(location)
        annotation.title = city //主标题显示城市
        annotation.subtitle = state //副标题显示州
        MKmapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.25, 0.25)
        let region = MKCoordinateRegion(center: location, span: span)
        MKmapView.setRegion(region, animated: false)
   
        //延时器， 使截图完整
        //wait 2.5 secs to call screenShotMethod
        var timer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: Selector("screenShotMethod"), userInfo: nil, repeats: false)
        
    }

    //截取当前地点图
    //get sceenshot of mapView2 (current location)
    func screenShotMethod() {
        let layer = MKmapView.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.renderInContext(UIGraphicsGetCurrentContext())
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        mapImageView.image = screenshot
    }
    

    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didBackBtnClicked(sender: AnyObject) {
        var choosepage = storyboard?.instantiateViewControllerWithIdentifier("CHP") as ChoosePageTabBarController
        presentViewController(choosepage, animated: true, completion: nil)

    }
    
    
    
    @IBAction func didSaveBtnClicked(sender: AnyObject) {
        
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        let idFormatter = NSDateFormatter()
        idFormatter.dateFormat = "yyyyMMddHHmmssZZZ"
        let timeZone = NSTimeZone.systemTimeZone()
        
        // 取得当前时间
        var currentdate = dateFormatter.stringFromDate(date)
        var recordid = (idFormatter.stringFromDate(date) as NSString).substringWithRange(NSMakeRange(0, 14))
        println("current:  \(currentdate)")
        println("RECORDID: \(recordid)")
        
        var row:AnyObject =  NSEntityDescription.insertNewObjectForEntityForName("Record", inManagedObjectContext: context!)
        
        row.setValue(self.userid, forKey:"userid")
        row.setValue("\(longitude)", forKey: "longitude")
        row.setValue("\(latitude)", forKey: "latitude")
        row.setValue(city, forKey: "cityname")
        row.setValue(state, forKey: "statename")
        row.setValue(country, forKey: "countryname")
        row.setValue(zipCode, forKey: "postid")
        row.setValue(piccommentTextView.text, forKey: "rcomment")
        row.setValue(currentdate, forKey: "date")
        row.setValue(recordid, forKey: "recordid")
        
        
        var doc = NSHomeDirectory() + "/Documents"
        var path = NSHomeDirectory() + "/Documents/" + recordid
        // 创建文件夹
        var manager = NSFileManager.defaultManager()
        var flag = manager.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: nil) // 如果中间路径不存在那么intermediation属性应设置为true
        
        var picrow:AnyObject =  NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: context!)
        var picturename = recordid + "\(0).jpg"
        picrow.setValue(picturename, forKey: "picturename")
        picrow.setValue(recordid, forKey: "groupid")
        picrow.setValue("", forKey: "pcomment")
        // 保存数据
        context?.save(nil)
        
        // 改格式为JPG并保存地图图片在Documents目录下
        var picturepath = path + "/" + picturename
        UIImageJPEGRepresentation(mapImageView.image!, 1).writeToFile(picturepath, atomically: true)  // 1代表占地最大， 0 代表占地最小

        
        // 有图片被选择
        if imageSet.count != 0 {
        for var i = 1; i <= imageSet.count; i++ {
            let picrow:AnyObject =  NSEntityDescription.insertNewObjectForEntityForName("Picture", inManagedObjectContext: context!)
            let picturename = recordid + "\(i).jpg"
            picrow.setValue(picturename, forKey: "picturename")
            picrow.setValue(recordid, forKey: "groupid")
            picrow.setValue("", forKey: "pcomment")
            // 保存数据
            context?.save(nil)
            let picturepath = path + "/" + picturename
            SavePictureToDisk(picturepath, pic: imageSet[i-1])

        }
        }
        
        var choosepage = storyboard?.instantiateViewControllerWithIdentifier("CHP") as ChoosePageTabBarController
        presentViewController(choosepage, animated: true, completion: nil)
        
    }
    
    func SavePictureToDisk(path: String, pic: UIImage){
        
        UIImageJPEGRepresentation(pic, 1).writeToFile(path, atomically: true)  // 1代表占地最大， 0 代表占地最小
        
    }
    
    
    
    // 图片添加按钮
    @IBAction func didCameraBtnClicked(sender: AnyObject) {
        
    }
    
    // 图片回传 ＋ 关摄像头界面
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        
        
        println("run here ")
        let image: UIImage  = info[UIImagePickerControllerOriginalImage] as UIImage
        
        
        
        self.image = image  // 保存图片
        picImageView.image = self.image
        
        
        picker.dismissViewControllerAnimated(true, completion: nil) // 关摄像头界面
        
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
      
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var pinView:MKPinAnnotationView = MKPinAnnotationView()
        pinView.annotation = annotation
        //pinView.pinColor = MKPinAnnotationColor.Red
        pinView.pinColor = MKPinAnnotationColor.Purple
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        return pinView

    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
