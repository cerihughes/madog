//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

class ViewController1: UIViewController {
    private let sharedService: Any
    private let container: AnyContainer<SampleToken>
    private var pushCount = 0

    init(sharedService: Any, container: AnyContainer<SampleToken>) {
        self.sharedService = sharedService
        self.container = container

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ButtonView()
    }

    override func viewDidLoad() {
        guard let view = view as? ButtonView else { return }
        view.button.setTitle("Push", for: .normal)
        view.button.addTarget(self, action: #selector(buttonTapGesture(sender:)), for: .touchUpInside)
    }
}

extension ViewController1 {
    // MARK: - UIButton interactions

    @objc
    private func buttonTapGesture(sender _: UIButton) {
        pushCount += 1
        let token = SampleToken.vc2(String(pushCount))
        container.forwardBack?.navigateForward(token: token, animated: true)
    }
}
