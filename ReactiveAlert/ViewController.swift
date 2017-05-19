import UIKit
import Result
import ReactiveSwift
import ReactiveCocoa

class ViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
     
        let actions = ["🌯", "🥙"].map(Action.init)
        let alert = UIAlertController.create(title: "Hey!", message: "What do you want for dinner?", actions: actions, presenter: self)
        alert.startWithValues { action in
            print("Selected \(action.title)")
        }
    }
}

struct Action {
    let title: String
}

extension UIAlertController {
    static func create(title: String, message: String, actions: [Action], presenter: UIViewController) -> SignalProducer<Action, NoError> {
        return SignalProducer { [weak presenter] sink, disposable in
            let alert = UIAlertController()
            actions.forEach { action in
                alert.addAction(UIAlertAction(title: action.title, style: .default) { _ in
                    sink.send(value: action)
                    sink.sendCompleted()
                })
            }
            
            presenter?.present(alert, animated: true)
            
            disposable += { presenter?.dismiss(animated: true, completion: nil) }
        }
    }
}
