# Kavak

Los Gnomos de Brastlewark han llegado a America. ¿Estan cerca de ti?

Así es, los gnomos han llegado a America, y esta aplicación te muestra donde se han colocado.

He tomado los gnomos y los he mostrado dentro de un mapa en puntos aleatorios. Tomé algunas coordenadas de Canadá, USA, México y Sudamerica.
Estas coordenadas son cuadrados, es decir, tomé dos esquinas y mediante una función aleatoria, obtuve los puntos dentro de este cuadrado.
```
private func randomFloatBetween(_ smallNumber: Double, andBig bigNumber: Double) -> Double {
        let diff: Double = bigNumber - smallNumber
        return ((Double(arc4random() % (UInt32(RAND_MAX) + 1)) / Double(RAND_MAX)) * diff) + smallNumber
    }
```
Son muchos gnomos y dentro del mapa se amontonan. Así que decidí hacer un clustering de los pines. Así sólo se muestran el número que estan en 
cierta región del mapa y al hacer zoom, se van desplegando hasta que podemos observar las imagenes de los gnomos.

Al hacer tap sobre ellos, nos muestra una pequeña descripción, decidí mostrar el nombre y la edad, que pienso que son los más relevantes. En esta 
descripción hay un botón que nos lleva a la toda la información del gnomo.

`Pero espera, sus amigos no tienen imágen.` Revisando el Json me di cuenta que podría buscar a sus amigos y obtener la URL de su imagen. Así que decidí 
hacerlo:
```
let amigos = gnomesViewModel.gnomes?.gnomes[view.tag].friends
gnomes.filter({amigos!.contains($0.name)})
```
Con esto, ya tengo las imágenes de sus amigos, si es que tiene.

Con la búsqueda hice algo similar, añadí una `UISearchBar` y tome el texto que ingresen, y lo filtro con todos los gnomos. Sólo los filtro por nombre.
```
func searchNameGnome(annotations: [MKAnnotation], name: String) -> [PinAnnotationViewModel] {
        gnomesAnnotationSearched = gnomesAnnotation?.filter{
            $0.name.lowercased().contains(name.lowercased())
        }
        return gnomesAnnotationSearched!
    }
 ```

Igualmente hice con los filtros, que debo decir, me causo un poco de problema, al decidir que campo quería filtrar y que fuera significativo. Los filtre por 
color de cabello y edad.

Para el filtro por el color de cabello, primero obtuve los diferentes tonalidades de cabello, para despues filtrar como anteriormente lo hice. Y con la edad 
propuse un rago que fuera significativo, los filtre por menos de 100 años y mayor a 100 años.
```
func getHairColors() -> [String] {
        var hairColors = [String]()
        for gnome in gnomes!.gnomes {
            if !hairColors.contains(gnome.hair_color) {
                hairColors.append(gnome.hair_color)
            }
        }
        return hairColors
    }
 ```
 ```
  func filterGnome(annotations: [MKAnnotation], filters: [Dictionary<String, String>]) -> [PinAnnotationViewModel] {
        let ageLess = filters[1]["filter"] == "<" ? 100 : nil
        let ageOlder = filters[1]["filter"] == ">" ? 100 : nil
        
        let filteredAnnotation : [PinAnnotationViewModel]?
        
        if gnomesAnnotationSearched == nil {
            filteredAnnotation = gnomesAnnotation?.filter {
                $0.hairColor.contains(filters[0]["filter"] ?? $0.hairColor) && $0.age <= (ageLess ?? $0.age) && $0.age >= (ageOlder ?? $0.age)
            }
        }else{
            filteredAnnotation = gnomesAnnotationSearched?.filter {
                $0.hairColor.contains(filters[0]["filter"] ?? $0.hairColor) && $0.age <= (ageLess ?? $0.age) && $0.age >= (ageOlder ?? $0.age)
            }
        }
        return filteredAnnotation!
    }
```

## Pods utilizados

Utilicé los siguientes pods:

- Alamofire: para obtener el Json.
- AlamofireImage: para mostar las imagenes asíncronamente, esta librería la utilizo para mostrar los pines con imagen, la imagen del gnomo y la de sus amigos.
- MBProgressHUD: para mortrar el spin de espera del servicio y la carga de los gnomos en el mapa.

## Cosas que se hicieron o faltaron

- [x] Filtrar
- [x] Buscar
- [ ] MVVM: por la premura del tiempo por mi carga de trabajo, falto pulirlo :(
- [ ] Determinar el género :(
- [ ] Tal vez haya algunos bichos, pero pequeños
- [x] Github
- [x] Code style: me he apegado a las convenciones que dictan el buen còdigo. Utilice la programación descriptiva.




  
  
    



