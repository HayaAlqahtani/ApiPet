//
//  ViewController.swift
//  PetApi
//
//  Created by Haya Alqahtani on 04/03/2024.
//import UIKit
import SnapKit
import Alamofire
import Eureka
import  UIKit

class PetViewController: UITableViewController, UISearchBarDelegate {
    var pets: [Pet] = []
    var filteredPets: [Pet] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        fetchPetsData()
        setUpNav()
        setupNavigationBar()
        setupSearchBar()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let pet = filteredPets[indexPath.row]
        cell.textLabel?.attributedText = attributedPetName(pet.name)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPet = filteredPets[indexPath.row]
        showPetDetails(for: selectedPet)
    }
    
    func fetchPetsData() {
        NetworkManager.shared.fetchPets { fetchedPets in
            DispatchQueue.main.async {
                self.pets = fetchedPets ?? []
                self.filteredPets = self.pets
                self.tableView.reloadData()
            }
        }
    }
    
    func showPetDetails(for pet: Pet) {
        let petDetailsVC = PetDetailViewController()
        petDetailsVC.pet = pet
        navigationController?.pushViewController(petDetailsVC, animated: true)
    }
    
    func setUpNav(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPetTapped))
    }
    
    @objc private func addPetTapped() {
        let navigationController = UINavigationController(rootViewController: AddPetViewController())
        present(navigationController, animated: true, completion: nil)
    }
    
    private func attributedPetName(_ name: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: name)
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Pets By Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension PetViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredPets = pets.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredPets = pets
        }
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let petToDelete = pets[indexPath.row]
            NetworkManager.shared.deletePet(petID: petToDelete.id!) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        self?.pets.remove(at: indexPath.row)

                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        print("error")
                    }
                }
            }
        }
    }
}
