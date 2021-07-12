import Foundation

public class HearXAppDependecyContainer {
    func makeHomeViewController() -> HomeTableViewController { HomeTableViewController() }
    
    func makeHearingTestViewController() -> HearingTestViewController { HearingTestViewController(hearingTestView: HearingTestView(viewModel: HearingTestViewModel(repository: HearingTestRepository(Client())))) }
}
