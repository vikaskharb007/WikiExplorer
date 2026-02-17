import SwiftUI

struct CustomLocationView: View {
    @State private var latitudeText: String = ""
    @State private var longitudeText: String = ""
    @StateObject var viewModel: CustomLocationViewModel = CustomLocationViewModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Group {
                coordinateField(title: "Latitude", placeholderText: "Enter latitude (-90.0 to 90.0)", inputField: $latitudeText)
                
                coordinateField(title: "Longitude", placeholderText: "Enter longitude (-180.0 to 180.0)", inputField: $longitudeText)
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

    /*private func validateAndExplore() {
        errorMessage = nil

        // Trim whitespace
        let latString = latitudeText.trimmingCharacters(in: .whitespacesAndNewlines)
        let lonString = longitudeText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let lat = Double(latString), let lon = Double(lonString) else {
            errorMessage = "Please enter valid numbers for latitude and longitude."
            return
        }

        guard (-90.0...90.0).contains(lat) else {
            errorMessage = "Latitude must be between -90.0 and 90.0."
            return
        }

        guard (-180.0...180.0).contains(lon) else {
            errorMessage = "Longitude must be between -180.0 and 180.0."
            return
        }

        // All good: invoke callback if provided
        onExplore?(lat, lon)
    } */
}

#Preview {
    NavigationStack {
        CustomLocationView()
    }
}

