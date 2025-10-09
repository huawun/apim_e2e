#!/bin/bash

echo "🚀 Pushing Azure E2E Workflow Documentation to GitHub..."

# Push to GitHub
git push -u origin main

if [ $? -eq 0 ]; then
    echo "✅ Successfully pushed to GitHub!"
    echo "📖 Repository URL: https://github.com/huawun/apim_e2e"
    echo ""
    echo "📋 Documentation Structure:"
    echo "├── README.md (Main overview)"
    echo "├── complete-e2e-workflow.md (Complete workflow guide)"
    echo "├── practical-microsoft-implementation-updated.md (Daily tasks)"
    echo "├── api-governance-integration.md (API Center & Developer Portal)"
    echo "├── e2e-workflow-diagram.md (Visual diagrams)"
    echo "└── src/ (Sample application code)"
    echo ""
    echo "🎯 Start with: https://github.com/huawun/apim_e2e/blob/main/complete-e2e-workflow.md"
else
    echo "❌ Failed to push to GitHub"
    echo "Make sure you've created the repository at: https://github.com/huawun/apim_e2e"
fi
