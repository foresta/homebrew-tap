class Ctt < Formula
  desc "Claude Code task management on terminal workspaces (herdr or tmux)"
  homepage "https://github.com/foresta/ctt"
  version "0.2.0"
  license "Apache-2.0"

  # MoonBit only ships an arm64 toolchain for macOS, so there is no Intel build.
  depends_on :macos
  depends_on arch: :arm64

  on_macos do
    on_arm do
      url "https://github.com/foresta/ctt/releases/download/v#{version}/ctt-v#{version}-darwin-arm64.tar.gz"
      sha256 "d3ff301400ea9e710b998e61fb4e6f4f56baf6e9178e3a43d56fc93b078d55fe"
    end
  end

  def install
    bin.install "ctt"
    pkgshare.install ".worktree-link-ignore", "config.toml"
  end

  # Seed the default config files once; never overwrite what the user edited.
  def post_install
    config_dir = "#{Dir.home}/.config/ctt"
    FileUtils.mkdir_p(config_dir)
    [".worktree-link-ignore", "config.toml"].each do |name|
      target = "#{config_dir}/#{name}"
      FileUtils.cp("#{pkgshare}/#{name}", target) unless File.exist?(target)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctt --version")
  end
end
