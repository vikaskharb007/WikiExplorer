import SwiftUI

struct CustomLocationView: View {
    @State private var latitudeText: String = ""
    @State private var longitudeText: String = ""
    @StateObject var viewModel: CustomLocationViewModel = CustomLocationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                coordinateField(title: "Latitude", placeholderText: "Enter latitude between -90.0 and 90.0)", inputField: $latitudeText)
                
                coordinateField(title: "Longitude", placeholderText: "Enter longitude between -180.0 and 180.0)", inputField: $longitudeText)
            }

            if let requestError = viewModel.requestError {
                Text(requestError.localizedDescription)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button("Explore") {
                Task {
                    await viewModel.validateCoordinatesAndConnectApp(lat: latitudeText, long: longitudeText)
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)
            .accessibilityLabel("Open Wikipedia app with coordinates")

            Spacer()
        }
        .padding()
        .navigationTitle("Explore Custom Location")
    }
    
    @ViewBuilder func coordinateField(title: String, placeholderText: String, inputField: Binding<String>) -> some View {
        VStack {
            Text(title)
                .font(.headline)
            TextField(placeholderText, text: inputField)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    NavigationStack {
        CustomLocationView()
    }
}

