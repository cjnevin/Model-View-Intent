import UIKit
import SnapKit

final class ViewController: UIViewController {
    let counter = CounterComponent()
    let elapsed = ElapsedComponent()
    
    func render() {
        [counter.label, counter.decrement, counter.increment].forEach(view.addSubview)
        [elapsed.label, elapsed.reset].forEach(view.addSubview)
        
        elapsed.label.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        counter.label.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.top.equalTo(elapsed.label.snp.bottom).offset(20)
        }
        
        counter.decrement.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        counter.increment.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(counter.decrement.snp.top).offset(-20)
        }
        
        elapsed.reset.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
            make.bottom.equalTo(counter.increment.snp.top).offset(-20)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }
}

