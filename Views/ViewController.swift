import UIKit
import MapKit
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet public weak var mapView: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    
    var gnomesViewModel = GnomeViewModel()
    var filterModalViewModel : FilterModalViewModel?
    //var searchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomesViewModel.fetchGnomes { [weak self] success in
            if success {
                self!.addAnnotations()
                self!.filterModalViewModel = FilterModalViewModel(hairColorFilter: self!.gnomesViewModel.getHairColors())
                self!.addObserverFilters()
            }else {
                print("error")
            }
        }
        searchBar.compatibleSearchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(triggerTouchAction))
        gestureRecognizer.numberOfTouchesRequired = 1
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        guard let keyPath = keyPath,  let change = change else {
            return
        }
        
        if let newName = change[NSKeyValueChangeKey.newKey], let oldName = change[NSKeyValueChangeKey.oldKey] {
            print("La propiedad con el keyPath '\(keyPath)' antes era \(oldName) y ahora tiene el valor \(newName)")
            //let filters = newName as? [Dictionary<String, String>]
            //dump(filters)
            
            if let filters = newName as? [Dictionary<String, String>] {
                let gnomesAnnotationSearched = gnomesViewModel.filterGnome(annotations: mapView.annotations, filters : filters)
                showAnnotationsSearched(annotations: gnomesAnnotationSearched)
            }
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    public func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        self.view.endEditing(true)
    }
    
    public func mapView(_ mapView: MKMapView,
                        viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let pinViewModel = annotation as? PinAnnotationViewModel else {
          return nil
        }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
        } else {
            annotationView!.annotation = annotation
        }
        annotationView!.canShowCallout = true
        annotationView?.clusteringIdentifier = "PinCluster"
        annotationView?.tag = pinViewModel.id
        annotationView!.image = UIImage(named: "annotationPlaceholder")
        //annotationView?.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "gnomePlaceholder"))
        let imageView = UIImageView()
        //imageView.contentMode = .scaleAspectFill
        
        let url = URL(string: pinViewModel.imageUrl)
        //imageView.af.setImage(withURL: url!, placeholderImage: UIImage(named: "gnomePlaceholder"))
        imageView.af.setImage(withURL: url!, placeholderImage: UIImage(named: "annotationPlaceholder"), completion: { response in
            let scaledImage = response.value?.af.imageAspectScaled(toFill: CGSize(width: 50.0, height: 50.0), scale: 0.0)
            
            //scaledImage?.af.imageAspectScaled(toFit: CGSize(width: 50.0, height: 50.0), scale: 1.0)
            
            annotationView!.image = scaledImage?.af.imageRoundedIntoCircle()
        })
        
        //annotationView!.image = imageView.image
        //annotationView?.leftCalloutAccessoryView = imageView
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        //annotationView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        annotationView!.calloutOffset = CGPoint(x: -2, y: 0)
        return annotationView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let detailVC =  self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        let detailViewModel = DetailViewModel()
        detailViewModel.gnome = gnomesViewModel.gnomes?.gnomes[view.tag]
        let amigos = gnomesViewModel.gnomes?.gnomes[view.tag].friends
        detailViewModel.friends = gnomesViewModel.gnomes?.gnomes.filter({amigos!.contains($0.name)})
        detailVC.detailViewModel = detailViewModel
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func addAnnotations() {
        gnomesViewModel.gnomesAnnotation?.forEach {
            mapView.addAnnotation($0)
        }
        regionForAnnotations(annotations: mapView.annotations)
    }
    
    private func addAnnotationsSearched(annotations: [PinAnnotationViewModel]) {
        annotations.forEach {
            mapView.addAnnotation($0)
        }
    }
    
    func regionForAnnotations(annotations : [MKAnnotation]) {
        var minLat: CLLocationDegrees = 90.0
        var maxLat: CLLocationDegrees = -90.0
        var minLon: CLLocationDegrees = 180.0
        var maxLon: CLLocationDegrees = -180.0

        for annotation in annotations as [MKAnnotation] {
            let lat = Double(annotation.coordinate.latitude)
            let long = Double(annotation.coordinate.longitude)
            if (lat < minLat) {
                minLat = lat
            }
            if (long < minLon) {
                minLon = long
            }
            if (lat > maxLat) {
                maxLat = lat
            }
            if (long > maxLon) {
                maxLon = long
            }
        }
        
        let latitudDelta = (maxLat - minLat) * 2.0
        let longitudeDelta = (maxLon - minLon) * 2.0
        let span = MKCoordinateSpan(latitudeDelta: latitudDelta > 0 ? latitudDelta : 15.0, longitudeDelta: longitudeDelta > 0 ? longitudeDelta : 15.0)
        let center = CLLocationCoordinate2DMake(maxLat - span.latitudeDelta / 4, maxLon - span.longitudeDelta / 4)
        let coordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        gnomesViewModel.gnomesAnnotationSearched = nil
        searchBar.text = nil
        searchBar.resignFirstResponder()
        addAnnotations()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let annotations = mapView.annotations
        let gnomesAnnotationSearched = gnomesViewModel.searchNameGnome(annotations: annotations, name: searchBar.text!)
        showAnnotationsSearched(annotations: gnomesAnnotationSearched)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

extension ViewController {
    
    @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func filter(){
        let filterVC =  self.storyboard?.instantiateViewController(withIdentifier: "FiltersModalViewController") as! FiltersModalViewController
        filterVC.filterModalViewModel = filterModalViewModel
        self.present(filterVC, animated: true, completion: nil)
    }
    
    func showAnnotationsSearched(annotations: [PinAnnotationViewModel]) {
        removeAllAnotationOnMap()
        addAnnotationsSearched(annotations: annotations)
        regionForAnnotations(annotations: annotations)
    }
    
    func removeAllAnotationOnMap() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    func addObserverFilters() {
        self.filterModalViewModel?.addObserver(self, forKeyPath: #keyPath(FilterModalViewModel.filters), options:  [ .new, .old ], context: nil)
    }
}
