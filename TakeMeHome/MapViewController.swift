import UIKit

public let DEFAULT_POSITION = MTMapPointGeo(latitude: 37.576568, longitude: 127.029148)
class MapViewController: UIViewController, MTMapViewDelegate {
    
    var mapView: MTMapView?
    
    var mapPoint1: MTMapPoint?
    var poiItem1: MTMapPOIItem?
    
    var allCircle = [MTMapCircle]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 지도 불러오기
        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView {
            mapView.delegate = self
            mapView.baseMapType = .standard
            
            // 지도 중심점, 레벨
            //mapView.setMapCenter(MTMapPoint(geoCoord: MTMapPointGeo(latitude:  37.585568, longitude: 127.019148)), zoomLevel: 1, animated: true)
           
            // 현재 위치 트래킹
            mapView.currentLocationTrackingMode = .onWithoutHeading
            mapView.showCurrentLocationMarker = true
            
            makeMarker()
          
            
            self.view.addSubview(mapView)
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    func makeMarker(){
        for item in CallItem.callItems {
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
            circ.circleRadius = 500.0
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
