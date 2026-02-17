//
//  AppConnectProtocol.swift
//  WikiExplorer
//
//  Created by Swati Sood on 17/02/2026.
//


public protocol AppConnectProtocol {
    func open(_ lat: Double, long: Double) async throws
}