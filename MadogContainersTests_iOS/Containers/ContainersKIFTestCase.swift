//
//  Created by Ceri Hughes on 08/12/2019.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import MadogContainers_iOS
import MadogCore
import MadogCoreTestUtilities
import XCTest

class ContainersKIFTestCase: MadogKIFTestCase {

    override func beforeEach() {
        super.beforeEach()

        madog.registerDefaultContainers()
    }
}
