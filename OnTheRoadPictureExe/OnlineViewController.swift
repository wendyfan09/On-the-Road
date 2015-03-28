//
//  OnlineViewController.swift
//  DVIPlayer
//
//  Created by JiangYi Zhang on 14/11/24.
//  Copyright (c) 2014年 JiangYi Zhang. All rights reserved.
//

import UIKit
import AVFoundation

class OnlineViewController: UIViewController, AVAudioPlayerDelegate {
    
    
    @IBOutlet weak var songImageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var songLabel: UILabel!
    
  //  @IBOutlet weak var timeLabel: UILabel!
    
    // 收藏
    @IBAction func didFavClicked(sender: UIBarButtonItem) {
    
        var song = self.currentSong
        // 存进去方法  保存对象， 归档
        NSKeyedArchiver.archiveRootObject(song, toFile: "/Users/jiangyizhang/desktop/test.plist")
        // NSString, NSArray, NSDictionary
        // NSMutableString, NSMutableArray
        // NSMutableDIctionary
        // 测试读出来  解归档
        var song2: Song = NSKeyedUnarchiver.unarchiveObjectWithFile("/Users/jiangyizhang/desktop/test.plist") as Song
        println("\(song2)")
        
    }
    
    
    
    
    // 进度调节
    @IBAction func valueChanged(sender: UISlider) {
        
        player.currentTime = NSTimeInterval(sender.value) * player.duration
    }
    
    func loadSongWithIndex(index: Int){
            if (index < self.songList.count && index >= 0) {
            self.currentSong = self.songList[index]
            self.currentIndex = index
                if player.playing{
                player.stop()
                }
                self.slider.value = 0.0
           //     self.timeLabel.text = " "
                println("归零")
            self.loadSongInfo(self.currentSong.id)
        }

    }
    
    
    // 上一曲
    @IBAction func previousClickedButton(sender: UIButton) {
        var index = self.currentIndex - 1
        loadSongWithIndex(index)
        
    }
    // 下一曲
    @IBAction func nextClickedButton(sender: UIButton) {
        var index = self.currentIndex + 1
        loadSongWithIndex(index)
    }
    // 播放 || 暂停
    @IBAction func playClickedButton(sender: UIButton) {
        if player.playing {
            player.pause() }
        else {
            player.play()}
    }
    
    
    
    
    var channel: Channel! //当前频道
    var songList: Array<Song> = [] //当前频道的歌曲列表
    var currentIndex: Int = 0
    var currentSong: Song! //当前播放的歌曲
    var player: AVAudioPlayer! //播放器对象
    var timer: NSTimer!// 定时器
    
    // 公共的下载数据的函数
    func downloadData(path: String, dataHandler: (NSData) -> Void){
        var url = NSURL(string: path)
        var request = NSURLRequest(URL: url!)
        var mainQueue = NSOperationQueue.mainQueue()
        // 异步下载
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var httpResponse = response as NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
                
                dataHandler(data)
            }
        })
        
    }
    // 显示歌曲图片
    func showSongPic(){
      var path = self.currentSong.songPicbig
        downloadData(path, dataHandler:{(data: NSData) -> Void in
        
        self.songImageView.image = UIImage(data: data)
        
        })
        
    }
    
    
    // 显示歌曲信息
    func showSongInfo(){
        self.artistLabel.text = self.currentSong.artistName
        self.songLabel.text = self.currentSong.songName
        
    }
    
    // 播放歌曲
    func playSong(data: NSData){
        
        player = AVAudioPlayer(data: data, error: nil)
        player.prepareToPlay()
        player.play()
        player.delegate = self
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "refreshSlider", userInfo: nil, repeats: true)
    }
    
    func refreshSlider(){
        slider.value = CFloat(player.currentTime / player.duration)
    //    self.timeLabel.text = player.currentTime.description
    }
    
    //AVaudioplayer的代理方法， 播放完毕时
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        timer.invalidate()
        loadSongWithIndex(self.currentIndex + 1)
        
           }
    
    // 下载歌曲
    func downloadSong(path: String){
        
        downloadData(path, dataHandler: {(data: NSData) -> Void in
            self.playSong(data)
        })
    }
    
    // 根据歌曲id获取歌曲信息
    func loadSongInfo(id: Int){
        var path = "http://music.baidu.com/data/music/fmlink?type=mp3&rate=1&format=json&songIds=\(id)"
        downloadData(path, dataHandler: {(data: NSData) -> Void in
            var error: NSError?
            //将JSON数据转换为对象类型
            var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            //查找需要的歌曲信息
            var dataDict: NSDictionary = dict["data"] as NSDictionary
            var songInformation: NSArray = dataDict["songList"] as NSArray
            var songDict: NSDictionary = songInformation[0] as NSDictionary
            // 更新歌曲信息
            self.currentSong.refreshSong(songDict)
            self.showSongInfo()
            self.showSongPic()
            self.downloadSong(self.currentSong.songLink)
            
        })
    }
    
    func loadsongList(){
        
        var path = "http://fm.baidu.com/dev/api/?tn=playlist&special=flash&prepend=&format=json&_=13789456264366&id="+String(channel.id)
        downloadData(path, dataHandler: {(data: NSData) -> Void in
            var str = NSString(data: data, encoding: NSUTF8StringEncoding)!
            
            //将json串转换为对象
            var error: NSError?
            var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &error) as NSDictionary
            
            var list: NSArray = dict["list"] as NSArray
            
            for d in list {
                var song = Song()
                song.id = d["id"] as NSInteger
                self.songList.append(song)
                
            }
            
            if self.songList.count != 0 {
                self.currentSong = self.songList[self.currentIndex]
                // 自动下载第一首歌
             
                self.loadSongInfo(self.currentSong.id)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("OnlineViewController")
        loadsongList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
