//
//  ActivityDataService.swift
//  DaoFeed
//
//  Created by Jenny Shalai on 2023-01-05.
//

import SwiftUI
import Combine

class ActivityDataService: ObservableObject {
    
    @Published var events: [ActivityEvent] = []
    static let data = ActivityDataService()
    var cancellables = Set<AnyCancellable>() // to store publishers

    private init() {
        getEventsTestData()
    }
    
    func getEventsWithCombine() {
        guard let url = URL(string: "add JSON url here") else { return }
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            //.subscribe(on: DispatchQueue.global(qos: .background))
//            .receive(on: DispatchQueue.main)
//            .tryMap { (data, responce) -> Data in
//                guard let response = responce as? HTTPURLResponse,
//                      responce.statusCode >= 200 && responce.statusCode < 300 else {
//                    throw URLError(.badServerResponse)
//                }
//                return data
//            }
//            .decode(type: [ActivityEvent].self, decoder: JSONDecoder())
//            .sink { (complition) in
//                print("complition is : \(complition)")
//            } receiveValue: { [weak self] (returnedEvent) in
//                self?.events = returnedEvent
//            }
//            .store(in: &cancellables)

    }
    
    
    func getEventsTestData() {
        let eventVoteActiveVote = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "kris.eth"),
            date: Date(),
            type: .vote,
            status: .activeVote,
            content: ActivityViewContent(
                title: "UIP23 - DAO Operations Buget",
                subtitle: "2 days left to vote via Snapshot",
                warningSubtitle: nil),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["239", "105%", ""])
        
        let eventDiscussionDiscussion = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: "uniman_ETH1f99999999999"),
            date: Date(),
            type: .discussion,
            status: .discussion,
            content: ActivityViewContent(
                title: "Deploy Uniswap V3 to Boba Layer 2 Network",
                subtitle: "2 days left to vote vs snapshot",
                warningSubtitle: nil),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["239", "342", "12"])
        
        let eventVoteQueued = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .queued,
            content: ActivityViewContent(
                title: "UIP19 - DAO Operations",
                subtitle: "Snapshot voting ended 3 days ago",
                warningSubtitle: "Waiting for execution"),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["132", "124%", ""])
    
        let eventVoteExecuted = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .executed,
            content: ActivityViewContent(
                title: "UIP18 - Fee mechanism",
                subtitle: "Executed 1 day ago",
                warningSubtitle: nil),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["593", "121%", "voted"])
        
        let eventVoteFailed = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .failed,
            content: ActivityViewContent(
                title: "UIP17 - Updated terms & conditions",
                subtitle: "Failed 1 day ago: Quorum not reached",
                warningSubtitle: nil),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["22", "54%", "voted"])

        
        events.append(eventVoteActiveVote)
        events.append(eventDiscussionDiscussion)
        events.append(eventVoteQueued)
        events.append(eventVoteExecuted)
        events.append(eventVoteFailed)
        events.append(eventVoteActiveVote)
        events.append(eventDiscussionDiscussion)
        events.append(eventVoteQueued)
        events.append(eventVoteExecuted)
        events.append(eventVoteFailed)
    }
    
    
    func refreshedEvents() {
        events.removeAll()
        let eventVoteFailed = ActivityEvent(
            user: User(
                address: "0x46F228b5eFD19Be20952152c549ee478Bf1bf36b",
                image: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
                name: nil),
            date: Date(),
            type: .vote,
            status: .failed,
            content: ActivityViewContent(
                title: "UIP17 - Updated terms & conditions",
                subtitle: "Failed 1 day ago: Quorum not reached",
                warningSubtitle: nil),
            daoImage: "https://cdn-icons-png.flaticon.com/512/17/17004.png?w=1060&t=st=1672407609~exp=1672408209~hmac=7cb92bf848bb316a8955c5f510ce50f48c6a9484fb3641fa70060c212c2a8e39",
            meta: ["22", "54%", "voted"])
        events.append(eventVoteFailed)
    }
    
    
}
