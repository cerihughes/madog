//
//  Created by Ceri Hughes on 31/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import UIKit

class ViewController4: UIViewController {
    private let stringData: String

    init(stringData: String) {
        self.stringData = stringData
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = LabelView()
    }

    override func viewDidLoad() {
        guard let view = view as? LabelView else { return }
        view.label.text = stringData
    }
}
