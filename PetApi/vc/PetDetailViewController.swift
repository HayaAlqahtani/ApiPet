import UIKit
import SnapKit
import Kingfisher
import UIKit
import SnapKit
import Kingfisher

class PetDetailViewController: UIViewController {
    var pet: Pet?
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.8) // Set container background color lighter
        view.layer.cornerRadius = 10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5 // Increased shadow opacity
        view.layer.shadowOffset = CGSize(width: 0, height: 4) // Increased shadow offset
        view.layer.shadowRadius = 12 // Increased shadow radius
        return view
    }()
    
    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if let pet = pet {
            setupUI(with: pet)
        }
    }
    
    private func setupUI(with pet: Pet) {
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        containerView.addSubview(petImageView)
        petImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        if let imageUrl = URL(string: pet.image) {
            petImageView.kf.setImage(with: imageUrl, options: [.scaleFactor(0.5)])
        }
        
        let nameLabel = createStyledLabel(withText: "Name: \(pet.name)")
        let adoptedLabel = createStyledLabel(withText: "Adopted: \(pet.adopted ? "Yes" : "No")")
        let ageLabel = createStyledLabel(withText: "Age: \(pet.age) years")
        let genderLabel = createStyledLabel(withText: "Gender: \(pet.gender)")
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(adoptedLabel)
        containerView.addSubview(ageLabel)
        containerView.addSubview(genderLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(petImageView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        adoptedLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        ageLabel.snp.makeConstraints { make in
            make.top.equalTo(adoptedLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(ageLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
        }
        
    
        petImageView.layer.cornerRadius = 20
        petImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func createStyledLabel(withText text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Times New Roman", size: 20)
        label.textColor = .black
        return label
    }
}
