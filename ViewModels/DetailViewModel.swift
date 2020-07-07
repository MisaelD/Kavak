import Foundation

public class DetailViewModel {
    
    var gnome : GnomeModel?
    var friends : [GnomeModel]?
}

extension DetailViewModel {

    public func getWeigth() -> String {
        return "Weight: \(gnome?.weight ?? 0)"
    }
    
    func getHeight() -> String {
        return "Height: \(gnome?.height ?? 0)"
    }
    
    func getAge() -> String {
        return "Age: \(gnome?.age ?? 0) years"
    }
    
    func getHairColor() -> String {
        return "Hair color: \(gnome?.hair_color ?? "")"
    }
    
}
