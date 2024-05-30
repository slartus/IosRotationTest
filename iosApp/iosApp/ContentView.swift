import UIKit
import SwiftUI
import ComposeApp

struct ComposeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        ComposeController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct ContentView: View {
    var body: some View {
        ComposeView()
                .ignoresSafeArea(.keyboard) // Compose has own keyboard handler
    }
}

class ComposeController: UIViewController {
    var childController: UIViewController? = nil

    var isAboutToClose: Bool {
        return self.isBeingDismissed ||
        self.isMovingFromParent ||
        self.navigationController?.isBeingDismissed ?? false
    }

    required init() {
        super.init(nibName: nil, bundle: nil)

        childController = MainViewControllerKt.MainViewController()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nil
        if let viewController = childController {
            addChild(viewController)
            view.addSubview(viewController.view)
            viewController.view.frame = view.bounds
            viewController.didMove(toParent: self)
        } else {
            dismiss(animated: false)
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isAboutToClose {
            childController?.willMove(toParent: nil)
            view.subviews.forEach({$0.removeFromSuperview()})
            children.forEach({$0.removeFromParent()})
            childController?.dismiss(animated: false)
            childController = nil
        }
    }
}
