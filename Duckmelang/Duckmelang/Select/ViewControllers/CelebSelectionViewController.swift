//
//  CelebSelectionViewController.swift
//  Duckmelang
//
//  Created by 김연우 on 1/20/25.
//

import UIKit

class CelebSelectionViewController: UIViewController {

    weak var delegate: CelebSelectionDelegate?
    var dismissCompletion: (() -> Void)?
    
    private let celebs: [Celeb]
    private var selectedCeleb: Celeb?
    
    private lazy var celebSelectionView: CelebSelectionView = {
        let view = CelebSelectionView(celebs: celebs, selectedCeleb: selectedCeleb)
        view.delegate = self
        return view
    }()

    init(celebs: [Celeb], selectedCeleb: Celeb?) {
        self.celebs = celebs
        self.selectedCeleb = selectedCeleb
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(celebSelectionView.view)
        addChild(celebSelectionView)
        celebSelectionView.didMove(toParent: self)

        celebSelectionView.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissCompletion?()
    }
}

// MARK: - CelebSelectionDelegate
extension CelebSelectionViewController: CelebSelectionDelegate {
    func didSelectCeleb(_ celeb: Celeb) {
        delegate?.didSelectCeleb(celeb)
        dismiss(animated: true)
    }
}
