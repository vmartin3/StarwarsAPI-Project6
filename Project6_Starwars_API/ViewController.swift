import UIKit

class ViewController: UIViewController {
    let swapiClient = SwapiClient()
    var detailViewController = DetailViewController()
    
    @IBOutlet weak var starshipLabel: UILabel!
    @IBOutlet weak var vehicleLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            dispatch_once(&Static.token) {
                fetchStarwarsCharacterData()
                fetchStarwarsVehiclesData()
                fetchStarwarsStarshipData()
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    enum FieldTitles: String {
        case Born
        case Home
        case Height
        case Eyes
        case Hair
        case Make
        case Cost
        case Length
        case Class
        case Crew
    }
    
    enum SegueTypes: String {
        case CharacterSegue
        case VehicleSegue
        case StarshipSegue
    }
    
    //Allows for ViewDidLoad Data Fetching code to only run once
    struct Static {
        static var token: dispatch_once_t = 0
    }
    
    func fetchStarwarsCharacterData(){
        swapiClient.fetchStarwarsCharacterData(EntityOptions.Characters) { (result) in
            switch result{
            case .Success(let starwarsDetails): print("Success")
            case .Failure(let error as NSError): print("Error")
            default: break
            }
        }
    }
    
    func fetchStarwarsVehiclesData(){
        swapiClient.fetchStarwarsVehicleData(EntityOptions.Vehicles) { (result) in
            switch result{
            case .Success(let vehicleDetails): print("Success")
            case .Failure(let error as NSError): print("Error")
            default: break
            }
        }
    }
    
    func fetchStarwarsStarshipData(){
        swapiClient.fetchStarwarsStarshipData(EntityOptions.Starships) { (result) in
            switch result{
            case .Success(let starwarsDetails): print("Success")
            case .Failure(let error as NSError): print("Error")
            default: break
            }
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == SegueTypes.CharacterSegue.rawValue) {
            detailViewController = segue.destinationViewController as!DetailViewController
            detailViewController.titleNavigationBarText = characterLabel.text
            detailViewController.setDetailView(EntityOptions.Characters)
            
        } else if (segue.identifier == SegueTypes.VehicleSegue.rawValue||segue.identifier == SegueTypes.StarshipSegue.rawValue){
            detailViewController = segue.destinationViewController as!DetailViewController
            if segue.identifier == SegueTypes.VehicleSegue.rawValue {
                detailViewController.titleNavigationBarText = vehicleLabel.text
                detailViewController.setDetailView(EntityOptions.Vehicles)
            } else {
                detailViewController.titleNavigationBarText = starshipLabel.text
                detailViewController.setDetailView(EntityOptions.Starships)
            }
        }
    }
}

