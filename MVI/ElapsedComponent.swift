import RxSwift
import RxCocoa

class ElapsedComponent {
    private let disposeBag = DisposeBag()
    private let binder = Binder(ElapsedModel(), ElapsedView(), ElapsedIntent())
    let label = UILabel()
    let reset = UIButton()
    
    init() {
        label.textAlignment = .center
        
        reset.backgroundColor = .black
        reset.setTitleColor(.white, for: .normal)
        reset.setTitle("Reset Elapsed Time", for: .normal)
        
        reset.rx.tap.subscribe(binder.view.reset).disposed(by: disposeBag)
        binder.view.text.bind(to: label.rx.text).disposed(by: disposeBag)
    }
}

struct ElapsedModel: Model {
    private let disposeBag = DisposeBag()
    fileprivate let seconds = BehaviorSubject<Int>(value: 0)
    
    func observe(_ intent: ElapsedIntent) {
        intent.reset.startWith(()).flatMapLatest { _ in
            Observable<Int>.timer(0, period: 1, scheduler: MainScheduler.asyncInstance)
        }.subscribe(seconds).disposed(by: disposeBag)
    }
}

struct ElapsedView: View {
    private let disposeBag = DisposeBag()
    fileprivate let text = BehaviorSubject<String>(value: "")
    fileprivate let reset = PublishSubject<Void>()
    
    func observe(_ model: ElapsedModel) {
        model.seconds.map({ "Seconds elapsed: \($0)" }).subscribe(text).disposed(by: disposeBag)
    }
}

struct ElapsedIntent: Intent {
    private let disposeBag = DisposeBag()
    fileprivate let reset = PublishSubject<Void>()
    
    func observe(_ view: ElapsedView) {
        view.reset.subscribe(reset).disposed(by: disposeBag)
    }
}
