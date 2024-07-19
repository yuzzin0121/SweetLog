//
//  ChatRepository.swift
//  SweetLog
//
//  Created by 조유진 on 7/20/24.
//

import Foundation
import RealmSwift

final class ChatRepository {
    private let realm = try! Realm()
    
    // roomId를 통해 저장된 채팅 내역 중 가장 마지막 날짜에 전송된 채팅날짜 검색
    func fetchChatList(roomId: String) {
        
    }
    
    // 채팅 저장
    func createChat(chat: ChatRealmModel) {
        do {
            try realm.write {
                realm.add(chat)
            }
        } catch {
            print(error)
        }
    }
}
