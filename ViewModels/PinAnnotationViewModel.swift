import UIKit
import MapKit

class PinAnnotationViewModel: NSObject {

  public let coordinate: CLLocationCoordinate2D
  public let name: String
  public let age: Int
  public let imageUrl: String
  public let id: Int
  public let hairColor :String
  
  public init(coordinate: CLLocationCoordinate2D,
              name: String,
              age: Int,
              imageUrl: String,
              id: Int,
              hairColor: String) {
    self.coordinate = coordinate
    self.name = name
    self.age = age
    self.imageUrl = imageUrl
    self.id = id
    self.hairColor = hairColor
  }
}

extension PinAnnotationViewModel: MKAnnotation {
  public var title: String? {
    return name
  }
  
  public var subtitle: String? {
    return "\(age) años"
  }
}
