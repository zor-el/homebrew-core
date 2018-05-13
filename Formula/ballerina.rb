class Ballerina < Formula
  desc "Complete Ballerina Tools package (runtime + visual composer)"
  homepage "https://ballerinalang.org/"
  url "https://product-dist.ballerina.io/downloads/0.970.1/ballerina-platform-0.970.1.zip"
  sha256 "cc54f6de6db7df86e9c28c54981fbbd5352a5806e0fcc29892326c846373ab33"

  bottle :unneeded

  depends_on :java

  def install
    # Remove Windows files
    rm "bin/ballerina.bat"
    rm "bin/composer.bat"

    # Translate ballerina script
    inreplace ["bin/ballerina"], /^BALLERINA_HOME=.*$/, "BALLERINA_HOME=#{libexec}"
    # Translate composer script
    inreplace ["bin/composer"], /^(\[ \-z "\$BAL_COMPOSER_HOME" \] && BAL_COMPOSER_HOME)=.*$/, "\\1=#{libexec}"

    # Install and symlink (Note: execuables already come properly chmod'ed)
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/ballerina"
    bin.install_symlink libexec/"bin/composer"
  end

  test do
    (testpath/"helloWorld.bal").write <<~EOS
      import ballerina.io;
      function main (string[] args) {
        io:println("Hello, World!");
      }
    EOS
    output = shell_output("#{bin}/ballerina run helloWorld.bal")
    assert_equal "Hello, World!", output.chomp
  end
end
