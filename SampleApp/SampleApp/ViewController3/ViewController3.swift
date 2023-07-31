//
//  Created by Ceri Hughes on 24/07/2023.
//  Copyright © 2023 Ceri Hughes. All rights reserved.
//

import MadogCore
import UIKit

private let vc3CellReuseIdentifier = "vc3CellReuseIdentifier"

class ViewController3: UIViewController {
    private weak var context: AnySplitUIContext<SampleToken>?
    private let tableView = UITableView()

    init(context: AnySplitUIContext<SampleToken>) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: vc3CellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension ViewController3: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: vc3CellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = indexPath.displayString
        return cell
    }

}

extension ViewController3: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context?.showDetail(token: .createVC4Identifier(stringData: indexPath.displayString))
    }
}

private extension IndexPath {
    var displayString: String {
        "Cell \(row)"
    }
}
