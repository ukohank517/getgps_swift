//
//  ViewController.swift
//  test
//
//  Created by Reason? on 11/13/15.
//  Copyright © 2015 Reason?. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{
    
    var myLocationManager:CLLocationManager!
    
    // 緯度表示用のラベル.
    var myLatitudeLabel:UILabel!
    
    // 経度表示用のラベル.
    var myLongitudeLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ボタンの生成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        myButton.backgroundColor = UIColor.orangeColor()
        myButton.layer.masksToBounds = true
        myButton.setTitle("Get", forState: .Normal)
        myButton.layer.cornerRadius = 50.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // 緯度表示用のラベルを生成.
        myLatitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLatitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+100)
        
        // 軽度表示用のラベルを生成.
        myLongitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLongitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+130)
        
        
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        
        myLocationManager.delegate = self
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            print("didChangeAuthorizationStatus:\(status)");
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        
        self.view.addSubview(myButton)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        print("didChangeAuthorizationStatus");
        
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
        case .NotDetermined:
            statusStr = "NotDetermined"
        case .Restricted:
            statusStr = "Restricted"
        case .Denied:
            statusStr = "Denied"
        case .AuthorizedAlways:
            statusStr = "AuthorizedAlways"
        case .AuthorizedWhenInUse:
            statusStr = "AuthorizedWhenInUse"
        }
        print(" CLAuthorizationStatus: \(statusStr)")
    }
    
    // ボタンイベントのセット.
    func onClickMyButton(sender: UIButton){
        // 現在位置の取得を開始.
        myLocationManager.startUpdatingLocation()
    }
    
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    //func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [CLLocation]!){
    func locationManager(manager: CLLocationManager,didUpdateLocations locations: [CLLocation]){
  
        // 緯度・経度の表示.
        //myLatitudeLabel.text = "緯度：\(manager.location.coordinate.latitude)"
        myLatitudeLabel.text = "緯度：\(manager.location!.coordinate.latitude)"
        myLatitudeLabel.textAlignment = NSTextAlignment.Center
        
        //myLongitudeLabel.text = "経度：\(manager.location.coordinate.longitude)"
        myLongitudeLabel.text = "経度：\(manager.location!.coordinate.longitude)"
        myLongitudeLabel.textAlignment = NSTextAlignment.Center
        
        
        self.view.addSubview(myLatitudeLabel)
        self.view.addSubview(myLongitudeLabel)
        
    }
    
    //位置情報取得に失敗した時に呼び出されるデリゲート.
    //func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error")
    }
    
}

