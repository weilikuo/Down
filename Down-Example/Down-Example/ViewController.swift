//
//  ViewController.swift
//  Down-Example
//
//  Created by Keaton Burleson on 7/1/17.
//  Copyright © 2016-2019 Down. All rights reserved.
//

import UIKit
import Down

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        renderDownInWebView()
    }
    
}

private extension ViewController {
    
    func renderDownInWebView() {
        guard let readMeURL = Bundle.main.url(forResource: nil, withExtension: "md"),
              let readMeContents = try? String(contentsOf: readMeURL)
            else {
                showError(message: "Could not load readme contents.")
                return
        }
        
        do {

            let downLabel = DownLabel(markDown: readMeContents)
            downLabel.translatesAutoresizingMaskIntoConstraints = false
            downLabel.numberOfLines = 0

            let downView = try DownView(frame: .zero, markdownString: readMeContents, didLoadSuccessfully: {
                print("Markdown was rendered.")
            })
            downView.translatesAutoresizingMaskIntoConstraints = false

            let header = UILabel()
            header.translatesAutoresizingMaskIntoConstraints = false
            header.text = "Our custom content above the markdown"
            header.backgroundColor = .yellow
            header.heightAnchor.constraint(equalToConstant: 100).isActive = true

            let footer = UILabel()
            footer.translatesAutoresizingMaskIntoConstraints = false
            footer.text = "Our custom content below the mardown"
            footer.backgroundColor = .yellow
            footer.heightAnchor.constraint(equalToConstant: 100).isActive = true

            let stack = UIStackView(arrangedSubviews: [header, downLabel, downView, footer])
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false

            let outerScroll = UIScrollView()
            outerScroll.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(outerScroll)
            outerScroll.addSubview(stack)


            NSLayoutConstraint.activate([
                view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: outerScroll.topAnchor),
                view.safeAreaLayoutGuide.leftAnchor.constraint(equalTo: outerScroll.leftAnchor),
                view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: outerScroll.bottomAnchor),
                view.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: outerScroll.rightAnchor),
                downView.widthAnchor.constraint(equalTo: outerScroll.widthAnchor)
            ])

            NSLayoutConstraint.activate([
                outerScroll.topAnchor.constraint(equalTo: stack.topAnchor),
                outerScroll.leftAnchor.constraint(equalTo: stack.leftAnchor),
                outerScroll.bottomAnchor.constraint(equalTo: stack.bottomAnchor),
                outerScroll.rightAnchor.constraint(equalTo: stack.rightAnchor)
            ])

            downView.scrollView.isScrollEnabled = false

            // Perhaps try value-observing the contentSize if possible, rather than assume a delay is enough
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                downView.heightAnchor.constraint(equalToConstant: downView.scrollView.contentSize.height).isActive = true
            }
        } catch {
            showError(message: error.localizedDescription)
        }
    }

    func showError(message: String) {
        let alertController = UIAlertController(title: "DownView Render Error",
                                                message: message,
                                                preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
}
