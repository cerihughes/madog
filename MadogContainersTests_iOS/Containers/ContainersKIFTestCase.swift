//
//  Created by Ceri Hughes on 11/11/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCoreTestUtilities

class ContainersKIFTestCase: MadogKIFTestCase {
    override func beforeEach() {
        super.beforeEach()

        madog.registerDefaultContainers()
    }
}
