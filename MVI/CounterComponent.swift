import RxSwift
import RxCocoa

class CounterComponent {
    private let disposeBag = DisposeBag()
    private let binder = Binder(CounterModel(), CounterView(), CounterIntent())
    let label = UILabel()
    let increment = UIButton()
    let decrement = UIButton()
    
    init() {
        label.textAlignment = .center
        
        increment.backgroundColor = .black
        increment.setTitleColor(.white, for: .normal)
        increment.setTitle("Increment Count", for: .normal)
        
        decrement.backgroundColor = .black
        decrement.setTitleColor(.white, for: .normal)
        decrement.setTitle("Decrement Count", for: .normal)
        
        increment.rx.tap.subscribe(binder.view.increment).disposed(by: disposeBag)
        decrement.rx.tap.subscribe(binder.view.decrement).disposed(by: disposeBag)
        binder.view.text.debug().bind(to: label.rx.text).disposed(by: disposeBag)
    }
}

struct CounterModel: Model {
    private let disposeBag = DisposeBag()
    fileprivate let count = BehaviorSubject<Int>(value: 0)
    
    func observe(_ intent: CounterIntent) {
        let increment = intent.increment.map { _ in 1 }
        let decrement = intent.decrement.map { _ in -1 }
        Observable.merge(increment, decrement)
            .startWith(0)
            .withLatestFrom(count) { $0 + $1 }
            .subscribe(count)
            .disposed(by: disposeBag)
    }
}

struct CounterView: View {
    private let disposeBag = DisposeBag()
    fileprivate let text = BehaviorSubject<String>(value: "")
    fileprivate let increment = PublishSubject<Void>()
    fileprivate let decrement = PublishSubject<Void>()
    
    func observe(_ model: CounterModel) {
        model.count.map({ "Count is now: \($0)" }).subscribe(text).disposed(by: disposeBag)
    }
}

struct CounterIntent: Intent {
    private let disposeBag = DisposeBag()
    fileprivate let increment = PublishSubject<Void>()
    fileprivate let decrement = PublishSubject<Void>()
    
    func observe(_ view: CounterView) {
        view.increment.subscribe(increment).disposed(by: disposeBag)
        view.decrement.subscribe(decrement).disposed(by: disposeBag)
    }
}
