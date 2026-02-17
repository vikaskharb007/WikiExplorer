//
//  AppConnectProtocol.swift
//  WikiExplorer
//
//  Created by Vikas Kharb on 17/02/2026.
//


public protocol AppConnectProtocol {
    func open(latitude: Double, longitude: Double) async throws
}
