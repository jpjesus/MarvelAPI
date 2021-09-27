//
//  FlowStartingPoint.swift
//  MarvelApp
//
//  Created by Jesus Parada on 26/09/21.
//

import Foundation
import UIKit
import Moya

final class FlowStartingPoint {
    
    var navigationController: UINavigationController?
    
    var provider: MoyaProvider<MarvelProvider> =  MoyaProvider<MarvelProvider>()
    
    init(with window: UIWindow) {
        let viewModel = MarvelListViewModel(with: provider)
        let vc = MarvelListViewController(with: viewModel)
        navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
