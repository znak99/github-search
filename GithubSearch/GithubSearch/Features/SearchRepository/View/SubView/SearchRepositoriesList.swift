//
//  SearchRepositoriesList.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/14.
//

import SwiftUI

struct SearchRepositoriesList: View {
    
    let repos: [GitHubRepository]
    
    var body: some View {
        ScrollView {
            // Search result info
            SearchRepositoriesResultInfo(repos: repos)
            
            ForEach(repos, id: \.id) { repo in
                // Repository Card
                VStack {
                    // header
                    HStack(alignment: .top, spacing: 8) {
                        AsyncImage(url: repo.owner.avatarURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.avatarSize(48).clipShape(Circle())
                            case .failure(_):
                                Image("github").avatarSize(48)
                            @unknown default:
                                Image("github").avatarSize(48)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(repo.owner.login)
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                                .underline()
                            Text(repo.name)
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        VStack(alignment: .leading) {
                            Text("最終更新日 \(repo.updatedAt.formatted())")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            HStack {
                                AppIcon(icon: "code", size: 20)
                                Text(repo.language ?? "Unknown")
                                    .font(.footnote)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                            }
                        }
                    }
                    
                    // body
                    VStack {
                        HStack {
                            HStack {
                                AppIcon(icon: "star", size: 16)
                                Text("\(repo.stargazersCount) Stars")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            HStack {
                                AppIcon(icon: "fork", size: 16)
                                Text("\(repo.forksCount) Forks")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                        }
                        if let description = repo.description {
                            Text(description)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top)
                        }
                        Divider()
                        HStack {
                            Text("詳しく見る")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                            Spacer()
                            AppIcon(icon: "angle-right", size: 24)
                        }
                    }
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.surface)
                }
                .padding(.bottom)
                .onTapGesture {
                    print(repo.name)
                }
            }
        }
    }
}

#Preview {
    SearchRepositoriesList(repos: testRepos)
}

let testRepos: [GitHubRepository] = [
    .init(id: 1,
          name: "Repo1",
          fullName: "user1/Repo1",
          htmlURL: URL(string: "https://github.com/user1/Repo1")!,
          description: "짧은 설명입니다.",
          stargazersCount: 100,
          forksCount: 20,
          language: "Swift",
          updatedAt: Date(timeIntervalSinceNow: -10000),
          owner: .init(login: "user1", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/1")!)),
    
        .init(id: 2,
              name: "Repo2",
              fullName: "user2/Repo2",
              htmlURL: URL(string: "https://github.com/user2/Repo2")!,
              description: """
          여러 줄로 된 설명입니다.
          두 번째 줄입니다.
          """,
              stargazersCount: 250,
              forksCount: 40,
              language: nil,
              updatedAt: Date(timeIntervalSinceNow: -20000),
              owner: .init(login: "user2", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/2")!)),
    
        .init(id: 3,
              name: "Repo3",
              fullName: "user3/Repo3",
              htmlURL: URL(string: "https://github.com/user3/Repo3")!,
              description: nil,
              stargazersCount: 50,
              forksCount: 5,
              language: "Python",
              updatedAt: Date(timeIntervalSinceNow: -30000),
              owner: .init(login: "user3", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/3")!)),
    
        .init(id: 4,
              name: "Repo4",
              fullName: "user4/Repo4",
              htmlURL: URL(string: "https://github.com/user4/Repo4")!,
              description: """
          긴 설명:
          - 기능 A
          - 기능 B
          - 기능 C
          """,
              stargazersCount: 4200,
              forksCount: 300,
              language: "TypeScript",
              updatedAt: Date(timeIntervalSinceNow: -40000),
              owner: .init(login: "user4", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/4")!)),
    
        .init(id: 5,
              name: "Repo5",
              fullName: "user5/Repo5",
              htmlURL: URL(string: "https://github.com/user5/Repo5")!,
              description: "간단한 유틸리티 라이브러리입니다.",
              stargazersCount: 999,
              forksCount: 87,
              language: "Go",
              updatedAt: Date(timeIntervalSinceNow: -50000),
              owner: .init(login: "user5", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/5")!)),
    
        .init(id: 6,
              name: "Repo6",
              fullName: "user6/Repo6",
              htmlURL: URL(string: "https://github.com/user6/Repo6")!,
              description: nil,
              stargazersCount: 12000,
              forksCount: 2100,
              language: "Rust",
              updatedAt: Date(timeIntervalSinceNow: -60000),
              owner: .init(login: "user6", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/6")!)),
    
        .init(id: 7,
              name: "Repo7",
              fullName: "user7/Repo7",
              htmlURL: URL(string: "https://github.com/user7/Repo7")!,
              description: """
          첫 줄 설명
          두 번째 줄 설명
          세 번째 줄 설명
          """,
              stargazersCount: 345,
              forksCount: 12,
              language: nil,
              updatedAt: Date(timeIntervalSinceNow: -70000),
              owner: .init(login: "user7", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/7")!)),
    
        .init(id: 8,
              name: "Repo8",
              fullName: "user8/Repo8",
              htmlURL: URL(string: "https://github.com/user8/Repo8")!,
              description: "Repo8은 머신러닝 관련 실험 저장소입니다.",
              stargazersCount: 2000,
              forksCount: 410,
              language: "Python",
              updatedAt: Date(timeIntervalSinceNow: -80000),
              owner: .init(login: "user8", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/8")!)),
    
        .init(id: 9,
              name: "Repo9",
              fullName: "user9/Repo9",
              htmlURL: URL(string: "https://github.com/user9/Repo9")!,
              description: nil,
              stargazersCount: 14,
              forksCount: 0,
              language: "C",
              updatedAt: Date(timeIntervalSinceNow: -90000),
              owner: .init(login: "user9", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/9")!)),
    
        .init(id: 10,
              name: "Repo10",
              fullName: "user10/Repo10",
              htmlURL: URL(string: "https://github.com/user10/Repo10")!,
              description: """
          Repo10 설명입니다.
          여러 줄 테스트를 포함합니다.
          줄이 세 개 이상일 수도 있습니다.
          """,
              stargazersCount: 777,
              forksCount: 77,
              language: "Java",
              updatedAt: Date(timeIntervalSinceNow: -100000),
              owner: .init(login: "user10", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/10")!)),
    
        .init(id: 11,
              name: "Repo11",
              fullName: "user11/Repo11",
              htmlURL: URL(string: "https://github.com/user11/Repo11")!,
              description: "단순한 설명",
              stargazersCount: 34,
              forksCount: 2,
              language: nil,
              updatedAt: Date(timeIntervalSinceNow: -110000),
              owner: .init(login: "user11", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/11")!)),
    
        .init(id: 12,
              name: "Repo12",
              fullName: "user12/Repo12",
              htmlURL: URL(string: "https://github.com/user12/Repo12")!,
              description: """
          Repo12 긴 설명:
          1. 첫 번째 포인트
          2. 두 번째 포인트
          """,
              stargazersCount: 620,
              forksCount: 99,
              language: "C#",
              updatedAt: Date(timeIntervalSinceNow: -120000),
              owner: .init(login: "user12", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/12")!)),
    
        .init(id: 13,
              name: "Repo13",
              fullName: "user13/Repo13",
              htmlURL: URL(string: "https://github.com/user13/Repo13")!,
              description: nil,
              stargazersCount: 8888,
              forksCount: 1234,
              language: "Ruby",
              updatedAt: Date(timeIntervalSinceNow: -130000),
              owner: .init(login: "user13", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/13")!)),
    
        .init(id: 14,
              name: "Repo14",
              fullName: "user14/Repo14",
              htmlURL: URL(string: "https://github.com/user14/Repo14")!,
              description: "한 줄 설명",
              stargazersCount: 0,
              forksCount: 0,
              language: nil,
              updatedAt: Date(timeIntervalSinceNow: -140000),
              owner: .init(login: "user14", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/14")!)),
    
        .init(id: 15,
              name: "Repo15",
              fullName: "user15/Repo15",
              htmlURL: URL(string: "https://github.com/user15/Repo15")!,
              description: """
          여러 줄
          설명 예시
          줄바꿈 포함
          """,
              stargazersCount: 432,
              forksCount: 54,
              language: "Kotlin",
              updatedAt: Date(timeIntervalSinceNow: -150000),
              owner: .init(login: "user15", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/15")!)),
    
        .init(id: 16,
              name: "Repo16",
              fullName: "user16/Repo16",
              htmlURL: URL(string: "https://github.com/user16/Repo16")!,
              description: nil,
              stargazersCount: 159,
              forksCount: 16,
              language: "Objective-C",
              updatedAt: Date(timeIntervalSinceNow: -160000),
              owner: .init(login: "user16", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/16")!)),
    
        .init(id: 17,
              name: "Repo17",
              fullName: "user17/Repo17",
              htmlURL: URL(string: "https://github.com/user17/Repo17")!,
              description: "Repo17에 대한 간단 설명",
              stargazersCount: 9999,
              forksCount: 500,
              language: "Scala",
              updatedAt: Date(timeIntervalSinceNow: -170000),
              owner: .init(login: "user17", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/17")!)),
    
        .init(id: 18,
              name: "Repo18",
              fullName: "user18/Repo18",
              htmlURL: URL(string: "https://github.com/user18/Repo18")!,
              description: """
          Repo18 긴 설명
          줄바꿈도 포함
          여러 줄 테스트
          """,
              stargazersCount: 58,
              forksCount: 9,
              language: "PHP",
              updatedAt: Date(timeIntervalSinceNow: -180000),
              owner: .init(login: "user18", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/18")!)),
    
        .init(id: 19,
              name: "Repo19",
              fullName: "user19/Repo19",
              htmlURL: URL(string: "https://github.com/user19/Repo19")!,
              description: nil,
              stargazersCount: 2,
              forksCount: 1,
              language: "Perl",
              updatedAt: Date(timeIntervalSinceNow: -190000),
              owner: .init(login: "user19", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/19")!)),
    
        .init(id: 20,
              name: "Repo20",
              fullName: "user20/Repo20",
              htmlURL: URL(string: "https://github.com/user20/Repo20")!,
              description: """
          Repo20 마지막 예시입니다.
          2줄 이상의 설명도 들어갑니다.
          """,
              stargazersCount: 2020,
              forksCount: 220,
              language: "Elixir",
              updatedAt: Date(timeIntervalSinceNow: -200000),
              owner: .init(login: "user20", avatarURL: URL(string: "https://avatars.githubusercontent.com/u/20")!))
]
