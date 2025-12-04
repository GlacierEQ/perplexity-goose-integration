#!/bin/bash

# Perplexity-Goose Integration Installer
# One-command installation for the complete autonomous AI stack

set -e

echo "============================================================"
echo "🚀 PERPLEXITY-GOOSE INTEGRATION INSTALLER"
echo "============================================================"
echo ""
echo "This will install:"
echo "  ✅ Perplexity Enhancement MCP"
echo "  ✅ Goose with MCP integration"
echo "  ✅ Goose-Evolve tracking"
echo ""
echo "Installation directory: ~/perplexity-goose"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled."
    exit 1
fi

# Create installation directory
mkdir -p ~/perplexity-goose
cd ~/perplexity-goose

echo ""
echo "============================================================"
echo "📦 Step 1/3: Installing Perplexity Enhancement MCP"
echo "============================================================"

# Check Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js not found. Please install Node.js 18+ first."
    echo "   Visit: https://nodejs.org"
    exit 1
fi

echo "✅ Node.js found: $(node --version)"

# Clone and build MCP server
if [ ! -d "perplexity-enhancement-mcp" ]; then
    git clone https://github.com/GlacierEQ/perplexity-enhancement-mcp.git
fi
cd perplexity-enhancement-mcp
npm install
npm run build
echo "✅ Perplexity Enhancement MCP installed"
cd ..

echo ""
echo "============================================================"
echo "🦆 Step 2/3: Installing Goose with MCP Integration"
echo "============================================================"

# Check Rust
if ! command -v cargo &> /dev/null; then
    echo "❌ Rust not found. Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

echo "✅ Rust found: $(rustc --version)"

# Clone Goose (feature branch)
if [ ! -d "goose" ]; then
    git clone https://github.com/GlacierEQ/goose.git
fi
cd goose
git checkout feature/perplexity-enhancement-integration 2>/dev/null || echo "Already on feature branch"
cargo build --release
echo "✅ Goose installed"
cd ..

echo ""
echo "============================================================"
echo "📈 Step 3/3: Installing Goose-Evolve"
echo "============================================================"

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 not found. Please install Python 3.9+ first."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Clone and install Goose-Evolve
if [ ! -d "goose-evolve" ]; then
    git clone https://github.com/GlacierEQ/goose-evolve.git
fi
cd goose-evolve
pip3 install -r requirements.txt
pip3 install -e .
echo "✅ Goose-Evolve installed"
cd ..

echo ""
echo "============================================================"
echo "⚙️  Configuration"
echo "============================================================"

# Create MCP config directory
mkdir -p ~/.config/goose

# Check if GitHub token is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo ""
    echo "⚠️  GitHub token not found in environment."
    echo "   Please create a GitHub token at:"
    echo "   https://github.com/settings/tokens"
    echo ""
    read -p "   Enter your GitHub token: " GITHUB_TOKEN
    echo ""
fi

# Create MCP config
MCP_PATH="$(pwd)/perplexity-enhancement-mcp/build/index.js"
cat > ~/.config/goose/mcp.yaml << EOF
servers:
  perplexity-enhancement:
    command: node
    args:
      - "$MCP_PATH"
    env:
      GITHUB_TOKEN: "$GITHUB_TOKEN"
EOF

echo "✅ MCP configuration created at ~/.config/goose/mcp.yaml"

# Add to PATH
GOOSE_BIN="$(pwd)/goose/target/release"
if ! grep -q "perplexity-goose" ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo "# Perplexity-Goose Integration" >> ~/.bashrc
    echo "export PATH=\"$GOOSE_BIN:\$PATH\"" >> ~/.bashrc
    echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.bashrc
fi

if ! grep -q "perplexity-goose" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# Perplexity-Goose Integration" >> ~/.zshrc
    echo "export PATH=\"$GOOSE_BIN:\$PATH\"" >> ~/.zshrc
    echo "export GITHUB_TOKEN=\"$GITHUB_TOKEN\"" >> ~/.zshrc
fi

echo "✅ PATH updated (restart your terminal or run: source ~/.bashrc)"

echo ""
echo "============================================================"
echo "✅ INSTALLATION COMPLETE!"
echo "============================================================"
echo ""
echo "What you can do now:"
echo ""
echo "1. 🚀 Test Goose:"
echo "   goose run 'Hello world'"
echo ""
echo "2. 🧠 Generate legal motion:"
echo "   goose run 'Generate TRO motion for Hawaii Family Court'"
echo ""
echo "3. 📊 Check evolution:"
echo "   python3 -c 'from evolution.mcp_enhancement_tracker import MCPEnhancementTracker; print(MCPEnhancementTracker().generate_report())'"
echo ""
echo "4. 📈 Deploy to repos:"
echo "   goose run 'Deploy legal-doc-gundam to my best repos'"
echo ""
echo "Documentation: https://github.com/GlacierEQ/perplexity-goose-integration"
echo ""
echo "Installed to: ~/perplexity-goose/"
echo ""
echo "============================================================"
echo "🎉 You now have nuclear-level AI automation!"
echo "============================================================"
