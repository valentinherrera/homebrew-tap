# Homebrew cask for TokenMaccer. Template: scripts/release.sh fills in 1.0.3 and 14747e1fa635e8504cd6ece650b49c7bfbb7374b9e110cf2fc53e655861dda92 (sha256 of
# TokenMaccer-VERSION.dmg) and writes dist/tokenmaccer.rb, which goes to a tap repository as Casks/tokenmaccer.rb
# (tap: github.com/valentinherrera/homebrew-tap).
cask "tokenmaccer" do
  version "1.0.3"
  sha256 "14747e1fa635e8504cd6ece650b49c7bfbb7374b9e110cf2fc53e655861dda92"

  # the versioned file of the release, so the checksum stays valid after the next release; the download page links
  # the same DMG under the stable name releases/latest/download/TokenMaccer.dmg
  url "https://github.com/valentinherrera/tokenmaccer/releases/download/v#{version}/TokenMaccer-#{version}.dmg"
  name "TokenMaccer"
  desc "Claude Code token usage in a desktop widget and the menu bar"
  homepage "https://github.com/valentinherrera/tokenmaccer"

  livecheck do
    url :url
    strategy :github_latest
  end

  # Sparkle updates the app itself
  auto_updates true
  depends_on macos: :sequoia

  app "TokenMaccer.app"

  # stop the background collector (SMAppService agent) before the app goes away
  uninstall quit:   "io.github.valentinherrera.tokenmaccer",
            script: {
              executable: "#{appdir}/TokenMaccer.app/Contents/MacOS/TokenMaccer",
              args:       ["--unregister"],
            }

  # --remove-data leaves the leaderboard first (if joined), then deletes Application Support/TokenMaccer; it removes
  # nothing while leaving fails, so that folder (it holds the leaderboard state) is not in the trash list.
  # `brew install` tested 2 Nov 2026 (into a separate --appdir). `brew uninstall` and `--zap` not yet run on a Mac
  # without another TokenMaccer install: both act on the bundle id, so on a maintainer's Mac they hit the real app.
  zap script: {
        executable: "#{appdir}/TokenMaccer.app/Contents/MacOS/TokenMaccer",
        args:       ["--unregister", "--remove-data"],
      },
      trash:  [
        "~/Library/Group Containers/3KM85F22L8.tokenmaccer",
        "~/Library/Preferences/io.github.valentinherrera.tokenmaccer.plist",
      ]
end
