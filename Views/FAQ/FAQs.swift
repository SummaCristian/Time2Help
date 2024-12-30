import SwiftUI
import MapKit

enum FAQs: Identifiable, CaseIterable {
    case whatIsMarker
    case whatIsSingleGroup
    case howToChangeNeighbourhood
    case howToReturnToNeighbourhood
    case howToAccessAdvancedFilters
    case howToFilterForCarNecessary
    case howToFilterForHeavyTask
    case howToFilterForDuration
    case canIDisableLocationServices
    case howToToggleLocationServices
    
    var id : Self {self}
    
    var faq: FAQ {
        switch self {
        case .whatIsMarker:
            return FAQ(
                icon: "mappin.and.ellipse",
                color: .green,
                question: "Cosa indicano le spille sulla mappa?",
                answer: "Le spille o \"Marker\" sulla mappa indicano un Favore disponibile in quel punto.\nLa spilla ti permette di riconoscere la categoria di quel Favore grazie al suo colore e alla sua icona, e ti permette anche di capire se quel Favore è Singolo oppure di Gruppo.\nInfine, si possono distinguere i Favori che hai richiesto da quelli degli altri utenti grazie alla forma: le spille dei tuoi Favori sono sempre esagonali, mentre quelle degli altri utenti sono circolari!",
                imagePosition: .trailing) {
                VStack(spacing: 60) {
                    FavorMarker(
                        favor: Favor(
                            title: "",
                            description: "",
                            author: User(
                                nameSurname: .constant(""),
                                neighbourhood: .constant("Duomo"),
                                profilePictureColor: .constant("blue")
                            ),
                            neighbourhood: "Duomo",
                            type: .individual,
                            location: MapDetails.startingLocation,
                            isCarNecessary: false,
                            isHeavyTask: false,
                            status: .completed,
                            category: .gardening
                        ),
                        isSelected: .constant(true),
                        isInFavorSheet: true,
                        isOwner: false
                    )
                    
                    FavorMarker(
                        favor: Favor(
                            title: "",
                            description: "",
                            author: User(
                                nameSurname: .constant(""),
                                neighbourhood: .constant("Duomo"),
                                profilePictureColor: .constant("blue")
                            ),
                            neighbourhood: "Duomo",
                            type: .individual,
                            location: MapDetails.startingLocation,
                            isCarNecessary: false,
                            isHeavyTask: false,
                            status: .completed,
                            category: .gardening
                        ),
                        isSelected: .constant(true),
                        isInFavorSheet: true,
                        isOwner: true
                    )
                }
                .padding(.top, 35)
            }
        case .whatIsSingleGroup:
            return FAQ(
                icon: "person.2.fill",
                color: .blue,
                question: "Cosa cambia tra Favori Singoli e di Gruppo?",
                answer: "I Favori Singoli possono essere svolti da una sola persona, e sono pensati per richieste più piccole e personali.\nI Favori di Gruppo, invece, possono essere svolti da un numero indefinito di utenti, e sono ideali per richieste più grandi ed il cui risultato va a giovare all'intera comunità locale, come può essere la pulizia di un parco ad esempio.\nSulla mappa i Favori di Gruppo sono evidenziati dalla presenza di un cerchio colorato, che ne evidenzia il loro essere più \"di larga portata\".",
                imagePosition: .bottom
            ) {
                Map(
                    bounds: MapCameraBounds(minimumDistance: 500, maximumDistance: 500),
                    interactionModes: [] // No interactions allowed
                ) {
                    let favor = Favor(
                        title: "",
                        description: "",
                        author: User(
                            nameSurname: .constant(""),
                            neighbourhood: .constant("Duomo"),
                            profilePictureColor: .constant("blue")
                        ),
                        neighbourhood: "Duomo",
                        type: .group,
                        location: MapDetails.startingLocation,
                        isCarNecessary: false,
                        isHeavyTask: false,
                        status: .completed,
                        category: .school
                    )
                    
                    MapCircle(center: MapDetails.startingLocation, radius: 35)
                        .foregroundStyle(favor.color.opacity(0.2))
                        .stroke(favor.color, lineWidth: 3)
                        .mapOverlayLevel(level: .aboveRoads)
                    
                    Annotation("", coordinate: MapDetails.startingLocation, content: {
                        // Only this Favor is shown in this mini-Map
                        FavorMarker(
                            favor: favor,
                            isSelected: .constant(true),
                            isInFavorSheet: true,
                            isOwner: false)
                    })
                }
                .frame(height: 200)
                .cornerRadius(10)
            }
        case .howToReturnToNeighbourhood:
            return FAQ(
                icon: "building.2",
                color: .blue,
                question: "Come posso ritornare velocemente al mio quartiere?",
                answer: "Cerca il pulsante con l'icona di due palazzi mostrata qui di fianco tra i Controlli della Mappa in alto a sinistra per ritornare in ogni momento sul tuo Quartiere.",
                imagePosition: .trailing
            ) {
                Image(systemName: "building.2.crop.circle")
                    .foregroundStyle(.blue)
                    .font(.title.bold())
                    .padding(6)
                    .background {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .shadow(radius: 3)
                    }
            }
        case .howToChangeNeighbourhood:
            return FAQ(
                icon: "pencil",
                color: .orange,
                question: "Posso cambiare quartiere?",
                answer: "Sì, è possibile modificare il proprio quartiere andando in Profilo > Modifica e selezionando il nuovo quartiere.",
                imagePosition: .trailing
            )
        case .howToAccessAdvancedFilters:
            return FAQ(
                icon: "slider.horizontal.3",
                color: .yellow,
                question: "Come posso filtrare i Favori che visualizzo?",
                answer: "Sia nella visualizzazione a Mappa che in quella a Lista è possibile filtrare i Favori visualizzati.\nPer accedere a queste opzioni basta cliccare sul pulsante in alto a sinistra, che presenta l'icona mostrata qui di fianco.\nNel popup che compare è possibile modificare le opzioni di filtraggio come si preferisce.",
                imagePosition: .trailing
            ) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(.blue)
                    .font(.title.bold())
                    .padding(12)
                    .background {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .shadow(radius: 3)
                    }
            }
        case .howToFilterForCarNecessary:
            return FAQ(
                icon: "car.fill",
                color: .red,
                question: "Come posso nascondere i Favori che richiedono un'automobile?",
                answer: "Accedi alla sezione \"Filtri Avanzati\" cliccando il tasto in alto a sinitra, poi scorri fino alla voce \"Auto necessaria\".\nDisattiva questo interruttore per nascondere i Favori con questa opzione, oppure attivalo per mostrarli.",
                imagePosition: .trailing
            )
        case .howToFilterForHeavyTask:
            return FAQ(
                icon: "hammer.fill",
                color: .green,
                question: "Come posso nascondere i Favori indicati come faticosi?",
                answer: "Accedi alla sezione \"Filtri Avanzati\" cliccando il tasto in alto a sinitra, poi scorri fino alla voce \"Lavoro faticoso\".\nDisattiva questo interruttore per nascondere i Favori con questa opzione, oppure attivalo per mostrarli.",
                imagePosition: .trailing
            )
        case .howToFilterForDuration:
            return FAQ(
                icon: "clock.fill",
                color: .orange,
                question: "Come posso nascondere i Favori troppo lunghi?",
                answer: "Accedi alla sezione \"Filtri Avanzati\" cliccando il tasto in alto a sinitra, poi scorri fino alla voce \"Durata\".\nModifica il valore mostrato usando i tasti + e - per cambiare la durata massima dei Favori che sei disposto a svolgere.\nDopo aver applicato i Filtri, tutti i Favori con una fascia oraria di durata maggiore di quella impostata verranno nascosti.\nImposta la durata massima, ovvero 24 ore, per visualizzare tutti i Favori",
                imagePosition: .trailing
            )
        case .canIDisableLocationServices:
            return FAQ(
                icon: "location.slash.fill",
                color: .green,
                question: "Posso evitare di concedere i permessi di localizzazione?",
                answer: "Time2Help richiede l'accesso alla posizione del dispositivo per aiutarti ad orientarti e a trovare i Favori più vicini a te.\nCiononostante, puoi sempre decidere di negare l'accesso a questi dati, sia durante la configurazione che in un secondo momento tramite le Impostazioni.\nAnche senza accesso alla tua posizione, puoi comunque utilizzare l'app, ma potrai soltanto centrare la mappa sul tuo quartiere, non più sulla tua posizione attuale.",
                imagePosition: .trailing
            )
        case .howToToggleLocationServices:
            return FAQ(
                icon: "location.magnifyingglass",
                color: .teal,
                question: "Come cambio i permessi legati alla posizione?",
                answer: "Se vuoi modificare la tua scelta in merito ai permessi di localizzazione per Time2Help, puoi farlo cliccando sul tasto con l'icona mostrata qui vicino, a forma di ingranaggio, che si trova nella schermata del tuo Profilo, in alto a destra.\nIn alternativa, puoi raggiungere quel menu tramite il seguente percorso:\nImpostazioni > App > Time2Help (iOS 18+).",
                imagePosition: .trailing
            ) {
                Image(systemName: "gearshape.fill")
                    .foregroundStyle(.blue)
                    .font(.title.bold())
                    .padding(12)
                    .background {
                        Circle()
                            .foregroundStyle(.ultraThinMaterial)
                            .shadow(radius: 3)
                    }
            }
        }
    }
}

#Preview {
    List {
        ForEach(FAQs.allCases) { faq in
            faqView(faq: faq.faq)
        }
    }
}
