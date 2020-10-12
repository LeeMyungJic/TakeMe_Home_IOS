import UIKit

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)
class MapViewController: UIViewController, MTMapViewDelegate {
    
    var mapView: MTMapView?
    
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    var allCircle = [MTMapCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 지도 중심점, 레벨
            //mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.443948814883925, longitude: 126.73770385857193)), zoomLevel: 1, animated: true)
            
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            makeMarker()
            
            
            self.view.addSubview(mapView)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        let userCircle = circle(latitude: latitude, longitude: longitude)
        for item in allCircle {
            mapView!.removeCircle(item)
        }
        
        for item in mapView!.poiItems {
            mapView!.remove(item as! MTMapPOIItem)
        }
        makeMarker()
    }
    
    
    func makeMarker(){
        // 콜 아이템 : 노랑 핀
        for item in CallItem.callItems {
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.latitude!, longitude: item.longitude!
            ))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.yellowPin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = item.storeName
            mapView!.add(poiItem1)
        }
        
        // 접수 아이템 : 레드 핀
        for item in AcceptanceItem.acceptanceItems {
            self.mapPoint1 = MTMapPoint(geoCoord: MTMapPointGeo(latitude: item.latitude!, longitude: item.longitude!
            ))
            poiItem1 = MTMapPOIItem()
            poiItem1?.markerType = MTMapPOIItemMarkerType.redPin
            poiItem1?.mapPoint = mapPoint1
            poiItem1?.itemName = item.storeName
            mapView!.add(poiItem1)
        }
    }
    
    func circle(latitude:Double, longitude:Double) -> MTMapCircle {
        let circ = MTMapCircle()
        circ.circleCenterPoint = MTMapPoint(geoCoord:
                                                MTMapPointGeo(latitude: latitude, longitude: longitude)
        )
        circ.circleRadius = Float(SettingsViewController.range)
        circ.circleLineColor = UIColor.red
        circ.circleLineWidth = 5
        circ.circleFillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
        circ.tag = 1
        
        return circ
    }
    
    
    // Custom: 현 위치 트래킹 함수
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        let currentLocation = location?.mapPointGeo()
        if let latitude = currentLocation?.latitude, let longitude = currentLocation?.longitude{
            print("MTMapView updateCurrentLocation (\(latitude),\(longitude)) accuracy (\(accuracy))")
            self.latitude = latitude
            self.longitude = longitude
            let userCircle = circle(latitude: latitude, longitude: longitude)
            for item in allCircle {
                mapView.removeCircle(item)
            }
            allCircle = [MTMapCircle]()
            allCircle.append(circle(latitude: latitude, longitude: longitude))
            mapView.addCircle(allCircle[0])
        }
        
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        print("MTMapView updateDeviceHeading (\(headingAngle)) degrees")
    }
    
    
    
    
}
