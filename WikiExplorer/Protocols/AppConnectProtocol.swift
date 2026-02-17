//
//  AppConnectProtocol.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


public protocol AppConnectProtocol {
    func open(_ lat: Double, long: Double) async throws
}
