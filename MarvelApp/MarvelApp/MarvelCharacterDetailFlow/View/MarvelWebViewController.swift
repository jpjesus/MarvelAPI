//
//  MarvelWebViewController.swift
//  MarvelApp
//
//  Created by Jesus Parada on 28/09/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import WebKit

class MarvelWebViewController: UIViewController {
    
    private lazy var wikiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var newProgressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.tintColor = .red
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let fullArticleWebView: WKWebView
    private let disposeBag = DisposeBag()
    private weak var estimatedProgress: Observable<Double>?
    private let estimatedTime = "estimatedProgress"
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
        fullArticleWebView = WKWebView()
        super.init(nibName: nil, bundle: nil)
        fullArticleWebView.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        addSubviews()
        setupWebView()
    }
    
    func addSubviews() {
        view.backgroundColor = .white
        view.addSubview(wikiView)
        view.addSubview(newProgressView)
        setWikiConstraints()
    }
    
    func setWikiConstraints() {
        wikiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        wikiView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        wikiView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        wikiView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        wikiView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        wikiView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        newProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        newProgressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        newProgressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        newProgressView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
}

//MARK: - private methods
extension MarvelWebViewController {
    
    private func setupWebView() {
        guard let url = self.url else {
            return
        }
        wikiView.addSubview(fullArticleWebView)
        fullArticleWebView.bindFrameToSuperviewBounds()
        fullArticleWebView.load(URLRequest(url: url))
        fullArticleWebView.rx
            .observe(Double.self, estimatedTime)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] progress in
                if let progress = progress {
                    self?.newProgressView.setProgress(Float(progress), animated: true)
                    self?.newProgressView.isHidden = progress == 1
                }
            }).disposed(by: disposeBag)
    }
    
    private func setNavigation() {
        navigationController?.clearNavigationBackground()
        navigationController?.isNavigationBarHidden = false
    }
}

//MARK: - WKNavigationDelegate
extension MarvelWebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: ((WKNavigationActionPolicy) -> Void)) {
        if (navigationAction.navigationType == .formSubmitted) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
