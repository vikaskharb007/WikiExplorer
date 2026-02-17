//
//  MockAppConnectService.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//

final class MockAppConnectService: AppConnectProtocol {
    var openCalled: (lat: Double, long: Double)?
    var result: Result<Void, Error> = .success(())
    func open(_ lat: Double, long: Double) async throws {
        openCalled = (lat, long)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
