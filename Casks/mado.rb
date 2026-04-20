cask "mado" do
  version "0.2.0"
  sha256 "e99ed92208336b94b15d504c9780aa3b1a01dc578f04b96d83c7f6c2ea7677e6"

  url "https://github.com/hummer98/mado/releases/download/v#{version}/mado-v#{version}-macos-arm64.zip"
  name "Mado"
  desc "CLI-first Markdown viewer for macOS"
  homepage "https://github.com/hummer98/mado"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "mado.app"

  # preflight: staged_path に shim を生成してから binary ステンザが symlink する。
  # launcher (Zig) が argv を無視するため、MADO_FILE 環境変数経由で
  # ファイルパスを渡すラッパーを生成する。将来 launcher が argv を直接扱うように
  # なったら binary "#{appdir}/mado.app/Contents/MacOS/launcher" に置き換える。
  # heredoc <<~SHIM は Ruby の文字列補間 (#{...}) が有効。appdir を展開させる。
  preflight do
    shim = staged_path/"mado"
    shim.write <<~SHIM
      #!/usr/bin/env bash
      set -euo pipefail
      if [ -n "${1:-}" ]; then
        if [[ "$1" = /* ]]; then
          MADO_FILE="$1"
        else
          MADO_FILE="$(pwd)/$1"
        fi
        export MADO_FILE
      fi
      exec "#{appdir}/mado.app/Contents/MacOS/launcher"
    SHIM
    shim.chmod 0755
  end

  binary "#{staged_path}/mado"

  caveats <<~EOS
    mado is currently unsigned. If macOS Gatekeeper blocks the first launch, run:
      xattr -dr com.apple.quarantine #{appdir}/mado.app

    Only Apple Silicon (arm64) is supported. Intel Mac support is planned.
  EOS

  zap trash: [
    "~/Library/Application Support/dev.mado.app",
    "~/Library/Caches/dev.mado.app",
    "~/Library/Preferences/dev.mado.app.plist",
    "~/Library/Saved Application State/dev.mado.app.savedState",
  ]
end
