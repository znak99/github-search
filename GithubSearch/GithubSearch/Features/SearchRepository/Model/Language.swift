//
//  Language.swift
//  GithubSearch
//
//  Created by seungwoo on 2025/09/15.
//

import Foundation

// GitHub API 検索用の言語フィルタ
enum Language: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    
    case none = "指定なし"
    case c = "C"
    case cPlusPlus = "C++"
    case cSharp = "C#"
    case objectiveC = "Objective-C"
    case java = "Java"
    case kotlin = "Kotlin"
    case swift = "Swift"
    case python = "Python"
    case ruby = "Ruby"
    case php = "PHP"
    case javascript = "JavaScript"
    case typescript = "TypeScript"
    case go = "Go"
    case rust = "Rust"
    case scala = "Scala"
    case dart = "Dart"
    case haskell = "Haskell"
    case elixir = "Elixir"
    case erlang = "Erlang"
    case clojure = "Clojure"
    case fSharp = "F#"
    case r = "R"
    case julia = "Julia"
    case lua = "Lua"
    case shell = "Shell"
    case powershell = "PowerShell"
    case assembly = "Assembly"
    case sql = "SQL"
    case matlab = "MATLAB"
    case perl = "Perl"
}
