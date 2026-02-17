
# WikiExplorer

The app displays a list of places fetched from a remote. Tapping a place opens the Wikipedia app at the place's coordinates, letting users explore locations directly in Wikipedia


Features
- Places List - Displays a list of places
- Wikipedia integration - Connects to wikipedia app using URL scheme - wikipedia://places?coordinates
- Custom coordinates - A dedicated screen to elt the users enter latitude and longitude within a given range
- Accesibility - Full Voice over support with descriptive labels and hints

Requirements
- iOS18.0
- xcode16
- swift6
- wikipedia app insatlled on the device

Architecture
- The app uses a hybrid of MVVM and clean separating concerns across distinct layers
- MainActor Isolation has been kept in mind for robust view updates

UnitTests
- Project includes unit test using Swift Testing Suite covering viewModels and service providers


