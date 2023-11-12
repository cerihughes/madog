//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

class ViewController2: UIViewController {
    private let sharedService: Any
    private let stringData: String
    private let container: AnyContainer<SampleToken>

    init(sharedService: Any, stringData: String, container: AnyContainer<SampleToken>) {
        self.sharedService = sharedService
        self.stringData = stringData
        self.container = container

        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = LabelView()
    }

    override func viewDidLoad() {
        guard let view = view as? LabelView else { return }
        view.label.text = stringData

        // Maybe do something with the shared service at this point?
    }

    override func viewDidAppear(_: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.container.forwardBack?.navigateBack(animated: true)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
