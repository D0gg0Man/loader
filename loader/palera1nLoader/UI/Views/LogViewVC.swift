//
//  LogViewer.swift
//  palera1nLoader
//
//  Created by 0x8ff on 3/10/23.
//  Copyright © 2023 0x8ff. All rights reserved.
//
//  Modified to work without Runestone, made to work for palera1nLoader
//

import UIKit

public var fromAlert = false

class LogViewer: UIViewController {
    
    @objc func closeWithDelay(){
      UIApplication.shared.openSpringBoard()
      exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (fromAlert) {
            let closeButton = UIBarButtonItem(title: LocalizationManager.shared.local("CLOSE"), style: .done, target: self, action: #selector(closeWithDelay))
            self.navigationItem.leftBarButtonItem = closeButton
            fromAlert = false
        }
 
        let textView = UITextView()
        
        self.navigationItem.title = LocalizationManager.shared.local("LOG_CELL")
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
            let appearance = UINavigationBarAppearance()
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            textView.backgroundColor = .systemBackground
        }
        textView.textContainerInset = UIEdgeInsets(top: self.navigationController!.navigationBar.frame.size.height - 25, left: 5, bottom: 8, right: 5)
        textView.isEditable = false
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.textContainer.lineBreakMode = .byClipping
        if #available(iOS 13.0, *) {
            textView.font = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        } else {
            textView.font = UIFont.systemFont(ofSize: 12)
        }
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            textView.topAnchor.constraint(equalTo: self.view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        do {
            let logFileContents = try String(contentsOfFile: logInfo.logFile, encoding: .utf8)
            textView.text = logFileContents
        } catch {
            let t = "Reading log file: \(logInfo.logFile)"
            log(type: .error, msg: t)
            textView.text = t
        }
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonTapped(_:)))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc func shareButtonTapped(_ sender: UIBarButtonItem) {
        let logFileURL = URL(fileURLWithPath: logInfo.logFile)
        let activityViewController = UIActivityViewController(activityItems: [logFileURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender
        present(activityViewController, animated: true, completion: nil)
    }
}

