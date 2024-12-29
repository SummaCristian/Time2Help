import SwiftUI
import MapKit

struct MapButtonsView: View {
    
    @ObservedObject var viewModel: MapViewModel
    
    // The MapCameraPosition used to center around the User's Location
    @Binding var camera: MapCameraPosition
    @Binding var cameraSupport: MapCameraPosition
    
    let selectedCLLocationCoordinate: CLLocationCoordinate2D
    
    let mapNameSpace: Namespace.ID
    
    @AppStorage("mapStyle") private var isSatelliteMode: Bool = false
    
    @State private var is3dMode: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                Button(action: {
                    isSatelliteMode.toggle()
                }) {
                    Image(systemName: !isSatelliteMode ? "map.circle" : "globe.europe.africa.fill")
                        .font(isSatelliteMode ? .title2 : .title)
                        .foregroundStyle(.blue)
                        .frame(width: 50, height: 50)
                }
                
                Button(action: {
                    if !is3dMode {
                        camera = MapCameraPosition.camera(.init(centerCoordinate: cameraSupport.camera!.centerCoordinate, distance: cameraSupport.camera!.distance, heading: cameraSupport.camera!.heading, pitch: 45.0))
                        is3dMode = true
                    } else {
                        camera = MapCameraPosition.camera(.init(centerCoordinate: cameraSupport.camera!.centerCoordinate, distance: cameraSupport.camera!.distance, heading: cameraSupport.camera!.heading, pitch: 0.0))
                        is3dMode = false
                    }
                }) {
                    Text(!is3dMode ? "3D" : "2D")
                    //                        .font(.custom("ArchivoVariable-SemiBold_Medium", size: 18))
                    //                        .font(.body)
                        .foregroundStyle(.blue)
                        .frame(width: 50, height: 50)
                }
                
                if viewModel.locationManager.authorizationStatus == .authorizedAlways || viewModel.locationManager.authorizationStatus == .authorizedWhenInUse {
                    MapUserLocationButton(scope: mapNameSpace)
                        .bold()
                }
                
                Button(action: {
                    if is3dMode {
                        is3dMode = false
                    }
                    camera = MapCameraPosition.camera(.init(centerCoordinate: .init(latitude: selectedCLLocationCoordinate.latitude, longitude: selectedCLLocationCoordinate.longitude), distance: 3200.0, heading: 0.0, pitch: 0.0))
                }) {
                    Image(systemName: "building.2.crop.circle")
                        .font(.title3)
                        .foregroundStyle(.blue)
                        .frame(width: 50, height: 50)
                }
            }
            .background {
                Capsule()
                //                        RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.thinMaterial)
                    .shadow(color: .gray.opacity(0.4), radius: 6)
            }
            
            //            MapCompass(scope: mapNameSpace)
        }
    }
}
