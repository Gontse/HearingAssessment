import UIKit

final class TitleDescriptionTableViewCell: UITableViewCell, TableviewCellReusable {
    // MARK: Private variables
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var descriptionLabel: UILabel!
    typealias Configuration = (configDTO: TitleDescriptionCellConfigurationDTO, styleDTO: TitleDescriptionCellStyleDTO?)
    
    // MARK: Configuration Data Tranfer Object
    struct TitleDescriptionCellConfigurationDTO {
        let title: String
        let description: String
    }
    
    // MARK: Style Data Tranfer Object
    struct TitleDescriptionCellStyleDTO {
        let titleLabelTitleFont: UIFont
        let titleLabelTitleColor: UIColor
        let descriptionLabelFont: UIFont
        let descriptionLabelColor: UIColor
    }
    
    // MARK: - Exposed/Internal functions
    
    func configure(_ configuration: Configuration) {
        titleLabel?.text = configuration.configDTO.title
        descriptionLabel.text = configuration.configDTO.description
        if let styleConfiguration = configuration.styleDTO { styleCell(styleConfiguration) } // set styling if exists
    }
    
    // MARK: - Private/Helper functions
    
    private func styleCell(_ style: TitleDescriptionCellStyleDTO) {
        titleLabel.font = style.titleLabelTitleFont
        titleLabel.textColor = style.titleLabelTitleColor
        descriptionLabel.font = style.descriptionLabelFont
        descriptionLabel.textColor = style.descriptionLabelColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
