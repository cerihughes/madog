//
//  Created by Ceri Hughes on 31/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

private let vc4Identifier = "vc4Identifier"

class ViewController4Provider: ViewControllerProvider {

    // MARK: - ViewControllerProvider

    func createViewController(token: SampleToken, context: AnyContext<SampleToken>) -> UIViewController? {
        guard token.identifier == vc4Identifier, let stringData = token.stringData else { return nil }
        return ViewController4(stringData: stringData)
    }
}

extension SampleToken {

    static func createVC4Identifier(stringData: String) -> SampleToken {
        SampleToken(identifier: vc4Identifier, data: [stringDataKey: stringData])
    }

}
