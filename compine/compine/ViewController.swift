//
//  ViewController.swift
//  compine
//
//  Created by Reason? on 2015/11/27.
//  Copyright © 2015年 Reason?. All rights reserved.
//


import UIKit
import GoogleMaps
import CoreLocation


class ViewController: UIViewController ,CLLocationManagerDelegate, UISearchBarDelegate{
    //Googleマップを追加
    var googleMap : GMSMapView!
    var count=0;
    
    let nowPin: GMSMarker = GMSMarker()
    let searchPin: GMSMarker = GMSMarker()
    let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))//大きさ
   
    
    //緯度経度定数 -> KIITO//マップで使用
    let latitude: CLLocationDegrees = 34.6846184553902
    let longitude: CLLocationDegrees = 135.199079588182
    //現在地マネージャーを追加
    var myLocationManager:CLLocationManager!
    // 緯度表示用のラベル.
    var myLatitudeLabel:UILabel!
    // 経度表示用のラベル.
    var myLongitudeLabel:UILabel!
    // 方角表示する用ラベル.
    var myAngleLabel:UILabel!
    //検索バー
    var mySearchBar:UISearchBar!
    
    override func viewDidLoad() {//開始時の画面情報
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //**********************マップの設定(始まり)*************************************************************
        //ズームレベル
        let zoom: Float = 17
        
        // カメラを生成.追跡範囲
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(latitude,longitude: longitude, zoom: zoom)
        
        //MapViewを生成.
        googleMap = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        // MapViewにカメラを追加.
        googleMap.camera = camera
        //マーカーの作成
        //let marker: GMSMarker = GMSMarker()
        nowPin.position = CLLocationCoordinate2DMake(latitude, longitude)
        nowPin.map = googleMap
        //**********************マップの設定(終わり)*************************************************************
        //**********************GPSの設定(始まり)*************************************************************
        // ボタンの生成.
        //let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))//大きさ
        myButton.backgroundColor = UIColor.blueColor()
        myButton.layer.masksToBounds = true
        myButton.setTitle("ボタン", forState: .Normal)
        myButton.layer.cornerRadius = 30.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/5*4)//場所
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        // 緯度表示用のラベルを生成.
        myLatitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLatitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+100)
        // 軽度表示用のラベルを生成.
        myLongitudeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myLongitudeLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height/2+130)
        //方角表示用のラベルを生成.
        myAngleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        myAngleLabel.layer.position = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2+70)
        // 現在地の取得.
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status == CLAuthorizationStatus.NotDetermined) {
            print("didChangeAuthorizationStatus:\(status)");
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        // 取得精度の設定.最高精度に設定した.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 300
        
        
        //起動する瞬間からGPS情報を起動する
        //myLocationManager.startUpdatingLocation()}
        //コンパス更新機能起動
        //myLocationManager.startUpdatingHeading()
        
        //********************************検索バーの設定*******************************************
        // 検索バーを作成する.
        mySearchBar = UISearchBar()
        mySearchBar.delegate = self
        mySearchBar.frame = CGRectMake(0, 0, 300, 80)
        mySearchBar.layer.position = CGPoint(x: self.view.bounds.width/2, y: 100)
        
        // 影をつける.
        mySearchBar.layer.shadowColor = UIColor.blackColor().CGColor
        mySearchBar.layer.shadowOpacity = 0.5
        mySearchBar.layer.masksToBounds = false
        
        // キャンセルボタンを有効にする.
        mySearchBar.showsCancelButton = true
        
        // ブックマークボタンを無効にする.
        mySearchBar.showsBookmarkButton = false
        
        // バースタイルをDefaultに設定する.
        mySearchBar.searchBarStyle = UISearchBarStyle.Default
        
        // タイトルを設定する.
        mySearchBar.prompt = "タイトル"
        
        // 説明文を設定する.
        mySearchBar.placeholder = "ここに入力してください"
        
        // カーソル、キャンセルボタンの色を設定する.
        mySearchBar.tintColor = UIColor.redColor()
        
        // 検索結果表示ボタンは非表示にする.
        mySearchBar.showsSearchResultsButton = false
        
        

        //*******************************************************************************************************
        
        //viewにMapViewを追加.
        self.view.addSubview(googleMap)
        self.view.addSubview(myButton)
        //self.view.delete(googleMap)
        self.view.addSubview(mySearchBar)
        //**********************GPSの設定(終まり)*************************************************************
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
        myLocationManager.startUpdatingHeading()
        count = 0
    }
    // 位置情報取得に成功したときに呼び出されるデリゲート.
    //func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [CLLocation]!){
    func locationManager(manager: CLLocationManager,didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        //現在地の取得
        myLocationManager.startUpdatingLocation()
        var mylatitude: CLLocationDegrees!
        var mylongitude: CLLocationDegrees!
        mylatitude=manager.location!.coordinate.latitude
        mylongitude=manager.location!.coordinate.longitude
        //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        if(count==0){

            //ズームレベル
            let zoom: Float = 17
        
            // カメラを生成.追跡範囲
            let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(mylatitude,longitude: mylongitude, zoom: zoom)
            //MapViewを生成.
            googleMap = GMSMapView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
            // MapViewにカメラを追加.
            googleMap.camera = camera
            nowPin.position = CLLocationCoordinate2DMake(mylatitude, mylongitude)
            nowPin.map = googleMap
            count=1
        }
        else{
            nowPin.position = CLLocationCoordinate2DMake(mylatitude, mylongitude)
            nowPin.map = googleMap
            count=100
            }
        
        
        
        //viewにMapViewを追加.
        self.view.addSubview(googleMap)
        
        //■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■
        
        // 緯度・経度の表示.
        //myLatitudeLabel.text = "緯度：\(manager.location.coordinate.latitude)"
        myLatitudeLabel.text = "緯度：\(mylatitude)"
        myLatitudeLabel.textAlignment = NSTextAlignment.Center
        
        //myLongitudeLabel.text = "経度：\(manager.location.coordinate.longitude)"
        myLongitudeLabel.text = "経度：\(mylongitude)"
        myLongitudeLabel.textAlignment = NSTextAlignment.Center
        
        //myAngleLabel.text = "方角:\(myAngle)"
        //myAngleLabel.textAlignment = NSTextAlignment.Center
        
        self.view.addSubview(myLatitudeLabel)
        self.view.addSubview(myLongitudeLabel)
        self.view.addSubview(myAngleLabel)
        self.view.addSubview(myButton)
        
    
    }

    
    // コンパスの値を受信
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
        let myAngle = newHeading.magneticHeading
        
        myAngleLabel.text = "角度：\(myAngle)"
        myAngleLabel.textAlignment = NSTextAlignment.Center
        
        googleMap.animateToBearing(myAngle)
       }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        mySearchBar.text = ""
    }
    
    
    
    //位置情報取得に失敗した時に呼び出されるデリゲート.
    //func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
    func locationManager(manager: CLLocationManager,didFailWithError error: NSError){
        print("error")
    }
    

    /*
    テキストが変更される毎に呼ばれる
    */
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        //myLabel.text = searchText
    }
    
    /*
    Searchボタンが押された時に呼ばれる
    */
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //入力した文字列をゲット
        let searchAddress: String!
        searchAddress=mySearchBar.text
        
        //検索バーをリセットする
        mySearchBar.text = ""
        self.view.endEditing(true)
        
        
        
        
        //ジオコーディング用意
        let myGeocoder: CLGeocoder = CLGeocoder()
        let searchMarker: GMSMarker = GMSMarker()
        
        // 正ジオコーディング開始
        myGeocoder.geocodeAddressString(searchAddress, completionHandler: { (placemarks, error) -> Void in
            var placemark: CLPlacemark!
            
            for placemark in placemarks! {
                // locationにplacemark.locationをCLLocationとして代入する
                let location: CLLocation = placemark.location!
                
                print("Latitude: \(location.coordinate.latitude)")
                print("Longitude: \(location.coordinate.longitude)")
                
                // アノテーションのtitle, subtitleにそれぞれ緯度経度をセット.
                let searchCamera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(location.coordinate.latitude,longitude: location.coordinate.longitude, zoom: 17)

                searchMarker.position = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                searchMarker.map = self.googleMap
                
                self.googleMap.camera = searchCamera
                
                self.view.addSubview(self.googleMap)


            }
        })

        
        
        
    }


    

    
    //不要メモリを解放する
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

