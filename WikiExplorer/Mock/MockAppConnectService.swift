//
//  MockAppConnectService.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

final class MockAppConnectService: AppConnectProtocol {
    var openCalled: (lat: Double, long: Double)?
    var result: Result<Void, Error> = .success(())
    func open(latitude: Double, longitude: Double) async throws {
        openCalled = (latitude, longitude)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
