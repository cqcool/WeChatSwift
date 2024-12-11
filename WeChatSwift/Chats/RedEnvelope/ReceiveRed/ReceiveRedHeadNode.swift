import AsyncDisplayKit
import SwiftyJSON

class ReceiveRedHeadNode: ASDisplayNode {
     
    private var model: Contact?
    private let timeNode = ASTextNode()
    private let arrowNode = ASImageNode()
    private let avatarNode = ASNetworkImageNode()
    private let nameNode = ASTextNode()
    private let totalMoneyNode = ASTextNode()
    private let countNode = ASTextNode()
    private let countLabelNode = ASTextNode()
    private let bestNode = ASTextNode()
    private let bestLabelNode = ASTextNode()
    
    override init() {
//        self.model = model
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        print(currentYear)

        setCount(count: "0")
        timeNode.attributedText = "\(currentYear)年".addAttributed(font: .systemFont(ofSize: 16), textColor: Colors.DEFAULT_TEXT_YELLOW_COLOR, lineSpacing: 0, wordSpacing: 0)
        arrowNode.image = UIImage(named: "LuckyMoney_ChangeArrow")
        arrowNode.style.preferredSize = CGSizeMake(12, 6)
        setName(name: "")
        setTotalMoney(countReceiveAmount: "0.00")
        countNode.attributedText = "收到红包".addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(white: 0, alpha: 0.6), lineSpacing: 0, wordSpacing: 0)
        
        
        bestNode.attributedText = "手气最佳".addAttributed(font: .systemFont(ofSize: 15), textColor: UIColor(white: 0, alpha: 0.6), lineSpacing: 0, wordSpacing: 0)
        setBestCount(count: "0")
        
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
    }
    private func setBestCount(count: String) {
        bestLabelNode.attributedText = "\(count)".addAttributed(font: .systemFont(ofSize: 30, weight: .regular), textColor: UIColor(white: 0, alpha: 0.6), lineSpacing: 0, wordSpacing: 0)
    }
    private func setCount(count: String) {
        countLabelNode.attributedText = "\(count)".addAttributed(font: .systemFont(ofSize: 30, weight: .regular), textColor: UIColor(white: 0, alpha: 0.6), lineSpacing: 0, wordSpacing: 0)
    }
    private func setName(name: String) {
        nameNode.attributedText = "\(name)共收到".addAttributed(font: .systemFont(ofSize: 17, weight: .regular), textColor: .black, lineSpacing: 0, wordSpacing: 0)
    }
    private func setTotalMoney(countReceiveAmount: String) {
        totalMoneyNode.attributedText = "\(countReceiveAmount)元".unitTextAttribute(fontSize: 41, unitSize: 16, unit: "元", baseline: 0)
    }
    func updateContent(json: JSON) {
        guard let personModel = GlobalManager.manager.personModel else {
            return
        }
        avatarNode.url = GlobalManager.headImageUrl(name: personModel.head)
        avatarNode.defaultImage =  UIImage(named: "login_defaultAvatar")
        setName(name: personModel.nickname ?? "")
        var countReceiveAmount = json["countReceiveAmount"].stringValue
        countReceiveAmount = countReceiveAmount.isEmpty ? "0.00" : countReceiveAmount
        setTotalMoney(countReceiveAmount: countReceiveAmount)
        
        var countReceiveNum = json["countReceiveNum"].stringValue
        countReceiveNum = countReceiveNum.isEmpty ? "0" : countReceiveNum
        setCount(count: countReceiveNum)
        
        var countBestNum = json["countBestNum"].stringValue
        countBestNum = countBestNum.isEmpty ? "0" : countBestNum
        setBestCount(count: countBestNum)
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
         
        let timeVertical = ASStackLayoutSpec.vertical()
        timeVertical.horizontalAlignment = .middle
        timeVertical.spacing = 8
        timeVertical.children = [timeNode, arrowNode]
        timeVertical.style.spacingAfter = 15
        
        let oneHorizontal = ASStackLayoutSpec.horizontal()
        oneHorizontal.horizontalAlignment = .right
        oneHorizontal.style.spacingBefore = 15
        oneHorizontal.children = [timeVertical]
        oneHorizontal.style.preferredSize = CGSizeMake(constrainedSize.max.width, 14)
        
        let countVertical = ASStackLayoutSpec.vertical()
        countVertical.horizontalAlignment = .middle
        countVertical.spacing = 8
        countVertical.children = [countLabelNode, countNode]
        countVertical.style.spacingBefore = 35
//        
        let bestVertical = ASStackLayoutSpec.vertical()
        bestVertical.horizontalAlignment = .middle
        bestVertical.spacing = 8
        bestVertical.children = [bestLabelNode, bestNode]
        bestVertical.style.spacingAfter = 35
        
        let twoHorizontal = ASStackLayoutSpec.horizontal()
        twoHorizontal.style.spacingBefore = 15
        twoHorizontal.children = [countVertical, bestVertical]
        twoHorizontal.justifyContent = .spaceBetween
        twoHorizontal.style.preferredSize = CGSizeMake(constrainedSize.max.width, 100)
        
        avatarNode.style.preferredSize = CGSizeMake(85, 85)
        avatarNode.cornerRadius = 4
        let vertical = ASStackLayoutSpec.vertical()
//        vertical.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height)
//        vertical.justifyContent = .center
        vertical.horizontalAlignment = .middle
        vertical.spacing = 15
//        nameNode.style.spacingBefore = 5
        totalMoneyNode.style.spacingBefore = 17
        vertical.children = [oneHorizontal, avatarNode, nameNode, totalMoneyNode, twoHorizontal]
        return ASInsetLayoutSpec(insets: .zero, child: vertical)
    }
    
}
