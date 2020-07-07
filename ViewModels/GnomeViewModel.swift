import Foundation
import MapKit


public class GnomeViewModel {
    
    var gnomes : GnomesModel?
    var gnomesAnnotation : [PinAnnotationViewModel]?
    var gnomesAnnotationSearched : [PinAnnotationViewModel]?
    var countRandomCoordinates = 0
}

extension GnomeViewModel {
    func fetchGnomes(completion:@escaping (Bool) -> Void) {
        
        APIClient.fetchGnomes { [weak self] gnomes in
            do {
                self?.gnomes = try gnomes.get()
                self?.gnomesModelToAnnotations()
                //dump(self?.gnomes)
                completion(true)
            } catch {
               // or display a dialog
                completion(false)
            }
        }        
    }
    
    func gnomesModelToAnnotations() {
        gnomesAnnotation = (gnomes?.gnomes.map{
            let annotation = self.annotation(title: $0.name, subtitle: $0.age, imageUrl: $0.thumbnail, id: $0.id, hairColor: $0.hair_color)
            return annotation
            })!
    }
    
    func annotation(title: String, subtitle: Int, imageUrl: String, id: Int, hairColor: String) -> PinAnnotationViewModel {
        
        var latitude = randomFloatBetween(61.012960, andBig: 49.693913)
        var longitude = randomFloatBetween(-124.509954, andBig: -93.557276)
        
        switch countRandomCoordinates {
        case 0...335:
            latitude = randomFloatBetween(61.012960, andBig: 49.693913)
            longitude = randomFloatBetween(-124.509954, andBig: -93.557276)
        case 336...670:
            latitude = randomFloatBetween(48.670012, andBig: 34.793098)
            longitude = randomFloatBetween(-122.398568, andBig: -76.652768)
        case 671...721:
            latitude = randomFloatBetween(32.507111, andBig: 25.319534)
            longitude = randomFloatBetween(-110.457693, andBig: -98.019336)
        case 722...871:
            latitude = randomFloatBetween(25.944243, andBig: 21.234115)
            longitude = randomFloatBetween(-105.965765, andBig: -97.528266)
        case 872...922:
            latitude = randomFloatBetween(19.989295, andBig: 17.720396)
            longitude = randomFloatBetween(-101.686153, andBig: -96.595054)
        case 922...992:
            latitude = randomFloatBetween(2.849628, andBig: -8.173868)
            longitude = randomFloatBetween(-77.854754, andBig: -50.372766)
        case 992...1142:
        latitude = randomFloatBetween(-13.232620, andBig: -22.789385)
        longitude = randomFloatBetween(-70.170297, andBig: -42.139767)
            case 1142...1340:
            latitude = randomFloatBetween(-24.726239, andBig: -16.850033)
            longitude = randomFloatBetween(-69.781585, andBig: -53.498827)
        default:
            break
        }
        countRandomCoordinates += 1
        
        //canada
        //61.012960, -124.509954
        //49.693913, -93.557276
        //usa
        //48.670012, -122.398568
        //34.793098, -76.652768
        //usa-mex
        //32.507111, -110.457693
        //25.319534, -98.019336
        
        //mexico
        //25.944243, -105.965765
        //21.234115, -97.528266
        //mex 2
        //19.989295, -101.686153
        //17.720396, -96.595054
        //sur
        //2.849628, -77.854754
        //-8.173868, -50.372766
        //sur2
        //-13.232620, -70.170297
        //-22.789385, -42.139767
        //sur 3
        //-24.726239, -69.781585
        //-33.576068, -53.498827
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let pinAnnotation = PinAnnotationViewModel(coordinate: coordinate, name: title, age: subtitle, imageUrl: imageUrl, id: id, hairColor: hairColor)
        return pinAnnotation
    }
    
    private func randomFloatBetween(_ smallNumber: Double, andBig bigNumber: Double) -> Double {
        let diff: Double = bigNumber - smallNumber
        return ((Double(arc4random() % (UInt32(RAND_MAX) + 1)) / Double(RAND_MAX)) * diff) + smallNumber
    }
}

extension GnomeViewModel {
    
    func searchNameGnome(annotations: [MKAnnotation], name: String) -> [PinAnnotationViewModel] {
        /*
        let pinAnnotationConverted = annotations.compactMap { $0 as? PinAnnotationViewModel }
        let gnomesSearched = pinAnnotationConverted.filter {
            $0.name.lowercased().contains(name.lowercased())
        }
        return gnomesSearched
 */
        gnomesAnnotationSearched = gnomesAnnotation?.filter{
            $0.name.lowercased().contains(name.lowercased())
        }
        return gnomesAnnotationSearched!
    }
    
    func getHairColors() -> [String] {
        var hairColors = [String]()
        for gnome in gnomes!.gnomes {
            if !hairColors.contains(gnome.hair_color) {
                hairColors.append(gnome.hair_color)
            }
        }
        return hairColors
    }
    
    func filterGnome(annotations: [MKAnnotation], filters: [Dictionary<String, String>]) -> [PinAnnotationViewModel] {
        let ageLess = filters[1]["filter"] == "<" ? 100 : nil
        let ageOlder = filters[1]["filter"] == ">" ? 100 : nil
        
        let filteredAnnotation : [PinAnnotationViewModel]?
        
        if gnomesAnnotationSearched == nil {
            filteredAnnotation = gnomesAnnotation?.filter{
                $0.hairColor.contains(filters[0]["filter"] ?? $0.hairColor) && $0.age <= (ageLess ?? $0.age) && $0.age >= (ageOlder ?? $0.age)
            }
        }else{
            filteredAnnotation = gnomesAnnotationSearched?.filter{
                $0.hairColor.contains(filters[0]["filter"] ?? $0.hairColor) && $0.age <= (ageLess ?? $0.age) && $0.age >= (ageOlder ?? $0.age)
            }
        }
        return filteredAnnotation!
    }
}
