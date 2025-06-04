//
//  AntipodesMapViewController.swift
//  RefactorTest
//
//  Created by Huy Quang Nguyen on 6/6/25
//

import UIKit
import MapKit
import SnapKit
import Combine

final class AntipodesMapViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: AntipodesMapViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Components
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        return view
    }()
    
    private lazy var primaryLocationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.font = .boldSystemFont(ofSize: 24.0)
        label.backgroundColor = .white
        label.textColor = .red
        label.text = Strings.Map.selectLocation
        return label
    }()
    
    private lazy var antipodeLocationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.font = .boldSystemFont(ofSize: 24.0)
        label.backgroundColor = .white
        label.textColor = .blue
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Initialization
    
    init(viewModel: AntipodesMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        setupGestures()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(primaryLocationLabel)
        primaryLocationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(64)
            make.height.equalTo(32)
        }
        
        view.addSubview(antipodeLocationLabel)
        antipodeLocationLabel.snp.makeConstraints { make in
            make.left.right.height.equalTo(primaryLocationLabel)
            make.top.equalTo(primaryLocationLabel.snp.bottom).offset(4)
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.$primaryLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.updatePrimaryLocation(location)
            }
            .store(in: &cancellables)
        
        viewModel.$antipodeLocation
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.updateAntipodeLocation(location)
            }
            .store(in: &cancellables)
    }
    
    private func setupGestures() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.25
        mapView.addGestureRecognizer(longPress)
    }
    
    // MARK: - State Handling
    
    private func handleState(_ state: MapState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
        case .loading:
            loadingIndicator.startAnimating()
        case .error(let message):
            loadingIndicator.stopAnimating()
            showError(message)
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: Strings.Map.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: Strings.Map.okButton, style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Location Updates
    
    private func updatePrimaryLocation(_ location: LocationAnnotation?) {
        mapView.removeAnnotations(mapView.annotations)
        
        guard let location = location else {
            primaryLocationLabel.text = Strings.Map.selectLocation
            return
        }
        
        primaryLocationLabel.text = location.words
        addAnnotation(location)
    }
    
    private func updateAntipodeLocation(_ location: LocationAnnotation?) {
        guard let location = location else {
            antipodeLocationLabel.text = nil
            return
        }
        
        antipodeLocationLabel.text = location.words
        addAnnotation(location)
        mapView.setCenter(location.coordinate, animated: true)
    }
    
    private func addAnnotation(_ location: LocationAnnotation) {
        let annotation = ColorPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = location.words
        annotation.color = location.color
        mapView.addAnnotation(annotation)
    }
    
    // MARK: - Actions
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard gestureRecognizer.state == .began else { return }
        
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        Task {
            await viewModel.handleLocationSelected(coordinate)
        }
    }
}

// MARK: - MKMapViewDelegate

extension AntipodesMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let colorPointAnnotation = annotation as? ColorPointAnnotation else {
            return nil
        }
        
        let identifier = "ColoredPin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: colorPointAnnotation, reuseIdentifier: identifier)
        } else {
            pinView?.annotation = colorPointAnnotation
        }
        
        pinView?.pinTintColor = colorPointAnnotation.color
        pinView?.canShowCallout = true
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? ColorPointAnnotation else { return }
        
        if annotation.color == .red {
            if let antipodeLocation = viewModel.antipodeLocation {
                mapView.setCenter(antipodeLocation.coordinate, animated: true)
            }
        } else {
            if let primaryLocation = viewModel.primaryLocation {
                mapView.setCenter(primaryLocation.coordinate, animated: true)
            }
        }
    }
} 

class ColorPointAnnotation: MKPointAnnotation {
  var color: UIColor?
}
