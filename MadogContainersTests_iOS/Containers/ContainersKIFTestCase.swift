//
//  Created by Ceri Hughes on 11/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogContainers_iOS
import MadogCore
import MadogCoreTestUtilities

class ContainersKIFTestCase: MadogKIFTestCase {
    override func beforeEach() {
        super.beforeEach()

        madog.registerDefaultContainers()
    }
}
